#=================================================================================
# [table of contents]
#	- basic Git structure
#	- basic Git workflow
#	- how to backtrack in Git
#   - Git branching
#   - Git team work
#=================================================================================
# references:
# - https://guides.github.com/
# - https://try.github.io/
# - http://happygitwithr.com/
# - http://r-pkgs.had.co.nz/git.html

#=================================================================================
# basic Git structure

# after `git init1, a .git folder is created
# ├── head - a pointer to the tip of the branch you're working on
# ├── branches
# ├── config - settings: every-time yo uuse 'git config...', it ends here
# ├── description
# ├── hooks - scripts that can be run at every meaningful git phase (e.g. some pre-push hook)
# │ ├── pre-commit.sample
# │ ├── pre-push.sample
# │ └── ...
# ├── info
# │ └── exclude - same as .gitignore, but won't be shared
# ├── objects - see below
# │ ├── info
# │ └── pack
# └── refs
#  ├── heads
#  └── tags

# everytime a file is created + tracked, git compresses and stores it into its own 
# data structure, under the object directory; a simplified version of commit:
# - if the file didn't change, git just adds the name of the compressed file
# - if the file changed, git compresses it, stores the compressed file in the object folder,
#   and adds the name (the hash) into the snapshot

# A commit is made of 4 things :
# - The name (a hash) of the working directory’s snapshot
# - A comment
# - Commiter information
# - Hash of the parent commit

#=================================================================================
# basic Git workflow

git --version  # to see version

# working directory: where you'll be doing your work
# - make changes
# staging area: where you'll see changes you make to the workign directory
# - bring changes into the staging area
# repository: where Git permanently stores changes as different versions of the project
# save changes to the respository as a 'commit'

git init  # sets up all the tools Git needs to begin tracking changes made
git status  # check the status of changes (untracked = Git sees, but not yet track)

# see difference
git diff file_1.txt  # changes marked with "+"; press "q" to quit
git diff HEAD  # of the most recent commit

# add changes to the staging area
git add file_1.txt  # add file_1.txt to the staging area
git add file_1.txt file_2.txt  # add both files to the staging area
git add '*.txt'  # adding all text files
git add *  # adding all

# see difference at the staging area
git diff --staged

# unstage
git reset file_1.txt

# commit changes
git commmit -m "message"  # optional message should be <50 characters
git commmit -a -m "message"  # commit all changes in existing files

# see log of changes
git log  # stored chronologically

#---------------------------------------------------------------------------------
# remote repositories

# name and email associated with remote repository
git config --global user.name "stevenwong15"
git config --global user.email "stevenwong15@gmail.com"
git config --global --list  # all associations

# Caching GitHub password in Git
# https://help.github.com/articles/caching-your-github-password-in-git/
# if already installed, shows usage: git credential-osxkeychain <get|store|erase>
git credential-osxkeychain

# hub is a command-line wrapper for git that makes you better at GitHub
# https://github.com/github/hub#readme/
# first, install homebrew: http://brew.sh/
# in .bash_profile, make hub the same as git
eval "$(hub alias -s)"

# setup: create a new remote repository
# then, clone the repo to your local computer
git clone https://github.com/stevenwong15/Notes.git
# show information
git remote show origin

# instead, if want to conenct to a remote server
git remote add origin https://github.com/stevenwong15/Notes.git

# workflow: 
# very similar to the branch, checkout, commit, merge in Git
# - Fork the repository.
# - Make the fix.
# - Submit a pull request to the project owner.
# rules
# - anything in teh master branch is always deployable
# - branch names should be descriptive, so that others can see what is being worked on
# - each commit has to have a reason, and being on Github, it creates transparency
# - pull requests start the review of the changes, before merging with the master
# all of the workflow can be done on github.com and GithHb Desktop

# show all remote URLs
git remote -v
# confirm local master branch has remote master branch (origin/master) as upstream remote
git branch -vv

# if osxkeychain installed:
git push -u origin master  # first time
git push  # subsequent time
git push origin branch  # pushing to a branch intead

# pulling from origin
git pull origin
# same as 
git fetch origin
git merge origin/master

#---------------------------------------------------------------------------------
# ignoring and deleting

# untrack files: http://git-scm.com/docs/gitignore
nano .gitignore  # to get a hidden list going
# to make git to forget what's already being tracked
git rm --cached <file>

#=================================================================================
# how to backtrack in Git

# head commit = the commit you're currently on
git show HEAD  # shows "git log" output, plus all the file changes

# restore the file to as it look when you last made a commit
git checkout HEAD file_1.txt

# unstage a file
git reset HEAD file_1.txt

# look at git log, and reset commit
git reset 5d69206  # where "5d69206" is the first 7-characters of last commit to keep

#---------------------------------------------------------------------------------
# Git branching
# to experiment with versions of a project, without affecting the master branch

# to check out which branch you are currently on (marked with *)
git branch  
# to get a new branch
git branch new_branch  
# to be on branch_1
git checkout new_branch  

# make changes, then commit

# merge
git checkout master  # the branch to be merged onto
git merge new_branch # merge new_branch onto master

# merge, with conflict (i.e. both branches has had new commits)
# when you merge, Git uses the following to indicate conflicts
# to resolve the conflict, preserve the one you want, and remove all else
git add file_1.txt  # to re-add to the staging area
git commit -m "merge conflict resolved"

# since branches are usually a means to an end, you delete them after their purpose
git branch -d new_branch

#---------------------------------------------------------------------------------
# Git team work
# origin: the original directory (which is remote)
# typical team workflow:
# - Fetch and merge changes from the remote
# - Create a branch to work on a new project feature
# - Develop the feature on your branch and commit your work
# - Fetch and merge from the remote again (in case new commits were made while you were working)
# - Push your branch up to the remote for review
# note, you must first be in your own cloned directory for the following to work 

# clone a directory
git clone /path/lcoation/folder_1 folder_2  # clone folder_1, and name it folder_2

git remote -v  # list the origin (and its path) of this remove directories

# get from remote, and merge with your own
git fetch  # to see if changes have been made to the remote
git merge origin/master  # to merge changes to the master of the origin

# push to remote
git push origin new_branch_name  # create changes in a branch, and push to remote as a new branch
