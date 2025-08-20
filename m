Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D192609EE
	for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755700402; cv=none; b=CtG2kdBXFS/ikjWjJ8SeYDZk5s8UWxcy8GXToLIbPu5q/+KNrT/fPENatajw0azxp62VPSRKk3s4Vbzwqcv5MZhEk1RdEUlEg8g/Gj+BCI2uiTNhQnRpwyLZWM5kpTc/ua1mQ4dIo29m53rW8U0ipcwvO8/7P7PFivhLYnZP3oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755700402; c=relaxed/simple;
	bh=p6TWOW7ohEtt2bDOMBlfDCdGASAZs4MaKtUa/go/6Rw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZS061v8L+PQCIbLIg8fholMd234UGBBG7gFrmXEwe9XXzgcg/xwUPE40cmNEtZkt90fMBPW25aE1+0me5HQjh0TajfZ2Sa429C/40bj41JhQqjSTWnBXiTEusB14eODAGC5/TXjefwcf9LNOvdXDLLJQC6P9kO1mP72bYwLErls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=iLh2L7/4; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="iLh2L7/4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1755699854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jwqvuq4EfRRmb1d7SCZOaEkY0ezLM8USYcnbGnMf5Jw=;
	b=iLh2L7/4Dp84FfyLTdpPTDiS25UPmZ9In7za85CevLMsYxJspC4/Kyrgq1vH5rCtQMXrC/
	bhh+/isye9/z+1fogXY3+qCcc6ra9/kTmnk6W19GMQYPcX4VmFRhdg6AcHyDFQpsV0+hDl
	dL+xiwugEdacENtJDIedKg4/Bs2xGpQ0e6HEu++WWzI7/IFXXrzRd7haS4mmSeZ8z514OH
	zfrhvAqw/pLrIvPoztj5FXfuoiUdk94B2TvwZX60VqIOaaSGaeNtp+TSGnxAAZYxl3ntDy
	yyANUVhg7dSiigOwPl29U7gVB34jLnt1bDKpy9ljv/S+OOcVw9q7zYIuJGhN2A==
From: Philipp Kerling <pkerling@casix.org>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	Philipp Kerling <pkerling@casix.org>
Subject: [PATCH] ksmbd: allow a filename to contain colons on SMB3.1.1 posix extensions
Date: Wed, 20 Aug 2025 16:24:13 +0200
Message-Id: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the client sends SMB2_CREATE_POSIX_CONTEXT to ksmbd, allow the filename to contain
a colon (':'). This requires disabling the support for Alternate Data Streams (ADS),
which are denoted by a colon-separated suffix to the filename on Windows. This should
not be an issue, since this concept is not known to POSIX anyway and the client has
to explicitly request a POSIX context to get this behavior.

Link: https://lore.kernel.org/all/f9401718e2be2ab22058b45a6817db912784ef61.camel@rx2.rx-server.de/
Signed-off-by: Philipp Kerling <pkerling@casix.org>
---
 fs/smb/server/smb2pdu.c   | 25 ++++++++++++++-----------
 fs/smb/server/vfs_cache.h |  2 ++
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0d92ce49aed7..a565fc36cee6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2951,18 +2951,19 @@ int smb2_open(struct ksmbd_work *work)
 		}
 
 		ksmbd_debug(SMB, "converted name = %s\n", name);
-		if (strchr(name, ':')) {
-			if (!test_share_config_flag(work->tcon->share_conf,
-						    KSMBD_SHARE_FLAG_STREAMS)) {
-				rc = -EBADF;
-				goto err_out2;
-			}
-			rc = parse_stream_name(name, &stream_name, &s_type);
-			if (rc < 0)
-				goto err_out2;
-		}
 
 		if (posix_ctxt == false) {
+			if (strchr(name, ':')) {
+				if (!test_share_config_flag(work->tcon->share_conf,
+							KSMBD_SHARE_FLAG_STREAMS)) {
+					rc = -EBADF;
+					goto err_out2;
+				}
+				rc = parse_stream_name(name, &stream_name, &s_type);
+				if (rc < 0)
+					goto err_out2;
+			}
+
 			rc = ksmbd_validate_filename(name);
 			if (rc < 0)
 				goto err_out2;
@@ -3443,6 +3444,8 @@ int smb2_open(struct ksmbd_work *work)
 	fp->attrib_only = !(req->DesiredAccess & ~(FILE_READ_ATTRIBUTES_LE |
 			FILE_WRITE_ATTRIBUTES_LE | FILE_SYNCHRONIZE_LE));
 
+	fp->is_posix_ctxt = posix_ctxt;
+
 	/* fp should be searchable through ksmbd_inode.m_fp_list
 	 * after daccess, saccess, attrib_only, and stream are
 	 * initialized.
@@ -5988,7 +5991,7 @@ static int smb2_rename(struct ksmbd_work *work,
 	if (IS_ERR(new_name))
 		return PTR_ERR(new_name);
 
-	if (strchr(new_name, ':')) {
+	if (fp->is_posix_ctxt == false && strchr(new_name, ':')) {
 		int s_type;
 		char *xattr_stream_name, *stream_name = NULL;
 		size_t xattr_stream_size;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 0708155b5caf..78b506c5ef03 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -112,6 +112,8 @@ struct ksmbd_file {
 	bool				is_durable;
 	bool				is_persistent;
 	bool				is_resilient;
+
+	bool                            is_posix_ctxt;
 };
 
 static inline void set_ctx_actor(struct dir_context *ctx,
-- 
2.50.1

