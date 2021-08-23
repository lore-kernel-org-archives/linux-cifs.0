Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FFFC4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41DB061037
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhHWPQA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231175AbhHWPQA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:16:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB3BE613A8;
        Mon, 23 Aug 2021 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731717;
        bh=LsqudMoJWp2HRTIg+rEk0wqkCmVr97TuorpzM7fhmMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEjGoJBnl531LnAXsyNgzDBfngDP2hF+zs7dNGjWNGZeCqHL6ZWOzNxF7uPlurVZQ
         RPP50652CoBAN1Xe239b9QzoP7Zy8e1ETZl8EP2A2bfVfU5OVz4BJaKQ3Tx9WK+Gp1
         Uf2ec0pz4QopdTB28l6M8GE8SHuVPEIWvVmqkEuLXtk00RmJJdN8LECP3qKZdOtRun
         lyj8jVC1fGRjiZu44/N6tT0RI6gQ0BoXvTEZx8p9YDWx88FPnyZzGr6EEko47CHRCb
         8Ux4qn8L/XGKrBo9786uHyhse5t2Z0z0bTGFcwSZrvyJcxCuA8WtrlzQbsZfq9gOVP
         3w6VaSqHhhmzQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 05/11] ksmbd: fix translation in acl entries
Date:   Mon, 23 Aug 2021 17:13:51 +0200
Message-Id: <20210823151357.471691-6-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4855; h=from:subject; bh=YcVp2d5Yhzv1OvOl0BsMZdHR4IYZW+LPB7vlQYGi+CI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zY8cKLnHlt0UfdHwXKBJxeju+J3FhjZfrq5rNNo2X2H 7VGJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO5H8nwP+16wpdW5d1222s537Ov2a /9+Vry9Qol90ixZzzCiiy/JBgZXrvFu6a2/K4rvHP7wcfUdTrX/5x74Gq0h3/7CjfNpz3OnAA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

The ksmbd server performs translation of posix acls to smb acls.
Currently the translation is wrong since the idmapping of the mount is
used to map the ids into raw userspace ids but what is relevant is the
user namespace of ksmbd itself. The user namespace of ksmbd itself which
is the initial user namespace. The operation is similar to asking "What
*ids would a userspace process see given that k*id in the relevant user
namespace?". Before the final translation we need to apply the idmapping
of the mount in case any is used. Add two simple helpers for ksmbd.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smbacl.c | 14 ++++++--------
 fs/ksmbd/smbacl.h | 25 +++++++++++++++++++++++++
 fs/ksmbd/vfs.c    |  4 ++--
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index a7025b31d2f2..3307ca776eb1 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -587,14 +587,14 @@ static void set_posix_acl_entries_dacl(struct user_namespace *user_ns,
 			uid_t uid;
 			unsigned int sid_type = SIDOWNER;
 
-			uid = from_kuid(user_ns, pace->e_uid);
+			uid = posix_acl_uid_translate(user_ns, pace);
 			if (!uid)
 				sid_type = SIDUNIX_USER;
 			id_to_sid(uid, sid_type, sid);
 		} else if (pace->e_tag == ACL_GROUP) {
 			gid_t gid;
 
-			gid = from_kgid(user_ns, pace->e_gid);
+			gid = posix_acl_gid_translate(user_ns, pace);
 			id_to_sid(gid, SIDUNIX_GROUP, sid);
 		} else if (pace->e_tag == ACL_OTHER && !nt_aces_num) {
 			smb_copy_sid(sid, &sid_everyone);
@@ -653,12 +653,12 @@ static void set_posix_acl_entries_dacl(struct user_namespace *user_ns,
 		if (pace->e_tag == ACL_USER) {
 			uid_t uid;
 
-			uid = from_kuid(user_ns, pace->e_uid);
+			uid = posix_acl_uid_translate(user_ns, pace);
 			id_to_sid(uid, SIDCREATOR_OWNER, sid);
 		} else if (pace->e_tag == ACL_GROUP) {
 			gid_t gid;
 
-			gid = from_kgid(user_ns, pace->e_gid);
+			gid = posix_acl_gid_translate(user_ns, pace);
 			id_to_sid(gid, SIDCREATOR_GROUP, sid);
 		} else {
 			kfree(sid);
@@ -1234,11 +1234,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 			pa_entry = posix_acls->a_entries;
 			for (i = 0; i < posix_acls->a_count; i++, pa_entry++) {
 				if (pa_entry->e_tag == ACL_USER)
-					id = from_kuid(user_ns,
-						       pa_entry->e_uid);
+					id = posix_acl_uid_translate(user_ns, pa_entry);
 				else if (pa_entry->e_tag == ACL_GROUP)
-					id = from_kgid(user_ns,
-						       pa_entry->e_gid);
+					id = posix_acl_gid_translate(user_ns, pa_entry);
 				else
 					continue;
 
diff --git a/fs/ksmbd/smbacl.h b/fs/ksmbd/smbacl.h
index 940f686a1d95..73e08cad412b 100644
--- a/fs/ksmbd/smbacl.h
+++ b/fs/ksmbd/smbacl.h
@@ -209,4 +209,29 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 bool type_check);
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_init_domain(u32 *sub_auth);
+
+static inline uid_t posix_acl_uid_translate(struct user_namespace *mnt_userns,
+					    struct posix_acl_entry *pace)
+{
+	kuid_t kuid;
+
+	/* If this is an idmapped mount, apply the idmapping. */
+	kuid = kuid_into_mnt(mnt_userns, pace->e_uid);
+
+	/* Translate the kuid into a userspace id ksmbd would see. */
+	return from_kuid(&init_user_ns, kuid);
+}
+
+static inline gid_t posix_acl_gid_translate(struct user_namespace *mnt_userns,
+					    struct posix_acl_entry *pace)
+{
+	kgid_t kgid;
+
+	/* If this is an idmapped mount, apply the idmapping. */
+	kgid = kgid_into_mnt(mnt_userns, pace->e_gid);
+
+	/* Translate the kgid into a userspace id ksmbd would see. */
+	return from_kgid(&init_user_ns, kgid);
+}
+
 #endif /* _SMBACL_H */
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 2bb506d1fb32..b047f2980d96 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1390,14 +1390,14 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(struct user_namespac
 		switch (pa_entry->e_tag) {
 		case ACL_USER:
 			xa_entry->type = SMB_ACL_USER;
-			xa_entry->uid = from_kuid(user_ns, pa_entry->e_uid);
+			xa_entry->uid = posix_acl_uid_translate(user_ns, pa_entry);
 			break;
 		case ACL_USER_OBJ:
 			xa_entry->type = SMB_ACL_USER_OBJ;
 			break;
 		case ACL_GROUP:
 			xa_entry->type = SMB_ACL_GROUP;
-			xa_entry->gid = from_kgid(user_ns, pa_entry->e_gid);
+			xa_entry->gid = posix_acl_gid_translate(user_ns, pa_entry);
 			break;
 		case ACL_GROUP_OBJ:
 			xa_entry->type = SMB_ACL_GROUP_OBJ;
-- 
2.30.2

