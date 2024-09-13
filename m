Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C560145A05;
	Fri, 13 Sep 2024 03:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726197974; cv=none; b=BZVtmNZBgivKqVX+jrDv8YTUtjPesGkfDLjsOg6lo/nihLfongs1tm2xfiKQBN+VR+kGGQHlmBOoVz/H4orQp9Jo+OGuWUjcR0GE64TT/Acqp3IUoBsIFzehxWscbE0z6S5H/Mp5tLepJJEdIHXMPaxE3SMTr7nDweUO/pncErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726197974; c=relaxed/simple;
	bh=JfmfjBDvS/l59xqajtP03o5CkFGUgq/13gz9ldS6lfc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F9Dlz/FUYJIBs08dJ7sKHpFhE5iCOksSTgBm3mqyq5oo2TztXhGCkY2Dd4nLB9J6USo/Lks3l+qDrMl/++gVo3IgXxfp9yz6gqfDHgtOsk+JlkDQTtuzd1g39XiH56CuEsTUnxdiDsb4VOB9WzuYsWb+WlWIxUysyUtynI6nkC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JhDcOzu/; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JhDcOzu/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ljcxF
	53JTM/45PN+XiijH1tFRPEMK4B7TlVQdyhXbgE=; b=JhDcOzu/JkHynhNi9g/Lv
	tTWLKvkixIjiFB8bj+QZjPWiBbGryD+ZTHJ3fBUXlojv6WkTLQ4IhscB36eDG5Ex
	Hhpsg+thpuQYqloA/twCS0YSpeK3fqHBYktNNyYigIFKRo8pZXyrJDctaLaOmlN3
	SDzEnJG7Eh6ixc29jpsUOE=
Received: from localhost.localdomain (unknown [58.243.42.99])
	by gzga-smtp-mta-g2-2 (Coremail) with SMTP id _____wB3W1SrsONmJnUUHA--.35312S2;
	Fri, 13 Sep 2024 11:25:32 +0800 (CST)
From: Qianqiang Liu <qianqiang.liu@163.com>
To: ematsumiya@suse.de,
	sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Qianqiang Liu <qianqiang.liu@163.com>
Subject: [PATCH] smb: client: compress: fix an "illegal accesses" issue
Date: Fri, 13 Sep 2024 11:24:49 +0800
Message-Id: <20240913032448.174936-1-qianqiang.liu@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3W1SrsONmJnUUHA--.35312S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr47Gr15JFWDur43WF45Jrb_yoW3Cwc_tF
	4IqFW0kw45XFy2k3W8Cw18tF4UXrWUWF1fJr95WF1qy3yUAFs8Zw4kJwsrWFW5WrW3Ka1x
	GwnrKr98CFWakjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREEfO7UUUUU==
X-CM-SenderInfo: xtld01pldqwhxolxqiywtou0bp/1tbiYA9ZamV4JNqg-AAAsj

Using uninitialized value "bkt" when calling "kfree"

Fixes: 13b68d44990d9 ("mb: client: compress: LZ77 code improvements cleanup")
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
---
 fs/smb/client/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index daf84e39861c..2c008e9f0206 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -233,7 +233,7 @@ static int collect_sample(const struct iov_iter *iter, ssize_t max, u8 *sample)
 static int is_compressible(const struct iov_iter *data)
 {
 	const size_t read_size = SZ_2K, bkt_size = 256, max = SZ_4M;
-	struct bucket *bkt;
+	struct bucket *bkt = NULL;
 	int i = 0, ret = 0;
 	size_t len;
 	u8 *sample;
-- 
2.34.1

