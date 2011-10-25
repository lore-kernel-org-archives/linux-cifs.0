From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 01/53] CIFS: Update cifs global structures to handle smb2 sessions
Date: Tue, 25 Oct 2011 10:11:34 +0400
Message-ID: <1319523146-2859-2-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

cifsglob.h defines the per socket structures
smb2 could already use the per-smb socket structures,
but to use the per-socket structures required additional
optional fields. (Note that the tree connection
structure differs substantially and will probably endup
as a based tcon structure used by smb2 and cifs and a
union for the stats.

Also save whole smb2 dialect minor version - Jeff suggested
that easier to handle future version updates if we treat
the minor version in its native wire form rather than as
series of booleans.

Prepratory to merging more of the smb2 global routines
1) cleanup some unused structs and defines
2) add in externs for smb2 debugging routines

smb2 needs to save off device_type on tcon and share_flags on tcon and
session flags and subdialect on sessionsetup

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/TODO         |    2 ++
 fs/cifs/cifs_debug.h |   12 +++++++++---
 fs/cifs/cifs_fs_sb.h |    4 +++-
 fs/cifs/cifsacl.h    |    2 +-
 fs/cifs/cifsglob.h   |   44 +++++++++++++++++++++++++++++++++-----------
 fs/cifs/cifspdu.h    |    2 ++
 fs/cifs/cifssmb.c    |    2 +-
 fs/cifs/sess.c       |    2 +-
 8 files changed, 52 insertions(+), 18 deletions(-)

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
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 500d658..8e6dd9a 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/cifs_fs_sb.h
  *
- *   Copyright (c) International Business Machines  Corp., 2002,2004
+ *   Copyright (c) International Business Machines  Corp., 2002,2010
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -24,10 +24,12 @@
 
 #define CIFS_MOUNT_NO_PERM      1 /* do not do client vfs_perm check */
 #define CIFS_MOUNT_SET_UID      2 /* set current's euid in create etc. */
+/* SERVER_INUM is always set for SMB2 */
 #define CIFS_MOUNT_SERVER_INUM  4 /* inode numbers from uniqueid from server  */
 #define CIFS_MOUNT_DIRECT_IO    8 /* do not write nor read through page cache */
 #define CIFS_MOUNT_NO_XATTR     0x10  /* if set - disable xattr support       */
 #define CIFS_MOUNT_MAP_SPECIAL_CHR 0x20 /* remap illegal chars in filenames   */
+/* The following two are not supported for SMB2 */
 #define CIFS_MOUNT_POSIX_PATHS  0x40  /* Negotiate posix pathnames if possible*/
 #define CIFS_MOUNT_UNX_EMUL     0x80  /* Network compat with SFUnix emulation */
 #define CIFS_MOUNT_NO_BRL       0x100 /* No sending byte range locks to srv   */
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 5c902c7..ba9a9db 100644
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
index 8238aa1..4c38b04 100644
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
@@ -259,7 +259,7 @@ struct TCP_Server_Info {
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
 	char server_GUID[16];
-	char sec_mode;
+	__u16 sec_mode;
 	bool session_estab; /* mark when very first sess is established */
 	u16 dialect; /* dialect index that server chose */
 	enum securityEnum secType;
@@ -305,6 +305,18 @@ struct TCP_Server_Info {
 	atomic_t in_send; /* requests trying to send */
 	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
 #endif
+#ifdef CONFIG_CIFS_SMB2
+	wait_queue_head_t read_q; /* used by readpages */
+	atomic_t active_readpage_req; /* used by readpages */
+	atomic_t resp_rdy; /* used by readpages and demultiplex */
+	__le16 smb2_dialect_revision; /* SMB2.0 implemented, 2.1 recognized */
+	struct task_struct *observe;
+	char smb2_crypt_key[CIFS_CRYPTO_KEY_SIZE]; /* BB can we use cifs key */
+	__u64 current_smb2_mid;         /* multiplex id - rotating counter */
+	__u8  speed;  /* helps us identify if this is a slow link */
+	unsigned int	max_read;
+	unsigned int	max_write;
+#endif /* CONFIG_CIFS_SMB2 */
 };
 
 /*
@@ -354,7 +366,7 @@ struct cifs_ses {
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
-	int Suid;		/* remote smb uid  */
+	__u64 Suid;		/* remote smb uid  */
 	uid_t linux_uid;        /* overriding owner of files on the mount */
 	uid_t cred_uid;		/* owner of credentials */
 	int capabilities;
@@ -367,6 +379,9 @@ struct cifs_ses {
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
+#ifdef CONFIG_CIFS_SMB2
+	__u16 session_flags;
+#endif /* CONFIG_CIFS_SMB2 */
 };
 /* no more than one of the following three session flags may be set */
 #define CIFS_SES_NT4 1
@@ -376,6 +391,7 @@ struct cifs_ses {
    which do not negotiate NTLM or POSIX dialects, but instead
    negotiate one of the older LANMAN dialects */
 #define CIFS_SES_LANMAN 8
+#define CIFS_SES_SMB2 16
 /*
  * there is one of these for each connection to a resource on a particular
  * session
@@ -388,7 +404,7 @@ struct cifs_tcon {
 	char treeName[MAX_TREE_SIZE + 1]; /* UNC name of resource in ASCII */
 	char *nativeFileSystem;
 	char *password;		/* for share-level security */
-	__u16 tid;		/* The 2 byte tree id */
+	__u32 tid;		/* The 4 byte tree id */
 	__u16 Flags;		/* optional support bits */
 	enum statusEnum tidStatus;
 #ifdef CONFIG_CIFS_STATS
@@ -436,6 +452,7 @@ struct cifs_tcon {
 	FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncated */
 	FILE_SYSTEM_UNIX_INFO fsUnixInfo;
 	bool ipc:1;		/* set if connection to IPC$ eg for RPC/PIPES */
+	bool print:1;		/* set if connection to printer share */
 	bool retry:1;
 	bool nocase:1;
 	bool seal:1;      /* transport encryption for this mounted share */
@@ -444,6 +461,15 @@ struct cifs_tcon {
 	bool local_lease:1; /* check leases (only) on local system not remote */
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+	bool bad_network_name:1;
+#ifdef CONFIG_CIFS_SMB2
+	__u32 capabilities;
+	__u32 share_flags;
+	__u32 maximal_access;
+	__u32 vol_serial_number;
+	__le64 vol_create_time;
+	struct mutex tcon_mutex;
+#endif /* CONFIG_CIFS_SMB2 */
 #ifdef CONFIG_CIFS_FSCACHE
 	u64 resource_id;		/* server resource id */
 	struct fscache_cookie *fscache;	/* cookie for share */
@@ -802,6 +828,7 @@ struct cifs_fattr {
 	struct timespec	cf_atime;
 	struct timespec	cf_mtime;
 	struct timespec	cf_ctime;
+	u32		ea_size;
 };
 
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
@@ -833,6 +860,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
+#define   MID_NO_RESPONSE_NEEDED 0x40
 
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
@@ -841,6 +869,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
+#define   CIFS_STD_OP		0
 #define   CIFS_BLOCKING_OP      1    /* operation can block */
 #define   CIFS_ASYNC_OP         2    /* do not wait for response */
 #define   CIFS_TIMEOUT_MASK 0x003    /* only one of above set in req */
@@ -891,13 +920,6 @@ require use of the stronger protocol */
 #define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2)
 #define   CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
 #define   CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_NTLMSSP)
-/*
- *****************************************************************
- * All constants go here
- *****************************************************************
- */
-
-#define UID_HASH (16)
 
 /*
  * Note that ONE module should define _DECLARE_GLOBALS_HERE to cause the
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 3c6ef34..47c8d81 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -428,6 +428,8 @@ struct smb_hdr {
 	__u8 WordCount;
 } __attribute__((packed));
 
+struct smb2_hdr;
+
 /* given a pointer to an smb_hdr, retrieve a void pointer to the ByteCount */
 static inline void *
 BCC(struct smb_hdr *smb)
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6600aa2..ea7b813 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -457,7 +457,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 			rc = -EOPNOTSUPP;
 			goto neg_err_exit;
 		}
-		server->sec_mode = (__u8)le16_to_cpu(rsp->SecurityMode);
+		server->sec_mode = le16_to_cpu(rsp->SecurityMode);
 		server->maxReq = le16_to_cpu(rsp->MaxMpxCount);
 		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
 		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index c7d80e2..5b7c94f 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -895,7 +895,7 @@ ssetup_ntlmssp_authenticate:
 	if (action & GUEST_LOGIN)
 		cFYI(1, "Guest login"); /* BB mark SesInfo struct? */
 	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
-	cFYI(1, "UID = %d ", ses->Suid);
+	cFYI(1, "UID = %llu ", ses->Suid);
 	/* response can have either 3 or 4 word count - Samba sends 3 */
 	/* and lanman response is 3 */
 	bytes_remaining = get_bcc(smb_buf);
-- 
1.7.1
