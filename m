Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF842EC0A4;
	Sun, 12 Oct 2025 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282640; cv=none; b=KZzv9CMKdLfocBadYbR9lgJz2InPSkjelI09WDUWoNqUIIzMNVetLp0fHjUrvK7wqrhqNz2xoFNlLf5xwX0WPIKflqp5P0bSPk+MAv945gObtV3gXmgJr9oLXB4l5qm4tWC/WggFxT+EWkEvsxndJCSJRl1sUIC+eZeuuqAioXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282640; c=relaxed/simple;
	bh=+Y1i4ZX5YAVz0aE+JKDU1tjQg9Po8/DgENzqiLN/5r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5GJ572tgLGjp58WF5wKNQ1SYJ0hbca4Ip9jXpeZvvjLD9i+1uUV3/9bGzerwwh2+70JjNRSm9MxYxAHu8vEaFz4+irIizqvt3rt9lyXpiC+zTD2K92GL4u/17xESacDlCJlM3a/z9LQp9sOUpzdIxsas3iH5vEZrkSCpAK46no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282588tf6b7d71a
X-QQ-Originating-IP: VWQnEKf58oe2EdsKBkJpAUO7Tdy1kaE7uSB6iW9p+6I=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:07 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2849665947815525843
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
Subject: [PATCH RESEND 01/22] smb/server: fix possible memory leak in smb2_read()
Date: Sun, 12 Oct 2025 23:22:26 +0800
Message-ID: <9836A3F274B62345+20251012152247.2992573-2-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: OQDheyKMdrW9H6cc2sFeGDtnNpRjgSra2AwrczGRde0p6VCytTNjgNQA
	XxaZyV+AVi8AeKIj2ydsIsHz3VNfGtPckDrgjncf8h4zp49qAERJCS1fDXagNx454F4WpJY
	owytGfxurXkremQd4yB8txQiTS4MOj1h8a3Xhs5EmBDFiuOV2bfFR2PD0R3qGv4es4Kxvji
	5XrgQLHa1bFjLAAxg7ZOoGw1Si6Cq+oph9WwUhUQfrc8NEgOLIo6EGUEs1yjrWUuzHlYJSC
	tO/I6zIKufb2jw3hvLYcFvuVLrHedkiwZVL9xH8iSJZ40uk+NabmVFxARchmvSKBcHGnbqT
	PldWrw05LPdKNaqvnjzMXmQNh5gq7+qtLMc70EY3FFrwldvhjMfDyzx/3/eIp3WdNl9qmRR
	EWcWwFwmEjdUrqyfZD/PPjLU6n6aGsL8X0uGozOlLuux5dMtZk3M980nQpw7zQrGvkMrbEP
	m1qSCsAYodPZuxUkt0knBb4G5dU/TChfppKi33q1AcbLD5qlxmD8L72cRYfoXZAL2p1w5bT
	kaDtjDAlwQ+O/duq97SmFGT9hiqSXwk5kPFUp0vr5vdZ+WYakdrKo+ZB8kur/oNrlDWxVvj
	/xZBGCQNqoRpjCP/Vi559V/qShmmRf7LkzwjAzjytvWmYjruvkUK2A8Me1Uxf8x1KKwYFj6
	HJugrF9DI1RIlYtn6tfcbNB93Cx+QjTE9DjZQhg/Z80HPqykQGoqUvLKe9DUs3RsztaT6N4
	4RUOc5pji0sRnQHUeiBkcnVeDehkFvrBwHoRihiucrWTiyG/ITBmUHF+0VeTpFV7HixcMXk
	s3SYy8Im1rgHqv33UgbNqJFywTIQM1umb7TJIioBpDrE+vmZ2Poldqo/epJa3TOP5cjj4an
	P65T0oiYKNO0NXxJNlPvc2XhRX4TSpYehcCjwBn8a+Nkwc+2Ic+JhDMLgxGv48MTwbGMiLc
	QxORwNQyZ1TttK0ckKPjZCMG00TrnqELgO/MsjWrYJMZeoeOkwU8fcP4NGeKU+wv6iYQmCp
	GaFiemCRAdK9dNnA18GUfE7FlEeh0+ep3vnSsGefU8REX2sfQML1Gw99xrYakIUX/PbVdUC
	ggCrS9qs2BS
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Memory leak occurs when ksmbd_vfs_read() fails.
Fix this by adding the missing kvfree().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ab1d45fcebde..e81e615f322a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6824,6 +6824,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.43.0

