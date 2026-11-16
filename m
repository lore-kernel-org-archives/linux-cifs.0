Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794799409;
	b=xquktKu/W8h65YnFTdYxFxqgnKXz5PIr3sJeeVmHt1bGZr2j8Lnnlzbo2jhv6qMGPEOo
	 tpm/bEsVS4xhe2Yn5KBjFbeSnq0z46MQ6mCKLWArRumGPzt+1V33jfQeqtM+/ki3rcoeF
	 MqjFubW+hPS9wDP+LXxiv0gZhTc1YODlpX9dFJNmeveVrMQjrs+esLbAGWXEkBt7bOF9x
	 urZYJbf1YeEQCtLofwNtcjRa9JWshJ8tnrkrvhLACHhzRmbNgyF3pylskunAjFzbB8I9J
	 tnEXGdZmAIXXBO07HWvWoiCeUUOV7fozdDXjsRvV7ztU1dgBzkQpHpLqA4kBUyjfr4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794799409;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NtqQG4iSjSR2MiybxziLAxicQlJIv1MnZs5UbCQXXsk=;
	b=yxXXp1R1ripVCV+kmhWsj1HdxxeiVmBpwMIZLgZorLV0sEaTHPGMlKxPVupvuf1JjqIU
	 gNKqjvi5lGd7fYp0y1Ut4NiBNnZhb+beXxuyFIPON694ySTo0WHSbFP+HxS8ofUB+BEGS
	 i7hi0UX7W6DqaLhzww/rKrAedK1M8+HWqfdY8W/428G28jmuo4G85FZtotF9CQxnazg+v
	 DUcQziw25l1sdH0w8+HwrZ/QXg3MbrXEPmdzwa7Wd1ou1TJCm6I4I3oupVZKed+i5FLY9
	 KzFC4BntzfWmwZ/JE+D9wEmauhzgVsO+CqjbTiksR3Zpyj0UXSSq/Rg9FbXoehr+1Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=yzHvi4H6;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B767B606A334;
	Mon, 16 Nov 2026 03:23:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B767B606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=yzHvi4H6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=yzHvi4H684dzVIN1ixp50ZmoKGTGwQGV/179ObX51mOnY1TNNmxslgTxtzcEq2zdcbyE0g0sy5YPX
	 aZmFKV914/bauJmKpxL72q1BxvgPUkllOWikOYXa0BZPyWN8FOpdT1FnvHiY6+qPcPwXHIsaKQhpUO
	 zZVMTyIPh3X2eJTk=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46afa772cf42-9b13a;
	Mon, 16 Nov 2026 11:23:26 +0800 (CST)
X-RM-TRANSID:2ee46afa772cf42-9b13a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from fedora (unknown[223.108.79.102])
	by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee26afa772bb5c-7ad09;
	Mon, 16 Nov 2026 11:23:25 +0800 (CST)
X-RM-TRANSID:2ee26afa772bb5c-7ad09
From: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Subject: [PATCH] ksmbd: remove unreachable input length check in FSCTL_SET_SPARSE
Date: Mon, 16 Nov 2026 11:23:14 +0800
Message-ID: <20261116032314.46458-1-wuyiqing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The FSCTL_SET_SPARSE handler checks whether a nonzero input buffer is
smaller than sizeof(struct file_sparse) before parsing it.  That
structure holds a single __packed byte, so a nonzero in_buf_len is
always at least sizeof(struct file_sparse) and the condition can never
be true.  GCC flags the dead test when building with W=2:

  fs/smb/server/smb2pdu.c:12035:32: warning: logical and of mutually exclusive tests is always false [-Wlogical-op]

Remove the unreachable branch.  A zero-length input is still handled
by the call site, which passes the local SetSparse default instead of
the request buffer.

Signed-off-by: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
---
 fs/smb/server/smb2pdu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index be226664b8af..08d10286cccf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12032,11 +12032,6 @@ int smb2_ioctl(struct ksmbd_work *work)
 	{
 		struct file_sparse sparse = {0};
 
-		if (in_buf_len && in_buf_len < sizeof(struct file_sparse)) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		*(u8 *)&sparse = 1;
 		ret = fsctl_set_sparse(work, id, in_buf_len ?
 				       (struct file_sparse *)buffer : &sparse);
-- 
2.56.0



