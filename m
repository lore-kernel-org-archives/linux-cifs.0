Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.67.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA961BD03B;
	Tue, 20 Aug 2024 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.67.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164611; cv=none; b=tnPgYZCxG2vw0XsP8Ud+aFJV+ygYpuDXN/bE/6b31KTGBoc3r0zuwO02a+2EmS0ZsXANeD9xxxgOGjh73RxAzg27p61A2W7J+8QMFWRlHAVscy4KmHMM3vnxH5J1SNJq3lowFsWIGUMDRqbx7c++wx8rwBvuETU8PFpCl1YjorU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164611; c=relaxed/simple;
	bh=AHsj+lkL4gAcct16Db/0Gq9g/QXByj6CbgSwmJOoKCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JiE0wgjwzSkk46FVbQbVvLobzPWO10hR2KWXKOpz/3DRzzHVXdUp4t3u7BOUjiLkyfrbpdCEPYhjUqKjluxnXGM1aXpj0tP7U3JXrQPvYSmJMQ9UCBKWBcBQM/QxgTkTHbwqI7Vvz3cVDb+b/yM16qdH9ZzOZqJDVvKiPIQf8/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=114.132.67.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz13t1724164447tcvmcj
X-QQ-Originating-IP: Nx1+9CYaiCdQOfphM7sLh8mPjcMR+erolHuc9VjpznE=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 20 Aug 2024 22:34:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3618686590817847333
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
Subject: [PATCH 3/8] smb/server: remove useless variable assignment in smb2_open()
Date: Tue, 20 Aug 2024 14:33:14 +0000
Message-Id: <20240820143319.274033-4-chenxiaosong@chenxiaosong.com>
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

The variable is already true here.

Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
---
 fs/smb/server/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 119c1ba5f255..4e87bbac2662 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3100,7 +3100,6 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out;
 		}
 
-		file_present = true;
 		idmap = mnt_idmap(path.mnt);
 	} else {
 		if (rc != -ENOENT)
-- 
2.34.1

