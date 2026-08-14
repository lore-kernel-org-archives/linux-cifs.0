Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDFB25A642
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 13:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715542; cv=none; b=RXOM1bRKh7aq3mvlC1CdzXPyKA9vX3UtwsU4XLWdA0jDBh9VZHmDDWKtIuITta5WFMr0c+Y6rFyI1lXkxgNOWMyz8CBnrmmC3BhO1EcSjor0wVZ2k2+H8c/+u2axhEP0zp2zzsjVZon67mDRxNQRUV83JbjdVnmWNROdmL0GD6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715542; c=relaxed/simple;
	bh=ivsYe9GLWAC7+t9g9LQOxSYNe5wueANHX2qlakHZCLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geuuDS5ax2QaL3EsQhba+gimM3uYfmbRsIdaFPGMNk+nPzttV/cRzN0d6TldpqraCCUEKSQeNVlQUjHhuC9xvPDE0ypxKVviAWh1G+g/xjPMvFBzyA/qSJ8jijPJz5GgkEgtbRRjRU4Lyl9queS/mkvooPiIRTT62jK2ksnIBZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 57b4b95497e711f1aa26b74ffac11d73-20260814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:57c0c481-4486-4850-8999-96888c2195b2,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:57c0c481-4486-4850-8999-96888c2195b2,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:ba4500a67d8079bc91e1f4a439db56a7,BulkI
	D:2608142152130K9J2B0R,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 57b4b95497e711f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from workspace-fedora [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1048362576; Fri, 14 Aug 2026 21:52:08 +0800
From: Ze Tan <tanze@kylinos.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/4] smb/server: warn if ksmbd_proc_create() fails
Date: Fri, 14 Aug 2026 13:51:41 +0000
Message-ID: <20260814135144.302443-2-tanze@kylinos.cn>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814135144.302443-1-tanze@kylinos.cn>
References: <20260814135144.302443-1-tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print a warning if the sessions procfs entry cannot be created.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c        | 3 ++-
 fs/smb/server/mgmt/user_session.c | 5 ++++-
 fs/smb/server/server.c            | 8 ++++++--
 fs/smb/server/vfs_cache.c         | 6 ++++--
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index e225aca67686..a627c5d4ed4a 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -746,7 +746,8 @@ int ksmbd_conn_transport_init(void)
 	}
 out:
 	mutex_unlock(&init_lock);
-	create_proc_clients();
+	if (create_proc_clients())
+		pr_warn("Unable to create clients procfs entry\n");
 	return ret;
 }
 
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index f4675c457714..a72dc0211d0d 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -204,6 +204,8 @@ static int create_proc_session(struct ksmbd_session *sess)
 	snprintf(name, sizeof(name), "sessions/%llu", sess->id);
 	sess->proc_entry = ksmbd_proc_create(name,
 					     show_proc_session, sess);
+	if (!sess->proc_entry)
+		return -ENOMEM;
 	return 0;
 }
 
@@ -722,7 +724,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
 
-	create_proc_session(sess);
+	if (create_proc_session(sess))
+		pr_warn_ratelimited("Unable to create session %llu procfs entry\n", sess->id);
 	ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS);
 	return sess;
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index d619d1f22601..513a82afced8 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -628,8 +628,12 @@ static int __init ksmbd_server_init(void)
 	ret = ksmbd_proc_init();
 	if (ret)
 		goto err_unregister;
-	create_proc_sessions();
-	create_proc_shares();
+
+	if (create_proc_sessions())
+		pr_warn("Unable to create sessions procfs entry\n");
+
+	if (create_proc_shares())
+		pr_warn("Unable to create shares procfs entry\n");
 
 	ksmbd_server_tcp_callbacks_init();
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 972e8985a503..532ef727d2f2 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -180,7 +180,8 @@ static int proc_show_files(struct seq_file *m, void *v)
 
 static int create_proc_files(void)
 {
-	ksmbd_proc_create("files", proc_show_files, NULL);
+	if (!ksmbd_proc_create("files", proc_show_files, NULL))
+		return -ENOMEM;
 	return 0;
 }
 #else
@@ -1829,7 +1830,8 @@ void ksmbd_close_session_fds(struct ksmbd_work *work)
 
 int ksmbd_init_global_file_table(void)
 {
-	create_proc_files();
+	if (create_proc_files())
+		pr_warn("Unable to create files procfs entry\n");
 	return ksmbd_init_file_table(&global_ft);
 }
 
-- 
2.55.0

