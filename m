Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB80EC43334
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 22:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiGVWnE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 18:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiGVWnD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 18:43:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7096FBB5
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 15:43:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E07D4200F2;
        Fri, 22 Jul 2022 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658529779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mecqvNQbDRBiuSmQrfzZJAo2AsF/9ze4S/GkkE9yew0=;
        b=Ku13BS/jvcDnX6rYH+arL2sAtEeG/f0pe4NUnmSqyGrrnlZNmwLUNuZzjDtF3qxP1R3oC+
        Mh5VzEx8Ss1AjPITiGNv7IZg0ZxV0cJ5p6D10B4eufij15CD3g7md9wL/eRnOYwLDEDJRS
        6FTuEDUhCQ5YCFlonsaRTOiUQA1mzr4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658529779;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mecqvNQbDRBiuSmQrfzZJAo2AsF/9ze4S/GkkE9yew0=;
        b=TIhAHS5gC6kIco7R9rCKI9SvfKVZJFp3IUdULGMZbA2if9P8ZX0OB3fdx0lEmDfEvTulXQ
        yVfmuSE/CIut5eAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5EAD2134A9;
        Fri, 22 Jul 2022 22:42:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yaRQCPMn22J/IgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 22 Jul 2022 22:42:59 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH 1/4] cifs: remove unused code
Date:   Fri, 22 Jul 2022 19:42:51 -0300
Message-Id: <20220722224254.8738-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove some macros definitions and several structs, most from cifspdu.h
Move smb3_sd and smb3_acl structs to smb2pdu.h, where it makes more
sense to have them. Also rename smb3_sd to smb3_sec_desc, to give a bit
more of context to it.

Other than that, no functional changes.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsacl.h    |  25 --------
 fs/cifs/cifsfs.c     |   1 -
 fs/cifs/cifsfs.h     |   1 -
 fs/cifs/cifsglob.h   |  15 -----
 fs/cifs/cifspdu.h    | 147 -------------------------------------------
 fs/cifs/dfs_cache.c  |   1 -
 fs/cifs/smb2pdu.h    |  28 ++++++++-
 fs/cifs/smbencrypt.c |  12 ----
 8 files changed, 27 insertions(+), 203 deletions(-)

diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index ccbfc754bd3c..f7037fd03886 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -119,23 +119,6 @@ struct cifs_ace {
 	struct cifs_sid sid; /* ie UUID of user or group who gets these perms */
 } __attribute__((packed));
 
-/*
- * The current SMB3 form of security descriptor is similar to what was used for
- * cifs (see above) but some fields are split, and fields in the struct below
- * matches names of fields to the spec, MS-DTYP (see sections 2.4.5 and
- * 2.4.6). Note that "CamelCase" fields are used in this struct in order to
- * match the MS-DTYP and MS-SMB2 specs which define the wire format.
- */
-struct smb3_sd {
-	__u8 Revision; /* revision level, MUST be one */
-	__u8 Sbz1; /* only meaningful if 'RM' flag set below */
-	__le16 Control;
-	__le32 OffsetOwner;
-	__le32 OffsetGroup;
-	__le32 OffsetSacl;
-	__le32 OffsetDacl;
-} __packed;
-
 /* Meaning of 'Control' field flags */
 #define ACL_CONTROL_SR	0x8000	/* Self relative */
 #define ACL_CONTROL_RM	0x4000	/* Resource manager control bits */
@@ -158,14 +141,6 @@ struct smb3_sd {
 #define ACL_REVISION	0x02 /* See section 2.4.4.1 of MS-DTYP */
 #define ACL_REVISION_DS	0x04 /* Additional AceTypes allowed */
 
-struct smb3_acl {
-	u8 AclRevision; /* revision level */
-	u8 Sbz1; /* MBZ */
-	__le16 AclSize;
-	__le16 AceCount;
-	__le16 Sbz2; /* MBZ */
-} __packed;
-
 /*
  * Used to store the special 'NFS SIDs' used to persist the POSIX uid and gid
  * See http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4c3a9c97d766..da2a53daeae3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -66,7 +66,6 @@ bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
-unsigned int sign_CIFS_PDUs = 1;
 atomic_t mid_count;
 atomic_t buf_alloc_count;
 atomic_t small_buf_alloc_count;
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index b17be47a8e59..d7f4917c191d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -108,7 +108,6 @@ extern int cifs_flush(struct file *, fl_owner_t id);
 extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
 extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
 extern const struct file_operations cifs_dir_ops;
-extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, struct dir_context *ctx);
 
 /* Functions related to dir entries */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2a458db1b5ae..721799b9a7a9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1747,20 +1747,6 @@ static inline void cifs_save_when_sent(struct mid_q_entry *mid)
 }
 #endif
 
-/* for pending dnotify requests */
-struct dir_notify_req {
-	struct list_head lhead;
-	__le16 Pid;
-	__le16 PidHigh;
-	__u16 Mid;
-	__u16 Tid;
-	__u16 Uid;
-	__u16 netfid;
-	__u32 filter; /* CompletionFilter (for multishot) */
-	int multishot;
-	struct file *pfile;
-};
-
 struct dfs_info3_param {
 	int flags; /* DFSREF_REFERRAL_SERVER, DFSREF_STORAGE_SERVER*/
 	int path_consumed;
@@ -1987,7 +1973,6 @@ extern bool enable_oplocks; /* enable or disable oplocks */
 extern bool lookupCacheEnabled;
 extern unsigned int global_secflags;	/* if on, session setup sent
 				with more secure ntlmssp2 challenge/resp */
-extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
 extern bool enable_gcm_256; /* allow optional negotiate of strongest signing (aes-gcm-256) */
 extern bool require_gcm_256; /* require use of strongest signing (aes-gcm-256) */
 extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available */
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 36df9a55376f..d869e1ed3648 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -836,12 +836,6 @@ typedef struct smb_com_findclose_req {
 #define NO_EAS			0x0001
 #define NO_SUBSTREAMS		0x0002
 #define NO_REPARSETAG		0x0004
-/* following flags can apply if pipe */
-#define ICOUNT_MASK		0x00FF
-#define PIPE_READ_MODE		0x0100
-#define NAMED_PIPE_TYPE		0x0400
-#define PIPE_END_POINT		0x4000
-#define BLOCKING_NAMED_PIPE	0x8000
 
 typedef struct smb_com_open_req {	/* also handles create */
 	struct smb_hdr hdr;	/* wct = 24 */
@@ -1281,14 +1275,6 @@ typedef struct smb_com_ntransact_rsp {
 	/* parms and data follow */
 } __attribute__((packed)) NTRANSACT_RSP;
 
-/* See MS-SMB 2.2.7.2.1.1 */
-struct srv_copychunk {
-	__le64 SourceOffset;
-	__le64 DestinationOffset;
-	__le32 CopyLength;
-	__u32  Reserved;
-} __packed;
-
 typedef struct smb_com_transaction_ioctl_req {
 	struct smb_hdr hdr;	/* wct = 23 */
 	__u8 MaxSetupCount;
@@ -1511,16 +1497,6 @@ struct reparse_posix_data {
 	char	PathBuffer[];
 } __attribute__((packed));
 
-struct cifs_quota_data {
-	__u32	rsrvd1;  /* 0 */
-	__u32	sid_size;
-	__u64	rsrvd2;  /* 0 */
-	__u64	space_used;
-	__u64	soft_limit;
-	__u64	hard_limit;
-	char	sid[1];  /* variable size? */
-} __attribute__((packed));
-
 /* quota sub commands */
 #define QUOTA_LIST_CONTINUE	    0
 #define QUOTA_LIST_START	0x100
@@ -1547,11 +1523,6 @@ struct trans2_req {
 	__le16 ByteCount;
 } __attribute__((packed));
 
-struct smb_t2_req {
-	struct smb_hdr hdr;
-	struct trans2_req t2_req;
-} __attribute__((packed));
-
 struct trans2_resp {
 	/* struct smb_hdr hdr precedes. Note wct = 10 + setup count */
 	__le16 TotalParameterCount;
@@ -2072,43 +2043,6 @@ typedef struct smb_com_transaction_get_dfs_refer_rsp {
  ************************************************************************
  */
 
-/*
- * Information on a server
- */
-
-struct serverInfo {
-	char name[16];
-	unsigned char versionMajor;
-	unsigned char versionMinor;
-	unsigned long type;
-	unsigned int commentOffset;
-} __attribute__((packed));
-
-/*
- * The following structure is the format of the data returned on a NetShareEnum
- * with level "90" (x5A)
- */
-
-struct shareInfo {
-	char shareName[13];
-	char pad;
-	unsigned short type;
-	unsigned int commentOffset;
-} __attribute__((packed));
-
-struct aliasInfo {
-	char aliasName[9];
-	char pad;
-	unsigned int commentOffset;
-	unsigned char type[2];
-} __attribute__((packed));
-
-struct aliasInfo92 {
-	int aliasNameOffset;
-	int serverNameOffset;
-	int shareNameOffset;
-} __attribute__((packed));
-
 typedef struct {
 	__le64 TotalAllocationUnits;
 	__le64 FreeAllocationUnits;
@@ -2363,36 +2297,10 @@ typedef struct {
 	__u32 Pad;
 } __attribute__((packed)) FILE_BASIC_INFO;	/* size info, level 0x101 */
 
-struct file_allocation_info {
-	__le64 AllocationSize; /* Note old Samba srvr rounds this up too much */
-} __attribute__((packed));	/* size used on disk, for level 0x103 for set,
-				   0x105 for query */
-
 struct file_end_of_file_info {
 	__le64 FileSize;		/* offset to end of file */
 } __attribute__((packed)); /* size info, level 0x104 for set, 0x106 for query */
 
-struct file_alt_name_info {
-	__u8   alt_name[1];
-} __attribute__((packed));      /* level 0x0108 */
-
-struct file_stream_info {
-	__le32 number_of_streams;  /* BB check sizes and verify location */
-	/* followed by info on streams themselves
-		u64 size;
-		u64 allocation_size
-		stream info */
-};      /* level 0x109 */
-
-struct file_compression_info {
-	__le64 compressed_size;
-	__le16 format;
-	__u8   unit_shift;
-	__u8   ch_shift;
-	__u8   cl_shift;
-	__u8   pad[3];
-} __attribute__((packed));      /* level 0x10b */
-
 /* POSIX ACL set/query path info structures */
 #define CIFS_ACL_VERSION 1
 struct cifs_posix_ace { /* access control entry (ACE) */
@@ -2465,16 +2373,6 @@ struct file_internal_info {
 	__le64  UniqueId; /* inode number */
 } __attribute__((packed));      /* level 0x3ee */
 
-struct file_mode_info {
-	__le32	Mode;
-} __attribute__((packed));      /* level 0x3f8 */
-
-struct file_attrib_tag {
-	__le32 Attribute;
-	__le32 ReparseTag;
-} __attribute__((packed));      /* level 0x40b */
-
-
 /********************************************************/
 /*  FindFirst/FindNext transact2 data buffer formats    */
 /********************************************************/
@@ -2572,16 +2470,6 @@ struct win_dev {
 	__le64 minor;
 } __attribute__((packed));
 
-struct gea {
-	unsigned char name_len;
-	char name[1];
-} __attribute__((packed));
-
-struct gealist {
-	unsigned long list_len;
-	struct gea list[1];
-} __attribute__((packed));
-
 struct fea {
 	unsigned char EA_flags;
 	__u8 name_len;
@@ -2597,14 +2485,6 @@ struct fealist {
 	struct fea list[1];
 } __attribute__((packed));
 
-/* used to hold an arbitrary blob of data */
-struct data_blob {
-	__u8 *data;
-	size_t length;
-	void (*free) (struct data_blob *data_blob);
-} __attribute__((packed));
-
-
 #ifdef CONFIG_CIFS_POSIX
 /*
 	For better POSIX semantics from Linux client, (even better
@@ -2680,33 +2560,6 @@ struct data_blob {
 	T2_QFS_INFO QueryDevice/AttributeInfo - OPTIONAL
  */
 
-/* xsymlink is a symlink format (used by MacOS) that can be used
-   to save symlink info in a regular file when
-   mounted to operating systems that do not
-   support the cifs Unix extensions or EAs (for xattr
-   based symlinks).  For such a file to be recognized
-   as containing symlink data:
-
-   1) file size must be 1067,
-   2) signature must begin file data,
-   3) length field must be set to ASCII representation
-	of a number which is less than or equal to 1024,
-   4) md5 must match that of the path data */
-
-struct xsymlink {
-	/* 1067 bytes */
-	char signature[4]; /* XSym */ /* not null terminated */
-	char cr0;         /* \n */
-/* ASCII representation of length (4 bytes decimal) terminated by \n not null */
-	char length[4];
-	char cr1;         /* \n */
-/* md5 of valid subset of path ie path[0] through path[length-1] */
-	__u8 md5[32];
-	char cr2;        /* \n */
-/* if room left, then end with \n then 0x20s by convention but not required */
-	char path[1024];
-} __attribute__((packed));
-
 typedef struct file_xattr_info {
 	/* BB do we need another field for flags? BB */
 	__u32 xattr_name_len;
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 34a8f3baed5e..1587ac435724 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -382,7 +382,6 @@ static inline void dump_refs(const struct dfs_info3_param *refs, int numrefs)
 	}
 }
 #else
-#define dump_tgts(e)
 #define dump_ce(e)
 #define dump_refs(r, n)
 #endif
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f57881b8464f..286044850e85 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -203,12 +203,38 @@ struct crt_query_id_ctxt {
 	__u8	Name[8];
 } __packed;
 
+/*
+ * The current SMB3 form of security descriptor is similar to what was used for
+ * cifs (see cifsacl.h) but some fields are split, and fields in the struct
+ * below matches names of fields to the spec, MS-DTYP (see sections 2.4.5 and
+ * 2.4.6).
+ *
+ * Note that "CamelCase" fields are used in this struct in order to match the
+ * MS-DTYP and MS-SMB2 specs which define the wire format.
+ */
+struct smb3_sec_desc {
+	__u8 Revision; /* revision level, MUST be one */
+	__u8 Sbz1; /* only meaningful if 'ACL_CONTROL_RM' flag set (cifsacl.h) */
+	__le16 Control;
+	__le32 OffsetOwner;
+	__le32 OffsetGroup;
+	__le32 OffsetSacl;
+	__le32 OffsetDacl;
+} __packed;
+
 struct crt_sd_ctxt {
 	struct create_context ccontext;
 	__u8	Name[8];
-	struct smb3_sd sd;
+	struct smb3_sec_desc sd;
 } __packed;
 
+struct smb3_acl {
+	u8 AclRevision; /* revision level */
+	u8 Sbz1; /* MBZ */
+	__le16 AclSize;
+	__le16 AceCount;
+	__le16 Sbz2; /* MBZ */
+} __packed;
 
 #define COPY_CHUNK_RES_KEY_SIZE	24
 struct resume_key_req {
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 4a0487753869..0214092d2714 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -26,18 +26,6 @@
 #include "cifsproto.h"
 #include "../smbfs_common/md4.h"
 
-#ifndef false
-#define false 0
-#endif
-#ifndef true
-#define true 1
-#endif
-
-/* following came from the other byteorder.h to avoid include conflicts */
-#define CVAL(buf,pos) (((unsigned char *)(buf))[pos])
-#define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
-#define SSVAL(buf,pos,val) SSVALX((buf),(pos),((__u16)(val)))
-
 /* produce a md4 message digest from data of length n bytes */
 static int
 mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
-- 
2.35.3

