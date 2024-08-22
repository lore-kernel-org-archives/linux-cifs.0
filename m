Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778F516A955;
	Thu, 22 Aug 2024 08:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315023; cv=none; b=Q8qUVb9hzzN48zWv2zN3590aksyDexQfbExex7e6EJJOvZ9UMnZsJBMSejbHn7rLpj7CujaEhDwUUhIVGV93lT/rnsqnGFvOSxcfPfjNeorAoJV9cLEWoFjPyBnQ5gDKDhoeSQFTGpsUPbgA1QccN+BCqXp5w78AdNTujHuZ/jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315023; c=relaxed/simple;
	bh=v9gf538vK/s804RJKpMzo7z/rr7qSvrhASA5NJkmMfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cQ3zCtOl9jDnUNWezg4AfpYKHxw57fob61R/TiKKRpAC+APJXI33bhFD/eTBrOhSVDp79UGk199R66IMMZGbzAr+DFBBS2z8Wd1qMnBN8CGuiMoqxvNpdg3J8ynBHBBAL7XRmCwwoXw7QmDB8doX9MDlzV1klTclg7gBaIR5p4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314909tqlrjlok
X-QQ-Originating-IP: vrFwbI2ZYqPKUh1jNEVLgw8H0HQpRqOdyqXVZhNbrmY=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:21:44 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11016837021676028273
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
Subject: [PATCH v2 01/12] smb/server: fix return value of smb2_open()
Date: Thu, 22 Aug 2024 08:20:50 +0000
Message-Id: <20240822082101.391272-2-chenxiaosong@chenxiaosong.com>
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

In most error cases, error code is not returned in smb2_open(),
__process_request() will not print error message.

Fix this by returning the correct value at the end of smb2_open().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2df1354288e6..d8a827e0dced 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3710,7 +3710,7 @@ int smb2_open(struct ksmbd_work *work)
 	kfree(name);
 	kfree(lc);
 
-	return 0;
+	return rc;
 }
 
 static int readdir_info_level_struct_sz(int info_level)
-- 
2.34.1

