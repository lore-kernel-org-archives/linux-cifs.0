Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98C8274B37
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034385; cv=none; b=mvqZeY+XlWF5NIm8ZqCcv2b48OJlGgK5Z9WVRMmM71EVTlae1l9iuwRVbwOInXbTN4rbd19eyY+5Z9WDTiW0hMG9gh73I7zifEkXFWIk3DNXNXAPiZ+sNvZj/o2g/GHdoyUxdkjScqTY2RzUptUQhmHVOgIkIfLvKDKMhW4scWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034385; c=relaxed/simple;
	bh=4JJp2NWhr5BTXdht9jh/3UFu2aqUDb0sNi6TkyC1740=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIF2oeJUmVAmLiIHJmgEIVKzC17HsHebl9oI+wat8ZhrkbAopjonbOMeCjvt3nTAfdNGlPlNqxnTyBgiv91r0wWve1VW7ARLgxx2i52bmQ4Z6Ju7T5spmtYK0bf7zt1afaPYAZfRJW/SUqJq2M0UGoECvFz9RJHzC9yq+liz8a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dBVeN+/x; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dBVeN+/x"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OpT0hLrQO7wTfJ3bQS8ehrjwnJyCu8VpuzDETsNFyMs=;
	b=dBVeN+/xqDyhOYgY45P8alcEm1bDW2w3p0X+EzQsQM37mjR1iV7dTShd2Cwz7/OTp1jWCR
	ycS+FQFrjmGtrHZCMCSJC+jhdqBeFFS9x9lO0J9QY7J0Nz8J+FeWo3TwyvwBUaJhf4pcd3
	H+14kLoXefUOzEv2XyVdLZTyUjIssUE=
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
Subject: [PATCH v4 03/10] smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
Date: Sat,  6 Dec 2025 23:18:19 +0800
Message-ID: <20251206151826.2932970-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

See MS-SMB2 3.3.5.4. To keep the name consistent with the documentation.

Additionally, move STATUS_INVALID_LOCK_RANGE to correct position in order.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smb2status.h | 5 +++--
 fs/smb/server/smb2pdu.c    | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/common/smb2status.h b/fs/smb/common/smb2status.h
index 14b4a5f04564..7d6b8ed304fc 100644
--- a/fs/smb/common/smb2status.h
+++ b/fs/smb/common/smb2status.h
@@ -631,6 +631,7 @@ struct ntstatus {
 #define STATUS_DOMAIN_TRUST_INCONSISTENT cpu_to_le32(0xC000019B)
 #define STATUS_FS_DRIVER_REQUIRED cpu_to_le32(0xC000019C)
 #define STATUS_IMAGE_ALREADY_LOADED_AS_DLL cpu_to_le32(0xC000019D)
+#define STATUS_INVALID_LOCK_RANGE cpu_to_le32(0xC00001A1)
 #define STATUS_NETWORK_OPEN_RESTRICTION cpu_to_le32(0xC0000201)
 #define STATUS_NO_USER_SESSION_KEY cpu_to_le32(0xC0000202)
 #define STATUS_USER_SESSION_DELETED cpu_to_le32(0xC0000203)
@@ -1773,5 +1774,5 @@ struct ntstatus {
 #define STATUS_IPSEC_INVALID_PACKET cpu_to_le32(0xC0360005)
 #define STATUS_IPSEC_INTEGRITY_CHECK_FAILED cpu_to_le32(0xC0360006)
 #define STATUS_IPSEC_CLEAR_TEXT_DROP cpu_to_le32(0xC0360007)
-#define STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP cpu_to_le32(0xC05D0000)
-#define STATUS_INVALID_LOCK_RANGE cpu_to_le32(0xC00001a1)
+/* See MS-SMB2 3.3.5.4 */
+#define STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP cpu_to_le32(0xC05D0000)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a4f6de350df8..b1323f1b100e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -896,7 +896,7 @@ static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
 		return STATUS_INVALID_PARAMETER;
 
 	if (pneg_ctxt->HashAlgorithms != SMB2_PREAUTH_INTEGRITY_SHA512)
-		return STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP;
+		return STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP;
 
 	conn->preauth_info->Preauth_HashId = SMB2_PREAUTH_INTEGRITY_SHA512;
 	return STATUS_SUCCESS;
-- 
2.43.0

