From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix memory over bound bug in cifs_parse_mount_options
Date: Thu, 14 Apr 2011 22:00:56 +0400
Message-ID: <1302804056-22865-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While password processing we can get out of options array bound if
the next character after array is delimiter. The patch adds a check
if we reach the end.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index db9d55b..4bc862a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -807,8 +807,7 @@ static int
 cifs_parse_mount_options(char *options, const char *devname,
 			 struct smb_vol *vol)
 {
-	char *value;
-	char *data;
+	char *value, *data, *end;
 	unsigned int  temp_len, i, j;
 	char separator[2];
 	short int override_uid = -1;
@@ -851,6 +850,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 	if (!options)
 		return 1;
 
+	end = options + strlen(options);
 	if (strncmp(options, "sep=", 4) == 0) {
 		if (options[4] != 0) {
 			separator[0] = options[4];
@@ -916,6 +916,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			the only illegal character in a password is null */
 
 			if ((value[temp_len] == 0) &&
+			    (value + temp_len < end) &&
 			    (value[temp_len+1] == separator[0])) {
 				/* reinsert comma */
 				value[temp_len] = separator[0];
-- 
1.7.1
