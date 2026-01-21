Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADE133EAF3;
	Wed, 21 Jan 2026 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025157; cv=none; b=j5hTV1anhqT+k7XoIk3/qR902qw4WIFlTohOoD/I+mxnymnW3y0wwNAFMFKajMnoYunUehBWHsAVwETHHPDxq/aGfisjl2XGuAcvusOJ2IqRCD3aKYyet/9JWhAwIVRKbxYuLi5BgebaI5WM3f74w9gLlbu5UGZcKKuDvxgSUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025157; c=relaxed/simple;
	bh=oPxLE4ZTbAqjvEPaxMdzQSN/MbULFRhJRfJcaatxKVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abKdfgPqdBk8ZBoHRmMV8rZjynLqOMFjKkHzo2BTZ3dN8H/ZT58G/Y/B1POXeMH7FPh2EzN3c0IqMYrtW7GiQEPlFCsJfavOzeo3OZPKkK/LrSEFP/XjgE5Z+V6E3aJGYUZYSe2tywextelMPDPg/dasY9IywPb9i1z7lapSdcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XdKgBkUr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XdKgBkUr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Jes5tTh+CBdWCVH/j/lsabM6CsiLreAc+W201oiX0Cs=; b=XdKgBkUrcFKiEXnMkXlvbJDHa2
	khANXyFjt3W2KdFA7jWAo+/DMrjZ8dg+eGbCe0sl1aTew+Npe0Ce6AolMHWKd5Jw5aI2ecUAtzmCg
	KseTydB6ltPf9q6b63CVq2DYhaLIuVeietyL0/8rKimuruD7vxOjZzxAjV/qwxGgmDc3MplT5Lwu0
	AtyQpZkZORHq0WVyRRKyjHy5HNo5hJa1CnF1bg4Ylqs/iYsXLJSHcYbNx99HKuJacTPuk3lzz3lcV
	MLxcoVr26W3cTgny0vRIpbiifw2MHu6I8zB8hJa/0GtTEPTcAxLKJMP2wRRRrE7JtOcJCNB9bOhh+
	rnMPnTmjFJDVDrYPk16MixnhgZkFjONYfZFIRzZIjaSKxiL4yvUR98EZ9L2/Ktm4TCVqiEFgd2P57
	RvjdMu4c83zZ3mq/tayzeagnNhBqLCWC4B+FnLJ3HVFqgIxd3VAf4GJWawAIRD4AoUGrwaa/0Safr
	JICjWYzp0LOT9B4gdb3CEJaD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieFj-00000001eCy-33B3;
	Wed, 21 Jan 2026 19:52:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 18/19] smb: client: fix last send credit problem causing disconnects
Date: Wed, 21 Jan 2026 20:50:28 +0100
Message-ID: <b0c19df47a46b9a44cb5db9f1243fc331c1f897f.1769024269.git.metze@samba.org>
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

This is a similar logic as we have in the server.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 964ee9daa714..f179e0addb6c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -697,6 +697,15 @@ static void smbd_post_send_credits(struct work_struct *work)
 
 	atomic_add(posted, &sc->recv_io.credits.available);
 
+	/*
+	 * If the last send credit is waiting for credits
+	 * it can grant we need to wake it up
+	 */
+	if (posted &&
+	    atomic_read(&sc->send_io.bcredits.count) == 0 &&
+	    atomic_read(&sc->send_io.credits.count) == 0)
+		wake_up(&sc->send_io.credits.wait_queue);
+
 	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
 	if (atomic_read(&sc->recv_io.credits.count) <
 		sc->recv_io.credits.target - 1) {
@@ -1394,6 +1403,27 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		goto err_wait_credit;
 	}
 
+	new_credits = manage_credits_prior_sending(sc);
+	if (new_credits == 0 &&
+	    atomic_read(&sc->send_io.credits.count) == 0 &&
+	    atomic_read(&sc->recv_io.credits.count) == 0) {
+		queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
+		rc = wait_event_interruptible(sc->send_io.credits.wait_queue,
+					      atomic_read(&sc->send_io.credits.count) >= 1 ||
+					      atomic_read(&sc->recv_io.credits.available) >= 1 ||
+					      sc->status != SMBDIRECT_SOCKET_CONNECTED);
+		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+			rc = -ENOTCONN;
+		if (rc < 0) {
+			log_outgoing(ERR, "disconnected not sending on last credit\n");
+			rc = -EAGAIN;
+			goto err_wait_credit;
+		}
+
+		new_credits = manage_credits_prior_sending(sc);
+	}
+	atomic_add(new_credits, &sc->recv_io.credits.count);
+
 	request = smbd_alloc_send_io(sc);
 	if (IS_ERR(request)) {
 		rc = PTR_ERR(request);
@@ -1449,8 +1479,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	/* Fill in the packet header */
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
-	new_credits = manage_credits_prior_sending(sc);
-	atomic_add(new_credits, &sc->recv_io.credits.count);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-- 
2.43.0

