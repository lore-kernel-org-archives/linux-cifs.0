Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405917E782;
	Fri, 13 Sep 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726198127; cv=none; b=NlTbtmHT6XmqvrBJjqC2xOmhrdBPqMQ62C5SeBdNaQNxLxv5hVs13x4qEYVROR1j+Rwr6WKl9gB9ZbVFYIbyxuKJacsX0ax4mjrSUBjmhsPJERNASYlbpiwgoHFkq7cvqFPKLNfLx2kiBoHA8GhEs6y8BVxyDbkpNlqy6Oz10hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726198127; c=relaxed/simple;
	bh=reDVlfWHl+c8E2dPnXp7Rl3NQyE+oPaHNiqkYNtAN10=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dNsUI+BboMNuyj6u99viopMHjrmOG7+3FB/FpHdW2iDtF21f80cxPIPBU1Uc+AmRdqXCiYYPxZmb9nzyEYQ09cJzrf5pKZpAPc4RTZEz2TGQW/KVvrcRfKBqlWIGnSYIdLMHtMfCYsEW16UNqivtixodUb/yExiUjxEDlsLtW5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kDBqPHOO; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="kDBqPHOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=hm7eF
	/OBGCDBnPw7SUMiSwnJconkrosHswRJvBftnIc=; b=kDBqPHOO9I7ntVR7FrGCp
	qNTvzMq3cGxirIJONHGjHIFI3zXuG+8h1Bwi5Ag/qJVdKPVL4Cc5SQB7toZRN70O
	NCxnrZztK4QkKvC9dV6+iP8l/P4JTPo0z3S7ZwoCKDzRL3mZnr1TlQOB9HBBvvcP
	ABeJbERdbJH6dV24Y2QT0U=
Received: from localhost.localdomain (unknown [58.243.42.99])
	by gzsmtp4 (Coremail) with SMTP id sygvCgCXDl5NseNmcZVKAA--.16913S2;
	Fri, 13 Sep 2024 11:28:14 +0800 (CST)
From: Qianqiang Liu <qianqiang.liu@163.com>
To: ematsumiya@suse.de,
	sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Qianqiang Liu <qianqiang.liu@163.com>
Subject: [PATCH v2] smb: client: compress: fix an "illegal accesses" issue
Date: Fri, 13 Sep 2024 11:27:51 +0800
Message-Id: <20240913032750.175840-1-qianqiang.liu@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:sygvCgCXDl5NseNmcZVKAA--.16913S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr47Gr15JFyfGw1DCF47XFb_yoW3Krg_Jr
	1IqFW0kw45JFy2k3W8C348tF48ZrWUWF4xJr9YgF1qy3y5AFs8Zw4kJwsrGFW5WrW3Kayx
	GwnrKryDCFWakjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_EfO5UUUUU==
X-CM-SenderInfo: xtld01pldqwhxolxqiywtou0bp/1tbiYAhZamV4JNquLwABs4

Using uninitialized value "bkt" when calling "kfree"

Fixes: 13b68d44990d9 ("smb: client: compress: LZ77 code improvements cleanup")
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
---
Changes since v1:
 - Fix 'Fixes' tag
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

