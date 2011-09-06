From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: allow cifs to do readpages larger and asynchronously (try #5)
Date: Tue,  6 Sep 2011 10:27:16 -0400
Message-ID: <1315319241-21637-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The changes since the last patchset are fairly minor. It occurs to me
that it would be better to simply have the default rsize set to a low
value when the server's MaxBufferSize is very small, instead of making
that a hard maximum value. That way, when users know that their server
can support a larger rsize they can force the value higher.

There's also a more subtle change -- when there is a problem with the
read that occurs after adding the page to the pagecache, the page is no
longer removed from the cache. It's possible that in the intervening
period that another task has found that page and is waiting on it, and
might become discombobulated if it's suddenly removed from the cache.

Instead, the code just leaves the page in place and puts it on the LRU
list, but doesn't set it uptodate. This more closely parallels what
other filesystems do in their readpages operations.

This patchset uses the infrastructure added in the receive path overhaul
to allow cifs to vastly increase the rsize. It also is more efficient
and does less copying as the data is read directly into the pagecache.

Additionally, readpages is now done asynchronously with this set.
cifs_readpages just puts the pages in the cache, fires off the reads and
returns. Eventually, when the reads complete, a workqueue job is queued
that will mark the pages uptodate and unlock them.

With this set in place, I see a dramatic increase in performance for
buffered read calls. On a simple dd test of a 1GB file to /dev/null:

prepatch, with 16k rsize:
1073741824 bytes (1.1 GB) copied, 47.2119 s, 22.7 MB/s

postpatch, with 1M rsize:
1073741824 bytes (1.1 GB) copied, 11.1602 s, 96.2 MB/s

postpatch, with 60k rsize:
1073741824 bytes (1.1 GB) copied, 12.5183 s, 85.8 MB/s

Other tests show similar results. These results are from my craptacular
KVM-based test rig. I expect that the performance boost will be even
more dramatic on real hardware or on higher-latency connections.

Steve, I'd like to see both of these sets go into 3.2 if at all
possible. Both of these sets should be bisectable, so committing them in
order is highly recommended.

Jeff Layton (5):
  cifs: fix protocol definition for READ_RSP
  cifs: add cifs_async_readv
  cifs: convert cifs_readpages to use async reads
  cifs: allow for larger rsize= options and change defaults
  cifs: tune bdi.ra_pages in accordance with the rsize

 fs/cifs/cifspdu.h   |    4 +-
 fs/cifs/cifsproto.h |   24 ++++
 fs/cifs/cifssmb.c   |  356 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c   |  165 +++++++++++++++---------
 fs/cifs/file.c      |  293 ++++++++++++++++++------------------------
 5 files changed, 608 insertions(+), 234 deletions(-)

-- 
1.7.6
