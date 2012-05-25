From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/6] transport/session code move to ops struct
Date: Fri, 25 May 2012 13:19:17 +0400
Message-ID: <1337937563-8417-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the regular patchset that makes the existing cifs code work through
ops struct of the server.

Pavel Shilovsky (6):
  CIFS: Move get_next_mid to ops struct
  CIFS: Move trans2 processing to ops struct
  CIFS: Extend credit mechanism to process request type
  CIFS: Move protocol specific negotiate code to ops struct
  CIFS: Move protocol specific session setup/logoff code to ops struct
  CIFS: Move protocol specific tcon/tdis code to ops struct

 fs/cifs/cifsglob.h  |   40 ++++++-
 fs/cifs/cifsproto.h |   12 +--
 fs/cifs/cifssmb.c   |   22 ++--
 fs/cifs/connect.c   |  226 ++++++---------------------------------
 fs/cifs/misc.c      |   89 +---------------
 fs/cifs/sess.c      |    5 +-
 fs/cifs/smb1ops.c   |  298 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/transport.c |   36 ++++---
 8 files changed, 400 insertions(+), 328 deletions(-)
