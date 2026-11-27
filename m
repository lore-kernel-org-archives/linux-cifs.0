Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782596;
	b=KCdjlTd4VI1OMpy7Svf7P9N8c/wcbVw91cK8M5+nCKndF/iOaWvv/LF85NsnxjbTeCbZ
	 /u6p5RanpevZofxKDiHexCWIVEhe4r9KmTGMWDR3+JO5hM4T+aKrUrWLYT7pYI7OAxIlg
	 AhQFHS4HAlJr+jzB8D9+25XvHkQaA6UdVXriaPQDdKSHSw/BJD/pzsj1/m1ttIY+9hUpF
	 xxCTBfQbn6LzFE9DQA7CKD8PcANPWjmmG6PkX6S1/H2F4ABgx074Un06quiqXcKOCI8fj
	 lB6gy1JAIzPNHDv7slXSwyX8Fv2NZ+mphl4lhtmQsWlKYP3Is1iqUbBru+0UlhZs8Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782596;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uuTZ+xT7/OX3wJ5mUNtdwe827wVJ1UalULCywQdXd2U=;
	b=EL+hS7sbF2586osOalK7MKRTXI2pzuw8/1QmBMe/04tNk5oaVSHJOwuAId6hUg07kmPf
	 LApsYcmJbnpzpdutAONgCDdQjFEGBzG75mX+ThpDwvBWyqWIA2WYYaGp40QyjxOIeYEm+
	 hrj+ehQ0klgPasYx2fV11J5KuBIC99jLUzIoPR54DVgu1RIg4JNe3kN7ECleiNF//tV8l
	 KxkZBfnbW+EZaRpw10Bw1CQKP1qsKR3MYRJPF/SL+w3xEPlkqaryfj22t00TSEXF6qJi9
	 N4MIiqceHpMWX72ntrUwnn4SOsieJEkFkVFuEny7X7XcrIUsM4yxZsS86XFogEqQdAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=rhKVCwvs;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DF9606A327;
	Fri, 27 Nov 2026 12:29:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39DF9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=rhKVCwvs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uuTZ+xT7/OX3wJ5mUNtdwe827wVJ1UalULCywQdXd2U=; b=rhKVCwvsNhLPv0X+kHa3Ji+V+a
	DsKv/9JH7CK+bqC0x9piO+DpunSQY08//AZwV0ZylY6sT7sD2EAd2aq6F2y3C9da2s/BEYbnJXptx
	xKduwV7hMfhIxK2reHZ3f6QHaYlKW8uv5zPcVoREgncz8bLc+7xfrzmABFHAGpeCP5gP258olmSnU
	OT8HWmHoJ/ham3hvJ86k+U8PkjV+qOtFWoLlxRUCQpyk19HVtgBr8cnGCvNu2VR6wTowbrU0pl106
	7WKPVCEpwhf7txLKG+p7Xg3tmrwLhdbQOdTF3w5JXHypVr2pv599fc/S8ZHdyHt8aDE6bRnw1jvB3
	H5XKGDmh00ZFKi1Ym5W0QF6i7T/WywUNTwGLdEgwx/c17WvAGa9s2eokcMcphmVyoPi1RxNOG4gps
	u0Wxpg7bKfhufmyUoPHQGLQDBbY3reBA7k97bwq/0daEzRGWA1Dod0nj40Ggj03e/bqUFUiRbdQyo
	dSuVRcyfSIsZ+9ETkL9jwib7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv5I-00000001Lbh-3XsG;
	Fri, 27 Nov 2026 12:29:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 05/10] smb: smbdirect: don't post a partial PDU after a send error
Date: Fri, 27 Nov 2026 13:29:02 +0100
Message-ID: <fb5cdee4de5adcfae25a7eeadb607836651d07d0.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All fragments of a PDU are built into the same smbdirect_send_batch
by smbdirect_connection_send_single_iter(). If building a fragment
failed, e.g. because a credit wait was interrupted by a fatal signal
or a DMA mapping failed, smbdirect_connection_send_iter() and the
smbd_send() of the client still flushed the batch with is_last=true.

That posts the fragments built so far, the last of them with a
remaining_data_length that is never satisfied, fragments may also
have been posted already by a flush with is_last=false. The peer
then appends the next PDU to the incomplete one: cifs reconnects
asynchronously, ksmbd keeps the connection and its next response
continues the truncated one.

Add smbdirect_connection_send_batch_abort() and use it instead of
the final flush after an error: if nothing of the PDU was built yet,
it only gives back the batch credit, otherwise it frees the messages
not posted yet and tears down the connection, as the peer can no
longer get a consistent stream.

Fixes: 2c1ac39ce9cd ("smb: client: use smbdirect_send_batch processing")
Fixes: 54abc694ebb8 ("smb: smbdirect: introduce smbdirect_connection_send_iter() and related functions")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c     | 14 ++++++-
 fs/smb/smbdirect/connection.c | 71 +++++++++++++++++++++++++++++++++--
 fs/smb/smbdirect/socket.h     |  7 ++++
 include/linux/smbdirect.h     |  3 ++
 4 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 563ef488a225..64d27d00079d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -485,9 +485,19 @@ int smbd_send(struct TCP_Server_Info *server,
 
 	} while (++rqst_idx < num_rqst);
 
-	rc = smbdirect_connection_send_batch_flush(sc, batch, true);
-	if (unlikely(!rc && error))
+	if (unlikely(error)) {
+		/*
+		 * Don't post a partial PDU, if some of it was
+		 * already built, this tears down the connection.
+		 * Fragments may have been posted already, so we
+		 * still wait for them below, they may use the
+		 * pages of the request.
+		 */
+		smbdirect_connection_send_batch_abort(sc, batch);
 		rc = error;
+	} else {
+		rc = smbdirect_connection_send_batch_flush(sc, batch, true);
+	}
 
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index c50096e605ee..3494189f41ee 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -925,6 +925,7 @@ static void smbdirect_connection_send_batch_init(struct smbdirect_send_batch *ba
 	batch->need_invalidate_rkey = need_invalidate_rkey;
 	batch->remote_key = remote_key;
 	batch->credit = 0;
+	batch->msg_cnt = 0;
 }
 
 int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
@@ -988,6 +989,58 @@ int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
 }
 EXPORT_SYMBOL_GPL(smbdirect_connection_send_batch_flush);
 
+/*
+ * Abort the PDU of a batch after an error, instead of flushing it with
+ * is_last=true.
+ *
+ * All fragments of a PDU use the same batch. If some of them were
+ * already added to the batch, possibly posted by a flush with
+ * is_last=false, the peer can no longer get a complete PDU, its
+ * remaining_data_length would just continue with the next PDU. So the
+ * messages not posted yet are freed and the connection is torn down.
+ *
+ * If nothing of the PDU was built yet, e.g. the wait for the first
+ * credit failed, only the batch credit is given back.
+ */
+void smbdirect_connection_send_batch_abort(struct smbdirect_socket *sc,
+					   struct smbdirect_send_batch *batch)
+{
+	struct smbdirect_send_io *msg, *next;
+	u32 freed = 0;
+
+	list_for_each_entry_safe(msg, next, &batch->msg_list, sibling_list) {
+		list_del_init(&msg->sibling_list);
+		smbdirect_connection_free_send_io(msg);
+		freed++;
+	}
+	batch->wr_cnt = 0;
+
+	/*
+	 * Each message took a local and a send credit,
+	 * see smbdirect_connection_send_single_iter().
+	 */
+	if (freed) {
+		atomic_add(freed, &sc->send_io.credits.count);
+		wake_up(&sc->send_io.credits.wait_queue);
+		atomic_add(freed, &sc->send_io.lcredits.count);
+		wake_up(&sc->send_io.lcredits.wait_queue);
+	}
+
+	if (batch->credit) {
+		atomic_add(batch->credit, &sc->send_io.bcredits.count);
+		batch->credit = 0;
+		wake_up(&sc->send_io.bcredits.wait_queue);
+	}
+
+	if (batch->msg_cnt) {
+		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+			"aborting a partial PDU after %u message(s)\n",
+			batch->msg_cnt);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+	}
+}
+EXPORT_SYMBOL_GPL(smbdirect_connection_send_batch_abort);
+
 struct smbdirect_send_batch *
 smbdirect_init_send_batch_storage(struct smbdirect_send_batch_storage *storage,
 				  bool need_invalidate_rkey,
@@ -1097,6 +1150,7 @@ static int smbdirect_connection_post_send_io(struct smbdirect_socket *sc,
 		}
 		list_add_tail(&msg->sibling_list, &batch->msg_list);
 		batch->wr_cnt++;
+		batch->msg_cnt++;
 		return 0;
 	}
 
@@ -1382,9 +1436,20 @@ int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 		}
 	}
 
-	ret = smbdirect_connection_send_batch_flush(sc, &batch, true);
-	if (unlikely(ret && !error))
-		error = ret;
+	if (unlikely(error)) {
+		/*
+		 * Don't post a partial PDU, see
+		 * smbdirect_connection_send_batch_abort().
+		 * Fragments may have been posted already, so we
+		 * still wait for them below, they may use the
+		 * pages of the caller.
+		 */
+		smbdirect_connection_send_batch_abort(sc, &batch);
+	} else {
+		ret = smbdirect_connection_send_batch_flush(sc, &batch, true);
+		if (unlikely(ret))
+			error = ret;
+	}
 
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index 14114a2567a2..dc1e906316ff 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -783,6 +783,13 @@ struct smbdirect_send_batch {
 	u32 remote_key;
 
 	int credit;
+
+	/*
+	 * Number of messages added to the batch,
+	 * unlike wr_cnt not reset by a flush, see
+	 * smbdirect_connection_send_batch_abort().
+	 */
+	u32 msg_cnt;
 };
 
 struct smbdirect_recv_io {
diff --git a/include/linux/smbdirect.h b/include/linux/smbdirect.h
index 97f5ba730fa7..74fff00cdf88 100644
--- a/include/linux/smbdirect.h
+++ b/include/linux/smbdirect.h
@@ -115,6 +115,9 @@ int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
 					  struct smbdirect_send_batch *batch,
 					  bool is_last);
 
+void smbdirect_connection_send_batch_abort(struct smbdirect_socket *sc,
+					   struct smbdirect_send_batch *batch);
+
 /*
  * This is only temporary and only needed
  * as long as the client still requires
-- 
2.43.0

