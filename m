Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2811632C8
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155937; cv=none; b=krXvYxraafHGDTDxLCqc+PIdDfyTzk+Do9SYNpsUBSv2lDP2NpGR5Pdu/s0wWdaynfBGLenqWWh6HTjEnwCyo5BcZYR7HdNQp78FAYcsS7Bnz1NntY4b3xMXl2K6HtPFjY3AZwoe9//GFfl3hmDUbfZC6qdBWUO8kWjoTP23izU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155937; c=relaxed/simple;
	bh=7ycdkJN8ycRthqAwAJH1/Hw8ywSAn2oB0XTCu3GSXLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qr6vl97iiLViycBjvK1Ku5/pYxc84kdjYkl6Z8JaDps5sFKAr/eo+6CZnGxvfoZxYoD7Y2KY9KmeWaYIVn9yzkfR+FimSGiCFqUHbqZporDEixp5ZQ3kXIYYMXP4sGH8EmU48GAkNPGMJGOnL0+QD10gPjSk/zciuY5FHSYUHSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3NHzoU9a; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3NHzoU9a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Ut6di6MFo5IDvTnkz6YBqcemuEB2OUyUmvKFElUDjs0=; b=3NHzoU9asuzPzGuSS/CNhoujVP
	7Q8PiFfID4b8NhsuRc992rK7fAikA7bNU00fCWEdUPh9DITO4m3qCytdbWoXGyjBrwuggSw5dW8QG
	cvR2KnUgYe9YJnYrMMaAHrNQZuD7CUbGUQaiZ9NAccUY/EJ8TcevKkesk/1ssH/eBNNjloKKnMYbS
	BrNd9S4WGGWxIYILRB0Er8Y5ql+I28MSBeasyZPqY/+ROyore+eIxYG/c0nIs+MySZ5TbQ7xTy0vH
	/+lCgJTVvIPg1xnCPefBqdebiXfWMaFZmlJDziVSeqqtdF1iDuQflC6eBbhWDF5OXN+b4rbUIjHoP
	SRACEgPaQf90c5nx+Ap0ySCeb86DRijKLBrrgIAs2vSPqgiKRd+jyMBRtzXMBvyJxfDUW0QTvnFBx
	TpPhAgjGsUDEGZDMaUc68mpJY1RZGSbamzpbdgoYsFUCmeRQ8uulNlHM8VbIrny4wjAm+/DA6OHU+
	ZTEv/mB8wbGuzTb5RGzNjLnF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeNe-000nvL-2L;
	Mon, 25 Aug 2025 21:05:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 142/142] smb: server: pass struct smbdirect_socket to smb_direct_send_negotiate_response()
Date: Mon, 25 Aug 2025 22:41:43 +0200
Message-ID: <5cab3ab295f9916279d3b3308b8c832a61c4cbc1.1756139608.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4c9d33ee67b5..6e4c2bf7dd93 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1562,10 +1562,9 @@ static void smb_direct_qpair_handler(struct ib_event *event, void *context)
 	}
 }
 
-static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
+static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 					      int failed)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct smbdirect_send_io *sendmsg;
 	struct smbdirect_negotiate_resp *resp;
@@ -2001,7 +2000,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	sc->recv_io.credits.target = min_t(u16, sc->recv_io.credits.target, sp->recv_credit_max);
 	sc->recv_io.credits.target = max_t(u16, sc->recv_io.credits.target, 1);
 
-	ret = smb_direct_send_negotiate_response(st, ret);
+	ret = smb_direct_send_negotiate_response(sc, ret);
 out:
 	spin_lock_irq(&sc->recv_io.reassembly.lock);
 	sc->recv_io.reassembly.queue_length--;
-- 
2.43.0

