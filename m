From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Wed, 21 Nov 2012 18:25:27 +0400
Message-ID: <1353507930-10908-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags - this change can benefit cifs and nfs modules. While this change is ok for network filesystems, itsn't not targeted for local filesystems due security problems (e.g. when a user process can deny root to delete a file).

Share flags are used by Windows applications and WINE have to deal with them too. While WINE can process open share flags itself on local filesystems, it can do it if a file stored on netowork share and is used by several clients. This patchset makes it possible.

Pavel Shilovsky (3):
  fcntl: Introduce new O_DENY* open flags for network filesystems
  CIFS: Add O_DENY* open flags support
  CIFS: Use NT_CREATE_ANDX command for forcemand mounts

 fs/cifs/cifsacl.c                |   10 ++++----
 fs/cifs/cifsglob.h               |   11 ++++++++-
 fs/cifs/cifsproto.h              |    9 ++++----
 fs/cifs/cifssmb.c                |   47 ++++++++++++++++++++------------------
 fs/cifs/dir.c                    |   14 ++++++++----
 fs/cifs/file.c                   |   18 ++++++++++-----
 fs/cifs/inode.c                  |   11 +++++----
 fs/cifs/link.c                   |   10 ++++----
 fs/cifs/readdir.c                |    2 +-
 fs/cifs/smb1ops.c                |   15 ++++++------
 fs/cifs/smb2file.c               |   10 ++++----
 fs/cifs/smb2inode.c              |    4 ++--
 fs/cifs/smb2ops.c                |   10 ++++----
 fs/cifs/smb2pdu.c                |    6 ++---
 fs/cifs/smb2proto.h              |   14 +++++++-----
 fs/fcntl.c                       |    5 ++--
 include/uapi/asm-generic/fcntl.h |   11 +++++++++
 17 files changed, 125 insertions(+), 82 deletions(-)

-- 
1.7.10.4

