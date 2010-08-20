From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/15] cifs: multiuser mount overhaul (try #3)
Date: Fri, 20 Aug 2010 15:31:56 -0400
Message-ID: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The last version of this patchset was sent back in April. At that time,
I called them "multisession mounts". This patchset is the next iteration
of that set, rebased against the current state of Steve's cifs-2.6 tree.

The reason for the name change is simple -- people seemed to be confused
by calling them "multisession mounts". Hopefully by calling them
"multiuser mounts", that confusion will be reduced.

There are really only a couple of changes since the last time I posted
these patches:

1) the mount option has been renamed to "multiuser"

2) the tcon_link container is now properly refcounted and timestamped.

This should allow for pruning of unused sessions, probably by scheduling
a workqueue task via kernel timer or something along those lines. The
patch to do that has not been implemented yet, but the pieces are all in
place and I don't expect it will be too tough to do. That can be
implemented later -- it's just that unused sessions in multiuser mounts
will linger around for now.

The patchset looks quite a bit different than the earlier one, primarily
because of this latter piece. Since references to the tcon_link are
taken by callers, they have to be put so this necessitates some error
handling cleanup.

The patchset seems to work for me so far. I ran it through a few hundred
passes of the Connectathon testsuite with unix extensions enabled and
disabled. It passed without issue and everything seems to work as
expected.

I'd like to see this go into the 2.6.37 release if there are no
objections. There will be merge conflicts between this and Metze's
mfsymlink work. We'll just need to determine which one goes in first to
know who needs to rebase to what.

Jeff Layton (15):
  cifs: eliminate redundant xdev check in cifs_rename
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

 fs/cifs/cifs_dfs_ref.c |   21 ++--
 fs/cifs/cifs_fs_sb.h   |   10 +-
 fs/cifs/cifsacl.c      |   46 ++++++--
 fs/cifs/cifsfs.c       |   22 ++--
 fs/cifs/cifsglob.h     |   39 +++++++
 fs/cifs/cifsproto.h    |    7 +-
 fs/cifs/connect.c      |  285 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/dir.c          |   95 +++++++++++-----
 fs/cifs/file.c         |  161 +++++++++++++++------------
 fs/cifs/fscache.c      |   13 +-
 fs/cifs/inode.c        |  241 ++++++++++++++++++++++++++++------------
 fs/cifs/ioctl.c        |   17 +---
 fs/cifs/link.c         |   55 ++++++----
 fs/cifs/misc.c         |    2 +-
 fs/cifs/readdir.c      |   45 ++++----
 fs/cifs/xattr.c        |   60 +++++++----
 16 files changed, 816 insertions(+), 303 deletions(-)

-- 
1.7.2.1
