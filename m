Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506988;
	b=CVPD3ODqMzEEhT3T1Dl7iYt5FU+km4r34+CZlFrgK9PH/tOnCQucN6tQSVi8F4F6UpUo
	 7NWRqmRSsznxK04ubzH2pmWSBLKg0jXRG2t6IXLerBN3vaT32o917W9k3i9S4WEr8M2dE
	 XAwiPIu/c2JqsER2yFrYMAdPDwXuAjNHdXofK9u+T6lGxHASer362hfMBdb29jNr7zHy7
	 bSRGfsOWlVabIryaEx2zmGnJ0iUZRZGjXfhh9boPxxt4W2L7IPpwmrK8Zy9vxJkO51Ruv
	 t1mGCxSId7O8fjd3fiKP36YyiE4bHhwagaNUZm9OEqdval0++kNi2AF9LlTzyLFL1rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506988;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g1gtp3ajhe6weKyGaniX5BFGPKET0OJB5VzM54AXGqQ=;
	b=tlFJleAvQzlIT2lK1dnI0g/jLcC+jaamRukhn0zriXmPcE5MLZ4GnwCaXeaasUAVoBY3
	 /glvoq5UNr2Z/3g3bQ8lZdFpuZSJX1JQjguwDtVXypvT0AFRj5Wz45tm+8IvmFfX7pJ66
	 KE/0jvg2MRciY7jSCJK003e/ueGot0xjyRmrHc5CFdvA7BNp7ZUgi+pduwMSxoMt0ZvZ+
	 JwYNURRqE1lJ8iJFswrTOtKgVe/0zqphTWxSvlJ+tAeHvXEii0qiH4+e/E5kq+YmOO6rn
	 17zE63OBSAQob7Btq23O3/02rpKzhmOQ0I3zQrTPtTsKHWR+st7+EJBnnoTHymBYjGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ajq6ts+F;
	arc=none smtp.remote-ip=91.218.175.5
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0F9606A322
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 07:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A0F9606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ajq6ts+F
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0gS8Gvmp5LPLIBMNILYXiQA3yUFnDaH7GHcxDxHgOMM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795506986; v=1; x=1796111786;
 b=ajq6ts+Fi77GdzENkmnLLOZ+LIgTSvDxIy5tNbvSr9q9tuJppN6Ic5+0AR4SpA0n+tlLqzoz
 j4d2xPY39pBk0S7inhKRS+74Zm+EI4sqYqklw7pD9ugICti+7kImHuaFTjnxF4zOOqlsXN5iRpA
 Z6C+QJ3ppGOaHF4RbcYf1z/s=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id baa28791bd42415a;
	Tue, 24 Nov 2026 07:56:25 +0000
X-Mizu-Trace-ID: baa28791bd42415a
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/2] smb/server: fix file name conversion on big-endian systems
Date: Tue, 24 Nov 2026 15:56:12 +0800
Message-ID: <20261124075613.469257-3-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124075613.469257-1-zhang.guodong@linux.dev>
References: <20261124075613.469257-1-zhang.guodong@linux.dev>
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

Fixes: 0c180317c654 ("ksmbd: add support for surrogate pair conversion")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/unicode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/unicode.c b/fs/smb/server/unicode.c
index 85e6791745ec..8841f8a83026 100644
--- a/fs/smb/server/unicode.c
+++ b/fs/smb/server/unicode.c
@@ -80,7 +80,7 @@ cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
 	/* convert SURROGATE_PAIR and IVS */
 	if (strcmp(cp->charset, "utf8"))
 		goto unknown;
-	len = utf16s_to_utf8s(from, 3, UTF16_LITTLE_ENDIAN, target, 6);
+	len = utf16s_to_utf8s(from, 3, UTF16_HOST_ENDIAN, target, 6);
 	if (len <= 0)
 		goto unknown;
 	return len;
@@ -404,7 +404,7 @@ int smbConvertToUTF16(__le16 *target, const char *source, int srclen,
 			} else
 				goto unknown;
 			ret  = utf8s_to_utf16s(source + i, charlen,
-					UTF16_LITTLE_ENDIAN,
+					UTF16_HOST_ENDIAN,
 					wchar_to, 6);
 			if (ret < 0)
 				goto unknown;
-- 
2.55.0

