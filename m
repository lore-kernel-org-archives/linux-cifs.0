Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3618C56458
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086490; cv=pass; b=S56xFLZi5sEAMPMY0NUJlzOFo0A6gzqesP+mFXqzlHPFWkHil2pwdHmpIipRx87HVDLuoctIfaf7rrFTPCbSOiTucKlpTnxfFeHlYNosqUoamg7BLJhCV4ZbHD156/kmQUzPBS4ntJLc5g2XEOEz0ym9Sln8k8DpxLM4tw67s/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086490; c=relaxed/simple;
	bh=hnD7WjKQPkKypBVIOvl3NgbhukfgddvgOSp52INiFyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dWTvzYGA4QNdx2O3Og4ACsNrsNhZSrBP+1d3yK77UHCCqkkFJeOx6GqwF0wo/1+S57KMD7aBzQ0EmOpNWc4JkjbBwPSmasAB4CVztNLVM2xR+WVtcANLh+xpBlO1bit123d6tMf3INz91y7QWNSdW+RCGwV6o6MJKz392pCKXH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=V+uQTtOC; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="V+uQTtOC"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/7FogLtrR70qtCPERTfeYQQa+mKQ3i5HKBwgP9WM4I4=;
	b=V+uQTtOCh5SkAlbmLEcynlHlzX2mgAfo74icXvOBDq0ci2dn36dBukEokKLs3icBC0sCNG
	cImueOymtdtE3H2lLjUwxyJsNLm1678yJnNd7Yy8TOcNmSDsgGKL1tq4LBZrU0gipOVbPL
	7QemHIQnBnFJU4zwlYq/P42nkx3QP090pOR6lS6H1WW+jfq5SvkoRNChv3vFk54X/wPXOz
	Eao2RMKPhg0NNUpOFzp+rgZJ3HPoOK963Ysyy0OiRzjm/cYlYx/cw0BLf1AXEr32s5VVBZ
	A3aASvm7fcwMlp3GN/KuT5fw+9P6x6rvicTZnvJR8+POwJCE5w5zC+0SViDMEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086478; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=/7FogLtrR70qtCPERTfeYQQa+mKQ3i5HKBwgP9WM4I4=;
	b=RBkf+/aDelCazmwzIn/PqI8s63l34g+EkcwCYy7TjrLjL6tRFHEXwvGMIUiqCMNx0tQqQS
	Fu9Gx8HaEsZSjkG0K5lZ5OItmYaWJpH1tE6wQ6hZLS48vL0KCpYJKqw9k2oXLelYDIkqye
	Ejoknky7l3uixYrbtJm++qhlxuOFKKeXiv2QWmFMEvvxtahLgq/kWpQxyMT6p59hbpZWx1
	60k92NIUTpo/Rn7ZlR2ho2Wwt3TVMRu1ACQx45jvocC2hbYt2j4WhOhl3dmE5IoIAArdYM
	dvFW7PBXKsvyIbw8m8GJYwIj1AOEMChrP6z+bBdXiHYu/Pc22TvSeTQTuuqrUg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086478; a=rsa-sha256;
	cv=none;
	b=U2HZyjJKbmSnc4BNejlUsfADtskU+zoFmqpyRu428rcWrg6QTlFd7eRW5G5n6u7f5e86xu
	2quG7k+cBOF5q37wQpR7zmUiCib2qlx/vZqQa/D+CxBrpxTouHQyaGGfs3JfuRZNLL/OxE
	OtQQ4T4zszPDCQfKFRkuI4voHqJBT9EJyqcuUyFblseto5nSW9HoKUyoHCEIhY9XnXTpiN
	R3Nri38KVkqQzqwfyfo/DRU2oz7lHs8yob+TAX5CB+advrDEKncEEofH1gdjbd7XNoOYVs
	lkilX3eksoQYsv628g7Nj5jXz0R7Urlo6MuksxaM4KKLQHsajyLVi2AwjXUsYg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 01/12] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Tue,  2 Apr 2024 16:33:53 -0300
Message-ID: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifs_debug.c |  2 ++
 fs/smb/client/cifsglob.h   | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 226d4835c92d..c9aec9a38ad3 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -250,6 +250,8 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				spin_lock(&tcon->open_file_lock);
 				list_for_each_entry(cfile, &tcon->openFileList, tlist) {
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 286afbe346be..f67607319c43 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2322,4 +2322,14 @@ struct smb2_compound_vars {
 	struct kvec ea_iov;
 };
 
+static inline bool cifs_ses_exiting(struct cifs_ses *ses)
+{
+	bool ret;
+
+	spin_lock(&ses->ses_lock);
+	ret = ses->ses_status == SES_EXITING;
+	spin_unlock(&ses->ses_lock);
+	return ret;
+}
+
 #endif	/* _CIFS_GLOB_H */
-- 
2.44.0

