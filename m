From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/7] cifs: asynchronous writepages support (try #2)
Date: Wed, 13 Apr 2011 07:43:07 -0400
Message-ID: <1302694994-8303-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second version of this set. There are a number of changes
from the first one:

- it now respects the max_pending limit on writes.

- the cifs_writedata struct is now variable-sized so it can handle
  arrays of pages of more or less any size. This allows us to
  increase the wsize up to much larger values.

- and there's a patch that cleans up the wsize negotiation. The
  new default with this code will be 124k writes, but it can be
  set much larger if the server supports large POSIX writes

This patchset changes the CIFS code to do asynchronous writes in
writepages(). It uses the asynchronous call infrastructure that was
added to handle SMB echoes. The idea here is to have the kernel
issue a write request and then have it handle the reply asynchronously.

For now, this just changes the writepages codepath. Once the patchset
has had a bit more refinement and testing, I'll see about changing some
of the other codepaths (writepage(), for instance).

I'm not 100% thrilled with this approach overall -- I think we do need
to handle writes asynchronously, but the fact that we're using our own
writepages routine kind of hamstrings this code.

Another possible approach here would be to move to more page-based I/O
like NFS has. Have writepage() set up the pages for writeback and
coalesce them together as it goes, and then issue the write all at
once. That would also allow us to handle larger write sizes than 56k.

Obviously, that's a much larger project to cobble together however. Much
of this code would still be applicable if we did decide to go that route
eventually.

I'm targeting this patchset for 2.6.40. I've tested this and it seems
to work, but have not yet done any significant perf testing. Pavel
tested an earlier version of this set and said he saw about a 20%
increase in sequential write performance. Not sure if that will hold
now that we're respecting the max_pending value.

Review and test feedback would be welcome.

Jeff Layton (7):
  cifs: consolidate SendReceive response checks
  cifs: make cifs_send_async take a kvec array
  cifs: don't call mid_q_entry->callback under the Global_MidLock
  cifs: add ignore_pend flag to cifs_call_async
  cifs: add cifs_async_writev
  cifs: convert cifs_writepages to use async writes
  cifs: clean up wsize negotiation and allow for larger wsize

 fs/cifs/cifsglob.h      |    7 +-
 fs/cifs/cifsproto.h     |   30 ++++-
 fs/cifs/cifssmb.c       |  218 ++++++++++++++++++++++++++++++++++-
 fs/cifs/connect.c       |   94 +++++++++++-----
 fs/cifs/file.c          |  292 ++++++++++++++++++++++++----------------------
 fs/cifs/netmisc.c       |    2 +-
 fs/cifs/smb2transport.c |   14 +--
 fs/cifs/transport.c     |  197 ++++++++++----------------------
 8 files changed, 528 insertions(+), 326 deletions(-)

-- 
1.7.4.2
