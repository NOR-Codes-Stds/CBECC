# Steps for performing the migration
1. Make a new branch from main of the GitHub repo.
1. Delete all directories that are from the SVN repository (aka "starting fresh").
1. Commit changes with comment "deleted svn-related directories to prep for migration" for tracking.
1. Due to memory of the GH Actions server the migration needs to happen in two migrations (from experience, GH Actions failed due to insufficient memory):

## First Migration
1. Modify the file `\migration\last_revision.txt` to the number `6650` (the MFam_Restructure branch has a first revision at r6651)
1. Modify the `\.github\workflows\mirrorSVN.yml` file line 57, changing `$LAST_REVISION:HEAD` to `$LAST_REVISION:7774` (revision 7774 is an approximate half way point after a larger deletion of Projects-2016 and Projects-2019 folders)
1. Commit with messege "Changed for first half of migration". Push branch changes to the remote repo.
1. Go to [GitHub Actions](https://github.com/NOR-Codes-Stds/CBECC-COM/actions/workflows/mirrorSVN.yml) to manually run the workflow on the newly created branch by clicking the `Run workflow` dropdown and selecting your new branch.
1. Run time may be approximately 2-3 hours. After which a Pull Request will be created to merge the automated branch into your newly created migration branch.
1. Merge the PR into your created branch.

## Second Migration

1. Modify the `\.github\workflows\mirrorSVN.yml` file line 57, changing `$LAST_REVISION:7774` to `$LAST_REVISION:HEAD`
1. Commit with messege "Changed for second half of migration". Push branch changes to the remote repo.
1. Go to [GitHub Actions](https://github.com/NOR-Codes-Stds/CBECC-COM/actions/workflows/mirrorSVN.yml) to manually run the workflow on the newly created branch.
1. Run time may be approximately 2-3 hours. After which a Pull Request will be created to merge the automated branch into your newly created migration branch.
1. Merge the PR into your created branch.


## Verification
After the migration is merged into your new branch, we need to verify files are identical.
### `git_svn_repo_compare.py`
Given the input of your base repository locations from svn and git (aka this branch), this script will compare which files and directories are mis-matched from the other. 
1. edit the variables `git_repo_loc` and `svn_repo_loc` accordingly and run.

## Merge to main
If your new branch has successfully migration from Sourceforge, and you have verified the files, merge to main.

# Migration of SVN Branches
### Active SVN Branches Mirrored in GitHub
- `CBECC-25_EPlus24-1`
    - Branched from: r8598 (git commit hash `3dae2bd5a6cf667b4bf6292856196fb3ba105394`)
    - last_revision.txt start: `8599`
    - Git Branch Name: `2025_EPlus24-1`
- `CBECC_CRACEnhancement`
    - Branched from: r8627 (git commit hash `ab796895cfc3f2804049bdf621c2bd54a532f526`)
    - last_revision.txt start: `8628`
    - Git Branch Name: `CRAC-Enhancement`
- `CBECC-Com_MFam-VCHP3`
    - Branched from: r8617 (git commit hash `4063aa702e0588883e3a4d031247d9eebc26902e`)
    - last_revision.txt start: `8618`
    - Git Branch Name: `VCHP3`

### Create Branch
1. Create new branch using syntax: `git branch <GIT BRANCH NAME> <GIT COMMIT HASH>`
1. Modify the file `\migration\last_revision.txt` to the number `<LAST_REVISION.TXT START>`

### Add Automation in `main`
1. Create a new file in `main` called `mirrorSVN_<GIT BRANCH NAME>.yml`
1. Copy contents from a similar branch mirror, or from `mirrorSVN.yml`
1. Assure the following are changed:
    - Change the name to `name: Mirror SVN to Git - <GIT BRANCH NAME>`
    - Modify the entirety of the checkout step to:
        ```
        steps:
        - name: Checkout the <GIT BRANCH NAME> branch
        uses: actions/checkout@v4
        with:
            ref: <GIT BRANCH NAME>
            path: git-repo
        ```
    - Change the svn checkout url to `https://svn.code.sf.net/p/cbecc-com/code/branches/<SVN BRANCH NAME>/`
    - Change the `title` of the `Create Pull Request` Step to: `title: "Automated PR: Mirror SVN to Git - <GIT BRANCH NAME>"`
1. Run a manual activation of the workflow in GitHub:
    - Nagivate to the `Actions` tab in GitHub -> select the workflow `Mirror SVN to Git - <GIT BRANCH NAME>` -> click the dropdown `Run workflow` -> using the default `Branch: main`, click `Run workflow`
1. Once completed, a PR is created for the `<GIT BRANCH NAME>` which can be merged to the branch.

NOTE: GitHub Automation will be activated every night at 3am to capture any changes.

TODO: Think about automatically merging the PR if gets overwhelming.
