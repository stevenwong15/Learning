#---------------------------------------------------------------------------------
# workflow
#---------------------------------------------------------------------------------
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

# fork
git clone https://...  # clone in the cd the GitHub files (URL found on Github)

# getting both your fork, and the upstream fork
git remote -v
# origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
# origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
git remote -v
# origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
# origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
# upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (fetch)
# upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (push)
# upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (push)

git push origin  # push changes to masters on GitHub

git pull origin  # pull changes from masters on Github
# same as
git fetch origin
git merge origin/master


# 




#--

git remote add origin ... 


# -u to remember the parameters
git push -u origin master

git pull origin master


# differences of the most recent commit
git diff HEAD
# then add
# then see changes that just staged (added)
git diff --staged
# unstage
git reset file

# changed back to last commit
git checkout -- file
git branch clean_up  # creat a branch

# switch to new branch
git checkout clean_up
# do changes
# then, commit


# use the master
git checkout master

#  merge
git merge clean_up
# delete branch
git branch -d clean_up

# push 
git push
