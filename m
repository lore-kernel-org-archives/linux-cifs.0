Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B60C2F9992;
	Tue, 26 Aug 2025 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215990; cv=none; b=H5pCzs++nZK0zdD2CnU+qeiYZHHyEHfBPcncerOpOPvEYKoOtTMpAj36QBaU/V9hEcpVQrsBLdl6M+lvH2thcsh9ZROhDHXHJwm5w82wme/n0GV4ItiYZuDAk4j51jYIfdqIgolJ6AgArK6catGj7FbFj24PFe4x9U3w1SrfbXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215990; c=relaxed/simple;
	bh=yWxJNDCOiQwS/rUK7cdBQvVh4np8cDa6wT8v1fSbqxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk9d+3Sz+Ouw1ur/cSYpVtyUuhUTtlk8qxgUgwvAvc9F6M9B1TMGo32ylU8qnNURA3e4170jdcc/TzDb7ZX/n8nqbpywWxpqHf7I3BOrUsgOzx2lUEiuWI847cZec5ZDsOPuKBnH7aHB/I3rzQ7V9kK3CMQ6DAbp32CY0o5s0JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b733rPJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b733rPJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A304DC4CEF1;
	Tue, 26 Aug 2025 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215990;
	bh=yWxJNDCOiQwS/rUK7cdBQvVh4np8cDa6wT8v1fSbqxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b733rPJvNVd3nv5mAgxLe6HptAl03jjMzAMcGCv+5kG94Xoz0mEHR6K5t+pquKLT+
	 nAIkZLm9ijD+y3hRIWJt4taMYTLwUkOirD+KE4xU7L4pffL8d+3mB5bXz3xWYQaTp2
	 u9d4NGor6xMRS3rxjstgvv0R84/3EqMbxaIVXnU8=
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
Subject: [PATCH 5.15 243/644] smb: client: let recv_done() cleanup before notifying the callers.
Date: Tue, 26 Aug 2025 13:05:34 +0200
Message-ID: <20250826110952.416232907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit bdd7afc6dca5e0ebbb75583484aa6ea9e03fbb13 ]

We should call put_receive_buffer() before waking up the callers.

For the internal error case of response->type being unexpected,
we now also call smbd_disconnect_rdma_connection() instead
of not waking up the callers at all.

Note that the SMBD_TRANSFER_DATA case still has problems,
which will be addressed in the next commit in order to make
it easier to review this one.

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
 fs/cifs/smbdirect.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index a9a5d27b8d38..48bd879349fb 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -455,7 +455,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
 		log_rdma_recv(INFO, "wc->status=%d opcode=%d\n",
 			wc->status, wc->opcode);
-		smbd_disconnect_rdma_connection(info);
 		goto error;
 	}
 
@@ -472,8 +471,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		info->full_packet_received = true;
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
+		put_receive_buffer(info, response);
 		complete(&info->negotiate_completion);
-		break;
+		return;
 
 	/* SMBD data transfer packet */
 	case SMBD_TRANSFER_DATA:
@@ -530,14 +530,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 
 		return;
-
-	default:
-		log_rdma_recv(ERR,
-			"unexpected response type=%d\n", response->type);
 	}
 
+	/*
+	 * This is an internal error!
+	 */
+	log_rdma_recv(ERR, "unexpected response type=%d\n", response->type);
+	WARN_ON_ONCE(response->type != SMBD_TRANSFER_DATA);
 error:
 	put_receive_buffer(info, response);
+	smbd_disconnect_rdma_connection(info);
 }
 
 static struct rdma_cm_id *smbd_create_id(
-- 
2.39.5



