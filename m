Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797669;
	b=28GOpABdDM3tn78Vm7Q+rwKuAJykGjjRCREHfDfWPQuTg6XIiYXwRlXMqIncjDDc0BaF
	 CdSM/3exBekKgEwLNnLaF8u+IXq99vN8fWJmTqkE+RslDGFXRQH9FNYpDX0r3G2XQhsYa
	 bOdzIpG4SedALPE7HwlSNbBC20U7HrCt1R9tHeNWLJLVZcQV5FKZJEVZW8hqdWZ1cSGC1
	 FmFT3aWOLA8LhtYHHPha6D1tSPdp7gqJ1yGONdUhPtsrWCNOYmySfhWFGfDzWlp9Pbvr5
	 hbCI9ZISQpDJrMpBMenK06eK9TAvxEwNC6W63+BJfDMajk3Cmzm6fBfDvXIuJ/a1JZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797669;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ibivpfxy3zOq5viANJcgzwXhf2SB1it8CuByfU/u/eI=;
	b=qtOf0atb8NgSplwfm/VAENUB2qLpgY1gipgQ1OmC7vRSYjehXHUXWIlpAzVlOqH+NTOQ
	 yKNBr0DNdMze8h9B2hhEqxS/VT9LK/gDdIMT/R46GmiqF9BMeJ7rrc3vK4fBDcBgY0Wy8
	 QbLtj4OIHqg001CkLHmVDALTKgAl7w82pLbmclpCztEOhvX15oqObDEoIFDsR5sTx+igA
	 TX1ptXgLe22hR9vu0psKYFQFHdDhc/m9Nm5o683M1dhNyHmquqhjl28Rd7q5R/Wl2JRS4
	 k+0c4B6IJFDO9/yA6oBce+jP8ZcIu+Iss5UANRoZuJmVmZ8IawZQahtevfKFnMQn6gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=j75vtlM8;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56460606A32D;
	Fri, 27 Nov 2026 16:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56460606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=j75vtlM8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ibivpfxy3zOq5viANJcgzwXhf2SB1it8CuByfU/u/eI=; b=j75vtlM8+Fq8TABAZ+Bj42wIQf
	hoV85fnru3easDyryW+ytDfJ3h+Cq422skio/U7CoihNSNK3YM+9UuezPpkLT/LTQmFfDAQhz03kv
	q0lp4ILAICD7s9omuv+rXhAVUrbkh2VwQS0mcALpOFpUmXhNBtbHGFpkq4uGb91DQUBR1IqdrX90Q
	nXt+IrRxaxt+aZQzRtj5Lsvfu5dWAlbGNjTyyjMMEMgcedFlgILnmXbhRabkOVzB4GaquAiSXFJ8e
	JPDIxbQ4lKrlEBEY4ggrF6Wcx2NQOHbFZnmcZgmUpILSLkXpkKRx/N3B3xeJqKWGFDi5+ntT16cZ/
	YLJu3+GxqKCG5KX9B5sKUjpFEg0sJ9rMyveBsX6AZ67ybb0sfrkJK6i0erENCz9xLWcbY6zZqI2xA
	tOyBi+PFtO+/GkOnAoLy3ZWj74PdsKhEQQt9NkIcYxawR33lXsKfs/IDTXjXO2HFohQJPpzBKH40r
	o/400RIfVU6GZsV0zv/nBYzf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz0J-00000001Pvi-1Z11;
	Fri, 27 Nov 2026 16:40:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH v2 03/13] smb: smbdirect: handle errors from smbdirect_iter_to_sgt()
Date: Fri, 27 Nov 2026 17:40:22 +0100
Message-ID: <9634ab9ab8c199e96b110d9021712f04bfde262b.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
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

smbdirect_connection_register_mr_io() ignored the return value of
smbdirect_iter_to_sgt(), so a failing extract_iter_to_sg() went on
with an incomplete or empty sg table. Fail the registration instead.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/mr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index af613a7405e7..c50cdb1b6cc4 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -323,7 +323,13 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
 		"num_pages=%u count=%zu depth=%u\n",
 		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
-	smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
+	ret = smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
+	if (ret < 0) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_iter_to_sgt() num_pages=%u dir=%x ret=%d (%1pe)\n",
+			num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto dma_map_error;
+	}
 
 	num_mapped = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 	if (!num_mapped) {
-- 
2.43.0

