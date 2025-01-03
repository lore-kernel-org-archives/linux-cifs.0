Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB121BEF9D
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jan 2025 22:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735943152; cv=none; b=Fu8ZVUbA/YDiLkG1+65goqbcVusiEKXexVNhVKS2PL3qC56sVSPRWMPBGHK1gnO/HIFaAVn/k1TkIvFaa2UWuy9dOvf8VycWlIzBUJzQmfXeypLdMrZOW/ZpDDhFKdxqkpEYAXztqbmCOIbYfMw7xV6D4lWLwZ7yj+L80vNiHRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735943152; c=relaxed/simple;
	bh=WIeT1Z7Dg+dIjPbXwAeteAFm8T4TdcIr/DwE96jPWlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVthlvNMuUPLmY8gXFVcncdURd97lHacFF1haNlk7Nva8VtmPefTDxLKLbQisRgYRKDhOEjl8tqNoHj4yNnZz1KI2/XKhMS6IdU9lRUMPU6RlF5tbNcg1+gqL81PrXck6OgKQ4k5Rt54VYbhkHkbq5vDRXWWLbljQJpE8ZYSYac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=F8Q5CIQp; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="F8Q5CIQp"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1735943148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4A0RciEHWvUEKXE9E8Jnh4UHYb1lakTO/Ck4veRFrM=;
	b=F8Q5CIQpkMDXA+BfU5dKxXWdfQ9qSi3YzOECR8yhlh5dk4rgnD7jXRjo6mFES9eTETpdJ1
	Who6EPoT0hIhk+n2pIAtTpnnHxYCnyrmgsGORyC8TpMy2G+AJw5FFaKrqxnSq+uRTln+Fg
	LpbXQjEK6S+8GE8doYsy+toTsiMOpd+pMM4juwbCtTdRzdhE8f4BLWUp2dQFnVFYNcClLy
	A3qE2Qi8+KYiLBzBfaRSpLF7JXIZ9wyzXLYiCX45wDC6Pm+g1ADsyuZPMbwr0xRQAglJts
	e/lYIKYF7LDNUzOT+0Cy8AOLCzFddDJxblSqb7jzev9Q/Wm/SKf/4zhsGNtb+Q==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH 4/4] smb: client: parse DNS domain name from domain= option
Date: Fri,  3 Jan 2025 19:25:34 -0300
Message-ID: <20250103222534.86744-4-pc@manguebit.com>
In-Reply-To: <20250103222534.86744-1-pc@manguebit.com>
References: <20250103222534.86744-1-pc@manguebit.com>
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

