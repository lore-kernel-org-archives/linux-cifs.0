From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 Fixes
Date: Fri, 13 Nov 2015 15:24:41 -0600
Message-ID: <CAH2r5mtPCXrTLS+eXvko7ofbT2VZLfqREyqcDKoUfychwfi_Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A collection of SMB3 patches adding some reliability features
(persistent and resilient handles) and improving SMB3 copy offload.
I will have some additional patches for SMB3 encryption and SMB3.1.1
signing (important security features), and also for improving SMB3
persistent handle reconnection (setting ChannelSequence number e.g.)
that I am still working on but wanted to get this set in since they
can stand alone.

Please pull the following changes since commit
523e13455ec9ec4457a5a1d24ff7132949742b70:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
(2015-10-31 15:19:36 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 7b52e2793a58af61b5d349c2c080437a437a4edb:

  Allow copy offload (CopyChunk) across shares (2015-11-09 09:28:48 -0600)

----------------------------------------------------------------
Steve French (7):
      Allow duplicate extents in SMB3 not just SMB3.1.1
      [SMB3] Add parsing for new mount option controlling persistent handles
      [SMB3] Enable checking for continuous availability and
persistent handle support
      [SMB3] Display persistenthandles in /proc/mounts for SMB3 shares
if enabled
      [SMB3] Send durable handle v2 contexts when use of persistent
handles required
      Add resilienthandles mount parm
      Allow copy offload (CopyChunk) across shares

 fs/cifs/cifsfs.c   |  16 ++-----
 fs/cifs/cifsglob.h |   8 +++-
 fs/cifs/connect.c  |  78 +++++++++++++++++++++++++++++++++
 fs/cifs/ioctl.c    |  11 +++--
 fs/cifs/smb2file.c |  19 +++++++++
 fs/cifs/smb2ops.c  |  10 ++---
 fs/cifs/smb2pdu.c  | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.h  |  45 ++++++++++++++++++++
 fs/cifs/smbfsctl.h |   2 +-
 9 files changed, 287 insertions(+), 25 deletions(-)

-- 
Thanks,

Steve
