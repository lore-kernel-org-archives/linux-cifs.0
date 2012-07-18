From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/11] cifs: convert async write code to use less kmapping
Date: Wed, 18 Jul 2012 13:58:55 -0400
Message-ID: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

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

Jeff Layton (11):
  cifs: remove bogus reset of smb_buf_length in smb_send routines
  cifs: rename cifs_sign_smb2 to cifs_sign_smbv
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

 fs/cifs/cifsencrypt.c |   39 +++++++--
 fs/cifs/cifsproto.h   |   37 ++++++--
 fs/cifs/cifssmb.c     |   53 ++++++------
 fs/cifs/connect.c     |   10 ++-
 fs/cifs/file.c        |   47 ++--------
 fs/cifs/transport.c   |  227 ++++++++++++++++++++++++++++++++++++-------------
 6 files changed, 264 insertions(+), 149 deletions(-)

-- 
1.7.10.4
