Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E601F1932
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985390; cv=none; b=pKJAp2JYgj0zfZqe0aIDA2LM2NyQC/3LVBIbLqp9BiFxa8wQoomAL48u8/9mZOVVfGvtlFEUCeo2XdEKwuTfLUsvTNVwVkLc3VdXpiuuai3vcxm5jSGCKiSyr0OLqCOMQ3oY5cixXiJ0dADjfw3Q094+W78nnjyhMsCJCmIHOw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985390; c=relaxed/simple;
	bh=UnDHSFb2DGh5fkXKGd6hrVqiuNpfOOSDNXDzWZx0FDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBHhCCx7NDArAAzjGA6godxLnWpFJw9VhhhHK25B3NFB6VjTWf9oqvT891TAb43myzNMNzf02mik6N+CxT4ymatvz2h7MO96NynrvNrUMUwgj3TFBF3ySSA/5EGq0ZHejX2rISkh2gDOAhYnPcA2T370jeoCV2TF+0c8/6CdqdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=O1aURhnZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="O1aURhnZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=DfLZN6Bj30ZaNE2OUOxZcTpRTO7N80Vik19UR3xP8ls=; b=O1aURhnZ37vI7Q1CC201wtkk+p
	7S0OB8PSuTvbV+Dwg8fp8c3bRz1hgByUKQ4xvSkOpxMCuGThcWiIVg8iC3+zB9gi9PYCkteo8w9/M
	Bbeps5rCD4coqk2+/SbXZ83rcoHi9LrIyWOKdi/Cq9F+nILwIPP8ry/RnhYXkF0IKaeXyRUtS3KiN
	JNgWdAks0JZi73egStUyHQBU9Hx+oD4FkPatJ8kFGyg+4buWg+wpty3xvdV5EVEzKRVKxSBFuPXGl
	wcVO8g0iWdiG4ZC4YpFohDfnim0mBsoU1VYNI4NC8NucgSnoqDjfGvwbrMC43Adai5ssESTWfb9/j
	VXdnhbW9mszUs0bKeae2FzTUfp37GHke68IOX8Q/U0C3rdZnI0xksVJ0LPS9beIb8lNNDtDlfE7OI
	LcwsRxs9FCNTNsRm01SGwmn2DNa5Bd+CBq0G/FteZNV3SW0E5J3TaGct5ghs8e8TX3wZ2uNpd/A5i
	SD4RNktJqlce3l6EL0AiQiDr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vAuk4-00ACNh-1x;
	Mon, 20 Oct 2025 18:36:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 2/5] smb: server: smb_direct_disconnect_rdma_connection() already wakes all waiters on error
Date: Mon, 20 Oct 2025 20:35:59 +0200
Message-ID: <f509375aa6c0efba8d0b95d387826b78252092ab.1760984605.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760984605.git.metze@samba.org>
References: <cover.1760984605.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need to care about pending or credit counters when we
already disconnecting.

And all related wait_event conditions already check for broken
connections too.

This will simplify the code and makes the following changes simpler.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 019e5f70d7b3..c4df1328342d 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -988,8 +988,6 @@ static int smb_direct_post_send(struct smbdirect_socket *sc,
 	ret = ib_post_send(sc->ib.qp, wr, NULL);
 	if (ret) {
 		pr_err("failed to post send: %d\n", ret);
-		if (atomic_dec_and_test(&sc->send_io.pending.count))
-			wake_up(&sc->send_io.pending.zero_wait_queue);
 		smb_direct_disconnect_rdma_connection(sc);
 	}
 	return ret;
@@ -1038,8 +1036,6 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 					 send_ctx->need_invalidate_rkey,
 					 send_ctx->remote_key);
 	} else {
-		atomic_add(send_ctx->wr_cnt, &sc->send_io.credits.count);
-		wake_up(&sc->send_io.credits.wait_queue);
 		list_for_each_entry_safe(first, last, &send_ctx->msg_list,
 					 sibling_list) {
 			smb_direct_free_sendmsg(sc, first);
-- 
2.43.0

