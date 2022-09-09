Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C91ECAAD3
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Sep 2022 10:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiIIKvk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Sep 2022 06:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiIIKvg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Sep 2022 06:51:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ED5D4BFA
        for <linux-cifs@vger.kernel.org>; Fri,  9 Sep 2022 03:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4561B61F97
        for <linux-cifs@vger.kernel.org>; Fri,  9 Sep 2022 10:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D02C4314B;
        Fri,  9 Sep 2022 10:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662720691;
        bh=tr54VAtkOub+ut6rxS/n3IKJNCLZc2z3a58rm9JqEok=;
        h=From:To:Cc:Subject:Date:From;
        b=sOx0yTeBwQ+G64pY5uxcZudfGhdiBNwYvbqdhbmCwfEOTeFCsastJ/zQUvMmoLZE8
         dFTS7SM2WIKiBkvNpx6UOu8lyTK4rz4iNdKhK1NGiIlXjTEGrNJP4BoehQn38d4Jas
         GjKk3RfxHCzIekAFKyOZcxp/rVxZNXxyKuX0SLnTDQoCq0btVmu/EpafdV1saRze0U
         E2lzPuXChH0C9XxV6Q6ErKv0kKQVFtF29/6NlCLdzDgGSbq00WAzvBZG/KqLDp1smZ
         IBH7BWnBRNpQOfcYCazNAkP5FtGCfRlQr5aKYZDgM6tfB9587fAkusEAZIUN9e12I3
         axa5dHYPh3T1g==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <sfrench@samba.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: port to vfs{g,u}id_t and associated helpers
Date:   Fri,  9 Sep 2022 12:51:19 +0200
Message-Id: <20220909105119.955332-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6099; i=brauner@kernel.org; h=from:subject; bh=tr54VAtkOub+ut6rxS/n3IKJNCLZc2z3a58rm9JqEok=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSRLSy1malpyQNSstbTnT5Wm9K3dNnPebmJkfjmNJ2jntO+d U3VFO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbywoeR4fT3aHtWRn/bW5WTVhVeXZ ykc/X02c//jE6ums349ZLL4dsM/6t27Ou3dLEIevs3859ESJyGc8s8g/MRCisN+bf1vX4vxQIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A while ago we introduced a dedicated vfs{g,u}id_t type in commit
1e5267cd0895 ("mnt_idmapping: add vfs{g,u}id_t"). We already switched
over a good part of the VFS. Ultimately we will remove all legacy
idmapped mount helpers that operate only on k{g,u}id_t in favor of the
new type safe helpers that operate on vfs{g,u}id_t.

Cc: Seth Forshee (Digital Ocean) <sforshee@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/ksmbd/ndr.c     |  8 ++++++--
 fs/ksmbd/oplock.c  |  8 ++++----
 fs/ksmbd/smb2pdu.c |  7 +++++--
 fs/ksmbd/smbacl.c  |  6 ++++--
 fs/ksmbd/smbacl.h  | 12 ++++++------
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/ksmbd/ndr.c b/fs/ksmbd/ndr.c
index 5052be9261d9..0ae8d08d85a8 100644
--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -345,6 +345,8 @@ int ndr_encode_posix_acl(struct ndr *n,
 {
 	unsigned int ref_id = 0x00020000;
 	int ret;
+	vfsuid_t vfsuid;
+	vfsgid_t vfsgid;
 
 	n->offset = 0;
 	n->length = 1024;
@@ -372,10 +374,12 @@ int ndr_encode_posix_acl(struct ndr *n,
 	if (ret)
 		return ret;
 
-	ret = ndr_write_int64(n, from_kuid(&init_user_ns, i_uid_into_mnt(user_ns, inode)));
+	vfsuid = i_uid_into_vfsuid(user_ns, inode);
+	ret = ndr_write_int64(n, from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid)));
 	if (ret)
 		return ret;
-	ret = ndr_write_int64(n, from_kgid(&init_user_ns, i_gid_into_mnt(user_ns, inode)));
+	vfsgid = i_gid_into_vfsgid(user_ns, inode);
+	ret = ndr_write_int64(n, from_kgid(&init_user_ns, vfsgid_into_kgid(vfsgid)));
 	if (ret)
 		return ret;
 	ret = ndr_write_int32(n, inode->i_mode);
diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 9046cff4374b..2e56dac1fa6e 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1609,6 +1609,8 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	struct create_posix_rsp *buf;
 	struct inode *inode = file_inode(fp->filp);
 	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(user_ns, inode);
+	vfsgid_t vfsgid = i_gid_into_vfsgid(user_ns, inode);
 
 	buf = (struct create_posix_rsp *)cc;
 	memset(buf, 0, sizeof(struct create_posix_rsp));
@@ -1639,11 +1641,9 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
 	buf->mode = cpu_to_le32(inode->i_mode);
-	id_to_sid(from_kuid_munged(&init_user_ns,
-				   i_uid_into_mnt(user_ns, inode)),
+	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
 		  SIDNFS_USER, (struct smb_sid *)&buf->SidBuffer[0]);
-	id_to_sid(from_kgid_munged(&init_user_ns,
-				   i_gid_into_mnt(user_ns, inode)),
+	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
 		  SIDNFS_GROUP, (struct smb_sid *)&buf->SidBuffer[20]);
 }
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 19412ac701a6..b6d63d45ac62 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2477,8 +2477,11 @@ static void ksmbd_acls_fattr(struct smb_fattr *fattr,
 			     struct user_namespace *mnt_userns,
 			     struct inode *inode)
 {
-	fattr->cf_uid = i_uid_into_mnt(mnt_userns, inode);
-	fattr->cf_gid = i_gid_into_mnt(mnt_userns, inode);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
+	vfsgid_t vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
+
+	fattr->cf_uid = vfsuid_into_kuid(vfsuid);
+	fattr->cf_gid = vfsgid_into_kgid(vfsgid);
 	fattr->cf_mode = inode->i_mode;
 	fattr->cf_acls = NULL;
 	fattr->cf_dacls = NULL;
diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 3781bca2c8fc..93983e5880a9 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -275,7 +275,8 @@ static int sid_to_id(struct user_namespace *user_ns,
 		uid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		uid = mapped_kuid_user(user_ns, &init_user_ns, KUIDT_INIT(id));
+		uid = KUIDT_INIT(id);
+		uid = from_vfsuid(user_ns, &init_user_ns, VFSUIDT_INIT(uid));
 		if (uid_valid(uid)) {
 			fattr->cf_uid = uid;
 			rc = 0;
@@ -285,7 +286,8 @@ static int sid_to_id(struct user_namespace *user_ns,
 		gid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		gid = mapped_kgid_user(user_ns, &init_user_ns, KGIDT_INIT(id));
+		gid = KGIDT_INIT(id);
+		gid = from_vfsgid(user_ns, &init_user_ns, VFSGIDT_INIT(gid));
 		if (gid_valid(gid)) {
 			fattr->cf_gid = gid;
 			rc = 0;
diff --git a/fs/ksmbd/smbacl.h b/fs/ksmbd/smbacl.h
index fcb2c83f2992..7e6e75e143ad 100644
--- a/fs/ksmbd/smbacl.h
+++ b/fs/ksmbd/smbacl.h
@@ -214,25 +214,25 @@ void ksmbd_init_domain(u32 *sub_auth);
 static inline uid_t posix_acl_uid_translate(struct user_namespace *mnt_userns,
 					    struct posix_acl_entry *pace)
 {
-	kuid_t kuid;
+	vfsuid_t vfsuid;
 
 	/* If this is an idmapped mount, apply the idmapping. */
-	kuid = mapped_kuid_fs(mnt_userns, &init_user_ns, pace->e_uid);
+	vfsuid = make_vfsuid(mnt_userns, &init_user_ns, pace->e_uid);
 
 	/* Translate the kuid into a userspace id ksmbd would see. */
-	return from_kuid(&init_user_ns, kuid);
+	return from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 }
 
 static inline gid_t posix_acl_gid_translate(struct user_namespace *mnt_userns,
 					    struct posix_acl_entry *pace)
 {
-	kgid_t kgid;
+	vfsgid_t vfsgid;
 
 	/* If this is an idmapped mount, apply the idmapping. */
-	kgid = mapped_kgid_fs(mnt_userns, &init_user_ns, pace->e_gid);
+	vfsgid = make_vfsgid(mnt_userns, &init_user_ns, pace->e_gid);
 
 	/* Translate the kgid into a userspace id ksmbd would see. */
-	return from_kgid(&init_user_ns, kgid);
+	return from_kgid(&init_user_ns, vfsgid_into_kgid(vfsgid));
 }
 
 #endif /* _SMBACL_H */

base-commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
-- 
2.34.1

