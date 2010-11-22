From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH] cifs: remove Local_System_Name
Date: Mon, 22 Nov 2010 15:31:03 -0500
Message-ID: <1290457863-10804-3-git-send-email-jlayton@redhat.com>
References: <1290457863-10804-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290457863-10804-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...this string is zeroed out and nothing ever changes it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    1 -
 fs/cifs/cifsglob.h |    2 --
 fs/cifs/connect.c  |   23 ++++++++++-------------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 041d7c3..57a7386 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -931,7 +931,6 @@ init_cifs(void)
 	GlobalCurrentXid = 0;
 	GlobalTotalActiveXid = 0;
 	GlobalMaxActiveXid = 0;
-	memset(Local_System_Name, 0, 15);
 	spin_lock_init(&cifs_tcp_ses_lock);
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b4c2524..2ffa029 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -743,8 +743,6 @@ GLOBAL_EXTERN unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
 GLOBAL_EXTERN unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
 GLOBAL_EXTERN spinlock_t GlobalMid_Lock;  /* protects above & list operations */
 					  /* on midQ entries */
-GLOBAL_EXTERN char Local_System_Name[15];
-
 /*
  *  Global counters, updated atomically
  */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 251a17c..7758120 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -806,23 +806,20 @@ cifs_parse_mount_options(char *options, const char *devname,
 	short int override_gid = -1;
 	bool uid_specified = false;
 	bool gid_specified = false;
+	char *nodename = utsname()->nodename;
 
 	separator[0] = ',';
 	separator[1] = 0;
 
-	if (Local_System_Name[0] != 0)
-		memcpy(vol->source_rfc1001_name, Local_System_Name, 15);
-	else {
-		char *nodename = utsname()->nodename;
-		int n = strnlen(nodename, 15);
-		memset(vol->source_rfc1001_name, 0x20, 15);
-		for (i = 0; i < n; i++) {
-			/* does not have to be perfect mapping since field is
-			informational, only used for servers that do not support
-			port 445 and it can be overridden at mount time */
-			vol->source_rfc1001_name[i] = toupper(nodename[i]);
-		}
-	}
+	/*
+	 * does not have to be perfect mapping since field is
+	 * informational, only used for servers that do not support
+	 * port 445 and it can be overridden at mount time
+	 */
+	memset(vol->source_rfc1001_name, 0x20, 15);
+	for (i = 0; i < strnlen(nodename, 15); i++)
+		vol->source_rfc1001_name[i] = toupper(nodename[i]);
+
 	vol->source_rfc1001_name[15] = 0;
 	/* null target name indicates to use *SMBSERVR default called name
 	   if we end up sending RFC1001 session initialize */
-- 
1.7.3.2
