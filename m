Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D242772621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046159; cv=none; b=JbDsnW7dG8zPWQV0qMCFAhroEwJgIeIiL5xgyO5tvI1zsmeKkctGqLSjl/LG9UJj6Or5OOnB+/OkvwTjJc0U8Lo1QP6oTg+ssOZhfzpV8KnCKFCJosHLwo8t6H1xvr3av69I7AhUlu80fqbOECL8P0oJReoc8+aH8NLaIFUUm5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046159; c=relaxed/simple;
	bh=MMxSDnTrZQssNkqdGdAVXrgLVxrkUog+E9a4yuk3QtE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BD2GG0t5td3G42JmlbRPttoZJOYJg67PegTZGKpAntWpL10TKXVDhXDIEu3YRIw+6/lsvhTMvPc04U+HiacZ/aZU1TxV8HA3inpi8VRBWydMBxOlYQOBrN8wyfGk16QfoNLEMeYCz/gTCzFs1RBXjqaeSop6WR8CYQWLpcbsTh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghGLLSHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghGLLSHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51B51F000E9;
	Sun, 21 Jun 2026 12:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046158;
	bh=qMoOilRbPBCVggZVpEd97MP5fxbjEEBcxMmFCZW2/8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghGLLSHvqSMRKWtrvYcNMZh6w3uqgAMRT2IgECMZrrRUVwtZl+HABEY5IaUYH4Kr4
	 k/nN2ZcssJiYIcdN9ZaH6FbvawUaMr5BDxph9MkDob/P+03lQZA3LOvHsh8NTUKKdw
	 VGYjO5xoLVm8+oXKVTfaKKi68gd/PZX+DMqzSD2dXaJ3iCEzWf+sxTKEFAArl2j+hj
	 aAzJ9bJ/0ugke+yFlOkQdBY+sT8NVIr7ssi/v7RTb8+OdusLvxX8xXgUd5LZV4EMEm
	 c1GGkAejHg8Lf/SZaDR5rjn+ex8kR1egXJ0J6NJC3xiy1kxiCz94lc69qixJAJ7U4E
	 NOxyFBf794e5g==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 14/29] ksmbd: honor stream delete sharing for base file
Date: Sun, 21 Jun 2026 21:48:29 +0900
Message-Id: <20260621124844.6235-14-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2.streams.delete opens an alternate data stream without
FILE_SHARE_DELETE and then tries to delete the base file.  Windows rejects
the base-file delete with STATUS_SHARING_VIOLATION while the stream handle
is open. ksmbd tracks stream opens on the same ksmbd_inode as the base
file, but the delete-on-close path only checked delete access on the base
handle before marking the inode delete-pending.  As a result, deleting
the base file succeeded even though an open stream handle denied delete
sharing. Add a helper to detect open stream handles on the same inode that
do not allow FILE_SHARE_DELETE, and reject base-file delete pending and
DELETE opens with a sharing violation in that case.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   |  9 +++++++++
 fs/smb/server/vfs_cache.c | 27 +++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 37 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cc9cd9297557..a3ae37e8b24d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3737,6 +3737,12 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	if (!stream_name && daccess & FILE_DELETE_LE &&
+	    ksmbd_has_stream_without_delete_share(fp)) {
+		rc = -EPERM;
+		goto err_out;
+	}
+
 	if (file_present || created)
 		path_put(&path);
 
@@ -6758,6 +6764,9 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 
 	inode = file_inode(fp->filp);
 	if (file_info->DeletePending) {
+		if (ksmbd_has_stream_without_delete_share(fp))
+			return -ESHARE;
+
 		if (S_ISDIR(inode->i_mode) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index b617edef950a..11b51320b96e 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -254,6 +254,33 @@ void ksmbd_clear_inode_pending_delete(struct ksmbd_file *fp)
 	up_write(&ci->m_lock);
 }
 
+bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp)
+{
+	struct ksmbd_file *prev_fp;
+	struct ksmbd_inode *ci = fp->f_ci;
+	bool ret = false;
+
+	if (ksmbd_stream_fd(fp))
+		return false;
+
+	down_read(&ci->m_lock);
+	list_for_each_entry(prev_fp, &ci->m_fp_list, node) {
+		if (prev_fp == fp || !ksmbd_stream_fd(prev_fp))
+			continue;
+
+		if (file_inode(fp->filp) != file_inode(prev_fp->filp))
+			continue;
+
+		if (!(prev_fp->saccess & FILE_SHARE_DELETE_LE)) {
+			ret = true;
+			break;
+		}
+	}
+	up_read(&ci->m_lock);
+
+	return ret;
+}
+
 void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 				  int file_info)
 {
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 52a0e8b1f79f..8aa87843025f 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -169,6 +169,7 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 void ksmbd_put_durable_fd(struct ksmbd_file *fp);
 int ksmbd_invalidate_durable_fd(unsigned long long id);
 bool ksmbd_has_other_active_fd(struct ksmbd_file *fp);
+bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
 int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
-- 
2.25.1

