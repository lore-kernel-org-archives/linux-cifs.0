Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D12186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671719; cv=none; b=dalrTqUrnL0smmajrdCJdcXOQ1aJfOMS9JQnzAD7yCI6sm4FiJK3o4nRmNfO6BTleH5XDkJTodK9slxHB+uejUJ2S194RX574nXEVt0B33eUVVWLjsMn/7OzoMZ35t10lDXd5wOS/LdrfZhbALZwp3kYkyJBMkTvff0p30HsCvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671719; c=relaxed/simple;
	bh=8QwkSn50HNeeF9ZbXYFXJm8sbnGoSBWCzX/ghnRViWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF4/DwCvIcQ79YJ+j/Bpw5zxt182ftZJ/m1+0nh5BZmlZfjQaPajt1qqawUfVW32sAhDpH4VV5cuSMhmCXZaSOwae52WARjhGuzJZc2EViaQcMAh+sWD+v+0YhQe69lbxuk7I6ZFE/u5yCqgdJhzyjXBHMtJKcWUYcRgoSy/yao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tqlamkKV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tqlamkKV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TpE2TzPqL1qNot0BgtzwshC+rsQCLDpwLvbzx3G+x1k=; b=tqlamkKVz3WaoAV1aInuVYavdS
	DfzVKjP/Gwy5f0NbyqodOK8gXIG83or5sFJbP+SNaaH/PwyGvdajKG9g2IVEHDkzOh/m3XmZUMmPw
	L9kVP7YoRB5q1rElYIDgjnOM3w3XULIIfAYrcFDf+ZxijsETJz4IntGB0bAaOLJMZN9avpaS1wlAp
	L4jNpS8W+vwc2OXXogFljujCzZdNVHZNsrKvl7GHGE9vnQ5JbOs+BYSz53PVkJc9/w3f+ysbakcJ+
	hogpSKUoflFGTqDT4INWv8EZhhaRvJ/3Ew6FTGrYDqWYC4b0E3Eqt/uoRSEUI93TWqEAJrWdVi7fl
	ET8yzM2/tyYlDsBcZZj0aR7us6iMpX+tiOnDpMXwtRYaUYGsVce44/G8vjPOfO5/ndvKU7HrC9BeZ
	V7aK143wxeiGEW0Ze30u4hu5u2LsAW+nWIa5FrHB3C7XFJyCnj/nvnF5eZd2I6X+c5x6aR88WcMwc
	1j5TBcFk4q8s+ThiUNsDnu9n;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQGg-001qM4-0r;
	Fri, 08 Aug 2025 16:48:34 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 1/9] smb: client: return an error if rdma_connect does not return within 5 seconds
Date: Fri,  8 Aug 2025 18:48:09 +0200
Message-ID: <2186fb5db861cd545f24e22102037bfcae7784b5.1754671444.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754671444.git.metze@samba.org>
References: <cover.1754671444.git.metze@samba.org>
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

