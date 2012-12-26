From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 0/3] Data coherency fixes for v3.8
Date: Wed, 26 Dec 2012 19:53:51 +0400
Message-ID: <1356537234-11507-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is targeted for v3.8 and aimed to fix data coherency problem mostly with SMB2.1 protocol code but it applies for CIFS code as well.

The problem is that is was investigated that Windows 7 server doesn't break read caching lease if we set/have madatory byte-range locks or issue a write request. This end up with situations when we have level2 lease, issue read caching and conflict with byte-range lock from another fid.

This strage behavior make we think that we should not rely on the server and should process such things ourself on the client.

On the client we can set oplock/lease level according to request we send to the server: if we issue a write or brlock request we can simply break level2 oplock/lease and there is no problem for us if the server breaks it too.

The patchset consists of two parts:
1) re-fix for the patch "CIFS: Fix write after setting a read lock for read oplock files" (patches #1 and #2) that breaks level2 oplock/lease on the client if we issue a write request.
2) fix for brlocks that breaks level2 oplock/lease on the client if we issue a mandatory byte-range lock request.

The work branch with the patches: http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-3.8

Pavel Shilovsky (3):
  Revert "CIFS: Fix write after setting a read lock for read oplock
    files"
  CIFS: Fix write after setting a read lock for read oplock files
  CIFS: Don't let read only caching for mandatory byte-range locked
    files

 fs/cifs/cifsfs.c   |   1 -
 fs/cifs/cifsglob.h |   2 +-
 fs/cifs/file.c     | 141 +++++++++++++++++++++++++++++------------------------
 fs/cifs/smb1ops.c  |   1 +
 fs/cifs/smb2ops.c  |   3 ++
 5 files changed, 81 insertions(+), 67 deletions(-)

-- 
1.7.12.4
