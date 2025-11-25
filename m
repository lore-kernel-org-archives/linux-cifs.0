Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6065A15ECD7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094041; cv=none; b=T1gzTAibAmtco5WBtRRvvSsiutWq+9D/BenBGalfcqI0QpHEPjpLpKzDipUWr8dq9f7xi6AyitFESoVWqydZJI9ON5acx7aJiSS9zbZbr9zjQEnR3zMYkyB3rP5Fh5DQKFdswNcaPDVd4Zr0TzIFribSEMLo8vz7gY/jEVtMEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094041; c=relaxed/simple;
	bh=SxhstkmzGM8LtV7jAHZDE8bKnbE4IrkTlQQrP+6BRFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDruZOLyfga8lXP7RRHtX/PbPq+TuAySN3X9VC9FybUfFDlTIZvmzWAUFYVP2L149JUHTXe3xGYUCtbWt80NtOscOHnc0fuEju7DOTGhXcHLsjJhmz36mwX0JLzy1Op0M4Hfkwl9LhXxrPPAbfdryrewenPbxxKABNcbUJN3SXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=t+Adcp9o; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="t+Adcp9o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uNKr46pB+JZm+4OqIpFYuEdtmoIjS32aJvkVec6ZU+E=; b=t+Adcp9oNjM5c0qdfVn0uL2PQr
	/+5zhOfaG/e5NEQ0wzptRS2wurQb01dwmWCVVZ4IyjaVKMtYIRc7XIVW7OlG26S7Ay65i0Nbc98Oa
	qh3ISD4/AjgE3RIaGVTvl3PUTNnou25/NaAT+XOa9qExwE06Iv5erasSxiokyNGZOfuTHJ33k91p8
	3Vf3/ZiwcWNoycKi0uzCNik1rf1Ag7dEsp+AVBPmaqE6U/dNCAG34fXi5jA1VaT5c88KAchk/od8Y
	GmotEHQFFM0S03rI6hdd1azDWtnVQ/w6FQTw0KFC+MCF0irPatxiCb7Cbpy0y0NFvc/VDLPjnPgol
	QGiGU9br+B6g93i+BJedy16QdC0UIr/3001skXcxckLAg/WMhElS/7rBx5WdbBMay7S88urEMPeB8
	KrDj4MdzNNfwGUQiMjNrB37mYCKoJDI9/npfDJdjXN+/VZDUfV74qez9MPYtDvQ/k8StKVwd1tRCX
	UmMmt0ecbsJVlWYFihIvWAsf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxOT-00FdeX-0F;
	Tue, 25 Nov 2025 18:04:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 068/145] smb: client: make use of smbdirect_connection_reassembly_{append,first}_recv_io()
Date: Tue, 25 Nov 2025 18:55:14 +0100
Message-ID: <4732f090a73e0ede18e2a56748604a426a19866f.1764091285.git.metze@samba.org>
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

These are exact copies of enqueue_reassembly() and _get_first_reassembly().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 63 +++------------------------------------
 1 file changed, 4 insertions(+), 59 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 21d08171cc85..39d94bea2bbe 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -26,12 +26,6 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf);
 static void destroy_receive_buffers(struct smbdirect_socket *sc);
 
-static void enqueue_reassembly(
-		struct smbdirect_socket *sc,
-		struct smbdirect_recv_io *response, int data_length);
-static struct smbdirect_recv_io *_get_first_reassembly(
-		struct smbdirect_socket *sc);
-
 static int smbd_post_recv(
 		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response);
@@ -682,7 +676,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
-			enqueue_reassembly(sc, response, data_length);
+			smbdirect_connection_reassembly_append_recv_io(sc, response, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
 			smbdirect_connection_put_recv_io(response);
@@ -1296,55 +1290,6 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 	return rc;
 }
 
-/*
- * Implement Connection.FragmentReassemblyBuffer defined in [MS-SMBD] 3.1.1.1
- * This is a queue for reassembling upper layer payload and present to upper
- * layer. All the inncoming payload go to the reassembly queue, regardless of
- * if reassembly is required. The uuper layer code reads from the queue for all
- * incoming payloads.
- * Put a received packet to the reassembly queue
- * response: the packet received
- * data_length: the size of payload in this packet
- */
-static void enqueue_reassembly(
-	struct smbdirect_socket *sc,
-	struct smbdirect_recv_io *response,
-	int data_length)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-	list_add_tail(&response->list, &sc->recv_io.reassembly.list);
-	sc->recv_io.reassembly.queue_length++;
-	/*
-	 * Make sure reassembly_data_length is updated after list and
-	 * reassembly_queue_length are updated. On the dequeue side
-	 * reassembly_data_length is checked without a lock to determine
-	 * if reassembly_queue_length and list is up to date
-	 */
-	virt_wmb();
-	sc->recv_io.reassembly.data_length += data_length;
-	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
-	sc->statistics.enqueue_reassembly_queue++;
-}
-
-/*
- * Get the first entry at the front of reassembly queue
- * Caller is responsible for locking
- * return value: the first entry if any, NULL if queue is empty
- */
-static struct smbdirect_recv_io *_get_first_reassembly(struct smbdirect_socket *sc)
-{
-	struct smbdirect_recv_io *ret = NULL;
-
-	if (!list_empty(&sc->recv_io.reassembly.list)) {
-		ret = list_first_entry(
-			&sc->recv_io.reassembly.list,
-			struct smbdirect_recv_io, list);
-	}
-	return ret;
-}
-
 /* Preallocate all receive buffer on transport establishment */
 static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf)
 {
@@ -1482,7 +1427,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "drain the reassembly queue\n");
 	do {
 		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-		response = _get_first_reassembly(sc);
+		response = smbdirect_connection_reassembly_first_recv_io(sc);
 		if (response) {
 			list_del(&response->list);
 			spin_unlock_irqrestore(
@@ -1963,7 +1908,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 		/*
 		 * Need to make sure reassembly_data_length is read before
 		 * reading reassembly_queue_length and calling
-		 * _get_first_reassembly. This call is lock free
+		 * smbdirect_connection_reassembly_first_recv_io. This call is lock free
 		 * as we never read at the end of the queue which are being
 		 * updated in SOFTIRQ as more data is received
 		 */
@@ -1973,7 +1918,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 		to_read = size;
 		offset = sc->recv_io.reassembly.first_entry_offset;
 		while (data_read < size) {
-			response = _get_first_reassembly(sc);
+			response = smbdirect_connection_reassembly_first_recv_io(sc);
 			data_transfer = smbdirect_recv_io_payload(response);
 			data_length = le32_to_cpu(data_transfer->data_length);
 			remaining_data_length =
-- 
2.43.0

