Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E34F2FBE14
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 04:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824392; cv=none; b=PvTQBOC3rnTw8d76PfWN9n6b510N/WI3ZQtPUClKGasCYorrdZORcdnr309VsIJTj4PDgY/QyCmXltLkAfgR+qLn2YT0cXE3W/+F/MweBvysnj4zYeFizdvoFiIwJUCe/gpU7HnwuNFS3jTGdU6x4eA0ygsiWtoeMMiZrZN6Sms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824392; c=relaxed/simple;
	bh=wHQHPGOBL67LojJYdHJntJqg3PyDMhkYPnnAIameZCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3v2hTF66Cd6mqNQqFKGt5FNnz+iyikbQ1Az86oOS6228pSxJikUMb89PjnN+Uc5MlxP5wlRm18XW/ddRLsC2ahmLi32BZ7nnIlmOwE+L+IaBZRQQh11/JRDEaqFCzMzCoDj1jZdl8NP+jxT7bUjx+LP4m/JCjmhrfRzZHawUY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H74RaZP/; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H74RaZP/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spW3FIUdbUtBzBiQQzKvx4iZUCmDJ5m4MvmIKanhjUw=;
	b=H74RaZP/lLXfRt1P0F0FIlEfUiHIFXRDGa+c2NIQTowszxo7Zn+y5tP6eqszofzTFdXIJR
	IQK0MG+PFcU9c+2WKrJZCuJovFm7Ed5X5278NMR02UpPWCSRs8559epPEoKWnSMmgUNCCa
	hFWyjkP+eY7MAIGfOj1YrVDby4vS/Ik=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 03/10] smb: add two elements to smb2_error_map_table array
Date: Thu,  4 Dec 2025 12:58:11 +0800
Message-ID: <20251204045818.2590727-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Both status codes are mapped to -EIO.

STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP -> STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP,
to keep it consistent with the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 3 +++
 fs/smb/common/smb2status.h   | 5 +++--
 fs/smb/server/smb2pdu.c      | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 118e32cc8edc..a77467d2d81c 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -734,6 +734,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_FS_DRIVER_REQUIRED, -EOPNOTSUPP, "STATUS_FS_DRIVER_REQUIRED"},
 	{STATUS_IMAGE_ALREADY_LOADED_AS_DLL, -EIO,
 	"STATUS_IMAGE_ALREADY_LOADED_AS_DLL"},
+	{STATUS_INVALID_LOCK_RANGE, -EIO, "STATUS_INVALID_LOCK_RANGE"},
 	{STATUS_NETWORK_OPEN_RESTRICTION, -EIO,
 	"STATUS_NETWORK_OPEN_RESTRICTION"},
 	{STATUS_NO_USER_SESSION_KEY, -EIO, "STATUS_NO_USER_SESSION_KEY"},
@@ -2413,6 +2414,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_IPSEC_INTEGRITY_CHECK_FAILED, -EIO,
 	"STATUS_IPSEC_INTEGRITY_CHECK_FAILED"},
 	{STATUS_IPSEC_CLEAR_TEXT_DROP, -EIO, "STATUS_IPSEC_CLEAR_TEXT_DROP"},
+	{STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP, -EIO,
+	"STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP"},
 };
 
 int
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
index 60839850025d..d70b4d32e8bc 100644
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

