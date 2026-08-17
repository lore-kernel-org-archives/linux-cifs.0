Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FC63B4417
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968938; cv=none; b=VtGma5SYi6hiwqYvkgDlkvLDokk8fL5U5JaJiOdWQCIOg3ldcxqqzcHUbRiuLj0wsMjfmkQj3SJxZvaTL3w0oEYzrk9AyLjiwtKxXqfeSCZDaY1NPYkTRQVTIQcHcg/FbVOl7mxGV+e6DrgtDnR7shn/xmozH0qF7CH19lgKaPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968938; c=relaxed/simple;
	bh=2aRPaGWcWahIKgLv/h8DlFgwTmd4waBmPA+wSs9XSfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JmMmO4AYo+QQRfbIlY2M4HoM8aIQMV3X3Uw4LTqtpg2Jdk64uFLwcDHrBJd/PJIEBJMExxk+bAhqcbM5/U+fCX1FV3jL/tGRvv23vyidhRps3VTpbxqvRNAo/Cz3hTtml1wmc4vr3XvxUTXeATFCncKFboE1oebQR5x8dYYpWks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0Fbc6Yp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0Fbc6Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66891F000E9;
	Mon, 17 Aug 2026 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968936;
	bh=htjaQG0prJvICZFsudwaPfcG2dg8E9i7v8QWXbNws/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0Fbc6Ypt4nGLvBewOHTypyH1e7zYfGlxwR8tNbd/Agu8sHp3QR4vajecYih9mqxk
	 VrGHI7tHdiYVWL4E7Ngpoz5FUPPjOp9FdHt6Oa6WXlpmN+NqKMD8A7dbYEmIQHWMyu
	 k5oQJF7fmaKLxzkZjIp5c1Gh+CRJOFT5W6LXHlylu/s8rR0pr1JAhJ/RA/x0xXdleE
	 AZ1mAvjiZm/YWR6WH7nMHDY2vBGi1+CWf9SAV156wjNS9szuC7oKyNqT5k5qHK25+9
	 hogE5736p3FHr8h236xk8j1F9a9BmyBH6tD2TLYPfPX3vev7xwV7rGdfs7lgeuEe6f
	 62I6ibN4COnkQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: implement SMB2 AppInstanceVersion takeover
Date: Mon, 17 Aug 2026 21:15:14 +0900
Message-Id: <20260817121524.8812-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BVT_AppInstanceVersion_SMB311_GreaterVersion,
BVT_AppInstanceVersion_SMB311_SameVersion,
BVT_AppInstanceVersion_SMB311_LowerAppInstanceVersionHigh, and
BVT_AppInstanceVersion_SMB311_LowerAppInstanceVersionLow exercise
ordered opens using the same AppInstanceId. ksmbd tracked the
AppInstanceId, but did not parse the version context or enforce the
version ordering, so versioned opens returned incorrect sharing
violations.

Parse and retain the 24-byte AppInstanceVersion context with each open.
Reject a version that is lower than or equal to the active version with
STATUS_FILE_FORCED_CLOSED, reject an unversioned open against a versioned
handle, and close the previous handle for a newer takeover. Do not apply
the takeover check to durable reconnect or replay requests.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 98 +++++++++++++++++++++++++++++++++++++--
 fs/smb/server/vfs_cache.c |  7 ++-
 fs/smb/server/vfs_cache.h |  5 ++
 3 files changed, 101 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bd806dca9dcd..da461535229a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -16,6 +16,7 @@
 #include <linux/filelock.h>
 #include <linux/fileattr.h>
 #include <linux/timekeeping.h>
+#include <linux/unaligned.h>
 
 #include "glob.h"
 #include "../common/smbfsctl.h"
@@ -3451,9 +3452,12 @@ struct durable_info {
 	bool replay;
 	bool replay_consumed;
 	bool app_instance_id;
+	bool app_instance_version_valid;
 	unsigned int timeout;
 	char *CreateGuid;
 	char AppInstanceId[SMB2_CREATE_GUID_SIZE];
+	u64 app_instance_version_high;
+	u64 app_instance_version_low;
 };
 
 static int smb2_check_durable_replay(struct ksmbd_work *work,
@@ -3819,6 +3823,68 @@ static int parse_app_instance_id(struct smb2_create_req *req,
 	return 0;
 }
 
+static int parse_app_instance_version(struct smb2_create_req *req,
+				      struct durable_info *dh_info)
+{
+	struct create_context *context;
+	char *data;
+
+	context = smb2_find_context_vals(req, SMB2_CREATE_APP_INSTANCE_VERSION,
+					 SMB2_CREATE_GUID_SIZE);
+	if (IS_ERR(context))
+		return PTR_ERR(context);
+	if (!context)
+		return 0;
+
+	if (le32_to_cpu(context->DataLength) < 24)
+		return -EINVAL;
+
+	data = (char *)context + le16_to_cpu(context->DataOffset);
+	if (get_unaligned_le16(data) != 24 ||
+	    get_unaligned_le16(data + 2) != 0)
+		return -EINVAL;
+
+	dh_info->app_instance_version_high = get_unaligned_le64(data + 8);
+	dh_info->app_instance_version_low = get_unaligned_le64(data + 16);
+	dh_info->app_instance_version_valid = true;
+	return 0;
+}
+
+static int smb2_handle_app_instance_id(struct smb2_create_rsp *rsp,
+				       struct durable_info *dh_info)
+{
+	struct ksmbd_file *old_fp;
+	bool reject = false;
+
+	if (!dh_info->app_instance_id)
+		return 0;
+
+	old_fp = ksmbd_lookup_fd_app_instance_id(dh_info->AppInstanceId);
+	if (!old_fp)
+		return 0;
+
+	if (dh_info->app_instance_version_valid) {
+		if (old_fp->app_instance_version_valid &&
+		    (dh_info->app_instance_version_high <
+			 old_fp->app_instance_version_high ||
+		     (dh_info->app_instance_version_high ==
+			      old_fp->app_instance_version_high &&
+			      dh_info->app_instance_version_low <=
+			      old_fp->app_instance_version_low)))
+			reject = true;
+	} else if (old_fp->app_instance_version_valid) {
+		reject = true;
+	}
+
+	ksmbd_put_durable_fd(old_fp);
+	if (reject) {
+		rsp->hdr.Status = STATUS_FILE_FORCED_CLOSED;
+		return -EIO;
+	}
+
+	return ksmbd_close_fd_app_instance_id(dh_info->AppInstanceId);
+}
+
 /**
  * smb2_open() - handler for smb file open request
  * @work:	smb work containing request buffer
@@ -3946,6 +4012,15 @@ int smb2_open(struct ksmbd_work *work)
 
 	req_op_level = req->RequestedOplockLevel;
 
+	if (req->CreateContextsOffset) {
+		rc = parse_app_instance_id(req, &dh_info);
+		if (rc)
+			goto err_out2;
+		rc = parse_app_instance_version(req, &dh_info);
+		if (rc)
+			goto err_out2;
+	}
+
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE &&
 	    req->CreateContextsOffset) {
 		lc = parse_lease_state(req);
@@ -3960,9 +4035,6 @@ int smb2_open(struct ksmbd_work *work)
 			if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
 				req_op_level = SMB2_OPLOCK_LEVEL_NONE;
 		}
-		rc = parse_app_instance_id(req, &dh_info);
-		if (rc)
-			goto err_out2;
 		rc = parse_durable_handle_context(work, req, lc, &dh_info);
 		if (rc) {
 			ksmbd_debug(SMB, "error parsing durable handle context\n");
@@ -4010,8 +4082,6 @@ int smb2_open(struct ksmbd_work *work)
 			goto reconnected_fp;
 		}
 
-		if (dh_info.type == DURABLE_REQ_V2 && dh_info.app_instance_id)
-			ksmbd_close_fd_app_instance_id(dh_info.AppInstanceId);
 	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
 		lc = parse_lease_state(req);
 		if (IS_ERR(lc)) {
@@ -4026,6 +4096,13 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
+	if (dh_info.app_instance_id && !dh_info.reconnected &&
+	    !dh_info.replay) {
+		rc = smb2_handle_app_instance_id(rsp, &dh_info);
+		if (rc)
+			goto err_out2;
+	}
+
 	if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGATE)) {
 		pr_err("Invalid impersonationlevel : 0x%x\n",
 		       le32_to_cpu(req->ImpersonationLevel));
@@ -4426,6 +4503,17 @@ int smb2_open(struct ksmbd_work *work)
 	 * waiting on the same break again.
 	 */
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
+	if (dh_info.app_instance_id) {
+		memcpy(fp->app_instance_id, dh_info.AppInstanceId,
+		       SMB2_CREATE_GUID_SIZE);
+		fp->has_app_instance_id = true;
+	}
+	if (dh_info.app_instance_version_valid) {
+		fp->app_instance_version_high =
+			dh_info.app_instance_version_high;
+		fp->app_instance_version_low = dh_info.app_instance_version_low;
+		fp->app_instance_version_valid = true;
+	}
 	if (dh_info.CreateGuid) {
 		memcpy(fp->create_guid, dh_info.CreateGuid, SMB2_CREATE_GUID_SIZE);
 		fp->durable_replay_consumed = dh_info.replay_consumed;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 972e8985a503..413997f393f0 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -995,16 +995,15 @@ bool ksmbd_has_other_active_fd(struct ksmbd_file *fp)
 	return ret;
 }
 
-static struct ksmbd_file *ksmbd_lookup_fd_app_instance_id(char *app_instance_id)
+struct ksmbd_file *ksmbd_lookup_fd_app_instance_id(char *app_instance_id)
 {
 	struct ksmbd_file *fp = NULL;
 	unsigned int id;
 
-	if (!memchr_inv(app_instance_id, 0, SMB2_CREATE_GUID_SIZE))
-		return NULL;
-
 	read_lock(&global_ft.lock);
 	idr_for_each_entry(global_ft.idr, fp, id) {
+		if (!fp->has_app_instance_id)
+			continue;
 		if (!memcmp(fp->app_instance_id, app_instance_id,
 			    SMB2_CREATE_GUID_SIZE)) {
 			fp = ksmbd_fp_get(fp);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5cac022b540b..502efb16f05f 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -149,6 +149,10 @@ struct ksmbd_file {
 	bool				is_durable;
 	bool				is_persistent;
 	bool				is_resilient;
+	bool				has_app_instance_id;
+	bool				app_instance_version_valid;
+	u64				app_instance_version_high;
+	u64				app_instance_version_low;
 	bool				durable_reconnect_disabled;
 	bool				durable_replay_consumed;
 
@@ -209,6 +213,7 @@ void ksmbd_put_durable_fd(struct ksmbd_file *fp);
 int ksmbd_invalidate_durable_fd(unsigned long long id);
 bool ksmbd_has_other_active_fd(struct ksmbd_file *fp);
 bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
+struct ksmbd_file *ksmbd_lookup_fd_app_instance_id(char *app_instance_id);
 int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
-- 
2.25.1

