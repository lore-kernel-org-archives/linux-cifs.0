From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] cifs: add version-specific operations containers
Date: Fri, 11 May 2012 14:46:58 -0400
Message-ID: <1336762021-6954-1-git-send-email-jlayton@redhat.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel asked me to sent this set to the list. It's not a complete set of
patches that do anything useful yet, but it does add some infrastructure
to allow the building of an SMB2 filesystem. It adds better handling for
the ver= mount option and adds a version specific struct that hangs off
the TCP_Server_Info.

Note that I've not done much more than compile test this patch, so
consider it an RFC.  Those who are working on SMB2 (mostly Pavel and
Steve at this point) are welcome to take these patches and use them if
you think it reasonable.

I imagine the last patch in the series will need to be respun at some
point. Changing out the send_cancel is probably better suited later on
after adding operations for some of the more basic functionality. I
only singled that one out since it was easy to use it to demonstrate
how you'd use smb_version_operations.


Jeff Layton (3):
  cifs: add a smb_version_operations struct and a smb_version enum
  cifs: add ver=2.1 option support
  cifs: convert send_nt_cancel into a version specific op

 fs/cifs/Makefile    |    4 ++-
 fs/cifs/cifsfs.c    |    1 +
 fs/cifs/cifsglob.h  |   19 ++++++++++++++-
 fs/cifs/connect.c   |   46 +++++++++++++++++++++++++++++-------
 fs/cifs/smb1ops.c   |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |   24 +++++++++++++++++++
 fs/cifs/transport.c |   45 ++++++-----------------------------
 7 files changed, 155 insertions(+), 48 deletions(-)
 create mode 100644 fs/cifs/smb1ops.c
 create mode 100644 fs/cifs/smb2ops.c

-- 
1.7.7.6
