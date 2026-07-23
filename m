Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1B8369D51
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 04:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784779948; cv=none; b=VqiDjyLCcT/cLEV8oqt/8mT42Z9PnT0TzRvtqg5wsbF9SHYIRMK6n34FNNfZ9PaXkXbmaaLB0vwRFeRiP9BT4sDBLoy4HMW4ncc6K3HMX8pDf5Gd0qFfNKh0i4nfG57kJYDbzuQoZYSbX3TwRyvagjeDF/CG1qqfiDzUJlGUeck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784779948; c=relaxed/simple;
	bh=yJa7Ms1ESHSWrVfyfwyxBm1jQDlbvwMj4fStv3H/Zeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJqDL/4aN6BwjH/NTDjhXF6bDDALa7FsNmhmtYrh3/DrI3EbNze3mvboabvQnLI65LBCfLCF3CrvPTjeXYwVaU9VsCq/nItbpXk+1JjX9jbw6jH9Pit04UViaRbYHkNOgCS8gjm4gubl+zyF0Xmyn3It4cTwYfykPFbI60x9Psg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=TDBJ3ydK; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="TDBJ3ydK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784779919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ym7VFeU+RHPW6wFBscB3c2T48n0hwkNBybBuaOKiPNo=;
	b=TDBJ3ydKY4a9HNaNNJjm4LqbEtpdlZSXjyijnXmF2pThGLqEt2HY4KQfIkozDq5XuX/MSc
	ikKuEHFc5NhvLvSz6uypUlPAQa+zEhn1T82SFn6fY4czkdEr4LBqrX9PhSh166VymYLc34
	AgOHGH2SYQMXdQQSkegdxQ/VnnzG9t1O/7pcRNynEcQgy4rtUTwgwaHl/eTG8nFy0KsAso
	NPH4SA4tonccNB5fmjK3xx27J3vXdjxKjHnQfA06OWNLnsNBfZGB1vT7i7vO1DVbRy6Ona
	2gQ5KUNb51KdAv4IbgigiD0Pr8Xqnev6CyES9c8o9up0bKwN32xwjLIrtBw/DQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	gael.blivet@gmail.com,
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 1/3] smb/server: fix signing when a response uses more than one iov
Date: Thu, 23 Jul 2026 04:11:29 +0000
Message-ID: <20260723041131.313321-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
References: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Some SMB responses keep their data in another buffer. The SMB header
and the data are then in different iovs.

The old code only handled this for SMB2 READ. For other commands, it
signed only the last iov. QUERY_INFO and CHANGE_NOTIFY can also use
another iov for their data. Their SMB header was not signed, so Windows
will client rejected the response.

Find the iov that starts with the current SMB header. Sign this iov and
all iovs after it.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 51 ++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 13dea63ec3bd..54327f8362db 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10933,6 +10933,39 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 	return 1;
 }
 
+/**
+ * smb2_get_sign_rsp_iov() - get the iovecs used to sign a response
+ * @work: work that has the response iovecs
+ * @hdr: SMB2 header of the response
+ * @n_vec: set to the number of iovecs to sign
+ *
+ * Response data may be in another buffer. In this case, the response uses
+ * more than one iovec. Find the iovec that starts with @hdr. Sign this
+ * iovec and all iovecs after it.
+ *
+ * Return: The first iovec to sign.
+ */
+static struct kvec *smb2_get_sign_rsp_iov(struct ksmbd_work *work,
+					   struct smb2_hdr *hdr, int *n_vec)
+{
+	int i;
+
+	/*
+	 * iov[0] has the RFC1002 message length. It is not part of the SMB2
+	 * message, so do not sign it.
+	 */
+	for (i = 1; i <= work->iov_idx; i++) {
+		if (work->iov[i].iov_base == hdr) {
+			*n_vec = work->iov_idx - i + 1;
+			return &work->iov[i];
+		}
+	}
+
+	WARN_ON_ONCE(1);
+	*n_vec = 1;
+	return &work->iov[work->iov_idx];
+}
+
 /**
  * smb2_set_sign_rsp() - handler for rsp packet sign processing
  * @work:   smb work containing notify command buffer
@@ -10943,18 +10976,13 @@ void smb2_set_sign_rsp(struct ksmbd_work *work)
 	struct smb2_hdr *hdr;
 	char signature[SMB2_HMACSHA256_SIZE];
 	struct kvec *iov;
-	int n_vec = 1;
+	int n_vec;
 
 	hdr = ksmbd_resp_buf_curr(work);
 	hdr->Flags |= SMB2_FLAGS_SIGNED;
 	memset(hdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
-	if (hdr->Command == SMB2_READ) {
-		iov = &work->iov[work->iov_idx - 1];
-		n_vec++;
-	} else {
-		iov = &work->iov[work->iov_idx];
-	}
+	iov = smb2_get_sign_rsp_iov(work, hdr, &n_vec);
 
 	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, n_vec,
 			    signature);
@@ -11037,7 +11065,7 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	char signature[SMB2_CMACAES_SIZE];
 	struct kvec *iov;
 	u16 command = conn->ops->get_cmd_val(work);
-	int n_vec = 1;
+	int n_vec;
 	char *signing_key;
 
 	hdr = ksmbd_resp_buf_curr(work);
@@ -11059,12 +11087,7 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
 	hdr->Flags |= SMB2_FLAGS_SIGNED;
 	memset(hdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
-	if (hdr->Command == SMB2_READ) {
-		iov = &work->iov[work->iov_idx - 1];
-		n_vec++;
-	} else {
-		iov = &work->iov[work->iov_idx];
-	}
+	iov = smb2_get_sign_rsp_iov(work, hdr, &n_vec);
 
 	ksmbd_sign_smb3_pdu(conn, signing_key, iov, n_vec, signature);
 	memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
-- 
2.54.0

