Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F819346A18
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744656; cv=none; b=cx+GtJBHoFkw20inkzC7xU/pu5Mrxl5/p4n1Z5q848GZyCH/aou2qsVCp8w3BBa8jJIzyz74BnyJ0bdm4TcaEY9RVcT3m6bIsuJ6INtPmuelGnhzUMnw+BtppJXSRXK+NSY85EoFOv2ovdS5Emem4pnVm57i8GYDzs9adtSIuaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744656; c=relaxed/simple;
	bh=bsPjxxa+tTiETNeQ+xRnONgjH6IEh68cTC4BNTt1qrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/PxroOFdiGuhxYa7y8RiIm1/aZhhJK/pZwxUxxTpwjjSKdUqWWv1wB316pKySAxy8PIMbX1pRh7en7CqbqowFIZ1SBJN11Tg7c4G8HjvRv6/SKHMxzHtm6UmQedK9Wz1+SVDZzDETrAHG2IO0uBi8WqFkZsvahBcHoz1cqNCw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xzoI2dzM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xzoI2dzM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JATSk+bgvGL+CSvVa8Bxb8c877MK0abt5QE5+0tQH8M=; b=xzoI2dzM7DDUaWFxNAHpzAwDap
	t3arn+bmkHyI8lUBNBAxUqIB10RhKwKeD2eHBiFFNK34EEzYrjGFfaAkyq4LEljDRipDqxVHdDeZu
	34KlUln7RPEG3WNwkL/UMR7VoYJbvN62zx/PKs6SbmwjsUCKPEyBKXPSqzaTVNnuLPs8HtR/OHHmb
	m2zZDMTldMdbRWk3wsnFyEr/2Tn3MqQJPrySSfc3Ysv32o08X7RpZEatyuvZ6F+OWreGR8zW7ifVX
	bCTHXFPZdth1bDuREELuwFlLBsCQNdggAEvb6N7dvTovupWGH/YNSvKriSz1zr3PtXTNcr2EQdimS
	MHrvJYKLl1HBfeDIA8KDvMQ753k8NANnYYQR4KmQyEbCBytBg1n1n6z/vzJ16SzcoFhC2dAdFuMdZ
	soXNvzGq0SmYUI5cMg5Tctke/rhBCC4+ya0+b9ezHqqAVtlK0yPQLJoqlGyRq+18kIcr/Qy0WRUbn
	hUsM4s9bt9RxxssgSwsJFEU6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6GD-00BcQo-09;
	Wed, 29 Oct 2025 13:30:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 083/127] smb: client: let smbd_post_send_iter() get remaining_length and return data_length
Date: Wed, 29 Oct 2025 14:21:01 +0100
Message-ID: <cf374a7847af2097543d6bf7d75fb9ea0b15fb52.1761742839.git.metze@samba.org>
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

This lets the logic be like smb_direct_post_send_data(), so
we can share common code in the next steps.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b94fa3bec5c5..34404a1d3e58 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -766,7 +766,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 
 static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       struct iov_iter *iter,
-			       int *_remaining_data_length)
+			       u32 remaining_data_length)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
@@ -776,6 +776,18 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	struct smbdirect_data_transfer *packet;
 	u16 new_credits = 0;
 
+	if (iter) {
+		header_length = sizeof(struct smbdirect_data_transfer);
+		if (WARN_ON_ONCE(remaining_data_length == 0 ||
+				 iov_iter_count(iter) > remaining_data_length))
+			return -EINVAL;
+	} else {
+		/* If this is a packet without payload, don't send padding */
+		header_length = offsetof(struct smbdirect_data_transfer, padding);
+		if (WARN_ON_ONCE(remaining_data_length))
+			return -EINVAL;
+	}
+
 wait_lcredit:
 	/* Wait for local send credits */
 	rc = wait_event_interruptible(sc->send_io.lcredits.wait_queue,
@@ -820,12 +832,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 
 	memset(request->sge, 0, sizeof(request->sge));
 
-	/* Map the packet to DMA */
-	header_length = sizeof(struct smbdirect_data_transfer);
-	/* If this is a packet without payload, don't send padding */
-	if (!iter)
-		header_length = offsetof(struct smbdirect_data_transfer, padding);
-
 	packet = smbdirect_send_io_payload(request);
 	request->sge[0].addr = ib_dma_map_single(sc->ib.dev,
 						 (void *)packet,
@@ -850,7 +856,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
 			.direction	= DMA_TO_DEVICE,
 		};
-		size_t payload_len = umin(*_remaining_data_length,
+		size_t payload_len = umin(iov_iter_count(iter),
 					  sp->max_send_size - sizeof(*packet));
 
 		rc = smbdirect_map_sges_from_iter(iter, payload_len, &extract);
@@ -858,7 +864,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			goto err_dma;
 		data_length = rc;
 		request->num_sge = extract.num_sge;
-		*_remaining_data_length -= data_length;
+		remaining_data_length -= data_length;
 	} else {
 		data_length = 0;
 	}
@@ -879,7 +885,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	else
 		packet->data_offset = cpu_to_le32(24);
 	packet->data_length = cpu_to_le32(data_length);
-	packet->remaining_data_length = cpu_to_le32(*_remaining_data_length);
+	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
 	packet->padding = 0;
 
 	log_outgoing(INFO, "credits_requested=%d credits_granted=%d data_offset=%d data_length=%d remaining_data_length=%d\n",
@@ -897,7 +903,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 
 	rc = smbd_post_send(sc, request);
 	if (!rc)
-		return 0;
+		return data_length;
 
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
 		wake_up(&sc->send_io.pending.zero_wait_queue);
@@ -929,11 +935,10 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
  */
 static void smbd_post_send_empty(struct smbdirect_socket *sc)
 {
-	int remaining_data_length = 0;
 	int ret;
 
 	sc->statistics.send_empty++;
-	ret = smbd_post_send_iter(sc, NULL, &remaining_data_length);
+	ret = smbd_post_send_iter(sc, NULL, 0);
 	if (ret < 0) {
 		log_rdma_send(ERR, "smbd_post_send_iter failed ret=%d\n", ret);
 		smbdirect_connection_schedule_disconnect(sc, ret);
@@ -953,9 +958,11 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	 */
 
 	while (iov_iter_count(iter) > 0) {
-		rc = smbd_post_send_iter(sc, iter, _remaining_data_length);
+		rc = smbd_post_send_iter(sc, iter, *_remaining_data_length);
 		if (rc < 0)
 			break;
+		*_remaining_data_length -= rc;
+		rc = 0;
 	}
 
 	return rc;
-- 
2.43.0

