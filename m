Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B143649620
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491274; cv=none; b=esa+AVAqVQLukyxsRF7GmqA9M0VDPpqEzFXFgCiRecYUJKu2+XQ6ERUsnSfPBquajsoraHiHjno46uvBI4ugSD1c1X2xOgnpn3xe6ISRbVAZCeDU5ljPpPtPODwgemBUK3w4HECKBpSS8BsxWxXOz+wczmWvzj+Fh/JEDyLUz3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491274; c=relaxed/simple;
	bh=rYTuZNsS4bZM2jEpO32MIyDJtzXCv3RRRnfgSmQ0YhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmUv8XLku6RZp80OuAIIwFULiJ2hV3aWN1XWZ3flwJ6mRD9j/H21g/XBfoovwRIriOQNB8BlBT3l3LEzOya86+0DgkIsAnmTN203ReCzbQgEkeDrnjh6eZ993AoaOf+SKkWZ9QoK3JB6uGDirPEC91RW+uc/hXVwE3LwNUVZOYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WgJfKfug; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WgJfKfug"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=eGimAKJXs+O7+IotBmTffj2Ph+qzQDzrvWKV4LdUPe0=; b=WgJfKfug/OaTHnA57oS4xq/N8J
	BbuTMg7pULZSJcjpL12fJkJkhi8/IdM5su1ufP+ETGADXAnKwOKwEEuWo4cqyMSUIoq5zlxYJ+SBy
	LOeSLEVHgir2pttYOqpYWBg0NCCMk3d8YWm3WLuTbWWIX0q3ePP/miyQZA+5XD4VGF7gtCtt42VRH
	wEZM8mttb03pdV+jAbBXw7KA8AoNBqtPFUZGRn/wO8EbRjKX7KJgP7BsdsCACjnKMU3Roq6Um5UPj
	6oFNoJa+BQ6IoFiU0lSxyvRtJZQmog7qvHKNDtszEO1sQBdb94Dj28RrMjGWOacTcl9gIZy05bqa+
	MnaNyvFD0eR8euFz/CkVeZiji/5XDcmPGY6EP9cxBr/4o4QWFTIBnXQ5OiXwdcZHhofZEb9XzZojT
	+QUIeY+Vx0jJj8jEENqqQ24iEgryl5WCiqVg3vK4SrBGoZ3VsM2LQuklHeh2oWLudbueFYaTZ7PCL
	pVPremGHvq4aigqDK4JwACXd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RuN-005Gkl-2G;
	Sun, 21 Sep 2025 21:47:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 18/18] smb: server: let smb_direct_flush_send_list() invalidate a remote key first
Date: Sun, 21 Sep 2025 23:45:05 +0200
Message-ID: <46360e2837bb22fd31c595f803f5e38f389746e2.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we want to invalidate a remote key we should do that as soon as
possible, so do it in the first send work request.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index e78347831d2f..27e3fc5139cc 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1017,12 +1017,15 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 			       struct smbdirect_send_io,
 			       sibling_list);
 
+	if (send_ctx->need_invalidate_rkey) {
+		first->wr.opcode = IB_WR_SEND_WITH_INV;
+		first->wr.ex.invalidate_rkey = send_ctx->remote_key;
+		send_ctx->need_invalidate_rkey = false;
+		send_ctx->remote_key = 0;
+	}
+
 	last->wr.send_flags = IB_SEND_SIGNALED;
 	last->wr.wr_cqe = &last->cqe;
-	if (is_last && send_ctx->need_invalidate_rkey) {
-		last->wr.opcode = IB_WR_SEND_WITH_INV;
-		last->wr.ex.invalidate_rkey = send_ctx->remote_key;
-	}
 
 	ret = smb_direct_post_send(sc, &first->wr);
 	if (!ret) {
-- 
2.43.0

