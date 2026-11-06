Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007120;
	b=X+QSNpzlpFG8dzM4oO4iGxEbHqdbHl8aDOsfW4Z74RTG3hCeOHiwUVmYeFkMyXLh6Tz6
	 oz+JIze4mfasfuSgpzXO3bSbmCEfbhkXuWoExyz75o1pZIZW44uLjxBFZJhiW8KcWplv2
	 V5rJqr0/PzSMnAyDfsVPinpZpd30e2V+Z613aJNUfpo88WZX1jhSiOYDYm1pFj0WcZPAn
	 8K75J+Vkh8dHmxZTAH3EQWOchL7akTosQwJGhg8jpakN8ujeEr4eJXHqahjmLW/CfbdUI
	 2bmcuknGbe9GolDf8C0+TAkEHayiAhPKnSPhUeru/FrvsIbOlNXt769/v2S4MtcsNDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=H1v0v6jdWWrkOMKSVVNAV2dkkY9NVRj9DV/y56uqM2Y=;
	b=GHeUKAgDdP3dhUXMihClnqbhenUm/adwj2Tg/JMfp5NvW1B1uEaH9MgSjHlqD6ZVwiWX
	 Plu4Pz+fRudkdqpsMmKq66dF1iDYA7kWcWzecMo3CrebKVbfWhiH276w2QJTHvbeJwhP1
	 WKh0ILoUauyLCLSw8uq9cnd2e5g49+oy5B9mmi4rH+cwxXmJoC1iYM9CXQZ+Jdbo9YMH3
	 ZDdP8FrpTZP2SJ1DaV4NuNSYluAUqLElgFobcABywaPEEvCI7OFWlJcNlmevXlvFDO2ro
	 IDAqFczG3oykJsr6k4JkmxFGwVK7ZdJ7nW6ecyq5e6mPPCiagD6PebslK9U7/zoIsdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=IntCRpWx;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64990606A330;
	Fri,  6 Nov 2026 23:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64990606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=IntCRpWx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=H1v0v6jdWWrkOMKSVVNAV2dkkY9NVRj9DV/y56uqM2Y=; b=IntCRpWxWqbgW4Wik68vriSxSC
	vvLl59/uj+0PxfhvthhXTA+h+u8GxmuQOCtqYcPQSN/6ze0uxJHTfaDOWf5fPyXwhlibPAZgDa0ep
	F9gp3TvQMgnrYWHOjU5PgDkgnPmP/z5QX5m8nGayb9tYxTx2GMS3LeUZcVmzZPjYokyUl40HUrQP1
	hZZV7EQ8l/HN1IdsLjRb66HzlOIPJo9deB73bXiJkPNvPGf4p5JhYBbncdCmroW3tb6uDw/Vti4jk
	o/RpqM6jI3jHBy8+x9m/aANYwL5OW4EiZ+Ene1dj/G2zpwJbBb7knSV+/Ohg/LaGr1zw6jIeQKkHy
	WTQbCQGw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPTCX-000000014Ez-2Y49;
	Fri, 06 Nov 2026 20:18:30 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 08/19] smb: client: don't spend read retries on reads cut short by a reconnect
Date: Fri,  6 Nov 2026 20:18:16 -0300
Message-ID: <20261106231827.2604956-9-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106231827.2604956-1-pc@manguebit.org>
References: <20261106231827.2604956-1-pc@manguebit.org>
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

smb2_readv_callback() always retries a read cut short by a reconnect,
but still asks cifs_io_should_replay() whether to mark it as a replay.
On a soft mount that spends one of the mount's retransmissions and grows
the backoff, so a later replayable error on the reissued read can fail
it early.

Mark such reads as replays without consulting the mount's retries, as
already done for writes.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 736c5c693c79..be003200efa8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4695,6 +4695,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[0], .rq_nvec = 1 };
 	unsigned int rreq_debug_id = rdata->rreq->debug_id;
 	unsigned int subreq_debug_index = rdata->subreq.debug_index;
+	bool cut_short = false;
 
 	if (rdata->got_bytes) {
 		rqst.rq_iter	  = rdata->subreq.io_iter;
@@ -4743,6 +4744,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
 do_retry:
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
+		cut_short = true;
 		rdata->result = -EAGAIN;
 		if (server->sign && rdata->got_bytes)
 			/* reset bytes number since we can not check a sign */
@@ -4815,7 +4817,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* see if we need to retry */
 	if (is_replayable_error(rdata->result) &&
-	    cifs_io_should_replay(rdata))
+	    (cut_short || cifs_io_should_replay(rdata)))
 		rdata->replay = true;
 
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.value,
-- 
2.56.0

