Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA70D34E754;
	Fri, 13 Feb 2026 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990576; cv=none; b=kX5jK24I8PTQSYc7P32gPRuKj4ljSXbFCqBehxxgAMuJ6dIgPScWqMjj/A2FAT0Wu8hDhNRzd5ipxFa+Z8PaKXSKxf/9eFQRPaEjxtsu10Dw6f+/TaVyVOLSo8s8gUkbXoWzImlcD/yUFtRbKXyRHuSURbjrjeT7Hq5l/phbsD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990576; c=relaxed/simple;
	bh=xK1WyuV0kXbo2Wz5O1IE+z2T33gp5S3e7AXimgJarT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOXW32l9T4UfwWVVNvdw71XIXUcSqgRws/QwAfdCXdqjiPQAGZAiXHtRK07loPeNLNhFHY1wQraSqsQN85o/1hbCH7E9M7HSomNnN7nYi/nxj7v2rTlgutvZ7KEVR3/VMIGA5fvt0jvE9MWgPLiMB+pLhdn3ZB7FUzcrU8KK7JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy4CzRJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy4CzRJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD180C116C6;
	Fri, 13 Feb 2026 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990576;
	bh=xK1WyuV0kXbo2Wz5O1IE+z2T33gp5S3e7AXimgJarT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sy4CzRJX8HNwPHWCwALdpNltP9MiHMeTj5afGW5vEgYPEnioKWTVjP8DSgoFjW9aP
	 luaDw+bhjXigOWybW9wElhsPwf2v9JVLnKxI1DAdA/zt+vvMOQzSxEWp9jMfhI7guh
	 FAwQ7FOA+DGLFZLg3NfF4z3qZK71zWlfP9woZQJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 12/49] smb: server: fix last send credit problem causing disconnects
Date: Fri, 13 Feb 2026 14:47:31 +0100
Message-ID: <20260213134709.176447405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 8cf2bbac6281434065f5f3aeab19c9c08ff755a2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1033,6 +1033,15 @@ static void smb_direct_post_recv_credits
 
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
@@ -1306,6 +1315,7 @@ static int calc_rw_credits(struct smbdir
 
 static int smb_direct_create_header(struct smbdirect_socket *sc,
 				    int size, int remaining_data_length,
+				    int new_credits,
 				    struct smbdirect_send_io **sendmsg_out)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
@@ -1321,7 +1331,7 @@ static int smb_direct_create_header(stru
 	/* Fill in the packet header */
 	packet = (struct smbdirect_data_transfer *)sendmsg->packet;
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
-	packet->credits_granted = cpu_to_le16(manage_credits_prior_sending(sc));
+	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(sc))
@@ -1459,6 +1469,7 @@ static int smb_direct_post_send_data(str
 	int data_length;
 	struct scatterlist sg[SMBDIRECT_SEND_IO_MAX_SGE - 1];
 	struct smbdirect_send_batch _send_ctx;
+	int new_credits;
 
 	if (!send_ctx) {
 		smb_direct_send_ctx_init(&_send_ctx, false, 0);
@@ -1477,12 +1488,29 @@ static int smb_direct_post_send_data(str
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
 


