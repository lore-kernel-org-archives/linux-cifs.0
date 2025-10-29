Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BFB205E3B
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744525; cv=none; b=GmpiZzXCxXBs+U4bVbd3k7/11HMlhgX53+zEWH8s+avYaYZuF+f/dGVjoQv+dMHtPce+QDZOU24A/ECW4Bc/q+Xmt+OzeBj9dHUIt4Si4qvHIEBJnDfY5ZE5y0Q0tgS2x0meZoA3xtPv+3ya1cblG1IdL5B4SIt6rQJXafl6T/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744525; c=relaxed/simple;
	bh=Rx3M+XmW8C6KWu9I2J0eZ86lU5pC2KxfPSQOScrIXFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpm6yNYIjwCzU+mAtGxkNSvQH7vabstC92hQ9nkKgsaXtMSV9NRSnsV30fsdpxc9tAgnD/RWeHNiknQLT3Buxg0J0PZRO+Z4Pq/6GVlGw+COTp8fx/vGxki0hgeCvJpN2BYLbu4E7qNfsFkHCVE8/mq3yYY7rNQEPFmpYQstklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kcCKWYcR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kcCKWYcR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=oUkkInYoPyT4J3cR6Q8CohJZdIROPok0h4uGmiYb6os=; b=kcCKWYcRlVeUbDb8cgKkdXCYmx
	Xpt/xFsUaL9l/nQP0RtA76QyA1zCfpkSTfVwtecF6BxPtnFzwskDIjsJKwPKMbsUz20yYfQObrnYQ
	BNcDP5io3XCVMx8IS+epq8VMVuhlVW87WBXhVubzGV6zIp5ixnoGdyR5EZi4nsDVjpBYvNqm2J/L9
	+67mAXQ+HcB8+6unPA1J0U+Z0/G9zgpKOQYjd40bYaSrtUp5Mqx8rZ1+Yud1DSqVYNIwig4FsQx8q
	OPJQXJpfgYuwptpd+ESZAPXpgaBsGF1cUkZr5eV5UKFfWpdGQKSmdEq45+flCavklwJQfcGGFPjyF
	4s/6C2USHGuMp4LI7sU75mxtPG3kTr3KENr54mpoSqbkYFpcMgb2YgmVhVi1bpXFr0KFY6fdj3Ik9
	Idw7/EWOxitmnNYlqmtGtM/+1MTcTV59cMkL1LdVeTS8hL92Mc8a/AvGQ6KRstZgAoVVm3du/DigQ
	yjPVgEqldI8hZBaHtOkXtFTP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6ED-00Bc89-0B;
	Wed, 29 Oct 2025 13:28:41 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 063/127] smb: client: make use of smbdirect_connection_reassembly_{append,first}_recv_io()
Date: Wed, 29 Oct 2025 14:20:41 +0100
Message-ID: <ae559f505513c3a7925ca38308938e32112cf253.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
index d76b25fc80f1..cf2f63696f85 100644
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
@@ -681,7 +675,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			if (sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
-			enqueue_reassembly(sc, response, data_length);
+			smbdirect_connection_reassembly_append_recv_io(sc, response, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
 			smbdirect_connection_put_recv_io(response);
@@ -1295,55 +1289,6 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
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
@@ -1479,7 +1424,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "drain the reassembly queue\n");
 	do {
 		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
-		response = _get_first_reassembly(sc);
+		response = smbdirect_connection_reassembly_first_recv_io(sc);
 		if (response) {
 			list_del(&response->list);
 			spin_unlock_irqrestore(
@@ -1960,7 +1905,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 		/*
 		 * Need to make sure reassembly_data_length is read before
 		 * reading reassembly_queue_length and calling
-		 * _get_first_reassembly. This call is lock free
+		 * smbdirect_connection_reassembly_first_recv_io. This call is lock free
 		 * as we never read at the end of the queue which are being
 		 * updated in SOFTIRQ as more data is received
 		 */
@@ -1970,7 +1915,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
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

