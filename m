Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7897C2E1758;
	Sun,  1 Mar 2026 01:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329595; cv=none; b=e75UXV2AiEBKhui6YfYGio5FFqlRO0TnFNmzpe0WtPU97PA99yLgj3/tgyfUzBpDV+rFOS9iL5WZXpjik5UD0KE0u+faBuP2ho7Y5aKxv7vWvCioF6a0m/AgVvgieXw1wzfdz2eJIRwsYcWZFz64dZ4JQaDtdy+QhAJNbwR+XEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329595; c=relaxed/simple;
	bh=thQ7okPqeB5cK8UV90sqPiM3L05GMwokWCXXyIVtbOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZBTwt93jX0/SzYJzG1AmVgHGd2lWo4YKLXy8gVEUkE6md9BB2p7gt2vE5ODTpM/EvZv8Dpgq0hlQSKw7+8RRCko1/H50q+KNXH0an0//Ic48+rzNszYTqNza4OG87Wjk71w6t+C7SkZkI8sXcyRbna3vaOCv1O9Wyrwd2BP4+ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frR1ZqIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frR1ZqIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CCAC19424;
	Sun,  1 Mar 2026 01:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329595;
	bh=thQ7okPqeB5cK8UV90sqPiM3L05GMwokWCXXyIVtbOo=;
	h=From:To:Cc:Subject:Date:From;
	b=frR1ZqIiBT3s54hWq1cG6RsU3aJ6YP5alFf1a9LpEcVnTrRzfs1OBjCsUWx7vV2vg
	 9P4darr3d2vjPmCYkvp58t4n/YXKXHnooT5ocOrBzNY7rqiTQpW9MS8iATrMP9/0ey
	 hvF0XFN2MSG8daNjR3Mqy2WTk4Ig3Zbx/TCwjCqmKs9jaJC1zeKtPdFFYxAIazy1wV
	 bdF+qAyzH8barHx6MSg/KfdD9uPRtI1MQwHmXDwBud/e/X77e8ON5r0EZbSntz8WNp
	 0avM0jjtiKJSK7ph6/B5/GQV+jvYofLFeFzCUDhBsHl+Ce5sGVwApMz5jmCgyhqsMA
	 orOJuIZwCp46A==
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
Subject: FAILED: Patch "smb: client: fix last send credit problem causing disconnects" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:46:32 -0500
Message-ID: <20260301014633.1709553-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
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




