Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBEE42EEDF
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059539; cv=none; b=Vhe0TXJU3be+Oqs4rs33R39XQ1uiM3ytEzml2tC8qR9HxonQc3F2QHII81Uirv8XRVgwUgkJP6VYV4j97n6upyJ2kiz9yz3va/pVVdaXhjL3Q4Wb8ttq7yTZ9XV8CwscbYVtpvmfUHJgzC14LVeKT9EExqd4AelLt2DLBKLrd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059539; c=relaxed/simple;
	bh=QyLOGypBRqxHSSbfw8bPLM/BYF7F1vjRDBGyViKSMEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRcbZh2YsCV30Gw/MZJ4Gv2vCW90z/R6fS1W/jNfbQDj4p65v8MDN87CivWD5dVi++DfBnGSxplBG1P7GiA9x8AqSiwCpq76+TFpVVl6LG/IqD0wNkbDvLm6iQMV3+1SGEzG+gCqgc5PmAQuX5GOOPNfEW4IvAak/HgYadYJ8E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jkmyHIyG; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jkmyHIyG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWwm1d+GZ0/gM8ErncWC+Th1DppiTEZYTdx7QaLk6vk=;
	b=jkmyHIyGxd1KW+O2thoBK/x08txtLgA8HSu/Z1Gyb+X5heJnDNiixR5xUMXMLZ0k9qCjpu
	14pTzmtNtxlKYikjFXQPxvkdRc7NQjkG2AjQYfkKtGJSiVo3tGg6Jm3P+Xa0qcBbi/zEeO
	RcO/JonSv4P/y+4TO5dlgN/yEUcZ5Qk=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 6/7] smb/client: rename to NT_ERROR_INVALID_DATATYPE
Date: Thu, 22 Jan 2026 13:24:01 +0800
Message-ID: <20260122052402.2209206-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

See MS-ERREF 2.2 ERROR_INVALID_DATATYPE.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index cab16d53e11c..03d120e2ce09 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -26,7 +26,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_MORE_ENTRIES         0x0105
 #define NT_ERROR_INVALID_PARAMETER     0x0057
 #define NT_ERROR_INSUFFICIENT_BUFFER   0x007a
-#define NT_STATUS_1804                 0x070c
+#define NT_ERROR_INVALID_DATATYPE      0x070c
 
 /*
  * Win32 Error codes extracted using a loop in smbclient then printing a netmon
-- 
2.43.0

