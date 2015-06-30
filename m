From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS/SMB3 changes for 4.2
Date: Tue, 30 Jun 2015 14:25:15 -0500
Message-ID: <CAH2r5mvMkTtiYyLb5G=rQ_ih46EMets8LaURTA3Axo6B+Ztu8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
4a10a91756ef381bced7b88cfb9232f660b92d93:

  Merge branch 'upstream' of
git://git.infradead.org/users/pcmoore/audit (2015-06-27 13:53:16
-0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 1dfd18d0571231d030f325bfcd80f5c42a56a53e:

  cifs: Unset CIFS_MOUNT_POSIX_PATHS flag when following dfs mounts
(2015-06-29 14:50:22 -0500)


Includes two bug fixes, as well as (minimal) support for the new
protocol dialect (SMB3.1.1), and support for two ioctls including
reflink (duplicate extents) file copy and set integrity.

----------------------------------------------------------------
Noel Power (1):
      client MUST ignore EncryptionKeyLength if CAP_EXTENDED_SECURITY is set

Sachin Prabhu (1):
      cifs: Unset CIFS_MOUNT_POSIX_PATHS flag when following dfs mounts

Steve French (9):
      Allow parsing vers=3.11 on cifs mount
      Add defines and structs for smb3.1 dialect
      Make dialect negotiation warning message easier to read
      add struct FILE_STANDARD_INFO
      Add SMB3.11 mount option synonym for new dialect
      Add reflink copy over SMB3.11 with new FSCTL_DUPLICATE_EXTENTS
      Add Get/Set Integrity Information structure definitions
      Add ioctl to set integrity
      Update negotiate protocol for SMB3.11 dialect

 fs/cifs/Kconfig    |   9 +++
 fs/cifs/cifsglob.h |  13 ++++
 fs/cifs/cifspdu.h  |  12 ++++
 fs/cifs/cifssmb.c  |   5 +-
 fs/cifs/connect.c  |  13 ++++
 fs/cifs/ioctl.c    |  27 +++++++-
 fs/cifs/smb2ops.c  | 180 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c  |  67 ++++++++++++++++++--
 fs/cifs/smb2pdu.h  |  81 +++++++++++++++++++++---
 fs/cifs/smbfsctl.h |   3 +
 10 files changed, 392 insertions(+), 18 deletions(-)

-- 
Thanks,

Steve
