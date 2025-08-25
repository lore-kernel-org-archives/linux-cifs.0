Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50CA291864
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155223; cv=none; b=gbojXBT7vOpMaYd5CZUuJ8wuarSzNfRV1rNOJT2qnWYTII32dE+knShtFQq+jOUyp/Kcl7fw88eGkJnX2OdrsO4R0A1J/AwrK2c/Bsy2BNqKR2r9VKJ63msmxqmvfFJROg+yx1AyNg8NOOVF0zjEkdQks342AZjsakLAG1F1uv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155223; c=relaxed/simple;
	bh=nqZkVjmaOrbrnx4bOG8kXj1Cx7uc0il4/aiCx0YxCac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9XEpPvXOCSqE1dWQlTAeLfWqAepWDQt6OpTzIxLk+c9Tw8RngC9FlcsnLiONwWa3669ISE663Y1tS9qA0IGYpuUrPUIp0amONhpWSa18MG19vhA9q5g3cl4hrNy5fOoV0vApzPg7W0wHxPJkGPhIiBxKrUGMc0Ia7wLOv4ySUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fsTTkMXQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fsTTkMXQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=G+tc5uI0jjTHMPWSxNgRwZV8XtjK0x/UIA1B314cIRE=; b=fsTTkMXQV6Wkoxt2HkDtwk7Yff
	83pAHxSlIZW1ElV2fah7/DFG8ykWaNScGJWy4xB6mD+6R6YCzFuAGc0bi+AygCm6dXfWHZBqwfeKM
	LZvdZmZTopUXLYoSuJm/O4raK16l4gT5gYyaid5CewSKRtAiT+eCfTD51wGdpkGdV2X/JCZPM+3b/
	IdTCshrsaKy0fO5NtM4LLVlFA5ztoQ4/mtynkjABXQ+E9heX1Q+IqfnGaJWpKHahVNenE1BmdA8C/
	L6IXf4zrEIEuAq0gvvcB/rf7/g1+JfSDtjbFQNluYEWFxnIVoCwx9MqfG5Fm/dTWUCgOKl99IezEt
	Bf+K0ETCp6f7useV3bFzfk85pXb0sh8OpgcH+3jYfpQc8q3jJaWctNAV/z7SRLWt6rv+B85F1J30h
	j52cprva0cHKZUA1wgzfHkRDk9LurGa+yZI/EHFm6w13Cw3l4lCRwH9vGjrP7vRQec1V01exLPvaI
	CD48dsvbCU/CWyuNWl+C++We;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeCA-000lZJ-2H;
	Mon, 25 Aug 2025 20:53:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 071/142] smb: client: pass struct smbdirect_socket to smbd_ia_open()
Date: Mon, 25 Aug 2025 22:40:32 +0200
Message-ID: <db1174ac0241ca8556abcb128325dc2adb4c24e6.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 3a0b5e3d3142..9fef01ed6320 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -773,10 +773,9 @@ static bool frwr_is_supported(struct ib_device_attr *attrs)
 }
 
 static int smbd_ia_open(
-		struct smbd_connection *info,
+		struct smbdirect_socket *sc,
 		struct sockaddr *dstaddr, int port)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	int rc;
 
@@ -1677,7 +1676,7 @@ static struct smbd_connection *_smbd_get_connection(
 	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
 	sp->keepalive_timeout_msec = KEEPALIVE_RECV_TIMEOUT * 1000;
 
-	rc = smbd_ia_open(info, dstaddr, port);
+	rc = smbd_ia_open(sc, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
 		goto create_id_failed;
-- 
2.43.0

