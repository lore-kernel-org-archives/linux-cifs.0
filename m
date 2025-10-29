Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6463E2D9ECE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744824; cv=none; b=A0oaAzK8L5VkNr03WGeBfOmKGPgVblxnL2Jj8N9J+Sp8SEb+rno13J7A8G1YSje+YxdLuKT3yOx3mUNf+F2x4CAibqMG5h3X6K5rDDreIhikzSwHJbM2vVbspoecn4eetzd6BYfjvv7cvvSQZbcjTALJtJFEVJN6kX6reAVwfho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744824; c=relaxed/simple;
	bh=/szPXrk+xhr7llNAg5Yuj/mUC+5LSKDdRCqGi+qH2r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQAsTd6zc28Sct3uSh0+1WocnjuwReKupDkjh5/tlbjtKFJ6hP6HJ6VfJvByFIuI3PBblYFcHOGc71xyQEk9Ny91UhhoBYrr8TJqRxdYtSPOZk8diTXULL493zEH2ype8QF1QHL3XAshe2d00AYa7pCsHdp93EF1f0wxvsBmADU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=doas9AMn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="doas9AMn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=CwbS/YDlAkblJiLqlWWZTEX6vo3TSIfWqh/ZIAFYDwc=; b=doas9AMnpeACmcRGPSLPWirzQL
	ZkzGmKI0KR/l6pOwhJgrqB+tyem+9zVxDHjpNB2BsN+7A/7K9siTmzHssxVq/K13KF/QdLm2Oulzb
	HIijPwF7hwyAGfZBtJz08ZqN+bDDE/Xx3v7SSIOste9zfClCq78Nqk6w1AQCFEJaq/g0CwTP7AtAW
	4zwV/WRnOh1rnf7T03iSURs3CNkWX9qvWYmRnfbt4TP42WWAiGBskef1Jksg1zly9rqIzNQ2MGXft
	5a++G125Q0rmOSdtF1TbnTfQAxfDT6g/bcZvCm3I/COliJOs84IOoN0/MQcw2kcsyIk9h1pcAf+Df
	JzprmcTWnODi8KAfMuBG2YNTm8YKfM2Aeg7bF7FObChpfx7KohbmetZ0iHGCFu4HnB8YkEVloswp4
	W9bMjpP/Di2HAryDf2Od17j9LekjWxABPc6JDu+kvypnY+QUlSQv5uY+/QqtUSFoNQI57rsja9ZBI
	t/0yd3m4EJxwhA9G3xNkwA8q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6J2-00Bcwg-01;
	Wed, 29 Oct 2025 13:33:40 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 111/127] smb: server: make use of smbdirect_get_buf_page_count()
Date: Wed, 29 Oct 2025 14:21:29 +0100
Message-ID: <9203393dba708100644f38c6d3fcddab5027b37f.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow us to move code into common code
between client and server soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 9cc8cffcc6e9..d8829cb57270 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -196,12 +196,6 @@ unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt)
 	return sp->max_read_write_size;
 }
 
-static inline int get_buf_page_count(void *buf, int size)
-{
-	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
-		(uintptr_t)buf / PAGE_SIZE;
-}
-
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
 				     struct kvec *iov, int niov,
@@ -828,7 +822,7 @@ static int wait_for_rw_credits(struct smbdirect_socket *sc, int credits)
 static int calc_rw_credits(struct smbdirect_socket *sc,
 			   char *buf, unsigned int len)
 {
-	return DIV_ROUND_UP(get_buf_page_count(buf, len),
+	return DIV_ROUND_UP(smbdirect_get_buf_page_count(buf, len),
 			    sc->rw_io.credits.num_pages);
 }
 
@@ -904,7 +898,7 @@ static int get_sg_list(void *buf, int size, struct scatterlist *sg_list, int nen
 	int offset, len;
 	int i = 0;
 
-	if (size <= 0 || nentries < get_buf_page_count(buf, size))
+	if (size <= 0 || nentries < smbdirect_get_buf_page_count(buf, size))
 		return -EINVAL;
 
 	offset = offset_in_page(buf);
@@ -1095,7 +1089,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 			v->iov_len = min_t(size_t,
 					   iov[iov_idx].iov_len - iov_ofs,
 					   possible_bytes);
-			page_count = get_buf_page_count(v->iov_base, v->iov_len);
+			page_count = smbdirect_get_buf_page_count(v->iov_base, v->iov_len);
 			if (page_count > possible_vecs) {
 				/*
 				 * If the number of pages in the buffer
@@ -1124,7 +1118,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 				size_t elen = min_t(size_t, v->iov_len - fplen, epages*PAGE_SIZE);
 
 				v->iov_len = fplen + elen;
-				page_count = get_buf_page_count(v->iov_base, v->iov_len);
+				page_count = smbdirect_get_buf_page_count(v->iov_base, v->iov_len);
 				if (WARN_ON_ONCE(page_count > possible_vecs)) {
 					/*
 					 * Something went wrong in the above
@@ -1289,7 +1283,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 		msg->sgt.sgl = &msg->sg_list[0];
 		ret = sg_alloc_table_chained(&msg->sgt,
-					     get_buf_page_count(desc_buf, desc_buf_len),
+					     smbdirect_get_buf_page_count(desc_buf, desc_buf_len),
 					     msg->sg_list, SG_CHUNK_SIZE);
 		if (ret) {
 			ret = -ENOMEM;
@@ -1303,7 +1297,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 		ret = rdma_rw_ctx_init(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
 				       msg->sgt.sgl,
-				       get_buf_page_count(desc_buf, desc_buf_len),
+				       smbdirect_get_buf_page_count(desc_buf, desc_buf_len),
 				       0,
 				       le64_to_cpu(desc[i].offset),
 				       le32_to_cpu(desc[i].token),
-- 
2.43.0

