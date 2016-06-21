#---------------------------------------------------------------------------------
# [table of contents]
#	- shortcuts
#	- general concepts
#	- navigate
#	- copy, move and remove files
#	- redirection
#	- environment
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# dotfiles
#--------------------------------------------------------------------------------- 

# https://github.com/robbyrussell/oh-my-zsh
# https://github.com/mathiasbynens/dotfiles

#---------------------------------------------------------------------------------
# shortcuts
#--------------------------------------------------------------------------------- 

Ctrl + a  # go to front
Ctrl + e  # go to end
Ctrl + u  # delete all prior
Ctrl + k  # delete all after
Opt + arrow  # skip by word
Opt + click  # go to word
tab  # auto-complete
drag folder to terminal  # get directory
history  # get history of commands  
!  # run last command starting with w/e comes after !, or use ID shown by history
Ctrl + r  # search for commands
Ctrl + l  # clear by adding space
Cmd + k  # clear all

#---------------------------------------------------------------------------------
# general concepts
#--------------------------------------------------------------------------------- 
# Console => Terminal => Shell
# - shell = the command line = the actual program capable of reading user’s input 
# 	and providing the result on the screen
# - "graphical user interfaces make easy tasks easy, while command line interfaces 
#   make difficult tasks possible"
# bash = Bourne Again SHell, an enhanched replacement for sh
# - has not concept of extension
# - much easier if filenames has no spaces or other punctuations

clear  # clear the terminal
open file_1.txt  # opens the file
open -a APP_NAME  # opens the application
open -a APP_NAME file_1.txt  # opens the file with the application

#---------------------------------------------------------------------------------
# navigate
#---------------------------------------------------------------------------------
# $ = shell prompt, appears when the terminal is ready to accept a command

ls  # list directory contents
ls -a  # lists all contents, including hidden files and directories
ls -l  # list all contents of a directory in long format
# long format
# 1) access rights
# 2) number of hard links (# of child directories and files)
# 3) username of the file's owner
# 4) the name of the group that owns the file
# 5) the size of the file in bytes
# 6) the date & time teh file was last modified
# 7) the name of the file or directory
ls -t  # order files and directory by the time they were last modified
ls -alt  # using all the above three commands together

pwd  # print working directory: outputs the name of the directory you're in

cd  # change directory, or navigate to home directory
cd ..  # navigate to parent directory (one up)
cd ../../folder/  # navigate two up, then to folder

cd ./STH  # navigate to STH, based on the relative path; ./ can be omitted
cd -  # changes the working directory to the previous working directory
cd ~unser_name  # changes the working directory to that of user_name

# new
mkdir filename  # make a new directory names "filename"
touch filename.txt  # make a new file in the directory

#---------------------------------------------------------------------------------
# copy, move and remove files
#---------------------------------------------------------------------------------

# copy
cp file_1.txt file_2.txt  # copies the content in filename_1 to filename_2
cp foler_1/file_1.txt folder_2/file_2.txt folder_3/  # copies file_1 and file_2 to folder_3
cp * folder/  # copy all the files in the current director to folder (* = ex of a wildcard)
cp m*.txt folder/  # copy all the .txt files starting with m to folder

# move
mv  # very similar to cp, but moves the files
mv file_1.txt file_2.txt  # renames file_1 to file_2

# remove – there's no going back: once it's gone, it's gone
rm file_1.txt  # removes files
rm -r folder_1  # removes recursively, meaning all the files and children files in a folder 

#---------------------------------------------------------------------------------
# redirection
#---------------------------------------------------------------------------------
# reroutes stdin, stdout and stderr to/from a different location
# standard input (stdin) = information inputted into the terminal
# standard output (stdout) = information outputted after a process in run
# standard error (stderr) = error message outputted by a failed process

echo "Hello"  # accepts "Hello" as stdin, and echoes it back to the terminal as stdout
# think of "echo" as "display" – pushes a return without executing the content of the return

echo "Hello" > hello.txt  # redirects stdout to a fie
cat hello.txt  # outputs contents to the terminal
cat < file_1.txt  # takes the stdin from the right, and inputs it to the left

cat file_1.txt > file_2.txt  # overwrites all content in file_2.txt with that in file_1.txt
cat file_1.txt >> file_2.txt  # appends all content in file_2.txt to that in file_1.txt

# piping: |
cat file_1.txt | wc | cat > file_2.txt  # outputs file_1, word count it, output wc into file_2
# 3 columns of wc: number of lines, words, and characters

sort file_1.txt  # orders alphabetically
uniq file_1.txt  # filters out adjacent, duplicate lines in a file

# global regular expression print (search, output)
grep Pattern file_1.txt  # search file_1 for lines that match a pattern
grep -i Pattern file_1.txt  # -i = case insensitive
grep -R /folder_1/folder_2  # (recursively) search for files; output filenames and lines with results
grep -Rl /folder_1/folder_2  # (recursively) search for files; output filenames with results

# stream editor (search, modify, output)
sed 's/text_1/text_2/' file_1.txt  # replace first instance of text_1 with text_2
sed 's/text_1/text_2/g' file_1.txt  # replace all instances of text_1 with text_2

#---------------------------------------------------------------------------------
# environment
#---------------------------------------------------------------------------------

# iTerm2: https://www.iterm2.com/

# learn more about .files here: https://dotfiles.github.io/

# command line text editor
nano file_1.txt  # opens a few .txt file named hello.txt in the text editor
# ^ key means Ctrl (more on the bottum of the nano editor)

# bash_profile (in ~/. directory - i.e. hidden) runs in every new terminal session
nano ~/.bash_profile  # opens up; can type in
# echo "Hello, Steven Wong!"
# alias pd="pwd"  # uses makes the pd command call the pwd command; i.e. shortcut
# alias hy="history"
# alias ll="ls -al"
# export PS1=">> "  # changes the prompt from $ to >>
# export USER="Steven Wong"  # sets the environment variable USER to "Steven Wong"
source ~/.bash_profile  # test run 
echo $USER  # $ is always used when returning a variable's value

env  # returns a list of environment variables for the current user
# sample
env | grep HOME  # or eve
echo $HOME  # display the path of the home directory

# scripts – can customize the PATH variables, when addring your own scripts
echo $PATH  # display the list of directories with scripts for command line to execute
# /home/ccuser/.gem/ruby/2.0.0/bin
# /usr/local/sbin
# /usr/local/bin
# /usr/bin
# /usr/sbin
# /sbin
# /bin
# example:
/bin/pwd  # excutes "pwd", which is stored in /bin
open -a Finder /ABOVEPATH  # to see in Finder these hidden folders

#---------------------------------------------------------------------------------
# in .bash_profile
#---------------------------------------------------------------------------------

# make ls display colors, reinforce with CLICOLOR and LSCOLORS
export CLICOLOR=1

# LSCOLORS order: DIR, SYM_LINK, SOCKET, PIPE, EXE, BLOCK_SP
# CHAR_SP, EXE_SUID, EXE_GUID, DIR_STICKY, DIR_WO_STICKY
# a = black, b = red, c = green, d = brown, e = blue,
# f = magenta g = cyan, h = light gray, x = default
# lowercase is bold
# solarized 
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

