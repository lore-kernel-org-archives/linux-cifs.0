Received: from cvsmtppost31.nm.naver.com (cvsmtppost31.nm.naver.com [114.111.35.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EAC3B8934
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 06:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354664; cv=none; b=X7y/ZrRSdXH+ewktIQAWL+thy7nz2TpRUSlr9k9kHahb4M6gTv6ckwh3y0BJAYiBFP0r3iY+edhti7WZIlC73Vx6AjZtarEDd+t80HXyKVLmPhKFbCntuT7KL7vLbhCjZEH7Z4Qzv9IIy/eiCxZY+UUM8ABwgS0aBOWKG0KMlIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354664; c=relaxed/simple;
	bh=jcGH7JwbsQbMMQ51g9Styx2YOPP8elP2suwU0SJNleA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hfJuXpRenwyvV5NHQgMWDGSAYo0PGTYgBPRNLMCSE91WVpedUmYxAbaZ9MnPl2FAZFg3vFUN1Lu1Rvqzhd3mQXewLyGmmwpCHvy6EQr1tJ21Ys5bBcCtYPNvvS+3fw3znRB2d6txu/LaqxzCqfyJNBEXqntE4mEApC1l2hozz2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=nqEQjsEt; arc=none smtp.client-ip=114.111.35.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="nqEQjsEt"
Received: from cvsendbo019.nm ([10.112.22.34])
  by cvsmtppost31.nm.naver.com with ESMTP id vaXDFOAZQFmfdZ866YpNaA
  for <linux-cifs@vger.kernel.org>;
  Wed, 07 Oct 2026 06:30:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791354654; bh=jcGH7JwbsQbMMQ51g9Styx2YOPP8elP2suwU0SJNleA=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=nqEQjsEt4ANOnNEu8nCnuNob9TqBUFQxc3qjXxrYgEf4MUBFtWDNPYx6RF9da2jNH
	 22bRvcJMGVMjWz9X66Hb4gkhyDBOmhKccNW1zCHsVBVkdGAW3SaE6JuoSXyQK1EChV
	 ra86GM4or0YxSq49ql52eEA95bJ78OXXptRIBXYhTRh7kCeq7oZTIFGEod7LObf28b
	 zvjZ/4qk67GVIVyJKjjXxcaHuWMYjtTyLpHmCIq0huKlwZ7IjVP3UES8NinkboKJAX
	 oD9NvskTOXqTjA+Q2s5zKxYM84T2Z3N4vqB7n/y8JOeop0PdJ3v0KsJPixsuNnbDbc
	 oEC2y/30OVqoA==
X-Session-ID: lfCT8SRmRnCmKWZ6EdWxZw
X-Works-Send-Opt: OlRwpzGdjHmdKHFOMr39Ko3YKHmZjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: XZbZKqulFqJZ+HmdFxUZ+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp010.nm.naver.com with ESMTP id lfCT8SRmRnCmKWZ6EdWxZw
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Wed, 07 Oct 2026 06:30:54 -0000
From: Sung Byeongchan <tjdqudcks0424@naver.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: validate AppInstanceId takeover target
Date: Wed,  7 Oct 2026 15:30:50 +0900
Message-ID: <20261007063050.26322-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AppInstanceId lookup currently compares only the 16-byte identifier in
the global open table.  A CREATE on an unrelated share and pathname can
therefore close an existing open belonging to another session before
authorization for the new target has been established.

MS-SMB2 requires the old open to have the same target path and share, a
different ClientGuid, and requires the current user's maximal access to
include GENERIC_READ before the old open is closed.

Move AppInstanceId handling after path and permission resolution and
enforce those matching and access conditions.  Pass the referenced file
which was validated directly to the close helper instead of performing
another identifier-only lookup.

This was found by source review with AI assistance.  Two tests using
distinct authenticated users showed a CREATE on an unrelated share
force-close the victim's open.  The fixed kernel preserved the victim
open and retained the valid same-share, same-path takeover behavior.

Fixes: 16c30649709d ("ksmbd: handle durable v2 app instance id")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
 fs/smb/server/smb2pdu.c   | 46 +++++++++++++++++++++++++++++----------
 fs/smb/server/vfs_cache.c |  7 +-----
 fs/smb/server/vfs_cache.h |  2 +-
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 26e683aeb3dbd..166ad4eb455c4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4119,8 +4119,11 @@ static int parse_app_instance_version(struct smb2_create_req *req,
 	return 0;
 }
 
-static int smb2_handle_app_instance_id(struct smb2_create_rsp *rsp,
-				       struct durable_info *dh_info)
+static int smb2_handle_app_instance_id(struct ksmbd_conn *conn,
+				       struct ksmbd_share_config *share,
+				       struct smb2_create_rsp *rsp,
+				       struct durable_info *dh_info,
+				       char *name)
 {
 	struct ksmbd_file *old_fp;
 	bool reject = false;
@@ -4131,6 +4134,13 @@ static int smb2_handle_app_instance_id(struct smb2_create_rsp *rsp,
 	old_fp = ksmbd_lookup_fd_app_instance_id(dh_info->AppInstanceId);
 	if (!old_fp)
 		return 0;
+	if (!old_fp->tcon || old_fp->tcon->share_conf != share ||
+	    !memcmp(old_fp->client_guid, conn->ClientGUID,
+		    SMB2_CLIENT_GUID_SIZE) ||
+	    ksmbd_validate_name_reconnect(share, old_fp, name)) {
+		ksmbd_put_durable_fd(old_fp);
+		return 0;
+	}
 
 	if (dh_info->app_instance_version_valid) {
 		if (old_fp->app_instance_version_valid &&
@@ -4145,13 +4155,13 @@ static int smb2_handle_app_instance_id(struct smb2_create_rsp *rsp,
 		reject = true;
 	}
 
-	ksmbd_put_durable_fd(old_fp);
 	if (reject) {
+		ksmbd_put_durable_fd(old_fp);
 		rsp->hdr.Status = STATUS_FILE_FORCED_CLOSED;
 		return -EIO;
 	}
 
-	return ksmbd_close_fd_app_instance_id(dh_info->AppInstanceId);
+	return ksmbd_close_fd_app_instance_id(old_fp);
 }
 
 /**
@@ -4194,7 +4204,7 @@ int smb2_open(struct ksmbd_work *work)
 	int share_ret, need_truncate = 0;
 	u64 time, alloc_size = 0;
 	umode_t posix_mode = 0;
-	__le32 daccess, maximal_access = 0;
+	__le32 daccess, maximal_access = 0, app_instance_access;
 	u32 dos_attr;
 	int iov_len = 0;
 
@@ -4365,13 +4375,6 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
-	if (dh_info.app_instance_id && !dh_info.reconnected &&
-	    !dh_info.replay) {
-		rc = smb2_handle_app_instance_id(rsp, &dh_info);
-		if (rc)
-			goto err_out2;
-	}
-
 	if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGATE)) {
 		pr_err("Invalid impersonationlevel : 0x%x\n",
 		       le32_to_cpu(req->ImpersonationLevel));
@@ -4640,6 +4643,25 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
+	if (file_present && dh_info.app_instance_id && !dh_info.reconnected &&
+	    !dh_info.replay) {
+		app_instance_access = FILE_MAXIMAL_ACCESS_LE;
+		rc = smb_check_perm_dacl(conn, &path, &app_instance_access, 0,
+					 sess->user->uid, false);
+		if (rc)
+			goto err_out;
+		if (app_instance_access == FILE_MAXIMAL_ACCESS_LE)
+			ksmbd_vfs_query_maximal_access(idmap, path.dentry,
+						       &app_instance_access);
+		if ((le32_to_cpu(app_instance_access) & GENERIC_READ_FLAGS) ==
+		    GENERIC_READ_FLAGS) {
+			rc = smb2_handle_app_instance_id(conn, share, rsp,
+							 &dh_info, name);
+			if (rc)
+				goto err_out;
+		}
+	}
+
 	if (daccess & FILE_MAXIMAL_ACCESS_LE) {
 		if (!file_present) {
 			daccess = cpu_to_le32(GENERIC_ALL_FLAGS);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index ae30ee08e5e8d..c4ee000c33fb8 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -982,17 +982,12 @@ struct ksmbd_file *ksmbd_lookup_fd_app_instance_id(char *app_instance_id)
 	return fp;
 }
 
-int ksmbd_close_fd_app_instance_id(char *app_instance_id)
+int ksmbd_close_fd_app_instance_id(struct ksmbd_file *fp)
 {
 	struct ksmbd_file_table *ft;
-	struct ksmbd_file *fp;
 	struct oplock_info *opinfo;
 	int n_to_drop = 0;
 
-	fp = ksmbd_lookup_fd_app_instance_id(app_instance_id);
-	if (!fp)
-		return 0;
-
 	opinfo = opinfo_get(fp);
 	if (!opinfo)
 		goto out;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 732ae26dd6a7d..abc9c2309c6f0 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -208,7 +208,7 @@ int ksmbd_invalidate_durable_fd(unsigned long long id);
 bool ksmbd_has_other_active_fd(struct ksmbd_file *fp);
 bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_fd_app_instance_id(char *app_instance_id);
-int ksmbd_close_fd_app_instance_id(char *app_instance_id);
+int ksmbd_close_fd_app_instance_id(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
 bool ksmbd_has_other_nonposix_open(struct dentry *dentry);
-- 
2.43.0

