Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE882FE598;
	Tue, 12 Aug 2025 18:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025099; cv=none; b=HPH9sPCKfTD/2W5BiZUMoIrlWwhrKBNX3EqkfZ1W4j+U/fFX2mqpIZMfDMMewvBMvA1vq7EPnwAwZn97/Q4PIcwcMQnzJBXUc3sqcMII4zRr8XnbLfeTgyNDiwWs/jWHCsa5LMgpm0O5U6dKYoQdetFfQMNXtjkWCEEYpRVZpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025099; c=relaxed/simple;
	bh=C7EmWK4JZbY66OWGnGx9HNRcJDXezGcE6e4CDlHpvQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+HjtZWNxgKVR1c7cTb0nM7UGe4kAgyyCoIKOyCbm2RtDqS4Mwo2hVS5yU8i9I0RerO/fh4ILVU1fw7CMeiPlKdkYCf7hP0uNI/yK0gMEXenWOaAmFT7uQjasLqB+3NDRm1lvcsezgZpCP45datq+f+/LJWsR0gQOzja9tZv0oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAepaCXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAepaCXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA879C4CEF0;
	Tue, 12 Aug 2025 18:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025099;
	bh=C7EmWK4JZbY66OWGnGx9HNRcJDXezGcE6e4CDlHpvQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAepaCXI1vnLhf6tpwdJpmClukYCUXh6VFregyXFMigFqiaDksnhWfPzsz73SwCEm
	 l0Jkl48fdkh93/eGl9h8jZSy5Nh+7/EfZfseX0h4h8MZ3OM2PkaET2Un75MiYHug5q
	 G92IXumPh3xKKiLZ347XPz8EG5NILsvqubRZexIk=
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
Subject: [PATCH 6.16 570/627] smb: client: return an error if rdma_connect does not return within 5 seconds
Date: Tue, 12 Aug 2025 19:34:25 +0200
Message-ID: <20250812173453.565501067@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



