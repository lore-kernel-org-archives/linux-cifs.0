Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F873AAF5E
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791479152; cv=none; b=fKlgbMvqwMv/xbIEThvngAMeqJT23unVBUfUM9/B8ln8lgsF+Mjyih1bkijM2EU0m0Mbijrp3LWL2ZjxmSSrfpD6vpmyYBMJPWtG5RPFL/aKZZBUQBqXnoUVssUvm2izBPM46LjsRYcDohanDbqaz5BAkkymtqHEz3U2mSA3V4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791479152; c=relaxed/simple;
	bh=SXbUN2sTxUryiOzRpiJL6R9ofWBCAXsss9KIoIP3yOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=inLI19THFvVpDs0kVNPrjo1/6O9VfOgl4eGjiUAs2ns0VOKtl79Nn8gSlVTJxmv0KKmvdgr5KJd5iC0aQ6syMIHmfOhVA7RDObUVGdItJD8oR9xMWHNA38VHnm3mZ6y7+xiRd8kesCzQX7DV6M1YmGRTyP7tFSGZP5wraP7OaSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlaFaf/y; arc=none smtp.client-ip=74.125.231.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlaFaf/y"
Received: by mail-oo2-f11.google.com with SMTP id 46e09a7af769-82890dea412so1473318a34.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791479150; x=1792083950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mDzT7rRLBlLl1SvCaZ6GZFdRqjVzzQ2BxwbcnMx0rc0=;
        b=XlaFaf/y9LEMd0+vtpF54qmy7VJUD5MA5Zb6bYkJkX+E2QKQbWQEgZDYhmcgOjz9Vp
         lL1p5iOt3lZ7vxHqUjAyZEKC7+/184Emb9HkYZ1sO9xqRdcYSb/1a3c2QW6OrrtR8WmH
         N3g8YfLIvtJwG7WYZrCUZ4uZ1IRwLxyYgHxF2nL88Fk6DCHPZZj+Ljrv+XvhliQF06Lh
         ofGNyUW1R1jBMW7AVa3SFjNYCGIXNeA5x3liE6PVDvSY2S3kA9caw3KcMLZPr+TXIt8e
         ItnYc21e8/WOOe6ZG4mXuvtHU93bG5dvTmhBFDcvGCWSmglMXaU4gl4CCETthwb6Lq4Q
         l4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791479150; x=1792083950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mDzT7rRLBlLl1SvCaZ6GZFdRqjVzzQ2BxwbcnMx0rc0=;
        b=WV1pcFSo7J6nKseokyhEDAcYKaFBbN61+jslgH8ZkEdUGZCZA1FMWMSDCDMU8Hrtvj
         jNkKho10Wxor/a0JUiPOIGt7fD2j2e/o29rrQ4Ot0Jo4AalNfDRya4ZFqotYb3khEuth
         IeTq0oxwh9xzSo7hTm0c3f3gd35hBKwE3RLGNALSpmXnwGnNM9duibzTO3UTjWYC8s3L
         KKPTVThtRczzllyUhLz4s4WE0d5VWKeJnO93/97aQ3fiwncAD/1Tuzg+ahvFO0J/pw4m
         kZp/62iB7v8H2V2eXtZyJSaEfZ9KEtvqWzOuhYpZKCww93jVvSfk9q6f0DZMao6Moh93
         FD6w==
X-Gm-Message-State: AFuF++ksUSuu5P+sEKSaoMKKfwWoIbeYfZfAwJnxFhQ1WfcXn2MNNPOY
	t3wgw7GXr2ZMuarnvTn+H3bYRgWlMNzpKEn3XYdsyTFbyqO7cOnzvrcD
X-Gm-Gg: AYBFou2UtBiqco7Uc+GXrfu2mlOb4mEml/ly5xsQdzxYERR2aY/It+Xgz6s7l0E8BuZ
	HdkuF/kK/usj62q+nqOs2vD0QEh/xaOsHIPz0GEBBNbti3wwtwJBpA33t3xiSUI1QMTgQrgkgej
	r8jG4Jggd/uQBVPt0Kh5O3N9MGct/c26imV5R0FaJoFosgcAVqqMPrHGVcwYMU2XD3ibRWEb1vw
	bhtwGn2nPg6KMSG08qWQ6GrjUJZL0h+CZv0eELZmK0pLtbER51WC7LWL73hLlMS09vSfYJArMYl
	Co/QYEXL2QXDWx7Mvz7kGiqf3Xk+D43T0f10HUSCL4+L4FpX6sT0XuKXDJXSEECWJV0m8/JaN/o
	FCH7hdS3ZVAJoegShKcLTN5W2qy2DX/7IEoXGcr9nxEqmD7x9vc1/qImmGuT9BO2tYsUP8Og0Gu
	jLBZsgzOVXG9L4X2ThhU3Dha+09n/ynjlYzGvPILIXmaxKVbNocFxKZSZIlXn5DoVp0H1zXpEog
	SSlRVVisOCk/AX7sVGpoqme24VQju8V3MhbRkLsXQ8CtD6J
X-Received: by 2002:a05:6830:81e7:b0:822:e9bf:6445 with SMTP id 46e09a7af769-82acfeb2c60mr6938276a34.9.1791479149825;
        Thu, 08 Oct 2026 10:05:49 -0700 (PDT)
Received: from localhost.localdomain ([117.88.121.66])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-82fc8873349sm131411a34.13.2026.10.08.10.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 10:05:49 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Gael Blivet <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>
Subject: [PATCH] ksmbd: fix heap out-of-bounds write in SMB2_CREATE context stacking
Date: Fri,  9 Oct 2026 01:05:42 +0800
Message-ID: <20261008170542.1034301-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_open() appends up to six create contexts (lease, mxac, disk_id,
durable, posix, aapl) back-to-back without checking the total length
against work->response_sz.  A non-compound SMB2_CREATE only gets the
448-byte small response buffer, which also carries the 4-byte rfc1002
length word, leaving 292 bytes for contexts.  The AAPL response alone
occupies 128 fixed bytes, so a client stacking contexts (up to 416)
overruns the kmalloc-512 object into the adjacent allocation with a
deterministic zero-fill.

Compute the worst-case context total from the per-dialect
conn->vals->create_*_size table and grow the response buffer to fit
before writing any context, so legitimate requests keep working
unchanged.

This vulnerability was discovered by Tencent CodeBuddy Security.

Fixes: 8f1b796ff1135 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context support")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 fs/smb/server/smb2pdu.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6b8809f67b926..e18e6b630f757 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5162,6 +5162,52 @@ int smb2_open(struct ksmbd_work *work)
 	rsp->CreateContextsLength = 0;
 	iov_len = offsetof(struct smb2_create_rsp, Buffer);

+	/*
+	 * The create contexts below are appended back-to-back with no
+	 * length check, while a non-compound CREATE only gets the 448-byte
+	 * small response buffer; a client stacking lease+mxac+disk_id+
+	 * durable+posix+AAPL contexts overruns it (the AAPL response alone
+	 * memsets 128 fixed bytes).  Compute the worst-case total and grow
+	 * the buffer before writing any context.  Note that response_buf
+	 * also carries the 4-byte rfc1002 length word before the SMB2
+	 * header.
+	 */
+	{
+		size_t ctx_max = 0;
+		size_t need;
+		void *nbuf;
+
+		if (opinfo && opinfo->is_lease)
+			ctx_max += conn->vals->create_lease_size;
+		if (maximal_access_ctxt)
+			ctx_max += conn->vals->create_mxac_size;
+		if (query_disk_id)
+			ctx_max += conn->vals->create_disk_id_size;
+		if (durable_rsp && dh_info.type == DURABLE_REQ_V2)
+			ctx_max += conn->vals->create_durable_v2_size;
+		else if (durable_rsp && dh_info.type == DURABLE_REQ)
+			ctx_max += conn->vals->create_durable_size;
+		if (posix_ctxt)
+			ctx_max += conn->vals->create_posix_size;
+		if (aapl_ctxt)
+			ctx_max += conn->vals->create_aapl_size;
+
+		need = 4 + offsetof(struct smb2_create_rsp, Buffer) + ctx_max;
+		if (need > work->response_sz) {
+			nbuf = kvzalloc(need, KSMBD_DEFAULT_GFP);
+			if (!nbuf) {
+				rc = -ENOMEM;
+				goto err_out;
+			}
+			memcpy(nbuf, work->response_buf,
+			       4 + offsetof(struct smb2_create_rsp, Buffer));
+			kvfree(work->response_buf);
+			work->response_buf = nbuf;
+			work->response_sz = need;
+			rsp = smb_get_msg(work->response_buf);
+		}
+	}
+
 	/* If lease is request send lease context response */
 	if (opinfo && opinfo->is_lease) {
 		struct create_context *lease_ccontext;
--
2.43.7
