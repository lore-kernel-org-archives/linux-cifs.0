Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4C3624D4
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498693; cv=none; b=LudYOi06SwftZu96DTU4ai5CW7b1uCojSg/tzX6yyDTUHaGgDmrxKFR2xu1on3xm9BsLNlVrxSLEBHrMJWwSzX/TBjhOe6GeIcaFlsz1dIHqsseaWUnZ1ZL2EsdB57/4ircBAdZAd7bVaajrbNtFq07hMjYuZvd/YI9mR/dmiuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498693; c=relaxed/simple;
	bh=5Ukx3TtLPMVqlyL5YrfmUSrEv1gpSeE8d9eyIPCmkBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mICUJi0mXaj24jbRvl84GsNfEljhOUc6b0tk/q/hAeFS4OLeH8lAFe6iw2rAKFjYPvDQP2qFVtUVGFBV1MfQCIDQHuzCUq9HUz/M2HP66hWGfKLoqOnbMG5h3PLwNZwKxPVFeMuC/NkYyNkpkjubfBm3bn3H5Ead88Rk+OJP/d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oMqN2GEb; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oMqN2GEb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785498689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiuSIrWDDDXZo4FWxUoAJNYjYw9pLmR5+xT2K6asNwc=;
	b=oMqN2GEbw5Cd8vw5BsNYSb/O7nVoCV+ukNVU18sEdQX29Ivm1BH+iM9F+4OA6TmGB0Q1re
	oMenaoOaiWfJwnwQbVX1+dDCwKZC1W9R+Zti0c6wkSEr4VJux2otcAFMeL5WB1AtZAB/Ao
	ZO5iXBHiALgtqyn1OsuTzDhhZmfCXEY=
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 6/6] smb/server: preserve error status in smb2_handle_negotiate()
Date: Fri, 31 Jul 2026 11:50:08 +0000
Message-ID: <20260731115008.111211-7-zhang.guodong@linux.dev>
In-Reply-To: <20260731115008.111211-1-zhang.guodong@linux.dev>
References: <20260731115008.111211-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

smb2_handle_negotiate() records specific failures such as
STATUS_INVALID_PARAMETER or STATUS_NOT_SUPPORTED.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4bde5ab2c881..9b64e28b5d56 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1722,7 +1722,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 				    KSMBD_DEFAULT_GFP);
 		if (!conn->preauth_info) {
 			rc = -ENOMEM;
-			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 			goto err_out;
 		}
 
@@ -1817,7 +1817,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
-	if (rc)
+	if (rc && rsp->hdr.Status == STATUS_SUCCESS)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
 	if (!rc)
-- 
2.54.0

