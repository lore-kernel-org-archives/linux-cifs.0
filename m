Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021397;
	b=r/yo9ORHEzewDIEw8dDECJWaa4D89ZSZgRhC38P8RJIL+XCBUi8l4zoTQNPl1CM2LcKG
	 JY9showRJq9mqUguPGDT/yuozZLU2oVljHM3wT6HyUUE0PH0twN4uhU3sut1KqiXbOZ2d
	 jsZkom/62GMxdIMAjDZP/q7ulQBKY4SEOS9VTSoDmY8zSFa3s3XaOFrWIU4yj8nf5aw+Z
	 nEZvMcOhRw8a/YN45AuLivzyyve/nOCDWB44OCox7QCEBQ7I/0pIMnFQuYoEfZ1ESa2SC
	 1KpZ7RkypvLz4ZLYoHLFocEP7UKL9ejeH0AWqdjNIAZfqLx+WWyNC46VKksKy8ueRBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iTY1lbaX85ZZF8yhJQgU4/tNPXBzBV/60zqI7qvuuCg=;
	b=gBQVKwcMWp03YuO7/3X0GRzPlxZmBbRm5G7tyZSfF1ky6cVUnghjgTN2AyJjLgjsgBS6
	 9iN6BQsB8JEy8D6TuwZblBoWo/Mu6Tseyn1wuoco0pi4IlpVZctcr/JbqmUOLnVs32cFP
	 VGlf0r7jni9vRFZunHbUX17th9lErIAnEWsWzCYspVwu6MZiWgk56njszqKWr7tCDsIZQ
	 gttnM+5smmjidGn1fXP8y+gu5q+V9k0h0U/ryVtXLBVPdxYY5t9txqnf4tjyD/7bJA6oD
	 KLAdZyOBFvzsP5YFJhwrPsRJWZU5R3SZ6/NcEFG/sy9hyEbD7TzC9YPuSEjxjBjgyHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjK1DRoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF80606A31C;
	Wed, 18 Nov 2026 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjK1DRoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AC21F000C4;
	Wed, 18 Nov 2026 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021397;
	bh=iTY1lbaX85ZZF8yhJQgU4/tNPXBzBV/60zqI7qvuuCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjK1DRoAfvtk/dH6Kt+SbYuHMJmNqbku1gEAVeef7fVpdb3GkF4EJVMLiOkDCCrkE
	 OdZj/E50ZwUwKKodtYs/GH0sOVDPo3kmTRP+KTFLzkiYIaIoqDspifIZqNHZdIz35M
	 40WuWF17iOosJjguKfkk51DZWuwx08AYE4zEt770=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2293/2651] smb: smbdirect: dont WARN on an unexpected receive opcode
Date: Wed, 18 Nov 2026 15:58:53 +0100
Message-ID: <20261118150407.804203114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit e8592dec2e935befe842f90f4044d210f59c4d30 ]

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
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/smbdirect/accept.c     | 2 +-
 fs/smb/smbdirect/connect.c    | 2 +-
 fs/smb/smbdirect/connection.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index e7e5eb75a5aea..85e37d11f43de 100644
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
index 34a3e72c38fbb..0d02f03063ac7 100644
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
index f48c857bda5a4..e6c7b343fe870 100644
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
2.53.0



