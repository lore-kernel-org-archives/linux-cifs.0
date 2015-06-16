From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Unset CIFS_MOUNT_POSIX_PATHS flag when following dfs mounts
Date: Tue, 16 Jun 2015 16:36:17 +0100
Message-ID: <1434468977-25651-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In a dfs setup where the client transitions from a server which support=
s
posix paths to a server which doesn't support posix paths, the flag
CIFS_MOUNT_POSIX_PATHS is not reset. This leads to the wrong directory
separator being used causing smb commands to fail.

Consider the following case where a dfs share on a samba server points
to a share on windows smb server.
 # mount -t cifs -o .. //vm140-31/dfsroot/testwin/
 # ls -l /mnt; touch /mnt/a
 total 0
 touch: cannot touch =E2=80=98/mnt/a=E2=80=99: No such file or director=
y

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8383d5e..a59370b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3461,6 +3461,8 @@ try_mount_again:
 		else if (ses)
 			cifs_put_smb_ses(ses);
=20
+		cifs_sb->mnt_cifs_flags &=3D ~CIFS_MOUNT_POSIX_PATHS;
+
 		free_xid(xid);
 	}
 #endif
--=20
2.4.3
