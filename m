Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15B32417F0
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744315; cv=none; b=ZRLTY12IJ4VRekB/XUYtf/RDzMyFCyC7MiJFP7FlRlzuXFj/UBB94lL5Vfm8ZL6uw7F+s1RIOCQYtIfR8MxjJkeT2VxmwTl/alkLzxOHEq7KUU8D1i3sl5hl8kty+oPBB6EMvTgclvcN/ayVGOnasEGhDE5FG1kPxhSEbgA+zw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744315; c=relaxed/simple;
	bh=Yr3271U3ux/xVQvV5fVYOXurwtPOJX7qqMuWMSMCD0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ok1fDGaTq2fzs7Vc781ScTDpZxP5mSyiD2RceUJgcue3EKk+DNj1wZUfvoKXtxfO/aGVcbBKkezxDk3VpEF5AeNocpZaKKjyiBDofGhTE2FymGj/6J+R/mAAY8RBulPF5bK6q+sSp6naHJWyrikup2tyXi08RNSxAOSBjn6hrdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BHQgkVmV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BHQgkVmV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=qMtol8LfEKYyVhZP5fz4TwWHcuFOS6ENzD9lRkBS8Zw=; b=BHQgkVmVr1CV7VFTCS4F18rwK2
	KO5nG7+23ka00oy3d4NinzW+HaHckMZbt8E9TUwhhWL9rzcZXXD6EqjJUNuzeLBvqBI7qY/wgcA9Q
	8Eq2nv+GRqP+FoCQ+StFwmszuiRO7OfwPFWGJcCCm8mRXjWtQ1G2x322YayiP4TLX5mMxq+hpV/h/
	brxWqVnB4OQmrqSJqGVM8Plrn0suWKKCqaysvd4ll2vHta9yz953Uh1053WHT0VVsyTu6ojCzS9gL
	BiQ+QZfNc2EzVXWxtaqtoHUXBu8oYfvKfEiznymZ61UrmEXAmWoego+lYXcHPV/+N09O+9NOR5OyP
	DTTmC8bomBWotJ/zsN0ABtPi4Gnt5Ey0qgclISE4ob0gSaAoLGlrNFWm8E3Kb5NyMwkvZH3n6LPRf
	HLUcl5p/MHXNMrkMgjW7NCz5JLdQsNKIYb1ksgchTVLH9YjDfSJTA2NPJHOn3RaKr/u8s6aiL090A
	eiRPtQ19ofj04oxDjANX1SjP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Ao-00BbbI-0H;
	Wed, 29 Oct 2025 13:25:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 027/127] smb: smbdirect: introduce smbdirect_connection_recv_io_refill_work()
Date: Wed, 29 Oct 2025 14:20:05 +0100
Message-ID: <5c859b5966f6cfdae655fd1e026d2c1d1dde2db1.1761742839.git.metze@samba.org>
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

This is basically a copy of smbd_post_send_credits() in the client
and smb_direct_post_recv_credits() in the server.

There are several improvements compared to the existing functions:

1. We calculate the number of missing posted buffers by getting the
   difference between recv_io.credits.target and recv_io.posted.count.

   Instead of the difference between recv_io.credits.target
   and recv_io.credits.count, because recv_io.credits.count is
   only updated once a message is send to the peer.

   It was not really a problem before, because we have
   a fixed number smbdirect_recv_io buffers, so the
   loop terminated when smbdirect_connection_get_recv_io()
   returns NULL.

   But using recv_io.posted.count makes it easier to
   understand.

2. In order to tell the peer about the newly posted buffer
   and grant the credits, we only trigger the send immediate
   when we're not granting only the last possible credit.

   This is mostly a difference relative to the servers
   smb_direct_post_recv_credits() implementation,
   which should avoid useless ping pong messages.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 959b0c49857f..95e212877e9f 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -881,6 +881,98 @@ static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
+	int missing;
+	int posted = 0;
+
+	if (unlikely(sc->first_error))
+		return;
+
+	/*
+	 * Find out how much smbdirect_recv_io buffers we should post.
+	 *
+	 * Note that sc->recv_io.credits.target is the value
+	 * from the peer and it can in theory change over time,
+	 * but it is forced to be at least 1 and at max
+	 * sp->recv_credit_max.
+	 *
+	 * So it can happen that missing will be lower than 0,
+	 * which means the peer has recently lowered its desired
+	 * tarted, while be already granted a higher number of credits.
+	 *
+	 * Note 'posted' is the number of smbdirect_recv_io buffers
+	 * posted within this function, while sc->recv_io.posted.count
+	 * is the overall value of posted smbdirect_recv_io buffers.
+	 *
+	 * We try to post as much buffers as missing, but
+	 * this is limited if a lot of smbdirect_recv_io buffers
+	 * are still in the sc->recv_io.reassembly.list instead of
+	 * the sc->recv_io.free.list.
+	 *
+	 */
+	missing = (int)sc->recv_io.credits.target - atomic_read(&sc->recv_io.posted.count);
+	while (posted < missing) {
+		struct smbdirect_recv_io *recv_io;
+		int ret;
+
+		/*
+		 * It's ok if smbdirect_connection_get_recv_io()
+		 * returns NULL, it means smbdirect_recv_io structures
+		 * are still be in the reassembly.list.
+		 */
+		recv_io = smbdirect_connection_get_recv_io(sc);
+		if (!recv_io)
+			break;
+
+		recv_io->first_segment = false;
+
+		ret = smbdirect_connection_post_recv_io(recv_io);
+		if (ret) {
+			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
+				"smbdirect_connection_post_recv_io failed rc=%d (%s)\n",
+				ret, errname(ret));
+			smbdirect_connection_put_recv_io(recv_io);
+			return;
+		}
+
+		atomic_inc(&sc->recv_io.posted.count);
+		posted += 1;
+	}
+
+	/* If nothing was posted we're done */
+	if (posted == 0)
+		return;
+
+	/*
+	 * If we posted at least one smbdirect_recv_io buffer,
+	 * we need to inform the peer about it and grant
+	 * additional credits.
+	 *
+	 * However there is one case where we don't want to
+	 * do that.
+	 *
+	 * If only a single credit was missing before
+	 * reaching the requested target, we should not
+	 * post an immediate send, as that would cause
+	 * endless ping pong once a keep alive exchange
+	 * is started.
+	 *
+	 * However if sc->recv_io.credits.target is only 1,
+	 * the peer has no credit left and we need to
+	 * grant the credit anyway.
+	 */
+	if (missing == 1 && sc->recv_io.credits.target != 1)
+		return;
+
+	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+		"schedule send of an empty message\n");
+	queue_work(sc->workqueue, &sc->idle.immediate_work);
+}
+
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
 					   struct page *page, size_t off, size_t len)
 {
-- 
2.43.0

