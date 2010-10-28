From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cifs: convert tlink_tree to a rbtree
Date: Thu, 28 Oct 2010 07:33:37 -0400
Message-ID: <1288265619-20616-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The new multiuser mount code in CIFS uses a radix tree to track
tcon_link entries. The main reason for this is historical. The initial
implementation that I did used a radix tree with pointers to
cifsTconInfo structs.

I chose that because it was possible that a tcon could be in more than
one tree at a time. It became evident in later versions however that I
needed a separate tracking struct to handle the refcounting. Thus, the
tcon_link was born, but I kept the initial design of a radix tree.

We recently had a bit of a kerfuffle surrounding the use of radix trees
with IMA to track inodes. While we'll likely have considerably fewer
radix tree entries, it's not really the best choice here either. The
tcon_link struct will only ever be in one tlink_tree, so we can embed
a tracking structure inside it.

This patchset converts that code to use a rbtree instead. This should
be as fast or faster than using a radix tree. It also has the benefit of
not requiring memory allocations on insertion which simplifies the
error handling in those codepaths.

Jeff Layton (2):
  cifs: store pointer to master tlink in superblock
  cifs: convert tlink_tree to a rbtree

 fs/cifs/cifs_fs_sb.h |    6 +-
 fs/cifs/cifsfs.c     |    2 +-
 fs/cifs/cifsglob.h   |    3 +-
 fs/cifs/connect.c    |  191 +++++++++++++++++++++++++------------------------
 4 files changed, 103 insertions(+), 99 deletions(-)

-- 
1.7.2.3
