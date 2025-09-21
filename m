Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A573A53363
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491217; cv=none; b=UZHziAxwx5Uh63um5tnVKRB6PK22qGOYkj70izpJ7216P1cMbwKRB931S4Ut0wMyCuKIdsUe50iFi99RLuz45Fu0cherwTn+u8//zDKIjtQIY2miFWH2BqmvJklBmZMMcvsB9Cud4LZhuN+76hFHBwtk3DnA+q9WFtp6EnphLTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491217; c=relaxed/simple;
	bh=qqRM0ENepQd7I1gyba+d3O4SGnYo9Jt+C2a7JLQqqwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwiDKSFDtZLSx9N3Sa3UxjwyeOZVWy/Odrvfada4de4mNr4IacToUYnD78wkFt+BO5j07UWDLpHB0RNtPf4QsKSjXSPGE9f8igII5dEfHvAlhsU2gZzZajj+XkPfCFAVhvDEfzlqP3XIAk7iXo2tYy1D20GST84n8K1fFrHivL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nLo4qGrM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nLo4qGrM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=wTnV7jAgVv6lcJdvr93g7Sd19rPW5MwD5qULp3J9V5g=; b=nLo4qGrMmZyyk1j5bgmfOzdFl9
	gIs5mXpkpAtqC7DnbNxB/PitB89CDk77IQsvSoADGqaO8xxzuFwH2NMphqRk8WIHQzGb2Sxo15B5s
	v6e2TwEdca9Ca9z/uY1nzBAK0Q58YlIwk+vV+K+2I2Tpj0tptG5uuDl026YImPhUjXvd4Ac77y1WC
	Oe0Sv6wanBALNRgRDp4dIIxioLgDq3ejGDa2sWnj2ngkOjaMm5w1Ia0eghzZj0ST4HZFrsKi1I7eL
	MuHhjM5C4Kf0lHSpV6hwcyejGosNW4UmDABCvaVDgGpnxQ7rNUSQQ7HFjTxTvy419bmlI1YgWegMf
	Ogs8Cug12HBXaHsWNxf1ju4xWIcNee0BNRgVO/3y1zgld95Z6oUC8tZo1w80XZpkQq7Bi9Wig9cfq
	A2woPyKG5rvibIHbh2yf9wP/uSlH89ybIlbvOvqORwpn9d693Gks3uj37bZpLSEFlpcL0LD6i2kN5
	8+DBam3z2M5TePhV0jrTm83v;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RtT-005GYF-2c;
	Sun, 21 Sep 2025 21:46:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 11/18] smb: client: let smbd_post_send_iter() call ib_dma_map_single() for the header first
Date: Sun, 21 Sep 2025 23:44:58 +0200
Message-ID: <5e543bae44011403245877cb42503a04934e5cf8.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will simplify further changes, the important part is that
request->num_sge >= 1 is only set if request->sge[0].* is valid.

Note that ib_dma_sync_single_for_device() is called in
smbd_post_send() for each sge, so the device will still
see the packet header even if it's modified after calling
ib_dma_map_single().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 43 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d5e2b3009294..0b93e54565f6 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1158,10 +1158,30 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	request->socket = sc;
 	memset(request->sge, 0, sizeof(request->sge));
 
+	/* Map the packet to DMA */
+	header_length = sizeof(struct smbdirect_data_transfer);
+	/* If this is a packet without payload, don't send padding */
+	if (!iter)
+		header_length = offsetof(struct smbdirect_data_transfer, padding);
+
+	packet = smbdirect_send_io_payload(request);
+	request->sge[0].addr = ib_dma_map_single(sc->ib.dev,
+						 (void *)packet,
+						 header_length,
+						 DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(sc->ib.dev, request->sge[0].addr)) {
+		rc = -EIO;
+		goto err_dma;
+	}
+
+	request->sge[0].length = header_length;
+	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
+	request->num_sge = 1;
+
 	/* Fill in the data payload to find out how much data we can add */
 	if (iter) {
 		struct smb_extract_to_rdma extract = {
-			.nr_sge		= 1,
+			.nr_sge		= request->num_sge,
 			.max_sge	= SMBDIRECT_SEND_IO_MAX_SGE,
 			.sge		= request->sge,
 			.device		= sc->ib.dev,
@@ -1180,11 +1200,9 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		*_remaining_data_length -= data_length;
 	} else {
 		data_length = 0;
-		request->num_sge = 1;
 	}
 
 	/* Fill in the packet header */
-	packet = smbdirect_send_io_payload(request);
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
 	new_credits = manage_credits_prior_sending(sc);
@@ -1211,25 +1229,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->data_length),
 		     le32_to_cpu(packet->remaining_data_length));
 
-	/* Map the packet to DMA */
-	header_length = sizeof(struct smbdirect_data_transfer);
-	/* If this is a packet without payload, don't send padding */
-	if (!data_length)
-		header_length = offsetof(struct smbdirect_data_transfer, padding);
-
-	request->sge[0].addr = ib_dma_map_single(sc->ib.dev,
-						 (void *)packet,
-						 header_length,
-						 DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(sc->ib.dev, request->sge[0].addr)) {
-		rc = -EIO;
-		request->sge[0].addr = 0;
-		goto err_dma;
-	}
-
-	request->sge[0].length = header_length;
-	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
-
 	rc = smbd_post_send(sc, request);
 	if (!rc)
 		return 0;
-- 
2.43.0

