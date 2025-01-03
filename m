Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68011C1AB4
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jan 2025 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735943366; cv=none; b=EA5Mprw9aTY1MH8OBn92nLxe16g6OP2/GP7nPvSnr4QkMO6e9Eapcvi0LewhQT/8hpNgVqCsUugbUHyNA+ODlDGJkV5ozxsVQIW2J/C6sLIlOViUfz7hUK48s0aPHkj4wtXjqBxNBcMXRZRNVxLzUwBaWkZqLhUhpNUWMhhniW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735943366; c=relaxed/simple;
	bh=WIeT1Z7Dg+dIjPbXwAeteAFm8T4TdcIr/DwE96jPWlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIEgKlkWXSuZ0mdFJotl3QjUgNE20zReIvRGkTjq2J3K/tJoy8WIC8EdpwWT8iQnD/ZHYYQARWa+9CL69x1rWlpOPRB7+2q+cva2KQttTphdMtxcBcwSfjuwBoC12CrEAPAqVCJ2zSbeFzjB8iK0XoSsJepUgCrYh6Hu2s9hBHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=bT/Ybrm+; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="bT/Ybrm+"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1735943363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4A0RciEHWvUEKXE9E8Jnh4UHYb1lakTO/Ck4veRFrM=;
	b=bT/Ybrm+VYQEAyVRXB/uayRMNw8XVrV51wKWn3zL/Jhl0vqRZ9eeCmRbKd6k07NZevjRgQ
	kRM+u/MtDXJ3u5lwCA97fj4I8bvd3jvYRDm5+TIwthenJXCkvVUMEwfG8lrsDAa6eCUD21
	i92iL4rP4ezQpirtY6/RHK91ph84xzuLKOMc/kbeJILLM66Q6zGTgdq3EEDp5i723ys6MQ
	2oc1tDduPkml3NXtoxLY+gBDUGb7HRHFzr1szHqxWe493KkpsuJZEGfgJkSvdHzUTcoQW2
	wbzV09kfMRIxeMl2V3MBwPjGvL6zEqikLhhyzraCk4sBjMNGmg/2y3f2Qhzuaw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/4] smb: client: parse DNS domain name from domain= option
Date: Fri,  3 Jan 2025 19:28:58 -0300
Message-ID: <20250103222858.87176-4-pc@manguebit.com>
In-Reply-To: <20250103222858.87176-1-pc@manguebit.com>
References: <20250103222858.87176-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the user specified a DNS domain name in domain= mount option, then
use it instead of parsing it in NTLMSSP CHALLENGE_MESSAGE message.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index d4b571d74191..35d0243ae177 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2280,12 +2280,13 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx __attribute__((unused)),
 struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
-	int rc = 0;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
+	struct cifs_ses *ses;
+	unsigned int xid;
 	int retries = 0;
-	unsigned int xid;
-	struct cifs_ses *ses;
-	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
-	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
+	size_t len;
+	int rc = 0;
 
 	xid = get_xid();
 
@@ -2375,6 +2376,14 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 		ses->domainName = kstrdup(ctx->domainname, GFP_KERNEL);
 		if (!ses->domainName)
 			goto get_ses_fail;
+
+		len = strnlen(ctx->domainname, CIFS_MAX_DOMAINNAME_LEN);
+		if (!cifs_netbios_name(ctx->domainname, len)) {
+			ses->dns_dom = kstrndup(ctx->domainname,
+						len, GFP_KERNEL);
+			if (!ses->dns_dom)
+				goto get_ses_fail;
+		}
 	}
 
 	strscpy(ses->workstation_name, ctx->workstation_name, sizeof(ses->workstation_name));
-- 
2.47.1

