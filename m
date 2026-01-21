Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBDC35C19D
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025123; cv=none; b=WO1epAN93G88EKkFfXKlIGgn8E2+HDZmuaqvT04LzB+5HzpJeXhxrLk0jJoyu5G5zR1mUcP5t4rgiamNW11w9DgacUSTWiw97gUA0mXTnRopmoHXL7qrNmF0D6NVIdTu3Ezy+NRbeeQJsevlRQN+fuK4N/HvV2SBodbOysvuMek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025123; c=relaxed/simple;
	bh=TwDm8zf5cNi8tjLnLGFIuuRZgeT2BaFSjct1LdQDxOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbWq8hg8vSmmpRkRQSTIi2rGV4as6qVPrQEBb71P6s0DyW3QVX2zb3KradgDiLVL7QpGjmPljIvJyAQawvhj8lBWJrTNnvy1kXRmQYUOZYBS+fH5MH+1FUh6xIdU4rpcoaLGpenZkw5XZwnS1NTIZKs3gwumyp0ZgxUrghzWUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=u1YMPQhw; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="u1YMPQhw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=l75hGhwncXPIFtWKdF5wGMziiQKQvnlQotdLgULWRIA=; b=u1YMPQhwvtVyMgwe6/zBJW5GZO
	qBL6syAYxMhP77pqgpXoNB+7ctHUh76gsEYA0BOs19tKiv2XQGZ09+VXPaZOWzIjSe5s8cs35FXYS
	GlGi0An0qv0vpii5duX98dAa1PIACKNW0eGWnI1UxG4cD8nxRE0XGtypifAP003jbWcnR49gCjAlU
	wZRh5zOk1NugddXe6F3cSNVmiJ/RqDPGa7w9hQIzasicp6IUYeRs6U+zvJJ16v2HSh3cnA4rx7vif
	OihHAP8kz0dWY2IKzOkrVfM+1qyjFRkvSb9VRRZy6tbpOH7Aojca3qd9eCP4sAcw5tSGNYazGwqb7
	pNp0PIkEnNh0sxMIB9S/uPtwp1CNAig7iBMMCfdTdGT2ZJ/WC74/fD7INhpZnROCQPKGsjpHqA1KY
	tPOpL/v6pQwDGPz/ss2+x36UkIDA0XPzZUVAkHIvL4re5H7PaOsgaTbo6aucCTBqWtAo+IF/gXvCN
	tEVGmr+XMsHZ81qz7JsBm+Lg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieFC-00000001e7h-0REL;
	Wed, 21 Jan 2026 19:51:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 12/19] smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()
Date: Wed, 21 Jan 2026 20:50:22 +0100
Message-ID: <738e733ed6eb0add3531bddd15c67e03f84dd26e.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we reach this the connection is already broken as
smbd_post_send() already called
smbd_disconnect_rdma_connection().

This will also simplify further changes.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 4677e82631a9..7fa0da092f13 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1275,11 +1275,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	if (!rc)
 		return 0;
 
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
-
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)
-- 
2.43.0

