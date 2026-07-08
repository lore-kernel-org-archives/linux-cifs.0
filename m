Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D09B43079C
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783528005; cv=none; b=ArGgwlOycCXprR16pHKvKqXkjpjCGsswbdb9Lc+WOUq9J45T82VffTilkTagzF+sc7gSWvgMI9/uZyeO0E9uIvLCXXXNC6SzL8etybdQAPuXEzc8u7TU5G71a7tCDpf2U5WQ/QGtNxQc+GSUUrbCksz3glZUKXn2+BnccRj9ieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783528005; c=relaxed/simple;
	bh=k1gAmoyA3T8V6aHPmand/RwF41utwIk4iABSOtyRNEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJCc7YfdpWf+ODMtddx0G6NsIbZYskmH2wehpilyWVowxV0ONU5g+calJVKVNHN28SvXwOjuCkTyMblzMYp3j2mOFlCoFAKYoOUraAVinIoXdKvfSzNlS8p3dkkFTkPq6IKuafnGHu94tdFJGSiVv26fGjI4K4bOUMRGTGiyLVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=F1ZvLkYF; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="F1ZvLkYF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783528000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smi8ok8hESZgjvZCNy6restjKNrYw/euSPNQ/Ojgpvg=;
	b=F1ZvLkYF0JJqGHUUB9U8SaYZ9oOro+dPLekOB99kmhoe6/d2I9SMcKwBy7NFvgu4qKfMMh
	MUoSIT9YoH+FcbqpHVZ4tzibjc/5dkJ1SCkKAskDRTIlQG+YYVfxlK2W0tWAS8RvWtes7F
	yh4G0ZTuv/tzhKYNF28bLVvLLECXB7aEnD8hGei/8O7FRR0jXKE+Ai5DAc/kcoYNcyhPjF
	j+9cUBIZqAF6Ygzmgj/2ymQXuxLzdlBhsfnAryiwLDxX7glA+xEmKwYClsYluTR0BJeQIl
	8mUpM+o1EBl4YXCKHuD+R+nGuvQwJDiyGEU7UguNtdylvCIaxHWbWb2/P7vPtw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 1/3] smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()
Date: Wed,  8 Jul 2026 16:25:50 +0000
Message-ID: <20260708162552.209468-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260708162552.209468-1-chenxiaosong@chenxiaosong.com>
References: <20260708162552.209468-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

SMB2_open() only fills the fixed fields, so a stack-allocated
smb2_file_all_info is sufficient here.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/link.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index dd127917a340..0014523d6511 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -320,7 +320,7 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct smb2_file_all_info *pfile_info = NULL;
+	struct smb2_file_all_info file_info = {};
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -336,20 +336,12 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (utf16_path == NULL)
 		return -ENOMEM;
 
-	pfile_info = kzalloc(sizeof(struct smb2_file_all_info) + PATH_MAX * 2,
-			     GFP_KERNEL);
-
-	if (pfile_info == NULL) {
-		kfree(utf16_path);
-		return  -ENOMEM;
-	}
-
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, pfile_info, NULL,
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, &file_info, NULL,
 		       NULL, NULL);
 	if (rc)
 		goto qmf_out_open_fail;
 
-	if (pfile_info->EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		/* it's not a symlink */
 		rc = -ENOENT; /* Is there a better rc to return? */
 		goto qmf_out;
@@ -367,7 +359,6 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 qmf_out_open_fail:
 	kfree(utf16_path);
-	kfree(pfile_info);
 	return rc;
 }
 
-- 
2.54.0

