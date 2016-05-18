#---------------------------------------------------------------------------------
# [table of contents]
#	- basic Git structure
#	- basic Git workflow
#	- how to backtrack in Git
#   - Git branching
#   - Git team work
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# basic Git structure
#---------------------------------------------------------------------------------

# after git init, a .git folder is created
# ├── head - a pointer to the tip of the branch you're working on
# ├── branches
# ├── config - settings: every-time yo uuse 'git config...', it ends here
# ├── description
# ├── hooks - set of scripts that can be run at every meaningful git phase (e.g. some pre-push hook)
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


#---------------------------------------------------------------------------------
# basic Git workflow
#---------------------------------------------------------------------------------
# working directory: where you'll be doing your work
# - make changes
# staging area: where you'll see changes you make to the workign directory
# - bring changes into the staging area
# repository: where Git permanently stores changes as different versions of the project
# save changes to the respository as a 'commit'

git init  # sets up all the tools Git needs to begin tracking changes made
git status  # check the status of changes (untracked = Git sees, but not yet track)

# add changes (i.e. if there's a new file!)
git diff file_1.txt  # changes marked with "+"; press "q" to quit
git add file_1.txt  # add file_1.txt to the staging area
git add file_1.txt file_2.txt  # add both files to the staging area

# commit changes
git commmit -a -m "message"  # commit all changes in existing files
git commmit -m "message"  # optional message should be <50 characters

# see log of changes
git log  # stored chronologically

# untrack files: http://git-scm.com/docs/gitignore
nano .gitignore  # to get a hidden list going
# to make git to forget what's already being tracked
git rm --cached <file>

#---------------------------------------------------------------------------------
# how to backtrack in Git
#---------------------------------------------------------------------------------

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
#---------------------------------------------------------------------------------
# to experiment with versions of a project, without affecting the master branch

git branch  # to check out which branch you are currently on (marked with *)

git branch new_branch  # to get a new branch

git checkout branch_1  # to be on branch_1

# merge
git checkout branch_1  # the branch to be merged onto
git merge branch_2  # merge branch_2 onto branch_1

# merge, with conflict (i.e. both branches has had new commits)
# when you merge, Git uses the following to indicate conflicts
# to resolve the conflict, preserve the one you want, and remove all else
git add file_1.txt  # to re-add to the staging area
git commit -m "merge conflict resolved"

# since branches are usually a means to an end, you delete them after their purpose
git branch -d branch_name

#---------------------------------------------------------------------------------
# Git team work
#---------------------------------------------------------------------------------
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
