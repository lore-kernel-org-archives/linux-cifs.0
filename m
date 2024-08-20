Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A9A1BDA92;
	Tue, 20 Aug 2024 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164611; cv=none; b=l74mtrkqkZEs3E7YiN7JdUT9p3cIFK/CLqDdB1Wkub4DuObB1f6b39hTl60mnhKOxTZnfxwMgG7KYXjyDWoDDO7DV88RqX32NyCzXKRBU8A6mLZJomvx21biriVZ7UEPyqzW5ssJupka6jUjmBEF8SWn3cDwDB1zlrCBbiViuLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164611; c=relaxed/simple;
	bh=luvK2JxUBMhTBgFqFW1RvyLQomj6QYyBETajLZNjC70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bURRWeOGVpf8pvwsqWntutaW3hEQRNCQbRc+UgWInX98g9oIz2XThi/ondLvmbt5r/l2vafh3M/0awOc/exkRm8JiqH6ecGsF4RYh1aXFS1oHrzJ8yjOhg3DSuIRH0uRyv5mEpi2R8DxGVPjYAZxZ6VFPR8dLTdOzZCS1y8hJc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz13t1724164457t5nif1
X-QQ-Originating-IP: 7HyFxf4DMjDvsab2FRov64X4X0xCPWbEisVoi3bBuUU=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 20 Aug 2024 22:34:14 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9856816800179513022
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
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH 5/8] smb/server: update misguided comment of smb2_allocate_rsp_buf()
Date: Tue, 20 Aug 2024 14:33:16 +0000
Message-Id: <20240820143319.274033-6-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

smb2_allocate_rsp_buf() will return other error code except -ENOMEM.

Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4e87bbac2662..6fd5977237ba 100644
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

