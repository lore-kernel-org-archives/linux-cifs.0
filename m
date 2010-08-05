From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] cifs: error handling cleanups
Date: Thu,  5 Aug 2010 10:18:33 -0400
Message-ID: <1281017916-31380-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is a set of error handling cleanup patches. They shouldn't
make any changes in behavior themselves, but are some prerequisite
patches for the multiuser mount patchsets I'm working on. Please
consider them for 2.6.36.

The patches are all in the cifs-2.6.36 branch of my git tree:

http://git.kernel.org/?p=linux/kernel/git/jlayton/linux.git;a=shortlog;h=refs/heads/cifs-2.6.36

Jeff Layton (3):
  cifs: clean up error handling in cifs_mknod
  cifs: consolidate error handling in several functions
  cifs: eliminate redundant xdev check in cifs_rename

 fs/cifs/dir.c   |  167 +++++++++++++++++++++++++++----------------------------
 fs/cifs/file.c  |    3 +-
 fs/cifs/inode.c |   30 +++-------
 3 files changed, 93 insertions(+), 107 deletions(-)

-- 
1.7.2
