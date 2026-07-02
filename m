Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058AB431E7D
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782990363; cv=none; b=Kzv4C7ambeXRpsc06q3PCuHIMT7H50HCz5/EsNogq0xv/ufFW7ly4HDMwzufIijXzyeCrBZpu2qS2Xa7h9XeN4CvJ75FoyWb1MZH2o9aJSglqUbq+2cARZZLm854V4VgoJn/SbwD0NQ6odQp0YWzc8CggfSR+IWBSZ91jBz2GVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782990363; c=relaxed/simple;
	bh=xB+IqcgQR4vdi4ZgQ751reoC1yfidcVzvR1Qv8VqLY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8hQhpML5RrwD5n0+IB9L/qyKNP0uaJ3Y3YhDx1uu/D2/mmld4NCuw7QNbygO30Nptr4RRWt6ypChp5rHK1iAFvvBVa0x0vHqemC5trr5pPDq0UoD1hit42nCn975qjszaV72nnAElEZQbtbGeuVnAF7QXoilKLVfHneweubHU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=TpcJ52C4; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="TpcJ52C4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782990359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jfn7mSdW2PC4szD/nFBW0uVj+uPQm3WUZZOfnwX6GZI=;
	b=TpcJ52C4tUqk4Jcd/6yLRawycQjxRU04ZP+gTtJ/59afb0G8o2lCiyL3xZKnjN1h20UIzO
	dsm94kckkAFbX/kS2wMA+1+Wp8iOoum8EQBWtS43FgEwO0GEGhD5LV6cDObP50dDUTDNLg
	rJ53scAksS3rXzsCxBuPLx8AorEliXlDkOEmQUDwTFuC9ET75w6kKAU2PWI9BwUdhVbCzg
	a/BMzqe8Z3eaMCjWZjlBvSzmopm81QerauCRZqomynBgeAVuqJKvOLpm8jZLM382S35RsF
	F3TebyoGvZ+un2HNwzms1BdVWtqSoDhtVdQuaXpEJ6CpaA0O7Qg1eDMxfc1N6g==
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
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/2] smb/server: factor out smb2_init_err_rsp()
Date: Thu,  2 Jul 2026 11:05:21 +0000
Message-ID: <20260702110522.911411-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
References: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Factor out SMB2 error response body initialization into a helper.
Use a named length for the SMB2 error response.

This prepares the async interim response path to build an error response
without calling smb2_set_err_rsp(), which also pins the response iov.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 540b4affa9fb..43d0dacc7907 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -58,6 +58,9 @@ static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 
 #define WORK_BUFFERS(w, rq, rs)	__wbuf((w), (void **)&(rq), (void **)&(rs))
 
+#define SMB2_ERROR_RSP_LEN	(__SMB2_HEADER_STRUCTURE_SIZE + \
+				 SMB2_ERROR_STRUCTURE_SIZE2)
+
 #define SMB2_CREATE_FILE_ATTRIBUTE_MASK \
 	(FILE_ATTRIBUTE_MASK & ~(FILE_ATTRIBUTE_INTEGRITY_STREAM | \
 				 FILE_ATTRIBUTE_NO_SCRUB_DATA))
@@ -195,6 +198,15 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 	return 1;
 }
 
+static void smb2_init_err_rsp(struct smb2_err_rsp *err_rsp)
+{
+	err_rsp->StructureSize = SMB2_ERROR_STRUCTURE_SIZE2_LE;
+	err_rsp->ErrorContextCount = 0;
+	err_rsp->Reserved = 0;
+	err_rsp->ByteCount = 0;
+	err_rsp->ErrorData[0] = 0;
+}
+
 /**
  * smb2_set_err_rsp() - set error response code on smb response
  * @work:	smb work containing response buffer
@@ -211,14 +223,9 @@ void smb2_set_err_rsp(struct ksmbd_work *work)
 	if (err_rsp->hdr.Status != STATUS_STOPPED_ON_SYMLINK) {
 		int err;
 
-		err_rsp->StructureSize = SMB2_ERROR_STRUCTURE_SIZE2_LE;
-		err_rsp->ErrorContextCount = 0;
-		err_rsp->Reserved = 0;
-		err_rsp->ByteCount = 0;
-		err_rsp->ErrorData[0] = 0;
+		smb2_init_err_rsp(err_rsp);
 		err = ksmbd_iov_pin_rsp(work, (void *)err_rsp,
-					__SMB2_HEADER_STRUCTURE_SIZE +
-						SMB2_ERROR_STRUCTURE_SIZE2);
+					SMB2_ERROR_RSP_LEN);
 		if (err)
 			work->send_no_response = 1;
 	}
-- 
2.54.0

