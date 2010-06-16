From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: use original device name as-is for mtab
Date: Wed, 16 Jun 2010 15:44:33 -0400
Message-ID: <1276717473-12198-1-git-send-email-jlayton@samba.org>
To: linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We don't want to alter the device name in any way for the mtab as
/bin/umount depends on the string being identical for user mounts.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 21ce532..51fc1a8 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1953,7 +1953,7 @@ mount_retry:
 	}
 
 	if (!parsed_info->nomtab)
-		rc = add_mtab(dev_name, mountpoint, parsed_info->flags, fstype);
+		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
 
 mount_exit:
 	if (parsed_info) {
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
