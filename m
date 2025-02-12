Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017C220C487
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 12:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739364292; cv=none; b=NWsqPdAiDfBsJwy/MErZmM+7iK0Y28s2s1ns+i+HObJ9oWbNZEO6oUDFxtaXcojzO7vRVLuamYYrJto6gKtP199+RwnyvNHIZ9wDcGj6AQ65gbg+m1Jlig7A2VVmOcvifAwSg1z/ad2vbegOVYcxAjJfqAMV5kkiTwJciO4siP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739364292; c=relaxed/simple;
	bh=GI5kQZl0mzTzJ9RTkbhbPtF+3vQfHkm4vLmeq6uVigc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ACYSZ6/vdRIQqLNjmukwcFrRJuUTWx3wnx8Vbo7n/xC/hS/nP2TUvRCrI5+5/ZlThU4zWB3DUcR2ydGNYcNpDtwhrcfXsZHB6drHFUQPxbpj1hx2iGrT3cfDsrO7Q0qYYPdOLg2EPCSGpI0DUYtpR1BmL9gieEwW+MqwsTaXr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-220bff984a0so11946505ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 04:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739364290; x=1739969090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nUnTNnXpeOR0J9OGXHKIO0akNmvV5BR/W8bv2xbh2gw=;
        b=p5Bn29y1d1x+8S93GinMkTfNbIIavKfcydfQZ1l1v63eYW1YmVU0M3J9hwOPisnIyA
         cJYUiey17pxoEs16Qk5j2LRlBMWG44ks25HG8m6aIYDSVm+jP3GqGe+/Wl8F4uLR7iwX
         oGZDLBnENz+FO2uRoA3PVc2I7rOIVhTyMVKZ/RWEyHITDplGHIJgKk4mSfuTrh9b6GKx
         Km/cTgIMGdZwTU3qIsbKt8LenKx6lz/AvGrU0/WBmqpHEK6gXumIP56xw53ZFl9na9WD
         HGK/yWQmnfsK4BU190dKPycPuZxxbojuesntZxLGD54moQzkT6V3hp4ob0Q7ZqtUJYPz
         4k7g==
X-Gm-Message-State: AOJu0YwZt0265rlNt417MCBOir7hAer50Ozp8kXCn24FN8MTLOT5/tFB
	zYmVNAnNu/b09JXkjdqsjA3IUF8eD5TdMnPXD1Tg0qoR3l4W7viSTDU7Mg==
X-Gm-Gg: ASbGnctXNPyJ1UysDqev1UC5qQWO0xU1piqUQOrlFUbEpopQArWV0cxmCP/ms5hkNe1
	kPhxWGLtAJaDKG2rZ6JfgCLqgihKo/SWD4251jWZN83PHLX4V7zWYi/xGxBKXdNZcU01vN4tZQR
	YPlz2kDJoy3nxycKI4Lw66wkhAtoMlWwcOykStU7YUXGdtiQa37w4YBXBP5O+1z5y3x0B6FOrJ7
	/QoNil4LOI3+5fC9mF07oVIv8/wOjaXc8qX6nAUvdfinzx6DypYH1aJUF3Ly+IaYuT8kHWMySGM
	+iXz7ybaGmyjqV91Fhyv0Ri1X3pZNg==
X-Google-Smtp-Source: AGHT+IHGdODcAmG4WAfv1IN79Qs5TiNfEbvB66gXsfjKV8EN8zvvLeqoGqyyqGywbtp/GzcrmNabrQ==
X-Received: by 2002:a05:6a20:2450:b0:1e1:bdae:e04d with SMTP id adf61e73a8af0-1ee5c85db6bmr6525516637.36.1739364290004;
        Wed, 12 Feb 2025 04:44:50 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad51af7b744sm11248738a12.77.2025.02.12.04.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 04:44:49 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>
Subject: [PATCH 1/4] smb: common: change the data type of num_aces to le16
Date: Wed, 12 Feb 2025 21:43:37 +0900
Message-Id: <20250212124340.8034-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

2.4.5 in [MS-DTYP].pdf describe the data type of num_aces as le16.

AceCount (2 bytes): An unsigned 16-bit integer that specifies the count
of the number of ACE records in the ACL.

Change it to le16 and add reserved field to smb_acl struct.

Reported-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsacl.c | 26 +++++++++++++-------------
 fs/smb/common/smbacl.h  |  3 ++-
 fs/smb/server/smbacl.c  | 27 ++++++++++++++-------------
 fs/smb/server/smbacl.h  |  2 +-
 4 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 699a3f76d083..7d953208046a 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -763,7 +763,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 		       struct cifs_fattr *fattr, bool mode_from_special_sid)
 {
 	int i;
-	int num_aces = 0;
+	u16 num_aces = 0;
 	int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -785,7 +785,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 
 	cifs_dbg(NOISY, "DACL revision %d size %d num aces %d\n",
 		 le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
-		 le32_to_cpu(pdacl->num_aces));
+		 le16_to_cpu(pdacl->num_aces));
 
 	/* reset rwx permissions for user/group/other.
 	   Also, if num_aces is 0 i.e. DACL has no ACEs,
@@ -795,7 +795,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	acl_base = (char *)pdacl;
 	acl_size = sizeof(struct smb_acl);
 
-	num_aces = le32_to_cpu(pdacl->num_aces);
+	num_aces = le16_to_cpu(pdacl->num_aces);
 	if (num_aces > 0) {
 		umode_t denied_mode = 0;
 
@@ -937,12 +937,12 @@ unsigned int setup_special_user_owner_ACE(struct smb_ace *pntace)
 static void populate_new_aces(char *nacl_base,
 		struct smb_sid *pownersid,
 		struct smb_sid *pgrpsid,
-		__u64 *pnmode, u32 *pnum_aces, u16 *pnsize,
+		__u64 *pnmode, u16 *pnum_aces, u16 *pnsize,
 		bool modefromsid,
 		bool posix)
 {
 	__u64 nmode;
-	u32 num_aces = 0;
+	u16 num_aces = 0;
 	u16 nsize = 0;
 	__u64 user_mode;
 	__u64 group_mode;
@@ -1050,7 +1050,7 @@ static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *p
 	u16 size = 0;
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
-	u32 src_num_aces = 0;
+	u16 src_num_aces = 0;
 	u16 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
@@ -1058,7 +1058,7 @@ static __u16 replace_sids_and_copy_aces(struct smb_acl *pdacl, struct smb_acl *p
 
 	acl_base = (char *)pdacl;
 	size = sizeof(struct smb_acl);
-	src_num_aces = le32_to_cpu(pdacl->num_aces);
+	src_num_aces = le16_to_cpu(pdacl->num_aces);
 
 	nacl_base = (char *)pndacl;
 	nsize = sizeof(struct smb_acl);
@@ -1090,11 +1090,11 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 	u16 size = 0;
 	struct smb_ace *pntace = NULL;
 	char *acl_base = NULL;
-	u32 src_num_aces = 0;
+	u16 src_num_aces = 0;
 	u16 nsize = 0;
 	struct smb_ace *pnntace = NULL;
 	char *nacl_base = NULL;
-	u32 num_aces = 0;
+	u16 num_aces = 0;
 	bool new_aces_set = false;
 
 	/* Assuming that pndacl and pnmode are never NULL */
@@ -1112,7 +1112,7 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 
 	acl_base = (char *)pdacl;
 	size = sizeof(struct smb_acl);
-	src_num_aces = le32_to_cpu(pdacl->num_aces);
+	src_num_aces = le16_to_cpu(pdacl->num_aces);
 
 	/* Retain old ACEs which we can retain */
 	for (i = 0; i < src_num_aces; ++i) {
@@ -1158,7 +1158,7 @@ static int set_chmod_dacl(struct smb_acl *pdacl, struct smb_acl *pndacl,
 	}
 
 finalize_dacl:
-	pndacl->num_aces = cpu_to_le32(num_aces);
+	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(nsize);
 
 	return 0;
@@ -1293,7 +1293,7 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 			dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL_REVISION);
 
 		ndacl_ptr->size = cpu_to_le16(0);
-		ndacl_ptr->num_aces = cpu_to_le32(0);
+		ndacl_ptr->num_aces = cpu_to_le16(0);
 
 		rc = set_chmod_dacl(dacl_ptr, ndacl_ptr, owner_sid_ptr, group_sid_ptr,
 				    pnmode, mode_from_sid, posix);
@@ -1653,7 +1653,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 			dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
 			if (mode_from_sid)
 				nsecdesclen +=
-					le32_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
+					le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
 			else /* cifsacl */
 				nsecdesclen += le16_to_cpu(dacl_ptr->size);
 		}
diff --git a/fs/smb/common/smbacl.h b/fs/smb/common/smbacl.h
index 6a60698fc6f0..a624ec9e4a14 100644
--- a/fs/smb/common/smbacl.h
+++ b/fs/smb/common/smbacl.h
@@ -107,7 +107,8 @@ struct smb_sid {
 struct smb_acl {
 	__le16 revision; /* revision level */
 	__le16 size;
-	__le32 num_aces;
+	__le16 num_aces;
+	__le16 reserved;
 } __attribute__((packed));
 
 struct smb_ace {
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d39d3e553366..f820d0759c3c 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -333,7 +333,7 @@ void posix_state_to_acl(struct posix_acl_state *state,
 	pace->e_perm = state->other.allow;
 }
 
-int init_acl_state(struct posix_acl_state *state, int cnt)
+int init_acl_state(struct posix_acl_state *state, u16 cnt)
 {
 	int alloc;
 
@@ -368,7 +368,7 @@ static void parse_dacl(struct mnt_idmap *idmap,
 		       struct smb_fattr *fattr)
 {
 	int i, ret;
-	int num_aces = 0;
+	u16 num_aces = 0;
 	unsigned int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -389,12 +389,12 @@ static void parse_dacl(struct mnt_idmap *idmap,
 
 	ksmbd_debug(SMB, "DACL revision %d size %d num aces %d\n",
 		    le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
-		    le32_to_cpu(pdacl->num_aces));
+		    le16_to_cpu(pdacl->num_aces));
 
 	acl_base = (char *)pdacl;
 	acl_size = sizeof(struct smb_acl);
 
-	num_aces = le32_to_cpu(pdacl->num_aces);
+	num_aces = le16_to_cpu(pdacl->num_aces);
 	if (num_aces <= 0)
 		return;
 
@@ -580,7 +580,7 @@ static void parse_dacl(struct mnt_idmap *idmap,
 
 static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 				       struct smb_ace *pndace,
-				       struct smb_fattr *fattr, u32 *num_aces,
+				       struct smb_fattr *fattr, u16 *num_aces,
 				       u16 *size, u32 nt_aces_num)
 {
 	struct posix_acl_entry *pace;
@@ -701,7 +701,7 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 			   struct smb_fattr *fattr)
 {
 	struct smb_ace *ntace, *pndace;
-	int nt_num_aces = le32_to_cpu(nt_dacl->num_aces), num_aces = 0;
+	u16 nt_num_aces = le32_to_cpu(nt_dacl->num_aces), num_aces = 0;
 	unsigned short size = 0;
 	int i;
 
@@ -728,7 +728,7 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 
 	set_posix_acl_entries_dacl(idmap, pndace, fattr,
 				   &num_aces, &size, nt_num_aces);
-	pndacl->num_aces = cpu_to_le32(num_aces);
+	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
 
@@ -736,7 +736,7 @@ static void set_mode_dacl(struct mnt_idmap *idmap,
 			  struct smb_acl *pndacl, struct smb_fattr *fattr)
 {
 	struct smb_ace *pace, *pndace;
-	u32 num_aces = 0;
+	u16 num_aces = 0;
 	u16 size = 0, ace_size = 0;
 	uid_t uid;
 	const struct smb_sid *sid;
@@ -792,7 +792,7 @@ static void set_mode_dacl(struct mnt_idmap *idmap,
 				 fattr->cf_mode, 0007);
 
 out:
-	pndacl->num_aces = cpu_to_le32(num_aces);
+	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
 
@@ -1007,7 +1007,8 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	struct dentry *parent = path->dentry->d_parent;
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	int inherited_flags = 0, flags = 0, i, ace_cnt = 0, nt_size = 0, pdacl_size;
-	int rc = 0, num_aces, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
+	int rc = 0, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
+	u16 num_aces;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
@@ -1023,7 +1024,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 
 	parent_pdacl = (struct smb_acl *)((char *)parent_pntsd + dacloffset);
 	acl_len = pntsd_size - dacloffset;
-	num_aces = le32_to_cpu(parent_pdacl->num_aces);
+	num_aces = le16_to_cpu(parent_pdacl->num_aces);
 	pntsd_type = le16_to_cpu(parent_pntsd->type);
 	pdacl_size = le16_to_cpu(parent_pdacl->size);
 
@@ -1264,7 +1265,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = acl_size - sizeof(struct smb_acl);
-		for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
+		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 			if (offsetof(struct smb_ace, access_req) > aces_size)
 				break;
 			ace_size = le16_to_cpu(ace->size);
@@ -1285,7 +1286,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 	aces_size = acl_size - sizeof(struct smb_acl);
-	for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
+	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 		if (offsetof(struct smb_ace, access_req) > aces_size)
 			break;
 		ace_size = le16_to_cpu(ace->size);
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 24ce576fc292..355adaee39b8 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -86,7 +86,7 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 int build_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		   struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info,
 		   __u32 *secdesclen, struct smb_fattr *fattr);
-int init_acl_state(struct posix_acl_state *state, int cnt);
+int init_acl_state(struct posix_acl_state *state, u16 cnt);
 void free_acl_state(struct posix_acl_state *state);
 void posix_state_to_acl(struct posix_acl_state *state,
 			struct posix_acl_entry *pace);
-- 
2.25.1

