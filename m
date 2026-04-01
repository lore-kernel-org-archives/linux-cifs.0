Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F21B398914
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 07:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028656; cv=none; b=Nec2gC6jAVnizpls29h5PJg9LwBp9D91QWzK+wBJe6+i5ZUE8vTCQCYHaS7wjhWxPj4iuXMvLLL4C2zNjZWuMdCUMbkHA5k+aTraE4FNc9SVAS14NUuOPxnhCRZWJz9EZWmuYB7iqxkdkvLxSNfx44gu771QW0ROWODFa2tSxrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028656; c=relaxed/simple;
	bh=BJutzYGmJ2JWTnzVClttQX9AVJucl2tQO0EE56xioDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xsv3P0or3MiaPk9vz3KI21dSasJE4r53u+4jZxFE/836YGJVk/zIyI1OzyB+2j5YRIN9x8OhEBg2CjMI+790CT6pAqR5Tg61Sh0pE25v5hiayQoHAhl/mV+hEaLR6I51YhKqL+wq6SgXM+eMBcwSOfGVszKsD+hPTeXm9ijCjmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gwsyF6kA; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gwsyF6kA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJTSBrLiux3616BPNl9Dzbj7QN+xl8NvOsbdwp1LrIc=;
	b=gwsyF6kAZwYZcim1LXTsxob++d6TaPPY1VckLjaY/oW1uv5MmknK7MdvUfXMw2diJm5G4B
	sy19GOJQ/k6dYC3epCOLkwUZWmMdd4z6Cic4vdxvyPYCVcK4gKbdh9IhDm8VVScGol/SYn
	3hNrVStgQTdID2gNDSWpythAXepaEDY=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 11/12] smb/client: check if SMB1 DOS/SRV error mapping arrays are sorted
Date: Wed,  1 Apr 2026 07:29:11 +0000
Message-ID: <20260401072912.355072-12-huiwen.he@linux.dev>
In-Reply-To: <20260401072912.355072-1-huiwen.he@linux.dev>
References: <20260401072912.355072-1-huiwen.he@linux.dev>
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
index 3074c60301ad..e8f559754178 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -219,6 +219,10 @@ static int __array ## _is_sorted(void)					\
 
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
2.52.0

