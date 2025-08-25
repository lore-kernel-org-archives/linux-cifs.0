Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B151DE2D7
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154612; cv=none; b=sgz3JIDeXzxXsrTu06lydCMA+aS+lRAr9RXao7zuDFM+KUfEptB2CHyuP1InJGbzEOOP3/UntedxWclu1xhcS9Tvz08TLiYFsXUtTHbhuPiS40sJnCelp5MUyb9sLoeWMbXMJuC6ZVZRNDJ/nqr6On7JNg5aev2MEOeFSD+qWNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154612; c=relaxed/simple;
	bh=mXwXOkLtXA/zFm21FEEPMUz5wBuSdA460LiBiPVj5lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR/jiEodPvhv8iNL5dTlv5CQlftLRZz29jwsZRLYECYjY7tjoamACqRm9O71ctD8ZSpFnk2bQCl48ih6vBOon0xGvvU6TfZVhxZ5XyGsbR+OUGi+y1ShAAN0koI+5HlT604KX71XUQeSeZDCnW+hELpb2hxbagUlgxsYeKw2nO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nG2Lx/8P; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nG2Lx/8P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=avpXg+3zxWxFK1KwidziCd4CJjjfXRYVUt4jeexiKW4=; b=nG2Lx/8Pm5Vw38M6w5JdBkIWQ3
	dOibJJTYsg4mL4HJrlKpHeM1sZRbCnNCTX7ZFaigCGSheT19ufryrBnkrMyoHL6pmDsY9gnfd3brg
	Wi3z0S91ZyZ0rDeyglQohcPK95usjrpfzT69BlRDGUDgaYdBM/yCCBAUojS4Rbdwf2YLJUEgXbVZ7
	QTA7ATICEi/UZU4FUDGKfhr2h1oUO5Ro9HhGxX36ubX/nsVIM4XqaUmXGQQ3pRObGMwLHN+gyII2/
	7JZoRfVVBlPu9OijRmrHc5HxGYycIYGKKv+4xhQ2NckXg1x+PKoCwCvDShOYpBbRu57MGI/7ZJ2Ax
	qwqBAGYoSnJq2vvx+AS/AztbztG4z/x3m5nOrHYckokgntM1e7bv1fx0kqTauqJPvvD43bjS8FN1o
	+sMSJQacR0bKDJ8A7ZmGCZc3wQU6yffsCUzAGgy1UwaSM3ClDR6E/Ce0gr/ke7Yab6mIf2H9/ZKZ3
	3MafPQQl9vrvoi1erfziGQ1z;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe2K-000jTu-0o;
	Mon, 25 Aug 2025 20:43:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 009/142] smb: smbdirect: introduce smbdirect_socket.recv_io.{posted,credits}
Date: Mon, 25 Aug 2025 22:39:30 +0200
Message-ID: <c21ba1ceab590332c45898ebddeae31b8ca5b1fa.1756139607.git.metze@samba.org>
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

This will be used by client and server soon in order to maintain
the state of posted recv_io messages and granted credits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ff7b9f20b1ac..09834e8db853 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -105,6 +105,23 @@ struct smbdirect_socket {
 			spinlock_t lock;
 		} free;
 
+		/*
+		 * The state for posted recv_io messages
+		 * and the refill work struct.
+		 */
+		struct {
+			atomic_t count;
+			struct work_struct refill_work;
+		} posted;
+
+		/*
+		 * The credit state for the recv side
+		 */
+		struct {
+			u16 target;
+			atomic_t count;
+		} credits;
+
 		/*
 		 * The list of arrived non-empty smbdirect_recv_io
 		 * structures
@@ -171,6 +188,10 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_LIST_HEAD(&sc->recv_io.free.list);
 	spin_lock_init(&sc->recv_io.free.lock);
 
+	atomic_set(&sc->recv_io.posted.count, 0);
+
+	atomic_set(&sc->recv_io.credits.count, 0);
+
 	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);
 	spin_lock_init(&sc->recv_io.reassembly.lock);
 	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
-- 
2.43.0

