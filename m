Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D49016F271;
	Thu, 22 Aug 2024 08:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315027; cv=none; b=CdMR7x4G5bRGvecbQBD1XL9fRx8LcHJmOJ5lG1TRMJA4Ytzy+f+X6QsUHgQkOdhRHmMJrm7CUD7yPxnf2MAt+iZT7StD+h75MNC5XN2Ob+86FyyGEUJRKQ2CGsACvPtfQwMSjiRaVozZxZD2CfEXeMxMLFqXfnvcdbv0A3w68bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315027; c=relaxed/simple;
	bh=jlyigKhMI1EqKcMCONT5den++7pPyf4NWJReMoZ7e7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T8OFWZ1pABdaO/HROJcaWVF6RxeTNYThUwKUjPH6f3bSBna3S133kmDF2q8Vjhqq89pllyMd6+UvMwtIcqX8f28UhOa/sKy02M4oYOtSGzL8JDaKWmjuG3qXX4dnLpQbERxUnNX5uxKuZiTuyWxn2ZWG/OZecI9oCn4BwcKzTb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314935tvlnwhbd
X-QQ-Originating-IP: /z+i4NwoSc7qAiLC71ItP+Q4ohKswnebu9hvrXZ9xTk=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:22:06 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8359037177853287873
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
Subject: [PATCH v2 04/12] smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock
Date: Thu, 22 Aug 2024 08:20:53 +0000
Message-Id: <20240822082101.391272-5-chenxiaosong@chenxiaosong.com>
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

The comments have typos, fix that to not confuse readers.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsfs.c   | 6 +++---
 fs/smb/client/cifsglob.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 2c4b357d85e2..d89485235425 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -75,9 +75,9 @@ unsigned int sign_CIFS_PDUs = 1;
 /*
  * Global transaction id (XID) information
  */
-unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
-unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
-unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
+unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Lock */
+unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Lock */
+unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Lock */
 spinlock_t GlobalMid_Lock; /* protects above & list operations on midQ entries */
 
 /*
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 5c9b3e6cd95f..7ebe80a25d04 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2017,9 +2017,9 @@ extern spinlock_t		cifs_tcp_ses_lock;
 /*
  * Global transaction id (XID) information
  */
-extern unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
-extern unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
-extern unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
+extern unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Lock */
+extern unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Lock */
+extern unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Lock */
 extern spinlock_t GlobalMid_Lock; /* protects above & list operations on midQ entries */
 
 /*
-- 
2.34.1

