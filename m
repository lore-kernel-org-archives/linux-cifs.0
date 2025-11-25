Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50E132D0EE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095361; cv=none; b=pDFVvhwpWvG+lFWoTbPJuWtagansePfhy2h96r0GxOy3Qvb86et4EI7bkvrVY4WTMu/pCtktvOuuwT+GH3ODbIYQN37if47ow424uNMdqcYdKCg4CTG2ajdCymLCEQp9tP6OGwrsCJT9Y12bhOX1Trd/G4M6jZT12D1f3sV6XXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095361; c=relaxed/simple;
	bh=KXmK3A1NprumYR85Q4RYDyQzk5s49V/0aJJvZCyNchs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1exWdff1Hxn/rMeqXaa09vvXU/xIKJW/mLlOl0rQd892Z7csontnMP3edE+xFw9HCnH71B/kv4jwKVT2WAHXRL2V7NPd3KoDt5/WNZhY/CxxGWk17BmmNNcsRiwUNpItiAUP8YTSMf6+oWF0jZ/Pu/hogthI0tnbGOX9RKhA7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Bc/yqUsz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Bc/yqUsz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=f5xLZbObS5BAz1NPEbF9m/WJpTL3iEkYfp88rTUTWzc=; b=Bc/yqUszNPutxgivcDEIWS+glE
	Ds6/t/p0Hnihlfx2lJYxhzsMsw6KJoZxH17aeQ905Cx3dLiAgNZ5980ZMFinARGlovf98CpwekzMR
	h5iojDiebx7P3HvU/x22F3PkzR31XR/rdNhUovis3UHq8cCW4/zoYgB5o+hSEeG08t2zwLUjs7FtD
	JPRNkET/WLev6ECfYuv8Z3ekVuvfwlrmbD+k8oPROcqOze1PaAET8AtW6VLEmbTbengsMFbwasT22
	gAHjoRh0hMVlmDAUjpVXnAlsVfNKKvmMIiAar4Kn61s9LmIP23q7fHtPKrKMRL8h8BVkDzhBJVHkf
	G/oY4/5vuTel9CryriCVlgu6Qv0ihi7AzIMSQSEtIOmHff1y2b6p5Qfczla1/aNN8gkCeB4JeukBF
	ghDgRQQLITOm8g35189ja6KrIlq2A9IfrSPY2tKPuuxuG4jfyVxdfkflOzPz5mIcFcxXoBzyOvlrn
	NLwfs/fKb/43/1hlMloFdu4u;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxh0-00FffH-1I;
	Tue, 25 Nov 2025 18:23:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 126/145] smb: server: let smbdirect_map_sges_from_iter() truncate the message boundary
Date: Tue, 25 Nov 2025 18:56:12 +0100
Message-ID: <b666ffcac342899d6245c2038d50105ebe013573.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbdirect_map_sges_from_iter() already handles the case that only
a limited number of sges are available. Its return value
is data_length and the remaining bytes in the iter are
remaining_data_length.

This is now much easier and will allow us to share
more code with the client soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 151 +++++++--------------------------
 1 file changed, 31 insertions(+), 120 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index ff7e9fab6c03..b153a47be237 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -199,7 +199,7 @@ unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt)
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
 				     struct iov_iter *iter,
-				     size_t *remaining_data_length);
+				     u32 remaining_data_length);
 
 static void smb_direct_send_immediate_work(struct work_struct *work)
 {
@@ -209,7 +209,7 @@ static void smb_direct_send_immediate_work(struct work_struct *work)
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return;
 
-	smb_direct_post_send_data(sc, NULL, NULL, NULL);
+	smb_direct_post_send_data(sc, NULL, NULL, 0);
 }
 
 static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
@@ -661,22 +661,26 @@ static int post_sendmsg(struct smbdirect_socket *sc,
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
 				     struct iov_iter *iter,
-				     size_t *_remaining_data_length)
+				     u32 remaining_data_length)
 {
 	const struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_io *msg;
 	struct smbdirect_data_transfer *packet;
 	size_t header_length;
 	u16 new_credits = 0;
-	u32 remaining_data_length = 0;
 	u32 data_length = 0;
 	int ret;
 
 	if (iter) {
 		header_length = sizeof(struct smbdirect_data_transfer);
+		if (WARN_ON_ONCE(remaining_data_length == 0 ||
+				 iov_iter_count(iter) > remaining_data_length))
+			return -EINVAL;
 	} else {
 		/* If this is a packet without payload, don't send padding */
 		header_length = offsetof(struct smbdirect_data_transfer, padding);
+		if (WARN_ON_ONCE(remaining_data_length))
+			return -EINVAL;
 	}
 
 	ret = wait_for_send_lcredit(sc, send_ctx);
@@ -687,14 +691,6 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	if (ret)
 		goto credit_failed;
 
-	if (iter)
-		data_length = iov_iter_count(iter);
-
-	if (_remaining_data_length) {
-		*_remaining_data_length -= data_length;
-		remaining_data_length = *_remaining_data_length;
-	}
-
 	msg = smbdirect_connection_alloc_send_io(sc);
 	if (IS_ERR(msg)) {
 		ret = PTR_ERR(msg);
@@ -723,14 +719,14 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
 			.direction	= DMA_TO_DEVICE,
 		};
+		size_t payload_len = umin(iov_iter_count(iter),
+					  sp->max_send_size - sizeof(*packet));
 
-		ret = smbdirect_map_sges_from_iter(iter, data_length, &extract);
+		ret = smbdirect_map_sges_from_iter(iter, payload_len, &extract);
 		if (ret < 0)
 			goto err;
-		if (WARN_ON_ONCE(ret != data_length)) {
-			ret = -EIO;
-			goto err;
-		}
+		data_length = ret;
+		remaining_data_length -= data_length;
 		msg->num_sge = extract.num_sge;
 	}
 
@@ -783,13 +779,9 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	struct smb_direct_transport *st = SMBD_TRANS(t);
 	struct smbdirect_socket *sc = &st->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	size_t remaining_data_length;
-	size_t iov_idx;
-	size_t iov_ofs;
-	size_t max_iov_size = sp->max_send_size -
-			sizeof(struct smbdirect_data_transfer);
 	int ret;
 	struct smbdirect_send_batch send_ctx;
+	struct iov_iter iter;
 	int error = 0;
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
@@ -798,112 +790,31 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	//FIXME: skip RFC1002 header..
 	if (WARN_ON_ONCE(niovs <= 1 || iov[0].iov_len != 4))
 		return -EINVAL;
-	buflen -= 4;
-	iov_idx = 1;
-	iov_ofs = 0;
-
-	remaining_data_length = buflen;
-	ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=%u\n", buflen);
-
-	smb_direct_send_ctx_init(&send_ctx, need_invalidate, remote_key);
-	while (remaining_data_length) {
-		struct kvec vecs[SMBDIRECT_SEND_IO_MAX_SGE - 1]; /* minus smbdirect hdr */
-		size_t possible_bytes = max_iov_size;
-		size_t possible_vecs;
-		size_t bytes = 0;
-		size_t nvecs = 0;
-		struct iov_iter iter;
-
-		/*
-		 * For the last message remaining_data_length should be
-		 * have been 0 already!
-		 */
-		if (WARN_ON_ONCE(iov_idx >= niovs)) {
-			error = -EINVAL;
-			goto done;
-		}
+	iov_iter_kvec(&iter, ITER_SOURCE, iov, niovs, buflen);
+	iov_iter_advance(&iter, 4);
 
-		/*
-		 * We have 2 factors which limit the arguments we pass
-		 * to smb_direct_post_send_data():
-		 *
-		 * 1. The number of supported sges for the send,
-		 *    while one is reserved for the smbdirect header.
-		 *    And we currently need one SGE per page.
-		 * 2. The number of negotiated payload bytes per send.
-		 */
-		possible_vecs = min_t(size_t, ARRAY_SIZE(vecs), niovs - iov_idx);
-
-		while (iov_idx < niovs && possible_vecs && possible_bytes) {
-			struct kvec *v = &vecs[nvecs];
-			int page_count;
-
-			v->iov_base = ((u8 *)iov[iov_idx].iov_base) + iov_ofs;
-			v->iov_len = min_t(size_t,
-					   iov[iov_idx].iov_len - iov_ofs,
-					   possible_bytes);
-			page_count = smbdirect_get_buf_page_count(v->iov_base, v->iov_len);
-			if (page_count > possible_vecs) {
-				/*
-				 * If the number of pages in the buffer
-				 * is to much (because we currently require
-				 * one SGE per page), we need to limit the
-				 * length.
-				 *
-				 * We know possible_vecs is at least 1,
-				 * so we always keep the first page.
-				 *
-				 * We need to calculate the number extra
-				 * pages (epages) we can also keep.
-				 *
-				 * We calculate the number of bytes in the
-				 * first page (fplen), this should never be
-				 * larger than v->iov_len because page_count is
-				 * at least 2, but adding a limitation feels
-				 * better.
-				 *
-				 * Then we calculate the number of bytes (elen)
-				 * we can keep for the extra pages.
-				 */
-				size_t epages = possible_vecs - 1;
-				size_t fpofs = offset_in_page(v->iov_base);
-				size_t fplen = min_t(size_t, PAGE_SIZE - fpofs, v->iov_len);
-				size_t elen = min_t(size_t, v->iov_len - fplen, epages*PAGE_SIZE);
-
-				v->iov_len = fplen + elen;
-				page_count = smbdirect_get_buf_page_count(v->iov_base, v->iov_len);
-				if (WARN_ON_ONCE(page_count > possible_vecs)) {
-					/*
-					 * Something went wrong in the above
-					 * logic...
-					 */
-					error = -EINVAL;
-					goto done;
-				}
-			}
-			possible_vecs -= page_count;
-			nvecs += 1;
-			possible_bytes -= v->iov_len;
-			bytes += v->iov_len;
-
-			iov_ofs += v->iov_len;
-			if (iov_ofs >= iov[iov_idx].iov_len) {
-				iov_idx += 1;
-				iov_ofs = 0;
-			}
-		}
+	/*
+	 * The size must fit into the negotiated
+	 * fragmented send size.
+	 */
+	if (iov_iter_count(&iter) > sp->max_fragmented_send_size)
+		return -EMSGSIZE;
 
-		iov_iter_kvec(&iter, ITER_SOURCE, vecs, nvecs, bytes);
+	ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=%zu\n",
+		    iov_iter_count(&iter));
 
-		ret = smb_direct_post_send_data(sc, &send_ctx,
-						&iter, &remaining_data_length);
+	smb_direct_send_ctx_init(&send_ctx, need_invalidate, remote_key);
+	while (iov_iter_count(&iter)) {
+		ret = smb_direct_post_send_data(sc,
+						&send_ctx,
+						&iter,
+						iov_iter_count(&iter));
 		if (unlikely(ret)) {
 			error = ret;
-			goto done;
+			break;
 		}
 	}
 
-done:
 	ret = smb_direct_flush_send_list(sc, &send_ctx, true);
 	if (unlikely(!ret && error))
 		ret = error;
-- 
2.43.0

