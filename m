Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8913A2820D1
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666905; cv=none; b=ocuMPqLOROkPbiWtSuCD+ril6e1gEARouku0MKnBOv0Z6xO9QnjiLzXFugzoxXjsybovswP+2jJAGH8ta+YqWn6tpDjfAQSAgAmrA9oaKQRJMkmwBpeCIwVV+Auhj7nLJI0JBfj34saWY3VFFpHF3AotufEPhsgbFn3FVtnHRD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666905; c=relaxed/simple;
	bh=8QwkSn50HNeeF9ZbXYFXJm8sbnGoSBWCzX/ghnRViWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXzjc0QgX3SnTPuuk8rPE9y8R89xAA9HbD32jxZZZwd/tKhl5Ru+BLpNGNNx/3JidlilLzaIAOEyeVLF+LQtFB9BCDuSsDgwiwfCyN2vpwkiq4jPFpDuU3rC0qa4mbaciOYzInIPjVyRt29GXQJLwkG3lnLQQ+B9UPjatxjCI/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=y5c/5ZR3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="y5c/5ZR3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TpE2TzPqL1qNot0BgtzwshC+rsQCLDpwLvbzx3G+x1k=; b=y5c/5ZR3qANRHgHPxkFbrH8l+j
	zCKwwjDT6tADUVSF7h/E/JvikO+dyKCHmnypfDCi911Kn3YXQUAaKbl6vYctStKEXMhRBx2dCQi+6
	mzWzo3DimotL335UozCEu3FqBP9N6inQyboed2mAcPhc7O2IdsjeRVyv6iWw8r8tVpdMP21NUrCoE
	xnmVyKda12L0onyXeKGK+oPr6f88glOJFxCKDY6SVFPGJTcZK/Ij95UH8uhhkIHN2F8JjNO+FBNdK
	1kcwkwXSTI8jNssB0FSIt744vxQm5TTEN1ze6BbtOoJ3rMsE2c0GWT5nXLr5CNo4pvOhYml04dMKQ
	8aIa73sAiBaS+I3Dmlq+YWts1vOy3OaUkKjkQGzVuM5a1gLO7ssBoGv7hOYhW0Csp5KqQDF0Ufoga
	cw4INOZuj72TCyZouSxlcQMwVbSoucjxjtKF8w5JKTdYwMa8fPGcyNwWbznGBhJ2PQ+vGOjizFNDF
	KZiSMjRDX8UxXmTIkVJuCPJC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukP13-001pNw-0E;
	Fri, 08 Aug 2025 15:28:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 1/9] smb: client: return an error if rdma_connect does not return within 5 seconds
Date: Fri,  8 Aug 2025 17:27:59 +0200
Message-ID: <2f31432cef778fbe2418fef7a76df811c464432f.1754666549.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754666549.git.metze@samba.org>
References: <cover.1754666549.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This matches the timeout for tcp connections.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 6c2af00be44c..181349eda7a3 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1653,8 +1653,10 @@ static struct smbd_connection *_smbd_get_connection(
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
2.43.0

