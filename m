From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cifs: cache invalidation fixes for cifs with cache=loose
Date: Mon, 31 Mar 2014 13:50:05 -0400
Message-ID: <1396288209-27328-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset fixes up some cache invalidation problems that can occur
when cache=loose. The main point is to ensure that we revalidate the
cache prior to satisfying a read.

At the same time, I added a fix for a potential problem that cropped up
with NFS a while back, and to which CIFS is also vulnerable.

This was originally reported by Tetsuo Handa, and as far as I can tell
this fixes his testcase, assuming that you also ensure that kernel
oplocks are enabled.

Jeff Layton (4):
  cifs: convert booleans in cifsInodeInfo to a flags field
  cifs: new helper function: cifs_revalidate_mapping
  cifs: fix potential races in cifs_revalidate_mapping
  cifs: revalidate mapping prior to satisfying aio_read request

 fs/cifs/cifsfs.c   | 21 +++++++++++++---
 fs/cifs/cifsfs.h   |  2 ++
 fs/cifs/cifsglob.h |  6 +++--
 fs/cifs/file.c     | 16 ++++++------
 fs/cifs/inode.c    | 71 ++++++++++++++++++++++++++++++++++++++++++------------
 5 files changed, 86 insertions(+), 30 deletions(-)

-- 
1.9.0
