Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD5F25524C
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 13:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715541; cv=none; b=t9Bgk06RMymsOligXNhZmBBLOqvMql0vdhoPe8gH2k1yosDnVu1FEYN6AUHL8Grqy70acIhFCz93NrtMyMxqserMqUH+053SDk8hbNgQV/oL3DSNi80QMegzqPC1NhtjeRB53aToRqGwQD5IixmbB9Te0blS5hqIl+QBkY7rIRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715541; c=relaxed/simple;
	bh=7nxypR4mBpSE4Vskt83R3OuooREodzTqHr9rTJdctqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgUzSB5Ez17QsKuTNukEe9Djn1+I1kUm/5Wi0+ZLJiT7gxmuvbtS5KUVcb/fV89DKpNra0NPM3Lnhfi+pDTQnrouHtwqraGnwjLP5AORX8v5xMXE0jNa762TM9wdX5zU1QIDsFP37sdYbOMuVCR69nLC29VlHriLTCseousOGoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 587d371297e711f1aa26b74ffac11d73-20260814
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
X-CID-O-INFO: VERSION:1.3.12,REQID:0d969b36-e554-491e-a064-26186fcc4074,IP:15,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:0d969b36-e554-491e-a064-26186fcc4074,IP:15,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:162032c5d86df78870348ba3c168ee38,BulkI
	D:260814215213XJ2Q28OB,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 587d371297e711f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from workspace-fedora [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1994718836; Fri, 14 Aug 2026 21:52:10 +0800
From: Ze Tan <tanze@kylinos.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 4/4] smb/server: fix session counter on session removal
Date: Fri, 14 Aug 2026 13:51:44 +0000
Message-ID: <20260814135144.302443-5-tanze@kylinos.cn>
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

See the procedure below:

  smb2_sess_setup
    ksmbd_smb2_session_create
      __session_create
        hash_add(sessions_table, &sess->hlist, sess->id)
        ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS)
  ksmbd_conn_handler_loop
    ksmbd_server_terminate_conn
      ksmbd_sessions_deregister
        hash_del(&sess->hlist)
        // do not decrement KSMBD_COUNTER_SESSIONS

KSMBD_COUNTER_SESSIONS tracks sessions published in sessions_table, but
session removal does not decrement it. The value therefore keeps growing
after sessions are expired, rejected during registration, or removed on
the last channel disconnect.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/mgmt/user_session.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index f023e0d2b8f0..1a0b2901ad21 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -413,6 +413,12 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	kfree_sensitive(sess);
 }
 
+static void ksmbd_session_remove_from_table(struct ksmbd_session *sess)
+{
+	hash_del(&sess->hlist);
+	ksmbd_counter_dec(KSMBD_COUNTER_SESSIONS);
+}
+
 struct ksmbd_session *__session_lookup(unsigned long long id)
 {
 	struct ksmbd_session *sess;
@@ -439,7 +445,7 @@ static void ksmbd_expire_session(struct ksmbd_conn *conn)
 		     time_after(jiffies,
 			       sess->last_active + SMB2_SESSION_TIMEOUT))) {
 			xa_erase(&conn->sessions, sess->id);
-			hash_del(&sess->hlist);
+			ksmbd_session_remove_from_table(sess);
 			ksmbd_session_destroy(sess);
 			continue;
 		}
@@ -460,7 +466,7 @@ int ksmbd_session_register(struct ksmbd_conn *conn,
 			      KSMBD_DEFAULT_GFP));
 	if (ret) {
 		down_write(&sessions_table_lock);
-		hash_del(&sess->hlist);
+		ksmbd_session_remove_from_table(sess);
 		up_write(&sessions_table_lock);
 		ksmbd_user_session_put(sess);
 	}
@@ -493,7 +499,7 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 	hash_for_each_safe(sessions_table, bkt, tmp, sess, hlist) {
 		if (!ksmbd_chann_del(conn, sess) &&
 		    xa_empty(&sess->ksmbd_chann_list)) {
-			hash_del(&sess->hlist);
+			ksmbd_session_remove_from_table(sess);
 			down_write(&conn->session_lock);
 			xa_erase(&conn->sessions, sess->id);
 			up_write(&conn->session_lock);
@@ -507,7 +513,7 @@ void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 		ksmbd_chann_del(conn, sess);
 		if (xa_empty(&sess->ksmbd_chann_list)) {
 			xa_erase(&conn->sessions, sess->id);
-			hash_del(&sess->hlist);
+			ksmbd_session_remove_from_table(sess);
 			if (atomic_dec_and_test(&sess->refcnt))
 				ksmbd_session_destroy(sess);
 		}
-- 
2.55.0

