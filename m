Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D381F30A9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094966; cv=none; b=XjUqmOSGaY7uXRO8z8V3I1x7i+5xOe7agHNsaHOEw6FvBBpKMWO86N17pTLQQB0VdpIpY5Gjz60w9xJ2B0107BUgGMJiWqTI3YVb829hb4bQmFN3iDscnxW+AxFJ6wtmgd1ToEaV1KRa6nIsNA4gKA9RSSVSnyc/QS4+VEZrmu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094966; c=relaxed/simple;
	bh=G13F52Cbp/cXGFOWHh+HdsZkbfK4gv0nDVwNQgnsSS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF9aiW0Y6S2IBwBvb1xJZKbLo5oFsaoupE2NV1ueaoqHyWa9jZRBmiYkMcZC9JAqFjHevIHEBeptAXcWIcejtUU/4sAkyPJH7TSLEk3DNX4/l6mX3vGKZ4HP4VqWwei5KX+6OIUSbIklQkqOXGYAvIkNq2e/DjHsl7Bx0UhL6VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UjdM13XF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UjdM13XF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=cqWnnWhFN0o3syiAo48N69KRxxH+6lXYSpa+6sSDVS8=; b=UjdM13XFf2HXshtBGuqWCUx8Jd
	Xofvw9QYUhGDKzxCex0iIXi43n5iZns9g8k+H3oW0d7fANI1Wh9jjbpYx0kRP4lZze1kvrUOegXtH
	2LAjrysWzuVjnB1pp95MSg6WYRvpyxx4V0ODFnUMca+u/ssS2TwIO9rLbcsSyUs4TjsF7btszAsAK
	scHT9Cuauc+5gNHNSXO37V8124t5WAJ+yCLPyu9ffOcQ/uCFd4TLMyDgdgpXPI2W3lFt6U6Lke31A
	OU8jzTl+i1GdvjRkSaBox0em/5K48+q26a6fJ1mqQCHh7EorcbUUkvSdsvEFdxp0O7J1aa8rALI0P
	5NtAeLVY5otQdpIUa0JmvfBwwow//GgWvRFCyitrR0tN2NcQSBAVab/Pv7uFaYvPq0yoJFeTxVec7
	Q741DzkgFOtVqBNuJJFJMb8XoWOiKtBxUwucyTteWzuWuIvvz0kJnh4lS4Qs03D/L3r3t/IgmP7WJ
	Ol8WiHKJoy4ODs/tyEiSMCXa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxdW-00Ff8O-1E;
	Tue, 25 Nov 2025 18:19:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 117/145] smb: server: make use of smbdirect_get_buf_page_count()
Date: Tue, 25 Nov 2025 18:56:03 +0100
Message-ID: <1d97ed7a4fda95eca8cc4bc14d971f56c259ad1c.1764091285.git.metze@samba.org>
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

This will allow us to move code into common code
between client and server soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 1c509ff2a32a..ca587ed6acce 100644
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
@@ -839,7 +833,7 @@ static int wait_for_rw_credits(struct smbdirect_socket *sc, int credits)
 static int calc_rw_credits(struct smbdirect_socket *sc,
 			   char *buf, unsigned int len)
 {
-	return DIV_ROUND_UP(get_buf_page_count(buf, len),
+	return DIV_ROUND_UP(smbdirect_get_buf_page_count(buf, len),
 			    sc->rw_io.credits.num_pages);
 }
 
@@ -915,7 +909,7 @@ static int get_sg_list(void *buf, int size, struct scatterlist *sg_list, int nen
 	int offset, len;
 	int i = 0;
 
-	if (size <= 0 || nentries < get_buf_page_count(buf, size))
+	if (size <= 0 || nentries < smbdirect_get_buf_page_count(buf, size))
 		return -EINVAL;
 
 	offset = offset_in_page(buf);
@@ -1106,7 +1100,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 			v->iov_len = min_t(size_t,
 					   iov[iov_idx].iov_len - iov_ofs,
 					   possible_bytes);
-			page_count = get_buf_page_count(v->iov_base, v->iov_len);
+			page_count = smbdirect_get_buf_page_count(v->iov_base, v->iov_len);
 			if (page_count > possible_vecs) {
 				/*
 				 * If the number of pages in the buffer
@@ -1135,7 +1129,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 				size_t elen = min_t(size_t, v->iov_len - fplen, epages*PAGE_SIZE);
 
 				v->iov_len = fplen + elen;
-				page_count = get_buf_page_count(v->iov_base, v->iov_len);
+				page_count = smbdirect_get_buf_page_count(v->iov_base, v->iov_len);
 				if (WARN_ON_ONCE(page_count > possible_vecs)) {
 					/*
 					 * Something went wrong in the above
@@ -1300,7 +1294,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 		msg->sgt.sgl = &msg->sg_list[0];
 		ret = sg_alloc_table_chained(&msg->sgt,
-					     get_buf_page_count(desc_buf, desc_buf_len),
+					     smbdirect_get_buf_page_count(desc_buf, desc_buf_len),
 					     msg->sg_list, SG_CHUNK_SIZE);
 		if (ret) {
 			ret = -ENOMEM;
@@ -1314,7 +1308,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 
 		ret = rdma_rw_ctx_init(&msg->rdma_ctx, sc->ib.qp, sc->ib.qp->port,
 				       msg->sgt.sgl,
-				       get_buf_page_count(desc_buf, desc_buf_len),
+				       smbdirect_get_buf_page_count(desc_buf, desc_buf_len),
 				       0,
 				       le64_to_cpu(desc[i].offset),
 				       le32_to_cpu(desc[i].token),
-- 
2.43.0

