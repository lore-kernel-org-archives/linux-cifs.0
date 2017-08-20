From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 6/8] CIFS: Return directly after a failed
 build_path_from_dentry() in cifs_do_create()
Date: Sun, 20 Aug 2017 18:40:07 +0200
Message-ID: <24a10b1a-3b4a-da70-1670-23b4ec9abff8@users.sourceforge.net>
References: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <826310e5-e01c-38af-90df-c5630f761a4d-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sun, 20 Aug 2017 17:17:30 +0200

Return directly after a call of the function "build_path_from_dentry"
failed at the beginning.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 fs/cifs/dir.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 2c9cbd8393d6..248aead1f3f4 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -239,10 +239,8 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		*oplock = REQ_OPLOCK;
 
 	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!full_path)
+		return -ENOMEM;
 
 	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
-- 
2.14.0
