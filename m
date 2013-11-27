From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 27 Nov 2013 13:21:59 -0600
Message-ID: <CAH2r5mtcsBjR5fcLyUjRAgdkSr2M7KUeN4ZzYH-bcLVf=jF9OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

SMB3 "validate negotiate" is needed to prevent certain types of
downgrade attacks.
Also changes SMB2/SMB3 copy offload from using the BTRFS copy ioctl
(BTRFS_IOC_CLONE) to a cifs specific ioctl (CIFS_IOC_COPYCHUNK_FILE)
to address Christoph's comment that there are semantic differences between
requesting copy offload in which copy-on-write is mandatory (as in the
BTRFS ioctl) and optional in the SMB2/SMB3 case.  Also fixes SMB2/SMB3
copychunk for large files.

The following changes since commit 2d3c627502f2a9b0a7de06a5a2df2365542a72c9:

  Revert "init/Kconfig: add option to disable kernel compression"
(2013-11-17 11:17:36 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to f19e84df37bda502a2248d507a9cf2b9e693279e:

  [CIFS] Do not use btrfs refcopy ioctl for SMB2 copy offload
(2013-11-25 09:50:31 -0600)

----------------------------------------------------------------
Steve French (4):
      CIFS: Fix SMB2/SMB3 Copy offload support (refcopy) for large files
      Removed duplicated (and unneeded) goto
      Check SMB3 dialects against downgrade attacks
      [CIFS] Do not use btrfs refcopy ioctl for SMB2 copy offload

 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/ioctl.c     |  6 ++--
 fs/cifs/smb2ops.c   | 99 ++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/cifs/smb2pdu.c   | 92 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h   | 12 +++++--
 fs/cifs/smb2proto.h |  1 +
 fs/cifs/smbfsctl.h  |  2 +-
 7 files changed, 189 insertions(+), 24 deletions(-)

-- 
Thanks,

Steve
