Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04132EA481;
	Sun,  1 Mar 2026 01:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330080; cv=none; b=rsXCTEukplScbecDONyQa1tMO20EkMJfdmqYsVexzbj1KGRweEVsoPwGCEuySv11ZDjp+i6fc4A/QxWvURNDAnZWh+MICItsjxRl9Gl2pAfRUzu4nl6iwJhQbVHbbZniIRVRmlOegqpmW3pVNFVrNzFf13RMl/5TVeuXgD7bb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330080; c=relaxed/simple;
	bh=VFglOmiTEa+QXXiq73Agb2yhFaqFGAYyoQF9fTEh/WE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vEI6DdNGU9ab+Mz5t8HSjVuL145HnPe8bv2aFzyg6DF2XtR9j3VMcl/X3hpcqfLeof1HYgSJe6SAMWnNK52kquP+whkFFMgx6CteRyaC+jKMUjCGpJ3WwsFMljjyOZb2QyJr3oC4tS/Kj6Se1KE5KzSmanfCBPfzQtFd1mVHIWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HphO5EA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HphO5EA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965CEC19421;
	Sun,  1 Mar 2026 01:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330080;
	bh=VFglOmiTEa+QXXiq73Agb2yhFaqFGAYyoQF9fTEh/WE=;
	h=From:To:Cc:Subject:Date:From;
	b=HphO5EA2Ye4A6iSGhmdfGo4D9uSLfUe/vLsAsVQ4Bx4ZYlrs4MlxstN8hulaz+vtu
	 n7UhOQY2nXPlC2POGRH+33q5WZrGOwUy0zxlwcjNriflDsw2daIMjk0lN7HA0LPK9L
	 C1ssN0xpUQKPX7LqRUZWNKUXN6drRk+o54qIgAA1HBe0McSwh/UVyqZrgv8sijQiRd
	 fFOeaFpzBXvHaeAva+cwJA+rLuKTUGZeJPy0JxIvlnAY3PvHxc0Ue6f0vGL+QPKC5D
	 02WsySyuTuJ41h/MwogJg0TJrYgrPMqsZfSIe90UlHapcyNjstVz2DUnAzTUjmSb0l
	 FNNOzNSh0zRWQ==
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
Subject: FAILED: Patch "smb: client: fix last send credit problem causing disconnects" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:54:38 -0500
Message-ID: <20260301015438.1721677-1-sashal@kernel.org>
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

The patch below does not apply to the 5.15-stable tree.
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




