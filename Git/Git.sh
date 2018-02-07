#=================================================================================
# [table of contents]
#	- basic Git structure
#	- basic Git workflow
#	- how to backtrack in Git
#   - Git branching
#   - Git team work
# - remote repositories
#=================================================================================
# references:
# - https://guides.github.com/
# - https://try.github.io/
# - http://happygitwithr.com/
# - http://r-pkgs.had.co.nz/git.html
# - https://www.atlassian.com/git/tutorials/

#=================================================================================
# basic Git structure

# after `git init`, a .git folder is created
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

git --version  # to see version

#=================================================================================
# basic Git workflow
# - working directory: where you'll be doing your work
# - - make changes
# - staging area: where you'll see changes you make to the working directory
# - - bring changes into the staging area
# - repository: where Git permanently stores changes as different versions of the project
# - - save changes to the respository as a 'commit'

git init  # sets up all the tools Git needs to begin tracking changes made
git status  # check the status of changes (untracked = Git sees, but not yet track)

# remove git repository (recursive and force)
rm -rf .git

# see difference ("q" to quit): "+" for added, "-" for removed
diff file_1.txt file_2.txt  # between file_2 and (compared to) file_1
git diff  # between working directory and staging area
git diff --staged  # between staging area and (commited) repository
git diff commit_n_1 commit_n_2  # between two particular commits (first 7 is enough)
git diff file_1.txt  # for a particular file
git diff HEAD  # compared to the most recent commit – i.e. HEAD

# add changes to the staging area (subset of files whose changes you want to commit)
git add file_1.txt  # add file_1.txt to the staging area
git add file_1.txt file_2.txt  # add both files to the staging area
git add '*.txt'  # adding all text files
git add -u  # adding files that are tracked, and are updated
git add *  # adding all

# commit changes
git commmit -m "message"  # optional message should be <50 characters
git commmit -a -m "message"  # commit all changes in existing files

# ammend - should never reset snapshots that have been shared with other developers
git commit --ammend -m "New commit message"  # also change message

#---------------------------------------------------------------------------------
# seeing log of changes

git log  # stored chronologically
git log  -n 1 # only show 1 commit

# more elaborate
git log --stat  # to add additional statistics (how many "+", "-", etc.)
git log --graph  # graph of current branch
git log --graph --oneline  # graph, with just the commit message
git log --graph --oneline master branch_1  # graph, with both master and branch1
git log --oneline  # condense each commit to a single line
git log -p  # display the patch representing each commit

# searching
git log --author="<pattern>"  # search for commits by a particular author
git log --grep="<pattern>"  # search for a matching commit message
git log <since>..<until>  # show only commits that occur between
git log <file>  # show only display commits that include the specified file

git log --graph --decorate --oneline  # combining into something useful

#---------------------------------------------------------------------------------
# ignoring

# untrack files: http://git-scm.com/docs/gitignore
nano .gitignore  # to get a hidden list going

# to make git to forget a file that is already being tracked
# - first, include that file .gitignore; then
git rm --cached file_1.txt  # removes from index ("cached")

#=================================================================================
# how to backtrack in Git

git show HEAD  # shows changes introduced by the latest commit, compared to parent
git show commmit_n_1  # show changes introduced by a particular commit
# merges are by time: `git show` will find parents; `git diff`, cannot

#---------------------------------------------------------------------------------
# to be on a previous commit

git checkout HEAD file_1.txt  # to be on the last commit
git checkout commit_n file_1.txt  # to be (temporarily) on a particular commit (n)
# git will warn of being on a "detached HEAD" state: it's okay to rerun the program
# to spot which commit introduced the "bug"; it is read-only

# for changes use:
git checkout -b branch_1  # same as `git branch branch_1`, then `git checkout branch_1`
# if changes is made w/t creating a new branch, git cannot relocate the change:
# git points to the HEAD of each branch, and traverse back; thus no branch = no pointer

git checkout master  # go back to master

#---------------------------------------------------------------------------------
# revert: undoes a single commit 
# - figures out how to undo the changes introduced by the commit (useful for bugs)
# - appends a new commit with the resulting content (safe; can undo)

git revert commit_n  # better for public, published changes 

#---------------------------------------------------------------------------------
# reset: "revert" back to the previous state of a project 
# - should only be used to undo local changes
# - should never reset snapshots that have been shared with other developers

# unstage 
git reset file_1.txt 
git reset --hard  # back to last commit (loosing any changes)
git reset --hard commit_n  # back to commit n (loosing any changes)
# be careful with `--hard`; only use after OK w/ `git diff` & `git diff --staged`

# example: undo the last commit
git reset HEAD^  # leave the files in current state (but unstaged)
git reset --mixed HEAD^  # same (default)
git reset --soft HEAD^  # undo the commit, but leave the files in the staging area
git reset --hard HEAD^  # undo the commit completely (loosing any changes)

# look at git log, and reset commit
git reset 5d69206  # where "5d69206" is the first 7-characters of last commit to keep

#---------------------------------------------------------------------------------
# clean up

git clean -n # untracked files to be cleaned
git clean -f # clean files
git clean -fd # clean files and directories

#=================================================================================
# how to branch in Git
# branching:  experiment with versions of a project, without affecting the master

# make changes in a new branch, then commit
git branch  # to check out which branch you are currently on (marked with *)
git branch new_branch  # to get a new branch
git checkout new_branch  # to be on new_branch

#---------------------------------------------------------------------------------

# merge: git compares the two HEADs, and the commit they last shared 
# - when merging one's parent to itself, git changes pointer ("Fast-forward")
# - when merging defies simple logic, git flag changes as conflicts
git checkout master  # the branch to be merged onto
git merge new_branch # merge new_branch onto master

# update branch with master
git checkout new_branch
git merge master new_branch

# merge, with conflict
# - commmit with conflict first, to flag where the conflict is 
# - then, to resolve the conflict, preserve the one you want, and remove all else
git add file_1.txt  # to re-add to the staging area
git commit -m "merge conflict resolved"

# since branches are usually a means to an end, you delete them after their purpose
git branch -d new_branch  # deletes the branch (stopped if it has unmerged changes)
git branch -d new_branch  # deletes the branch (even if it has unmerged changes)
git branch -m new_branch_name  # rename branch

#=================================================================================
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

# setup: create a new remote repo; then, clone the repo to local computer
# - clone only works for git repos; unlike copy, clone copies history of changes
git clone https://github.com/stevenwong15/Notes.git
git remote show origin  # show information
# OR: if want to conenct to an empty remote server
git remote add origin https://github.com/stevenwong15/Notes.git
git push origin master  # push to master branch

# adding upstream (from which you forked)
git remote add upstream https://github.com/stevenwong15/Notes.git

# git keeps the status of the remote branch, when it was last fetched
git log  # master branch
git log origin/master  # origin/master branch of the latest fetch

#---------------------------------------------------------------------------------
# workflow: very similar to the branch, checkout, commit, merge in Git
# - Fork the repo (clone a repo to your GitHub repo, then you can clone to local)
# - Make the fix
# - Submit a pull request to the project owner
# rules:
# - anything in the master branch is always deployable
# - branch names should be descriptive: others can see what is being worked on
# - each commit has to have a reason, and being on Github, it creates transparency
# - pull requests start the review of the changes, before merging with the master

# show all remote URLs
git remote -v  # -v = verbose
git branch -vv  # confirms if local master has origin/master as upstream remote

# pulling from origin
git pull origin master  # need to specify which branch to pull from
# same as: do this if there are potential conflicts
git fetch origin  # updates `origin/mater` branch in local repo
git merge master origin/master  # merging 

git push -u origin master  # first time (if osxkeychain installed)
git push  # subsequent time (if osxkeychain installed)
git push origin branch  # pushing to a branch intead

# 1. centralized workflow
# pulling via rebase: put my changes on top of what everybody else has done
git checkout master
git pull --rebase origin master
# if conflict (say, file_1.txt):
# - fix file_1.txt
git add file_1.txt
git rebase --continue
# if you get to this point and realize and you have no idea what’s going on:
git rebase --abort
# finally
git push origin master

# 2. feature branch workflow
git branch new_branch  # first, create a new branch
git checkout new_branch  # check out the branch
# work on it; then:
git push -u origin new_branch  # -u flag adds it as a remote tracking branch
# then, make more changes, add to staging area, and commmit
git push origin new_branch  # push to a branch first
# make a pull request (pull because you're asking the owner to pull and merge)
# once approved: 
git checkout master
git pull origin master  # make sure master is up to date (should be clean)
git pull origin new_branch  # merges the central repository’s copy of new_branch
# could also use a simple git merge marys-feature, 
# but the command shown makes sure pulling latest version of the feature branch
git push origin master
# if there are no conflicts, GitHub allows for automatic merge
# - if yes conflict, need to first pull master into local master (should be clean)
# - then, merge local master to local branch and resolve conflict
# - then, push, and make a new `pull request` (there should be no conflicts now)
# if two people are introducing different changes:
# - merge one with the origin/master first, then do the other (as shown above)
# if the upstream (from which your remote is forked) changed, similarly conduct
# - add a new remote call upstream to local 
# - pull from upstream to local master
# - then, merge local master to local branch and resolve conflict
git checkout new_branch
git merge master new_branch
# - then, push to the fork:
git push origin new_branch  # push new_branch to the fork
git checkout master  # push the master to the fork as well
git push origin master
# - finally merge fork with upstream
