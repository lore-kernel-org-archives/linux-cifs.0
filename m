Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A5E1A4E66
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 05:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725340784; cv=none; b=uXd1kVPKPhquS3PBADYE7lciaXoZrbRFs+azNFnc9WrabGjd/e3lCEAjL/O4UfdwJBF9jmfRZwZ4MAnsAX+YhP/Wsjmb4v7ige4vMe2uIFQZrs6QlE/dEgsr3DOn9uIZ7BKGE1vlRvlaSjxVXA/ZjyWbl+n6aPv2Yo40kUFvquQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725340784; c=relaxed/simple;
	bh=imfPBgYtR0P/j+VCPhlXUPVkAkV6ZlHgaMyc+3KltPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=tW6BRG+b7oAa6L1M4+ezmfc86pu+dwF9/9gAtrlm78ldjdHcUGg928/PEFCT5gOYqnJp435lPFW2LJvIzNEBGR3UOy9l7a/Z8cpWSZulFWNFZwT4kuZELA/1FvA9Nuiocu0Z7ysugHTto0I0XSLmyRPWNbTqlOV1PCwcBz3rIWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hCB3hp+7; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hCB3hp+7"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240903051933epoutp042f8f521fb5736ec51867a30d7668a8f8~xpErY48MR1449514495epoutp04U
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 05:19:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240903051933epoutp042f8f521fb5736ec51867a30d7668a8f8~xpErY48MR1449514495epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725340773;
	bh=OUvysq7D0Mku7q9pK/r7TcrGExT9hy4sieECwD4nU+A=;
	h=From:To:Cc:Subject:Date:References:From;
	b=hCB3hp+74djGYV/C61FRNFZxz0gDYj9qwW0zCmLae3wOXFXDhLlN2AhjIoWtw6CLu
	 pbPIrXuuLJkHe0AX9IEjInEo2WeTZsfr3uh/63gyF5O+pktpME7DHSscDVs3ktVTOf
	 jlH3b6fMKccduI4C3S4idirgezWyN2MVVTYOsAQs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240903051933epcas1p461f0817079277cda5b9daa6de8bc53f8~xpEq_cCa92741827418epcas1p4y;
	Tue,  3 Sep 2024 05:19:33 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.36.226]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WyYpD5rbVz4x9Pw; Tue,  3 Sep
	2024 05:19:32 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
	epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	C9.E7.09734.46C96D66; Tue,  3 Sep 2024 14:19:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250~xpEqPOcTd2936429364epcas1p3F;
	Tue,  3 Sep 2024 05:19:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240903051932epsmtrp2355c3b97f038aede31dc3ff4680b8e51~xpEqOSDfk1630716307epsmtrp2Y;
	Tue,  3 Sep 2024 05:19:32 +0000 (GMT)
X-AuditID: b6c32a35-babff70000002606-09-66d69c640b00
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	90.6D.08964.46C96D66; Tue,  3 Sep 2024 14:19:32 +0900 (KST)
Received: from linux.. (unknown [10.253.100.137]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240903051932epsmtip25e0af9355af996e9619e14f6333fa1d4~xpEqB5Yn50356503565epsmtip27;
	Tue,  3 Sep 2024 05:19:32 +0000 (GMT)
From: Hobin Woo <hobin.woo@samsung.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
	tom@talpey.com, sj1557.seo@samsung.com, kiras.lee@samsung.com, Hobin Woo
	<hobin.woo@samsung.com>
Subject: [PATCH] ksmbd: make __dir_empty() compatible with POSIX
Date: Tue,  3 Sep 2024 14:19:18 +0900
Message-ID: <20240903051918.728540-1-hobin.woo@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmrm7KnGtpBnO26Vpsmv6SyeJAyxt2
	i4nTljJbvPi/i9li98ZFbBYdL48yW2z5d4TV4tSvU0wOHB6zGy6yeGxa1cnmMXdXH6NH35ZV
	jB6Xn1xh9Pi8SS6ALSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgVmBXnFibnFpXrpe
	XmqJlaGBgZEpUGFCdsbeKyIFS9grGv5+ZW9g/M7axcjBISFgInGty6aLkYtDSGAHo8SXnlb2
	LkZOIOcTo8TWXk6IxDdGiSOz9jGBJEAaZtyeywiR2Mso8bznJFTHM0aJh5vBbDYBdYnddxrB
	GkQE5CTWbjrJAtLALLCGUWLF5ydgRcICDhK3TzWD2SwCqhKbzp9kA7F5Bawl1sxoZ4XYJi+x
	eMdyZoi4oMTJmU9YQGxmoHjz1tnMIEMlBO6xS6z7/JAZosFFYuOubVDNwhKvjm9hh7ClJD6/
	28sGYRdLrDu5DipeI9E9+w5U3F6iubWZDRQuzAKaEut36UPs4pN497UHGly8Eh1tQhDVyhKN
	j5+zQNiSElOWN0Jt9ZDYcvAzGyRMYiVmHOphm8AoNwvJB7OQfDALYdkCRuZVjGKpBcW56anF
	hgWG8GhMzs/dxAhOhVqmOxgnvv2gd4iRiYPxEKMEB7OSCG/sxqtpQrwpiZVVqUX58UWlOanF
	hxhNgWE6kVlKNDkfmIzzSuINTSwNTMyMTCyMLY3NlMR5z1wpSxUSSE8sSc1OTS1ILYLpY+Lg
	lGpgCmF1fK5dKZ90/ObmtX+W5i77NW/fuoluT86oq62cv/eluPsfzay/ey+xP7u7rcFB4imr
	obSN9e8p4R7rbF9/+lkluNjT7st8/pd7dc42LL3UOFuqZd/lpqC/msutxB8U5/M5axgzWyS7
	CP/Z6Lc800znF/fLNT6P+33LD7yxYfLtEX29uD9w1eHaL4Gfmp7u+da5acIjx4A1qx5NuLHU
	k2vZdHVXrY5j3vJL0iP892+rmuP779mFPaqnzwfMnz2Px+n9ycajWdaPPT+V6369Ynp36kkb
	9q2/FLxn/l9fGW9cNO0Lx9bNbLtFzv1Z+oMx0sp9Yvt2Z4b3B39OMvubJucU8vQpj7zhp/Yp
	ia+dFOyVWIozEg21mIuKEwHZOGgnDgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWy7bCSvG7KnGtpBituCVlsmv6SyeJAyxt2
	i4nTljJbvPi/i9li98ZFbBYdL48yW2z5d4TV4tSvU0wOHB6zGy6yeGxa1cnmMXdXH6NH35ZV
	jB6Xn1xh9Pi8SS6ALYrLJiU1J7MstUjfLoErY+8VkYIl7BUNf7+yNzB+Z+1i5OSQEDCRmHF7
	LmMXIxeHkMBuRolJe44AORxACUmJZ5ckIExhicOHiyFKnjBKLPj5hw2kl01AXWL3nUYmEFtE
	QE5i7aaTLCBFzAJbGCU+Tv/NCJIQFnCQuH2qmR3EZhFQldh0/iRYM6+AtcSaGe1QR8hLLN6x
	nBkiLihxcuYTFhCbGSjevHU28wRGvllIUrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3XK07MLS7N
	S9dLzs/dxAgOWy3NHYzbV33QO8TIxMF4iFGCg1lJhDd249U0Id6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rziL3pThATSE0tSs1NTC1KLYLJMHJxSDUzll+y+PTbWi5pcpPzzaUuciFi0yvPuN5Z5
	S2rVV4apFa031FRYkvJlrdrFQMuoG0FPLgqtfm6reKM3Yq8Ox8/3Z7iU9RVfBFR7OFcopq7x
	Sb6adn7LhI/Le5/z2dTsU5ywcnXsU5V7NUY3p3Tu3cv5ybL+/EaPRz+quz5NWP2VY+WC3zNm
	9/yt/eYewz7147Pfulvuhs9/r8waaXN5yq1NOSxRLvdOLltpx8vdnvv1terv2gM3DvxblbJ5
	i4Jvy2H5CXcj455PYP9WpWcXmrZXMOp4nqHrm8keR7gywjef1fm91Ih94tHMj+/81U93f19x
	Zf9G5kjOrzXnjhwQmX2m12n3mUj+WcqG9z4qr64NVGIpzkg01GIuKk4EAPZplovKAgAA
X-CMS-MailID: 20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250
References: <CGME20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250@epcas1p3.samsung.com>

Some file systems may not provide dot (.) and dot-dot (..) as they are
optional in POSIX. ksmbd can misjudge emptiness of a directory in those
file systems, since it assumes there are always at least two entries:
dot and dot-dot.
Just set the dirent_count to 2, if the first entry is not a dot.

Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
---
 fs/smb/server/vfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 9e859ba010cf..bb836fa0aaa6 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1115,6 +1115,8 @@ static bool __dir_empty(struct dir_context *ctx, const char *name, int namlen,
 	struct ksmbd_readdir_data *buf;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
+	if (offset == 0 && !(namlen == 1 && name[0] == '.'))
+		buf->dirent_count = 2;
 	buf->dirent_count++;
 
 	return buf->dirent_count <= 2;
-- 
2.43.0

