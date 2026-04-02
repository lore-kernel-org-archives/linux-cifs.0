Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5BF21D3F3
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139620; cv=none; b=cqNFD8JS8HYFRfgpULsRmljgTO2YU5UNLh9ZhboK4WDwjzKE2hEShqu2NM3CuxjqqhhXJoB7TsAyNJN4x3/VFzHnAGw2TQY0LWD0gmRAbWz6dJtwQuvcuRjnQQF73zny1WG5n8aEQzynVTWLS6NLcBm+UYHI1akUYRREfcSu6cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139620; c=relaxed/simple;
	bh=3dZQqwqAIhn34Ck/iGekNDeArCK7NmJz/V1ng0QyNe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4rpffvQPuX892NrChmrUivxsB0einphBwEPpHp+QBd4jGgG/CsoiYNoqMNSoSK25vELnwtvOu9Qm0ksll9mkVAXxfghmi1GloyhJX0cxN80APJM7y1oGY+FkZ/P/yp3czrJqR24Vb0rIUUwzvoXeSe4ZO8y0D5+NOwndhjrpk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pHOLT4Ow; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pHOLT4Ow"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775139616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sQnXWuMlmwBukSBB50TW9nKs2RJY8XutuKl1q8W9hZA=;
	b=pHOLT4OwAto92Qqp4El17AIUk8HHuPE5bkEjylM03+I//AqxAc/bcE/8V0zKazVFEi7Px8
	CVorghlyI5Bmm7NHQ/N3bcHtBcjoik+CIqkNYE+9MLLRUOVohjkb1e7d5g+3iUOkGH+wtj
	ww4OuGwhFy4rpxhrJapSZrSFzXO5XZw=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v3 12/13] smb/client: check if SMB1 DOS/SRV error mapping arrays are sorted
Date: Thu,  2 Apr 2026 14:18:38 +0000
Message-ID: <20260402141839.461257-13-huiwen.he@linux.dev>
In-Reply-To: <20260402141839.461257-1-huiwen.he@linux.dev>
References: <20260402141839.461257-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Although the arrays are sorted at build time, verify the ordering again
when cifs.ko is loaded to avoid potential regressions introduced by
future script changes.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 28e1c84fa83b..bca9b60ac836 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -219,6 +219,10 @@ static int __init __array ## _is_sorted(void)				\
 
 /* ntstatus_to_dos_map_is_sorted */
 DEFINE_CHECK_SORT_FUNC(ntstatus_to_dos_map, ntstatus);
+/* mapping_table_ERRDOS_is_sorted */
+DEFINE_CHECK_SORT_FUNC(mapping_table_ERRDOS, smb_err);
+/* mapping_table_ERRSRV_is_sorted */
+DEFINE_CHECK_SORT_FUNC(mapping_table_ERRSRV, smb_err);
 
 int __init smb1_init_maperror(void)
 {
@@ -228,6 +232,14 @@ int __init smb1_init_maperror(void)
 	if (rc)
 		return rc;
 
+	rc = mapping_table_ERRDOS_is_sorted();
+	if (rc)
+		return rc;
+
+	rc = mapping_table_ERRSRV_is_sorted();
+	if (rc)
+		return rc;
+
 	return rc;
 }
 
-- 
2.53.0

