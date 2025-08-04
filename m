Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8EC248F7D
	for <linux-cifs@vger.kernel.org>; Mon,  4 Aug 2025 12:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309525; cv=none; b=Oael8HBz9PuzMS43vZtzoe54NqDL/A5LbS26yjiGJZUVu7AMC7qDLwCl4t3HftIq6nyZWRwnI1A4ksc12VAczuNYvt/oGkQJwwLcJuFAKYzJyxuUYZD7X9fj+1EN9Oq420aF+3kRny+mK6/0wWqYdNiZxE7r9lS5nV9fedqGdMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309525; c=relaxed/simple;
	bh=f4OyzPQhljJt+UBrUSY+zA0mPPfoDA7VT6ZNJ/D60Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG4m3ONHBHiJUI0AlXygY7Ga7wAsH+MB/oLhYLCiLFG4iaBuY0ijJuqlWiVSKpeiHvp6eRZB4/zfB8Gn9eCxCdPcVgGgoQigTrYsqqqA0NUKFZHKd96fYTiNzpBIczVv5PcV33RTNwAA8ER/24JnMcYFy172OvkntwhZBJLY8XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IT3Ux1rz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IT3Ux1rz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=CdYFXYJEModr6o2laAGxuweVh0CJ07+3rQ+j6A2kOL0=; b=IT3Ux1rzLafu7K1AvIxpC9kgbK
	/FA45Owwzaphzh5XkRmylXlqnfsE+tbxvRFiNnHtolOj8Bj+xTac/YyqyverI4BHt76wHloRPHeRG
	gfSxEA0UkjmnyoYlXU3ilpU5mGqpsNB5YNiZywT7OIiShCPsCjjFMqCVW3n/clHm4dhK5x9h2lkWY
	SZF8a/cAVt+SYPTVfoTkSyCRTMrxIkmxiuX2VarZ7sLX81RnjaqU9j8FmY6F2cmBXTApvjbuLiEas
	GqNLAU0M/MfJ5l8i5yvwOCRFg3mn94QqBUZUHBOHC7PLS2drZaJW7cjL10LjVPCPs2buIbC9sbRmj
	rGoJYHNkV/4edlevgdbzh9D1lAkFOdQzLfAAGucSbAX06J59Wy84NWOKsSYm55XVMs3t4AHUfPyOx
	KoedcGMSZWRXWva8le6viA0AByLcEcbLJXBzOlhdi5UCNS+YZzMe4lMe5dhkRwPTBwWvEFz3vhmpI
	pmGJ3BS+oTpiutAao3wEHT06;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiu2p-000vxF-1T;
	Mon, 04 Aug 2025 12:11:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 4/5] smb: client: let recv_done() cleanup before notifying the callers.
Date: Mon,  4 Aug 2025 14:10:15 +0200
Message-ID: <82981763ec07b3164d16c7d797118e98dcdeb676.1754308712.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754308712.git.metze@samba.org>
References: <cover.1754308712.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/client/smbdirect.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a32ebb4d48a2..21a12e08082f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -454,7 +454,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
 		log_rdma_recv(INFO, "wc->status=%d opcode=%d\n",
 			wc->status, wc->opcode);
-		smbd_disconnect_rdma_connection(info);
 		goto error;
 	}
 
@@ -471,8 +470,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		info->full_packet_received = true;
 		info->negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
+		put_receive_buffer(info, response);
 		complete(&info->negotiate_completion);
-		break;
+		return;
 
 	/* SMBD data transfer packet */
 	case SMBD_TRANSFER_DATA:
@@ -529,14 +529,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
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
2.43.0

