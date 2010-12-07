From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cifs: CONFIG_CIFS_EXPERIMENTAL removal
Date: Tue,  7 Dec 2010 09:23:51 -0500
Message-ID: <1291731835-1120-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The CONFIG_CIFS_EXPERIMENTAL KConfig option is the sort of thing that
gives distro packagers nightmares. The things that live under it are
impossible to predict for someone who isn't following development
upstream.

We usually want bleeding-edge distros like Fedora to turn on these sorts
of bleeding edge features, but it's difficult for them to do so with any
confidence because so much of the code under this option is just plain
broken. If we have code that needs to be conditionally compiled in,
then it generally ought to be given its own KConfig option.

This patchset eliminates the CONFIG_CIFS_EXPERIMENTAL Kconfig option.
Code that currently resides under this option is either moved to being
built in by default or is removed from the kernel altogether.

The last patch in the series also removes /proc/fs/cifs/Experimental --
a knob that's purpose has been unclear since I've been working on CIFS.

I've tested this by building cifs.ko with a variety of different Kconfig
combinations and it seems to be OK.

I think this patchset is appropriate for 2.6.38, though I won't object
if you want to merge it sooner.

Jeff Layton (4):
  cifs: remove export_ops code
  cifs: move "ntlmssp" and "local_leases" options out of experimental
    code
  cifs: remove CIFSSMBQueryReparseLinkInfo and CONFIG_CIFS_EXPERIMENTAL
  cifs: remove /proc/fs/cifs/Experimental

 fs/cifs/Kconfig      |   13 ------
 fs/cifs/Makefile     |    2 +-
 fs/cifs/README       |   12 -----
 fs/cifs/cifs_debug.c |   42 -------------------
 fs/cifs/cifsfs.c     |    8 ----
 fs/cifs/cifsfs.h     |    4 --
 fs/cifs/cifsglob.h   |    1 -
 fs/cifs/cifsproto.h  |    6 ---
 fs/cifs/cifssmb.c    |  109 +-------------------------------------------------
 fs/cifs/connect.c    |    4 --
 fs/cifs/export.c     |   67 ------------------------------
 fs/cifs/file.c       |    6 +-
 fs/cifs/sess.c       |  103 +++++++++++++++++++++-------------------------
 13 files changed, 52 insertions(+), 325 deletions(-)
 delete mode 100644 fs/cifs/export.c

-- 
1.7.3.2
