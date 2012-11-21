From: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] CIFS: Fix IP address bounds checking on mount utility.
Date: Wed, 21 Nov 2012 15:10:52 -0500
Message-ID: <1353528652-8912-1-git-send-email-scott.lovenberg@gmail.com>
Cc: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index a9632b4..f63c309 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -941,8 +941,8 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			if (!value || !*value) {
 				fprintf(stderr,
 					"target ip address argument missing\n");
-			} else if (strnlen(value, MAX_ADDRESS_LEN) <=
-				MAX_ADDRESS_LEN) {
+			} else if (strnlen(value, MAX_ADDR_LIST_LEN + 1) <=
+				MAX_ADDR_LIST_LEN) {
 				strcpy(parsed_info->addrlist, value);
 				if (parsed_info->verboseflag)
 					fprintf(stderr,
-- 
1.7.5.4
