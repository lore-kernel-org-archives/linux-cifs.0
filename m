From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 8 Jun 2014 22:00:48 -0500
Message-ID: <CAH2r5muCJresTZ8E-8NBepycVr0ekm6sBPZ4jBYHDFbjaXm25w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 663a962151593c69374776e8651238d0da072459:

  CIFS: Fix memory leaks in SMB2_open (2014-05-24 13:24:20 -0700)

----------------------------------------------------------------
Fabian Frederick (2):
      fs/cifs/cifs.c: replace seq_printf by seq_puts
      fs/cifs/netmisc.c: convert printk to pr_foo()

Jeff Layton (5):
      cifs: fix cifs_uniqueid_to_ino_t not to ever return 0
      cifs: convert booleans in cifsInodeInfo to a flags field
      cifs: new helper function: cifs_revalidate_mapping
      cifs: fix potential races in cifs_revalidate_mapping
      cifs: ensure that vol->username is not NULL before running strlen on it

Libo Chen (1):
      fs: cifs: new helper: file_inode(file)

Pavel Shilovsky (1):
      CIFS: Fix memory leaks in SMB2_open

Sachin Prabhu (1):
      cifs: Set client guid on per connection basis

Steve French (3):
      Update cifs version number to 2.03
      Do not send ClientGUID on SMB2.02 dialect
      Clarify SMB2/SMB3 create context and add missing ones

 fs/cifs/cifsfs.c   | 94 ++++++++++++++++++++++++------------------------------
 fs/cifs/cifsfs.h   | 22 +++++++++----
 fs/cifs/cifsglob.h |  8 +++--
 fs/cifs/connect.c  |  5 ++-
 fs/cifs/file.c     | 16 +++++-----
 fs/cifs/inode.c    | 71 +++++++++++++++++++++++++++++++----------
 fs/cifs/ioctl.c    |  2 +-
 fs/cifs/netmisc.c  |  9 +++---
 fs/cifs/smb2ops.c  |  2 ++
 fs/cifs/smb2pdu.c  | 19 +++++++++--
 fs/cifs/smb2pdu.h  |  8 +++--
 11 files changed, 158 insertions(+), 98 deletions(-)

-- 
Thanks,

Steve
