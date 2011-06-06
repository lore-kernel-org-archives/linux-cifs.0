From: Vasily Averin <vvs-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [CIFS] possible memory corruption in cifs_parse_mount_options()
Date: Mon, 06 Jun 2011 11:33:12 +0400
Message-ID: <4DEC82B8.7000701@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

error path after mountdata check frees uninitialized mountdata_copy

Signed-off-by: Vasily Averin <vvs-3ImXcnM4P+0@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6d88b82..dd5e33e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -784,7 +784,7 @@ cifs_parse_mount_options(const char *mountdata, const char
*devname,
 			 struct smb_vol *vol)
 {
 	char *value, *data, *end;
-	char *mountdata_copy, *options;
+	char *mountdata_copy = NULL, *options;
 	unsigned int  temp_len, i, j;
 	char separator[2];
 	short int override_uid = -1;
-- 
1.7.4.1
