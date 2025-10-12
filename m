Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7752EC540;
	Sun, 12 Oct 2025 16:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285963; cv=none; b=J15PNKwSxO9jPpn0y9QQ+4m71EX0jpyLz5CeoTAs2fI/x/rEg82zVKEvzLpXTvBSxrw9Esst2ubF7beFCVED5xAeYH+D7j8fsq37txet27RUrczCV/53agCqYYg+JrFnqeHEswuxJP731KwmO0U32Nk0kPRn+ipwKcUeVFkRZO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285963; c=relaxed/simple;
	bh=LzJ+/nuwdxTRfBvOPshybE9q6IX8QoFZJsWv+HEV83w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8GoLdALhd6t5myZtRfdPZYF7IYB6neKlZjV4jUoKUnOcKWax9ckWEswkQM2XUKBh94MV6VQzXOCbb2Cm+wRaLvCSDvipFbEAbwg6cL9BVwof3RS2oFr7LT3GsEyzxvXUe51C4U/bQi6In/85Ai/UhzsPQj0z4c2FzTzoPGE38k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285897tafee2776
X-QQ-Originating-IP: 4mgnOffwBDpFNk/GsYaRyXLAWCCEzfXnK3L6oayYNQ8=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12391843874504626479
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 02/22] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Mon, 13 Oct 2025 00:17:29 +0800
Message-ID: <82634D25223A75A0+20251012161749.2994033-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NJyF3+D7p4uc2WoYkosPbVnONsrtgZa0vJNcP9tx7RW4JmKr4IqGagOq
	UewGEDwG+PRMFjr7njMXVfaEB7V8xXluiaKcukEvjfE/ybNxodCYuefDnznBWvp8Oqj4Pap
	CmZ+PXfNMT6CgY1LvB+P2ZrLvdAsD8reMA+aKPHB7cRgQtAht42WuwE0kYqYt2Gcn40s/D5
	DiaF0ytItC/a42Yaop8TZtZkSwX6pNEihOylghx6bd5KYF6CloiG7laXIRk09MzrSM5wZmZ
	JMhaX+JNFo1zWNhXZLE/SVqeWvQ5bpdlfeMpATL3m405/j++rZQN+Czs5h/tM6Fid64HQap
	+2uc+vXVi0vQCz1ninAUe+tamb+PVk2b97t+Rihf9KhYz3kPZ5utb93wG8xpZjXl+8U7/M1
	zv8NVcs4+7nsOGWvrDHQsuthFTw2cY+MFdJZWHCB+aEmAb9QqlDlvFAiCR9qxgSH0CsPcIK
	2PeJTEE3jEAESlyQJlZEc4XvQvTggknfeDBGPRoKyEJ66RYx8WlYjsZq1MQ2BX108Hruyvw
	vv3XL2tzASEZSA52HtOA/WxwEEoYmO8vQH+kagf4aB1HBQIOgaYYcTK+7xJdMaLjtXqLh7Y
	/Enm2xoJT9vM0UdQbE6XqJ/eToWNhVNM8I/+Y3rdycv+Q5qUPmEJAURfzEUspnwbq50yi8R
	9pjmsr2OxDV0MO2t9Sv9Ij0JlQz+Z56IHfblwFiY0vqoNQYq+xpDuAaCL5o3ejfbsYDL1UL
	+1xIZUuFgIXzIhh1ytxcIJhlbchjgWYzB4sUoqBJUaslU1rZB2xg99KOo0LoKkDOGgjyqqt
	gZ+dOBpGavlZveW6dteiK8zUE5wg+PYt7Mtl48U2Ak6e1bo909NY8PAPoXFf30vNT86J/gA
	fmzzKBEZdaTu0qixJa2oX5F7E3QRR0jowf490vH0JYU/Kki1I7bGU1th4M5mNCNJN0dmtym
	uu9oA/IqJ5+27CnXkbnx0jx9SAoav/675vzDl/HlYa41zw0KvRz2RbPSWKWb6KFgy+aviL7
	31hX3ytbihqe9aziuD9pufFOnP5uNvdI/4MokxNYGzbNO6xLZu
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Reference count of ksmbd_session will leak when session need reconnect.
Fix this by adding the missing ksmbd_user_session_put().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e81e615f322a..b731d9b09408 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1806,6 +1806,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			sess = NULL;
 			goto out_err;
 		}
-- 
2.43.0

