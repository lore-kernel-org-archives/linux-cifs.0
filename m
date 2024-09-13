Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86CAB173;
	Fri, 13 Sep 2024 00:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726185747; cv=none; b=QQ66AyTVjU0Eav+yxQ+koG4kPvYg69rA5TdOWJy9JPE7wlRS2plvNb7f2oC/IlCQyXl2CD7CoE7OQq+wdipEr8Lg574K8GWJnTQGyVcCDMT0AAd9I0zc6sfq3xP+AE+M0rzoe3TZE4FME5x6Ed1tqn1ZGTwt3ud7sdKFKX3VhRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726185747; c=relaxed/simple;
	bh=To3GrvyKIBX3UYEvwiX7EvVEOXarD/UT+eqRyoj0ne4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qnM3679qBQrwNmovvv0+EkLG+lTBHPt6l5u1zx7awXr+b7CjNfsE6OSgf+o246fuq97qdf8RhQqdfK3lVPld/CDUcCAiyDcVKX1WI5z3Ld0oaVI58iyW5L5djftJ/FZSthJjpLE+/XJWGSq7GIg8MHdnpNTS3HiEw/M7kOEUD0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TuFkx1Sb; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TuFkx1Sb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RPHRL
	nQ6x+m895bVcK5uCZBBPny+jYlt2NTStIDkmjk=; b=TuFkx1Sb5zYXhw+gnPtMv
	JTYGYGL+FSTdEjQ3XTIHK9fGRBxF2D7D6ik/rmpjnQE+GDEEb+TKRq9X2IaRJlKx
	4LKWBmtcliiLLaFVhQc7iWP/ED33D3wYeMgP49PyexJ7Ao2oUB0CMWSmsmKpw1y1
	rshOqP+ey40MFfCQajY/aI=
Received: from localhost.localdomain (unknown [58.243.42.99])
	by gzga-smtp-mta-g2-4 (Coremail) with SMTP id _____wD3H1XjgONm44GTBA--.21527S2;
	Fri, 13 Sep 2024 08:01:40 +0800 (CST)
From: Qianqiang Liu <qianqiang.liu@163.com>
To: ematsumiya@suse.de,
	sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Qianqiang Liu <qianqiang.liu@163.com>
Subject: [PATCH] smb: client: compress: fix a potential issue of freeing an invalid pointer
Date: Fri, 13 Sep 2024 08:00:54 +0800
Message-Id: <20240913000053.123052-1-qianqiang.liu@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H1XjgONm44GTBA--.21527S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw17WrWxtFyfGr4fXF15twb_yoW3XrX_JF
	s2grW8ur45Jr1DK3Wvkr1SyF45X3yUXr1xJF1DtFyYyFWDCan0ywsrtws8GF4kWrWfKw4x
	Wwn2kF98ZFWxCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjLvKUUUUUU==
X-CM-SenderInfo: xtld01pldqwhxolxqiywtou0bp/1tbiYBBYamV4JNEUBwABs4

The dst pointer may not be initialized when calling kvfree(dst)

Fixes: 13b68d44990d9 ("smb: client: compress: LZ77 code improvements cleanup")
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
---
 fs/smb/client/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 65d3d219e8bc..daf84e39861c 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -318,7 +318,7 @@ int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_s
 {
 	struct iov_iter iter;
 	u32 slen, dlen;
-	void *src, *dst;
+	void *src, *dst = NULL;
 	int ret;
 
 	if (!server || !rq || !rq->rq_iov || !rq->rq_iov->iov_base)
-- 
2.34.1

