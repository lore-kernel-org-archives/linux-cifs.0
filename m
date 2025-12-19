Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B959C287510
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766163871; cv=none; b=OLUHThEwatSg/ELhmxko6ZEN57rEJRH46OaJBCqoeaG8HwghauorjIHlr0dB8VXOtJsTqd4+0l/a7N0Oy45cbtbqbyXVXQ09s8MFSXbuwS2T6bZ4ODqUAPIohHnUvgw4yawvQFtlJq90oi6sgGlvec8BLqA+veMUJ+Xtcq5Kz3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766163871; c=relaxed/simple;
	bh=sM2XKwZh0rrG5EcjwOVFiPbaVpSw1s2MTivNgCpmWZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhL4F+9GCGwOtbd+wJMlhQo8d4atNR1Wsw1+HVPgmKkXeDxasPuliqkUutaty0Dp5i1XgzJzil9B0MhtQhxRcrFvR1P4c9xWpPn8D4urn3oYBlHUyCHDK9+tW4lIxEH7b4lKjU52JtYZCjMVNDmzzSN5NI9ObHb4HVmAGbw7MV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u3rIk9ji; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u3rIk9ji"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766163862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qz53u02rRIuSTQk43PrKolSkKWsMJqS2m2kT3126owQ=;
	b=u3rIk9jiIgIih29MB2aXPINspyCReC6v76SXgLGXxpIrmt+iT2Zc/TMAM++nbd0Z62z+c2
	FXudaMhvfmKz5nvH7bF0yzh6F6QNXxcPizw1t/MYwxqtelbHjU2JLIkxHlM7vFL1vyty2v
	vvZQmgmz/B8YwkBv2XrkfjM+mDiLdHg=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH RFC v2 3/3] smb: use sizeof() to get __SMB2_HEADER_STRUCTURE_SIZE
Date: Sat, 20 Dec 2025 01:00:57 +0800
Message-ID: <20251219170057.337496-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251219170057.337496-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251219170057.337496-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I have checked the size of the structure using GDB:

  gdb ./build/fs/smb/server/ksmbd.ko
  (gdb) p sizeof(struct smb2_hdr)
  $1 = 64

  gdb ./build/fs/smb/client/cifs.ko
  (gdb) p sizeof(struct smb2_hdr)
  $1 = 64

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smb2pdu.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index f5ebbe31384a..f2a6b7191f43 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -107,10 +107,6 @@
  *
  */
 
-#define __SMB2_HEADER_STRUCTURE_SIZE	64
-#define SMB2_HEADER_STRUCTURE_SIZE				\
-	cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
-
 #define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe)
 #define SMB2_TRANSFORM_PROTO_NUM cpu_to_le32(0x424d53fd)
 #define SMB2_COMPRESSION_TRANSFORM_ID cpu_to_le32(0x424d53fc)
@@ -157,6 +153,10 @@ struct smb2_hdr {
 	__u8   Signature[16];
 } __packed;
 
+#define __SMB2_HEADER_STRUCTURE_SIZE	(sizeof(struct smb2_hdr))
+#define SMB2_HEADER_STRUCTURE_SIZE				\
+	cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
+
 struct smb3_hdr_req {
 	__le32 ProtocolId;	/* 0xFE 'S' 'M' 'B' */
 	__le16 StructureSize;	/* 64 */
-- 
2.43.0

