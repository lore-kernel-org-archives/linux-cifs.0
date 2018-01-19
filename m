From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 0/2] Make IPC a regular tcon and fix SMB2 domain-based DFS
Date: Fri, 19 Jan 2018 18:12:56 +0100
Message-ID: <20180119171258.14244-1-aaptel@suse.com>
References: <20180117172200.3221-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117172200.3221-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

changes since v1:

* squashed definition change of SERVER_NAME_LENGTH in first patch
* ipc tcon no longer added the the session tcon list
* ipc tcon no longer protected by spinlock
* decrement tcon refcount only if it was incremented earlier (ie not
  an ipc tcon) in smb2_get_dfs_refer()

Aurelien Aptel (2):
  CIFS: make IPC a regular tcon
  CIFS: use tcon_ipc instead of use_ipc parameter of SMB2_ioctl

 fs/cifs/cifsglob.h  |  14 ++---
 fs/cifs/cifssmb.c   |   5 +-
 fs/cifs/connect.c   | 148 +++++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/inode.c     |   2 +-
 fs/cifs/smb2file.c  |   2 +-
 fs/cifs/smb2ops.c   |  53 ++++++++-----------
 fs/cifs/smb2pdu.c   |  36 ++-----------
 fs/cifs/smb2proto.h |   3 +-
 8 files changed, 151 insertions(+), 112 deletions(-)

-- 
2.12.3
