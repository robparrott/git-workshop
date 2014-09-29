## Installing git

### For Linux

Git is probably available from your distribution.  If you are using
RHEL or CentOS, try:

    $ sudo yum install git

If you are using Ubuntu or Debian, try:

    $ sudo yum install git-core

### For OS X

The [git website][] provides an [installer for OS X][osx installer],
but you will probably be better off installing [MacPorts][], a
collection of open source software for OS X, and then running:

    $ sudo port install git-core

[git website]: http://git-scm.org
[osx installer]: http://git-scm.com/download/mac
[macports]: http://macports.org

### For Windows

Download and install [msysgit][], which will provide you with:

- A `bash` shell,
- The command-line `git` tools, and
- OpenSSH

This will give you an environment largely similar to that available on
Linux and OS X.

[msysgit]: http://code.google.com/p/msysgit/

## Initial configuration

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

    $ git config --global --edit
          
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

## Creating a repository

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
    Initialized empty Git repository in /home/lars/myproject/.git/
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

## What's changed?

### git status

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

### git diff

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

### git blame

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

## Adding changes

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

## Committing changes

The `commit` command records changes in your repository.  Let's commit
the changes we made in the previous step:

    $ git commit -m 'Added a new file.'
     1 files changed, 1 insertions(+), 0 deletions(-)
     create mode 100644 newfile.txt

## Removing files

    $ git rm newfile.txt

## When things go wrong

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

### Revert

The `revert` command will generate a new commit that reverses the
changes caused by a previous commit.

## Tags

## Managing branches

### Merging and rebasing

## Interacting with remote repositories

### Cloning a remote repository

### Add a remote repository

### Pushing your changes

## About this document

The complete source for this document is available at
<http://github.com/robparrott/git-workshop>.

This document was written using [markdown][], a lightweight markup language.  
The markdown source for this document is available [here][source].

[source]: gitworkshop.txt
[markdown]: http://daringfireball.net/projects/markdown/

<!-- vim: set ft=markdown : -->

