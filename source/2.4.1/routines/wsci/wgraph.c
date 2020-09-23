/*******************************************
 * Original source : GNUPLOT - win/wgraph.c
 * modified for Scilab 
 *******************************************
 *
 * Copyright (C) 1992   Maurice Castro, Russell Lang
 *
 * Permission to use, copy, and distribute this software and its
 * documentation for any purpose with or without fee is hereby granted, 
 * provided that the above copyright notice appear in all copies and 
 * that both that copyright notice and this permission notice appear 
 * in supporting documentation.
 *
 * Permission to modify the software is granted, but not the right to
 * distribute the modified code.  Modifications are to be distributed 
 * as patches to released version.
 *  
 * This software is provided "as is" without express or implied warranty.
 * 
 * AUTHORS (GNUPLOT) 
 *   Maurice Castro
 *   Russell Lang
 *
 * Modifications for Scilab 
 *   Jean-Philipe Chancelier 
 *   Bugs and mail : Scilab@inria.fr 
 */
#ifndef STRICT
#define STRICT
#endif
#include <windows.h>
#include <windowsx.h>

#ifndef __GNUC__
#include <commdlg.h>
#include <shellapi.h>
#endif

#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>

#include "wgnuplib.h"
#include "wresource.h"
#include "wcommon.h"

extern void SetGHdc  _PARAMS((HDC lhdc, int width, int height)); 
static void scig_replay_hdc(char c, integer win_num,HDC hdc,int width,int height,
			    int scale);
extern TW textwin;

EXPORT LRESULT CALLBACK  WndGraphProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam);
void ReadGraphIni(struct BCG *ScilabGC);
void WriteGraphIni(struct BCG *ScilabGC);

/******************************************
 * delete a graphic window
 ******************************************/

int C2F(deletewin)(integer *number) 
{
  /* destroying recorded graphic commands */
  scig_erase(*number);
  /* delete the windows and resources */
  DeleteSGWin(*number);
  return(0);
}

/******************************************
 * Printing and redrawing graphic window 
 ******************************************/

EXPORT void WINAPI 
GraphPrint(struct BCG *ScilabGC)
{
  if ( ScilabGC->CWindow && IsWindow( ScilabGC->CWindow))
    SendMessage( ScilabGC->CWindow,WM_COMMAND,M_PRINT,0L);
}

EXPORT void WINAPI 
GraphRedraw(struct BCG *ScilabGC)
{
  if ( ScilabGC->CWindow && IsWindow( ScilabGC->CWindow))
    SendMessage( ScilabGC->CWindow,WM_COMMAND,M_REBUILDTOOLS,0L);
}

/****************************************
 * copy graph window to clipboard 
 * with the EnHmetafile format (win95/winNT)
 ****************************************/

void NewCopyClip(struct BCG *ScilabGC)
{
  LPGW lpgw;
  RECT rect;
  HANDLE hmf;
  HWND hwnd;
  HDC hdc;
  lpgw = ScilabGC->lpgw;
  hwnd =  ScilabGC->CWindow;
  /* view the window */
  if (IsIconic(hwnd))  ShowWindow(hwnd, SW_SHOWNORMAL);
  BringWindowToTop(hwnd);
  UpdateWindow(hwnd);
  GetClientRect(hwnd, &rect);
  hdc = CreateEnhMetaFile(NULL,NULL,NULL,NULL);
  SetMapMode(hdc, MM_TEXT);
  SetTextAlign(hdc, TA_LEFT|TA_BOTTOM);
  SetWindowExtEx(hdc, rect.right -rect.left ,
		 rect.bottom -rect.top , (LPSIZE)NULL);
  /** 
  SetWindowExtEx(hdc, rect.right, rect.bottom, (LPSIZE)NULL); 
  **/
  /** fix hdc in the scilab driver **/
  Rectangle (hdc, 0, 0, rect.right - rect.left,rect.bottom - rect.top);
  scig_replay_hdc('C',ScilabGC->CurWindow,hdc,
		  rect.right - rect.left,rect.bottom - rect.top,1);
  hmf = CloseEnhMetaFile(hdc);
  OpenClipboard(hwnd);
  EmptyClipboard();
  SetClipboardData(CF_ENHMETAFILE,hmf);
  CloseClipboard();
  return;
}

/****************************************
 * copy graph window to clipboard 
 * copy a CF_METAFILEPICT and a CF_BITMAP to the clipboard 
 ****************************************/

void CopyClip(struct BCG *ScilabGC)
{
  LPGW lpgw;
  HDC mem;
  RECT rect;
  HBITMAP bitmap;
  HANDLE hmf;
  HGLOBAL hGMem;
  /** XXXX  GLOBALHANDLE hGMem;**/
  LPMETAFILEPICT lpMFP;
  HWND hwnd;
  HDC hdc;
  lpgw = ScilabGC->lpgw;
  hwnd =  ScilabGC->CWindow;
  /* view the window */
  if (IsIconic(hwnd))  ShowWindow(hwnd, SW_SHOWNORMAL);
  BringWindowToTop(hwnd);
  UpdateWindow(hwnd);
  /* get the context */
  hdc = GetDC(hwnd);
  GetClientRect(hwnd, &rect);
  /* make a bitmap and copy it there */
  mem = CreateCompatibleDC(hdc);
  bitmap = CreateCompatibleBitmap(hdc, rect.right - rect.left,
				  rect.bottom - rect.top);
  if (bitmap) 
    {
      /* there is enough memory and the bitmaps OK */
      SelectBitmap(mem, bitmap);
      BitBlt(mem,0,0,rect.right - rect.left, 
	     rect.bottom - rect.top, hdc, rect.left,
	     rect.top, SRCCOPY);
    }
  else 
    {
      MessageBeep(MB_ICONHAND);
      MessageBox(hwnd, "Insufficient Memory to Copy Clipboard", 
		 lpgw->Title, MB_ICONHAND | MB_OK);
    }
  DeleteDC(mem);
  ReleaseDC(hwnd, hdc);
  hdc = CreateMetaFile((LPSTR)NULL);

  /** SetMapMode(hdc, MM_ANISOTROPIC); **/

  SetMapMode(hdc, MM_TEXT);
  SetTextAlign(hdc, TA_LEFT|TA_BOTTOM);
  SetWindowExtEx(hdc, rect.right -rect.left ,
		 rect.bottom -rect.top , (LPSIZE)NULL);
  /** fix hdc in the scilab driver **/
  scig_replay_hdc('C',ScilabGC->CurWindow, hdc,
		  rect.right - rect.left,rect.bottom - rect.top,1);
  hmf = CloseMetaFile(hdc);
  hGMem = GlobalAlloc(GMEM_MOVEABLE, (DWORD)sizeof(METAFILEPICT));
  lpMFP = (LPMETAFILEPICT) GlobalLock(hGMem);
  /* in MM_ANISOTROPIC, xExt & yExt give suggested size in 0.01mm units */
  hdc = GetDC(hwnd);
  lpMFP->mm = MM_ANISOTROPIC;
  lpMFP->xExt =MulDiv(rect.right-rect.left, 2540, GetDeviceCaps(hdc, LOGPIXELSX));
  lpMFP->yExt =MulDiv(rect.bottom-rect.top, 2540, GetDeviceCaps(hdc, LOGPIXELSX));
  lpMFP->hMF = hmf;
  ReleaseDC(hwnd, hdc);
  GlobalUnlock(hGMem);
  OpenClipboard(hwnd);
  EmptyClipboard();
  SetClipboardData(CF_METAFILEPICT,hGMem);
  SetClipboardData(CF_BITMAP, bitmap);
  CloseClipboard();
  return;
}

/****************************************
 * copy graph window to printer         *
 ****************************************/

/* PageGDICalls : only for testing */
#ifdef PageTest 
static void PageGDICalls (HDC hdcPrn, int cxPage, int cyPage)
{
  static char szTextStr[] = "Hello, Printer!" ;
  SetMapMode       (hdcPrn, MM_ISOTROPIC) ;
  SetWindowExtEx   (hdcPrn, 1000, 1000, NULL) ;
  SetViewportExtEx (hdcPrn, cxPage / 2, -cyPage / 2, NULL) ;
  SetViewportOrgEx (hdcPrn, cxPage / 2,  cyPage / 2, NULL) ;
  Ellipse (hdcPrn, -500, 500, 500, -500) ;
  SetTextAlign (hdcPrn, TA_LEFT|TA_BOTTOM);
  TextOut (hdcPrn, 0, 0, szTextStr, sizeof (szTextStr) - 1) ;
}
#endif 


int CopyPrint(struct BCG *ScilabGC)
{
  int            xPage, yPage ;
  static DOCINFO di     = { sizeof (DOCINFO), "Scilab: Printing", NULL } ;
  BOOL           bError = FALSE ;
  HDC printer;
  LPGW lpgw;
  ABORTPROC lpfnAbortProc;
  DLGPROC lpfnPrintDlgProc;
  static PRINTDLG pd;
  HWND hwnd;
  RECT rect;
  PRINT pr;
  lpgw = ScilabGC->lpgw;
  hwnd =  ScilabGC->CWindow;
#ifdef __GNUC__
  /** for cygwin and mingwin **/
  /** XXXXX : Bug in cygwin : sizeof(PRINTDLG) gives something wrong (68) **/
  memset(&pd, 0, 66);
  pd.lStructSize         = 66 ;
#else
  memset(&pd, 0, sizeof(PRINTDLG));
  pd.lStructSize         = sizeof (PRINTDLG) ;
#endif 
  pd.hwndOwner           = hwnd ;
  pd.hDevMode            = NULL ;
  pd.hDevNames           = NULL ;
  pd.hDC                 = NULL ;
  pd.Flags               = PD_ALLPAGES | PD_COLLATE | PD_RETURNDC ;
  pd.nFromPage           = 0 ;
  pd.nToPage             = 0 ;
  pd.nMinPage            = 0 ;
  pd.nMaxPage            = 0 ;
  pd.nCopies             = 1 ;
  pd.hInstance           = NULL ;
  pd.lCustData           = 0L ;
  pd.lpfnPrintHook       = NULL ;
  pd.lpfnSetupHook       = NULL ;
  pd.lpPrintTemplateName = NULL ;
  pd.lpSetupTemplateName = NULL ;
  pd.hPrintTemplate      = NULL ;
  pd.hSetupTemplate      = NULL ;

  if (PrintDlg(&pd)==FALSE)
    {
      /** int i;
      i=CommDlgExtendedError();
      sciprint("Printer Menu error code %d\r\n",i);
      **/
      return TRUE;
    }
  printer = pd.hDC;
  if (NULL == printer)
    {
      sciprint("Can't print \r\n");
      return TRUE;	/* abort */
    }

  pr.hdcPrn = printer;
  xPage = GetDeviceCaps (pr.hdcPrn, HORZRES) ;
  yPage = GetDeviceCaps (pr.hdcPrn, VERTRES) ;

  GetClientRect(hwnd, &rect);
  SetLastError(0);
  /** Warning : 
    inside PrintDlgProg we use GetWindowLong(GetParent(hdlg), 4);
    to get the parent window of the print dialog box 
    GetParent(hdlg) returns ScilabGC->hWndParent and not hwnd = ScilabGC->CWindow 
    as we would expect ? 
    So we call SetwindowLong with ScilabGC->hWndParent also 
    **/
  if ( SetWindowLong(hwnd, 4, (LONG)((LPPRINT)&pr)) == 0 
       && GetLastError() != 0) 
    {
      sciprint("Can't print : Error in SetWindowLong");
      return TRUE;
    }
  if ( SetWindowLong(ScilabGC->hWndParent, 4, (LONG)((LPPRINT)&pr)) == 0 
       && GetLastError() != 0) 
    {
      sciprint("Can't print : Error in SetWindowLong");
      return TRUE;
    }
  PrintRegister((LPPRINT)&pr);
  {
    /**** Shoud be inserted ? to select the part of the page we want 
    RECT lprect;
    PrintSize( printer, hwnd, &lprect);
    *****/
  }
  EnableWindow(hwnd,FALSE);
  pr.bUserAbort = FALSE;
  lpfnPrintDlgProc = (DLGPROC) MyGetProcAddress("PrintDlgProc",PrintDlgProc);
  lpfnAbortProc = (ABORTPROC) MyGetProcAddress("PrintAbortProc",PrintAbortProc);
  pr.hDlgPrint = CreateDialogParam(hdllInstance,"PrintDlgBox",hwnd,
				   lpfnPrintDlgProc,(LPARAM)lpgw->Title);
  SetAbortProc (pr.hdcPrn, lpfnAbortProc) ;
  
  if (StartDoc (pr.hdcPrn, &di) > 0)
    {
      if (StartPage (pr.hdcPrn) > 0)
	{
	  int scalef=1;
	  /** test : PageGDICalls (pr.hdcPrn, xPage, yPage) ; **/
	  /** 
	    SetMapMode(pr.hdcPrn, MM_ANISOTROPIC);
	    SetWindowExtEx(pr.hdcPrn, rect.right-rect.left, 
	    rect.bottom-rect.right, (LPSIZE)NULL); 
	    **/
	  SetMapMode(pr.hdcPrn, MM_TEXT);
	  SetBkMode(pr.hdcPrn,TRANSPARENT); 
	  SetTextAlign(pr.hdcPrn, TA_LEFT|TA_BOTTOM);
	  /** changes the origin 
	    we shoul duse this to get into account the margins 
	    that can be specified with the print dialog 
	    But I don't know how to get back the values ???
	    Rectangle(pr.hdcPrn,0,0,xPage,yPage);
	    SetViewportOrgEx(pr.hdcPrn,xPage/8,yPage/8,NULL);
	    Rectangle(pr.hdcPrn,0,0,xPage -xPage/4,yPage-yPage/4);
	    **/
	  /**
	    put the apropriate scale factor according to printer 
	    resolution and redraw with the printer as hdc 
	  **/
	  scalef = (int) (10.0 * ((double) xPage*yPage)/(6800.0*4725.0));
	  scig_replay_hdc('P',ScilabGC->CurWindow, printer,
			  xPage,yPage,scalef);
	  if (EndPage (pr.hdcPrn) > 0)
	    EndDoc (pr.hdcPrn) ;
	  else
	    bError = TRUE ;
	}
    }
  else
    bError = TRUE ;
  if (! pr.bUserAbort)
    {
      EnableWindow (hwnd, TRUE) ;
      DestroyWindow (pr.hDlgPrint) ;
    }
  DeleteDC(printer);
  SetWindowLong(hwnd, 4, (LONG)(0L));
  SetWindowLong(ScilabGC->hWndParent,4, (LONG)(0L));
  PrintUnregister((LPPRINT)&pr);
  return bError || pr.bUserAbort ;
}

/****************************************
 *  INI file stuff 
 *  XXXX : should be upgraded for win95/winnt 
 *  using the registry ? 
 ****************************************/

void WriteGraphIni(struct BCG *ScilabGC)
{
  RECT rect;
  LPSTR file = ScilabGC->lpgw->IniFile;
  LPSTR section = ScilabGC->lpgw->IniSection;
  char profile[80];
  if ((file == (LPSTR)NULL) || (section == (LPSTR)NULL))
    return;
  if (IsIconic( ScilabGC->CWindow))
    ShowWindow( ScilabGC->CWindow, SW_SHOWNORMAL);
  GetWindowRect( ScilabGC->CWindow,&rect);
  wsprintf(profile, "%d %d", rect.left, rect.top);
  WritePrivateProfileString(section, "GraphOrigin", profile, file);
  wsprintf(profile, "%d %d", rect.right-rect.left, rect.bottom-rect.top);
  WritePrivateProfileString(section, "GraphSize", profile, file);
  return;
}

void ReadGraphIni(struct BCG *ScilabGC)
{
  LPSTR file = ScilabGC->lpgw->IniFile;
  LPSTR section = ScilabGC->lpgw->IniSection;
  char profile[81];
  LPSTR p;
  BOOL bOKINI;
  bOKINI = (file != (LPSTR)NULL) && (section != (LPSTR)NULL);
  if (!bOKINI) profile[0] = '\0';
  if (bOKINI)
    GetPrivateProfileString(section, "GraphOrigin", "", profile, 80, file);
  if ( (p = GetLInt(profile, &ScilabGC->lpgw->Origin.x)) == NULL)
    ScilabGC->lpgw->Origin.x = CW_USEDEFAULT;
  if ( (p = GetLInt(p, &ScilabGC->lpgw->Origin.y)) == NULL)
    ScilabGC->lpgw->Origin.y = CW_USEDEFAULT;
  if (bOKINI)
    GetPrivateProfileString(section, "GraphSize", "", profile, 80, file);
  if ( (p = GetLInt(profile, &ScilabGC->lpgw->Size.x)) == NULL)
    ScilabGC->lpgw->Size.x = CW_USEDEFAULT;
  if ( (p = GetLInt(p, &ScilabGC->lpgw->Size.y)) == NULL)
    ScilabGC->lpgw->Size.y = CW_USEDEFAULT;
}

/****************************************************
 * Debug Function 
 ****************************************************/

#define MAXPRINTF 1024

extern void DebugGW(char *fmt, ...)
{
#ifdef DEBUG 
  int i,count;
  char buf[MAXPRINTF];
  va_list args;
  va_start(args,fmt);
  count = vsprintf(buf,fmt,args);
  MessageBox(textwin.hWndParent,(LPSTR) buf,
	     textwin.Title,MB_ICONEXCLAMATION);
  va_end(args);
#endif
}


/***********************************************
 * we keep track of the last MaxCB XXBUTTONDOWN 
 * events while we are in GraphicWindowProc 
 ***********************************************/

typedef struct but {
  int win,x,y,ibutton;
} But;

#define MaxCB 50
static But ClickBuf[MaxCB];
static int lastc = 0;

int PushClickQueue(win,x,y,ibut) 
     int win,x,y,ibut;
{
  if ( lastc == MaxCB ) 
    {
      int i;
      for ( i= 1 ; i < MaxCB ; i ++ ) 
	{
	  ClickBuf[i-1]=ClickBuf[i];
	}
      ClickBuf[lastc-1].win = win;
      ClickBuf[lastc-1].x = x;
      ClickBuf[lastc-1].y = y;
      ClickBuf[lastc-1].ibutton = ibut;
    }
  else 
    {
      ClickBuf[lastc].win = win;
      ClickBuf[lastc].x = x;
      ClickBuf[lastc].y = y;
      ClickBuf[lastc].ibutton = ibut;
      lastc++;
    }
  return(0);
}

int CheckClickQueue(win,x,y,ibut) 
     integer *win,*x,*y,*ibut;
{
  int i;
  for ( i = 0 ; i < lastc ; i++ )
    {
      int j ;
      if ( ClickBuf[i].win == *win || *win == -1 ) 
    {
	  *win = ClickBuf[i].win;
	  *x= ClickBuf[i].x ;
	  *y= ClickBuf[i].y ;
	  *ibut=ClickBuf[i].ibutton; 
	  for ( j = i+1 ; j < lastc ; j++ ) 
	    {
	      ClickBuf[j-1].win = ClickBuf[j].win ;
	      ClickBuf[j-1].x   = ClickBuf[j].x ;
	      ClickBuf[j-1].y =  ClickBuf[j].y ;
	      ClickBuf[j-1].ibutton = ClickBuf[j].ibutton ;
	    }
      lastc--;
      return(1);
    }
    }
    return(0);
}

int ClearClickQueue(win)
     int win;
{
  int i;
  if ( win == -1 ) 
{
      lastc = 0;
      return 0;
    }
  for ( i = 0 ; i < lastc ; i++ )
    {
      int j ;
      if ( ClickBuf[i].win == win  ) 
	{
	  for ( j = i+1 ; j < lastc ; j++ ) 
	    {
	      ClickBuf[j-1].win = ClickBuf[j].win ;
	      ClickBuf[j-1].x   = ClickBuf[j].x ;
	      ClickBuf[j-1].y =  ClickBuf[j].y ;
	      ClickBuf[j-1].ibutton = ClickBuf[j].ibutton ;
	    }
	  lastc--;
	}
    }
  lastc=0;
  return(0);
}



/****************************************************
 * The Event Handler for the graphic windows 
 ****************************************************/

EXPORT LRESULT CALLBACK 
WndGraphProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
  static paint = 0;
  HDC hdc;
  PAINTSTRUCT ps;
  RECT rect;
  struct BCG *ScilabGC;
  ScilabGC = (struct BCG *)GetWindowLong(hwnd, 0);
  switch(message)
    {
    case WM_SYSCOMMAND:
      switch(LOWORD(wParam))
	{
	case M_GRAPH_TO_TOP:
	case M_COLOR:
	case M_COPY_CLIP:
	case M_PRINT:
	case M_WRITEINI:
	case M_REBUILDTOOLS:
	  SendMessage(hwnd, WM_COMMAND, wParam, lParam);
	  break;
	case M_ABOUT:
	  if (ScilabGC != (struct BCG *) 0 && ScilabGC->lpgw->lptw)
	    AboutBox(hwnd,ScilabGC->lpgw->lptw->AboutText);
	  return 0;
	}
      break;
    case WM_SETFOCUS: 
      return(0);
    case WM_COMMAND:
      if (LOWORD(wParam) < NUMMENU)
	SendGraphMacro(ScilabGC, LOWORD(wParam));
      else
	switch(LOWORD(wParam))
	  {
	  case M_GRAPH_TO_TOP:
	    ScilabGC->lpgw->graphtotop = !ScilabGC->lpgw->graphtotop;
	    SendMessage(hwnd,WM_COMMAND,M_REBUILDTOOLS,0L);
	    return(0);
	  case M_COPY_CLIP:
	    CopyClip(ScilabGC);
	    return 0;
	  case M_PRINT:
	    CopyPrint(ScilabGC);
	    return 0;
	  case M_WRITEINI:
	    WriteGraphIni(ScilabGC);
	    if (ScilabGC->lpgw->lptw)
	      WriteTextIni(ScilabGC->lpgw->lptw);
	    return 0;
	  case M_REBUILDTOOLS:
	    DebugGW("rebuild tools \r\n");
	    /** wininfo("rebuild tools \r\n"); **/
	    GetClientRect(hwnd, &rect);
	    InvalidateRect(hwnd, (LPRECT) &rect, 1);
	    UpdateWindow(hwnd);
	    return 0;
	  }
      return 0;
    case WM_LBUTTONDOWN:
      PushClickQueue(ScilabGC->CurWindow,(int) LOWORD(lParam),HIWORD(lParam),0) ;
      /** wininfo("mouse %d %d,%d",lastc,(int) LOWORD(lParam),HIWORD(lParam));**/
      return(0);
    case WM_MBUTTONDOWN:
      PushClickQueue(ScilabGC->CurWindow,(int) LOWORD(lParam),HIWORD(lParam),1) ;
      /** wininfo("mouse %d,%d",(int) LOWORD(lParam),HIWORD(lParam)); **/
      return(0);
    case WM_RBUTTONDOWN:
      PushClickQueue(ScilabGC->CurWindow,(int) LOWORD(lParam),HIWORD(lParam),2) ;
      /** wininfo("mouse %d,%d",(int) LOWORD(lParam),HIWORD(lParam)); **/
      return(0);
    case WM_CREATE:
      ScilabGC  = ((CREATESTRUCT *)lParam)->lpCreateParams;
      SetWindowLong(hwnd, 0, (LONG)ScilabGC);
      ScilabGC->CWindow = hwnd;
      if ( ScilabGC->lpgw->lptw 
	   && (ScilabGC->lpgw->lptw->DragPre!=(LPSTR)NULL) 
	   && (ScilabGC->lpgw->lptw->DragPost!=(LPSTR)NULL) )
	DragAcceptFiles(hwnd, TRUE);
      return(0);
    case WM_PAINT:
      paint++;
      /** wininfo("Painting %d",paint); **/
      /** if we are in pixmap mode ? **/
      hdc = BeginPaint(hwnd, &ps);
      if (  ScilabGC->Inside_init != 1 )
	{
	  SetMapMode(hdc, MM_TEXT);
	  SetBkMode(hdc,TRANSPARENT);
	  GetClientRect(hwnd, &rect);
	  SetViewportExtEx(hdc, rect.right, rect.bottom,NULL);
	  DebugGW("==> paint rect %d %d \n", rect.right, rect.bottom);
	  if ( ScilabGC->CurPixmapStatus == 1) 
	    {
	      scig_replay_hdc('W',ScilabGC->CurWindow,ScilabGC->hdcCompat,
			      rect.right,rect.bottom,1);
	      C2F(show)(PI0,PI0,PI0,PI0);
	    }
	  else
	    scig_replay_hdc('U',ScilabGC->CurWindow,hdc,rect.right,rect.bottom,1);
	}
      EndPaint(hwnd, &ps);
      return 0;
    case WM_SIZE:
      /* wininfo("Resizing"); */
      /* sciprint("Resising"); */
      /** We do not paint just check if we must resize the pixmap  **/
      if (  ScilabGC->Inside_init != 1 
	    && ((wParam == SIZE_MAXIMIZED) || (wParam == SIZE_RESTORED )))
	{
	  HDC hdc1;
	  /** a resize can occur while we are executing a routine 
	    inside periWin.c : so we must protect the hdc 
	    XXXX : not useful with scig_resize_pixmap ? **/
	  hdc1=GetDC(ScilabGC->CWindow); 
	  SetGHdc(hdc1,ScilabGC->CWindowWidth,ScilabGC->CWindowHeight);
	  scig_resize_pixmap(ScilabGC->CurWindow);
	  SetGHdc((HDC) 0,0,0); 
	}
      return 0;
      break;
    case WM_DROPFILES:
      if (ScilabGC->lpgw->lptw)
	DragFunc(ScilabGC->lpgw->lptw, (HDROP)wParam);
      break;
    case WM_DESTROY:
      /** sciprint("[destroy gw]"); */
      DebugGW("Je fais un destroy \n");
      DragAcceptFiles(hwnd, FALSE);
      return 0;
    case WM_CLOSE:
      /** sciprint("[close gw]"); **/
      DebugGW("Je fais un close \n");
      C2F(deletewin)(&(ScilabGC->CurWindow));
      SetWindowLong(hwnd,0,(LONG) 0L);
      /** XXXXX : PostQuitMessage(0); **/
      return 0;
    }
  return DefWindowProc(hwnd, message, wParam, lParam);
}

/********************************************************
 * A special Replay for win95 
 * we want to replay with a specific hdc 
 * and reset the hdc to its current value when leaving 
 * we must also protect the alufunction current value 
 *  ( for application like gr_menu or scicos : where 
 *    a redraw can occurs while we are using a alufunction 
 *    in a graphic mode without xtape )
 ********************************************************/

static void scig_replay_hdc(char c, integer win_num,HDC hdc,int width,int height,
			    int scale)
{
  integer verb=0,cur,na;
  char name[4];
  integer alu,narg,verbose=0;
  GetDriver1(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  /** Warning : We use a driver which does not touch to hdc **/
  C2F(SetDriver)("Int",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
  C2F(dr)("xset","window",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xget","alufunction",&verbose,&alu,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  SetGHdc(hdc,width,height);
  /** new font for printers **/
  if ( c == 'P' ) SciG_Font_Printer(scale);
  /** the create default font/brush etc... in hdc */ 
  ResetScilabXgc ();
  /** xclear will properly upgrade background if necessary **/
  C2F(dr)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);    
  C2F(dr)("xreplay","v",&win_num,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr1)("xset","alufunction",&alu,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  C2F(SetDriver)(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  SetGHdc((HDC) 0,600,400);
  /** back to usual font size **/
  SciG_Font() ;
  SwitchWindow(&cur);
}

/********************************************************
 * parent overlapped window 
 ********************************************************/

EXPORT LRESULT CALLBACK 
WndParentGraphProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
  POINT ScreenMinSize = {16,4};
  POINT *MMinfo = (POINT *)lParam;
  TEXTMETRIC tm;
  HDC hdc;
  PAINTSTRUCT ps;
  RECT rect;
  struct BCG *ScilabGC;
  ScilabGC = (struct BCG *)GetWindowLong(hwnd, 0);
  switch(message) {
  case WM_SYSCOMMAND:
    switch(LOWORD(wParam))
      {
      case M_COPY_CLIP:
      case M_PASTE:
      case M_WRITEINI:
      case M_ABOUT:
	SendMessage(ScilabGC->CWindow, WM_COMMAND, wParam, lParam);
      }
    break;
  case WM_KILLFOCUS: 
    SendMessage(textwin.hWndText, message, wParam, lParam);
    return(0);
  case WM_SETFOCUS: 
    /** when focus is set in the graphic window we set it to scilab window**/
    SendMessage(textwin.hWndText, message, wParam, lParam);
    return(0);
  case WM_KEYDOWN:
    SendMessage(textwin.hWndText, message, wParam, lParam);
    return(0);
  case WM_CHAR :
    SendMessage(textwin.hWndText, message, wParam, lParam);
    return(0);
  case WM_GETMINMAXINFO:
    /*** Eventuellement a changer XXXXXXX  **/
    hdc = GetDC(hwnd);
    SelectFont(hdc, GetStockFont(OEM_FIXED_FONT));
    GetTextMetrics(hdc,(LPTEXTMETRIC)&tm);
    ReleaseDC(hwnd,hdc);
    /* minimum size */
    MMinfo[3].x = ScreenMinSize.x*tm.tmAveCharWidth
      + GetSystemMetrics(SM_CXVSCROLL) + 2*GetSystemMetrics(SM_CXFRAME);
    MMinfo[3].y = ScreenMinSize.y*tm.tmHeight
      + GetSystemMetrics(SM_CYHSCROLL) + 2*GetSystemMetrics(SM_CYFRAME)
      + GetSystemMetrics(SM_CYCAPTION);
    return(0);
  case WM_SIZE:
    /** sciprint("Resising Parent"); **/
    GetWindowRect (ScilabGC->Statusbar, &rect) ;
    SetWindowPos(ScilabGC->Statusbar,(HWND)NULL, 0,
		 HIWORD(lParam) - ( rect.bottom - rect.top) , 
		 LOWORD(lParam), ( rect.bottom - rect.top) , 
		 SWP_NOZORDER | SWP_NOACTIVATE);
    SetWindowPos(ScilabGC->CWindow, (HWND)NULL, 0,
		 ScilabGC->lpgw->ButtonHeight,
		 LOWORD(lParam),HIWORD(lParam) -ScilabGC->lpgw->ButtonHeight
	         - ( rect.bottom - rect.top) , 
		 SWP_NOZORDER | SWP_NOACTIVATE);
    return(0);
  case WM_COMMAND:
    /** pass on menu commands */
    if (IsWindow(ScilabGC->CWindow))
      SetFocus( ScilabGC->CWindow);
    SendMessage( ScilabGC->CWindow, message, wParam, lParam); 
    return(0);
  case WM_PAINT:
    {
      hdc = BeginPaint(hwnd, &ps);
      if (ScilabGC->lpgw->ButtonHeight) {
	HBRUSH hbrush;
	GetClientRect(hwnd, &rect);
	hbrush = CreateSolidBrush(GetSysColor(COLOR_BTNSHADOW));
	rect.bottom = ScilabGC->lpgw->ButtonHeight-1;
	FillRect(hdc, &rect, hbrush);
	DeleteBrush(hbrush);
	SelectPen(hdc, GetStockPen(BLACK_PEN));
	MoveToEx(hdc, rect.left, ScilabGC->lpgw->ButtonHeight-1,NULL);
	LineTo(hdc, rect.right, ScilabGC->lpgw->ButtonHeight-1);
      }
      EndPaint(hwnd, &ps);
      return 0;
    }
  case WM_DROPFILES:
    DragFunc(ScilabGC->lpgw->lptw, (HDROP)wParam);
    break;
  case WM_CREATE:
    {
      ScilabGC  = ((CREATESTRUCT FAR *)lParam)->lpCreateParams;
      SetWindowLong(hwnd, 0, (LONG) ScilabGC);
      ScilabGC->hWndParent = hwnd;
      if ( ScilabGC->lpgw->lptw 
	   && (ScilabGC->lpgw->lptw->DragPre!=(LPSTR)NULL) 
	   && (ScilabGC->lpgw->lptw->DragPost!=(LPSTR)NULL) )
	DragAcceptFiles(hwnd, TRUE);
    }
  break;
  case WM_DESTROY:
    /** sciprint("[==>Destroy de graph Parent]");**/
    DragAcceptFiles(hwnd, FALSE);
    break;
  case WM_CLOSE:
    /** sciprint("[==>Close de graph Parent]"); **/
    /** The Graphic window will do the job **/
    SendMessage( ScilabGC->CWindow,WM_CLOSE,0,0); 
    return 0;
  }
  return DefWindowProc(hwnd, message, wParam, lParam);
}

