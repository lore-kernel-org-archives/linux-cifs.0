Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC0979DC
	for <linux-cifs@vger.kernel.org>; Thu,  5 Dec 2024 02:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733365898; cv=none; b=KxQ7fxRk59X+8wbZt23TPQ47wwYo3HVOsXcR6dI5WWtmM4bgFZwfKgZyv1GUN8PIwRylpLagT4sp07IldJ5dwyOIfccRe4vaNwuhiKiLawk1Rftjn8Imf/TH78Jq8Mv5dGZ8ff0bBD5F85oTHg2wy4NP7ayI5W/L6y9ErpFv6FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733365898; c=relaxed/simple;
	bh=erRgedDLlIj1PVdGrEs7FrNa5hi1/gSySLzSvJ4D/nk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=lzzoRo04pc0V/icXzetSAjerg7Fj6dk5pG/4QI23XFggyECxFZOpLL6Fohqb21evbWGtOROsNvZCOA65YM0rYCKZ/TP8NHK1/F6jX69u1F8VbIyvLQn2kuWKTJnZzUqFu+XUUn4/N9EBLqOZJtAPfKCci4yNDJFHdwmBTkD/fWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EeHTK6j2; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EeHTK6j2"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241205023132epoutp041c8d96a00b76bc91197f3291496782fc~OJxh_B6VU1646816468epoutp048
	for <linux-cifs@vger.kernel.org>; Thu,  5 Dec 2024 02:31:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241205023132epoutp041c8d96a00b76bc91197f3291496782fc~OJxh_B6VU1646816468epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733365892;
	bh=iAdurLpaqiPFvd/FUM26zFUQV4Mkd7MeSj2k4UzNE+o=;
	h=From:To:Cc:Subject:Date:References:From;
	b=EeHTK6j2eaW0z/1pidBo33xNC0cqbtUKZA1kjEEaYNPOrGen5xVEb0z+LqUy8ZEpj
	 t+XBw9qvtKrC3NQ8rDo8Nv2QtBjHARzSIx2TeQtoCEx8tOrs3CZXStbBI5mzYBpexU
	 ausB2J9BbC26CjVz6Y97DdVZ8YrucDGIYvQRHLzU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241205023132epcas1p1931b36ce3a25ced1d4e70d70baed353c~OJxhi9Ge70159701597epcas1p1Q;
	Thu,  5 Dec 2024 02:31:32 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.38.249]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Y3dgR6L2Nz4x9Px; Thu,  5 Dec
	2024 02:31:31 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	93.93.23869.38011576; Thu,  5 Dec 2024 11:31:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20241205023131epcas1p3adfaf05ab3fcaf851d90f2e314001513~OJxgqVKfg1309613096epcas1p3M;
	Thu,  5 Dec 2024 02:31:31 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241205023131epsmtrp249dd19615c80cb2a0ef500008af75e78~OJxgpj7sM1873018730epsmtrp2R;
	Thu,  5 Dec 2024 02:31:31 +0000 (GMT)
X-AuditID: b6c32a36-6f5e970000005d3d-19-675110832fad
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CC.DD.33707.38011576; Thu,  5 Dec 2024 11:31:31 +0900 (KST)
Received: from linux.. (unknown [10.253.100.137]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241205023131epsmtip1aa96e712c86162b5451e29369bd26acf~OJxgaaOaf2565825658epsmtip14;
	Thu,  5 Dec 2024 02:31:31 +0000 (GMT)
From: Hobin Woo <hobin.woo@samsung.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
	tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com,
	moons49.kim@samsung.com, Hobin Woo <hobin.woo@samsung.com>
Subject: [PATCH] ksmbd: retry iterate_dir in smb2_query_dir
Date: Thu,  5 Dec 2024 11:31:19 +0900
Message-ID: <20241205023120.792280-1-hobin.woo@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJsWRmVeSWpSXmKPExsWy7bCmnm6zQGC6weU9Bhabpr9kspg4bSmz
	xYv/u4DE/SmsFrs3LmKz6Hh5lNliy78jrBanfp1isjh64i6jA6fH7IaLLB6bVnWyeczd1cfo
	0bdlFaPH5SdXGD0+b5ILYItqYLRJLErOyCxLVUjNS85PycxLt1UKDXHTtVBSyMgvLrFVijY0
	NNIzNDDXMzIy0jM1irUyMlVSyEvMTbVVqtCF6lVSKEouAKrNrSwGGpCTqgcV1ytOzUtxyMov
	BXlFrzgxt7g0L10vOT9XSaEsMacUaISSfsI3xozzL3vZCpqEK079XMzYwHiLv4uRk0NCwERi
	74s1jF2MXBxCAjsYJVpvXWGGcD4xSqxctosJpArMWXhPEKbjx7peFoiinYwSV5b1QnU8Y5SY
	e+kLO0gVm4C6xO47jWDdIgJyEms3nQTrYBY4ziix9tMMsISwgLVE/9VjLCA2i4CqxKutb1hB
	bF6g+KQZXcwQ6+QlFu9YzgwRF5Q4OfMJWD0zULx562ywzRIC99glml70QTW4SDzY2s4GYQtL
	vDq+hR3ClpL4/G4vVLxYYt3JdVDxGonu2Xeg4vYSza3NQDYH0AJNifW79CF28Um8+9rDClEi
	KHH6WjczSImEAK9ER5sQRFhZovHxcxYIW1JiyvJGqHIPiefdC6GhGCuxdfJN1gmM8rOQfDML
	yTezEBYvYGRexSiWWlCcm55abFhghByxmxjBCVbLbAfjpLcf9A4xMnEwHmKU4GBWEuEN0g5I
	F+JNSaysSi3Kjy8qzUktPsSYDAzficxSosn5wBSfVxJvaGZmaWFpZGJobGZoSFjYxNLAxMzI
	xMLY0thMSZz3zJWyVCGB9MSS1OzU1ILUIpgtTBycUg1MivNElYs0+tdISCsn95vvie3QzPoj
	yHKp8n7r57dSM1O1g72v60tcUPx4tHxqDXtijBf3dDurLVO+BHkVRtb417SzrGUvDk+x+76y
	1WqTycTZ9akrPefMslkXaJ6hcJFp5kP16dL2y8K4qp4dMElLyF323FaoVqKby+IbVze79Rme
	543X3h5a05Ih+GZra1/BX7frqxeLv0l1sTaWVhQo/2VUJXDnYfHL0qiFH+t3b580yS5t2Z5T
	Cd6XGmXiVNoKKyufzXxVo1L34pHOeok3FVe9Ll840vY2x/xtyJ66K+K5s3VdL6/3tKo3YJl5
	kXn+m3tu7t6vEhaZ3VweMK+z7eZ8s/C7nZVGLL+eVCmxFGckGmoxFxUnAgDZkfMyZwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWy7bCSnG6zQGC6wfbJXBabpr9kspg4bSmz
	xYv/u4DE/SmsFrs3LmKz6Hh5lNliy78jrBanfp1isjh64i6jA6fH7IaLLB6bVnWyeczd1cfo
	0bdlFaPH5SdXGD0+b5ILYIvisklJzcksSy3St0vgyjj/spetoEm44tTPxYwNjLf4uxg5OSQE
	TCR+rOtl6WLk4hAS2M4o8W/pDaYuRg6ghKTEs0sSEKawxOHDxRAlTxgl9vZ/YwTpZRNQl9h9
	p5EJxBYRkJNYu+kk2BxmgYuMEs++PGcHSQgLWEv0Xz3GAmKzCKhKvNr6hhXE5gWKT5rRxQxx
	hLzE4h3LmSHighInZz4Bq2cGijdvnc08gZFvFpLULCSpBYxMqxhFUwuKc9NzkwsM9YoTc4tL
	89L1kvNzNzGCQ1craAfjsvV/9Q4xMnEwHmKU4GBWEuEN0g5IF+JNSaysSi3Kjy8qzUktPsQo
	zcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCUamAKkxHRskt5YcvDqFe9kp81N3KB+RLTo1wS
	B3I/Lspv02GVE2L8tSxe2WvzszgLkxvTK9l9juo+M/63n7OoRXH7CvV1X9WS5Xhk05/PnTnx
	34oKrpari5fPt+nM+XdTe8Ype/aSDfvs9/zfnj/l4qfCYxWdosW/vab/OVm/mnFNYtx2piuP
	OGd8rtkvoOTarHdpi8vnR/d79Uq+n2As4ll4g/nKiUWVSk89ReYJfN+anv7L0Zqxp7oo4NWT
	lV/+pcUlXzNcr3rptHOhe0/5olv15Vmb16S97699tmLq9hfbshOY5/T2cJkLHV/6LH1lG9Of
	Pi393TuPWuxbr7fisE7wacU3u1Ub2u8ZHis7evOOEktxRqKhFnNRcSIAeb7Ua8wCAAA=
X-CMS-MailID: 20241205023131epcas1p3adfaf05ab3fcaf851d90f2e314001513
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
X-ArchiveUser: EV
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241205023131epcas1p3adfaf05ab3fcaf851d90f2e314001513
References: <CGME20241205023131epcas1p3adfaf05ab3fcaf851d90f2e314001513@epcas1p3.samsung.com>

Some file systems do not ensure that the single call of iterate_dir
reaches the end of the directory. For example, FUSE fetches entries from
a daemon using 4KB buffer and stops fetching if entries exceed the
buffer. And then an actor of caller, KSMBD, is used to fill the entries
from the buffer.
Thus, pattern searching on FUSE, files located after the 4KB could not
be found and STATUS_NO_SUCH_FILE was returned.

Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Yoonho Shin <yoonho.shin@samsung.com>
---
 fs/smb/server/smb2pdu.c | 12 +++++++++++-
 fs/smb/server/vfs.h     |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4f539eeadbb0..1923f91d40b6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4228,6 +4228,7 @@ static bool __query_dir(struct dir_context *ctx, const char *name, int namlen,
 	/* dot and dotdot entries are already reserved */
 	if (!strcmp(".", name) || !strcmp("..", name))
 		return true;
+	d_info->num_scan++;
 	if (ksmbd_share_veto_filename(priv->work->tcon->share_conf, name))
 		return true;
 	if (!match_pattern(name, namlen, priv->search_pattern))
@@ -4390,8 +4391,17 @@ int smb2_query_dir(struct ksmbd_work *work)
 	query_dir_private.info_level		= req->FileInformationClass;
 	dir_fp->readdir_data.private		= &query_dir_private;
 	set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
-
+again:
+	d_info.num_scan = 0;
 	rc = iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
+	/*
+	 * num_entry can be 0 if the directory iteration stops before reaching
+	 * the end of the directory and no file is matched with the search
+	 * pattern.
+	 */
+	if (rc >= 0 && !d_info.num_entry && d_info.num_scan &&
+			d_info.out_buf_len > 0)
+		goto again;
 	/*
 	 * req->OutputBufferLength is too small to contain even one entry.
 	 * In this case, it immediately returns OutputBufferLength 0 to client.
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index cb76f4b5bafe..06903024a2d8 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -43,6 +43,7 @@ struct ksmbd_dir_info {
 	char		*rptr;
 	int		name_len;
 	int		out_buf_len;
+	int		num_scan;
 	int		num_entry;
 	int		data_count;
 	int		last_entry_offset;
-- 
2.43.0

