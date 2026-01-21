Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0093939D3;
	Wed, 21 Jan 2026 19:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025065; cv=none; b=qqrG4F83WYgRMk96LzSe3jSku4jPrx/CevDcle4mrSu/Jgeb9nIQg7BWJBvk37kpoIzFjHIu/lrs6pKywf8GaFBWdfUWo8lO7IRsQxEs5mFmVpaRBQVnWm1H+4gfwIVuLxbbI2q8NoeNnRA5sXm6119Zp09IUlw+ZuyssTeq4wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025065; c=relaxed/simple;
	bh=XIdU/MLpEQSiPl/FKKbiiYkdanXe5eqCZvhWxdjTe44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eI0ts5FUoRsPM/iptUvdAs+tQROLjnfZSKuW4C34wl4kVHdCuecGbmatTwDZ/yLhG0dVf3I7xAzI/UpOHC59TgbuhzmgaQWSPGG+J+lvL7bxJav7DVVsY9dcDegIJWNlYmyVAlJsNLL/UwHAdp0bTbfcBxayM1tCGFDZhSAvzi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=czGywiB8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="czGywiB8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=GyjAzlOkShxRerZ/pL9H1G4a3M9K8OvNbg3AksMPpPE=; b=czGywiB8Z4/1QdPKubhS1R22/T
	vAgkmedMU6c54yvSd+Uk2jE5Pnxwk/AqhZTauyHSki15cd7dDOAnZkWa1s8UJ+zOIj1mqluhZm8jE
	+trj6aBnIVnVvNUPOTz6krCVJaJa1pW46NtnFOyvhI//921VdMhPt+KPqEROt9JRdtrka5WeBpI0F
	Pp7b60/fiCULIDHBs5QfWBaGBH4NVIDWPQw0yq0kXn/pMoJIzt8OaUie6Xfs0yWbLFbjR3026bdOd
	eo0BSBLAahxh07oBnNo5DQtbq2Dh1WsV1OH3RWiJ4K/0bcCkzLPhEwA3mhR3rTGbmApr2eXx+R/fu
	CXLSh6w2Y32ALKglLuogQK4UJ18WrTz38puQ0rN4d+DXMt1EY7Q00+GKi/DJY7sVBgxxFyGSD0fzb
	xUiPVhxDelLvZeEOZpu5zKoXBJe3S4ZQcZ5R0pEDzIlqvGo3v3YMs4UAnZc6d4zzYhaiRi/xzdotX
	/n5eJDgolybopJFRZeK9OLs7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEG-00000001dyq-1Nv3;
	Wed, 21 Jan 2026 19:51:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 02/19] smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*
Date: Wed, 21 Jan 2026 20:50:12 +0100
Message-ID: <b7a30840f1b912a924b700c3eb01f1e36e88b7ec.1769024269.git.metze@samba.org>
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

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 403a8b2cd30e..95265192bb01 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -162,6 +162,17 @@ struct smbdirect_socket {
 			mempool_t		*pool;
 		} mem;
 
+		/*
+		 * This is a coordination for smbdirect_send_batch.
+		 *
+		 * There's only one possible credit, which means
+		 * only one instance is running at a time.
+		 */
+		struct {
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} bcredits;
+
 		/*
 		 * The local credit state for ib_post_send()
 		 */
@@ -371,6 +382,9 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
+	atomic_set(&sc->send_io.bcredits.count, 0);
+	init_waitqueue_head(&sc->send_io.bcredits.wait_queue);
+
 	atomic_set(&sc->send_io.lcredits.count, 0);
 	init_waitqueue_head(&sc->send_io.lcredits.wait_queue);
 
@@ -485,6 +499,8 @@ struct smbdirect_send_batch {
 	 */
 	bool need_invalidate_rkey;
 	u32 remote_key;
+
+	int credit;
 };
 
 struct smbdirect_recv_io {
-- 
2.43.0

