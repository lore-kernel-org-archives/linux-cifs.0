From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH] CIFS: Fix NULL pointer dereference in
 cifs_construct_tcon()
Date: Sun, 5 Feb 2012 00:35:19 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the call to kcalloc() fails and returns NULL we'll dereference a
NULL 'vol_info' after we jump to the 'out:' label.

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 986709a..bd67b7c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3859,7 +3859,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 	vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
 	if (vol_info == NULL) {
 		tcon = ERR_PTR(-ENOMEM);
-		goto out;
+		goto out2;
 	}
 
 	vol_info->local_nls = cifs_sb->local_nls;
@@ -3901,7 +3901,7 @@ out:
 	kfree(vol_info->username);
 	kfree(vol_info->password);
 	kfree(vol_info);
-
+out2:
 	return tcon;
 }
 
-- 
1.7.9



-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
