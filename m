Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0715E28504D
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155461; cv=none; b=FnehcUmF+sj7Rj4VvcfS5gde+IGqXUwndI3DoNwfi4UOHsZU6dVRu5B/WGom04XFu0OLcdpbr276B+m5vFet13aYwgPULE0jetUHfhTz2Oms01lUM4YfZZqiM4yXKlwG+AN4il1/g6twKP/WRaq/+H02nMJIeGxNzXfx0MC8lJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155461; c=relaxed/simple;
	bh=dsNe3XFxgrMa9OxomwKtyUpAYHelSsCxw+oWEAiiA+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzABPcBXiTMD7EfyVabG/nl1sHM7HT1LpL5BeUVHwQdGJ7CETezMnqe+G3fEIybMpGlrk5trxwnt3nnUMLEItlLcY8bdqsW2PI1o+yjwDE9zeIuJPmrg81jcCf4e9XzyV3K9MRt64PPD/ycRG/bnZygXaNyfmxZ9HJzmaosxoXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=R8VQ7PLg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="R8VQ7PLg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=WOK7z6VcMh0Q6V3Wcyr0oxJOvqrXge65v8FPbcuga2s=; b=R8VQ7PLgaGeNC2VCLgcTt+UCZ6
	e87LmmNHVIGMk2lEOpSy84noEYdbcsDnU8AVy8lqSAtmgYfpzCZQrDCS7ctnahoijqrJ41j032CG7
	Pp/sLQ0PqkjoUE/8M8RtgcU0RnjfHjk+3scbtw+VqiIdP8OIaJhYj2ZvGfK37wkIGT0EZwOiJfUFT
	gWn15Un5W/MYIy7CZWUAFn27h8QoFA/KoIQ9iYsk2PdDV8J1U4XXkgW/aAdSCGABK6Wl5oaVTZtnI
	AsYwZ3ekvY8ozon1CmVsGPe1HwGSGKX1lslEXNq/UPWtJ7bqMpPCDBnOmINShRZbkeWSVLJAzzVwz
	D7Ir7FgK0FGreCzBD92/jSxrLlIniOJf2QnL12gSBYfln34erV69rOSOsQR7qMthKk36VGn9kc6gU
	wh4CeVV6EeUMVdO6KxHwtpnmaLTcOeBMXe3w5lDQDeGkVyXXid8LYRSZdCA7Lfget9yP0b6dFtpY/
	3btoHdwiJwLb7xMHx0c9TL+9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeG1-000mNZ-0v;
	Mon, 25 Aug 2025 20:57:37 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 095/142] smb: server: don't wait for info->send_pending == 0 on error
Date: Mon, 25 Aug 2025 22:40:56 +0200
Message-ID: <f786b32c48c2296ada72f3e49394d9f965f44f36.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead we just wake up the waiters and let them return -ENOTCONN.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 741b5b62b7d6..d5b01748f0c4 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -388,10 +388,7 @@ static void free_transport(struct smb_direct_transport *t)
 	}
 
 	wake_up_all(&t->wait_send_credits);
-
-	ksmbd_debug(RDMA, "wait for all send posted to IB to finish\n");
-	wait_event(t->wait_send_pending,
-		   atomic_read(&t->send_pending) == 0);
+	wake_up_all(&t->wait_send_pending);
 
 	disable_work_sync(&t->post_recv_credits_work);
 	disable_work_sync(&t->send_immediate_work);
@@ -1291,7 +1288,11 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	 */
 
 	wait_event(st->wait_send_pending,
-		   atomic_read(&st->send_pending) == 0);
+		   atomic_read(&st->send_pending) == 0 ||
+		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED && ret == 0)
+		ret = -ENOTCONN;
+
 	return ret;
 }
 
@@ -1624,7 +1625,11 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
 	}
 
 	wait_event(t->wait_send_pending,
-		   atomic_read(&t->send_pending) == 0);
+		   atomic_read(&t->send_pending) == 0 ||
+		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return -ENOTCONN;
+
 	return 0;
 }
 
-- 
2.43.0

