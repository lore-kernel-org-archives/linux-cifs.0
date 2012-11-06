From: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Subject: [PATCH] Convert slashes in the UNC parameter to backslashes
Date: Tue, 06 Nov 2012 13:29:47 +0100
Message-ID: <509902BB.6020400@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch ensures that slashes used as separators in the
UNC are properly converted to backslashes. The existing
implementation did not perform that conversion and that
lead to a "invalid argument" error when specifying an UNC
explicitly which contained slashes in it.

---
  fs/cifs/connect.c |   12 ++++++------
  1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5c670b9..8f4c76f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1108,6 +1108,7 @@ cifs_parse_mount_options(const char *mountdata, 
const char *devname,
  	char *string = NULL;
  	char *tmp_end, *value;
  	char delim;
+	char *p, *q;

  	separator[0] = ',';
  	separator[1] = 0;
@@ -1573,12 +1574,11 @@ cifs_parse_mount_options(const char *mountdata, 
const char *devname,
  				printk(KERN_WARNING "CIFS: no memory for UNC\n");
  				goto cifs_parse_mount_err;
  			}
-			strcpy(vol->UNC, string);
-
-			if (strncmp(string, "//", 2) == 0) {
-				vol->UNC[0] = '\\';
-				vol->UNC[1] = '\\';
-			} else if (strncmp(string, "\\\\", 2) != 0) {
+			for (p = string, q = vol->UNC; *p; ++p, ++q) {
+				*q = *p == '/'? '\\' : *p;
+			}
+			*q = '\0';
+			if (strncmp(vol->UNC, "\\\\", 2) != 0) {
  				printk(KERN_WARNING "CIFS: UNC Path does not "
  						    "begin with // or \\\\\n");
  				goto cifs_parse_mount_err;
-- 
1.7.2.5
