Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BB52EC097;
	Sun, 12 Oct 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282654; cv=none; b=XQouqljkrztDBXP88jLAKKH7PAE682xAwGXkWivDXzFI+Iisa7k56cKyATwVBrGj4XymXHnPXQbDUHRit6iwtmL3ppJm1WZk5+NNgc3sRqMGlZle60wYS51or+saQg1M7W91qg3cvGrTE9fS1H8ktQ0HU2v4HDK++xrk+sOdK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282654; c=relaxed/simple;
	bh=LzJ+/nuwdxTRfBvOPshybE9q6IX8QoFZJsWv+HEV83w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2DU62qOymRVNKNT5vC/RKcS3IPy6Xnhf5CG9Odz/rWlfs87nMBOIFxm6gudQOm8tnQGtEjBUcZj21KCQiq4BKY8OZRXrSs5Sz0zx13AwMA2pPqlmdJGijhxMcif5SuIZxWSS6lSZh7VmrCjte+ujJMm5fEp90pogj0UjQZA4xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282591ta3bdd2b1
X-QQ-Originating-IP: SEyL7S5qpA4WwYpthX6mdLh+E1OOH5iTBDqCBvn3g84=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1132431418211425726
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
Subject: [PATCH RESEND 02/22] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Sun, 12 Oct 2025 23:22:27 +0800
Message-ID: <282F68460576D756+20251012152247.2992573-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: Oa2shA1LYpbMFFFQ6qFROplspGUR1uRyAcjk5s26Qxl0XgK2FN+f2ahh
	A/tfYWEee3UGCaojoWy3SChZUsnlvT8NA5GiVVPQRV4/FC+MWHNY8ACOMzestdWD6+L1DIT
	Qs6u+6iSnW4+GqP4hIFjuA3nA18pjhO4mPy/K+lBaMVyz203AQzLRFsoALSZCmAngus1iZ4
	VNdE3SExV71JV81diUViHvXERrP9hRYxWGJ7nbTmOq/bU9sviJmpWnoudkn+TsObXbJS3a1
	ayE9iRWBUMswkT747ENT/rpaTT14eoSDOFdNufPtO0ezeWJiwoaxxazpJ09dIXPIEapQBQn
	EiN4mwucxBWjikArJ7TPqCwK91GJ/xbn72qVDFUUjjpoZ5wQjt5ZD/BwjVXIcyTX6+I0E1N
	SDBPobHObtfc/aNPOvltTV5XbOsvvz9YpBujrIAPzhJLqI01zRmIhY4pB36nNMmqeebb/d6
	HBX1S7ALvTKU05HWoxS8niyN7XQbbK9jSo6R73zYrsxSYvkNoCsI7nPn0vMNfcuq4jlySsY
	VkOGDDQcZ/tlqLGyAwq5zWWFCQVuNujz9SUQ7ExEAErPyvOUsPpYmln6e+Y7fdoqb0ojMpE
	KSuwvPFx3ZWZglms6Buuow54uclm2JMeUeMxQSOqXA05Z4Vwexg7dBPbYGSm19lSYizjvpq
	R6AlgWEl4tyF4wakDgo1EFBvGrZEEFrCrQeY7eLjNnr5Z0mYW/sGBNlKuKtyZ/wRjRTbCCD
	3C8r63AveJguD7wmAn7xQv3Cf8q6ZgbXY/tCNxevXfxxKUt6NAXXLY5Pvhd98QgKC86IWL+
	ekYGJNWFdbhEnL1Xm5AwYnEbJq99BnEDTXGpPcUCRuvBHYwH4I1WfIxODdDwjABVQzo5Kx4
	UWYkRoSv6aliRxp0h8pRw/ODr2xX319AYF5aYjqcBZ351zAkeLbGhee/fs1KGoUqCgHeilN
	y9fF7w890fXTcDSiRGp3qIEm5oGxysOkuF31CZAsSAVqFSxw2QD36g2KUqkKmTHcbl3K0T1
	igbt0t/NxuiaadDTpqbBSqHmb3QRe2++VB3Kh7LDFz62bWtAhEab88y48543J92J/qXJVjH
	457pbM5hUdh
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
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

