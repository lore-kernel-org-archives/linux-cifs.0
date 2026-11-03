Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713076;
	b=cMLThWPxLWBZxMI3dvGL6rdsfnHy4lKeBd/o1PhrudDqwCuNP7c+GgZQAYWJGzW6ukVZ
	 xOKGKaBsLqMUh0WuklUCYOcSKxrcNrIQyWKx7rnSpB85DP/DZhZzxglUrkfHQE5HT8I08
	 iPXj8A8RIdpdKEdy0araszesSL5wmeF/FyMstSPmJtOWnHqZs6tgKyPWqNsHBgf1alLv3
	 WgdsQP+HKfECowYGOnddQoZp3CNjdWw0o5IHu5LKHSZFvXEgd3TY9LOpj1jmrQRxhq9NS
	 Ash4F68KxMlr44gf+OLEjD3+qoQb8dU1948Vi9t75+/ALNvtz44XAT9W9MkysMV5fNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713076;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hEMI+m3js1aFnCErRNCz/Cu9tKkq0BT32Y7SR0V+Acc=;
	b=mzHlpCV+zJRN93wxrH3wNZXzYH4nI4B4qmtIQJ4pF3VPImbWC/Y3w+VxfGvOTB5PHVOF
	 WFnvKdzyymnPo+/7yJwHz6ktbLtAcc33hd+SKJJWxDlfFvlwZVc2lfpWpWTHRy/BsJaUr
	 O6oeouNDw1nsFRjs2vBLh8NLUxLy90SYF8JVs94nm9XVr3XBD22Gw2X3w3iGMdMy8+Sz0
	 UIrA4AUfgYNHFKrtWhqrF3PglobTFdTZlP1MwD64C3M/IbAnVz2vrxN4r7V+ufddvZDNA
	 QbU+Q6+fiCHWuePvsZIFpRiWDfud30jOXDmnUmyGg9WoN46GvC7nehWxsrGjaB0lbhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Xu7eiIIg;
	arc=none smtp.remote-ip=91.218.175.251
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B63606A327
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 13:37:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60B63606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=Xu7eiIIg
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1gROWatEtva1QtksbHrY1qmsoeyLVAYi9rdrvKhCq6A=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793713072; v=1; x=1794317872;
 b=Xu7eiIIgqrd4axQIsMNU3caB2TLn11BT7TeGZH38dOJDrFu8KrwB0VrSyWPTSuUzA/zcD2dA
 vg0itl4nCERnQL3V5CGFF2zTM0j+pAtRvaq+oNklw+4PyM23n+vMOHcubh2yiSjFo7kJmaeCKXY
 v18qK+nC9Rk4TrITnALnSn+Doi87yIKNScO+xhGL6jQtKwDjp3Z7tRPC3lXej+t3pRsKBZ3rvfo
 LQfWB9kgZpp4KN0Mt6cM4qs0XbzaLU11zvxp8eQAlgjOzLDfkI+eY3ICDcryiMXHjkVVAlEB4nh
 qk6lXF1jfXMKcecPovMpFeEspZqHU7HOn9xsv8H0lYgqQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c2ab1624e596d386;
	Tue, 03 Nov 2026 13:37:51 +0000
X-Mizu-Trace-ID: c2ab1624e596d386
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: reject embedded NULs in EA names
Date: Tue,  3 Nov 2026 13:37:36 +0000
Message-ID: <20261103133736.285341-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

A client can send "DOSATTRIB\0suffix" as an EA name. The check sees
a name longer than "DOSATTRIB" and lets it through. But the VFS
stops at the first '\0', so the request writes to "user.DOSATTRIB",
which should be blocked.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9cb533a030f4..1be0de361c40 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3455,7 +3455,8 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 		if (!eabuf->EaNameLength)
 			goto next;
 
-		if (eabuf->name[eabuf->EaNameLength]) {
+		if (eabuf->name[eabuf->EaNameLength] ||
+		    memchr(eabuf->name, '\0', eabuf->EaNameLength)) {
 			rc = -EBADMSG;
 			break;
 		}
-- 
2.55.0

