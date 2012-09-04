From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] Implement SMB2.1 lease support
Date: Tue,  4 Sep 2012 20:24:03 +0400
Message-ID: <1346775847-7894-1-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is applied on top of the previous brlocking patchset and enables SMB2.1 lease support for file opens. This feature allows to keep several file handles opened and cache read/write/brlock operations.

Pavel Shilovsky (4):
  CIFS: Request SMB2.1 leases
  CIFS: Fix cache coherency for read oplock case
  CIFS: Add SMB2.1 lease break support
  CIFS: Fix fast lease break after open problem

 fs/cifs/cifsfs.c    |   28 +++++++--
 fs/cifs/cifsglob.h  |   22 +++++++
 fs/cifs/cifsproto.h |    7 ++
 fs/cifs/connect.c   |    1 +
 fs/cifs/dir.c       |   22 ++++++-
 fs/cifs/file.c      |   82 ++++++++++++++++++++++-----
 fs/cifs/misc.c      |   30 ++++++++++
 fs/cifs/smb2file.c  |   11 +++-
 fs/cifs/smb2misc.c  |  154 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2ops.c   |   25 ++++++++
 fs/cifs/smb2pdu.c   |  158 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h   |   68 +++++++++++++++++++++-
 fs/cifs/smb2proto.h |    4 +
 13 files changed, 575 insertions(+), 37 deletions(-)
