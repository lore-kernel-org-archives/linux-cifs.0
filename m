Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782582;
	b=OTYLIow588R4e7il8UVQYwg1Pc9aqRQPay0Oce3pLo3XRTh0UhjLwVdx5I3E/nT1PNNG
	 v0Vqld1AZkzMc4EiWebov98i8VqnSNTJV5S19Re+0rrDEtKyTHDLt0PtmPXnemUxVHxd8
	 3ALYY9uTjLNHp4n0lOQO20hhyY+Ta2OKNFZA4NTzyzwAMT06/1i5rsDURTv9NCNPYVyuj
	 zHxjnQNEU+fbXbCzRLdUfdZ35PVwmlI5ZXTNpvLUDng8wgfor4gXHGOIs0b0kIenZ18Ls
	 gCC/baeLrkJnBJdCZ1rrpMMdICiQ8QlWE0wd7iKxo5o2U77xASfrJqg0B8hLFF+CRvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782582;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MEOdGE5ymQEKYdPhnwDCZq3BfbxiVieYiwN2ZS/lxUA=;
	b=lg1kFTgu1vRXZAwAtjjDC1567okRRUBZh6GDABxh4U75g/Z6YgJjzomH4FkJo2gCZyTT
	 XSA4qsi+1NQ8lCpHohaXIIFRjvCJ9lIjej+/cxcOjALzmLAUmoe/Liv19vMq1wXc6hfi8
	 +J37PWkPQTKFPamPJcfweSpNXU5OLxTpp1uA7Kg9hZoxTvRDxqG5+l70kvB31bKalIDi0
	 sqS5y9/MxJUchPCuCighycgn1vcy8dISaS4DpKbUS1OF4lQqaGcW2nCU7obGjW0oJZkQ3
	 KjJkhz8mV22OoHpGP2dguNhx9z6pgYDfJ4gPNe8T+Osl9Y9BPAUi6nXMR1ofjd1prug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=mfrjj8nj;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDA9606A330;
	Fri, 27 Nov 2026 12:29:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBDA9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=mfrjj8nj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=MEOdGE5ymQEKYdPhnwDCZq3BfbxiVieYiwN2ZS/lxUA=; b=mfrjj8njc2LG3cqhG3yngYkm7M
	v6mGAgz56H575y0RpuHRzzvKo76f926cdhP+X1kyro5imDDd0grkVlhLlhWweCIYwy3k4xVoOFJvj
	tLcDopBdGbJDEw4fI5Ei3zLgIr/mf+9GEiG123f7DA3hqBWSLtWvFzdebwos18f+rGeKW0VFKr7cG
	X/YZKep1cn3J9luPXPaO8qcJGSUGhEhoxP2Fv+uVK7PscORhoUBvmaV/CpoTWdPCMHhGycdaN3uLA
	NGjbJ1vDuxxipL+zZSB/LtA/MRgF2Em98iQDMWGpNkJv/YmEuxjgVil97sWhGnyYK/yTX0lhcv20h
	YKHLHToNhxFGVoexv95qo18mLBSYbx5Fqxs8FfVMygpFEy9oxPUGRk/3o98J4bicHAHkVMUdZV/fk
	685oBiWLIoN4vzA9P4ML7vngQKFBHSJT7gTMXhYmQQn08G2SpPGtiPt0S016du1vsMCUQmWyAb8kQ
	aiZ8NesKo8o4TiIUmGejqQjp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv57-00000001Lao-33Q4;
	Fri, 27 Nov 2026 12:29:37 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 03/10] smb: smbdirect: handle errors from smbdirect_iter_to_sgt()
Date: Fri, 27 Nov 2026 13:29:00 +0100
Message-ID: <74b40b1d44931122386bd5419bfaa59973cc6521.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
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
index 20620fb043bd..fa2f7c19e7ee 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -317,7 +317,13 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
 		"num_pages=%u count=%zu depth=%u\n",
 		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
-	smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
+	ret = smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
+	if (ret < 0) {
+		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
+			"ib_dma_map_sg num_pages=%u dir=%x ret=%d (%1pe)\n",
+			num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
+		goto dma_map_error;
+	}
 
 	num_mapped = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 	if (!num_mapped) {
-- 
2.43.0

