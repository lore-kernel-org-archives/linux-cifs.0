Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751443A7DF1
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025117; cv=none; b=m/UY/b+aOq1AUp3YDLi3SKCkd5Ao4SIVwG2iHJueq1d+3Kl4/eG539oMDdXDef6Kyrhyb7EWfJYzc345U8OxRlXPGQ+ViDHsNqqBWrQAifc39aHEFKQE50r3Bej/2P0V/dUCQi6LlRxEtwT8GRGHqaWwzIoA6p4knPugfjjqQdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025117; c=relaxed/simple;
	bh=QB6Cw02sISBLJZ+6JZ/rg9+dz3pyaCVnHx4bYtSknFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAUfDblhOiT0RZDsDrJFmD6QdwihW3tfxvV1vhpY2YzHOSdZ3peYogFN6uD5bMI1yXAMF4rPQiUAqQQY+7rKRZq/sjKVeUq2FJ298hfrfm2k7bm6lRnA9LbChiE5WWSwCVCeekSXbhs2Mwf/Ji2yIkacdzYfFfBsnFfe8SJsWg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=peGqLUHo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="peGqLUHo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=FcyW328vx0gI+/8Sm2YtoN0tlaraS5QICHh2MQGBg9o=; b=peGqLUHord40KEI2XTqjKLwD2j
	qJLVVuL2jxsG6D0nOg65zW8rdiH3r89uZKBICaKX6Kf1LsAjmcuWAuDRGjgfAAdo4+BONSFNSxAhB
	3Q683AsH+7N46F2mo4Lihl8cNjVN7IaqjnbuMhnLRXzQIk2xgs0j0pgUpVxD4Cowdeai9gO/ux5Gm
	Q2Bw6zoRaLMLV7Lqb83Hbpojumm7utfFM5yjREOeqCHwKhxOVcF5VJCwnH4lRy1LJM+eJjgNRfRuj
	7nQ0BfcZWI2P/pvOF0rjuVkcgHiZOM8iAoP56iA4PIhAmYrj5CfFI+eTae4JQ118sd0L3Gnnbnh5c
	Y6lWUjOSh0CIoW3Qh/1Uh5PUGrhskerrmQ+Oc6LYtOyETINxsAeFyIUtGiQthjG+1eUKsGcylBdlG
	JksVaO8I7VKayfR36wJRvJwr8tC6iRIYZK99ZHVk9x80yC4AwHYBrJaowc9CDlMQVklK5WvSpfl3m
	WtFKHVPuADq80mcAWlaQFEEC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieF6-00000001e60-2ZgM;
	Wed, 21 Jan 2026 19:51:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 11/19] smb: client: remove pointless sc->recv_io.credits.count rollback
Date: Wed, 21 Jan 2026 20:50:21 +0100
Message-ID: <80c61e4e188e6a3194c9841b56395f10bf8a2e5d.1769024269.git.metze@samba.org>
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

We either reach this code path before we call
new_credits = manage_credits_prior_sending(sc),
which means new_credits is still 0
or the connection is already broken as
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
 fs/smb/client/smbdirect.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index dc1e6656051a..4677e82631a9 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1289,9 +1289,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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

