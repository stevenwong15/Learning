#---------------------------------------------------------------------------------
# [table of contents]
#	- setup
#---------------------------------------------------------------------------------
# https://guides.github.com/

#---------------------------------------------------------------------------------
# setup
#---------------------------------------------------------------------------------

git config --global user.name "YOUR NAME"
git config --global user.email "YOUR EMAIL ADDRESS"

# Caching your GitHub password in Git
# https://help.github.com/articles/caching-your-github-password-in-git/

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

# fork