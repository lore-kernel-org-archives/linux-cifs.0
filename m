Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DFE32D0F3
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094221; cv=none; b=C6wUfuF+cl/k8d83UJ3kQOq5SUOvf/pTJc29+xoMCB7VYmKMKhAm0W/48pbfHWiszvXlGeKBaoZiD+fw30ZLwlbyDL5IP8Y+uMCy38N5V82WMe/zLwSQ9Z9TAfGdrQzCEFxTicWTeyaf5D5kn6OL1zAHIDxvdOK3unMBV2OQwJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094221; c=relaxed/simple;
	bh=S5CPDaXGjfX5BZr/wP0FRsf94MFXQZNPle4O6f3QE9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhV6jOayxXFBVPAvl7bQ7BZUh+mcPpC9/q1hNfVyrLJsIlPZrhVJPFlrVF9GR9HkYenrkYN+RznVNzLJI32Su/Dl20e+HsUhzGrbI8sEB2OaXZOlwagA5VbSKCiaRIfW4fNhFuPfiEJCqg89mgbG+HAVmTKSzHl+4PGJZRocuhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UQxew6JK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UQxew6JK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hCzrbunfKU4uKGzOleIczLEq+X7+G3nLyd+iUCZCIhU=; b=UQxew6JKVMXKdrccFAk4TryFw7
	w3/oI88WFxKwlAs5ijh5ec1kz01aq2hAznGqEmwjtd/JINyBl8JKanDWWCtIMq/xUQ53qfCOImR4P
	LkYhumFRbkgq6DolYVyfgyVGnWy3OSaVSkh03Q+AasUEHaDr8DvzTpSPuKMwdvIFw2oy5OU485HvH
	/NWIPqCFTPrDBdg5NTcozg1TysDmbuIh9LWf8zimTgDKFTdfRmkEWFJjsaBZXknEchymbYatXh89e
	n0bVO0YI+tyXm8tUYAh9zzaa8RAo8kCHRrgj6QkqZ5A3+ImG4BfFFB2AcyFdVNPixXcxgp7pf3r3y
	7/lSHi+LdLL7KvhCw9DpEcGljnZ3KWRdMmET263BnzC0ApFaLDszgHM/tMbnu4EBLIPyi5u2g67Oj
	eu7POQkjI4j9XsTXXR8kNNQ+is2xvvVxJwFHDR9ktMLJYe09XtdPBVbGHOKQdjOnwsusjDIWf82p4
	kAzIPlwgUV0iijLdOeBg28iS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxSV-00Fe1u-0b;
	Tue, 25 Nov 2025 18:08:12 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 088/145] smb: client: let smbd_post_send_iter() get remaining_length and return data_length
Date: Tue, 25 Nov 2025 18:55:34 +0100
Message-ID: <d976b20508971a51b1ab0dd479f20ad4b124c9d6.1764091285.git.metze@samba.org>
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

This lets the logic be like smb_direct_post_send_data(), so
we can share common code in the next steps.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index bc8c3e3f705f..a924d1aa4a27 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -767,7 +767,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 
 static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       struct iov_iter *iter,
-			       int *_remaining_data_length)
+			       u32 remaining_data_length)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
@@ -777,6 +777,18 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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
@@ -821,12 +833,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 
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
@@ -851,7 +857,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
 			.direction	= DMA_TO_DEVICE,
 		};
-		size_t payload_len = umin(*_remaining_data_length,
+		size_t payload_len = umin(iov_iter_count(iter),
 					  sp->max_send_size - sizeof(*packet));
 
 		rc = smbdirect_map_sges_from_iter(iter, payload_len, &extract);
@@ -859,7 +865,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			goto err_dma;
 		data_length = rc;
 		request->num_sge = extract.num_sge;
-		*_remaining_data_length -= data_length;
+		remaining_data_length -= data_length;
 	} else {
 		data_length = 0;
 	}
@@ -880,7 +886,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	else
 		packet->data_offset = cpu_to_le32(24);
 	packet->data_length = cpu_to_le32(data_length);
-	packet->remaining_data_length = cpu_to_le32(*_remaining_data_length);
+	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
 	packet->padding = 0;
 
 	log_outgoing(INFO, "credits_requested=%d credits_granted=%d data_offset=%d data_length=%d remaining_data_length=%d\n",
@@ -898,7 +904,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 
 	rc = smbd_post_send(sc, request);
 	if (!rc)
-		return 0;
+		return data_length;
 
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
 		wake_up(&sc->send_io.pending.zero_wait_queue);
@@ -930,11 +936,10 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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
 		smbdirect_socket_schedule_cleanup(sc, ret);
@@ -954,9 +959,11 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
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

