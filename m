From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: allow cifs to do readpages larger and asynchronously (try #4)
Date: Thu,  1 Sep 2011 17:29:43 -0400
Message-ID: <1314912588-20435-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yet another readpages patchset...

The earlier ones caused a regression against very old servers such as
win9x-era servers. Those hosts have very small buffers, and tend to
throw errors when you request a read that's "too big".

This set solves this by essentially punting on doing any readahead at
all in that situation. With such a low rsize, it wouldn't likely be very
helpful anyway. We can revisit this decision later if someone presents a
common use case that would be helped by this.

Currently it tries to detect this situation by detecting when the
server's MaxBufferSize is less than a page. This is sort of a hack. The
server's maxBuf should have no bearing on how much the client can
receive in a read.

I don't see a better way to automatically detect this however as the
server doesn't seem to send anything that says "don't send me read
requests bigger than this". Suggestions are welcome if you have them.

This patchset uses the infrastructure added in the patchset to overhaul
the receive path to allow cifs to vastly increase the rsize. It also is
more efficient and does less copying as the data is read directly into
the pagecache.

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
 fs/cifs/cifssmb.c   |  357 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c   |  169 ++++++++++++++++---------
 fs/cifs/file.c      |  282 ++++++++++++++++------------------------
 5 files changed, 602 insertions(+), 234 deletions(-)

-- 
1.7.6
