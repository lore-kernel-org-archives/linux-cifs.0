From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v4 0/7] transport/session code move to ops struct
Date: Thu, 31 May 2012 16:50:49 +0400
Message-ID: <1338468657-29742-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the regular patchset that makes the existing cifs code work through
ops struct of the server.

This version eliminate S_OP/S_OPV and makes the code more similiar to kernel
code style.

Pavel Shilovsky (7):
  CIFS: Make accessing is_valid_oplock/dump_detail ops struct field
    safe
  CIFS: Move get_next_mid to ops struct
  CIFS: Move trans2 processing to ops struct
  CIFS: Extend credit mechanism to process request type
  CIFS: Move protocol specific negotiate code to ops struct
  CIFS: Move protocol specific session setup/logoff code to ops struct
  CIFS: Move protocol specific tcon/tdis code to ops struct

 fs/cifs/cifsglob.h  |   43 +++++++-
 fs/cifs/cifsproto.h |   21 ++--
 fs/cifs/cifssmb.c   |   24 ++--
 fs/cifs/connect.c   |  277 ++++++++++++------------------------------------
 fs/cifs/misc.c      |   89 +---------------
 fs/cifs/sess.c      |    4 +-
 fs/cifs/smb1ops.c   |  298 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/transport.c |   36 ++++---
 8 files changed, 444 insertions(+), 348 deletions(-)
