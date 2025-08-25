Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BDA2AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154882; cv=none; b=s9GOjLLwx1m8J7iKdVCRw2DuDvb/EjhaxEvNc9yqoVp0S8InZhM52JsUNmJ7A0fekZUcH+85SIXgUVdLea8/vYQpU+S6vzHatVsvw4bVJ/0rLBB51wnMqM/8pkm4w86LD5pHRB9V8k+nAukl4JozUJaqkb/j4drfXyMEP5Adl5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154882; c=relaxed/simple;
	bh=Fe/GwxT1373oGCfBV5plKqLZrzjXLTaPxSxaRhmeB1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlTDfEJLzWkBWrHoF9LpVWx7Fz4+5b6SiXz5ZQSoAXFTApbuMjoiNbt/absLcOSa3wQDKOh7nKy7CAJldVtvvUxB7upaflCEhoFFisMe7o7bG3eGyB+XYZ/UF1p7fqlVkQ0Ob73xaUjY4FZRCPHeBxp8xyh5sthFyOkovpM++kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0WmtbKOm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0WmtbKOm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9rGhBGFl6MV0NKSal2DirvvnNmsMvaZX4oYElfRRTPY=; b=0WmtbKOmXQkYX0Io13aaI4yl9d
	hwVtrDRlL8yn/3FzMJH3jY0NySqdgUyvCW6Kk/roBxPZIzpfRc1PX289nqyI99HDfHuemrVKf+hIB
	kf8eeULMHUjxdGxsSuqdVkHevMI5vB7pciWkirAoSV56e7zO34X1dNuAApKpVS/8Ha3/6VguxXSSz
	krB0rHJ3ulkM1HktfY3jnku6bp5TN/YWgyOCUaQRx/ziDemfwg3UZ5a+A5ra/gs40f+p5lmnldqDX
	rawHPvgND7zDJVjbSIWOOjlhoZn5b2t6wTUtusIMzrzUBiiMLJ3/t+tqd+UPkMBaOmqmlZwglXg31
	I5eQakh2m2adFQv5vJ5Wlc+6lV7qyCG0OCZNWFOG1vT2S4/Q+jHUIIDyoSPkm/+MXHT8TQGqY4IhA
	sLDjXYmrxLn/KC14dGxirOyNXzzQUrfjhVPzLQXHoO2zGMWu3lGZP7n1j/kYvIB+gGb2SupHfmnhH
	2Qi2G2/pscNWno7SnviemCpq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe6f-000kR7-2F;
	Mon, 25 Aug 2025 20:47:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 037/142] smb: client: remove useless smbd_connection.send_immediate
Date: Mon, 25 Aug 2025 22:39:58 +0200
Message-ID: <2bdf4791685e76cd47402e7c87fd27337764f2dc.1756139607.git.metze@samba.org>
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

We always set it to true before having an if statement that checks it is
true...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 10 ++--------
 fs/smb/client/smbdirect.h |  2 --
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 62c0d27ec8bc..a65c3a841985 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -536,14 +536,10 @@ static void smbd_post_send_credits(struct work_struct *work)
 	}
 
 	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
-	info->send_immediate = true;
 	if (atomic_read(&sc->recv_io.credits.count) <
 		sc->recv_io.credits.target - 1) {
-		if (info->keep_alive_requested == KEEP_ALIVE_PENDING ||
-		    info->send_immediate) {
-			log_keep_alive(INFO, "send an empty message\n");
-			smbd_post_send_empty(info);
-		}
+		log_keep_alive(INFO, "send an empty message\n");
+		smbd_post_send_empty(info);
 	}
 }
 
@@ -1080,8 +1076,6 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	atomic_add(new_credits, &sc->recv_io.credits.count);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
-	info->send_immediate = false;
-
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(info))
 		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index a4b368d14f51..3dd7408329f5 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -77,8 +77,6 @@ struct smbd_connection {
 	/* Activity accounting */
 	wait_queue_head_t wait_post_send;
 
-	bool send_immediate;
-
 	struct workqueue_struct *workqueue;
 	struct delayed_work idle_timer_work;
 
-- 
2.43.0

