From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Q: cifs, freeing volume_info->UNCip
Date: Tue, 16 Aug 2011 08:22:17 +0900
Message-ID: <7087.1313450537@jrobl>
Cc: linux-kernel@vger.kernel.org, kirk w <kirkpuppy@yahoo.com>
To: smfrench@gmail.com, linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


Hello,

CIFS cleanup_volume_info_contents() looks like having a memory
corruption problem.
When UNCip is set to "&vol->UNC[2]" in cifs_parse_mount_options(), it
should not be kfree()-ed in cleanup_volume_info_contents().

If it is correct and the code in mainline is not fixed yet, then here is
a patch.

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccc1afa..e0ea721 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2838,7 +2838,8 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
 	kfree(volume_info->username);
 	kzfree(volume_info->password);
 	kfree(volume_info->UNC);
-	kfree(volume_info->UNCip);
+	if (volume_info->UNCip != volume_info->UNC + 2)
+		kfree(volume_info->UNCip);
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);


J. R. Okajima
