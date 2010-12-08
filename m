From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cifs: CONFIG_CIFS_EXPERIMENTAL removal (try #2)
Date: Wed,  8 Dec 2010 10:03:41 -0500
Message-ID: <1291820625-20907-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second version of this patchset. The changes since the last
set are:

1) The patch to remove "/proc/fs/cifs/Experimental" did not remove the
deregistration of that file, which caused a warning on rmmod.

2) The patch to remove "/proc/fs/cifs/Experimental" now adds a new
module parameter so that people relying on it to allow zero-copy
writes with signing have a way to continue using that.

A modified description of the set follows...

The CONFIG_CIFS_EXPERIMENTAL KConfig option is the sort of thing that
gives distro packagers nightmares. The things that live under it are
impossible to predict for someone who isn't following development
upstream.

We usually want bleeding-edge distros like Fedora to turn on these sorts
of bleeding edge features. But, it's difficult for them to do so with any
confidence because so much of the code under this option is just plain
broken. If we have code that needs to be conditionally compiled in,
then it generally ought to be given its own KConfig option.

This patchset eliminates the CONFIG_CIFS_EXPERIMENTAL Kconfig option.
Code that currently resides under this option is either moved to being
built in by default or is removed from the kernel altogether.

The last patch in the series also removes /proc/fs/cifs/Experimental 
and replaces with with a bool module_parm that better describes what
it does.

I've tested this by building cifs.ko with a variety of different Kconfig
combinations and it seems to be OK. I've also played with the new
module option and it seems to work properly.

I think this patchset is appropriate for 2.6.38, though I won't object
if you want to merge it sooner.

Jeff Layton (4):
  cifs: remove export_ops code
  cifs: move "ntlmssp" and "local_leases" options out of experimental
    code
  cifs: remove CIFSSMBQueryReparseLinkInfo and CONFIG_CIFS_EXPERIMENTAL
  cifs: replace /proc/fs/cifs/Experimental with a module parm

 fs/cifs/Kconfig      |   13 ------
 fs/cifs/Makefile     |    2 +-
 fs/cifs/README       |   28 -------------
 fs/cifs/cifs_debug.c |   43 --------------------
 fs/cifs/cifsfs.c     |   13 ++----
 fs/cifs/cifsfs.h     |    4 --
 fs/cifs/cifsglob.h   |    2 +-
 fs/cifs/cifsproto.h  |    6 ---
 fs/cifs/cifssmb.c    |  109 +-------------------------------------------------
 fs/cifs/connect.c    |    4 --
 fs/cifs/export.c     |   67 ------------------------------
 fs/cifs/file.c       |    4 +-
 fs/cifs/sess.c       |  103 +++++++++++++++++++++-------------------------
 13 files changed, 56 insertions(+), 342 deletions(-)
 delete mode 100644 fs/cifs/export.c

-- 
1.7.3.2
