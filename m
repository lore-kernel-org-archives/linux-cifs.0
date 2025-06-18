Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1602F49F6
	for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750265545; cv=none; b=Qi7YrboWjFEK2e5kAH5mkrRd1NyXO3RTk8h9xqQkchTR83wQuNKb7iKIOAy7sc8pZJSDNgpv7thTgq2vwxLJ3HdFG4zfObxfvJxbwQn0NX4JsKSEt6R2crbrOWvphvoLkQIV6j/LkzQ9jDsvPgkWd6tyIaUA/o8ccEaOCH64Db4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750265545; c=relaxed/simple;
	bh=oE2sey6iK+3XMqkGsPvHPgefvLAViyGJbjlsGHFFO+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UZnsG/38RWcIF4vd84jjslJ+nQTWKm9zXhO60UmvioCUOhFwXGM+BgvB8mQAABGpuofwlVOJHcol+xSooPJkBRqvmpHg8S0EaHOA2tqrXiDBAKEKilqzr1WIn9iXNnhVNu+dTJ8sJ2RFi1XuvlLOzMPrpNEp187JjjMvzEoqsGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cf9dVmCj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cf9dVmCj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=AuZg51BO8koDimSdoTHlqr111cCTmSQtdCELPTRIJpU=; b=cf9dVmCjmFMj6NmdabkCVF4GQu
	kDTxScTB2Gz6FeYuCP7fvpJ6Z3eKPLwm+EE2fv6WLGwt43kNYZ6NIgn/TMCslFdLg0k5SdGh4zsdc
	3KkucQZViCk3a4r1dnDiirNGCJdal7f2q1JiSygSS+7TG/CY9aPkYGbK48YMmltkNao/7DsEb3IPu
	Veq3+h4di4KokrqsGRmX2jqaC3ba9uhg8BIwqDA4N0zlTHLYZUNFM9TT7vkiBX93w7xgTH7S7Q/0k
	C9mBNjfPcl0HAQVTN9wrV2X1TgMG47iViA89uwZsrkI4ZLwsf8Ma+gnwH3oqRrvfghiq6uYif9Sub
	7P3Tauf+BANFIAvNMs76LSRMyMha8zbM/MaDN/UOnstgrnnBfM6ED3RJXaJLm/m0fK5FSD4mNYR6j
	wYcwatJ2XrQ4GI8swe1tyd7u4PeG9s0B1EHMFsF0eYJEB4lyhybTnJ54wav/YpPTi25fEvEHw1kyn
	ggBoRPu3UnilkRRGNdTUh5Ds;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uRw1M-00BL6w-2j;
	Wed, 18 Jun 2025 16:52:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <sfrench@samba.org>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Date: Wed, 18 Jun 2025 18:51:41 +0200
Message-Id: <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1750264849.git.metze@samba.org>
References: <cover.1750264849.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should not send smbdirect_data_transfer messages larger than
the negotiated max_send_size, typically 1364 bytes, which means
24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.

This happened when doing an SMB2 write with more than 1340 bytes
(which is done inline as it's below rdma_readwrite_threshold).

It means the peer resets the connection.

Note for stable sp->max_send_size needs to be info->max_send_size:

  @@ -895,7 +895,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
                          .direction      = DMA_TO_DEVICE,
                  };
                  size_t payload_len = min_t(size_t, *_remaining_data_length,
  -                                          sp->max_send_size - sizeof(*packet));
  +                                          info->max_send_size - sizeof(*packet));

                  rc = smb_extract_iter_to_rdma(iter, payload_len,
                                                &extract);

cc: Steve French <sfrench@samba.org>
cc: David Howells <dhowells@redhat.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an iterator")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index cbc85bca006f..3a41dcbbff81 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -842,7 +842,7 @@ static int smbd_post_send(struct smbd_connection *info,
 
 static int smbd_post_send_iter(struct smbd_connection *info,
 			       struct iov_iter *iter,
-			       int *_remaining_data_length)
+			       unsigned int *_remaining_data_length)
 {
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -907,8 +907,10 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
 			.direction	= DMA_TO_DEVICE,
 		};
+		size_t payload_len = min_t(size_t, *_remaining_data_length,
+					   sp->max_send_size - sizeof(*packet));
 
-		rc = smb_extract_iter_to_rdma(iter, *_remaining_data_length,
+		rc = smb_extract_iter_to_rdma(iter, payload_len,
 					      &extract);
 		if (rc < 0)
 			goto err_dma;
@@ -970,8 +972,16 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
 	rc = smbd_post_send(info, request);
-	if (!rc)
+	if (!rc) {
+		if (iter && iov_iter_count(iter) > 0) {
+			/*
+			 * There is more data to send
+			 */
+			goto wait_credit;
+		}
+
 		return 0;
+	}
 
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
@@ -1007,7 +1017,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
  */
 static int smbd_post_send_empty(struct smbd_connection *info)
 {
-	int remaining_data_length = 0;
+	unsigned int remaining_data_length = 0;
 
 	info->count_send_empty++;
 	return smbd_post_send_iter(info, NULL, &remaining_data_length);
-- 
2.34.1

