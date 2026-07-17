Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802FA37BE80;
	Fri, 17 Jul 2026 03:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259623; cv=none; b=rj4544/Dqw+vbJSHV9vd43C5AxGsDVEV7qcmfLfy0iXG38QV823BtrfG41zt3LVW/mgnSXFWsqzAdpG98jNsFJCHr8gBIa2NifaP68QvS34Zf6x7SB6Danl4LUQzF/T/1zVxXsloYxpo4Cvp9f30tDn83miZvw9bd5YZfRWVYNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259623; c=relaxed/simple;
	bh=yxVbMvJOYPtAxSynYawp9hhn3qIDuH4QCT75qRVh5Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQYkDCl7PWuwn/PQ68Qgtbb28EoS1A5/JaasJNeAh3JDP9wtmGOc3lcjEiWhFlpIBOhDUxUDjmeMZly42QP4y2ShRyzDtBaS9zsjWCqjszSBq+RnKyRA0cnpGAzjmT5JcBzd7IXvahv7CUGRxNe2QtRH8zxnQjWEDLbZJRQTT1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3872483e819111f1aa26b74ffac11d73-20260717
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b494fd96-a682-467a-ad68-123ecd9c8be2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:b494fd96-a682-467a-ad68-123ecd9c8be2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:a7dbfa419539c7ca40503006457835b2,BulkI
	D:260717114015AMVYFD6Y,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3872483e819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 280125222; Fri, 17 Jul 2026 11:40:14 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	sprasad@microsoft.com,
	tom@talpey.comm,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tanze@kylinos.cn
Subject: [RFC PATCH v2 9/9] ksmbd: avoid self oplock breaks for EA opens
Date: Fri, 17 Jul 2026 11:39:27 +0800
Message-ID: <37f280818ac592b7e641d08325b4c10ae6bb7c99.1784258165.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784258165.git.tanze@kylinos.cn>
References: <cover.1784258165.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

generic/093 writes to a file after setcap sets security.capability. The
CIFS client can reopen the file to query or update EAs while the same
session holds an oplock. ksmbd breaks this oplock and waits for the same
client, so the write can block.

Skip the oplock break for same-session EA or metadata opens. Keep the
normal break when another session holds an oplock.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/server/oplock.c | 49 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 3c55ae5d6a11..85f7c29fc2c4 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1424,6 +1424,49 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 	ksmbd_inode_put(p_ci);
 }
 
+static bool ksmbd_skip_session_ea_break(struct ksmbd_work *work,
+					struct ksmbd_file *fp,
+					int req_op_level,
+					struct lease_ctx_info *lctx)
+{
+	struct oplock_info *opinfo;
+	bool same_session = false;
+	bool foreign_session = false;
+	__le32 ea_meta_mask = FILE_READ_EA_LE | FILE_WRITE_EA_LE |
+			      FILE_READ_ATTRIBUTES_LE |
+			      FILE_WRITE_ATTRIBUTES_LE |
+			      FILE_READ_CONTROL_LE | FILE_SYNCHRONIZE_LE;
+
+	if (!work || !fp || lctx || req_op_level != SMB2_OPLOCK_LEVEL_NONE)
+		return false;
+
+	/*
+	 * Avoid self-deadlock when the same session reopens the file only
+	 * to read/write EAs or metadata, e.g. CIFS killpriv querying or
+	 * removing security.capability during buffered write.
+	 */
+	if (!(fp->daccess & (FILE_READ_EA_LE | FILE_WRITE_EA_LE)) ||
+	    (fp->daccess & ~ea_meta_mask))
+		return false;
+
+	down_read(&fp->f_ci->m_lock);
+	list_for_each_entry(opinfo, &fp->f_ci->m_op_list, op_entry) {
+		if (!opinfo->conn || opinfo->level == SMB2_OPLOCK_LEVEL_NONE)
+			continue;
+
+		if (opinfo->sess == work->sess)
+			same_session = true;
+		else
+			foreign_session = true;
+
+		if (same_session && foreign_session)
+			break;
+	}
+	up_read(&fp->f_ci->m_lock);
+
+	return same_session && !foreign_session;
+}
+
 /**
  * smb_grant_oplock() - handle oplock/lease request on file open
  * @work:		smb work
@@ -1529,6 +1572,12 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		goto err_out;
 	}
 
+	if (share_ret >= 0 &&
+	    ksmbd_skip_session_ea_break(work, fp, req_op_level, lctx)) {
+		opinfo_put(prev_opinfo);
+		goto set_lev;
+	}
+
 	if (prev_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    prev_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		opinfo_put(prev_opinfo);
-- 
2.43.0

