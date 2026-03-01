Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F1D2D838A;
	Sun,  1 Mar 2026 02:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330666; cv=none; b=a5sRRUL4uO5T9vLaWqaXm5psam7XYFOs/VmPiGGM9r7ET3AwTqqPHSIOjq7j3HRCKVqy/qOMnmfruF2+o1gTWgUeIQMDoTDoxuzbshitBtG3kHz06SJ+ZLpbU9iTEzjcuGnD2BAZ03iXp4lB/D3jHhoUXG5iIN14eGb96sFWCP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330666; c=relaxed/simple;
	bh=xGrNdouBxRIwXCWyszYJy1k3Awel0e25um83o0bhHcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RinTNmvtRfEgF5YU88zhKlZguaxo5IX+lyBRCTtOruc12fgaHLUMPXzoiShFgRn3ipKfUH9ZxXhS3U25m1FO/g8vBEh/sU1iNaeXkT6Y5wOQYi6VzKDYUfDSiz4DUV/YPB19PqMwnnssmn/g57vxFr7033ETBCPWdsBnpPqn7a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDFfXRXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDFfXRXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFF4C19421;
	Sun,  1 Mar 2026 02:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330665;
	bh=xGrNdouBxRIwXCWyszYJy1k3Awel0e25um83o0bhHcY=;
	h=From:To:Cc:Subject:Date:From;
	b=ZDFfXRXsNSDdFtg+tdbssMbAfebJjZBRkguFmY3SGzHJgyGw3MLyg1fjSrYUVx1nL
	 DJmr3fDEp9/9mP6ygOKS6u9x6QK1/v+t1aYIcfDg3w4HEUuYyUfy7ZBlyx+whhoIyB
	 TK38n09r5vs8douvYzrBEwvPNyp89SyP5aN2U/0SFAOvNYXxjYOjSjqDxn4LtoL0S4
	 hiUiNUFteZOr1HcSs20YGf6wQNUnF3Gibe7mGYLqqqzqkQFlrlbiFZQXFRq94yyAzH
	 SBMaavJwoJsU+Icrehk5bLjvejXqGhSd/v8hm1T+z/5l92yCwj9r26M/Xx26GKxQg+
	 LIESoWlJCBGTQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: fix last send credit problem causing disconnects" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:04:23 -0500
Message-ID: <20260301020423.1732845-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 93ac432274e1361b4f6cd69e7c5d9b3ac21e13f5 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:58 +0100
Subject: [PATCH] smb: client: fix last send credit problem causing disconnects

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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index dbb2d939bc44d..20faa6d7f514d 100644
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
@@ -1394,6 +1403,26 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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
+
 	request = smbd_alloc_send_io(sc);
 	if (IS_ERR(request)) {
 		rc = PTR_ERR(request);
@@ -1448,8 +1477,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 
 	/* Fill in the packet header */
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-
-	new_credits = manage_credits_prior_sending(sc);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
-- 
2.51.0




