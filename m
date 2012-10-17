From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/7] cifs: second pile of cleanups for cifsacl
Date: Wed, 17 Oct 2012 14:08:56 -0400
Message-ID: <1350497343-7155-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is a second pile of cleanups for the cifsacl code. This
should be applied on top of the set I sent yesterday, which in turn
should go on top of the patch I sent yesterday to fix the buffer
overruns in cifs. The meat of this set is in the 6th patch which is
largely responsible for the awesome diffstat.

I've tested this set and it seems to work as expected. With the merge
window closed, this is probably best suited for 3.8, but getting it into
linux-next soon would be ideal.

Steve, all of these patches are in my cifs-next branch if you just want
to pull from there...

Jeff Layton (7):
  cifs: make cifs_copy_sid handle a source sid with variable size
    subauth arrays
  cifs: redefine NUM_SUBAUTH constant from 5 to 15
  cifs: fix the format specifiers in sid_to_str
  cifs: remove uneeded __KERNEL__ block from cifsacl.h
  cifs: simplify id_to_sid and sid_to_id mapping code
  cifs: avoid extra allocation for small cifs.idmap keys
  cifs: don't override the uid/gid in getattr when cifsacl is enabled

 fs/cifs/cifsacl.c   | 569 +++++++++++-----------------------------------------
 fs/cifs/cifsacl.h   |  44 ++--
 fs/cifs/cifsfs.c    |   1 -
 fs/cifs/cifsproto.h |   1 -
 fs/cifs/inode.c     |   7 +-
 5 files changed, 145 insertions(+), 477 deletions(-)

-- 
1.7.11.7
