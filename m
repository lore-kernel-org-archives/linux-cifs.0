From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/16] cifs: cleanup and overhaul of the receive codepath (try #2)
Date: Fri, 26 Aug 2011 15:06:13 -0400
Message-ID: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset does a fairly major cleanup and overhaul of the receive
codepath for cifs. Aside from basic cleanup, there are two main goals:

1) allow the receive codepath to identify the mid before receiving all
of the data for a particular SMB.

...and in turn...

2) add the ability for certain calls to receive their responses into
their into their own set of buffers.

These two changes allow cifs to break the CIFSMaxBufSize barrier for
receives. This patchset just adds the necessary infrastructure to do
the above.

A separate patchset will follow that will overhaul cifs_readpages to use
this infrastructure to allow for a larger rsize.

Jeff Layton (16):
  cifs: clean up checkSMB
  cifs: consolidate signature generating code
  cifs: trivial: remove obsolete comment
  cifs: make smb_msg local to read_from_socket
  cifs: check for unresponsive server every time we call kernel_recvmsg
  cifs: simplify read_from_socket
  cifs: turn read_from_socket into a wrapper around a vectorized
    version
  cifs: keep a reusable kvec array for receives
  cifs: clean up check_rfc1002_header
  cifs: add a third receive phase to cifs_demultiplex_thread
  cifs: move mid finding into separate routine
  cifs: eliminate is_multi_rsp parm to find_cifs_mid
  cifs: move buffer pointers into TCP_Server_Info
  cifs: find mid earlier in receive codepath
  cifs: break out 3rd receive phase into separate function
  cifs: add a callback function to receive the rest of the frame

 fs/cifs/cifsencrypt.c |  103 ++--------
 fs/cifs/cifsglob.h    |   29 +++-
 fs/cifs/cifsproto.h   |    7 +-
 fs/cifs/cifssmb.c     |    5 +-
 fs/cifs/connect.c     |  519 ++++++++++++++++++++++++++++---------------------
 fs/cifs/misc.c        |   51 +++---
 fs/cifs/transport.c   |   16 +-
 7 files changed, 391 insertions(+), 339 deletions(-)

-- 
1.7.6
