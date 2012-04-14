From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/5] cifs: asynchronous read support for uncached reads
Date: Fri, 13 Apr 2012 22:23:17 -0400
Message-ID: <1334370202-30711-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset converts cifs_iovec_read to issue and collect asynchronous
reads. This is primarily of use when a share is mounted with
forcedirectio, or strictcache and the client doesn't have an oplock for
the file being read.

This greatly increases read performance in this situation. Here are some
test results from my craptacular KVM test rig to samba. Here's the
command that I ran:

    $ dd if=./ddtest.out of=/dev/null bs=1M

Unpatched 3.4-rc2 kernel -- rsize is always capped at 16k here:
    1073741824 bytes (1.1 GB) copied, 97.6394 s, 11.0 MB/s

Patched 3.4-rc2 kernel -- rsize=1M:
    1073741824 bytes (1.1 GB) copied, 9.89869 s, 108 MB/s

Patched 3.4-rc2 kernel -- rsize=61440:
    1073741824 bytes (1.1 GB) copied, 13.4146 s, 80.0 MB/s

The first few patches abstract out and clean up some of the code. The
last one converts cifs_iovec_read to use the async read infrastructure.
This also lifts the artificial limit on the rsize.

Once this goes in, I'd like to begin discussing a transition to make
strictcache the default since that's what the protocol mandates. I'll
come up with a more detailed proposal for that in the near future.

I'd like to see this set go into the 3.5 merge window. Merging it into a
branch destined for linux-next soon in order to get it more testing
would be ideal though.

Jeff Layton (5):
  cifs: make cifs_readdata_alloc take a work_func_t arg
  cifs: abstract out function to marshal the iovec for readv receives
  cifs: add refcounting to cifs_readdata structures
  cifs: add wrapper for cifs_async_readv to retry opening file
  cifs: convert cifs_iovec_read to use async reads

 fs/cifs/cifsproto.h |    8 +-
 fs/cifs/cifssmb.c   |  120 +-------------
 fs/cifs/file.c      |  452 ++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 392 insertions(+), 188 deletions(-)

-- 
1.7.7.6
