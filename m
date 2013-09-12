From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 11 Sep 2013 23:55:53 -0500
Message-ID: <CAH2r5mvA+2UTrVYn5R8Xsw-uvNH8CwhjhvjJpKivyrOZttr3Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

CIFS update including case insensitive file name matching improvements
for UTF-8 to Unicode, various small cifs fixes, SMB2/SMB3 leasing
improvements, support for following SMB2 symlinks, SMB3 packet signing
improvements

The following changes since commit b409624ad5a99c2e84df6657bd0f7931ac470d2d:

  Merge git://git.infradead.org/users/willy/linux-nvme (2013-09-07
20:19:02 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 42873b0a282ac84a56e0e48c408beb62d0ad2917:

  CIFS: Respect epoch value from create lease context v2 (2013-09-09
22:52:18 -0500)

----------------------------------------------------------------
Jeff Layton (6):
      cifs: ensure that srv_mutex is held when dealing with ssocket pointer
      cifs: create a new Documentation/ directory and move docfiles into it
      cifs: display iocharset= option in /proc/mounts
      cifs: add new case-insensitive conversion routines that are
based on wchar_t's
      cifs: convert case-insensitive dentry ops to use new case
conversion routines
      cifs: add winucase_convert.pl to Documentation/ directory

Pavel Shilovsky (10):
      CIFS: Implement follow_link for SMB2
      CIFS: Implement follow_link for nounix CIFS mounts
      CIFS: Fix a memory leak when a lease break comes
      CIFS: Fix missing lease break
      CIFS: Replace clientCanCache* bools with an integer
      CIFS: Store lease state itself rather than a mapped oplock value
      CIFS: Move creating lease buffer to ops struct
      CIFS: Move parsing lease buffer to ops struct
      CIFS: Add create lease v2 context for SMB3
      CIFS: Respect epoch value from create lease context v2

Scott Lovenberg (3):
      cifs: Move string length definitions to uapi
      cifs: Expand max share name length to 256
      cifs: Move and expand MAX_SERVER_SIZE definition

Shirish Pargaonkar (3):
      cifs: Process post session setup code in respective dialect functions.
      cifs: Add a variable specific to NTLMSSP for key exchange.
      cifs: Start using per session key for smb2/3 for signature generation

Steve French (2):
      [CIFS] Add Scott to list of cifs contributors
      [CIFS] quiet sparse compile warning

Wei Yongjun (1):
      CIFS: convert to use le32_add_cpu()

 {fs => Documentation/filesystems}/cifs/AUTHORS     |   1 +
 {fs => Documentation/filesystems}/cifs/CHANGES     |   0
 {fs => Documentation/filesystems}/cifs/README      |   0
 {fs => Documentation/filesystems}/cifs/TODO        |   0
 Documentation/filesystems/{ => cifs}/cifs.txt      |   0
 Documentation/filesystems/cifs/winucase_convert.pl |  62 ++
 fs/cifs/Makefile                                   |   2 +-
 fs/cifs/cifs_unicode.h                             |   2 +
 fs/cifs/cifsfs.c                                   |  49 +-
 fs/cifs/cifsglob.h                                 |  61 +-
 fs/cifs/cifspdu.h                                  |  11 +-
 fs/cifs/cifsproto.h                                |  12 +-
 fs/cifs/cifssmb.c                                  | 110 ++--
 fs/cifs/connect.c                                  |  43 +-
 fs/cifs/dir.c                                      |  58 +-
 fs/cifs/file.c                                     |  35 +-
 fs/cifs/inode.c                                    |  12 +-
 fs/cifs/link.c                                     |  24 +-
 fs/cifs/misc.c                                     |  13 +-
 fs/cifs/readdir.c                                  |   3 +
 fs/cifs/sess.c                                     |  58 +-
 fs/cifs/smb1ops.c                                  |  44 +-
 fs/cifs/smb2file.c                                 |  25 +-
 fs/cifs/smb2inode.c                                |   9 +-
 fs/cifs/smb2misc.c                                 | 186 +++---
 fs/cifs/smb2ops.c                                  | 344 ++++++++++-
 fs/cifs/smb2pdu.c                                  | 135 +++--
 fs/cifs/smb2pdu.h                                  |  37 ++
 fs/cifs/smb2proto.h                                |   5 +-
 fs/cifs/smb2transport.c                            |  70 ++-
 fs/cifs/winucase.c                                 | 663 +++++++++++++++++++++
 include/uapi/linux/cifs/cifs_mount.h               |  27 +
 32 files changed, 1677 insertions(+), 424 deletions(-)
 rename {fs => Documentation/filesystems}/cifs/AUTHORS (99%)
 rename {fs => Documentation/filesystems}/cifs/CHANGES (100%)
 rename {fs => Documentation/filesystems}/cifs/README (100%)
 rename {fs => Documentation/filesystems}/cifs/TODO (100%)
 rename Documentation/filesystems/{ => cifs}/cifs.txt (100%)
 create mode 100755 Documentation/filesystems/cifs/winucase_convert.pl
 create mode 100644 fs/cifs/winucase.c
 create mode 100644 include/uapi/linux/cifs/cifs_mount.h

-- 
Thanks,

Steve
