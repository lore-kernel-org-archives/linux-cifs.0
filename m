Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F88253F11
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068746; cv=none; b=u9JRiD7E6bPap/+WU0BUwykatV31xnYBDiWu/AoHO60cofFBRmVJB/wS+er6uICsY+nBFVm17Txv5t8EdCJd3YdVdMHHnRliSlZEHVmwKqzieOnSCstysbTlIJkVwGOsW0iPIcGwzcfnDsjeZcwaIx8zmvEnQR4gxTTctnpIEUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068746; c=relaxed/simple;
	bh=Zx31GQhTf+NGlFQDldb/w2jBqmYAff62m6LXTgOKi08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRNVfcTIXLOR7kMPoelNr4RkWbr1nllCz2rtzCC5Cx1I8WJLhntKT4B3G+Kqdi/jQZZ12ziCoMPFAJ8Si/KNFEhjwuVHkSjyzBhVGaB5DrtC4BM9XRpsthZOyde3tK6aUXLSixD/K9H1GAzbgioaSMe5vts4iR1u4rIj6gnrdQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=djjU7PTm; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="djjU7PTm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1PKr7dfmn1x3wo4NC3mmqZ1Avb8U3jlg6h/I/4TzkM=;
	b=djjU7PTmllE2QhB+q9rW6Y4yI57PWxZuZgJQxN+j2voKRnHPXwwFTWDLQn0/l9PlFohu3Q
	y7fZEajeOrOPxm6/8uRcJfR1GpVEaXNenvs3r1NHoXv+PyLq5zfd12kdIhzld8xa636cLN
	oDAix8J7tc9WojgaB0k5fSV8cd0yJ68=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 02/14] smb: move MAX_CIFS_SMALL_BUFFER_SIZE to common/smbglob.h
Date: Sun,  2 Nov 2025 15:30:47 +0800
Message-ID: <20251102073059.3681026-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

In order to maintain the code more easily, move duplicate definitions to
common header file.

By the way, add the copyright and author information for Namjae to
common/smbglob.h.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 1 -
 fs/smb/common/smbglob.h    | 4 ++++
 fs/smb/server/smb_common.h | 2 --
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index aba9caee8302..2fb1eb2fff41 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -86,7 +86,6 @@
 #define NT_TRANSACT_GET_USER_QUOTA    0x07
 #define NT_TRANSACT_SET_USER_QUOTA    0x08
 
-#define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 /* future chained NTCreateXReadX bigger, but for time being NTCreateX biggest */
 /* among the requests (NTCreateX response is bigger with wct of 34) */
 #define MAX_CIFS_HDR_SIZE 0x58 /* 4 len + 32 hdr + (2*24 wct) + 2 bct + 2 pad */
diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
index fa3d30dc6022..7853b5771128 100644
--- a/fs/smb/common/smbglob.h
+++ b/fs/smb/common/smbglob.h
@@ -2,8 +2,10 @@
 /*
  *
  *   Copyright (C) International Business Machines  Corp., 2002,2008
+ *                 2018 Samsung Electronics Co., Ltd.
  *   Author(s): Steve French (sfrench@us.ibm.com)
  *              Jeremy Allison (jra@samba.org)
+ *              Namjae Jeon (linkinjeon@kernel.org)
  *
  */
 #ifndef _COMMON_SMB_GLOB_H
@@ -65,4 +67,6 @@ static inline void inc_rfc1001_len(void *buf, int count)
 
 #define CIFS_DEFAULT_IOSIZE (1024 * 1024)
 
+#define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
+
 #endif	/* _COMMON_SMB_GLOB_H */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index c3258a3231e4..a2c7ab994fb1 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -29,8 +29,6 @@
 
 #define SMB_ECHO_INTERVAL	(60 * HZ)
 
-#define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
-
 #define MAX_STREAM_PROT_LEN	0x00FFFFFF
 
 /* Responses when opening a file. */
-- 
2.43.0

