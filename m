From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 00/15] cifs: convert async write and read code to use less kmapping
Date: Mon,  6 Aug 2012 07:30:57 -0400
Message-ID: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the third version of this series. The main differences are:

1) fix up merge conflicts with Steve's for-next tree, mostly due to the
merge of more SMB2 patches.

2) the async read code has been converted not to do as much kmapping

We currently have a problem with the async write code on CONFIG_HIGHMEM
architectures. It uses *way* too much kmap space. Not only does this
limit throughput by adding an artificial bottleneck, but can lead to
deadlocks.

This patchset fixes this by making the code not kmap an entire array of
pages before attempting to send and receive it. Instead, pages are dealt
with one at a time so we only generally will have a single kmap in play
at a time.

I've tested this numerous ways and it seems to work as expected. Pavel
reviewed an earlier series. Some of these patches have seen some changes
but I've left his Reviewed-by's in place. Let me know if you want to
withdraw them.

It's probably too late now for the 3.6 merge window, but I'd like to see
this go into linux-next very soon so that it's ready for merge in 3.7.

Jeff Layton (15):
  cifs: change signing routines to deal with smb_rqst structs
  cifs: change smb2 signing routines to use smb_rqst structs
  cifs: convert send code to use smb_rqst structs
  cifs: cork the socket before a send and uncork it afterward
  cifs: teach smb_send_rqst how to handle arrays of pages
  cifs: teach signing routines how to deal with arrays of pages in a
    smb_rqst
  cifs: change cifs_call_async to use smb_rqst structs
  cifs: convert async write code to pass in data via rq_pages array
  cifs: remove the kmap size limit from wsize
  cifs: add deprecation warning to sockopt=TCP_NODELAY option
  cifs: allocate kvec array for cifs_readdata as a separate allocation
  cifs: turn the pages list in cifs_readdata into an array
  cifs: convert async read code to use pages array without kmapping
  cifs: replace kvec array in readdata with a single kvec
  cifs: remove kmap lock and rsize limit

 fs/cifs/cifsencrypt.c   |  37 +++++--
 fs/cifs/cifsfs.c        |   4 -
 fs/cifs/cifsglob.h      |  78 ++++++---------
 fs/cifs/cifsproto.h     |  25 +++--
 fs/cifs/cifssmb.c       | 106 +++++++++-----------
 fs/cifs/connect.c       |   7 +-
 fs/cifs/file.c          | 253 ++++++++++++++++++++++-------------------------
 fs/cifs/smb1ops.c       |   6 --
 fs/cifs/smb2ops.c       |   6 --
 fs/cifs/smb2pdu.c       |  65 ++++++------
 fs/cifs/smb2proto.h     |  13 ++-
 fs/cifs/smb2transport.c |  83 ++++++++--------
 fs/cifs/transport.c     | 255 ++++++++++++++++++++++++++++++++++--------------
 13 files changed, 503 insertions(+), 435 deletions(-)

-- 
1.7.11.2
