Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4FA217F35;
	Tue, 12 Aug 2025 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026761; cv=none; b=s+HDdT3zTOkX/Wsm8va1WFBNvhNfS8fVDs2kpy28Xc8jnExE1VvoPbI9BSjSl5DieYF7FBFizYKdkKKbHs3nTBpXCtWXK/skSUu1zvKozpRDziZhJH2hTwxU7v8wIx45V7mj3yS9iSmW0eibYOBovGY8BtDiwwlZblpBtgHGVEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026761; c=relaxed/simple;
	bh=0WvaBwUyXo1BhGC2LL+3zAm3Ov/ke54cDUD1yHt+h3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG5CxQEFrq50qP6jgMsiaKRT/70UMc8UHAy91P5YoDYgoO+ubdP2OLmInSQIP6gKU9mwlSFlzy9So3m9RP9fPoBh+hhG3S8CTJPJHTr+h4gAMEfsrUL7qibpQLPjBmE+wliKOXuPxwytuo4PKH4dyMpNzmFJQp2hoEpIGtRD6Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQQ+Rm4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQQ+Rm4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72214C4CEF0;
	Tue, 12 Aug 2025 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026760;
	bh=0WvaBwUyXo1BhGC2LL+3zAm3Ov/ke54cDUD1yHt+h3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQQ+Rm4llmlkSvJ19KK8vnfvqkZKxSRvuLbBHD2p3K26B2uIBQk70bzbAK+nzMYfH
	 1GoOKetXQBzWyJoFUPiuJWdd2+9bh6azvpFD7sme8G+ZhUE1V11JAPngc61K2JFiYq
	 0jA31nYu1Foy3PKkOR6ZFmjjZW6HVyQwK0iMUhDA=
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
Subject: [PATCH 6.15 431/480] smb: client: return an error if rdma_connect does not return within 5 seconds
Date: Tue, 12 Aug 2025 19:50:39 +0200
Message-ID: <20250812174415.175148166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



