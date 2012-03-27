From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Add missed forcemand mount option
Date: Tue, 27 Mar 2012 20:51:15 +0400
Message-ID: <1332867075-3231-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The 'forcemand' form of 'forcemandatorylock' mount option was missed
when the code moved to use the standard token parser. Return it back.

Also fix a comment style in the parser.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 26327ea..7e4775c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -140,6 +140,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_nobrl, "nobrl" },
 	{ Opt_nobrl, "nolock" },
 	{ Opt_forcemandatorylock, "forcemandatorylock" },
+	{ Opt_forcemandatorylock, "forcemand" },
 	{ Opt_setuids, "setuids" },
 	{ Opt_nosetuids, "nosetuids" },
 	{ Opt_dynperm, "dynperm" },
@@ -1397,9 +1398,11 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			break;
 		case Opt_nobrl:
 			vol->nobrl =  1;
-			/* turn off mandatory locking in mode
+			/*
+			 * turn off mandatory locking in mode
 			 * if remote locking is turned off since the
-			 * local vfs will do advisory */
+			 * local vfs will do advisory
+			 */
 			if (vol->file_mode ==
 				(S_IALLUGO & ~(S_ISUID | S_IXGRP)))
 				vol->file_mode = S_IALLUGO;
-- 
1.7.1
