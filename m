From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/8] cifs: convert "strict" writes to be asynchronous
Date: Fri,  3 Feb 2012 09:32:53 -0500
Message-ID: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_iovec_write currently sends writes serially. This patchset changes
it to send those writes in parallel instead, and to simply wait for the
replies before returning to userspace. With this, I see a performance
boost of roughly 20% or so when doing streaming writes without an
oplock.

I'd like to see this in linux-next very soon, and then eventually in
v3.4.

As a heads up, my goal here is to eventually convert cifs to use
strictcache by default since that's what the protocol really mandates.
Before we do that though, we need to convert uncached reads and writes
to be asynchronous when we don't have an oplock.

Jeff Layton (8):
  cifs: add pid field to cifs_writedata
  cifs: allow caller to specify completion op when allocating writedata
  cifs: rename pTcon to tcon in cifs_iovec_write
  cifs: fix allocation in cifs_write_allocate_pages
  cifs: make cifsFileInfo_get return the cifsFileInfo pointer
  cifs: fix up get_numpages
  cifs: abstract out function to marshal up the iovec array for async
    writes
  cifs: convert cifs_iovec_write to use async writes

 fs/cifs/cifsglob.h  |    4 +-
 fs/cifs/cifsproto.h |    9 ++-
 fs/cifs/cifssmb.c   |   29 +++---
 fs/cifs/file.c      |  239 +++++++++++++++++++++++++++++++++------------------
 4 files changed, 180 insertions(+), 101 deletions(-)

-- 
1.7.7.6
