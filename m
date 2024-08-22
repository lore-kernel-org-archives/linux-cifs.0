Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713818306C;
	Thu, 22 Aug 2024 08:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315076; cv=none; b=rIQpjAeQ6U3QMB9fGkaAwqspXIuLTquVqNGgzCtarkG0hLLoKfrG5ea7aLJiBRHbvnnCI4azSZlNkL2gtX3BZqprfF64PCdIr07jR8apFkyc9BZdksx9VhEyZPRp99F20nsXNlQM1d0Xsf7PBOPi2qJTrguuD1o3G+g9F+qSUI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315076; c=relaxed/simple;
	bh=mTGVaHTZQ3UjbmpeOF9wyjawifk0wAOZgUGkG+Oj0sk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kK3d3yrsKGN5sVjwWAH/o5mmLELrEku5TNkpNzLpbkuDKNijinwoIuL05HBR2Uiw8EdMPzawdzqH+sO4T90cNR2yMIjjECgS97f/II0g+E4frHNBenAeHq3ZT1qPlTCai6iQcV54Rdm7Sjcnu6e5dbJUbrDSqELJIxdWXC0uKq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314944tsw4de59
X-QQ-Originating-IP: Xv2ZqH8h/2nXkd6VJ9vCavvBKoI36zTxY4kTdvpSJYw=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:22:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7983957467294825685
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Subject: [PATCH v2 05/12] smb/server: update misguided comment of smb2_allocate_rsp_buf()
Date: Thu, 22 Aug 2024 08:20:54 +0000
Message-Id: <20240822082101.391272-6-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

smb2_allocate_rsp_buf() will return other error code except -ENOMEM.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index db84c7d0c278..e7c83973cdd2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -519,7 +519,7 @@ int init_smb2_rsp_hdr(struct ksmbd_work *work)
  * smb2_allocate_rsp_buf() - allocate smb2 response buffer
  * @work:	smb work containing smb request buffer
  *
- * Return:      0 on success, otherwise -ENOMEM
+ * Return:      0 on success, otherwise error
  */
 int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 {
-- 
2.34.1

