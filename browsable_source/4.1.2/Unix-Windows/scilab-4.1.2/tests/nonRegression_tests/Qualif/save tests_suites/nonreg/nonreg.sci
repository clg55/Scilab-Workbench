mode (-1)

disp("")
disp("")
disp("------------------------------{ DEBUT TEST SUITE NON REGRESSION DEBUT }");
disp("")
disp("")

// dans la variable num_test mettre tous les num�ros de bugs corrig�s dans la version .7.1
num_test = [1,6,21,22,24,25]

for k = num_test
   exec('bug' + string(k) + '.sci')
end

disp("")
disp("") 
disp("------------------------------{ FIN TEST SUITE NON REGRESSION FIN }");

