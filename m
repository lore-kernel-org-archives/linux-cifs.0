Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B548332D434
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766163856; cv=none; b=kUiEPkBjjF0OpnzQSqQ5CWheTYn7zl1sFYWqdH1lBCq/TJt/kUhj5xmWtwgVHkoZKP4dU81gOCFsUCcsO7l62VvbJefcizm0Yopf2/IprbBGnDDt9dVYxsiS2ozsmccbysFOECuqk6GZ7jz2Y0BTzSnrot4n2bdFnY1yg/PnNMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766163856; c=relaxed/simple;
	bh=tFKjVlXzqjceOHeK7O5kE5TVZQgv6nCOjDPQZrPfocg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq5hmh4QTGVyRXvsvXyzLsujj4ELZv3y2WtLiYg6XSxaAjTwb+zOw/dcWr8YRH6i64pDFlKW4wPXTSHcjLEYAcIRdfjSUd+m/h1zy90WOHkZgAAZkYqkDGDu4/laGZL6MiwKf3C3bgnVhtc5hRgUb/H7oyXZ896p4nxSBtaZs6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JqfTkXPm; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JqfTkXPm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766163846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5QxYmQBsKFpyA35KMLBjauc5+QlBGY4mJgHLixtcMcI=;
	b=JqfTkXPm/0KL9w715Yubqdaon049Xp6Q/MDjVA54T1KyMqGaV5kd3BEYWJaxza/PPAh5yA
	bLK407CX7ehcMe1QQ89aOYgX63vl4P6/MrWorlH2bbd1nCz1NGyT0WqzBEE8qrnxT6ss03
	5ixFGJrATHrRHMd8W5Dqz8sgF93GwbA=
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
Subject: [PATCH RFC v2 1/3] smb/server: fix minimum SMB1 PDU size
Date: Sat, 20 Dec 2025 01:00:55 +0800
Message-ID: <20251219170057.337496-2-chenxiaosong.chenxiaosong@linux.dev>
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

Since the RFC1002 header has been removed from `struct smb_hdr`,
the minimum SMB1 PDU size should be updated as well.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
Suggested-by: David Howells <dhowells@redhat.com>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smb1pdu.h    | 5 +++++
 fs/smb/server/connection.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
index df6d4e11ae92..3c5332a82ea7 100644
--- a/fs/smb/common/smb1pdu.h
+++ b/fs/smb/common/smb1pdu.h
@@ -53,4 +53,9 @@ typedef struct smb_negotiate_req {
 	unsigned char DialectsArray[];
 } __packed SMB_NEGOTIATE_REQ;
 
+struct smb_pdu {
+	struct smb_hdr;
+	__le16 ByteCount;
+} __packed;
+
 #endif /* _COMMON_SMB1_PDU_H */
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b6b4f1286b9c..f372486ebcc5 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -295,7 +295,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 	return true;
 }
 
-#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
+#define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_pdu))
 #define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
 
 /**
@@ -363,7 +363,7 @@ int ksmbd_conn_handler_loop(void *p)
 		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
 
-		if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
+		if (pdu_size < SMB1_MIN_SUPPORTED_PDU_SIZE)
 			break;
 
 		/* 4 for rfc1002 length field */
-- 
2.43.0

