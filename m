Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2523926C384
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242718; cv=none; b=d+jv0uTdr6peKRKdwFgO6G0PQdeZ+Iv5g5KnFzckaPYstV4DHYkeT4UB4RA3gfun4+oNA4a8vjhGX6z57QdMk0jMM2VTVRG2LFFAbO/g1BryqwAuH6TR1AU+LAeT/WyboB+mAVeMnCnduJMdlSDZA1/QORJ0LkdWszldJXBinHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242718; c=relaxed/simple;
	bh=UoSzlA7UcDhi8VzWSSDyyp/VpWPrqxSzqFUkbGUfWp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBZqwHlbBjTDEPigYEeN/EG10XNkeWMhEJWsqz3oHE9UTGjKCf6SCx1GF+/CrQ7xm5eCxnFXuLp4A8tmT9LtMb7niQE7DLLEqfkKD8BI5+xZHZK7YqUG6sh3Rn404XbiwUE22Lb845H1l79PMc3G/1BvAYKorq6/zqV3XQLjMLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fb3nzoHY; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fb3nzoHY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2d4eXbhHC2qkvORC6gvYB29v6kL4CKbLiTNuDFfzF6E=;
	b=Fb3nzoHYIpgLdmiD6vR6Sb3+LzTx5tFHDUAWee4Or9+QrVFwwXBczE/WJMZ90lqV/3s8xt
	W0SfltBq2JyqcdQdVX7KObjx6Pp9ulVqOUud+soDJk3nEMknR3vdKPFgOSFR+6ojsWk/dh
	4PgTVEceJgyadmDSkNtUe9U+L5UDNyg=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 04/13] smb: move file_notify_information to common/fscc.h
Date: Tue,  9 Dec 2025 09:10:10 +0800
Message-ID: <20251209011020.3270989-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

This struct definition is specified in MS-FSCC, and KSMBD will also use it,
so move it into common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h | 11 -----------
 fs/smb/common/fscc.h    | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 8f0547d1fe0e..e10392eb80e7 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1358,17 +1358,6 @@ typedef struct smb_com_transaction_change_notify_rsp {
 	/* __u8 Pad[3]; */
 } __packed TRANSACT_CHANGE_NOTIFY_RSP;
 
-/*
- * response contains array of the following structures
- * See MS-FSCC 2.7.1
- */
-struct file_notify_information {
-	__le32 NextEntryOffset;
-	__le32 Action;
-	__le32 FileNameLength;
-	__u8  FileName[];
-} __packed;
-
 struct cifs_quota_data {
 	__u32	rsrvd1;  /* 0 */
 	__u32	sid_size;
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 35dbacdbb902..b8e7bb5ddfdd 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -144,6 +144,17 @@ typedef struct {
 	__le32 DeviceCharacteristics;
 } __packed FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
 
+/*
+ * Response contains array of the following structures
+ * See MS-FSCC 2.7.1
+ */
+struct file_notify_information {
+	__le32 NextEntryOffset;
+	__le32 Action;
+	__le32 FileNameLength;
+	__u8  FileName[];
+} __packed;
+
 /*
  * See POSIX Extensions to MS-FSCC 2.3.2.1
  * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/fscc_posix_extensions.md
-- 
2.43.0

