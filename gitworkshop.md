## Installing git

### For Linux

Git is probably available from your distribution.  If you are using
RHEL or CentOS, try:

    $ sudo yum install git

If you are using Ubuntu or Debian, try:

    $ sudo yum install git-core

### For OS X

The [git website](http://git-scm.org) provides an [installer for OS X][osx installer], but you will probably be better off installing [HomeBrew](http://brew.sh), a collection of open source software for OS X, and then running:

    $ sudo brew install git

* [git website](http://git-scm.org)
* [OSX Installer](http://git-scm.com/download/mac)
* [Homebrew](http://macports.org)

### For Windows

Download and install [msysgit][], which will provide you with:

- A `bash` shell,
- The command-line `git` tools, and
- OpenSSH

This will give you an environment largely similar to that available on
Linux and OS X.

[msysgit]: http://code.google.com/p/msysgit/

## Initial Configuration

Git will look for configuration information inside the per-repository
`.git/config` file and in the global `$HOME/.gitconfig`.  The `git config`
command modifies these configuration files, although you can also edit
them with your favorite text editor.  They are standard INI-style
configuration files:

    [alias]
            ci = commit
            co = checkout
            gl = log --pretty=oneline
    [user]
            name = Lars Kellogg-Stedman
            email = lars@seas.harvard.edu

Git provides a simple way to open your global configuration file in an
editor:

```
$ git config --global --edit          
```

### Name and email

Git needs to know who you are in order to correctly attribute your
changes.  You can configure your username and email address globally
like this:

    $ git config --global user.name "Lars Kellogg-Stedman"
    $ git config --global user.email "lars@seas.harvard.edu"

### Editor

For operations that require you to provide messages (such as commits
and tags), git will look in the following places to figure out which
editor to use:

- The `GIT_EDITOR` environment variable.
- The `core.editor` configuration option.
- The `VISUAL` environment variable.
- The `EDITOR` environment variable.

The `VISUAL` and `EDITOR` environment variables are traditionally used
by a variety of Unix tools to select your editor, so you may already
have these set to something sensible.

### Colors

Many git commands can produce colorized output.  Set `color.ui` to
`auto` to have git produce colorized output when writing to a
terminal:

    $ git config --global color.ui auto

### Aliases

Git allows you to configure aliases for commonly used commands and
options.   As you use git you may find yourself frequently typing in
the same commands and options; using aliases is a good way to save
yourself some typing.

Start with these:

    $ git config --global alias.co checkout
    $ git config --global alias.ci commit

Otherwise you will go insane during the rest of this workshop.

----
> **Exercise:** Install and configure git on your system.
>

----

## Getting Help

Most commands have built-in documentation you can access with the
  ``--help`` option::

```
git init --help
```

- Also available via ``man``, e.g::

```
man git-init
```

## Creating a Repository

A *repository* is what contains the change history for your project.

When interacting with git, you will typically have a set of
files called your *working directory*, inside which is a directory
called `.git` which is the actual *repository*.

### From an existing directory

Run `git init` to create a git repository inside an existing
directory:

    $ cd myproject
    $ git init
    Initialized empty Git repository in /home/lars/myproject/.git/

If you have a collection of files you would like to manage
using `git`, the process will look something like this:

    $ cd myproject
    $ git init
    Initialized empty Git repository in myproject/.git/
    $ git add .
    $ git commit -m 'initial import'

We'll talk about these commands in more detail later on.

### From scratch

With recent versions of git you can simply type:

    $ git init myproject
    Initialized empty Git repository in /home/lars/myproject/.git/

This will create the `myproject` directory and initialize a git
repository inside the directory.  In older versions of git it was
necessary to create the directory first:

    $ mkdir myproject
    $ cd myproject
    $ git init

### From a remote repository

Another way to create a git repository is to copy -- or *clone* it --
from somewhere else using the `git clone` command.  For example:

    $ git clone git://github.com/robparrott/git-workshop-sample1.git

Which should result in output along the lines of:

    Cloning into 'sample1'...
    remote: Counting objects: 3, done.
    remote: Compressing objects: 100% (2/2), done.
    remote: Total 3 (delta 0), reused 0 (delta 0)
    Receiving objects: 100% (3/3), done.

After the `clone` operation completes, you will have a directory
called `sample1` inside your current directory.

### Cloning This Repository

A quick way to get a git repo in place to work with is to simply clone this repository:

```
git clone http://github.com/robparrott/git-workshop
cd git-workshop
```

----
> **Exercise:** Create a simple repository from a directory, and add some files to it. Then clone that repository to another repository in a different directory on your system. Next clone the repository one more time, but as a "bare" repository using the `--bare` flag. Compare the contents of that directory to the contents of the `.git/` directory of the original repository. What's missing and what's the same?
>

----

## What's Here? What's Changed?

### `git status`

The `git status` command displays information about the state of files
in your working directory. If you were to run it inside the `sample1`
directory from the previous step, your output should look like this:

    $ cd sample1
    $ git status
    # On branch master
    nothing to commit (working directory clean)

Now try creating a new file:

    $ echo Hello world. > newfile.txt

And re-run `git status`:

    $ git status
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #	newfile.txt
    nothing added to commit but untracked files present (use "git add" to track)
    
The output shows that there is a new file in our working directory
that git knows nothing about ("untracked").  We will look at how to
add this file to the repository in the next section.

### `git ls-files`

To get a listing of all files in the repository, use `ls-files`

```
git ls-files
```

### `git diff`

The `diff` command shows the changes between different versions of
your files.  Without any additional parameters, it will show the
difference between your working copy and the repository:

    $ git diff

Edit `hello.py` so that it looks like this:

    #!/usr/bin/python

    import os
    import sys

    print 'Hello, Harvard!'

And re-run `git diff`:

    $ git diff
    diff --git a/hello.py b/hello.py
    index e42612d..a557bf7 100644
    --- a/hello.py
    +++ b/hello.py
    @@ -1,4 +1,7 @@
     #!/usr/bin/python
     
    -print 'Hello, world.'
    +import os
    +import sys
    +
    +print 'Hello, Harvard!'

The output of `git diff` shows where we have added or removed (or
modified) lines.

You can also use ``git diff`` to see the changes between arbitrary revisions of your project:

- Changes in working copy vs. previous commit::

```
git diff <commit>
```

- Changes between two previous commits:

```
git diff <commit1> <commit2>
```

### `git log`

Find out the commits to the repo, and their hash values by examining the log

```
git log
```

This shows the commit message and hash values.

### `git show` 

If you need more information, use `show`

```
git show
```

which shows not only logs, but also the changes themselves. Can be quite long.

### `git blame`

The `blame` command shows who is responsible for each line in a file.
For example, running `git blame` on the file `hello.py` yields:

    $ git blame hello.py
    ^af1bee6 (Lars Kellogg-Stedman 2012-06-08 12:42:06 -0400 1) #!/usr/bin/python
    ^af1bee6 (Lars Kellogg-Stedman 2012-06-08 12:42:06 -0400 2) 
    59e1d7d0 (Lars Kellogg-Stedman 2012-06-08 12:42:47 -0400 3) import os
    59e1d7d0 (Lars Kellogg-Stedman 2012-06-08 12:42:47 -0400 4) import sys
    59e1d7d0 (Lars Kellogg-Stedman 2012-06-08 12:42:47 -0400 5) 
    59e1d7d0 (Lars Kellogg-Stedman 2012-06-08 12:42:47 -0400 6) # Note that in Python 3 "print" becomes a function call
    59e1d7d0 (Lars Kellogg-Stedman 2012-06-08 12:42:47 -0400 7) # instead of a statement.
    ^af1bee6 (Lars Kellogg-Stedman 2012-06-08 12:42:06 -0400 8) print "Hello, world."
    ^af1bee6 (Lars Kellogg-Stedman 2012-06-08 12:42:06 -0400 9) 

The first column identifes the commit ID that last modified this line.
This is followed by the committer name, date, and time, and finally by
the actual file contents.

----
> **Exercise:** Clone this repository, and investigate it's files and history. Use `git status`, `git ls-files`,  `git log` or `git show`, and finally `git blame`. Change a file, and look at the change with `git diff`. When was this line (i.e. this text) written and by whom?
>

----

## Making Changes

### Adding Changes

You add changes to your repository with the `add` command.  Create a
file called `newfile.txt`:

    $ echo This is a test. > newfile.txt

And add this to the repository:

    $ git add newfile.txt

And now run `git status`:

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       new file:   newfile.txt
    #

This shows that the next time we run `commit`, this file will be added
to the repository. 

### Committing changes

The `commit` command records changes in your repository.  Let's commit
the changes we made in the previous step:

```
$ git commit -m 'Added a new file.'
1 files changed, 1 insertions(+), 0 deletions(-)
create mode 100644 newfile.txt
```

You can skip the _add_ step by referencing the file to commit:

```
git commit path/to/modified/file
```

or commit all non-new files at once:

```
git commit -a
```

### Moving files

Use the `mv` command to relocate or rename files:

    $ git mv newfile.txt newfile2.txt


### Removing files

Use the `rm` command:

    $ git rm newfile.txt

When the file is not up-to-date or you just need to forcefully remove it, use the `-f` forse option

    $ git rm -f annoying-file.txt


## Working with Remote Repositories

### Cloning a remote repository

Use the ``git clone`` command to check out a working copy of a remote
repository:

```
git clone http://github.com/robparrott/git-workshop
cd git-workshop
```

This is the first step in working with someone else's codebase.

``git clone`` will clone the remote repository to a new directory in your current directory named after the repository, unless you explicitly provide a name with the *DIRECTORY* argument.

This is analogous to Subversion's ``checkout`` operation.

You can only clone the top-level repository; unlike Subversion, git does not allow you to clone individual subtrees.

The repository itself is in `.git/` and that you have cloned the entire history of the repository as well as the current state.

Use the `git remote` command to view the current set of remotes:

```
git remote -v
origin  git@github.com:robparrott/git-workshop.git (fetch)
origin  git@github.com:robparrott/git-workshop.git (push)
```

Note that by default there was a remote named `origin` created which points to the cloned remote repository.

### Add a remote repository

Now you can add another repository beside the `origin` one. This could be your own copy on GitHub, when you don't have write access to the cloned repo.

```
git remote add mycopy git@github.com:robparrott/git-workshop2.git
```

You can have as many remotes as needed; you just need to keep track.

### Updating your working copy

Use ``git pull`` to update your local repository from the remote repository and merge changes into your working copy::

```
git pull [REPOSITORY [REFSPEC]]
```

* http://www.kernel.org/pub/software/scm/git/docs/v1.6.6.2/git-pull.html

``git pull`` by itself will pull changes from the remote repository defined by the ``branch.master.remote`` config option (which will typically be the repository from which you originally cloned your working copy).  If there are multiple remote repositories associated with your working copy, you can specify a repository (and branch) on the command line, e.g, to pull changes from the branch *master* at a remote named *origin*:

```
$ git pull origin master
```

### Pushing changes

Use ``git push`` to send your committed changes to a remote repository::

```
git push [REPOSITORY [REFSPEC]]

i.e.
git push mycopy master

```

* http://www.kernel.org/pub/software/scm/git/docs/v1.6.6.2/git-push.html

``git push`` by itself will push your changes to the remote repository
defined by the ``branch.master.remote`` config option (which will
typically be the repository from which you originally cloned your
working copy).  If there are multiple remote repositories associated
with your working copy, you can specify a repository (and branch) on the
command line, e.g, to push your changes to branch *master* at a remote
named *origin*:

```
$ git push origin master
```

If you attempt to push to a repository that is newer than your working
copy you will see an error similar to the following:

```
$ git push
To dottiness.seas.harvard.edu:repos/myproject
! [rejected]        master -> master (non-fast forward)
error: failed to push some refs to 'dottiness.seas.harvard.edu:repos/myproject'
```

To fix this, run ``git pull`` and deal with any conflicts.


## GitHub

[GitHub](http://github.com) has emerged as the place to be with open source code. It provides an incredible toolset to collaborate and work with source code, including features such as 

- Distributed coding and collaboration via "forking" and "pull requests"
- Source code browser and editor
- Easy diff analysis
- visualization of code history and networks
- Automation through "web-hooks" includinf automated testing and notifications

One of the most useful features is the ability to fork (i.e. make a complete copy) of any project's code into a repository of your own, then 

Login here:

- [http://github.com/](http://github.com/)

----
> **Exercise:** Create a brand new repository in GitHub that includes a README file. Using the GUI create an additional file in the repo with minimal contents. Once created, clone the repo locally. Make changes locally, including adding a new file, editing a file, and removing a file. Capture these into the index, commit, and then push to your GitHub repository. Confirm the changes are in place on GitHub.
>

----

## A Little Theory

### The repository

The actual repository in Git is contained is the root of the repository directory in `.git/`. It contains the entire history of the repository in a compact binary format, and allows you to very quickly change to any version of the repository, or to any branch. 

When you clone or push a repository, it is this data that is transferred and manipulated. 

Often with incremental updates, only differences are transferred, which makes git a very efficient transfer protocol/

### The working copy

All the files that you work with and edit are called the _working copy_, but are not the actual git repository. They can all deleted and you can still work with the repository. These files and their changes only become part of the repositiry after being added to the _index_ and them commited.

### The Index

Git is not really just like Subversion (or most other version control solutions). It uses an additional stage to allow you to do distrbuted version control: the _Index_.

- The *index* is a staging area between your working copy and your local
  repository.
- ``git add`` adds files to the index
- ``git commit`` commits files from the
  index to the repository.

In addition:

- ``git diff`` is the difference between your working copy and the index.
- ``git diff HEAD`` is the difference between your working copy and the
  local repository.
- ``git diff --cached`` is the difference between the index and the local
  repository.

Refer to this illustration to see how the index fits in:

![git-transport.png](./images/git-transport.png)  
(This image used with permission.)

----
> **Exercise:** Fork on GitHub this repository into your own, then clone that locally. Setup a new remote named "upstream" that tracks the original repository, keeping your copy under the name "origin". Make a trivial change to this repository, then push that change back to your copy or "fork" on GitHub. Once the change is pushed, use the GitHub GUI to create a "Pull Request" (PR) against the original repository. 
>

----

## Tags & Branches

### Create a tag

Create a tag:

```
git tag [-a] TAGNAME
```

- Creates a *lightweight* tag (an alias for a commit object)
- Add ``-a`` to create an annotated tag (i.e., with an associated message)
- Also possible to create cryptographically signed tags

See: http://www.kernel.org/pub/software/scm/git/docs/v1.6.6.2/git-tag.html

### Pushing a tag

Once you've created a tag, you need to push it to a remote repository for it to be used and released. Use git push:

```
git push --tags
```


### Listing tags

```
git tag
```

Information about a specific tag:
```
git tag -v TAGNAME
```

### Listing branches:

```
  git branch -av
```

The `-av` option is more verbose, and also includes any remote branches.

### Creating branches

Create a branch rooted at *START*:

```
git branch BRANCHNAME [START]
```

See http://www.kernel.org/pub/software/scm/git/docs/v1.6.6.2/git-branch.html

If you omit *START*, the branch is rooted at your current HEAD.

### Changing branches

Switch to a branch:

```
git checkout BRANCHNAME
```

Create a branch rooted at *START* and switch to it::

```
git checkout -b BRANCHNAME [START]
```

For example, you want to enhance your code with some awesome
experimental code.  You create a new *workshop* branch and switch
to it:

```
$ git checkout -b workshop
```

You make some changes, and when things are working you commit your branch:

```
$ git commit -m 'made some awesome changes' -a
```

And then merge it into the master branch::

```
     $ git checkout master
     $ git merge seas-workshop-dev
     Updating 1288ed3..33e4a4c
     Fast-forward
      version-control.rst |    2 ++
      1 files changed, 2 insertions(+), 0 deletions(-)
```
 
### Pushing branches

When you create a local branch and you want to push that branch to a remote repository, you need to specify the name of the remote branch to push to, and usually create it beforehand. This is done using the `-u` flag:

```
git push origin -u workshop
```

This should create a new branch remotyely and push this branch to it. An entry in your local git config will be created to remember this mapping.

### Deleting branches

To delete a local branch, use the `-D` option:

```
git branch -D workshop
```

If you want to remove a remote branch, you need to push to the branch specifying deletion. Newer versions of git use the `--delete` option

```
git push origin --delete workshop
```

while older version use the syntax

```
git push origin :workshop
```

----
> **Exercise:** Using a repository from a previous exercise, tag your current version as a new tag. Next create a local branch and checkout that branch. Make changes on that branch, and commit them locally. Next push those changes to the remote. Confirm that works, then checkout your local master, mefrge the changes from the local branch, and push the master. Once that's done, delete both the local and remote branches.
>

----

## Exercise: GitHub Workflow

>This extended exercise demonstrates using GitHub to do distributed development.
>
>Git + GitHub makes code review very easy. Instead of pushing changes to master, create a new branch, then push that branch to a remote remote branch of the same name.
>
Then in GitHub, create a "Pull Request." Ask a collaborator to review that Pull Request. If you are disclined ad follow this simpe process for every changeset, you get code review for free. 
>
>To start, create a local repository and populate it with some content:
>
>```
>$ mkdir tutorial_code
>$ cd tutorial_code
>
># create a git repository here
>$ git init
>
># add some files 
>$ git add (my files)
>
># where are we ?
>$ git status
>
># commit those files
>$ git commit -m "my first checkin"
>
># Make some changes. Let's see 
>#  what's changed
>$ git diff
>$ git commit -m "more changes"
>```
>
>Now that you have a basic repo, we want push it to GitHub. First, we'll need to create a repository in GitHub, and the following the directions, setup the remote properly. When done, push it.
>
>```
># create a repository in GitHub or 
>#  elsewhere, then setup a "remote"
>$ git remote add origin [url]
>
># Now, let's push those changes remotely
>$ git push origin master
>```
>
>### Branch and Merge
>
>Now let's do some experimental work on a different branch:
>
>```
># I want to make some more changes, so
>#   create a branch track them
>$ git checkout -b my_new_feature_branch
>
># Make some changes.
>
># What has changed?
>$ git status
>$ git diff somefile.code
>
># make some more changes ...
>
># add the changes, then comit
>$ git add [files]
>$ git commit -m "my new feature"
>
># Now push those changes to a new branch
>#  on the remote server
>$ git push origin -u my_new_feature_branch
>```
>
>Once the branch is pushed, go to GitHub and create a Pull Request by browsing to the branch and clicking a button.
>
>Collaborators on the repo will need notified by email, and can view changes, and merge if they approve.
>
>### Fork and Merge
>
>Now do the same, but instead of branching, use GitHub forking to make the changes. Have someone else fork your repo in GitHub, and they will make changes to their copy of your repo. Once their changes are checked back in, have them create a Pull Request, and merge.
>

## When Things Go Wrong

### Redoing previous commit

If immediately after you commit changes to a repository you realize
you've made a mistake, you can replace the previous commit with a new one
using the `--amend` option to the `commit` command.

For example, let's say that after committing some changes to a
website...

    $ git commit -m "use new stylesheets in all of our pages"

...you realized that you had forgotten to actually add the stylesheets
as part of the commit.  You can type:

    $ git add css
    $ git commit --amend

This will replace the previous commit with a new one containing both
the changes from the previuos commit and your most recent changes.

### Reset

The `reset` command will **discard history** from your project and
reset your repository to a prior state. 

Use the ``git reset`` command to "undo" an add operation::

```
git reset HEAD
```

This resets the index but leaves your working directory untouched. You
can also use `git reset` to revert to a previous commit, using the hash or a tag name; read the documentation for more information.

### Revert

The `revert` command will generate a new commit that reverses the
changes caused by a previous commit.

## Conflicts

A conflict occurrs when two people make overlapping changes.

- Detected when you attempt to update your working copy via ``git pull``.
- You may discard your changes, discard the repository changes, or attempt to correct things manually.

If you attempt to pull in changes that conflict with your working tree, you will see an error similar to the following:

```
$ git pull
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 2), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From /Users/lars/projects/version-control-workshop/work/repo2
   4245cb6..84f1112  master     -> origin/master
Auto-merging README
CONFLICT (content): Merge conflict in README
Automatic merge failed; fix conflicts and then commit the result.
```
   
To resolve the conflict manually:

- Edit the conflicting files as necessary.

To discard your changes (and accept the remote repository version)::

- run ``git checkout --theirs README``

To override the repository with your changes:

- run ``git checkout --ours README``

When you complete the above tasks:
 
- add the files with ``git add``
- commit the changes with ``git commit``.

Once your local repository is in good working order, you can push the changes back to a remote repository.


## Merging and Rebasing

(TBD)

## Integrating w/ Subversion

You can use git as your Subversion client.  This gives you many of the benefits of a DVCS while still interacting with a Subversion repository.

### Checking out from subversion

Cloning a remote subversion repository:

```
git svn clone [ -s ] REPO_URL
```


   The ``-s`` flag informs git that your Subversion repository uses the
   recommended repository layout (i.e., that the top level of your
   repository contains ``trunk/``, ``tags/``, and ``branches/``
   directories).  The ``HEAD`` of your working copy will track the trunk.

   This instructs git to clone the *entire* repository, including the
   complete revision history. This may take a while for repositories with a
   long history.  You can use the ``-r`` option to request a partial
   history.  From the man page::

      -r <ARG>, --revision <ARG>
          Used with the fetch command.

          This allows revision ranges for partial/cauterized history to be
          supported. $NUMBER, $NUMBER1:$NUMBER2 (numeric ranges),
          $NUMBER:HEAD, and BASE:$NUMBER are all supported.

          This can allow you to make partial mirrors when running fetch; but
          is generally not recommended because history will be skipped and
          lost.

### Commiting

Committing your changes back to the Subversion repository:

```
git svn dcommit
```

Before you push your changes to the Subversion repository you need to first commit any pending modifications to your local repository. Otherwise, git will complain:

```
$ git svn dcommit
Cannot dcommit with a dirty index.  Commit your changes first, or stash them with `git stash'.
 at /usr/libexec/git-core/git-svn line 491

 To fix this, commit your changes::

$ git commit -m 'a meaningful commit message' -a
```

And then send your changes to the Subversion repository:

```
$ git svn dcommit
Committing to https://source.seas.harvard.edu/svn/version-control-workshop/trunk ...
 M    seealso.rst
Committed r38
 M    seealso.rst
r38 = 03254f2c0b3d5e068a87566caef84454558b85b0 (refs/remotes/trunk)
No changes between current HEAD and refs/remotes/trunk
Resetting to the latest refs/remotes/trunk
Unstaged changes after reset:
 M  git.rst
 M    git.rst
Committed r39
 M    git.rst
r39 = d1f884a3f945f6083541e28ab7a09ca8efc6343b (refs/remotes/trunk)
No changes between current HEAD and refs/remotes/trunk
Resetting to the latest refs/remotes/trunk
```

### Updating from Subversion

Updating your working copy from the Subversion repository::

```
git svn rebase
```

   As with ``git svn dcommit``, you must have a clean working copy before
   running the ``rebase`` command.


## About this document

The complete source for this document is available at
<http://github.com/robparrott/git-workshop>.

This document was written using [markdown][], a lightweight markup language.  
The markdown source for this document is available [here][source].

[source]: gitworkshop.txt
[markdown]: http://daringfireball.net/projects/markdown/

<!-- vim: set ft=markdown : -->

