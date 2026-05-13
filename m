Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D7C3D88FE
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 08:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778660154; cv=none; b=gERICnuICtpXzzPW3MJhcujyHs2pGwrN+SHOl5zlxnNByn0/9WKhab/gYfqlFmsq0pq7ocXv8w6DS+QoliiOVWMGegsUcXf/8Kp68bijsK3+Ongzw2hm9feMf6LNcq53/auNKQFIgbnDCymFBV1faWpbCZU/YJY7xGKNHTsnCdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778660154; c=relaxed/simple;
	bh=YckFDSuayRs05gEDQJ8nhvZ5pZKRXegwqbICFRIUtoM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HPBiju61QRZ57Q0SN3iL44hOLdx2M2u4D0kI3rawXHUfD3o3wNszYrLBIgqzcMF4kGWlgkm1mIbk77nxZslOJ2sctsKha4H7Bst62v7eXPSbijfE5NFFXes3zqItSfFEnYKm3j7lbL9FSJv2ys1AgUX6VwgBxg4WWurw7XBDgdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hQe3RUa9; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hQe3RUa9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FLhz8DhmQVod3GTcIJY/fZWL4Jzh5t6tRktaKjLALbs=;
	b=hQe3RUa9e3PNzU6IOus8gg6p1VltzVv0lsDo/ZomlA640VcTZwGEYitBIQr6f5uQqqT6qXO+Z
	+HL1TyZco1qwO8C1f8z22QRhYYInjuNSo8n4PAl5vJX0EouB3Io04rRTLmQfK1TbNa/4C4AITlX
	9ABhGnlhyF9vRi5kAk0nicY=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gFmLd4qTzz12LD1;
	Wed, 13 May 2026 16:08:41 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D52CF40571;
	Wed, 13 May 2026 16:15:46 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 13 May 2026 16:15:46 +0800
Received: from huawei.com (10.50.87.132) by kwepemq500016.china.huawei.com
 (7.202.194.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 May
 2026 16:15:46 +0800
From: Ye Bin <yebin10@huawei.com>
To: <sfrench@samba.org>, <pc@manguebit.com>, <ronniesahlberg@gmail.com>,
	<sprasad@microsoft.com>, <linux-cifs@vger.kernel.org>, <tom@talpey.com>,
	<bharathsm@microsoft.com>
CC: <samba-technical@lists.samba.org>
Subject: [PATCH] smb/client: fix possible infinite loop and oob read in symlink_data()
Date: Wed, 13 May 2026 16:12:05 +0800
Message-ID: <20260513081205.1018080-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500016.china.huawei.com (7.202.194.202)

On 32-bit architectures, the infinite loop is as follows:

  len = p->ErrorDataLength == 0xfffffff8
  u8 *next = p->ErrorContextData + len
  next == p

On 32-bit architectures, the out-of-bounds read is as follows:

  len = p->ErrorDataLength == 0xfffffff0
  u8 *next = p->ErrorContextData + len
  next == (u8 *)p - 8

Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: stable@vger.kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2file.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index b292aa94a593..9d6f342b3f82 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -31,7 +31,7 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 	u32 len;
 
 	if (err->ErrorContextCount) {
-		struct smb2_error_context_rsp *p;
+		struct smb2_error_context_rsp *p, *next;
 
 		len = (u32)err->ErrorContextCount * (offsetof(struct smb2_error_context_rsp,
 							      ErrorContextData) +
@@ -49,7 +49,10 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 				 __func__, le32_to_cpu(p->ErrorId));
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
-			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
+			next = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
+			if (next <= p)
+				return ERR_PTR(-EINVAL);
+			p = next;
 		}
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
 		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
-- 
2.34.1

