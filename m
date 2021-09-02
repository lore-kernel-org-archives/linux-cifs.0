Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B32EC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 22:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46B2161054
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 22:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbhIBWSZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:18:25 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:41804 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbhIBWSX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Sep 2021 18:18:23 -0400
Received: by mail-pg1-f178.google.com with SMTP id k24so3500737pgh.8
        for <linux-cifs@vger.kernel.org>; Thu, 02 Sep 2021 15:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wCqEj2nnHQT5+ADuGnUZQcy//wo+tJxTophT3J3eoHE=;
        b=mBGALrScUCUb9U3v69vfR0MmnBYDhLIll+RY7Ws9nJzMAom3G7l/jscBg/jgJevnEk
         bz1MaBQw1ALcGL/N96bVPNNVadv+0TLHT5jDdSTzlv3aYmu4niovmzgzfRYt+uTiGxjU
         gaGfB3+zEDAEe/UNAkSdat5P9wWA8cIS9c3d0JoiFa4PxFeJIxGIp8GurnCSz6IVIZBK
         ZFBnbpxICh6MK01XcBYrzGzvNxjWWoLGa3TbY53wkP8wz82N1U2t5n8eAx6HRGltfusW
         PCg++dTjQQLaJR11YcSyUjY8gAxCXPNdyQwh3AAg6GSxP/UcI3UgLmeFN6JauB4VQvwv
         rLhA==
X-Gm-Message-State: AOAM5339gVb+d97y4hY/bGJwrGX4drx8Z3LGi0QE5eutYHaa9Lz+7HeP
        /rWpVdRt46oxpZvy0ZPRNyGA30jwrh555Q==
X-Google-Smtp-Source: ABdhPJwMCAajtlOrg+A+RG42/sMkopz4QmNaj69ilT8C2Yxtdg48E/MF6TpYLFFQ2NizxTHuVaA+iQ==
X-Received: by 2002:a63:4f0d:: with SMTP id d13mr532971pgb.169.1630621044549;
        Thu, 02 Sep 2021 15:17:24 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id o1sm3207699pjk.1.2021.09.02.15.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 15:17:24 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2] ksmbd: add validation for ndr read/write functions
Date:   Fri,  3 Sep 2021 07:17:05 +0900
Message-Id: <20210902221705.5296-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If ndr->length is smaller than expected size, ksmbd can access invalid
access in ndr->data. This patch add validation to check ndr->offset is
over ndr->length. and added exception handling to check return value of
ndr read/write function.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
v2:
 - change data type of "ret" to int in ndr_decode_dos_attr().

 fs/ksmbd/ndr.c | 383 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 274 insertions(+), 109 deletions(-)

diff --git a/fs/ksmbd/ndr.c b/fs/ksmbd/ndr.c
index e6a574fa7709..a476de291f62 100644
--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -28,37 +28,60 @@ static int try_to_realloc_ndr_blob(struct ndr *n, size_t sz)
 	return 0;
 }
 
-static void ndr_write_int16(struct ndr *n, __u16 value)
+static int ndr_write_int16(struct ndr *n, __u16 value)
 {
-	if (n->length <= n->offset + sizeof(value))
-		try_to_realloc_ndr_blob(n, sizeof(value));
+	if (n->length <= n->offset + sizeof(value)) {
+		int ret;
+
+		ret = try_to_realloc_ndr_blob(n, sizeof(value));
+		if (ret)
+			return ret;
+	}
 
 	*(__le16 *)ndr_get_field(n) = cpu_to_le16(value);
 	n->offset += sizeof(value);
+	return 0;
 }
 
-static void ndr_write_int32(struct ndr *n, __u32 value)
+static int ndr_write_int32(struct ndr *n, __u32 value)
 {
-	if (n->length <= n->offset + sizeof(value))
-		try_to_realloc_ndr_blob(n, sizeof(value));
+	if (n->length <= n->offset + sizeof(value)) {
+		int ret;
+
+		ret = try_to_realloc_ndr_blob(n, sizeof(value));
+		if (ret)
+			return ret;
+	}
 
 	*(__le32 *)ndr_get_field(n) = cpu_to_le32(value);
 	n->offset += sizeof(value);
+	return 0;
 }
 
-static void ndr_write_int64(struct ndr *n, __u64 value)
+static int ndr_write_int64(struct ndr *n, __u64 value)
 {
-	if (n->length <= n->offset + sizeof(value))
-		try_to_realloc_ndr_blob(n, sizeof(value));
+	if (n->length <= n->offset + sizeof(value)) {
+		int ret;
+
+		ret = try_to_realloc_ndr_blob(n, sizeof(value));
+		if (ret)
+			return ret;
+	}
 
 	*(__le64 *)ndr_get_field(n) = cpu_to_le64(value);
 	n->offset += sizeof(value);
+	return 0;
 }
 
 static int ndr_write_bytes(struct ndr *n, void *value, size_t sz)
 {
-	if (n->length <= n->offset + sz)
-		try_to_realloc_ndr_blob(n, sz);
+	if (n->length <= n->offset + sz) {
+		int ret;
+
+		ret = try_to_realloc_ndr_blob(n, sz);
+		if (ret)
+			return ret;
+	}
 
 	memcpy(ndr_get_field(n), value, sz);
 	n->offset += sz;
@@ -70,8 +93,13 @@ static int ndr_write_string(struct ndr *n, char *value)
 	size_t sz;
 
 	sz = strlen(value) + 1;
-	if (n->length <= n->offset + sz)
-		try_to_realloc_ndr_blob(n, sz);
+	if (n->length <= n->offset + sz) {
+		int ret;
+
+		ret = try_to_realloc_ndr_blob(n, sz);
+		if (ret)
+			return ret;
+	}
 
 	memcpy(ndr_get_field(n), value, sz);
 	n->offset += sz;
@@ -81,9 +109,14 @@ static int ndr_write_string(struct ndr *n, char *value)
 
 static int ndr_read_string(struct ndr *n, void *value, size_t sz)
 {
-	int len = strnlen(ndr_get_field(n), sz);
+	int len;
 
-	memcpy(value, ndr_get_field(n), len);
+	if (n->offset + sz > n->length)
+		return -EINVAL;
+
+	len = strnlen(ndr_get_field(n), sz);
+	if (value)
+		memcpy(value, ndr_get_field(n), len);
 	len++;
 	n->offset += len;
 	n->offset = ALIGN(n->offset, 2);
@@ -92,41 +125,52 @@ static int ndr_read_string(struct ndr *n, void *value, size_t sz)
 
 static int ndr_read_bytes(struct ndr *n, void *value, size_t sz)
 {
-	memcpy(value, ndr_get_field(n), sz);
+	if (n->offset + sz > n->length)
+		return -EINVAL;
+
+	if (value)
+		memcpy(value, ndr_get_field(n), sz);
 	n->offset += sz;
 	return 0;
 }
 
-static __u16 ndr_read_int16(struct ndr *n)
+static int ndr_read_int16(struct ndr *n, __u16 *value)
 {
-	__u16 ret;
+	if (n->offset + sizeof(__u16) > n->length)
+		return -EINVAL;
 
-	ret = le16_to_cpu(*(__le16 *)ndr_get_field(n));
+	if (value)
+		*value = le16_to_cpu(*(__le16 *)ndr_get_field(n));
 	n->offset += sizeof(__u16);
-	return ret;
+	return 0;
 }
 
-static __u32 ndr_read_int32(struct ndr *n)
+static int ndr_read_int32(struct ndr *n, __u32 *value)
 {
-	__u32 ret;
+	if (n->offset + sizeof(__u32) > n->length)
+		return 0;
 
-	ret = le32_to_cpu(*(__le32 *)ndr_get_field(n));
+	if (value)
+		*value = le32_to_cpu(*(__le32 *)ndr_get_field(n));
 	n->offset += sizeof(__u32);
-	return ret;
+	return 0;
 }
 
-static __u64 ndr_read_int64(struct ndr *n)
+static int ndr_read_int64(struct ndr *n, __u64 *value)
 {
-	__u64 ret;
+	if (n->offset + sizeof(__u64) > n->length)
+		return -EINVAL;
 
-	ret = le64_to_cpu(*(__le64 *)ndr_get_field(n));
+	if (value)
+		*value = le64_to_cpu(*(__le64 *)ndr_get_field(n));
 	n->offset += sizeof(__u64);
-	return ret;
+	return 0;
 }
 
 int ndr_encode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 {
 	char hex_attr[12] = {0};
+	int ret;
 
 	n->offset = 0;
 	n->length = 1024;
@@ -136,97 +180,161 @@ int ndr_encode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 
 	if (da->version == 3) {
 		snprintf(hex_attr, 10, "0x%x", da->attr);
-		ndr_write_string(n, hex_attr);
+		ret = ndr_write_string(n, hex_attr);
 	} else {
-		ndr_write_string(n, "");
+		ret = ndr_write_string(n, "");
 	}
-	ndr_write_int16(n, da->version);
-	ndr_write_int32(n, da->version);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int16(n, da->version);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int32(n, da->version);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int32(n, da->flags);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int32(n, da->attr);
+	if (ret)
+		return ret;
 
-	ndr_write_int32(n, da->flags);
-	ndr_write_int32(n, da->attr);
 	if (da->version == 3) {
-		ndr_write_int32(n, da->ea_size);
-		ndr_write_int64(n, da->size);
-		ndr_write_int64(n, da->alloc_size);
+		ret = ndr_write_int32(n, da->ea_size);
+		if (ret)
+			return ret;
+		ret = ndr_write_int64(n, da->size);
+		if (ret)
+			return ret;
+		ret = ndr_write_int64(n, da->alloc_size);
 	} else {
-		ndr_write_int64(n, da->itime);
+		ret = ndr_write_int64(n, da->itime);
 	}
-	ndr_write_int64(n, da->create_time);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int64(n, da->create_time);
+	if (ret)
+		return ret;
+
 	if (da->version == 3)
-		ndr_write_int64(n, da->change_time);
-	return 0;
+		ret = ndr_write_int64(n, da->change_time);
+	return ret;
 }
 
 int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 {
-	char *hex_attr;
-	int version2;
-
-	hex_attr = kzalloc(n->length, GFP_KERNEL);
-	if (!hex_attr)
-		return -ENOMEM;
+	char hex_attr[12];
+	unsigned int version2;
+	int ret;
 
 	n->offset = 0;
-	ndr_read_string(n, hex_attr, n->length);
-	kfree(hex_attr);
-	da->version = ndr_read_int16(n);
+	ret = ndr_read_string(n, hex_attr, sizeof(hex_attr));
+	if (ret)
+		return ret;
+
+	ret = ndr_read_int16(n, &da->version);
+	if (ret)
+		return ret;
 
 	if (da->version != 3 && da->version != 4) {
 		pr_err("v%d version is not supported\n", da->version);
 		return -EINVAL;
 	}
 
-	version2 = ndr_read_int32(n);
+	ret = ndr_read_int32(n, &version2);
+	if (ret)
+		return ret;
+
 	if (da->version != version2) {
 		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
 		       da->version, version2);
 		return -EINVAL;
 	}
 
-	ndr_read_int32(n);
-	da->attr = ndr_read_int32(n);
+	ret = ndr_read_int32(n, NULL);
+	if (ret)
+		return ret;
+
+	ret = ndr_read_int32(n, &da->attr);
+	if (ret)
+		return ret;
+
 	if (da->version == 4) {
-		da->itime = ndr_read_int64(n);
-		da->create_time = ndr_read_int64(n);
+		ret = ndr_read_int64(n, &da->itime);
+		if (ret)
+			return ret;
+
+		ret = ndr_read_int64(n, &da->create_time);
 	} else {
-		ndr_read_int32(n);
-		ndr_read_int64(n);
-		ndr_read_int64(n);
-		da->create_time = ndr_read_int64(n);
-		ndr_read_int64(n);
+		ret = ndr_read_int32(n, NULL);
+		if (ret)
+			return ret;
+
+		ndr_read_int64(n, NULL);
+		if (ret)
+			return ret;
+
+		ndr_read_int64(n, NULL);
+		if (ret)
+			return ret;
+
+		ret = ndr_read_int64(n, &da->create_time);
+		if (ret)
+			return ret;
+
+		ret = ndr_read_int64(n, NULL);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int ndr_encode_posix_acl_entry(struct ndr *n, struct xattr_smb_acl *acl)
 {
-	int i;
+	int i, ret;
+
+	ret = ndr_write_int32(n, acl->count);
+	if (ret)
+		return ret;
 
-	ndr_write_int32(n, acl->count);
 	n->offset = ALIGN(n->offset, 8);
-	ndr_write_int32(n, acl->count);
-	ndr_write_int32(n, 0);
+	ret = ndr_write_int32(n, acl->count);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int32(n, 0);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < acl->count; i++) {
 		n->offset = ALIGN(n->offset, 8);
-		ndr_write_int16(n, acl->entries[i].type);
-		ndr_write_int16(n, acl->entries[i].type);
+		ret = ndr_write_int16(n, acl->entries[i].type);
+		if (ret)
+			return ret;
+
+		ret = ndr_write_int16(n, acl->entries[i].type);
+		if (ret)
+			return ret;
 
 		if (acl->entries[i].type == SMB_ACL_USER) {
 			n->offset = ALIGN(n->offset, 8);
-			ndr_write_int64(n, acl->entries[i].uid);
+			ret = ndr_write_int64(n, acl->entries[i].uid);
 		} else if (acl->entries[i].type == SMB_ACL_GROUP) {
 			n->offset = ALIGN(n->offset, 8);
-			ndr_write_int64(n, acl->entries[i].gid);
+			ret = ndr_write_int64(n, acl->entries[i].gid);
 		}
+		if (ret)
+			return ret;
 
 		/* push permission */
-		ndr_write_int32(n, acl->entries[i].perm);
+		ret = ndr_write_int32(n, acl->entries[i].perm);
 	}
 
-	return 0;
+	return ret;
 }
 
 int ndr_encode_posix_acl(struct ndr *n,
@@ -235,7 +343,8 @@ int ndr_encode_posix_acl(struct ndr *n,
 			 struct xattr_smb_acl *acl,
 			 struct xattr_smb_acl *def_acl)
 {
-	int ref_id = 0x00020000;
+	unsigned int ref_id = 0x00020000;
+	int ret;
 
 	n->offset = 0;
 	n->length = 1024;
@@ -245,35 +354,46 @@ int ndr_encode_posix_acl(struct ndr *n,
 
 	if (acl) {
 		/* ACL ACCESS */
-		ndr_write_int32(n, ref_id);
+		ret = ndr_write_int32(n, ref_id);
 		ref_id += 4;
 	} else {
-		ndr_write_int32(n, 0);
+		ret = ndr_write_int32(n, 0);
 	}
+	if (ret)
+		return ret;
 
 	if (def_acl) {
 		/* DEFAULT ACL ACCESS */
-		ndr_write_int32(n, ref_id);
+		ret = ndr_write_int32(n, ref_id);
 		ref_id += 4;
 	} else {
-		ndr_write_int32(n, 0);
+		ret = ndr_write_int32(n, 0);
 	}
-
-	ndr_write_int64(n, from_kuid(&init_user_ns, i_uid_into_mnt(user_ns, inode)));
-	ndr_write_int64(n, from_kgid(&init_user_ns, i_gid_into_mnt(user_ns, inode)));
-	ndr_write_int32(n, inode->i_mode);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int64(n, from_kuid(&init_user_ns, i_uid_into_mnt(user_ns, inode)));
+	if (ret)
+		return ret;
+	ret = ndr_write_int64(n, from_kgid(&init_user_ns, i_gid_into_mnt(user_ns, inode)));
+	if (ret)
+		return ret;
+	ret = ndr_write_int32(n, inode->i_mode);
+	if (ret)
+		return ret;
 
 	if (acl) {
-		ndr_encode_posix_acl_entry(n, acl);
-		if (def_acl)
-			ndr_encode_posix_acl_entry(n, def_acl);
+		ret = ndr_encode_posix_acl_entry(n, acl);
+		if (def_acl && !ret)
+			ret = ndr_encode_posix_acl_entry(n, def_acl);
 	}
-	return 0;
+	return ret;
 }
 
 int ndr_encode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 {
-	int ref_id = 0x00020004;
+	unsigned int ref_id = 0x00020004;
+	int ret;
 
 	n->offset = 0;
 	n->length = 2048;
@@ -281,36 +401,65 @@ int ndr_encode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 	if (!n->data)
 		return -ENOMEM;
 
-	ndr_write_int16(n, acl->version);
-	ndr_write_int32(n, acl->version);
-	ndr_write_int16(n, 2);
-	ndr_write_int32(n, ref_id);
+	ret = ndr_write_int16(n, acl->version);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int32(n, acl->version);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int16(n, 2);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int32(n, ref_id);
+	if (ret)
+		return ret;
 
 	/* push hash type and hash 64bytes */
-	ndr_write_int16(n, acl->hash_type);
-	ndr_write_bytes(n, acl->hash, XATTR_SD_HASH_SIZE);
-	ndr_write_bytes(n, acl->desc, acl->desc_len);
-	ndr_write_int64(n, acl->current_time);
-	ndr_write_bytes(n, acl->posix_acl_hash, XATTR_SD_HASH_SIZE);
+	ret = ndr_write_int16(n, acl->hash_type);
+	if (ret)
+		return ret;
 
-	/* push ndr for security descriptor */
-	ndr_write_bytes(n, acl->sd_buf, acl->sd_size);
+	ret = ndr_write_bytes(n, acl->hash, XATTR_SD_HASH_SIZE);
+	if (ret)
+		return ret;
 
-	return 0;
+	ret = ndr_write_bytes(n, acl->desc, acl->desc_len);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_int64(n, acl->current_time);
+	if (ret)
+		return ret;
+
+	ret = ndr_write_bytes(n, acl->posix_acl_hash, XATTR_SD_HASH_SIZE);
+	if (ret)
+		return ret;
+
+	/* push ndr for security descriptor */
+	ret = ndr_write_bytes(n, acl->sd_buf, acl->sd_size);
+	return ret;
 }
 
 int ndr_decode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 {
-	int version2;
+	unsigned int version2;
+	int ret;
 
 	n->offset = 0;
-	acl->version = ndr_read_int16(n);
+	ret = ndr_read_int16(n, &acl->version);
+	if (ret)
+		return ret;
 	if (acl->version != 4) {
 		pr_err("v%d version is not supported\n", acl->version);
 		return -EINVAL;
 	}
 
-	version2 = ndr_read_int32(n);
+	ret = ndr_read_int32(n, &version2);
+	if (ret)
+		return ret;
 	if (acl->version != version2) {
 		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
 		       acl->version, version2);
@@ -318,11 +467,22 @@ int ndr_decode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 	}
 
 	/* Read Level */
-	ndr_read_int16(n);
+	ret = ndr_read_int16(n, NULL);
+	if (ret)
+		return ret;
+
 	/* Read Ref Id */
-	ndr_read_int32(n);
-	acl->hash_type = ndr_read_int16(n);
-	ndr_read_bytes(n, acl->hash, XATTR_SD_HASH_SIZE);
+	ret = ndr_read_int32(n, NULL);
+	if (ret)
+		return ret;
+
+	ret = ndr_read_int16(n, &acl->hash_type);
+	if (ret)
+		return ret;
+
+	ret = ndr_read_bytes(n, acl->hash, XATTR_SD_HASH_SIZE);
+	if (ret)
+		return ret;
 
 	ndr_read_bytes(n, acl->desc, 10);
 	if (strncmp(acl->desc, "posix_acl", 9)) {
@@ -331,15 +491,20 @@ int ndr_decode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 	}
 
 	/* Read Time */
-	ndr_read_int64(n);
+	ret = ndr_read_int64(n, NULL);
+	if (ret)
+		return ret;
+
 	/* Read Posix ACL hash */
-	ndr_read_bytes(n, acl->posix_acl_hash, XATTR_SD_HASH_SIZE);
+	ret = ndr_read_bytes(n, acl->posix_acl_hash, XATTR_SD_HASH_SIZE);
+	if (ret)
+		return ret;
+
 	acl->sd_size = n->length - n->offset;
 	acl->sd_buf = kzalloc(acl->sd_size, GFP_KERNEL);
 	if (!acl->sd_buf)
 		return -ENOMEM;
 
-	ndr_read_bytes(n, acl->sd_buf, acl->sd_size);
-
-	return 0;
+	ret = ndr_read_bytes(n, acl->sd_buf, acl->sd_size);
+	return ret;
 }
-- 
2.25.1

