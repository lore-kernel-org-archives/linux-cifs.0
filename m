Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25391F12FB
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 06:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786428107; cv=none; b=AvhAHwjtJDI5S/oG1sQlHY+pg/VuOzNhSRy70XXsaJOA/mJsIvw2BDUOxLd3SjyVEDAv8BAaHitIu3S1sL6yplRgJj7Sv8uOslcYLtK+7U/ovLlrisg5aVTcCMNxqFgJSJgiK9QYha9tPdJv9pzgA/Da5kO2+k28XK76OjUPfCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786428107; c=relaxed/simple;
	bh=VtY2PHj3u/iQTbtMKDxAFnZSE32KFAc8IEVRk+36wJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB0m0JnU0XXlRtYj37jaOilcQ/1OiP7TJ1O4lPp3HnLAUcZSpJ1HQm8vp4mxvMcY1pGwqlnA0XdsV8HIjPlQkYdJeUuXMLfloDxPLJPw6a5O4s2gCq7qaugzTBv7t2zpJnink5cjE+2UGb+KQpsdYcgGqc94t+xnk2dw9uIvUto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1ab67230954a11f1aa26b74ffac11d73-20260811
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:464db80c-d054-4866-a43c-fa070548834a,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:464db80c-d054-4866-a43c-fa070548834a,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:5eae2a4eef81251c32e6a53e0f55e35d,BulkI
	D:2608111401376LRVVHDN,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2|1,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ab67230954a11f1aa26b74ffac11d73-20260811
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1756454296; Tue, 11 Aug 2026 14:01:33 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	ronniesahlberg@gmail.com,
	pc@manguebit.org,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	hehuiwen@kylinos.cn,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn
Subject: [PATCH 1/3] smb/client: mark missing nlink values as unknown
Date: Tue, 11 Aug 2026 14:00:45 +0800
Message-ID: <d379aa40574b89ecbb0ae6683441b2b422c2ceca.1786427463.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786427463.git.tanze@kylinos.cn>
References: <cover.1786427463.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several SMB1 fallback and open responses do not provide the hard link
count. The SMB2 create-only query fallback has the same limitation.
These paths currently leave a zero link count or synthesize a value of
one and then expose it as authoritative metadata.

Mark those results with unknown_nlink so existing inodes keep their
cached link count and new inodes receive the usual sane default.

This was tested against Samba with "server min protocol = NT1". Mount
the share using SMB1 with Unix extensions disabled:

  mount -t cifs //<server>/<share> /mnt/cifs \
        -o username=<user>,vers=1.0,nounix

Create three names for the same inode and cache its real link count:

  TESTDIR=/mnt/cifs/nlink-repro-$$
  mkdir "$TESTDIR"
  touch "$TESTDIR/file1"
  ln "$TESTDIR/file1" "$TESTDIR/file2"
  ln "$TESTDIR/file1" "$TESTDIR/file3"
  stat -c 'before open: %h' "$TESTDIR/file1"

Open the file and read the link count through the open descriptor:

  exec 3<"$TESTDIR/file1"
  stat -Lc 'after open: %h' /proc/$$/fd/3
  exec 3<&-

Clean up the test files:

  rm -f "$TESTDIR/file1" "$TESTDIR/file2" "$TESTDIR/file3"
  rmdir "$TESTDIR"

Before this change, the two stat commands report 3 and 1 because the
SMB1 open response overwrites the known link count. With this change,
both commands report 3.

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/smb1ops.c   | 8 +++++++-
 fs/smb/client/smb2inode.c | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index dc5a8c1da623..7e2b29060f51 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -542,6 +542,7 @@ static int cifs_query_path_info(const unsigned int xid,
 
 	data->reparse_point = false;
 	data->adjust_tz = false;
+	data->unknown_nlink = false;
 
 	/*
 	 * First try CIFSSMBQPathInfo() function which returns more info
@@ -608,6 +609,7 @@ static int cifs_query_path_info(const unsigned int xid,
 				fi.EASize = di->EaSize;
 			}
 			fi.NumberOfLinks = cpu_to_le32(1);
+			data->unknown_nlink = true;
 			fi.DeletePending = 0;
 			fi.Directory = !!(le32_to_cpu(fi.Attributes) & ATTR_DIRECTORY);
 			cifs_buf_release(search_info.ntwrk_buf_start);
@@ -630,6 +632,8 @@ static int cifs_query_path_info(const unsigned int xid,
 		rc = SMBQueryInformation(xid, tcon, full_path, &fi, cifs_sb->local_nls,
 					 cifs_remap(cifs_sb));
 		data->adjust_tz = true;
+		if (!rc)
+			data->unknown_nlink = true;
 	} else if ((rc == -EOPNOTSUPP || rc == -EINVAL) && non_unicode_wildcard) {
 		/* Path with non-UNICODE wildcard character cannot exist. */
 		rc = -ENOENT;
@@ -893,8 +897,10 @@ static int cifs_open_file(const unsigned int xid, struct cifs_open_parms *oparms
 	else
 		rc = CIFS_open(xid, oparms, oplock, &fi);
 
-	if (!rc && data)
+	if (!rc && data) {
 		move_cifs_info_to_smb2(&data->fi, &fi);
+		data->unknown_nlink = true;
+	}
 
 	return rc;
 }
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 213bc298cdf2..d4ae8a5ad463 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -576,6 +576,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		idata->fi.EndOfFile = create_rsp->EndofFile;
 		if (le32_to_cpu(idata->fi.NumberOfLinks) == 0)
 			idata->fi.NumberOfLinks = cpu_to_le32(1); /* dummy value */
+		idata->unknown_nlink = true;
 		idata->fi.DeletePending = 0; /* successful open = not delete pending */
 		idata->fi.Directory = !!(le32_to_cpu(create_rsp->FileAttributes) & ATTR_DIRECTORY);
 
-- 
2.43.0

