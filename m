From: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
Date: Tue, 22 Jan 2013 19:20:58 -0500
Message-ID: <1358900459-26277-1-git-send-email-dinggnu@gmail.com>
Cc: Cong Ding <dinggnu@gmail.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

When it goes to error through line 144, the memory allocated to *devname is
not freed, and the caller doesn't free it either in line 250. So we free the
memroy of *devname in function cifs_compose_mount_options() when it goes to
error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/cifs/cifs_dfs_ref.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ce5cbd7..210fce2 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -226,6 +226,8 @@ compose_mount_options_out:
 compose_mount_options_err:
 	kfree(mountdata);
 	mountdata = ERR_PTR(rc);
+	kfree(*devname);
+	*devname = NULL;
 	goto compose_mount_options_out;
 }
 
-- 
1.7.10.4
