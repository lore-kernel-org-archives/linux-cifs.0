From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v3 0/3] Make IPC a regular tcon and fix SMB2 domain-based DFS
Date: Wed, 24 Jan 2018 13:46:09 +0100
Message-ID: <20180124124612.21993-1-aaptel@suse.com>
References: <20180117172200.3221-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117172200.3221-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

changes since v2:

* rebased against Steve's for-next
* mark IPC tcon for reconnection like other tcons
* dump IPC tcon in /proc DebugData
* pass IPC tcon instead of NULL to smb_init() in CIFSGetDFSRefer() so
  that it reconnect it if needed

passes make C=1, checkpatch.pl, and reconnection works in these cases
(domain-based DFS with Windows Server 2016):

| test                      | v1.0 | v3.0 |
|---------------------------+------+------|
| mount root, reco, cd link |  ok  |  ok  |
| mount link, reco, ls      |  ok  |  ok  |



changes since v1:

* squashed definition change of SERVER_NAME_LENGTH in first patch
* ipc tcon no longer added the the session tcon list
* ipc tcon no longer protected by spinlock
* decrement tcon refcount only if it was incremented earlier (ie not
  an ipc tcon) in smb2_get_dfs_refer()

Aurelien Aptel (3):
  CIFS: make IPC a regular tcon
  CIFS: use tcon_ipc instead of use_ipc parameter of SMB2_ioctl
  CIFS: dump IPC tcon in debug proc file

 fs/cifs/cifs_debug.c |  61 ++++++++++++---------
 fs/cifs/cifsglob.h   |  14 ++---
 fs/cifs/cifssmb.c    |   7 +--
 fs/cifs/connect.c    | 150 ++++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/inode.c      |   2 +-
 fs/cifs/smb2file.c   |   2 +-
 fs/cifs/smb2ops.c    |  53 ++++++++----------
 fs/cifs/smb2pdu.c    |  40 ++++----------
 fs/cifs/smb2proto.h  |   3 +-
 9 files changed, 193 insertions(+), 139 deletions(-)

-- 
2.12.3
