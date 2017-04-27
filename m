From: Daniel N Pettersson <daniel.n.pettersson-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH] cifs: fix IPv6 link local, with scope id, address parsing
Date: Thu, 27 Apr 2017 11:32:36 +0200
Message-ID: <1493285556-18947-1-git-send-email-Daniel.N.Pettersson@axis.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel N Pettersson <danielnp-VrBV9hrLPhE@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Daniel N Pettersson <danielnp-VrBV9hrLPhE@public.gmane.org>

When the IP address is gotten from the UNC, use only the address part
of the UNC. Else all after the percent sign in an IPv6 link local
address is interpreted as a scope id. This includes the slash and
share name. A scope id is expected to be an integer and any trailing
characters makes the conversion to integer fail.
Example of mount command that fails:
mount -i -t cifs //fe80::6a05:caff:fe3e:8ffc%2/test /mnt/t -o sec=none

Signed-off-by: Daniel N Pettersson <danielnp-VrBV9hrLPhE@public.gmane.org>
---
 fs/cifs/connect.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d82467c..3f7819e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1945,9 +1945,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	}
 
 	if (!got_ip) {
+		int len;
+		const char *slash;
+
 		/* No ip= option specified? Try to get it from UNC */
-		if (!cifs_convert_address(dstaddr, &vol->UNC[2],
-						strlen(&vol->UNC[2]))) {
+		/* Use the address part of the UNC. */
+		slash = strchr(&vol->UNC[2], '\\');
+		len = slash - &vol->UNC[2];
+		if (!cifs_convert_address(dstaddr, &vol->UNC[2], len)) {
 			pr_err("Unable to determine destination address.\n");
 			goto cifs_parse_mount_err;
 		}
-- 
2.1.4
