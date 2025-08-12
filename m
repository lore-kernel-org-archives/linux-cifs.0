Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7241D416C;
	Tue, 12 Aug 2025 18:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023120; cv=none; b=EdEjtFSEvD9hWfMp4MsqPiK6yBoBYwunAdXtqZRjBeDteD+VgrCi4wWY8puiTYP8M4oQSQdeob8vadnyaX1ylU8JyJDCDdVUGOmlXoRe70nVprNzFJ/00odAmBQbdrUVzM+W5GyolhSo6spu21Vo1m74sF6Oyi5brVUgJUV9PMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023120; c=relaxed/simple;
	bh=duAXvz2RDxtSL7kkLMyXCpRmEckD1Btm5X4vxnX2R/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lcr0gWRlWEPn5uSe3qcOPCOF4FJrCRzUGaoCqh7veGESGtsdFvScRlOiQtYt9MrIUm9dmuL3D1hc1d6I8/I57lIrvOizYZsBPZ5aT72cDen6yTTYHCTeNpAVFYy+ceXj94uu6RFOak0qp8MFstnab7CVSMNU1RI9aZub7G8QZqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLj5brmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLj5brmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF027C4CEF0;
	Tue, 12 Aug 2025 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023120;
	bh=duAXvz2RDxtSL7kkLMyXCpRmEckD1Btm5X4vxnX2R/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLj5brmwBiDI0695l/VtexqIJv8huCZFwAfu5QkgDBScCwl/o0WnsTpWui8jr4kRV
	 kQJhmD82j3rjeGxGczslgnQsQ+GEROV5awvN5nmokZBfO1TnN8w9/xpUSTAGD2hbKY
	 tXKXnzr0TfoJFfVi9ewPifpPy5ipgJPzx0WdWt3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/369] smb: client: return an error if rdma_connect does not return within 5 seconds
Date: Tue, 12 Aug 2025 19:30:19 +0200
Message-ID: <20250812173028.830747662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 03537826f77f1c829d0593d211b38b9c876c1722 ]

This matches the timeout for tcp connections.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 47f2a6cc1c0c..60b160219f0a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1636,8 +1636,10 @@ static struct smbd_connection *_smbd_get_connection(
 		goto rdma_connect_failed;
 	}
 
-	wait_event_interruptible(
-		info->conn_wait, sc->status != SMBDIRECT_SOCKET_CONNECTING);
+	wait_event_interruptible_timeout(
+		info->conn_wait,
+		sc->status != SMBDIRECT_SOCKET_CONNECTING,
+		msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		log_rdma_event(ERR, "rdma_connect failed port=%d\n", port);
-- 
2.39.5



