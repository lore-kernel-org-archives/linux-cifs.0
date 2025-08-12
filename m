Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A602F745E;
	Tue, 12 Aug 2025 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021915; cv=none; b=Xsi1Dy4F9SQlAxkw8+O2FndERvO2bUvCQGhW1zLINGIRaBIr76BzXuhVQfbNZtB7nlI2WHUay1SnqNn/jtVnExWrkfe0TYcN6pOHzwtSO1Oq2JAtpP/YfftsH9wRFsnenRpZ+Kfyk8FIipksBvFU96yYllfn71gfUHM/4KSjJV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021915; c=relaxed/simple;
	bh=w2lwJB/tdlB559C067ziz0uS2t2Z4uAP3SJxane2rXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMM/WGPCCzvPiuiDw8xjndBKjd3m0jnRAjl+ayBxveI7Dy+ngTNnIE9vzJ2h03tYSoBTtKDphYTR4P+QHGXvmXleclJrJLr3CE1JwV1Og5WfXYUMRQfKJWXu+FmLKzqytWt9/ZNqQ9Lbd32jY9rn10miTxZuhDESIyb6F32SP8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAYotmQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAYotmQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872A8C4CEF0;
	Tue, 12 Aug 2025 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021914;
	bh=w2lwJB/tdlB559C067ziz0uS2t2Z4uAP3SJxane2rXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAYotmQBaMwGOqjQZMl1j7Mbh4tBLZf3ekG1tZtJt+J4phe3/iGegEyyW1pD8Sw2j
	 Crt+F/lKjilul8Lu0I4czo9kTQTRQ5jjK17OvYrobHpxC+0dmz8KZ6goojLSih31ok
	 giubb4mfTKW49r4bsbaOrnGHj8JMVwLIH/y+1yZM=
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
Subject: [PATCH 6.6 229/262] smb: client: return an error if rdma_connect does not return within 5 seconds
Date: Tue, 12 Aug 2025 19:30:17 +0200
Message-ID: <20250812173002.914031126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c7f4eb8c9a10..71aef565db5f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1647,8 +1647,10 @@ static struct smbd_connection *_smbd_get_connection(
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



