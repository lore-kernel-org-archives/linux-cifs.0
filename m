Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3BE222582
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907431; cv=none; b=I2Oe1BD49yAqBDcw+v2ZFNTXQsX+ufX+lzgah0lOoT/D69jEJkOtTilb+Sf3jq+3gM+0EyTHAVAuGr9tZyBGUVIVpmKz6SGYAyr/sB7CHmO1qb0tPgob3yDftoyzjWstHd9yKoeEPQLjHZlvg50wxcYeMGqnK15SPTehX4jPBvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907431; c=relaxed/simple;
	bh=B9LsAYkhqTJaDS/bId014jHSBOAIFlr8FZeHb6E9ho8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=VLW67yRuoDDCRCffDzlMHmLX2VtGkqym6+Yi2dq5fQpfTadZigYht7xIMry/V64c3Rrg2jjLPF7hdqgYNg68oY3snwmkJYk7bWO4s5+KaomPLfrNWc64xuiSsnk3Jjicvq25ej60WFAgUd4GJtF9BqVMu56J8hoFck/8ft8jU2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.51 with ESMTP; 11 Aug 2025 18:47:07 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.31.96)
	by 156.147.1.121 with ESMTP; 11 Aug 2025 18:47:07 +0900
X-Original-SENDERIP: 10.178.31.96
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	gunho.lee@lge.com,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>,
	Chanho Min <chanho.min@lge.com>
Subject: [PATCH 1/4] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Mon, 11 Aug 2025 18:46:36 +0900
Message-Id: <20250811094639.37446-2-chanho.min@lge.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250811094639.37446-1-chanho.min@lge.com>
References: <20250811094639.37446-1-chanho.min@lge.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

From: Paulo Alcantara <pc@manguebit.com>

commit ca545b7f0823f19db0f1148d59bc5e1a56634502 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ This patch removes lock/unlock operation in routine cifs_ses_exiting()
  for ses_lock is not present in v5.10 and not ported yet. ses->status
  is protected by a global lock, cifs_tcp_ses_lock, in v5.10. ]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
[ chanho: Backport to v5.4.y from v5.10.y's commit 8f8718afd44 ]
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c | 2 ++
 fs/cifs/cifsglob.h   | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index efb2928ff6c89..df3dfa611c352 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -162,6 +162,8 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 				    tcp_ses_list);
 		list_for_each(tmp, &server->smb_ses_list) {
 			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp1, &ses->tcon_list) {
 				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 				spin_lock(&tcon->open_file_lock);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 253321adc2664..5f545a240afa6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2027,4 +2027,12 @@ static inline struct scatterlist *cifs_sg_set_buf(struct scatterlist *sg,
 	return sg;
 }
 
+static inline bool cifs_ses_exiting(struct cifs_ses *ses)
+{
+	bool ret;
+
+	ret = ses->status == CifsExiting;
+	return ret;
+}
+
 #endif	/* _CIFS_GLOB_H */
