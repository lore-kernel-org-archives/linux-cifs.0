Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D91C366DDD;
	Thu, 22 Jan 2026 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102303; cv=none; b=F1tk3nWWHzVJayB7lmLTNwHFcHPWuITVA4vv1S33iLZcRM6gQpXzcmbiaG/Fe+7WU7wK0WP1OBv7OgQuBISTbgGf29ULl4e2Eu4MniymBJM67YlaltqxahDeEnc3Vzqh3grwu7pFvLrv6g76SIQxncUyQCkqSM0+wGZQTCYOZLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102303; c=relaxed/simple;
	bh=dyh32F4qSIj8/tFXtuAKUmc5BoNrEmCCOb6DeLFxY0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dne5GFZU7keaHk+18R/BNITbdFU6W3P6o/O1vCmAjTx9JiKsDEW2ykpJnpB8OdFfHrbToPxoKManMf/gz9KzzJRUo0H7iuETPkzs5aPN2H+vUzY2J6VQQLVrkU8WK4PUBh2mzKXtr3j7F73PWzcjVNkCrrJQ2nqko+qKv8DdMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=o/mJIJbu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="o/mJIJbu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=45lBNRP4QE4H+5FeF7oxqRJW4l6lb7WxoEo8UPOSraA=; b=o/mJIJbu8YGBUeCOYVZUpVTUFo
	Yq9wVs70lzceoJOZ66sZWq86hH4bgHLL9cEQigUvOEJBuJ+7eZu70uFFR9ZbB0lmyo2rntEe1y9XV
	ucYpj4IM59FaQbhjJD7qIvYhnrPqZkakVLXXgm3qHXk0oOroRer7NEgZwfwvUwViFu8IOIbfI8YZg
	XUv925LGWB71hleHMOAHM/AGHIxkPVR2hZ05hRgV9+zLu3fNvoIhcql/PjhhQvvN4YQWAVAOXeT+G
	LITBVwg+PDKYlu4W8MpfGyvtkM2nugyVgckqxJEPZski+ILMKpUbioQzV8cOUsHfmofiox3vIjn4f
	7Pjsg6JdCzsF7VE9BWorcUe64gevwUqOzG3wcdIPPL2aK2XzV+goe8xejTJ/lmZPfT8nuEaebx362
	9Y7OuxuH08cF/AoHQogusmlWmhGVakPhbDxAYMBLfQQJmXKjyHVXgpiHOF5lczqfDK8JnhdbO6DG1
	TNZbRl0WamGLM/MgOsxWJRxw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyJx-00000001prv-2JwH;
	Thu, 22 Jan 2026 17:18:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 11/20] smb: client: remove pointless sc->recv_io.credits.count rollback
Date: Thu, 22 Jan 2026 18:16:51 +0100
Message-ID: <a2512fcd5c650cfa7e0778c6719be294238b62b4.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We either reach this code path before we call
new_credits = manage_credits_prior_sending(sc),
which means new_credits is still 0
or the connection is already broken as
smbd_post_send() already called
smbd_disconnect_rdma_connection().

This will also simplify further changes.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index f2ae35a9f047..c9fcd35e0c77 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1288,9 +1288,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 					    DMA_TO_DEVICE);
 	mempool_free(request, sc->send_io.mem.pool);
 
-	/* roll back the granted receive credits */
-	atomic_sub(new_credits, &sc->recv_io.credits.count);
-
 err_alloc:
 	atomic_inc(&sc->send_io.credits.count);
 	wake_up(&sc->send_io.credits.wait_queue);
-- 
2.43.0

