From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: allow cifs to do readpages larger and asynchronously (try #6)
Date: Tue, 11 Oct 2011 08:35:22 -0400
Message-ID: <1318336527-13648-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Just some small changes since the last patchset to fix problems noticed
by Pavel Shilovsky:

- the max rsize when posix extensions are not in force was too large
  by 1 byte

- some of the debug printks in cifs_readv_receive were using the wrong
  width specifier for size_t and ssize_t (%lu instead of %zu)

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

This set and the preceding overhaul of the receive codepath are also
available in the cifs-3.2 branch of my git tree on git.samba.org:

    git:    git://git.samba.org/jlayton/linux.git
    gitweb: http://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/cifs-3.2

Jeff Layton (5):
  cifs: fix protocol definition for READ_RSP
  cifs: add cifs_async_readv
  cifs: convert cifs_readpages to use async reads
  cifs: allow for larger rsize= options and change defaults
  cifs: tune bdi.ra_pages in accordance with the rsize

 fs/cifs/cifspdu.h   |    4 +-
 fs/cifs/cifsproto.h |   24 ++++
 fs/cifs/cifssmb.c   |  356 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c   |  167 +++++++++++++++---------
 fs/cifs/file.c      |  293 ++++++++++++++++++------------------------
 5 files changed, 609 insertions(+), 235 deletions(-)

-- 
1.7.6.4
