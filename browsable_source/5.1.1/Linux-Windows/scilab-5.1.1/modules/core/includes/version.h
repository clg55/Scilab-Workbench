/*
 * Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) INRIA
 *
 * This file must be used under the terms of the CeCILL.
 * This source file is licensed as described in the file COPYING, which
 * you should have received as part of this distribution.  The terms
 * are also available at
 * http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
 *
 */
#ifndef SCI_VERSION_H
#define SCI_VERSION_H

#define SCI_VERSION_MAJOR 5
#define SCI_VERSION_MINOR 1
#define SCI_VERSION_MAINTENANCE 0
#define SCI_VERSION_STRING "scilab-5.1.1"
/* SCI_VERSION_REVISION --> hash key commit */
#define SCI_VERSION_SVN_URL "svn://svn.scilab.org/scilab/branches/5.1/"
#define SCI_VERSION_GIT_URL "git://git.scilab.org/scilab"
#define SCI_VERSION_REVISION 2eb7d0d90e8affad49d97318834c9d27f4916486
#define SCI_VERSION_TIMESTAMP 1239693280

void disp_scilab_version(void);

/* for compatibility */
/* Deprecated */
#define SCI_VERSION SCI_VERSION_STRING
#define DEFAULT_SCI_VERSION_MESSAGE "scilab-5.1.1 (INRIA,ENPC)"


#endif
/*--------------------------------------------------------------------------*/

