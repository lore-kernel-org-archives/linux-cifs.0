From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/7] cifs: asynchronous writepages support (try #4)
Date: Thu, 19 May 2011 16:22:51 -0400
Message-ID: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the fourth version of this set. The main changes since the 3rd set are:

- it's been rebased on top of Steve's current master branch

- testing showed that find_get_pages_tag would only return a maximum of
  256 pages, which limited the wsize to 1M with 4k PAGE_CACHE_SIZE. So,
  the code now calls find_get_pages_tag multiple times until it gets all
  that it wants, it hits the end of the file, or no more dirty pages are
  present in the range.

- the default wsize is now 1M, but it will negotiate downward depending
  on what the server supports. It can be set as high as ~16M, but some
  cursory testing didn't show any real improvement in throughput with
  a larger wsize than 1M (YMMV of course).

- I dropped the patch to make the maxmpxcount be respected. I think that
  needs more careful consideration and is probably worthy of a separate
  patchset in its own right.

At this point, I believe this set is ready for merge for 2.6.40. Once it
goes in, I'll plan to spin up a patch to clarify the wsize= option in
the mount.cifs manpage.

Once this has had some soak time, I'll look at async readpages support
as well, and maybe consider changing writepage to use an async call.

Jeff Layton (7):
  cifs: consolidate SendReceive response checks
  cifs: make cifs_send_async take a kvec array
  cifs: don't call mid_q_entry->callback under the Global_MidLock
  cifs: add ignore_pend flag to cifs_call_async
  cifs: add cifs_async_writev
  cifs: convert cifs_writepages to use async writes
  cifs: clean up wsize negotiation and allow for larger wsize

 fs/cifs/cifsglob.h  |    6 +-
 fs/cifs/cifsproto.h |   28 +++++-
 fs/cifs/cifssmb.c   |  242 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/connect.c   |   99 +++++++++++++++------
 fs/cifs/file.c      |  241 +++++++++++++++++++++------------------------------
 fs/cifs/netmisc.c   |    2 +-
 fs/cifs/transport.c |  196 ++++++++++++-----------------------------
 7 files changed, 498 insertions(+), 316 deletions(-)

-- 
1.7.4.4
