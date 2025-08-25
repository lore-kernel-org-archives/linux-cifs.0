Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AB528688E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154565; cv=none; b=Jg1StGWjqw/AGvQVzb6ql6OUAGrkxq4plmO2n31aLFdgK+ZjaIFXqTrTHYrNknDuhbKbZv/A8dpbdVieU6qMswsJ5/ydEzBnEBtTJ++sw29wIXUNxKOgkeuUyO9qLCl/mXvQhUF9LpzYrsEh7jHdEy/DXk998/9yEE9Lw3QpCAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154565; c=relaxed/simple;
	bh=4J5m1sTDavLF6LcWz7MC2g0YkwQBvdhbqnQ2Fz69w+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUkE8HwHKB7TWlQyOKQJX4fdtIVb9IldiM9tkxWqQgEI5PIKnEDy2VIZo4g/SR48IK+cahOILcNfcB9rNLXxxxa57RgSTH5yxFoV+hr6AhZFB5JmYucZg1h4L4g63EiCNgE08iWOLablcMUN7pH/XO8KYc/5B5Su7Syt7VJyUBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UAeuNGqm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UAeuNGqm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=X+IgLJWutN5KZwrz7YVVcXzmetkmDFKU+K7lOErb8DI=; b=UAeuNGqmMl62LcgLo17+iCTfJV
	FbNK9GRqWOxIrYtXgC/WrGP8HUvdoXmdevGbGP1gntbSpc391YTasyRzuGSABl6SluDVDfxnu2ZZd
	UTwutO76FVrmoMFR8S+ep/r5sBovXSIGaY+2nbhS/dsCQhxbNAZ5a02CBzDJQ6isvuGHOOtVSzxWP
	Qd9zpa7dq0MyQ01aQVGuVIeA7ARuQ+bwzYwDuLKEcaQqN6zvqlOqaPvEncoPZ7/3muIpE7ysAvuNN
	dcmJ1OZifUFdcWIh2NIMFbgE3H2Kfa3KohueFjOfyRKE04OLRcTfMf8QDPQKRe+34FONgYVtnr102
	5jrEDHSauP1UmKVAoS1vfuX2eABB3hjq1FQqpf57Cfp+bwzWX3rLJVEwtlvsRAxfsDcM6o9vxc1Tg
	I8IDLHsxqwkUgvlSM6SyS9SgBhqPZ08X9Bsdm8U0LbxyZyF+ZHOAwEqeZOizKaSJZIVyBfe+269Vj
	qxEkRfV/PWYqNfAffDe4S3yd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe1Y-000jL2-0W;
	Mon, 25 Aug 2025 20:42:40 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 004/142] smb: smbdirect: introduce smbdirect_socket.send_io.pending.{count,wait_queue}
Date: Mon, 25 Aug 2025 22:39:25 +0200
Message-ID: <2512d1dd03eec49674f317f9b78fc0bee60c2e60.1756139607.git.metze@samba.org>
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

This will be shared between client and server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 79eb99ba984e..bfae68177e50 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -54,6 +54,14 @@ struct smbdirect_socket {
 			struct kmem_cache	*cache;
 			mempool_t		*pool;
 		} mem;
+
+		/*
+		 * The state about posted/pending sends
+		 */
+		struct {
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} pending;
 	} send_io;
 
 	/*
@@ -123,6 +131,9 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 
 	init_waitqueue_head(&sc->status_wait);
 
+	atomic_set(&sc->send_io.pending.count, 0);
+	init_waitqueue_head(&sc->send_io.pending.wait_queue);
+
 	INIT_LIST_HEAD(&sc->recv_io.free.list);
 	spin_lock_init(&sc->recv_io.free.lock);
 
-- 
2.43.0

