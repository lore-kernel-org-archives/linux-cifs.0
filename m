From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cifs: allow cifs to do readpages larger and asynchronously (try #2)
Date: Mon, 29 Aug 2011 07:40:32 -0400
Message-ID: <1314618036-5812-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When testing against windows servers, I ran into a couple of bugs in
the first patchset. This set fixes them and consolidates a couple of
the patches.

It also changes the code to add pages to the pagecache in a more
conventional fashion. It adds them to the cache after doing the reads
instead of before. In testing I didn't see much difference in
performance, and it's a more standard way to handle the pages. If we
later find that it helps performance to do it the other way, it's not
too hard to change.

This patchset uses the infrastructure added in the first set to allow
cifs to vastly increase the rsize. It also is more efficient and does
less copying as the data is read directly into the pagecache.

Additionally, readpages is now done asynchronously with this set.
cifs_readpages just fires off the reads and returns. Eventually, when
the reads complete, the pages are put in the cache, marked Uptodate, and
unlocked.

With this set in place, I see a dramatic increase in performance for
buffered read calls. On a simple dd test of a 1GB file to /dev/null:

prepatch, with 16k rsize:
1073741824 bytes (1.1 GB) copied, 47.4432 s, 22.6 MB/s

postpatch, with 1M rsize:
1073741824 bytes (1.1 GB) copied, 12.9057 s, 83.2 MB/s

postpatch, with 60k rsize:
1073741824 bytes (1.1 GB) copied, 16.2091 s, 66.2 MB/s

Other tests show similar results. These results are from my craptacular
KVM-based test rig. I expect that the performance boost will be even
more dramatic on real hardware or on higher-latency connections.

Steve, I'd like to see both of these sets go into 3.2 if at all
possible. Both of these sets should be bisectable, so committing them in
order is highly recommended.

Jeff Layton (4):
  cifs: fix protocol definition for READ_RSP
  cifs: add cifs_async_readv
  cifs: convert cifs_readpages to use async reads
  cifs: allow for larger rsize= options and change defaults

 fs/cifs/cifspdu.h   |    4 +-
 fs/cifs/cifsproto.h |   23 ++++
 fs/cifs/cifssmb.c   |  346 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c   |  139 ++++++++++++---------
 fs/cifs/file.c      |  251 ++++++++++++-------------------------
 5 files changed, 531 insertions(+), 232 deletions(-)

-- 
1.7.6
