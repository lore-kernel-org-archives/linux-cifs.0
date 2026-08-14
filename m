Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A327F212542
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715542; cv=none; b=aGaefxHXrDrEqdAjQm1r67MctBOFuYuik53ZeltMywmUJLSqQlGNcoCKtCqCdZmb+w01MCyPOubHs6VkxC3ICmPD5r3TtW6pgBGE+j+n0nxdXmwTuQnxhtKMFZ0gHHFZxmJg0DkViTfChTBkW+c616J0Or9EwlOH5lFXMWQyz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715542; c=relaxed/simple;
	bh=2A099Zqr4XxvZgbAAtt8go+5uE3yOGIDShWBpYEq79Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNXcgTgzGuRaptvxSIyv0R6dIAzbTKfNnWf+WTXzgcXfktisWin6IZY4yKV7rZDPIR1P8FQVBBUhS2JYyRooa1407fbgldFHjc677ZrsKHwyYirwb6AgZjaVcyD+ZG1N8/dg2G1bcBQb3lzCNHL+voURmNXP8yxjBq1fIpzR5xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 583a8eee97e711f1aa26b74ffac11d73-20260814
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
X-CID-O-INFO: VERSION:1.3.12,REQID:35cc81c6-aa51-4ed9-a256-2f77d55ae5ab,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:35cc81c6-aa51-4ed9-a256-2f77d55ae5ab,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:725d8959efbec23d330e46c49342fb79,BulkI
	D:260814215213W39V05CN,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 583a8eee97e711f1aa26b74ffac11d73-20260814
X-User: tanze@kylinos.cn
Received: from workspace-fedora [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1122191386; Fri, 14 Aug 2026 21:52:09 +0800
From: Ze Tan <tanze@kylinos.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 3/4] smb/server: update session counter under sessions table lock
Date: Fri, 14 Aug 2026 13:51:43 +0000
Message-ID: <20260814135144.302443-4-tanze@kylinos.cn>
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

KSMBD_COUNTER_SESSIONS tracks sessions published in sessions_table.
Increment it while holding sessions_table_lock so publishing a session and
updating the counter happen together.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/mgmt/user_session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 0fc26012dbbb..f023e0d2b8f0 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -733,11 +733,11 @@ static struct ksmbd_session *__session_create(int protocol)
 
 	down_write(&sessions_table_lock);
 	hash_add(sessions_table, &sess->hlist, sess->id);
+	ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS);
 	up_write(&sessions_table_lock);
 
 	if (create_proc_session(sess))
 		pr_warn_ratelimited("Unable to create session %llu procfs entry\n", sess->id);
-	ksmbd_counter_inc(KSMBD_COUNTER_SESSIONS);
 	return sess;
 
 error:
-- 
2.55.0

