Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1A93D5237
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 02:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786675048; cv=none; b=qNN9lQmz8fCDyrOudz9aeC9cndORqfwNhEh4uV+/N1NcpD1QA+W1BqIwEqn2k0A+SL45V7Z1xCTA7uVgkouebjiGxJ2Giv8qUQXCpW5UWegf4fA9AcPWQSzh2K1wGncByrFTOQWT7e8wJ2wz56OEUSfdyHCRgVLD1gUmA4AQjRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786675048; c=relaxed/simple;
	bh=KiHaB3IMbFeI7YWbk0VEptRg6Hvt4oPs8rhQ9F6s/G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tF+ECVWMWTGF7p1IGCa4UsWA5WQ8ZqfPyoGCCK7YcyVutrpLo5ykQr1BOOKYjiwRAVBFDmijQ4rVKXujqjPSGtCLifQbTVlbjyw0/OuJf3LTnKDBqwdDGy8ieIAQx4gYmOiEKTw52VA1cP7854kSDKxun7Y1zSq7H9FGleH1Ahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0fbd3332978911f1aa26b74ffac11d73-20260814
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
X-CID-O-INFO: VERSION:1.3.12,REQID:831494b2-99c0-4ffe-a4e9-8ccbc57463d7,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:831494b2-99c0-4ffe-a4e9-8ccbc57463d7,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:818cd8f8c137597ea5c6c8786a7f8f7f,BulkI
	D:260814103719AZ6074IS,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2|1,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0fbd3332978911f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 272382335; Fri, 14 Aug 2026 10:37:15 +0800
From: Ze Tan <tanze@kylinos.cn>
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	constant.lee@samsung.com,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/3] smb/server: fix tree connection leak in smb2_tree_connect()
Date: Fri, 14 Aug 2026 10:36:29 +0800
Message-ID: <53c06a45facec8c91593ff75ee102ebabb358a9a.1786674373.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786674373.git.tanze@kylinos.cn>
References: <cover.1786674373.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

See the procedure below:

  smb2_tree_connect
    ksmbd_tree_conn_connect
      xa_store(&sess->tree_conns, tree_conn->id, tree_conn)
      ksmbd_counter_inc(KSMBD_COUNTER_TREE_CONNS)
      ksmbd_share_tree_conn_inc(sc)
    ksmbd_iov_pin_rsp // fail
    status.ret = KSMBD_TREE_CONN_STATUS_NOMEM
    // do not disconnect tree_conn

Disconnect the new tree connection if ksmbd_iov_pin_rsp() fails.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 835d9e2aacc4..cac83b89535c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2691,8 +2691,16 @@ int smb2_tree_connect(struct ksmbd_work *work)
 			cpu_to_le32(SMB2_SHAREFLAG_ACCESS_BASED_DIRECTORY_ENUM);
 
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
-	if (rc)
+	if (rc) {
+		if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
+			down_write(&sess->tree_conns_lock);
+			status.tree_conn->t_state = TREE_DISCONNECTED;
+			up_write(&sess->tree_conns_lock);
+			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
+			status.tree_conn = NULL;
+		}
 		status.ret = KSMBD_TREE_CONN_STATUS_NOMEM;
+	}
 
 	if (!IS_ERR(treename))
 		kfree(treename);
-- 
2.43.0

