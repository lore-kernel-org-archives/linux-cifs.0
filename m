Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5B74A43E4
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 10:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541724; cv=none; b=HQ7t8u+o1GX4zvkCNFZzTuqG98iq1KLXfY2/ilbLoTDcvjbynBNiIDkG1K3ahCIZ2FLiUtUSomk+zbv2tyA/pbbC7YsMXh97yIb1pzXfPClHx2SXnDmiNbuxUzh/TC94xBbhRrFP+sHkKMywcQ8WID6OElHCuK6vMOkimG+MUp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541724; c=relaxed/simple;
	bh=uM1cVDPSzcTyuhCAZ/hSzycg6zV2b8DvjXcxp/HCxLE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RJ+XDX7NpQL0OMt/vvhdHUMutvx57n8I7JQYvAZ8F1OE0oCbuzbFdACyI5NthInwLBC6A0qV0fMeCdMiT+EorC6x17MbxVtLkceN/aXYXhzSbXoVyI0jvR9ZVfIsslWoEVaMYDqhyfE6YdH1AexAbPCLapejsrvTWFDEKkb/t40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0AdeFgkD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0AdeFgkD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=GAskWK3hyDZABRQhX4VY496H96XcuaCVWmIhrHbEZ0Q=; b=0AdeFgkDk5bsNHYnqLzXpL1UAz
	kZOxBYrH8sgn+VC2yyZ6Srgfu86Px1+GDMgM2dH0PCxVxvkCF6+TNXvGUpYwvoIv+wj3bN45Zy3yZ
	oso1yiQN4f1dRemS7Y6PdFUKS3nVPSb/83wFFFKDLDxWPatLupxi0dUkvGjdHHqlAdxlARXQbpcA3
	FbMU1rbI/qAQwlomLh9Kkg3bM7OTwrJUqTWKICpeb/aLtcTa5Bj1BXwscYigEoqY3znqDTruX6SW0
	rBOHmVaYwqw4tMEmKzMjC3iflq2xGS4+km/hS7QaaZR7LAGtg7UwHM6BGQBLLMg9gNa2D7RCK2nKf
	Lo2G/se7Ks8lwQS6FvTRllPOuokGNE0jINPWvK42H88c6ZeE8wqH2LkjUJNuvqizlyue8+efYKzbx
	Cl1kC4YiqQeXuDZsdnb+zZM+KDht1rFXqT2iQSlf2uK4HXUU+1S49xVr0913FakmFskiu/nml48Uz
	MJ4TsJOXcNZ5iCbFms/XaLqx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xF7q5-00000000TDo-2rZQ;
	Fri, 09 Oct 2026 10:28:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: smbdirect: don't WARN on an unexpected receive opcode
Date: Fri,  9 Oct 2026 12:28:27 +0200
Message-ID: <20261009102827.1785085-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The receive completion handlers smbdirect_connection_recv_io_done(),
smbdirect_accept_negotiate_recv_done() and
smbdirect_connect_negotiate_recv_done() verify that the completion is a
regular receive with WARN_ON_ONCE(wc->opcode != IB_WC_RECV).

But wc->opcode is controlled by the remote peer: a posted receive work
request is consumed not only by an incoming SEND, but also by an RDMA
Write with Immediate, which completes as IB_WC_RECV_RDMA_WITH_IMM. An
unauthenticated peer can transmit such a message, even before the
negotiate completes, so it reaches the accept/connect negotiate
handlers as well. With panic_on_warn set this is a remote denial of
service, and otherwise it still taints the kernel and spams the log for
something a peer can trigger at will.

The opcode check itself was inherited from the original client and
server recv_done() handlers (fs/smb/client/smbdirect.c and
fs/smb/server/transport_rdma.c), where an unexpected opcode was simply
logged and the connection was torn down. Only the WARN_ON_ONCE() was
added on top during the socketization rework. Drop the WARN_ON_ONCE()
and keep the existing graceful error path, which logs the unexpected
opcode (unless the status is IB_WC_WR_FLUSH_ERR) and tears the
connection down.

Fixes: ea4151222a93 ("smb: smbdirect: introduce smbdirect_connection_recv_io_done()")
Fixes: eb3ed1e9048c ("smb: smbdirect: introduce smbdirect_accept_connect_request()")
Fixes: d1f187656797 ("smb: smbdirect: introduce smbdirect_connect[_sync]()")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-5341a0c0-7b00-4eef-915c-91e099649d3e
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/accept.c     | 2 +-
 fs/smb/smbdirect/connect.c    | 2 +-
 fs/smb/smbdirect/connection.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index e7e5eb75a5ae..85e37d11f43d 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -234,7 +234,7 @@ static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	struct smbdirect_socket *sc = recv_io->socket;
 	unsigned long flags;
 
-	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_RECV))) {
+	if (unlikely(wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV)) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
 				"wc->status=%s (%d) wc->opcode=%d\n",
diff --git a/fs/smb/smbdirect/connect.c b/fs/smb/smbdirect/connect.c
index 34a3e72c38fb..0d02f03063ac 100644
--- a/fs/smb/smbdirect/connect.c
+++ b/fs/smb/smbdirect/connect.c
@@ -581,7 +581,7 @@ static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, struct ib_wc
 	struct smbdirect_socket *sc = recv_io->socket;
 	unsigned long flags;
 
-	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_RECV))) {
+	if (unlikely(wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV)) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
 				"wc->status=%s (%d) wc->opcode=%d\n",
diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index f48c857bda5a..e6c7b343fe87 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -1529,7 +1529,7 @@ void smbdirect_connection_recv_io_done(struct ib_cq *cq, struct ib_wc *wc)
 	u32 data_length;
 	u32 remaining_data_length;
 
-	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_RECV))) {
+	if (unlikely(wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV)) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
 				"wc->status=%s (%d) wc->opcode=%d\n",
-- 
2.43.0

