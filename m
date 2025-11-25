Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251ED2264D3
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094973; cv=none; b=TIReecJEN0TXEKUmvMODJBJj/R95FCLPzsRbvsP297qvefrhWQYOT48U2cRA+PFFv3KQIQggGI6gEQJQC99upcpxHiMx0uR+O6IGIwOQ5fxRKAghm/U4Z4dyCAqkqDeLFEGarDmSVsF8Sby7/wzFNKailXXURuw1Ym3WTpmzhjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094973; c=relaxed/simple;
	bh=4UZea+uDUDUbOavYSH+aiecmA/GPNq5upVShbMOhqt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqSdvhdaojSLTYR/biWtIR5G3jTW1zoFZSB5mqU8pvcgHZt9U0/1uxuwQt7Lau+dodTPtuK0DpMUhkrH1YIPdq2NJQrig9KUlq//Hbz590igdyEnE2nXrgcxrPVXT65eo2OSgMXPubYC//2ZQAz3hkgCcrQgIrrcVpKYPr8SuS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vtUJb+p0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vtUJb+p0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=023mhDFPiPqCU8XiHj8HA2U66mK6vYusmbyFy+3eZEI=; b=vtUJb+p0HiFLeulABAh/c6zeEO
	fOOUOHMLfITkUw2gN8Eud4d0Z2x814PA1AwpjVh0FC5uemk10Wdo0TYsKL+v9lYgBgQRjqERGazRR
	vqkprnCbgT/WTVKLVVW4aKf6sQ4yd6C5qUj56LNfEI8fn/x05zxQVlZsuU6UuTnBxVFCT3ZhOrxcY
	XeR0UXgm8CSBD5O58G/ZagttaM6XJx+xhKyW3A2ABQvxymeM6umQ0lfjer3My/ERqJr5iq4PrXS9f
	e7ZDe+1LoDSDjxm0hQ9UDEzDSnYeC82BrKMt11lMFgaA1WvgeiLzqRuYFx25CqWmRSEjZ6lOlXp4t
	uFrhyLW8KrDyQWNRhu6GWrteL1eIa6WSs3AvvI0D+lBUYai8TSgjHmO0KLY85fzzMk/emyav1yHC1
	sVXJHKupV+J21HWLvxYUSykEXxiCWM2MDEkMvogA8DuoDSB1FJ+HPXueDQZj7OXVp7ncQLmbrPSGT
	6YATGnzM+cubL72BsbKHBAwk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxgH-00FfSx-2q;
	Tue, 25 Nov 2025 18:22:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 121/145] smb: server: make use of smbdirect_connection_recvmsg()
Date: Tue, 25 Nov 2025 18:56:07 +0100
Message-ID: <973dff4b81047abaa4c1b7fc5a692c8a75ee21a4.1764091285.git.metze@samba.org>
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

This is basically the same logic, it just operates on iov_iter_kvec()
instead of a raw buffer pointer. This allows us to use common
code between client and server.

We keep returning -EINTR instead of -ERESTARTSYS if
wait_event_interruptible() fails. I don't if this is
required, but changing it is a task for another patch.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 128 +++------------------------------
 1 file changed, 11 insertions(+), 117 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 19522fc4af38..5534de7a23ef 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -201,12 +201,6 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct kvec *iov, int niov,
 				     int remaining_data_length);
 
-static inline void
-*smbdirect_recv_io_payload(struct smbdirect_recv_io *recvmsg)
-{
-	return (void *)recvmsg->packet;
-}
-
 static void smb_direct_send_immediate_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -492,121 +486,21 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 			   unsigned int size, int unused)
 {
-	struct smbdirect_recv_io *recvmsg;
-	struct smbdirect_data_transfer *data_transfer;
-	int to_copy, to_read, data_read, offset;
-	u32 data_length, remaining_data_length, data_offset;
-	int rc;
 	struct smb_direct_transport *st = SMBD_TRANS(t);
 	struct smbdirect_socket *sc = &st->socket;
+	struct msghdr msg = { .msg_flags = 0, };
+	struct kvec iov = {
+		.iov_base = buf,
+		.iov_len = size,
+	};
+	int ret;
 
-again:
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		pr_err("disconnected\n");
-		return -ENOTCONN;
-	}
-
-	/*
-	 * No need to hold the reassembly queue lock all the time as we are
-	 * the only one reading from the front of the queue. The transport
-	 * may add more entries to the back of the queue at the same time
-	 */
-	if (sc->recv_io.reassembly.data_length >= size) {
-		int queue_length;
-		int queue_removed = 0;
-		unsigned long flags;
-
-		/*
-		 * Need to make sure reassembly_data_length is read before
-		 * reading reassembly_queue_length and calling
-		 * smbdirect_connection_reassembly_first_recv_io. This call is lock free
-		 * as we never read at the end of the queue which are being
-		 * updated in SOFTIRQ as more data is received
-		 */
-		virt_rmb();
-		queue_length = sc->recv_io.reassembly.queue_length;
-		data_read = 0;
-		to_read = size;
-		offset = sc->recv_io.reassembly.first_entry_offset;
-		while (data_read < size) {
-			recvmsg = smbdirect_connection_reassembly_first_recv_io(sc);
-			data_transfer = smbdirect_recv_io_payload(recvmsg);
-			data_length = le32_to_cpu(data_transfer->data_length);
-			remaining_data_length =
-				le32_to_cpu(data_transfer->remaining_data_length);
-			data_offset = le32_to_cpu(data_transfer->data_offset);
-
-			/*
-			 * The upper layer expects RFC1002 length at the
-			 * beginning of the payload. Return it to indicate
-			 * the total length of the packet. This minimize the
-			 * change to upper layer packet processing logic. This
-			 * will be eventually remove when an intermediate
-			 * transport layer is added
-			 */
-			if (recvmsg->first_segment && size == 4) {
-				unsigned int rfc1002_len =
-					data_length + remaining_data_length;
-				*((__be32 *)buf) = cpu_to_be32(rfc1002_len);
-				data_read = 4;
-				recvmsg->first_segment = false;
-				ksmbd_debug(RDMA,
-					    "returning rfc1002 length %d\n",
-					    rfc1002_len);
-				goto read_rfc1002_done;
-			}
-
-			to_copy = min_t(int, data_length - offset, to_read);
-			memcpy(buf + data_read, (char *)data_transfer + data_offset + offset,
-			       to_copy);
-
-			/* move on to the next buffer? */
-			if (to_copy == data_length - offset) {
-				queue_length--;
-				/*
-				 * No need to lock if we are not at the
-				 * end of the queue
-				 */
-				if (queue_length) {
-					list_del(&recvmsg->list);
-				} else {
-					spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-					list_del(&recvmsg->list);
-					spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-				}
-				queue_removed++;
-				smbdirect_connection_put_recv_io(recvmsg);
-				offset = 0;
-			} else {
-				offset += to_copy;
-			}
-
-			to_read -= to_copy;
-			data_read += to_copy;
-		}
-
-		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-		sc->recv_io.reassembly.data_length -= data_read;
-		sc->recv_io.reassembly.queue_length -= queue_removed;
-		spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-
-		sc->recv_io.reassembly.first_entry_offset = offset;
-		ksmbd_debug(RDMA,
-			    "returning to thread data_read=%d reassembly_data_length=%d first_entry_offset=%d\n",
-			    data_read, sc->recv_io.reassembly.data_length,
-			    sc->recv_io.reassembly.first_entry_offset);
-read_rfc1002_done:
-		return data_read;
-	}
-
-	ksmbd_debug(RDMA, "wait_event on more data\n");
-	rc = wait_event_interruptible(sc->recv_io.reassembly.wait_queue,
-				      sc->recv_io.reassembly.data_length >= size ||
-				       sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc)
-		return -EINTR;
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, size);
 
-	goto again;
+	ret = smbdirect_connection_recvmsg(sc, &msg, 0);
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+	return ret;
 }
 
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
-- 
2.43.0

