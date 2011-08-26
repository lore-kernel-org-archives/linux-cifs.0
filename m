From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: allow cifs to do readpages larger and asynchronously
Date: Fri, 26 Aug 2011 15:18:13 -0400
Message-ID: <1314386298-27424-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset uses the infrastructure added in the first set to allow
cifs to vastly increase the rsize. It also is more efficient and does
less copying as the read of the data is all done directly into the
pagecache.

Additionally, readpages is now done asynchronously with this set.
cifs_readpages just puts the pages in the cache, and fires off the
reads and returns. Eventually, when the reads complete, the pages
are marked Uptodate, unlocked, etc.

With this set in place, I see a dramatic increase in performance
for buffered read calls. On a simple dd test of 100M or so:

prepatch, with 16k rsize:
104857600 bytes (105 MB) copied, 5.08086 s, 20.6 MB/s

postpatch, with 1M rsize:
104857600 bytes (105 MB) copied, 1.2141 s, 86.4 MB/s

Other tests show similar results. These results are from my craptacular
KVM-based test rig. I expect that the performance boost will be even
more dramatic on real hardware or on higher-latency connections.

Steve, I'd like to see both of these sets go into 3.2 if at all
possible. Both of these sets should be bisectable, so committing them
in order is recommended.

Jeff Layton (5):
  cifs: fix protocol definition for READ_RSP
  cifs: add cifs_async_readv
  cifs: convert cifs_readpages to use async reads
  cifs: allow for larger rsize= options and set default to 1M
  cifs: don't discard readahead pages that are beyond EOF

 fs/cifs/cifspdu.h   |    4 +-
 fs/cifs/cifsproto.h |   23 ++++
 fs/cifs/cifssmb.c   |  313 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c   |  127 ++++++++++++---------
 fs/cifs/file.c      |  272 ++++++++++++++++----------------------------
 5 files changed, 509 insertions(+), 230 deletions(-)

-- 
1.7.6
