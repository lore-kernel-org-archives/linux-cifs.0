From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: replace some hardcoded values with preprocessor constants
Date: Wed,  1 Dec 2010 09:49:45 -0500
Message-ID: <1291214985-31607-1-git-send-email-jlayton@redhat.com>
References: <20101201092731.7aeded31@tlielax.poochiereds.net>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101201092731.7aeded31-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A number of places that deal with RFC1001/1002 negotiations have bare
"15" or "16" values. Replace them with RFC_1001_NAME_LEN and
RFC_1001_NAME_LEN_WITH_NULL.

The patch also cleans up some checkpatch warnings for code surrounding
the changes. This should apply cleanly on top of the patch to remove
Local_System_Name.

Reported-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5d48e09..a96324b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -64,8 +64,8 @@ struct smb_vol {
 	char *UNC;
 	char *UNCip;
 	char *iocharset;  /* local code page for mapping to and from Unicode */
-	char source_rfc1001_name[16]; /* netbios name of client */
-	char target_rfc1001_name[16]; /* netbios name of server for Win9x/ME */
+	char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
+	char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
 	uid_t cred_uid;
 	uid_t linux_uid;
 	gid_t linux_gid;
@@ -816,11 +816,11 @@ cifs_parse_mount_options(char *options, const char *devname,
 	 * informational, only used for servers that do not support
 	 * port 445 and it can be overridden at mount time
 	 */
-	memset(vol->source_rfc1001_name, 0x20, 15);
-	for (i = 0; i < strnlen(nodename, 15); i++)
+	memset(vol->source_rfc1001_name, 0x20, RFC1001_NAME_LEN);
+	for (i = 0; i < strnlen(nodename, RFC1001_NAME_LEN); i++)
 		vol->source_rfc1001_name[i] = toupper(nodename[i]);
 
-	vol->source_rfc1001_name[15] = 0;
+	vol->source_rfc1001_name[RFC1001_NAME_LEN] = 0;
 	/* null target name indicates to use *SMBSERVR default called name
 	   if we end up sending RFC1001 session initialize */
 	vol->target_rfc1001_name[0] = 0;
@@ -1165,22 +1165,22 @@ cifs_parse_mount_options(char *options, const char *devname,
 			if (!value || !*value || (*value == ' ')) {
 				cFYI(1, "invalid (empty) netbiosname");
 			} else {
-				memset(vol->source_rfc1001_name, 0x20, 15);
-				for (i = 0; i < 15; i++) {
-				/* BB are there cases in which a comma can be
-				valid in this workstation netbios name (and need
-				special handling)? */
-
-				/* We do not uppercase netbiosname for user */
+				memset(vol->source_rfc1001_name, 0x20,
+					RFC1001_NAME_LEN);
+				/*
+				 * FIXME: are there cases in which a comma can
+				 * be valid in workstation netbios name (and
+				 * need special handling)?
+				 */
+				for (i = 0; i < RFC1001_NAME_LEN; i++) {
+					/* don't ucase netbiosname for user */
 					if (value[i] == 0)
 						break;
-					else
-						vol->source_rfc1001_name[i] =
-								value[i];
+					vol->source_rfc1001_name[i] = value[i];
 				}
 				/* The string has 16th byte zero still from
 				set at top of the function  */
-				if ((i == 15) && (value[i] != 0))
+				if (i == RFC1001_NAME_LEN && value[i] != 0)
 					printk(KERN_WARNING "CIFS: netbiosname"
 						" longer than 15 truncated.\n");
 			}
@@ -1190,7 +1190,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 				cFYI(1, "empty server netbiosname specified");
 			} else {
 				/* last byte, type, is 0x20 for servr type */
-				memset(vol->target_rfc1001_name, 0x20, 16);
+				memset(vol->target_rfc1001_name, 0x20,
+					RFC1001_NAME_LEN_WITH_NULL);
 
 				for (i = 0; i < 15; i++) {
 				/* BB are there cases in which a comma can be
@@ -1207,7 +1208,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 				}
 				/* The string has 16th byte zero still from
 				   set at top of the function  */
-				if ((i == 15) && (value[i] != 0))
+				if (i == RFC1001_NAME_LEN && value[i] != 0)
 					printk(KERN_WARNING "CIFS: server net"
 					"biosname longer than 15 truncated.\n");
 			}
-- 
1.7.3.2
