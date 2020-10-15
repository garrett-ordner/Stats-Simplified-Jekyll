# R-1-2-6
#Install the gtools package if running for the first time
#(remove the '#' from the next line)
#install.packages('gtools')

#load the gtools package
library(gtools)
# let's remove whatever is in our global environment for a fresh start!
rm(list=ls())


#set a seed so our results are reproducible (if you run a part of the code with a random sample, 
#make sure you still include this line)
set.seed(83759)

#set up our nine-ball lottery as a vector containing integers 1 through 9, and then assign the total number of balls to 'n'
lotto = 1:9
n = length(lotto)

#how many ways can we arrange the 9 balls?
permlotto = nrow(permutations(n, n, lotto))
permlotto
#notice that this is just nine factorial:
factorial(9)


#randomly pick four balls without replacement and assign 
#the number of balls picked to 'r'
pick = sample(lotto, 4, replace = FALSE)
pick
r = length(pick)

#we've picked '6 2 5 1'

#how many ways can we arrange the 4 balls?
permpick = nrow(permutations(r, r, lotto, repeats.allowed = FALSE))
permppick
#again, this is 4 factorial
factorial(4)

#how many arrangements of four balls picked without replacement
#can we get?
orderednoreplace = nrow(permutations(n, r, lotto, repeats.allowed = FALSE))
orderednoreplace

#Notice, 3,024 is the result of dividing nine factorial by (9-4) factorial:
factorial(n)/factorial(n-r)

#-------------------------------------------------------------
#let's do one more example. this time we will still pick without replacement,
#but the order of our pick is no longer important e.g. '1 2 3 4' is the same as '4 3 2 1'
#--------------------------------------------------------------

#we'll set a different seed here so we can run this section of code in isolation
set.seed(97412)

#we'll pick another sample without replacement just for fun.  If you wanted to pick
#with replacement, just set replace = TRUE
pick2 = sample(lotto, 4, replace = FALSE)
pick2
#our pick is '6 4 3 9'
r = length(pick2)

#we already know our pick can be arranged 24 ways
#now, let's see how many combinations of 4 balls we can pick without replacement
unorderednoreplace = nrow(combinations(n, r, lotto, repeats.allowed = FALSE))
unorderednoreplace

#we can pick 126 combinations of 4 balls without replacement.  Note that we get the same result with our formula:
factorial(n)/(factorial(r)*factorial(n-r))

#finally, lets calculate the number of combinations of 4 balls picked WITH replacement
unorderedreplace = nrow(combinations(n, r, lotto, repeats.allowed = TRUE))
unorderedreplace

#and our formula:
factorial(n+r-1)/(factorial(r)*factorial(n+r-1-r))