Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8EA296BA2
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154594; cv=none; b=oW/xnMGoWz91L0fuSs1n8cJt06ZM5PsW0TTsYjxTmqkh8skthUQx2a7X6FYK+NZFafemXOS8H52kl3SMBw9rgC02FSYKA6P9yGOg3gTrpqt+F6T+9brzm1BrMQ1VIB9y6QFW2y7N4lFqqsgSlQ29cze1uaDQ7aXjdTQZb/VEI/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154594; c=relaxed/simple;
	bh=OL+fkO347Srviq7XD8K0zZUtXl6XUhdqFNnBgzOBJC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2wrd6dH2PGQmnoA+dnIpBlFmF9bmfjntHRTW9enADZTi83/eM/tQsoJdvesS9Yt6juCEumoL+dZi8i50hERskD+JnyJOsgQgvd4jYe7JyTlFyhCx9x41QDy1XuEYND3EXsKjWy4PLGBraQif9sCd4A884RafFuuitdIfiIrnPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=oDeMS1dv; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oDeMS1dv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=qILDkUkeLcVNZlyX80a+XatELZsjB73tpMiwDQpttXY=; b=oDeMS1dvxsBQwnTfSZyPDQ7Uni
	t5Kw28Gigw3ilBhRG0VLwmbrOZGDBhYMXZrk+Icdd2XthfVYrNDLhQu4EaaF9FdY17t+2BCujr5L8
	i2BMwitHbFmXyS5AWEVn1tO2wlfQ1bceJvRQWiv19zHzchYV3K4P+Th5Z52praVjjiX1/+ar929AS
	oPhxkrnRjf4EZXNH+b7gH9m4fd8+s7BQN22r6LLPi5Pfps/FXlOqTP6fKJmQb+ECAak7JmlHfm0Rm
	Z1AyvvX8kYys27exkvVVE9z897CKIMIYG8P494BYCi1JuoBsQlgt4y0X/h5Zh9GIEBOGidpCq1MCH
	ANwj0QAaHc0oS5nA/3zKVU1Lfn2dXpxniKXrTlwVhLIrvcEIuIV1mzFtMusrgzD+gskqfGlziQJ8P
	mGPOL45WdJKHitV7NgqElkP++b++hWS0hcOA+XZNrT3j8WEAOsdE0TDp2MN6yDu9ZAC1LvCAeojjE
	UmClZx8K5/ow5jq3put0BQlU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe21-000jRr-2x;
	Mon, 25 Aug 2025 20:43:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 007/142] smb: smbdirect: introduce smbdirect_socket.rw_io.credits
Date: Mon, 25 Aug 2025 22:39:28 +0200
Message-ID: <7517f6b194ded09f77e25f2e77933c2393a638a3.1756139607.git.metze@samba.org>
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

This will be used by the server to manage the state
for RDMA read/write requests.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ef6f330ba7d4..001193799e16 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -129,6 +129,27 @@ struct smbdirect_socket {
 			bool full_packet_received;
 		} reassembly;
 	} recv_io;
+
+	/*
+	 * The state for RDMA read/write requests on the server
+	 */
+	struct {
+		/*
+		 * The credit state for the send side
+		 */
+		struct {
+			/*
+			 * The maximum number of rw credits
+			 */
+			size_t max;
+			/*
+			 * The number of pages per credit
+			 */
+			size_t num_pages;
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} credits;
+	} rw_io;
 };
 
 static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
@@ -151,6 +172,9 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);
 	spin_lock_init(&sc->recv_io.reassembly.lock);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
+
+	atomic_set(&sc->rw_io.credits.count, 0);
+	init_waitqueue_head(&sc->rw_io.credits.wait_queue);
 }
 
 struct smbdirect_send_io {
-- 
2.43.0

