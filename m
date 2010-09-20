From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/15] cifs: multiuser mount overhaul (try #4)
Date: Mon, 20 Sep 2010 16:01:29 -0700
Message-ID: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the fourth attempt at a patchset to overhaul the multiuser CIFS
mount capability in the kernel. The main difference from the last is the
addition of a recurring workqueue job to close out idle tcons (Tree
Connects). The patchset has also been rebased on top of a very recent
pull of Steve's tree including the patches from Metze to implement
mfsymlinks.

Many people may be aware that CIFS has a MultiuserMount switch in
/proc/fs/cifs. This code basically works, but it has a number of
shortcomings that make it impractical to deploy. This patchset is
a redesign of that concept from scratch that allows CIFS to use multiple sessions
to the same server, establish them on an as-needed basis and tear them
down when they've been idle for a period of time.

Because we cannot prompt for passwords from the kernel, this code is
currently limited to using krb5 authentication. Igor Druzhinin has done
some work as a Google Summer of Code project to allow the stashing of
username/password in the kernel keyring. Once that code is ready, we'll
be able to extend this to other sec= types as well.

The patchset is large, but I've done my best to split it up into a
logical set of bisectable changes. Some of the patches touch the same
areas of code as earlier ones. This increases the amount of "churn" but
I think it makes a more logical sequence of changes.

At this point, I think this code is ready for merge. I'd like to see it
in 2.6.37. Comments and review are welcome.

Jeff Layton (15):
  cifs: add tcon field to cifsFileInfo struct
  cifs: make various routines use the cifsFileInfo->tcon pointer
  cifs: fix handling of signing with writepages
  cifs: add function to get a tcon from cifs_sb
  cifs: temporarily rename cifs_sb->tcon to ptcon to catch stragglers
  cifs: add cifs_sb_master_tcon and convert some callers to use it
  cifs: have cifs_new_fileinfo take a tcon arg
  cifs: add refcounted and timestamped container for holding tcons
  cifs: have cifsFileInfo hold a reference to a tlink rather than tcon
    pointer
  cifs: have find_readable/writable_file filter by fsuid
  cifs: fix cifs_show_options to show "username=" or "multiuser"
  cifs: add routines to build sessions and tcons on the fly
  cifs: on multiuser mount, set ownership to
    current_fsuid/current_fsgid
  cifs: add "multiuser" mount option
  cifs: implement recurring workqueue job to prune old tcons

 fs/cifs/cifs_dfs_ref.c |   21 ++--
 fs/cifs/cifs_fs_sb.h   |   11 +-
 fs/cifs/cifsacl.c      |   46 +++++--
 fs/cifs/cifsfs.c       |   22 ++--
 fs/cifs/cifsglob.h     |   40 ++++++
 fs/cifs/cifsproto.h    |    8 +-
 fs/cifs/connect.c      |  339 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/dir.c          |   97 ++++++++++-----
 fs/cifs/file.c         |  161 +++++++++++++-----------
 fs/cifs/fscache.c      |   13 +-
 fs/cifs/inode.c        |  213 +++++++++++++++++++++++--------
 fs/cifs/ioctl.c        |   17 +--
 fs/cifs/link.c         |   88 ++++++++-----
 fs/cifs/misc.c         |    2 +-
 fs/cifs/readdir.c      |   45 ++++---
 fs/cifs/xattr.c        |   60 ++++++---
 16 files changed, 888 insertions(+), 295 deletions(-)

-- 
1.7.2.3
