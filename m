From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v6 0/5] transport/session code move to ops struct
Date: Wed, 20 Jun 2012 14:54:06 +0400
Message-ID: <1340189651-25093-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the rest of the patchset that makes the cifs transport code
work through ops struct of the server.

This version has improved #3, #4, #5 patches (xid is unsigned int).

Pavel Shilovsky (5):
  CIFS: Move trans2 processing to ops struct
  CIFS: Extend credit mechanism to process request type
  CIFS: Move protocol specific negotiate code to ops struct
  CIFS: Move protocol specific session setup/logoff code to ops struct
  CIFS: Move protocol specific tcon/tdis code to ops struct

 fs/cifs/cifsglob.h  |   38 ++++++-
 fs/cifs/cifsproto.h |   28 +++---
 fs/cifs/cifssmb.c   |   29 +++---
 fs/cifs/connect.c   |  276 ++++++++++++---------------------------------------
 fs/cifs/sess.c      |    4 +-
 fs/cifs/smb1ops.c   |  209 ++++++++++++++++++++++++++++++++++++++-
 fs/cifs/transport.c |   70 +++++++------
 7 files changed, 375 insertions(+), 279 deletions(-)
