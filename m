From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/7] Implement byte-range locks support for SMB2
Date: Fri, 31 Aug 2012 13:41:21 +0400
Message-ID: <1346406088-4537-1-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This version has the following changes since v1:
1) sec type patch was deleted and sent separately.
2) the longterm bug, that allows one process read/write to the file region locked by another process when they use the same file handle, was fixed by checking a read/write area for a lock before an operation.

This patchset enable brlock support for SMB2 mounts. It allows brlocks
to be cached and send in portions (on oplock break or unlock range).

git branch:
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-brlocks

Pavel Shilovsky (7):
  CIFS: Remove spinlock dependence in brlock processing
  CIFS: Move brlock code to ops struct
  CIFS: Handle SMB2 lock flags
  CIFS: Add brlock support for SMB2
  CIFS: Use brlock cache for SMB2
  CIFS: Turn lock mutex into rw semaphore
  CIFS: Check for mandatory brlocks on read/write

 fs/cifs/cifsfs.c    |    3 +-
 fs/cifs/cifsglob.h  |   26 +++--
 fs/cifs/cifsproto.h |   11 ++
 fs/cifs/file.c      |  272 ++++++++++++++++++++++++++++++---------------------
 fs/cifs/smb1ops.c   |   12 +++
 fs/cifs/smb2file.c  |  189 +++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |   28 +++++-
 fs/cifs/smb2pdu.c   |   59 +++++++++++
 fs/cifs/smb2pdu.h   |   29 ++++++
 fs/cifs/smb2proto.h |   11 ++
 10 files changed, 518 insertions(+), 122 deletions(-)
