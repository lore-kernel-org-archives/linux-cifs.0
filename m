Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E408190664;
	Sun,  1 Mar 2026 02:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330637; cv=none; b=hreS/BCcsd7ksGOjt6v6NF6wDpML/3e2s5ONrz12/iLwEojWZ4QpS9jm29tKEJkQBTYSU2yL5+jOmj83OIDceanrc803qqmwoLdscQVuXIyZerRMB3Wy+n6rZyLzuYzv+59+llMqYwA1icUdpMv6sd6E+qdJR1X2KTFBJT99kSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330637; c=relaxed/simple;
	bh=buzZpUgqkm3rAKGc7BhSMb+Z02sgcVOLSLP3lwaJv1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KiU8s9s4diDn9o5QNbgd+H79bR+9VMkWk6lex6HKFBP/5aIykNLEwbXNPZsY6L2zNKyWntlXWwzNOhMdqnlxuQlAfMUj/q1irg70HGLKUhKOer9GvGUXBjd6tMtZx+o50Z5q1cDDTukPx0mQAcSWk4gle++9QZ+X2NaxSHtMMHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZFFyq1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZFFyq1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20249C19421;
	Sun,  1 Mar 2026 02:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330636;
	bh=buzZpUgqkm3rAKGc7BhSMb+Z02sgcVOLSLP3lwaJv1E=;
	h=From:To:Cc:Subject:Date:From;
	b=XZFFyq1S4xq8htpFGj4pUni1W40gQzIrQA99mWrNQUatrI0+s/fPwNMFVE74+vWs0
	 irKUyPmu4TFOuSHi3HSa2Ab8VnUShGTnpJOJAoq0UmFDxZJqxcMgyT78HmHwzM5v/0
	 l5gu9loZpjRadvWeit7Y0oUH8cxT5gzj/Iwsw+Z+N7uMg3YvGAPC4nSc9LnkFCLMAw
	 Fvhys2isCDH5XvB+Kvl7q+2J+2viUKJ+iSDTh91YdPYT/T2u1nZrGM9NOuEKNmhvvc
	 VRyLwhMxIgC4r9lIy4mEFOOIxjsPD6P+k4aAABrl4UfHm+AupCzO/hFh0Sfsi3CaxH
	 xeQcdBw5mxjcA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: server: fix last send credit problem causing disconnects" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:03:54 -0500
Message-ID: <20260301020355.1732088-1-sashal@kernel.org>
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

From 8cf2bbac6281434065f5f3aeab19c9c08ff755a2 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:46 +0100
Subject: [PATCH] smb: server: fix last send credit problem causing disconnects

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
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 38248b6a1b5ca..5c0cc5064e8c0 100644
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
@@ -1459,6 +1469,7 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	int data_length;
 	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
 	struct smbdirect_send_batch _send_ctx;
+	int new_credits;
 
 	if (!send_ctx) {
 		smb_direct_send_ctx_init(&_send_ctx, false, 0);
@@ -1477,12 +1488,29 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
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
2.51.0




