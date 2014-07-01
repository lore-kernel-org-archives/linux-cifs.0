From: =?ISO-8859-15?Q?G=FCnter_Kukkukk?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] on 2nd try mount.cifs must also uppercase "orig_dev" - recent
 kernels now ignore "unc=..." mount option
Date: Tue, 01 Jul 2014 19:05:29 +0200
Message-ID: <53B2EA59.8090404@kukkukk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070704070700090808020302"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070704070700090808020302
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

userland mount helper mount.cifs.

Also uppercase the now used (kernel) "orig_dev" parameter, to get the
mount retry working again.

Cheers, Günter
-- 


--------------070704070700090808020302
Content-Type: text/x-patch;
 name="0001-on-2nd-try-mount.cifs-must-also-uppercase-orig_dev-r.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-on-2nd-try-mount.cifs-must-also-uppercase-orig_dev-r.pa";
 filename*1="tch"

>From 5b6633b93b4df19b6c2863b8c9cf11d622132b60 Mon Sep 17 00:00:00 2001
From: Guenter Kukkukk <kukks-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date: Tue, 1 Jul 2014 17:43:55 +0200
Subject: [PATCH] on 2nd try mount.cifs must also uppercase "orig_dev" - recent
 kernels now ignore "unc=..." mount option

mount.cifs.c, when getting errno=ENXIO, retries the mount with uppercased
hostname, sharename and prefixpath in the "unc=..." mount option, which
is ignored now in the kernel. Used e.g. during OS/2 mounts, which fail now.

Also uppercase the now used "orig_dev" parameter.

Signed-off-by: Guenter Kukkukk <kukks-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 497665d..3535096 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2097,7 +2097,8 @@ mount_retry:
 			if (!already_uppercased &&
 			    uppercase_string(parsed_info->host) &&
 			    uppercase_string(parsed_info->share) &&
-			    uppercase_string(parsed_info->prefix)) {
+			    uppercase_string(parsed_info->prefix) &&
+			    uppercase_string(orig_dev)) {
 				fprintf(stderr,
 					"Retrying with upper case share name\n");
 				already_uppercased = 1;
-- 
1.8.4.5


--------------070704070700090808020302--
