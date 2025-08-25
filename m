Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214172AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154823; cv=none; b=Z5c83yTt5jji1ft7r6p2O64yZ0otu1IJwOsSKcSR9SBv9KsHDJ07Z8RMLQqyuKXBdNklb+yKXJsVga0SpjRhcwQsbT7U1XQ/m1z8O/lSp2MEjTnfSLQuu5S4dDOxGA2TTQnRq4n4YxA/flrP6PzG+o0IvJFsp4u3+Rh+reC0ptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154823; c=relaxed/simple;
	bh=LaPC/KsfWElGwAE8vVB+2YHsxV9lLvw+vDp5oedwpyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUt51YtFWWQ71/Xv/7IxnmvphFkU7SKpJ4cV7Dren9/1FLxhbq609/o4GQEXfijSzHDMdi6wylaF6C1VMGCLrDL0VRcF1rvW/Lc+06s3Dq5fCmu03tUHb5tCcFqBzYwgodPk6xO2ax1UK1BBz037hFvSGLoG85+S2Fju+Gy6JNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UiP3Kuz1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UiP3Kuz1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vR/GIUyuVHiWlyyPDjuauznDoHjd/N2hSnjPlBVcY1U=; b=UiP3Kuz1FYQgLT39F9EwqhskpL
	onh7nQnom0ibA/2CNLJ18qOpFTiTTPEkQgHCs2KJRta0tbZaci5i8o1/tJAwXlDQQSXS93Ms678OE
	onoUoayDONxW3n1vVTPZJBrTTRJthAUEWFlFiohHjdIZO+m6tUrSr455jmfLqxJ/AGTSx5oB/y7T+
	qwmjpehlu4bXrk9+lgKw5xhWVmXDsNsJq+EHmGMJdVI0wEY9WKXjFhJWSWzShyI2xKZKke847nsj7
	rt3mgH7W7aYMumUAU4RagS9h3znNO97Tk/1dGsPq3cXhP8WG689xuPSX1PZ6ESi688A9YBiC1mOct
	YpToLehDRGPaJ7PAtTAKF2yEVLrOl3Og59d3gCnKFD/phu3/O2a6d5hV6vIFdn65lxuVkYVZtI3YX
	lvfsr1hyvzPiHYdCQDHl1vE22+JBHmtQ1KXbSlO22CGqq9rIhEArrvW0/2axhx9zOhninSkeZpwLL
	l+U9I8VRU4cFIh3NMPuKU3h3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe5j-000kDs-0V;
	Mon, 25 Aug 2025 20:46:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 031/142] smb: client: queue post_recv_credits_work also if the peer raises the credit target
Date: Mon, 25 Aug 2025 22:39:52 +0200
Message-ID: <207f19af6a22d271101dd91e446a344623518608.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is already handled in the server, but currently it done
in a very complex way there. So we do it much simpler.

Note that put_receive_buffer() will take care of it
in case data_length is 0.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a61c7d2afbdf..40aafc606ac8 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -562,6 +562,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_socket *sc = response->socket;
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
+	int old_recv_credit_target;
 	int data_length = 0;
 	bool negotiate_done = false;
 
@@ -616,6 +617,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 
 		atomic_dec(&info->receive_credits);
+		old_recv_credit_target = info->receive_credit_target;
 		info->receive_credit_target =
 			le16_to_cpu(data_transfer->credits_requested);
 		if (le16_to_cpu(data_transfer->credits_granted)) {
@@ -646,6 +648,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		 * reassembly queue and wake up the reading thread
 		 */
 		if (data_length) {
+			if (info->receive_credit_target > old_recv_credit_target)
+				queue_work(info->workqueue, &info->post_send_credits_work);
+
 			enqueue_reassembly(info, response, data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
-- 
2.43.0

