From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: Cleanup cifs headers for smb2 debugging routines
Date: Fri, 25 Feb 2011 23:21:21 -0600
Message-ID: <AANLkTikRtx3vLWhW2M9F06m8MLUCyT0YpG4A3aoBiUzD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit e2730dd792051dad902410a3f121389239ac41fa
Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Fri Feb 25 18:09:31 2011 -0600

    [CIFS] Cleanup cifs headers for smb2 debugging routines

    Prepratory to merging more of the smb2 global routines
    1) cleanup some unused structs and defines
    2) add in externs for smb2 debugging routines

    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/TODO b/fs/cifs/TODO
index 355abcd..2c68abc 100644
--- a/fs/cifs/TODO
+++ b/fs/cifs/TODO
@@ -1,5 +1,7 @@
 Version 1.53 May 20, 2008

+PUT IN WARNING FOR NTLMV2 becoming default
+
 A Partial List of Missing Features
 ==================================

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 8942b28..fec0743 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -1,6 +1,6 @@
 /*
  *
- *   Copyright (c) International Business Machines  Corp., 2000,2002
+ *   Copyright (c) International Business Machines  Corp., 2000,2011
  *   Modified by Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This program is free software;  you can redistribute it and/or modify
@@ -18,7 +18,7 @@
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
 */
-#define CIFS_DEBUG		/* BB temporary */
+#define CIFS_DEBUG		/* remove to disable cifserror logging */

 #ifndef _H_CIFS_DEBUG
 #define _H_CIFS_DEBUG
@@ -28,6 +28,9 @@ void cifs_dump_mem(char *label, void *data, int length);
 #define DBG2 2
 void cifs_dump_detail(struct smb_hdr *);
 void cifs_dump_mids(struct TCP_Server_Info *);
+#ifdef CONFIG_CIFS_SMB2
+void smb2_dump_detail(struct smb2_hdr *);
+#endif /* CONFIG_CIFS_SMB2 */
 #else
 #define DBG2 0
 #endif
@@ -37,12 +40,15 @@ void dump_smb(struct smb_hdr *, int);
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04

+#ifdef CONFIG_CIFS_SMB2
+void dump_smb2(struct smb2_hdr *, int);
+#endif /* CONFIG_CIFS_SMB2 */
+
 /*
  *	debug ON
  *	--------
  */
 #ifdef CIFS_DEBUG
-
 /* information message: e.g., configuration, major event */
 extern int cifsFYI;
 #define cifsfyi(fmt, arg...)						\
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index c4ae7d0..025e943 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/cifsacl.h
  *
- *   Copyright (c) International Business Machines  Corp., 2007
+ *   Copyright (c) International Business Machines  Corp., 2007,2010
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 293b636..232b790 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/cifsglob.h
  *
- *   Copyright (C) International Business Machines  Corp., 2002,2008
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *              Jeremy Allison (jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
  *
@@ -595,13 +595,6 @@ struct mid_q_entry {
 	bool multiEnd:1;	/* both received */
 };

-struct oplock_q_entry {
-	struct list_head qhead;
-	struct inode *pinode;
-	struct cifsTconInfo *tcon;
-	__u16 netfid;
-};
-
 /* for pending dnotify requests */
 struct dir_notify_req {
 	struct list_head lhead;
@@ -651,6 +644,7 @@ struct cifs_fattr {
 	struct timespec	cf_atime;
 	struct timespec	cf_mtime;
 	struct timespec	cf_ctime;
+	u32 		ea_size;
 };

 static inline void free_dfs_info_param(struct dfs_info3_param *param)
@@ -681,6 +675,7 @@ static inline void free_dfs_info_array(struct
dfs_info3_param *param,
 #define   MID_RESPONSE_RECEIVED 4
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
 #define   MID_RESPONSE_MALFORMED 0x10
+#define   MID_NO_RESPONSE_NEEDED 0x20

 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
@@ -739,13 +734,6 @@ require use of the stronger protocol */
 #define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM |
CIFSSEC_MAY_NTLMV2)
 #define   CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
 #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 |
CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 |
CIFSSEC_MAY_NTLMSSP)
-/*
- *****************************************************************
- * All constants go here
- *****************************************************************
- */
-
-#define UID_HASH (16)

 /*
  * Note that ONE module should define _DECLARE_GLOBALS_HERE to cause the

-- 
Thanks,

Steve
