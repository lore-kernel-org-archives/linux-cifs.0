Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756491A6835;
	Sat,  4 Jul 2026 05:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783143043; cv=none; b=vEwj3ZuRIDr3vLi1DkmgKI/ID1PpeOWv9h2EPFDXUDAKK0Y8vfY7tp7CHHF9KYvpy+HLrdoMF7f+61SKEht6JOdbxM3eEe92ECnPSaXzqLDdneQ+3VWHJ3c6WrxQzcM5MymRgjvuGz2iHCziTeVLMFdhnZW85n4fFrX/iO7b1GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783143043; c=relaxed/simple;
	bh=tJcox1rWD4z7Jk9os3ZWyqBe8ykE6s2cpS38xza7HJI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JgYt3WWGGCpCWhDPrTHq+D2EjBW2Fjg7p1TPJZoqLBBSKIfhsGU+/zL8v12fAjv7bULgCOOrT+1jB894uWpAOv7uNBm+IHW+JXWZ4cwREaH6ZHwTNraqq7hQ7z2gw8lTCVwPxh2uSxUsfdy/ontTh6xbEK9QX4kQNjIOM8FpiTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iMH3Qx50; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iMH3Qx50"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783142856;
	bh=IxMT6gRH7itvC7SHpm4MmhQpkU51+Z1iysNx8SCxqvk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=iMH3Qx50A7v7pnLzDJOJUsOsa9jaIH6ugSrD6F5KCLSE8t89WSnFNg6+ksMWkTTUP
	 el17CDeUvEx8GQv4J/G1zWwo4xY1RS5IunuF6kdW467pS4RMNnwxmIe0Yj+aq2AVZl
	 DU5WXLFvLvK1xIajKLZciD3srexAsJKgdiJHgnIU=
X-QQ-mid: zesmtpsz4t1783142838tbc75a0b0
X-QQ-Originating-IP: kMIW2AZwJB+HFp3zxoZaK4l6MEmWmemZ80bEhw1pAgs=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 04 Jul 2026 13:27:16 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5754723132755459465
EX-QQ-RecipientCnt: 10
From: Yichong Chen <chenyichong@uniontech.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] smb: client: free partially allocated transform folio queue
Date: Sat,  4 Jul 2026 13:27:14 +0800
Message-Id: <20260704052714.428561-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NyTsQ4JOu2J2WcpFu4cugBIaWVYqYsbobjvyss2RPJ5pOaD9GyxxVkch
	A0RML/t542II9iobPHUkXyk8d9q2SMWNHpiC7ujefwhjXZvBj/lk7Cpx6dnR9+W5WcojSCA
	wnL+Kg/jEZ+dG+MqawlTIegFJ3o56dk4ObX3bYOSdgxi5xv7Wbzs21XtqydqujIvc0Ckpd4
	Et9B5FrbXlWZeT5WJE5W2TDrqVZcltnGycldy0i77r+H+kBGJviJiS8VJ6VLZZlapEKe5rq
	2RDBGLtejhV40vSRFkS5T8+eCP7T+OiYf4WIF+OhhlK0bwXkoTLTiv7RW6fOiyCGqZgYfUv
	6f33OfEfLYLN/H2MvMmNf+HTl4TYrK3ZM7wVSxFA4j1h7YfKSMXDj6XQpUy21XI3OICYC8e
	Uiw8S+qMKGvmcB1j5e223rb2S7viCNMwQcJ0T49tVO/R2D/6hKxMziAUfV42SKteocMBEkH
	G+8G3f5tng7hTZ8B4hwmhApq/VVF4Bodp72cPlA7R7CPSChAUTiP6kBQA6X0VbL1Q3G2kuC
	FGK7Sh8eDOMycQRozQzW5RXQuYL4s2yvE6zrZGBr7Ul51LDK9CNAzjeZKoM/9GMPmRhIM7t
	lKnf8fn5s/TOZ6IgBzDQA/AsLfaIsBkxtGv3Ww0mQtmzrXfk740lf7nSB11vU/bHpYVrCHc
	8A9D2GmrHFrx0Nr41DuIAgqjRC3vqWFNFFZSMm8sB+OtexdWjff8FpfSEQVThDOTQFN2yn/
	KQZrvYP8r88AVirfnc8CcRgjNVJdojYKJ/2AZOxwKoR3hLIGe8T54ynbpZgKm7H1eIvl9VP
	j1e67j7EPOTtfU6cXPFz3HmcXqYyxM3UP5rqC9ki6blCQ8x9UIHejGcaboVRJo7OzPyKaAj
	T6oLEeLtjrUMndejgeIy286puePGKhX5XT4DCOrD9UsTdFyzjyveNKXfSMpPyvJEWqyJXHM
	4QCVWeIgqsSVko4kG6dufMItrvr2Nr0iZhiP2DEyhChes5rvMk6lVEnrzN1zxQQXCWHNs5f
	q4bhhSWX1CxFKg9S03OPyZMcDEzR/qQgKWmVkJY4imQkQoxK3ZmfNcmSig6eZYPbAwH3kVK
	+I2MhI2yRhm
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

netfs_alloc_folioq_buffer() may leave a partially allocated folio
queue attached to the caller's buffer pointer when it returns an error.

smb3_init_transform_rq() stores the buffer in the request only after
allocation succeeds, so the common error path cannot free a partial
allocation. Store the buffer pointer before checking the return value so
err_free releases it.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/smb/client/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 199f6aeb7b33..3fe9f0534e42 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4882,10 +4882,10 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 			size_t cur_size = 0;
 			rc = netfs_alloc_folioq_buffer(NULL, &buffer, &cur_size,
 						       size, GFP_NOFS);
+			new->rq_buffer = buffer;
 			if (rc < 0)
 				goto err_free;
 
-			new->rq_buffer = buffer;
 			iov_iter_folio_queue(&new->rq_iter, ITER_SOURCE,
 					     buffer, 0, 0, size);
 
-- 
2.51.0

