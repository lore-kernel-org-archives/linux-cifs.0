Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619BD32571D;
	Wed, 21 Jan 2026 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025087; cv=none; b=YCdy8Plf1YLTUWRwJ5YqaVIa1XrQwjNHPEmDhI2fPBhvnZPk58lymoE+yoPIHn2bDZc+qc1W+AzCkfLVgtzP1vkdUajoFN41EXTlYsIymcPIjJau1FbtL/NjWRoE9apaEwZVJOjKF5fsvlGTejPtUtDr0wp2GLwHj1OT7w9rUGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025087; c=relaxed/simple;
	bh=yVr5tE6vpDyZzt3ZpXnvK0X3p6bNyO/kg4KqZyc7pOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8GRHP8DdxD4CTnsJ5OMpSLSGP+uNV9UPWsAKSXyFseFheYQUIf2EauFmcs7Ag1NkTY1ZYRe8YlEnkAugR7icwYW82oVrI1QT3imL37qOs80S85HBucs8uhfqzf7/2xsi0vKH0CuNRX9YmuGrW3kodgVf7zXNmQQIOG/rCfycG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vDHA1gyA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vDHA1gyA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pOnuLA0SV88nfSgQxoMuY2denMGjiSAk4ToJf7Xw4X4=; b=vDHA1gyALS9AITk2O/wJLxxyPc
	m0bDFLwnEf8gR5/E4L7sabyhiT1yzgIisilm8tCthhCyt+MhnbKVs5JdX0U90K9i6sPZPaVkxT639
	wMBs2k9lznhr5dHzkhIvR25Ay1g3/L0TlL4JhrU8axfHuYGl4kf5ubRt93ZZCLwviZt/iy6Ro/YpL
	n7Hys7QFZELYvDXlLxKClD3VfFwxfpNpVBM9kc8ZfS8LetHkJTTuq34MZM792J1BV6kRE5IwXOBpv
	WL6jo1mebBnAhflMcEKFBRR+zQ+0nZYSs8NiaTR8egccAQuFkRs4ms3TVlUCo/XgNaIzhXRWtl6+A
	4XmA6IBzipN+/+yBpOiPopOZztGoSucL8VUrVUsHLbChCnLyvonVKs1RU4BcOuGOFI+cnJE0+Mtxt
	Ba+kqCI859eheirJ1rGxkUPAzN/v2yClVFzrsXoARcou8zPQVXJKghQfZa8GUa/h+PHtSms2XxE1n
	9O93q6ZoIHVVRa7P1p0OfOwc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEc-00000001dzb-17JI;
	Wed, 21 Jan 2026 19:51:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 06/19] smb: server: fix last send credit problem causing disconnects
Date: Wed, 21 Jan 2026 20:50:16 +0100
Message-ID: <27b48512bb652a9e1662c9321971f42c88084c4c.1769024269.git.metze@samba.org>
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

When we are about to use the last send credit that was
granted to us by the peer, we need to wait until
we are ourself able to grant at least one credit
to the peer. Otherwise it might not be possible
for the peer to grant more credits.

The following sections in MS-SMBD are related to this:

3.1.5.1 Sending Upper Layer Messages
...
If Connection.SendCredits is 1 and the CreditsGranted field of the
message is 0, stop processing.
...

3.1.5.9 Managing Credits Prior to Sending
...
If Connection.ReceiveCredits is zero, or if Connection.SendCredits is
one and the Connection.SendQueue is not empty, the sender MUST allocate
and post at least one receive of size Connection.MaxReceiveSize and MUST
increment Connection.ReceiveCredits by the number allocated and posted.
If no receives are posted, the processing MUST return a value of zero to
indicate to the caller that no Send message can be currently performed.
...

This problem was found by running this on Windows 2025
against ksmbd with required smb signing:
'frametest.exe -r 4k -t 20 -n 2000' after
'frametest.exe -w 4k -t 20 -n 2000'.

Link: https://lore.kernel.org/linux-cifs/b58fa352-2386-4145-b42e-9b4b1d484e17@samba.org/
Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 84a654715ed5..6c063c05a6ed 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1033,6 +1033,15 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 	atomic_add(credits, &sc->recv_io.credits.available);
 
+	/*
+	 * If the last send credit is waiting for credits
+	 * it can grant we need to wake it up
+	 */
+	if (credits &&
+	    atomic_read(&sc->send_io.bcredits.count) == 0 &&
+	    atomic_read(&sc->send_io.credits.count) == 0)
+		wake_up(&sc->send_io.credits.wait_queue);
+
 	if (credits)
 		queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
@@ -1306,6 +1315,7 @@ static int calc_rw_credits(struct smbdirect_socket *sc,
 
 static int smb_direct_create_header(struct smbdirect_socket *sc,
 				    int size, int remaining_data_length,
+				    int new_credits,
 				    struct smbdirect_send_io **sendmsg_out)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -1321,7 +1331,7 @@ static int smb_direct_create_header(struct smbdirect_socket *sc,
 	/* Fill in the packet header */
 	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
+	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(sc))
@@ -1461,6 +1471,7 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	int data_length;
 	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
 	struct smbdirect_send_batch _send_ctx;
+	int new_credits;
 
 	if (!send_ctx) {
 		smb_direct_send_ctx_init(&_send_ctx, false, 0);
@@ -1479,12 +1490,29 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	if (ret)
 		goto credit_failed;
 
+	new_credits = manage_credits_prior_sending(sc);
+	if (new_credits == 0 &&
+	    atomic_read(&sc->send_io.credits.count) == 0 &&
+	    atomic_read(&sc->recv_io.credits.count) == 0) {
+		queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
+		ret = wait_event_interruptible(sc->send_io.credits.wait_queue,
+					       atomic_read(&sc->send_io.credits.count) >= 1 ||
+					       atomic_read(&sc->recv_io.credits.available) >= 1 ||
+					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
+		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+			ret = -ENOTCONN;
+		if (ret < 0)
+			goto credit_failed;
+
+		new_credits = manage_credits_prior_sending(sc);
+	}
+
 	data_length = 0;
 	for (i = 0; i < niov; i++)
 		data_length += iov[i].iov_len;
 
 	ret = smb_direct_create_header(sc, data_length, remaining_data_length,
-				       &msg);
+				       new_credits, &msg);
 	if (ret)
 		goto header_failed;
 
-- 
2.43.0

