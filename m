Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363FA49620
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491225; cv=none; b=l7gYU7nNbbD9usZ3z1drS0nY6jrdj71Hg25AWAfuFjdWnpFImWcckAaZ/0QVSFoj157AXgp9TuQg9DygDe/m4cRgU/CRs/Ycqg0UEJLoAP9IOo8i9GY9EcAIb/0gstrcDfOyy/kLibneu8H+f/F8l/Q3EQpU9k90lMV2ZuYWcgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491225; c=relaxed/simple;
	bh=Mp9q8Q+sJKMvP6hRC9s163YPqnSPw1AS8xzbOQ2fP0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfUJAC6Ir3NQaDv52PuVZA0vgYQGiqZ9Q5l0tWlquOrcBo/EGio6SkrlnlMCv3dV33hXoKTnmd5pfLpuMaIO4s4W75oKM7UmVlf8L4GSJk5nJwGWY0nVYdLYRu1mr8o3hrRAIgXgLFPYFpi5Ow3KtfdxgxuAYel2N6+0dGgqhnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0v7AbYCg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0v7AbYCg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=6BfYLkFDioZezMId5wyusiJbKPkT8rO/6WyQV68h0q4=; b=0v7AbYCgzDG7tIbV1uzpcD9dxX
	0epYDoiqLwogNZb1kVyRMoOPFp+XqVYeQHnvAmSkYgTVjPvPTr3SVywF6HnoZUY3PlpYGQmUuPkW5
	XJlczU4ZuH7HH8pkk/9rR+B6UB1NzaVp2eHoPBHvJBU7q59uL+QduJ1kzJ8OTYYN/iG35PyyOTkHd
	WEEJA0u0V7SVGlKgddiO/rRj+AuU0X+tsJ8FozGbg0zoY+k0aApfVaz8b2XoXbD8fjCB51A4U1Gpd
	5+dDf11aZ1oKQvvIF122L1Vk8J2A6Zvw9D6oUUcNfue/WqhLWGnv7kpNdFgi8VOQ4V1Y9Q/n4gBZO
	AU1TuUmzdWy+bQalgvOXS3NiCXfKHmzKauglg1VQtNkXK2eQWUjeM7hOMSrocBu33MWJYctu7myIG
	RgNCqHvlkB6L3uL3sAlcuIEbwB/bRKnlt8XABlsa7hHHnKycBtkJW6IrnQ87/zmDwR31HxL2G6ppp
	eaG4q916XUr5C2eUmmk1SVLN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rtc-005GZm-0I;
	Sun, 21 Sep 2025 21:47:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 12/18] smb: server: let smb_direct_disconnect_rdma_connection() set SMBDIRECT_SOCKET_ERROR...
Date: Sun, 21 Sep 2025 23:44:59 +0200
Message-ID: <f93ed3acdc20d019b290b274be60b6a2b5f54424.1758489989.git.metze@samba.org>
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

smb_direct_disconnect_rdma_connection() should turn the status into
an error state instead of leaving it as is until
smb_direct_disconnect_rdma_work() is running.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index a61898ea2a3f..67345c58bfe9 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -259,6 +259,46 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 static void
 smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
+	switch (sc->status) {
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
+	case SMBDIRECT_SOCKET_ERROR:
+	case SMBDIRECT_SOCKET_DISCONNECTING:
+	case SMBDIRECT_SOCKET_DISCONNECTED:
+	case SMBDIRECT_SOCKET_DESTROYED:
+		/*
+		 * Keep the current error status
+		 */
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
+	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
+	case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
+	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
+		sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
+		break;
+
+	case SMBDIRECT_SOCKET_CREATED:
+	case SMBDIRECT_SOCKET_CONNECTED:
+		sc->status = SMBDIRECT_SOCKET_ERROR;
+		break;
+	}
+
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
 
-- 
2.43.0

