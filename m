Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFBB2F5E;
	Tue, 12 Aug 2025 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021853; cv=none; b=o7d55nQ4Nxe4i77Ayd6tjVkAZqnyhNlYapS2j4Rfl1dn5IJxMRBNadu/VLMkQlKKGHsk06ZlgpO45K9MgmdInXst4teWrWBAKBVGeu2w+YIyRE7qIo2xGCRuxK86ZrLynLt89QnHA+arVwGdfJEM+MW/oOuIaoRRZrsfx40w5NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021853; c=relaxed/simple;
	bh=U8BYxjoiJOawlEhVfsSfXO3uSUZ56cIGq+CiYsMiz7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXYctBxwXo7A3kt7mlA6yCET+HtVra8Vbp2YSTfYVDbgWXPJr6WVa5FiH93+cVY2tGt3AMh+Nqzr0JrGmnRUz5eS4mRpGifWXZQdP3Xdr7kVT00884q/sUFwkb39Ij+PGONdE2CqY1IBtNOi2QJVli59X1/AdIrE3jc8+0zxlF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIqEIFhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIqEIFhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80282C4CEF0;
	Tue, 12 Aug 2025 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021853;
	bh=U8BYxjoiJOawlEhVfsSfXO3uSUZ56cIGq+CiYsMiz7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIqEIFhT4hcuSyWG20Y6+grxD/Bc1xmFqEyk8fjqXZX99YUVYUf8ExKSIlSLIAgLB
	 Of9uVUWeUuZwwbTup4bHuyKA4L7GVHpjkJuDCXenX0ePwLIBrjpkC6y0CrEU0Lsa0v
	 BAhG1xPnEWvi7p/fFkkBYxNUcstcqCIB40XNGUVE=
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
Subject: [PATCH 6.6 227/262] smb: client: let recv_done() cleanup before notifying the callers.
Date: Tue, 12 Aug 2025 19:30:15 +0200
Message-ID: <20250812173002.823566955@linuxfoundation.org>
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
 fs/smb/client/smbdirect.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 49aafb58c7df..c7f4eb8c9a10 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -467,7 +467,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
 		log_rdma_recv(INFO, "wc->status=%d opcode=%d\n",
 			wc->status, wc->opcode);
-		smbd_disconnect_rdma_connection(info);
 		goto error;
 	}
 
@@ -484,8 +483,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		info->full_packet_received = true;
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
+		put_receive_buffer(info, response);
 		complete(&info->negotiate_completion);
-		break;
+		return;
 
 	/* SMBD data transfer packet */
 	case SMBD_TRANSFER_DATA:
@@ -542,14 +542,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
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



