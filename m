From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH v2 0/4] cifs: cache invalidation fixes when cache=loose
Date: Wed, 30 Apr 2014 09:31:44 -0400
Message-ID: <1398864708-18185-1-git-send-email-jlayton@poochiereds.net>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second posting of this patchset. The end result of this set
should be indentical to the v1 set, but this fixes some problems in the
intermediate changes that would have introduced bugs for someone doing
a bisect.

This patchset fixes up some cache invalidation problems that can occur
when cache=loose. The main point is to ensure that we revalidate the
cache prior to satisfying a read.

At the same time, I added a fix for a potential problem that cropped up
with NFS a while back, and to which CIFS is also vulnerable.

This was originally reported by Tetsuo Handa, and as far as I can tell
this fixes his testcase, assuming that you also ensure that kernel
oplocks are enabled.

Given that we're late in the cycle, I'd like to see these merged for
v3.16 but getting them into -next soon would be good.

Jeff Layton (4):
  cifs: convert booleans in cifsInodeInfo to a flags field
  cifs: new helper function: cifs_revalidate_mapping
  cifs: fix potential races in cifs_revalidate_mapping
  cifs: revalidate mapping prior to satisfying aio_read request

 fs/cifs/cifsfs.c   | 24 ++++++++++++------
 fs/cifs/cifsfs.h   |  2 ++
 fs/cifs/cifsglob.h |  7 +++---
 fs/cifs/file.c     | 16 ++++++------
 fs/cifs/inode.c    | 71 ++++++++++++++++++++++++++++++++++++++++++------------
 5 files changed, 86 insertions(+), 34 deletions(-)

-- 
1.9.0
