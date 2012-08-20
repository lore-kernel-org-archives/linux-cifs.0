From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 00/10] SMB2 brlocks, leases and multicredit io
Date: Mon, 20 Aug 2012 22:42:50 +0400
Message-ID: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a patchset that includes the rest of SMB2 changes: brlocks, leases and multicredit io.

The changes are applied on top of Jeff's recent patchset and can be found here:
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev-cork

Pavel Shilovsky (10):
  CIFS: Improve byte-range locks handling
  CIFS: Handle SMB2 lock flags
  CIFS: Move brlock code to ops struct
  CIFS: Add brlock support for SMB2
  CIFS: Request SMB2.1 leases
  CIFS: Add SMB2.1 lease break support
  CIFS: Fix cache coherency for read oplock case
  CIFS: Make use of multicredit write for SMB2
  CIFS: Make use of multicredit reads for SMB2
  CIFS: Add NTLMSSP sec type to defaults

 fs/cifs/cifsfs.c        |   21 +++--
 fs/cifs/cifsglob.h      |   46 +++++++--
 fs/cifs/cifsproto.h     |   10 ++
 fs/cifs/cifssmb.c       |   14 ++-
 fs/cifs/dir.c           |    5 +
 fs/cifs/file.c          |  185 ++++++++++++++++++++++++-----------
 fs/cifs/smb1ops.c       |   20 ++++
 fs/cifs/smb2file.c      |  156 +++++++++++++++++++++++++++++-
 fs/cifs/smb2misc.c      |  132 +++++++++++++++++++++++++-
 fs/cifs/smb2ops.c       |  106 ++++++++++++++++++--
 fs/cifs/smb2pdu.c       |  250 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h       |   95 ++++++++++++++++++-
 fs/cifs/smb2proto.h     |   15 +++
 fs/cifs/smb2transport.c |    4 +
 fs/cifs/transport.c     |   29 +++++-
 15 files changed, 975 insertions(+), 113 deletions(-)
