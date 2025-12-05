Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A590137932
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 04:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909069; cv=none; b=ADS2TAlqjFfplh1JAvUUC6rkIYGOmbG4xNqsrhCqxwteQ/UO/PZwdf97B1V9bUTx+QIaVIuxEu22CH1gBifElS7J8deIQQNG/w8vkX0aj0epgjej8qeU8BB7g2Pb7yp3NhtiK2INzZL+jlVBV34R1HLZ7GiGdzHiVSQ9xOMSss8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909069; c=relaxed/simple;
	bh=4JJp2NWhr5BTXdht9jh/3UFu2aqUDb0sNi6TkyC1740=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaG91lNdYwj0SB43pVCMNsr1gPX6aeM578W5toED6YM63SSuburlt9BBBBPmPD0UVmYt+3Kw13cIXYbp7OA8xVzCBowrnW9QXgi9K27OObDYssao424NnV1Ke21hTgOsAxllTCV0/yUf93goVbLTO1GyyyauhlClUKlTUSbE4Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iZcwCUf8; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iZcwCUf8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764909065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OpT0hLrQO7wTfJ3bQS8ehrjwnJyCu8VpuzDETsNFyMs=;
	b=iZcwCUf8AtmOzIHUBXtcU/mX43Ub76l8QBmY80WXOxMOTz76fd1m4vRRYhS45D0g0zzuEb
	feOE3mUzYaOmg/soa26MzK+hoR46zrfHMcNhTY78RKQUM0Q6wc1HldRHXcjW1pEjMn6xZh
	5S3dwd5T99D2jbjj+WYttJgR5CSPdNk=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 3/9] smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
Date: Fri,  5 Dec 2025 12:29:51 +0800
Message-ID: <20251205042958.2658496-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
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

