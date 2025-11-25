Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABF232D0FD
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094221; cv=none; b=MG0uk/JGTyQ8nL4q4OEOoEXeYsQhk7ohB2x1OiL9XemmWkMoA7HAhQpCb0KQzgcYTbe/D8udzOw7CPuCFN+0BZ2H+Ty5iZ1okOsH9a3qDqrdl3b00JzqZsiF7J+S9nDFy4bdVuwkhI4JRQluQrL84+GyYBcLrSRT83NQJYxtC+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094221; c=relaxed/simple;
	bh=5zhVQkJn2SZZkJYb7zXkjlgMSs2viz0HsYON5nkhO8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiP+D+ehuDms9JNoGYkst4PG74KoZVQfuDwiAVBezQNUgcewYe+EJf7Phyya3F3pVBnfoepDXh4LixCQzso226DyGXjUM6EdKHmvc9yE3UNI+Ew0xJFzrcH0dLavH/8+5NNiKMv04M/y13VF14ybhkZ03PjeJLUqHWM0NtOO3jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=v0nqWrRC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="v0nqWrRC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=RDNV0a5XFTF/TmtAxMZm7bpnkNRznb47x1xPep6hcMc=; b=v0nqWrRCHJ3ySZ7YphaO9GqpWf
	hkpki85/ttBZUIKSRl6qKYanNiKppzMezbzW/iCO7H6znrbMf98kONlXlxJmWyGOoYIsp1kbxfp3Q
	bV32nFhZ/iqtBBTzCd+oWtRj+XYMKFarpFPcKimU4YFShy+QVzvhFUfw7jqeYPVxXIf+ba6CAo7Yv
	ymLto8ncRs3a7BHXClsl3GNESwiK6Pn5G/m6+HQqtuyEPntSJYgVsWyOJ1hVltyvYuO48U1KA/CyG
	QVc5tKD3VeXnGdQZExYc769ulWhy/igtt0qmtQNQFSIOxZ92b96rCY41Rnjwk1+omWhNuMT6z7pWe
	3bGOh+xVikWPNk0RHdZrQaaTrdDoYtGAf4AlelCZXFUXH8/FG5673tBvj5ELjlWleop28YIXxfPpZ
	9jvFnbPI5WfhnO8E3l2V4h8mtpDC6NhX4OG6NNlPf4xG3S8jD13H+6VZRBQpUQiOJ/XOUVm0rMfDr
	NXRh3Ucfzl8EP/Ev6Q5DmvEg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxRz-00Fe08-0K;
	Tue, 25 Nov 2025 18:07:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 086/145] smb: client: make use of smbdirect_connection_request_keep_alive()
Date: Tue, 25 Nov 2025 18:55:32 +0100
Message-ID: <67e25b892afe4b22634e42cb6bef9d432dddbd7d.1764091285.git.metze@samba.org>
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

This will help to share more common code soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 5695ba579ea5..42f85dd42e7b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -731,32 +731,6 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	return rc;
 }
 
-/*
- * Check if we need to send a KEEP_ALIVE message
- * The idle connection timer triggers a KEEP_ALIVE message when expires
- * SMBDIRECT_FLAG_RESPONSE_REQUESTED is set in the message flag to have peer send
- * back a response.
- * return value:
- * 1 if SMBDIRECT_FLAG_RESPONSE_REQUESTED needs to be set
- * 0: otherwise
- */
-static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-
-	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
-		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
-		/*
-		 * Now use the keepalive timeout (instead of keepalive interval)
-		 * in order to wait for a response
-		 */
-		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
-				 msecs_to_jiffies(sp->keepalive_timeout_msec));
-		return 1;
-	}
-	return 0;
-}
-
 /* Post the send request */
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
@@ -899,7 +873,7 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-	if (manage_keep_alive_before_sending(sc))
+	if (smbdirect_connection_request_keep_alive(sc))
 		packet->flags |= cpu_to_le16(SMBDIRECT_FLAG_RESPONSE_REQUESTED);
 
 	packet->reserved = 0;
-- 
2.43.0

