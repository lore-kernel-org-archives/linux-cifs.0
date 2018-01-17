From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 0/3] Make IPC a regular tcon and fix SMB2 domain-based DFS
Date: Wed, 17 Jan 2018 18:21:57 +0100
Message-ID: <20180117172200.3221-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

The DFS code for smb2 doesn't work [1] when cifs.ko connects to a
domain-based DFS where you have an extra level on indirection (so 3
machines: AD, nameserver and the final storage).

* In SMB1 code, the DFS request is made without the tcon object. It works
  directly on the session.
* In SMB2 code, we use SMB2_ioctl() which works on a tcon.

For domain-based DFS UNC \\DOMAIN\namespace\link, cifs.ko first tries to
connect to \\DOMAIN\namespace. DOMAIN doesn't have a "namespace" share
so no valid tcon object is created.

* SMB1 doesn't care as it's working on the session object and just use
  the ses->ipc_tid number to make the DFS request.
* SMB2 code on the other hand fails as SMB2_ioctl() needs a tcon
  object (even if you pass use_ipc=true) because it uses the tcon you
  pass and simply overwrites the packet tid with ipc_tid. There is no
  valid tcon object at that time since DOMAIN rejected the "namespace"
  tcon request.

So to solve this I thought I would get rid of ses->ipc_tid and make a
real IPC tcon, that would be added to the session tcon_list and be
managed like any other tcon (almost).

This patch series cleans some definitions and makes the IPC connection
a regular tcon owned by the session. It removes the use_ipc param from
SMB2_ioct() (you can pass ses->tcon_ipc as the tcon param).

I've made the choice of having the IPC tcon completely associated to
the session instead of any other tcon. Its refcount is not really used
as it's always created as soon as we have a valid session and always
destroy when the session is destroyed and no mount points directly
refer to it.

All patches compile when applied sequentially, no warnings with
checkpatch.pl, no warnings with make C=1.

I've tested this against Windows Server 2016 vms with smb1, 2, 3 (with
and without encryption) and it seems to be working properly.

I've also quickly tested the reconnection code path but it probably
needs some work still (making sure DFS works after a reconnection) as
there are multiple ways to trigger the reconnection (I've been using
qemu monitor "set_link xyz off" which is analogous to unplugging the
network cable IIUC).

Please take a look, review, test :)

1: https://bugzilla.samba.org/show_bug.cgi?id=12917

Aurelien Aptel (3):
  CIFS: set SERVER_NAME_LENGTH to serverName actual size
  CIFS: make IPC a regular tcon
  CIFS: use tcon_ipc instead of use_ipc parameter from SMB2_ioctl

 fs/cifs/cifsglob.h  |  14 ++---
 fs/cifs/cifssmb.c   |   5 +-
 fs/cifs/connect.c   | 159 ++++++++++++++++++++++++++++++++++++++++------------
 fs/cifs/inode.c     |   2 +-
 fs/cifs/smb2file.c  |   2 +-
 fs/cifs/smb2ops.c   |  50 +++++++----------
 fs/cifs/smb2pdu.c   |  36 ++----------
 fs/cifs/smb2proto.h |   3 +-
 8 files changed, 160 insertions(+), 111 deletions(-)

-- 
2.12.3
