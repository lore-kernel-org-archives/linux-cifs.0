Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.58.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B21C4631;
	Tue, 20 Aug 2024 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.58.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164619; cv=none; b=pPGi/VJhPfEUhiP6jeyw55h21ef7i5rTccrXLqmbXRfA43sj1Pz7x0NPhlNO0U86Y14TdsJiPoHnoT6ArVZGLwZV7Xp56SbknTOlYxQH1B8gHVZTI+/bYR38aSTz2Vl48iNaaIz6Kv0D6k1UPoATLLRFlxYbUsXDWRzrqpczksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164619; c=relaxed/simple;
	bh=5WKFmMiK1A6Ge674LNnmmM/4JViFss5NZpUQwWYGunY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RKB0DTjguy0fqg0C8qY7YpVn9Vm+co7TivF/TWBSlPwWBVqTj/HRgJaNIZzAKQ2RyONqUqU3bXeTSAU5rDMuU/P014Hg+UYEiaInFi6ZfqYysYnfCfATutoWa33cez+4TnupxoSuALLZy9aV28WJdX5ET84nvLbFjdKjxUo2HlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=114.132.58.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz13t1724164452t8aoj9
X-QQ-Originating-IP: 6un5EVb3PB0T8n+h40gufD33xqtcdx4VDbWGYLwtZfk=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 20 Aug 2024 22:34:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 4418011969623935280
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
Subject: [PATCH 4/8] smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock
Date: Tue, 20 Aug 2024 14:33:15 +0000
Message-Id: <20240820143319.274033-5-chenxiaosong@chenxiaosong.com>
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

The comments have typos, fix that to not confuse readers.

Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
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

