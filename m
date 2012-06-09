From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v5 0/5] transport/session code move to ops struct
Date: Sat,  9 Jun 2012 10:25:59 +0400
Message-ID: <1339223164-9721-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the rest of the patchset that makes the cifs transport code
work through ops struct of the server.

This version has improved credit patch (#2).

Pavel Shilovsky (5):
  CIFS: Move trans2 processing to ops struct
  CIFS: Extend credit mechanism to process request type
  CIFS: Move protocol specific negotiate code to ops struct
  CIFS: Move protocol specific session setup/logoff code to ops struct
  CIFS: Move protocol specific tcon/tdis code to ops struct

 fs/cifs/cifsglob.h  |   38 ++++++-
 fs/cifs/cifsproto.h |   20 ++--
 fs/cifs/cifssmb.c   |   25 +++---
 fs/cifs/connect.c   |  269 ++++++++++++---------------------------------------
 fs/cifs/sess.c      |    4 +-
 fs/cifs/smb1ops.c   |  209 +++++++++++++++++++++++++++++++++++++++-
 fs/cifs/transport.c |   54 ++++++-----
 7 files changed, 356 insertions(+), 263 deletions(-)
