From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/8] cifs: asynchronous writepages support (try #3)
Date: Mon,  2 May 2011 10:04:21 -0400
Message-ID: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the third version of this set. There are a number of changes
from the last one:

- WB_SYNC_ALL writepages no longer waits for all of the writes to
  complete before returning. Instead, if the result of a write is
  EAGAIN, the write call is resent. This makes cifs writepages work more
  like writepages does in other filesystems. It also simplifies the
  writepages code significantly.

- there's a patch that makes the max_pending limit use the value sent
  in the NEGOTIATE request instead of a hardcoded limit set via a
  module parameter

This patchset changes the CIFS code to do asynchronous writes in
writepages(). It uses the asynchronous call infrastructure that was
added to handle SMB echoes. The idea here is to have the kernel
issue a write request and then have it handle the reply asynchronously.

For now, this just changes the writepages codepath. Once the patchset
has had a bit more refinement and testing, I'll see about changing some
of the other codepaths (writepage(), for instance), and maybe adding
async readpages support.

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

This patch is based on Steve's for-2.6.40 branch plus some other patches
forward ported on top of it. That branch seems to be a bit out of date
though, so once it has been updated, I'll rebase this again to fix up
the merge conflicts.

Review and test feedback would be welcome.

Jeff Layton (8):
  cifs: consolidate SendReceive response checks
  cifs: make cifs_send_async take a kvec array
  cifs: don't call mid_q_entry->callback under the Global_MidLock
  cifs: add ignore_pend flag to cifs_call_async
  cifs: add cifs_async_writev
  cifs: convert cifs_writepages to use async writes
  cifs: clean up wsize negotiation and allow for larger wsize
  cifs: use the server's MaxMpxCount to determine max requests in
    flight

 fs/cifs/cifsfs.c        |   12 ---
 fs/cifs/cifsglob.h      |   21 +----
 fs/cifs/cifsproto.h     |   28 +++++-
 fs/cifs/cifssmb.c       |  244 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/connect.c       |   95 +++++++++++++------
 fs/cifs/file.c          |  224 ++++++++++++++++---------------------------
 fs/cifs/netmisc.c       |    2 +-
 fs/cifs/smb2transport.c |   14 +--
 fs/cifs/transport.c     |  203 ++++++++++++---------------------------
 9 files changed, 486 insertions(+), 357 deletions(-)

-- 
1.7.4.4
