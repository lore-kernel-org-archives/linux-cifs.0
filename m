Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE201514DC
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491234; cv=none; b=Yc42cr+qshqxX3X0R66loEGB1uxhVjNpT2LfjBEh6rqemnMSRRn1nFlQD4k6rLIi/sH7zfiqcijtBGJ84jFmQAV+7tdRUn3OK3G8eor1SXe3u3Gz/VztGt4Jq4FmA7CnZH9sOL8ppIzel2wuax8McXCblPRF9UPzsCqS0M10I4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491234; c=relaxed/simple;
	bh=9wJ1b/zTfGLWp3IOhgawQv11dhw2rIl3V2Wc5LRNP5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGbYYxYeO3+0svyI6OlzIJP6UKh/uIao3pZoWWJi1zwayAkDZ8v03XcnyEqjn2rKf3Pi1CDLcJf84Rhtq2mWqWtZp5NOj6sKQMaWad86fwgSmgAuKOvuBnjqd3Yw/THSBdagdk2N08WdOXIeP0Rf39cuht99JEYxL1WXsWRQpCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=h64fKPZ3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="h64fKPZ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ZotanPfuqXC8gKv4kgZSupTobtQq+Z/W2VKej3T0u2Q=; b=h64fKPZ3QAMfbF0ut0VNFqMBO6
	9zsJtfvFAB2UPikMQdC08x9zxvQoO8U6kXnhRh5vWtTpzGVveLGvsKXyk1GvySRjuujff/iAWSt6n
	GtNBGzU+vM8FTzjtxl/mLegVNXLVAFPDKXZuV1kY9v1ug8d7XY1A5J44FH9M42JDe34KE8G2+iE1B
	/64+HUvkoiPRYbsJp/rzJyScJsOEwYSkkZqnTkL3P6nsKqnj1AMEOBM2BsRxHpoPKXakfZPnJg57G
	X26x5JU2d6K4fUEhC6JaMdPrgnDR4Mzi1ZpKeuQXD3SNNzQ+7lRDqsj1IcjCydIVVwOFo9nRxKax/
	t4TqJTuuN+hiitfWUIbl45EkuF8gx89RSHBrvYQ9ZSlcBHe9t3KAGFx4jLm/RM293IusSQ0+M6XGd
	TeuKuQPWLgr31rVN4jLDb0ZtC1nmQYCYj6Y73LmTxKUrGdpCH3PfHH+1HqVeGmIyJyM6mtXbQjAmu
	5bmpYyvQ9ZuQcT/9qL1ptGTZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rtk-005GcV-2D;
	Sun, 21 Sep 2025 21:47:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 13/18] smb: server: fill in smbdirect_socket.first_error on error
Date: Sun, 21 Sep 2025 23:45:00 +0200
Message-ID: <7a4ab9b767693f8b4f96ed85b9f83628d04b8c9b.1758489989.git.metze@samba.org>
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

For now we just use -ECONNABORTED, but it will get more detailed
later.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 67345c58bfe9..44fa0af21b45 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -222,6 +222,9 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 	disable_delayed_work(&sc->idle.timer_work);
 	disable_work(&sc->idle.immediate_work);
 
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
 	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
@@ -259,6 +262,9 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 static void
 smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
 	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
-- 
2.43.0

