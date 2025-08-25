Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A575828F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155820; cv=none; b=X81fKrcQBR1P2CvKh323jlGJIjYnDoxAMSZXnG7IwzKQl7yXLFSMI98fwdKZYh3GO+8tqW0Xz9KPOWaElvdDv6AurO6dk61uEZFGHyJsq68ArSNOoN7OjiOO4GK6PHiwRDIZfgrGJlvT8+x5GENkGCJj9tP0rToSJwT7n4E/NXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155820; c=relaxed/simple;
	bh=5fGsvK7R9vkdkFL1dXSFKtrEE4LdGA6T3yRRJjp10Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUw5fMWg4Rh5QlRxhfiZZt1/VibGfBZJb+9MJTk1S2JrujvEd7wF5mv1QfA8Xc4TNyKEKeht7uIn71HfdMZmhrjMbY6Pp5BnzO9paOYs1dQVxuwYGYoQQYcyMGGg6uQqoL7PmSXe7DtfrNWacbhI9mkrsRfDOMjq89PRQobx/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QfKO610v; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QfKO610v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=KQDLTfiMCyb0U7S54nktlS5dL1/Nh4CX7psSRQehF3I=; b=QfKO610vz9U4JUNJRJqeU1Fnsj
	68bDNCYULDMuogcjzMlRwF/ggLtNB6RHX9xlpqUmYyq67uKLftSabf+3+Afdr1DaJYsggzeByn+wL
	MayqY2+J6fIUwfaf8zTs1b32+DhegpeWyRgizjiANeWpKnG7ZhQNRCqhUk8oJpXUy8u6zriCHVFTH
	e+aWzX7M5o2R9x8eX32tAdmLl5d1aq78qKfDNwu50pRoRGXhImW6CoPxoQ/2wq/dundjl/xfOvMci
	eYho2FdUuFumQlejNU1nmnylhmFn+B5ja1FhEVjB5zNOAsKE1Ff4aeD/0dL3BgHcttE5nsbDQofC9
	1yxGx4Z9sClPKNsB4lKFgjWfKUsBKs7Qooqa6XJd6K9L7UjzBt8rwJ99ek0bhLKjzpLiquPT7iEnz
	JcgFiGlkoz1RrWcu6rxrTVX7hApM9Kw5gsFgwOK7bbrkphVr4yux5JMgNZt/3AL+gUEbbZqP4c4+g
	nUPbKs4u5XzjO7V1NZtIIJDs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeLo-000naP-0K;
	Mon, 25 Aug 2025 21:03:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 131/142] smb: server: pass struct smbdirect_socket to smb_direct_flush_send_list()
Date: Mon, 25 Aug 2025 22:41:32 +0200
Message-ID: <b54e5b82e928a014016af83b93d0ff87aa98f730.1756139608.git.metze@samba.org>
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

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d29afc4be6a7..39ea9c51a24b 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -905,11 +905,10 @@ static void smb_direct_send_ctx_init(struct smbdirect_send_batch *send_ctx,
 	send_ctx->remote_key = remote_key;
 }
 
-static int smb_direct_flush_send_list(struct smb_direct_transport *t,
+static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 				      struct smbdirect_send_batch *send_ctx,
 				      bool is_last)
 {
-	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_send_io *first, *last;
 	int ret;
 
@@ -977,7 +976,7 @@ static int wait_for_send_credits(struct smb_direct_transport *t,
 
 	if (send_ctx &&
 	    (send_ctx->wr_cnt >= 16 || atomic_read(&sc->send_io.credits.count) <= 1)) {
-		ret = smb_direct_flush_send_list(t, send_ctx, false);
+		ret = smb_direct_flush_send_list(sc, send_ctx, false);
 		if (ret)
 			return ret;
 	}
@@ -1297,7 +1296,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	}
 
 done:
-	ret = smb_direct_flush_send_list(st, &send_ctx, true);
+	ret = smb_direct_flush_send_list(sc, &send_ctx, true);
 
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
-- 
2.43.0

