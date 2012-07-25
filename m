From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/9] cifs: convert async write code to use less kmapping
Date: Wed, 25 Jul 2012 11:54:03 -0400
Message-ID: <1343231652-10459-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second version of this patch series. The main differences
from the first are:

1) move the struct smb_rqst definition from cifsproto.h to cifsglob.h

2) fix up merge conflicts with Steve's for-next tree and drop patches
   that are already there

3) convert the setup_async_request prototype to return a mid_q_entry
   pointer or an ERR_PTR instead of requiring a double pointer argument

Original cover letter follows...

We currently have a problem with the async write code on CONFIG_HIGHMEM
architectures. It uses *way* too much kmap space. Not only does this
limit throughput by adding an artificial bottleneck, but it also can
lead to deadlocks.

Late in the 3.5 cycle, I sent some patches to limit the rsize and wsize
on these arches as a temporary workaround. This patchset is a first pass
at fixing this the right way, by teaching the low-level transport code
how to deal with arrays of pages.

Note that this is just a fix for the write codepaths. The read side will
need a separate set of patches.

The code seems to work correctly, and is probably suitable for the
upcoming 3.6 merge window. This probably also has some non-trivial
conflicts with Pavel's patches since I did not base this on top of his
SMB2 work.

Let me know what you plan to merge first for 3.6 and I can try to
fix those up, or we can ask Pavel to rebase his code on top of this.

Jeff Layton (9):
  cifs: change signing routines to deal with smb_rqst structs
  cifs: convert send code to use smb_rqst structs
  cifs: cork the socket before a send and uncork it afterward
  cifs: teach smb_send_rqst how to handle arrays of pages
  cifs: teach signing routines how to deal with arrays of pages in a
    smb_rqst
  cifs: change cifs_call_async to use smb_rqst structs
  cifs: convert async write code to pass in data via rq_pages array
  cifs: remove the kmap size limit from wsize
  cifs: add deprecation warning to sockopt=TCP_NODELAY option

 fs/cifs/cifsencrypt.c   |  37 ++++++--
 fs/cifs/cifsglob.h      |  18 +++-
 fs/cifs/cifsproto.h     |  25 +++---
 fs/cifs/cifssmb.c       |  59 ++++++------
 fs/cifs/connect.c       |  10 ++-
 fs/cifs/file.c          |  47 ++--------
 fs/cifs/smb2proto.h     |   4 +-
 fs/cifs/smb2transport.c |  14 ++-
 fs/cifs/transport.c     | 233 +++++++++++++++++++++++++++++++++++-------------
 9 files changed, 278 insertions(+), 169 deletions(-)

-- 
1.7.11.2
