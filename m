Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6782951A7;
	Sun, 12 Oct 2025 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281899; cv=none; b=kQCdM6b0MJeeAzoZKIlBOOULthodNLnaIDVV6l79+twvDUy7NqnAGHIvYRlYuZ0WeiLDYh6h5yFRI3xqRogacBzsUUuspi2xNCgJHTyOPYvb76wHkEdyjGG+YPTw/9nEQmZNTmqyVymPIM5s7GotOC/pigR/3PlYCKbCFA868vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281899; c=relaxed/simple;
	bh=LzJ+/nuwdxTRfBvOPshybE9q6IX8QoFZJsWv+HEV83w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZOETo6iWhtyqiM1ntxKuPb7Lhee05I0IgvcQtFdweK3SswJNW4K+a1cBG7ePWLi0RuqI25/hbB7/rAqIxJOVHlHVEp9MkFb7MmD+C8bEyE00/m9afuXpWupKeswuB6jfj0vl5id0M482EMxcAPztNzTCztbvhLqd18SpDbaHiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281809t61091223
X-QQ-Originating-IP: ts3zpHnvugKLdR1bU9Ety5x3SB1CrwRQNFARtA+3wX4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3917531318074874974
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
Subject: [PATCH 02/22] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Sun, 12 Oct 2025 23:08:55 +0800
Message-ID: <0855DD8681EC3496+20251012150915.2992220-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M5EckrgUwuIS0FCnIXGBI//CDjfwIzZU+dyzXDJzr2F5I9t84hJy1Akd
	nelEhPSKKdMu3LmU/lf2+jgTXNF30w/uMLp4rrG4ceKNwrHKzRi9wmuPFWatrpA149LETnT
	5IxppbDJlRW+aGLiIX6cLWFY9OGHnWjcuGLfwo8B8pT8LJrnRxF838cGikLYs0AyoigTuN5
	4XQgFa7T6ta4vV9/dx1mFYmLUWZEkisaHjIcRE4QhFs94gys6vFjbFKGgptzNUsdZO/XUHa
	SJD2yUBQZr/naz/jvl3PPNf13g/6dsgjgHfFc+YEwblg43GwdjN1XORFhYVbFU77PnOJjU/
	jdRrn5Ia739migmgjckX+LGDFJQHA7/+lQT9qtkj1qfgMuKh/S2M4gDqG/lv0gUcK9orsSV
	HzaFqGFYxrRh8vMspaIo6GQOO1ooOqh5hHIWbaDa0mXv9X2cK1HzLgKWn6mQ9t4IkXkXj8t
	lJFQKMhZlMIDIb98kug/6d8k/1KMx3qVQwESK4bhKuhp5yhqanZ/FuYNXcqcDFMP768OjyF
	JA3SYqML0LvN922odoAhFwrcfLJPgSXwWaM2EE2sabaMxbUMdRaWbrPh25BOtR5smDFgfz1
	OsU66k1JRiRCZtHYwRHpNIMKUGQecRDhDd3e7/3EvauBP97f0yf5JNkJkNESJrLxhLZx6ld
	tp0g0ejxuiTcMd7Evp85rmot6CtAz+NVphUXqa7EJ12C1ouT8PkXf9zXYeG5Bz9bO9YbMfn
	FrP/D6zVAHktNQLVbXrEaPIiK2mfgLg2VNETC0mgEerXEpSbPoeipEL0BHUkhc+oW+1z+9/
	NYrSaZ2CANp8bex5wDtk7AXLeIf1gvcrov12uiY/x9ythGLcUialvK7/Fc2n/SIiKy0vjuB
	AMy0vSoVt5hRIUEIrb/bLyvDLAht8atALLgQDuFwh1ryi+jWypopM/2CdNmVaR2HicHUKBt
	FGXMc0VbO10+1hzfQL2uhk50ixgea8B7iZaKGbHPs5tPO+sr2BNByDLRELJ4Jn/05Qmb/va
	+X4zHESiUw8en2TYbJEN7/TR4PUlc=
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

