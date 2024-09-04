Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA3A635
	for <linux-cifs@vger.kernel.org>; Wed,  4 Sep 2024 04:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725424606; cv=none; b=tTvnyjv61YJVkUAsIIl3EaR7Y/44clr9ZlEtyuk6I+YT5SBBEU2TzstMCokakGmj/VTU4sA2qtkMtLpSPM02m5+MUGQbBm5ES4CindZgT8ZongotWnbNSfb6YwRFIl518Hx3zaiGViK9Pmi1ZUon3DbaA9vdVdcnr8d0QDZNwhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725424606; c=relaxed/simple;
	bh=LhzGdFlzBmcrTO90PTxeKR8Bg5lUHcaTZVbpXXIUT2g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=sQwYYRPQ/AGScwLDNpjuQDXClILpZXIoiZ8Y2qyHyy2GcPk5BHE0x58VqGd0vnylpI0cKOKQIIfUba/gIduICkfxhjb2yv5zBRZZYqWVa7bB27kWwV9cBzGWGYRVkO+pWu7fGSDYSRS8iW8nu3CLW0va8IDqpnBLtaLf7j09CXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rVJlQ5wr; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rVJlQ5wr"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240904043641epoutp03f5cbcfd49f30196e862c92e226ac6390~x8Ih0Hq0X2411324113epoutp036
	for <linux-cifs@vger.kernel.org>; Wed,  4 Sep 2024 04:36:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240904043641epoutp03f5cbcfd49f30196e862c92e226ac6390~x8Ih0Hq0X2411324113epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725424601;
	bh=hfFG1CXvGSDwkWvTZdSlg8k3ujB5boNopVjMowO/YQY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=rVJlQ5wr5Mv9TrVbkjtGyX/Rin3+pyVtAO+9ATwqasmrtg4P3jJSXXwpv3BrVXYii
	 SaIkqEpGNk2Lv+hoBuqOsDyYbEUvnMRiV2rT0D0YR5O480/gM4ylN8pBXkKQQebP2Q
	 93l29cim/qZxKgEkxykmqjKs14VaiEP41VXRV1AE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240904043640epcas1p4da07ad061c20eec5fed111bb3f77cfbe~x8Ig-BkS41552315523epcas1p4K;
	Wed,  4 Sep 2024 04:36:40 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.227]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Wz8pH66tfz4x9Ps; Wed,  4 Sep
	2024 04:36:39 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.53.09725.7D3E7D66; Wed,  4 Sep 2024 13:36:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240904043639epcas1p27080078eed3604d12cff3b01d7636343~x8IgRjAJk2593725937epcas1p20;
	Wed,  4 Sep 2024 04:36:39 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240904043639epsmtrp27edf614b4aa3a4207852e16e27e4ed62~x8IgQ7KFd2643726437epsmtrp2x;
	Wed,  4 Sep 2024 04:36:39 +0000 (GMT)
X-AuditID: b6c32a37-1f3ff700000025fd-43-66d7e3d7eefe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.03.07567.7D3E7D66; Wed,  4 Sep 2024 13:36:39 +0900 (KST)
Received: from linux.. (unknown [10.253.100.137]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240904043639epsmtip24de10975f9f7ec776159e53906a42e64~x8IgEQNax3030330303epsmtip2b;
	Wed,  4 Sep 2024 04:36:39 +0000 (GMT)
From: Hobin Woo <hobin.woo@samsung.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
	tom@talpey.com, sj1557.seo@samsung.com, kiras.lee@samsung.com, Hobin Woo
	<hobin.woo@samsung.com>
Subject: [PATCH v2] ksmbd: make __dir_empty() compatible with POSIX
Date: Wed,  4 Sep 2024 13:36:35 +0900
Message-ID: <20240904043635.782603-1-hobin.woo@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmnu71x9fTDGad07fYNP0lk8WBljfs
	FhOnLWW2ePF/F7PF7o2L2Cw6Xh5lttjy7wirxalfp5gcODxmN1xk8di0qpPNY+6uPkaPvi2r
	GD0uP7nC6PF5k1wAW1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScArMCveLE3OLSvHS9
	vNQSK0MDAyNToMKE7Iz/Rw4xFrznrNi0aR1rA2MbRxcjJ4eEgInE7NN32bsYuTiEBHYwSsz8
	3cEK4XxilGjqfQPlfGOUOHixkwmm5eeXKWwQib2MEne+fmEBSQgJPGOUWLlHEsRmE1CX2H2n
	EaxBREBOYu2mkywgDcwCaxglVnx+wg6SEBZwltj6pQ+siEVAVaLz4g5GEJtXwFrizKtv7BDb
	5CUW71jODBEXlDg58wnYMmagePPW2cwgQyUE7rFLrGx6wgbR4CJx9PAtZghbWOLV8S1Qg6Qk
	Pr/bC1VTLLHu5DqoeI1E9+w7UHF7iebWZiCbA2iBpsT6XfoQu/gk3n3tYQUJSwjwSnS0CUFU
	K0s0Pn7OAmFLSkxZ3sgKYXtInGhqY4aESaxE8/v7zBMY5WYh+WAWkg9mISxbwMi8ilEstaA4
	Nz212LDAGB6Tyfm5mxjBCVHLfAfjtLcf9A4xMnEwHmKU4GBWEuGN3Xg1TYg3JbGyKrUoP76o
	NCe1+BCjKTBMJzJLiSbnA1NyXkm8oYmlgYmZkYmFsaWxmZI475krZalCAumJJanZqakFqUUw
	fUwcnFINTLtemf5X/f5ytgrjv/+caRs63u2X3h/J2r5xW9vGr9Uhu7xcUzMOhqvuqKjiuPlv
	p0zAvdbq7/HNT/nPTwy9NHtCw++m5J/rpHmftxUJFO2KFJ30X9H2s9l6O59u8fSqeYpHuuI2
	/nu7/PJhN07lMr0XN5hlBNxFwyMsSp9Km+9ge/9GpzsyVO0pc66BROR8DsGYQr3dzyUeaSd6
	Xt6V4v3i3OId+UKXpIR3XLWadzbs7pcElu77z7YHLD3qcb+kjO8g6/GSyEO//I4WP+M1+HKk
	ZELftcgTbrPO/WS+ZPMuP1RUg+uKyIdf084XfXm+n0V+O+PM5/1tz2V7k7x0f09LnvRaKe/2
	n6mu/x3eXlRiKc5INNRiLipOBABWMG87EQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSvO71x9fTDPYtFrPYNP0lk8WBljfs
	FhOnLWW2ePF/F7PF7o2L2Cw6Xh5lttjy7wirxalfp5gcODxmN1xk8di0qpPNY+6uPkaPvi2r
	GD0uP7nC6PF5k1wAWxSXTUpqTmZZapG+XQJXxv8jhxgL3nNWbNq0jrWBsY2ji5GTQ0LAROLn
	lylsXYxcHEICuxkl2la1AzkcQAlJiWeXJCBMYYnDh4shSp4wSky4eIsNpJdNQF1i951GJhBb
	REBOYu2mkywgRcwCWxglPk7/zQiSEBZwltj6pQ+siEVAVaLz4g6wOK+AtcSZV9/YIY6Ql1i8
	YzkzRFxQ4uTMJywgNjNQvHnrbOYJjHyzkKRmIUktYGRaxSiZWlCcm56bbFhgmJdarlecmFtc
	mpeul5yfu4kRHLhaGjsY783/p3eIkYmD8RCjBAezkghv7MaraUK8KYmVValF+fFFpTmpxYcY
	pTlYlMR5DWfMThESSE8sSc1OTS1ILYLJMnFwSjUwzTq6l6/Q9t/h/F93I1grqxO2C+99uHHK
	wZ+9dulH1m8/Z7/RmH+vuflOoQAD3cWMEfZ6vyTVlOwfmYrkCpxbe/ZyVRHvk8m3GKLt3EVD
	oqSvXXmftX3HfZaF2i+5tM5wueaXlPev+nCGZU6fMuOPxtdfbkxaqav2+GJ+zswVe94fu3xi
	zvHoFIbLs6sd5z2uN+Cq3nL90EFjJykFrzuLXQRfTXfbbu1wYV/xrDS3puf33wm5TZ0YM1Ei
	uCnkZccJr4ze/UmyTddOTnounJZld27pKd3Zi5NvMv62325u8sY0fN731OBpvbNcu0/yH9c7
	FCB+Wm/d4uNmDur8cZ7rP0b5SPK05EyrTbnx5dFXOyWW4oxEQy3mouJEAHEVAVDLAgAA
X-CMS-MailID: 20240904043639epcas1p27080078eed3604d12cff3b01d7636343
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240904043639epcas1p27080078eed3604d12cff3b01d7636343
References: <CGME20240904043639epcas1p27080078eed3604d12cff3b01d7636343@epcas1p2.samsung.com>

Some file systems may not provide dot (.) and dot-dot (..) as they are
optional in POSIX. ksmbd can misjudge emptiness of a directory in those
file systems, since it assumes there are always at least two entries:
dot and dot-dot.
Just don't count dot and dot-dot.

Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
---
v2:
 - Just don't count dot and dot-dot.

 fs/smb/server/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 9e859ba010cf..62de668cd1e1 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1115,9 +1115,10 @@ static bool __dir_empty(struct dir_context *ctx, const char *name, int namlen,
 	struct ksmbd_readdir_data *buf;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
-	buf->dirent_count++;
+	if (!is_dot_dotdot(name, namlen))
+		buf->dirent_count++;
 
-	return buf->dirent_count <= 2;
+	return !buf->dirent_count;
 }
 
 /**
@@ -1137,7 +1138,7 @@ int ksmbd_vfs_empty_dir(struct ksmbd_file *fp)
 	readdir_data.dirent_count = 0;
 
 	err = iterate_dir(fp->filp, &readdir_data.ctx);
-	if (readdir_data.dirent_count > 2)
+	if (readdir_data.dirent_count)
 		err = -ENOTEMPTY;
 	else
 		err = 0;
-- 
2.43.0

