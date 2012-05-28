From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 0/7] transport/session code move to ops struct
Date: Mon, 28 May 2012 13:30:07 +0400
Message-ID: <1338197414-22340-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the regular patchset that makes the existing cifs code work through
ops struct of the server.

The version #2 consists the S_OP code that makes the code execution safer.

Pavel Shilovsky (7):
  CIFS: Introduce S_OP/S_OPV macros for a safe access to ops struct
    field
  CIFS: Move get_next_mid to ops struct
  CIFS: Move trans2 processing to ops struct
  CIFS: Extend credit mechanism to process request type
  CIFS: Move protocol specific negotiate code to ops struct
  CIFS: Move protocol specific session setup/logoff code to ops struct
  CIFS: Move protocol specific tcon/tdis code to ops struct

 fs/cifs/cifsglob.h  |   60 +++++++++--
 fs/cifs/cifsproto.h |   12 +--
 fs/cifs/cifssmb.c   |   28 +++---
 fs/cifs/connect.c   |  236 +++++++-----------------------------------
 fs/cifs/file.c      |    2 +-
 fs/cifs/misc.c      |   89 +----------------
 fs/cifs/sess.c      |    5 +-
 fs/cifs/smb1ops.c   |  290 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/transport.c |   47 +++++----
 9 files changed, 423 insertions(+), 346 deletions(-)
