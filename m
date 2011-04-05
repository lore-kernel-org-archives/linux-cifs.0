From: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] mount.cifs: only convert '\' to '/' for dev_name
Date: Wed,  6 Apr 2011 00:26:48 +0200
Message-ID: <1302042408-10579-1-git-send-email-luk@debian.org>
References: <20110405085147.22dc6829@corrin.poochiereds.net>
Cc: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110405085147.22dc6829-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When dev_name is constructed by combining slashes with the different
parsed_mount_info fields, there can be an unnecessary appended slash
compared to the original device string. So only convert backslashes
to slashes to get the device name from the original device string.

Signed-off-by: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
---
 mount.cifs.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 8e1e32b..2cec7e4 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1824,10 +1824,7 @@ int main(int argc, char **argv)
 	}
 
 	/* lengths of different strings + slashes + trailing \0 */
-	dev_len = strnlen(parsed_info->host, sizeof(parsed_info->host)) +
-	    strnlen(parsed_info->share, sizeof(parsed_info->share)) +
-	    strnlen(parsed_info->prefix, sizeof(parsed_info->prefix)) +
-	    2 + 1 + 1 + 1;
+	dev_len = strlen(orig_dev) + 1;
 	dev_name = calloc(dev_len, 1);
 	if (!dev_name) {
 		rc = EX_SYSERR;
@@ -1835,12 +1832,10 @@ int main(int argc, char **argv)
 	}
 
 	/* rebuild device name with forward slashes */
-	strlcpy(dev_name, "//", dev_len);
-	strlcat(dev_name, parsed_info->host, dev_len);
-	strlcat(dev_name, "/", dev_len);
-	strlcat(dev_name, parsed_info->share, dev_len);
-	strlcat(dev_name, "/", dev_len);
-	strlcat(dev_name, parsed_info->prefix, dev_len);
+	strlcpy(dev_name, orig_dev, dev_len);
+	while (c = strcspn(dev_name, "\\") < dev_len - 1) {
+		dev_name[c] = '/';
+	}
 
 	currentaddress = parsed_info->addrlist;
 	nextaddress = strchr(currentaddress, ',');
-- 
1.7.4.1
