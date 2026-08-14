Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B14126BE1
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 13:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715542; cv=none; b=ZRSjhluTyvQFCHNWuRPtEMKVULji5CzOpH2aWALkuwCTjQpOGhcMGsoawvm3B6J+oFc7T0nqg41RXc4VzsvwaZah+MyRP2Hhp1/xSicOOBWkZZs7rpaAswZ1hSf1N2rvg2DzWexQgtsTlfuf5ropM5aVxLV27js3jI2Bj6bYC1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715542; c=relaxed/simple;
	bh=DZWluuNOSX5Bsj3VqukTkvfB1pD+8vOPjRHrUd2YbBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDMI62E9JyOM4rccRDbKSZUfE9NsISxqf7m1SvjD3mk9kkU+k8cG1y09wOYvmNncurDAn+d772akze9MOj4zDMoz6uAX6W7ZK++G1NNUvxFnRNsOtLBBHHtHf0ZHB+xEfmr/nHxHX1zS/FmIfcBuYNrW6zxV/7f/t3xCt9sLEec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 57f7baba97e711f1aa26b74ffac11d73-20260814
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
X-CID-O-INFO: VERSION:1.3.12,REQID:5d2e28e4-f31c-4bc0-8f74-2e3177f66a79,IP:15,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:5d2e28e4-f31c-4bc0-8f74-2e3177f66a79,IP:15,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:f6f68381b9fb1c73611ba40d2a270ef8,BulkI
	D:260814215213KNFNSL62,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 57f7baba97e711f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from workspace-fedora [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2004323017; Fri, 14 Aug 2026 21:52:09 +0800
From: Ze Tan <tanze@kylinos.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/4] smb/server: fix session leak in ksmbd_session_register()
Date: Fri, 14 Aug 2026 13:51:42 +0000
Message-ID: <20260814135144.302443-3-tanze@kylinos.cn>
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
        atomic_set(&sess->refcnt, 2)
        hash_add(sessions_table, &sess->hlist, sess->id)
    ksmbd_session_register
      xa_store(&conn->sessions, sess->id, sess) // fail
    ksmbd_user_session_put
      atomic_dec(&sess->refcnt) // refcnt is 1, session is not freed

Remove the session from sessions_table and drop its table reference if
xa_store() fails.

Fixes: f5c779b7ddbd ("ksmbd: fix racy issue from session setup and logoff")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/mgmt/user_session.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index a72dc0211d0d..0fc26012dbbb 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -451,10 +451,21 @@ static void ksmbd_expire_session(struct ksmbd_conn *conn)
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess)
 {
+	int ret;
+
 	sess->dialect = conn->dialect;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 	ksmbd_expire_session(conn);
-	return xa_err(xa_store(&conn->sessions, sess->id, sess, KSMBD_DEFAULT_GFP));
+	ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
+			      KSMBD_DEFAULT_GFP));
+	if (ret) {
+		down_write(&sessions_table_lock);
+		hash_del(&sess->hlist);
+		up_write(&sessions_table_lock);
+		ksmbd_user_session_put(sess);
+	}
+
+	return ret;
 }
 
 static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
-- 
2.55.0

