Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E0BC4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 071D8613CD
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhHWPP5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230354AbhHWPP4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:15:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F260613D3;
        Mon, 23 Aug 2021 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731714;
        bh=trcPHzm3HtFGxR+ovNfbT4O5BLP2Yewf0rB2dVasudw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNMvVLqb+B+eU9xN9UwQifU98WJRxJz9ddWTpS9myTLyit3ZDxnlHBHTCnNH7YgaZ
         0FldUYbIuM+sbvrpo4rzbCmXVtgv8YNvBJNz/90oH0FoJZkjrDSaeWtALfCU4Phd9M
         GxsJl3B5nosTywstkhf8n2bswjTLlY366DA6Yb6UBbR+oDgK+LD789Kt1L69dn+qJQ
         k7fvI5VgbCAnACCPe0WzyzlfNDS3UkTu33K3ZLD9QaBgdxD2kpwC5Wyd1x7YPKzALq
         HFuk7ZwJsvM8FG+khgMLvJhjC6iJeiExZmewPOhK4enVg1S6FtdMRew1I5m9eLHvXg
         QApjxF1wJXriw==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 04/11] smb2pdu: fix translation in ksmbd_acls_fattr()
Date:   Mon, 23 Aug 2021 17:13:50 +0200
Message-Id: <20210823151357.471691-5-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3756; h=from:subject; bh=WRpJpyan9fP7qD7fF2oD9PVzbv2++eYyy+221/rD6mA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zZslWP+u8fWIHLZwddB7uf+z32U96NgTfz/M8kfWlMv ntE/2lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR/12MDFevCmptv2XU0uKwIOIHQ1 2ikf+P1de69DTcbu+Lz8jsLGBkOMG0fMbXoxkX+sT4dPYdzX+bPNv+9I2pPFxbDlyyOKM1hwsA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

When creating new filesystem objects ksmbd translates between k*ids and
s*ids. For this it often uses struct smb_fattr and stashes the k*ids in
cf_uid and cf_gid. Let cf_uid and cf_gid always contain the final
information taking any potential idmapped mounts into account. When
finally translation cf_*id into s*ids translate them into the user
namespace of ksmbd since that is the relevant user namespace here.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smb2pdu.c | 12 +++++++-----
 fs/ksmbd/smbacl.c  |  8 ++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 559bfa2623f2..1b0a9242be88 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2381,10 +2381,12 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 			    le32_to_cpu(sd_buf->ccontext.DataLength), true);
 }
 
-static void ksmbd_acls_fattr(struct smb_fattr *fattr, struct inode *inode)
+static void ksmbd_acls_fattr(struct smb_fattr *fattr,
+			     struct user_namespace *mnt_userns,
+			     struct inode *inode)
 {
-	fattr->cf_uid = inode->i_uid;
-	fattr->cf_gid = inode->i_gid;
+	fattr->cf_uid = i_uid_into_mnt(mnt_userns, inode);
+	fattr->cf_gid = i_gid_into_mnt(mnt_userns, inode);
 	fattr->cf_mode = inode->i_mode;
 	fattr->cf_acls = NULL;
 	fattr->cf_dacls = NULL;
@@ -2893,7 +2895,7 @@ int smb2_open(struct ksmbd_work *work)
 					struct smb_ntsd *pntsd;
 					int pntsd_size, ace_num = 0;
 
-					ksmbd_acls_fattr(&fattr, inode);
+					ksmbd_acls_fattr(&fattr, user_ns, inode);
 					if (fattr.cf_acls)
 						ace_num = fattr.cf_acls->a_count;
 					if (fattr.cf_dacls)
@@ -5006,7 +5008,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	user_ns = file_mnt_user_ns(fp->filp);
 	inode = file_inode(fp->filp);
-	ksmbd_acls_fattr(&fattr, inode);
+	ksmbd_acls_fattr(&fattr, user_ns, inode);
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_ACL_XATTR))
diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 5456e3ad943e..a7025b31d2f2 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -723,7 +723,7 @@ static void set_mode_dacl(struct user_namespace *user_ns,
 	}
 
 	/* owner RID */
-	uid = from_kuid(user_ns, fattr->cf_uid);
+	uid = from_kuid(&init_user_ns, fattr->cf_uid);
 	if (uid)
 		sid = &server_conf.domain_sid;
 	else
@@ -739,7 +739,7 @@ static void set_mode_dacl(struct user_namespace *user_ns,
 	ace_size = fill_ace_for_sid(pace, &sid_unix_groups,
 				    ACCESS_ALLOWED, 0, fattr->cf_mode, 0070);
 	pace->sid.sub_auth[pace->sid.num_subauth++] =
-		cpu_to_le32(from_kgid(user_ns, fattr->cf_gid));
+		cpu_to_le32(from_kgid(&init_user_ns, fattr->cf_gid));
 	pace->size = cpu_to_le16(ace_size + 4);
 	size += le16_to_cpu(pace->size);
 	pace = (struct smb_ace *)((char *)pndace + size);
@@ -880,7 +880,7 @@ int build_sec_desc(struct user_namespace *user_ns,
 	if (!nowner_sid_ptr)
 		return -ENOMEM;
 
-	uid = from_kuid(user_ns, fattr->cf_uid);
+	uid = from_kuid(&init_user_ns, fattr->cf_uid);
 	if (!uid)
 		sid_type = SIDUNIX_USER;
 	id_to_sid(uid, sid_type, nowner_sid_ptr);
@@ -891,7 +891,7 @@ int build_sec_desc(struct user_namespace *user_ns,
 		return -ENOMEM;
 	}
 
-	gid = from_kgid(user_ns, fattr->cf_gid);
+	gid = from_kgid(&init_user_ns, fattr->cf_gid);
 	id_to_sid(gid, SIDUNIX_GROUP, ngroup_sid_ptr);
 
 	offset = sizeof(struct smb_ntsd);
-- 
2.30.2

