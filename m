Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795507185;
	b=h9m86A/EkBmrTSvaWGMpzkdeN8lYcaQjw06GjqeWj86SM0cWfTqx3if7GxXc5qb2nrM9
	 l3wvZzBn1jNQ/JfieBpvHtsczoHvtJE/0cpZ9jqewkqgeumWYxv0RGCvnpx7HlPuMWlmc
	 JuhOtw8IQOeRDIcX1wRkTotPIRz1b0+VWMeRHLs0BGwo3ZOu2bZxQoV9V9A9jREVCoRXi
	 BMNS2NFwx2LKrJRMcZJR+IgXZZAtdCSf3Eikd6d63Rkacikv80Am+UylcKBG2Se+RsMgJ
	 JqPBr6ua5VGDK3EpDsvQorr8mpTvsD5ksJl/hCdkN+pp7IadCvyNNPqL+fCCfAARBhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795507185;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4OvXlmVDbj+xMLIOv10yP+37UNfCpiJKulfx4V+7HuA=;
	b=YIevdg0v7usIOfFiMu1oeomXpYbs5q8i/1usXDwFV/WGy3wVlWWAUXpkdvIIq0kW9fhr
	 IAvEWVzAxgTW0QDnrljjREp7HrmKXewxvSLTl2fNsrYtFNnhCpRTlK67jJYxIynGQ+9oy
	 kkUYI068M9USXeZNcWn78NhTfJTQVZyZy9rHhiVA8omB0jB9QFjqdJkEysVe6jko25aKA
	 dqdilbhGXqGNXPM6xCjfAalf/K4Bd5KLwDhgV0m406sYsU8QL2WyLCvLBAwkb6XER5h7e
	 d37iEN3Upo6l1hg+KD+syHvG9yvG1kibbWyyZ3L53Ib0+h1+MYz8bUl9Y2Oiy6AQB2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QA+4gDBz;
	arc=none smtp.remote-ip=95.215.58.10
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EF6606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 07:59:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34EF6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QA+4gDBz
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=u1CeqRsOC3qFVy1aH8rMj6Fa7zHv++gfcrsDEpqcCNs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795507183; v=1; x=1796111983;
 b=QA+4gDBzNIna7LRNU4HLSeTE47LsMtnrr/UyS852szxi2lOI8mdBCvGCH8/HB4kyWOTL4xAD
 XUy4p5a7s1bNnGA406drjCHjcW1v6u2T1SrrBsmToPMsaEh+1qOxpO514nwW/9IX80L2bgXXhj5
 LJVuop4C4Wd5LweHDohjuOR0=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ae916bafd3db2c92;
	Tue, 24 Nov 2026 07:59:43 +0000
X-Mizu-Trace-ID: ae916bafd3db2c92
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/2] smb/client: fix file name conversion on big-endian systems
Date: Tue, 24 Nov 2026 15:59:27 +0800
Message-ID: <20261124075927.469470-3-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124075927.469470-1-zhang.guodong@linux.dev>
References: <20261124075927.469470-1-zhang.guodong@linux.dev>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Use CPU byte order for temporary UTF-16 buffers to avoid incorrect
file name conversion on big-endian architectures.

Fixes: b29103076bec ("Fix to convert SURROGATE PAIR")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifs_unicode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 4a8a591f4bca..264595633b1e 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -92,7 +92,7 @@ convert_sfm_char(const __u16 src_char, char *target)
 /*
  * cifs_mapchar - convert a host-endian char to proper char in codepage
  * @target - where converted character should be copied
- * @src_char - 2 byte host-endian source character
+ * @from - 2 byte host-endian source character
  * @cp - codepage to which character should be converted
  * @map_type - How should the 7 NTFS/SMB reserved characters be mapped to UCS2?
  *
@@ -126,7 +126,7 @@ cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
 	/* convert SURROGATE_PAIR and IVS */
 	if (strcmp(cp->charset, "utf8"))
 		goto unknown;
-	len = utf16s_to_utf8s(from, 3, UTF16_LITTLE_ENDIAN, target, 6);
+	len = utf16s_to_utf8s(from, 3, UTF16_HOST_ENDIAN, target, 6);
 	if (len <= 0)
 		goto unknown;
 	return len;
@@ -518,7 +518,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 			} else
 				goto unknown;
 			ret  = utf8s_to_utf16s(source + i, charlen,
-					       UTF16_LITTLE_ENDIAN,
+					       UTF16_HOST_ENDIAN,
 					       wchar_to, 6);
 			if (ret < 0)
 				goto unknown;
-- 
2.55.0

