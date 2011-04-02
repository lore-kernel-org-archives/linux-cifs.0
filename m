From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: asynchronous writepages support (try #1)
Date: Sat,  2 Apr 2011 08:23:54 -0400
Message-ID: <1301747039-31411-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset changes the CIFS code to do asynchronous writes in
writepages(). It uses the asynchronous call infrastructure that was
added to handle SMB echoes. The idea here is to have the kernel
issue a write request and then have it handle the reply asynchronously.

For now, this just changes the writepages codepath. Once the patchset
has had a bit more refinement and testing, I'll see about changing some
of the other codepaths (writepage(), for instance).

So far, I have *not* seen a large amount of performance increase from
this. That may just be because my test rig sucks though. I'm planning to
reserve some beefier machines for testing next week sometime. In the
meantime, if anyone wants to help test this out please do so and report
the results.

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

Obviously, this patch is not quite ready for merge in 2.6.39, but I
would like to have this ready to go when the 2.6.40 merge window opens.

Jeff Layton (5):
  cifs: consolidate SendReceive response checks
  cifs: make cifs_send_async take a kvec array
  cifs: don't call mid_q_entry->callback under the Global_MidLock
  cifs: add cifs_async_writev
  cifs: convert cifs_writepages to use async writes

 fs/cifs/cifsglob.h      |    7 +-
 fs/cifs/cifsproto.h     |   27 +++++-
 fs/cifs/cifssmb.c       |  225 +++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/connect.c       |   32 +++++--
 fs/cifs/file.c          |  256 +++++++++++++++++++++++++----------------------
 fs/cifs/netmisc.c       |    2 +-
 fs/cifs/smb2transport.c |   14 +--
 fs/cifs/transport.c     |  194 +++++++++++-------------------------
 8 files changed, 473 insertions(+), 284 deletions(-)

-- 
1.7.4
