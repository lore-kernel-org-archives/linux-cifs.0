Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793937235;
	b=24wnSb81XYy05TQ7s1attN/kreuOGLBddAUXhAyrRd3lrgaXdhD3mFRxNo/d+gH4i1zb
	 TcuWSl71jc0kSuBv6wVw/0PKJ0s6cQUrfNHO/zbRQYAktMkUqrPJXmpRExN2v5fnolMqJ
	 PZBrQGeZOzeg6Dap7P70If0FfrXVGs3WWCRtOCQI2Zy3vFZg1HDh/rNtCDoFxPi+7799g
	 uAX+lgz52kaztYr5FqAYuUWO9F9NoSoOyLYc9s7xMOaQ9Ah8VB6DoG7IzvKn6G50dClgU
	 Ssq9T4Rl0g9hVp8+n4OifTcpWGo0kfzrUpbwkYrJQrH0tnO1qnIXmONpYCphH4QuOeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793937235;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=/uJY+lXVAYz2u+NeiYxSeggW68B7e2gaqanprkeHSEc=;
	b=2zWhypLAk5RqIgO7nKBn3Cb8XJVGn9S4Y7+d2cJO7fb8ZC3kn8BhPo0US6aoUAtCtO1Z
	 m7sR4yhPNzlhfcOqVhWhjltFZUI2gznoFn/JIvSJmmawJfAzbW3VXKVwIDG9L1/LpvpzV
	 5pkEQnmA0/bJkwv+/DMiIjK/Dk+nFSC+ywdkoMSvn7kZn84YT0Zty7riEDXiPQKbP0UT5
	 zEx4hGZmZsAP32K2g51EQ8l0cLOpBikI2QwwarhK3jaU5ueBHKWSky+ShVRMxgTJWTWBH
	 AUW69gZW4DOgYxGupTfEtz+pSF1hcvSm4gxCD+gU8nvqF8rBaiVGccHtet1sTtajV4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=rly9AuXR;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=weo7LL6n;
	arc=none smtp.remote-ip=103.168.172.145
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B03A606A338
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 03:53:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B03A606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=rly9AuXR;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=weo7LL6n
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 8F1F8EC01D5
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 22:53:53 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 05 Nov 2026 22:53:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1793937233; x=
	1794023633; bh=/uJY+lXVAYz2u+NeiYxSeggW68B7e2gaqanprkeHSEc=; b=r
	ly9AuXRueb3go+G5FqPXEg0czhtuYYppfJyt3HSX/bTgdCmDBpEACEC7wWneuBur
	q+JVtR+zkiNiQv1WjNYiXL06HntZqTpLGsf5qj/uEvZYKMSJHRd9DoySREmf6lh1
	pys5UzmJJvR8FZXLIRGzlGjpQTUnaBS2WCjcJWqaDDfnTv4CcuhdrW25pWAsOOYu
	rArb+6IqkYyFB6FNkSpyVoYmJqeF9PKqS4tHg3qIqVXMg2APxX/Rj1TfJHxyHzwF
	vFyhlTt+cdRVH/LSG9CTxtqxuVc3K0I57heoUy1AzK8g1L1tuayvJFySF4ivuUF3
	8tjmbv/ilZ0fCde4klHuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793937233; x=1794023633; bh=/
	uJY+lXVAYz2u+NeiYxSeggW68B7e2gaqanprkeHSEc=; b=weo7LL6nP7x0whKDf
	JfdW0zy/aDe+Qzopl7yPopg38uIOuLLt1I2xu3l/h1w1I2mZ5WnvP9uQ2j7t00oM
	Ob2RyDCHAj+feo3fPibnkB11Yz8tPPcjDEkq3w4pa8aYpH7YyGJVq9ztu1P+oT9d
	SbZ5i2zmW4UbQVH57h7i0x5P8aCDrnrTDBwlqwfkVb4hE0ayjysTq/+q1JeIP7ih
	HuzUW0njDQ8Z+0yrXVBxYKMx2e+2jCa+OfBCDkbFFaffQvNEyXSXwJJrs42nMsH2
	VZkJQVSSyWfQS3056gAUYH6kG/fQfStUXNbF0VmJ3mn4R9XzdgkCAqt95xGfCiyB
	673qg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793937233; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:qyLvbfAVNI4z2uqx7aRkqgzs44XFU992RBz14XW1G6FvXPM
	8LePV00f8SRbAwn0qE9OFLsqWX/tIPINpDTziWMv0U3lvQVyfGesjvAtQ6UYjmHV
	dZVqjf/sMxiX87W774GiMmD/jtSGfOdOJrKMtGEGlpG0DI1n/Hg/OQAzjuvHIvu1
	EBK3BohgaIah5RTC5xQNnHYWd4UOtolu4ZrRiUHrUtUGjbMf32OGLbpep27D/ilH
	Of9I9rrAS2PPBwydARhoH++czEXEtzEtIgN+N3yaxKBVOFiOis7K/M1+/eHMDvoC
	hv41MwGvocM9vkDMPM9xpBDgGqH5EtI8uue+RKw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:EITy810PDyQ8pZ19Zt6SZd2Zc3MHCK2HTSqO2aM9uyU=:2TPWuyUjk1/sxLv3frLk6/y6HSSkb6ZrGStJTm0Cz8Y=;
X-ME-Sender: <xms:UU_tatTNpNyQesHRdIPAnuLsfDbsS40GJ-qBSxCJA_1XwY1ATMmruQ>
    <xme:UU_taiwZQHuxicEH6xb6e_xIK3LArov1x16mTa_yr86Q12HE1OD1qdW5qsiS8wbAr
    WXqn0q7VkKaItj1BB7v_zfkwT6nZvxGSP0qllkpyooMsyO8j-NM-wHc>
X-ME-Received: <xmr:UU_talCQO_CcTQ00w3xvu4g9XW9R6ZHeElaCPMV6TdxvJlNlKGIUaWixMCVVfCG2>
X-ME-Proxy-Cause: dmFkZTFIjkh/VkrFtaLZ47zpZzzrVb1j87A4M4dFjd8r9QlZeldkq2H9HL9mTFPhexGiWy
    I0wK29+khresqZAE5vlBKDqddYRQaNjPdsGWL/77YszKh7M0swfOmPyXXm3mqQLXMNsU7l
    //jsYHqPtoa4/gNJNhb6ERabdIBEzztwM4Pjx+fleEmj3dQUhDne/H180wHsjwOiCzxwP5
    Y4appzIa6Ek2olO9Rp8Qx/8tY+lq2cKslHR6GV7KjHGBskFIUOVZb9C9RonqmAd8qm8yqA
    m2DSX62OvTbYVYiBEh7k+5I6i7vhrLQb93jchtUugUltCpS6UMDdqLZgU+qjomZXzVHRNI
    baXz9w+l1xANH0tS/dOF2TU00+MjMkbALQh1IRljjpQqymgx3HQ4L6vPHlQtspqJvVk6kn
    7AqNeHEPv3nTVQnchD6ckBNug2CzJaQ0Qg9NqySKq8f6SvE1guOaEtAfzwj1521goSzc+Z
    h4JxsoftqltKS7eF4rqIFCO7veA7OV7lkh0ZlngUuK6M0muryuVg93fAZCQ/yqwoPSe58O
    /yq+SJgM3Y37tR8cI2OOEKsv8JU5AxpsWXOBkkzIbfjmcMnVML4evpS+cd3FtqrLqTKYzr
    qwtMiVzclevAKqw8z2CfpHaLNcoA0lQ9vtQ5AHfQRPazGHoxb8LL+YCqTGXQ
X-ME-Proxy: <xmx:UU_tamEyeGlrQsTNZxR1QhQJktBBvAuXB5h3VMaPPhTpC6qI1hge-A>
    <xmx:UU_takNu-vtkre9y3z6W7yS4oogll9GNe0T3TJFagrz-xsZaPi7GXQ>
    <xmx:UU_tav7ZARZzdDZtuLoKAOo_BIBWVPcB0R1jPVLxJGT6baYxea20cg>
    <xmx:UU_tavg0TMQQZB8AFGmQLd5lu8SirpAWdKPfrltvCPYGbuAk1oNTEg>
    <xmx:UU_tao7QCsZ4YkbrUU2bZrDKsNLEVnacoG_27r9q3jyCBxEJZnOTfpgg>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 22:53:52 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] ksmbd: skip metadata-only opens in sharing checks
Date: Thu,  5 Nov 2026 21:53:44 -0600
Message-ID: <20261106035345.728454-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106035345.728454-1-icb@fastmail.org>
References: <20261106035345.728454-1-icb@fastmail.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A READ_CONTROL open without sharing can block later reads, writes and
deletes even though it holds no data, execute or delete access.

Keep the existing attribute-only exception. For other pairs, require
both effective access masks to hold one of those rights. MS-FSA
2.1.5.1.2 grants FILE_WRITE_DATA when an open overwrites a file or
stream, or creates a named stream on an existing file. Use that granted
access for sharing checks while keeping the requested access on the
returned handle.

The Time Machine AFP_AfpInfo synthesis keeps its requested access.
ksmbd implements FILE_SUPERSEDE by truncating the file, so count it as
a write.

This also prevents an overwrite from truncating a file while another
open that holds data, execute or delete access does not share writing.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    An authenticated user can trigger this on any share, and a guest can on
    a guest-enabled share. Without a stored DACL, directory search
    permission can be enough to hold a metadata-only open without sharing
    and block the file owner's access.
    
    Tested on ksmbd-for-next 957772008502 with KASAN. Targeted tests and
    KUnit matrices covered access masks, sharing modes, create dispositions
    and streams. smbtorture matched the base. There were no KASAN reports or
    warnings.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smb2pdu.c    | 30 ++++++++++++++++++++++--------
 fs/smb/server/smb_common.c | 34 +++++++++++++++++++++++++++++++++-
 fs/smb/server/smb_common.h |  5 +++++
 fs/smb/server/vfs_cache.h  |  2 ++
 4 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b084cca8813c..5bbc33d5a3a8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3541,7 +3541,8 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 
 static noinline int smb2_set_stream_name_xattr(const struct path *path,
 					       struct ksmbd_file *fp,
-					       char *stream_name, int s_type)
+					       char *stream_name, int s_type,
+					       bool *created)
 {
 	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	size_t xattr_stream_size;
@@ -3605,6 +3606,8 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, false);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
+	else
+		*created = true;
 	return 0;
 }
 
@@ -4394,6 +4397,7 @@ int smb2_open(struct ksmbd_work *work)
 	char *stream_name = NULL;
 	bool file_present = false, created = false, already_permitted = false;
 	bool app_instance_id_checked = false, app_instance_closed;
+	bool stream_created = false;
 	int share_ret, need_truncate = 0;
 	u64 time, alloc_size = 0;
 	umode_t posix_mode = 0;
@@ -5138,7 +5142,8 @@ int smb2_open(struct ksmbd_work *work)
 		rc = smb2_set_stream_name_xattr(&path,
 						fp,
 						stream_name,
-						s_type);
+						s_type,
+						&stream_created);
 		if (rc)
 			goto err_out;
 		file_info = FILE_CREATED;
@@ -5146,13 +5151,25 @@ int smb2_open(struct ksmbd_work *work)
 
 	fp->attrib_only = !(req->DesiredAccess & ~(FILE_READ_ATTRIBUTES_LE |
 			FILE_WRITE_ATTRIBUTES_LE | FILE_SYNCHRONIZE_LE));
+	need_truncate = !S_ISDIR(file_inode(filp)->i_mode) &&
+			open_flags & O_TRUNC && !fp->attrib_only && !stream_name;
+	/*
+	 * Count the FILE_WRITE_DATA that MS-FSA 2.1.5.1.2 grants an overwrite,
+	 * supersede included, or a new named stream on an existing file.
+	 * An attribute-only open of the file is not truncated, and the
+	 * synthesized AFP_AfpInfo stream is not created by the client.
+	 */
+	fp->implied_write = need_truncate ||
+			    (stream_name &&
+			     (open_flags & O_TRUNC ||
+			      (file_present && stream_created)));
 
 	fp->is_posix_ctxt = posix_ctxt;
 	fp->posix_append = posix_ctxt && !!(open_flags & O_APPEND);
 
 	/* fp should be searchable through ksmbd_inode.m_fp_list
-	 * after daccess, saccess, attrib_only, and stream are
-	 * initialized.
+	 * after daccess, saccess, attrib_only, implied_write, and
+	 * stream are initialized.
 	 */
 	down_write(&fp->f_ci->m_lock);
 	list_add(&fp->node, &fp->f_ci->m_fp_list);
@@ -5173,11 +5190,8 @@ int smb2_open(struct ksmbd_work *work)
 	if (file_present || created)
 		path_put(&path);
 
-	if (!S_ISDIR(file_inode(filp)->i_mode) && open_flags & O_TRUNC &&
-	    !fp->attrib_only && !stream_name) {
+	if (need_truncate)
 		smb_break_all_oplock(work, fp);
-		need_truncate = 1;
-	}
 
 	share_ret = ksmbd_smb_check_shared_mode(fp->filp, fp);
 	if (!test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_OPLOCKS) ||
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index f9fb3741ada3..e7a987af64ba 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -695,10 +695,24 @@ static void smb_shared_mode_error(int error, struct ksmbd_file *prev_fp,
 		    prev_fp->saccess, curr_fp->daccess);
 }
 
+/*
+ * Sharing checks use fp->daccess plus the FILE_WRITE_DATA that MS-FSA
+ * grants an open that overwrites data or creates a named stream.
+ * fp->daccess keeps the open's own access.
+ */
+__le32 ksmbd_sharing_daccess(const struct ksmbd_file *fp)
+{
+	if (fp->implied_write)
+		return fp->daccess | FILE_WRITE_DATA_LE;
+	return fp->daccess;
+}
+
 int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 {
 	int rc = 0;
 	struct ksmbd_file *prev_fp;
+	__le32 curr_access = ksmbd_sharing_daccess(curr_fp);
+	__le32 access;
 
 	/*
 	 * Lookup fp in master fp list, and check desired access and
@@ -719,6 +733,24 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 		if (prev_fp->attrib_only != curr_fp->attrib_only)
 			continue;
 
+		/*
+		 * MS-FSA checks sharing per stream, so a named stream open's
+		 * implied write is not a write against the primary stream.
+		 * It still decides whether the pair is checked.
+		 */
+		access = curr_access;
+		if (ksmbd_stream_fd(curr_fp) && !ksmbd_stream_fd(prev_fp))
+			access = curr_fp->daccess;
+
+		/*
+		 * Two opens conflict only if both hold a right in
+		 * FILE_SHARE_CHECKED_ACCESS_LE (MS-FSA 2.1.5.1.2.1 and
+		 * 2.1.5.1.2.2)
+		 */
+		if (!(ksmbd_sharing_daccess(prev_fp) & FILE_SHARE_CHECKED_ACCESS_LE) ||
+		    !(curr_access & FILE_SHARE_CHECKED_ACCESS_LE))
+			continue;
+
 		if (!(prev_fp->saccess & FILE_SHARE_DELETE_LE) &&
 		    curr_fp->daccess & FILE_DELETE_LE) {
 			smb_shared_mode_error(SHARE_DELETE_ERROR,
@@ -745,7 +777,7 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 		}
 
 		if (!(prev_fp->saccess & FILE_SHARE_WRITE_LE) &&
-		    curr_fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) {
+		    access & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) {
 			smb_shared_mode_error(SHARE_WRITE_ERROR,
 					      prev_fp,
 					      curr_fp);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index a9cc09e31721..d3d19f1a23ea 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -69,6 +69,10 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
+/* Rights that make an open take part in sharing checks */
+#define FILE_SHARE_CHECKED_ACCESS_LE	(FILE_EXECUTE_LE | FILE_READ_DATA_LE | \
+		FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE | FILE_DELETE_LE)
+
 #define SMB_COM_NEGOTIATE		0x72 /* See MS-CIFS 2.2.2.1 */
 
 /* See MS-CIFS 2.2.3.1 */
@@ -284,6 +288,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn,
 
 int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command);
 
+__le32 ksmbd_sharing_daccess(const struct ksmbd_file *fp);
 int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp);
 int __ksmbd_override_fsids(struct ksmbd_work *work,
 			   struct ksmbd_share_config *share);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index a0239ec178d8..57c81287efe6 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -131,6 +131,8 @@ struct ksmbd_file {
 
 	bool				is_nt_open;
 	bool				attrib_only;
+	/* writes data on open, see ksmbd_sharing_daccess() */
+	bool				implied_write;
 	bool				allocation_size_set;
 
 	char				client_guid[16];
-- 
2.47.3

