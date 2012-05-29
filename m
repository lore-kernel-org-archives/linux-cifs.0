From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 0/7] transport/session code move to ops struct
Date: Tue, 29 May 2012 20:18:57 +0400
Message-ID: <1338308344-29149-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the regular patchset that makes the existing cifs code work through
ops struct of the server.

The version #3 consists the S_OP code that makes the code execution safer where
we need. Also it is not targeted to use for all ops struct call - it is much
better to opses in some critical place than having something unprepictable
(writeback, transport, credits, etc).

Pavel Shilovsky (7):
  CIFS: Introduce S_OP/S_OPV macros for a safe access to ops struct
    field
  CIFS: Move get_next_mid to ops struct
  CIFS: Move trans2 processing to ops struct
  CIFS: Extend credit mechanism to process request type
  CIFS: Move protocol specific negotiate code to ops struct
  CIFS: Move protocol specific session setup/logoff code to ops struct
  CIFS: Move protocol specific tcon/tdis code to ops struct

 fs/cifs/cifsglob.h  |   61 ++++++++++-
 fs/cifs/cifsproto.h |   21 ++--
 fs/cifs/cifssmb.c   |   24 ++--
 fs/cifs/connect.c   |  240 +++++++----------------------------------
 fs/cifs/misc.c      |   89 +---------------
 fs/cifs/sess.c      |    4 +-
 fs/cifs/smb1ops.c   |  298 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/transport.c |   39 ++++---
 8 files changed, 435 insertions(+), 341 deletions(-)
