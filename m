Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B56126D4C0
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583167; cv=none; b=YkGtdthLeBSHghcMH1s7HFtD86urw28vWyQvecBaQF55YlC8zIRUdEghH2q/MoAkjHBDqa2VsRyqcRQZHtrryH335H7/eb/aRB+xocoVf8hrs2rSumvgWlPptCGo0K470iGIuTtxgCvFDos/1/8oTdTB4eDs5pD5HCJ8ymrnDu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583167; c=relaxed/simple;
	bh=wVE9ultrmxktU25U0ruvhuFegr2iyL1A4R5QOYw0y1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzdNqTJgX6Hu4rYLcojO6A03Pr2x8z5X8G6WyXJn/5kTmk2bfogzHjy5e1Hvg/BjqS4C9i6nwESO9Su00EpufgyRbYVWdJb5xpljmh6LmmE5K42IrN+ktYv+TETKS0/lrPQlkt0jOauBi2Q5fRPspdNOMwRz2yoocPNPmbZfhp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wQN9Wf0k; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wQN9Wf0k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=J8VwAIG8jBZik4M9J45UPYRQfEYGVaXkhKjPtz9bqAY=; b=wQN9Wf0kXBKLPyfwYWuNfLXvwu
	AsGfv3z3E/RRuy7VUy/6qxkuqiAwvoCHoJm5hcpszQOb9UbYqFzScYlL0uLWLcAsTHvkF2cHCGN5t
	H3tEBApE5O5MsvnDVfFpN3Pvi6fBS0mOC8yYvCnxM7EajqwiZ1vpZeiOadFH2Y+KUm+4NL5MFaBkt
	0ffqScSB/nWaSlEkBrVXcenzQWnP73udUP3cB/A1Ou4RTxaaoXjMecm3Vb0exWSOuE5M90SfxnRN8
	ilhzVF58zyJLjdSp7RzCwLQ75ejw4pScwx8loLgsC/ejt+fJl78YG32P06ew8SJztamrCAxjz3YiK
	53lq0PKGQ9LmyknkHlMNe7MiYoGK0oQO+yv/h1MsZB1zGhVjVgJIHq//lGYcfzsA+IJ9+IKMW2TCE
	U5bLaFENUlaIB3cE/tPutRZVr9OmN+6dfcAgBJC0hW5dqVF+WV5tpArnuaENDqpzppoOYvZlnfrac
	vS0C8yxLz7DuC6eK9SQUaWAP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3ER-001cZc-0T;
	Thu, 07 Aug 2025 16:12:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 3/9] smb: client: don't call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection
Date: Thu,  7 Aug 2025 18:12:13 +0200
Message-ID: <34eb89b5573045e9c5424dc13f223d3d79cf257b.1754582143.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754582143.git.metze@samba.org>
References: <cover.1754582143.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is already called long before we may hit this cleanup code path.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 8ed4ab6f1d3a..c819cc6dcc4f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1716,7 +1716,6 @@ static struct smbd_connection *_smbd_get_connection(
 	cancel_delayed_work_sync(&info->idle_timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-	init_waitqueue_head(&info->conn_wait);
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(info->conn_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-- 
2.43.0

