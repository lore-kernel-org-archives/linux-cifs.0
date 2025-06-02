Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB33224882
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884148; cv=none; b=iieHo/zAkGA/SlkZDoliJ3cebIoMZHykqMUGoXB6WjCA1vtC/PpE2bJ22wvHmZkZuaLQDOIkzxWZ3af3zZq1r7jrzqiTA3ET43MuhIBosN+ZqM9a+UotcIS5hoHUIT3Ixoy+nLMYF3rplMFLBO5lfmhwKS6LUHx48kM2u40bk70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884148; c=relaxed/simple;
	bh=1a+buuJ/yu53BkMP+WxoRmPsqdbkjv6LnkOh/AtKsr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPBJrd8AGWyn3DoFM7rY1TpiH1uKCyaNtYKI64rlgFmGKkwYKfY/otHfmaGpWTSTE7oRwkePLYQ2zhkksFbI0/qArmJcegc6t2zxJR20f9BRchFl0+RJ9jHG2Nmzm+PZXPrrrAsVLYHQ1+Hie1YJKX+wijbgRAEGUomI1p2ms1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOWl4zee; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOWl4zee"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-231e98e46c0so43009535ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Jun 2025 10:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748884145; x=1749488945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvgppn4KrR1ccS7/98n6E9hBw93UfkiPqXyBWZIB5kw=;
        b=YOWl4zeeTGrQ3WYw+OTBnvOC76/PFTQ3tssjhYRNSFZA/7uJOACMsLfajeox2hdkVY
         +DHbFuGNrmBmyv23U6tR3jYGvBQ3i8jQbs/nx5y0Z3AX6mSUMd0ywKYVzL4gCIC+rS1f
         +NqVLsLHEGOrxBppXekWqXZ6Iwzg6igzIcegvcZkkASdT9txv998tDk9D99DTF0P99qu
         kJ2HmseH7G9Q9lbpCWd+7mZ1hkavm3+VE8TodL8krse6wMb1v5Hsd0Almv3thl+AlUTG
         YJAMF000VHjlzOkPmGqVSp5RHmXO8OaGxwuCm/5xfaWmQubZ6RR4TRe0h9sLqxUh/trv
         DUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884145; x=1749488945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mvgppn4KrR1ccS7/98n6E9hBw93UfkiPqXyBWZIB5kw=;
        b=IgRvK9u/lSLuxNmfshZCGxmf8CUyc86ZxEOM391Yn29G2UHtINVZWwvyzlT6akjPsN
         60gDUN8iahCPS4s9KlGHwuNzxo3Izzp3K0KYM6G8/fWh9TrCwepKFhJT5Tlz0IIw3cR9
         XAhhfLmgXugFSWtJqDFcbMIsmrOSC5wtcRc4TJAED6xqqtWRtlEWctj1AkS6nJ6yVodu
         QcTlKBZvIlhIsoaGGVcZj6f7sMO02qubj2DNgstRjPExVPixKrnyCbPmDjFA0YNR4oOg
         ECYJFTE7dfedh5yE/qBQ5Zq1+CdHvymXKjMHm7k/NQn+k4mxdLf+OpygFBotXZRG2fOF
         eWDA==
X-Gm-Message-State: AOJu0YxeA+M6Ep/zlSNA74CcWlWw8x6zwYaQDN0RHqZe5LpqBtCD1Vcw
	rmQEXG0m2nAsjxmYD9KeM2C6oNneQoioE71NLh9hc8GSwv9rImlh/YKpFdRM/w==
X-Gm-Gg: ASbGncs7E0d07qkH9Jkkv+ifsf2hqaRPAyr7PrSWiQBj4q8wJTfmh4GvWsqruR1uTQT
	nW+P6ozva4MBaivCBa2Y/D/3v9lKubXZV+Q3BSBL1YQKm93iBDbslwOz1d9f0annSBxPRQzUHxK
	EGii12KfmDL8prCMsRvpEz0yMcHg7CZOxACnJQfsMYzAZSZupL0vneyceyTCyoM0eZU7CVqbmIc
	IfNro17UVWslOluZHweX9hx28ELzK2YKILM3JMdgMX8MsnRv8djelNOflnTwv6fSp0Yeq4zss0h
	AtGF2BiYTxv74wTcmtRXhO+u5E9jALsQwk0x/tADuk98SbFKtdh0XBabr8lCy2ab7X9Z0VMSVqh
	J5gdGmA==
X-Google-Smtp-Source: AGHT+IE/ncbNKJffqsMB2qdmoehy2txwD2ZPe4Nm5WfEd57BBbIKJtZPt9Kz6jm8AIK1FLJWYqosiw==
X-Received: by 2002:a17:903:94d:b0:234:8e78:ce8a with SMTP id d9443c01a7336-2355f79c7aemr149722325ad.48.1748884144938;
        Mon, 02 Jun 2025 10:09:04 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2355c58ecd0sm40319625ad.25.2025.06.02.10.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 10:09:04 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/6] cifs: serialize other channels when query server interfaces is pending
Date: Mon,  2 Jun 2025 22:37:15 +0530
Message-ID: <20250602170842.809099-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250602170842.809099-1-sprasad@microsoft.com>
References: <20250602170842.809099-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today, during smb2_reconnect, session_mutex is released as soon as
the tcon is reconnected and is in a good state. However, in case
multichannel is enabled, there is also a query of server interfaces that
follows. We've seen that this query can race with reconnects of other
channels, causing them to step on each other with reconnects.

This change extends the hold of session_mutex till after the query of
server interfaces is complete. In order to avoid recursive smb2_reconnect
checks during query ioctl, this change also introduces a session flag
for sessions where such a query is in progress.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/smb2pdu.c  | 24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3b32116b0b49..0c80ca352f3f 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1084,6 +1084,7 @@ struct cifs_chan {
 };
 
 #define CIFS_SES_FLAG_SCALE_CHANNELS (0x1)
+#define CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES (0x2)
 
 /*
  * Session structure.  One of these for each uid session with a particular host
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4e28632b5fd6..59a6b86c3786 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -411,14 +411,19 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (!rc &&
 	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) &&
 	    server->ops->query_server_interfaces) {
-		mutex_unlock(&ses->session_mutex);
-
 		/*
-		 * query server network interfaces, in case they change
+		 * query server network interfaces, in case they change.
+		 * Also mark the session as pending this update while the query
+		 * is in progress. This will be used to avoid calling
+		 * smb2_reconnect recursively.
 		 */
+		ses->flags |= CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
 		xid = get_xid();
 		rc = server->ops->query_server_interfaces(xid, tcon, false);
 		free_xid(xid);
+		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
+
+		mutex_unlock(&ses->session_mutex);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
 			/*
@@ -560,11 +565,18 @@ static int smb2_ioctl_req_init(u32 opcode, struct cifs_tcon *tcon,
 			       struct TCP_Server_Info *server,
 			       void **request_buf, unsigned int *total_len)
 {
-	/* Skip reconnect only for FSCTL_VALIDATE_NEGOTIATE_INFO IOCTLs */
-	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO) {
+	/*
+	 * Skip reconnect in one of the following cases:
+	 * 1. For FSCTL_VALIDATE_NEGOTIATE_INFO IOCTLs
+	 * 2. For FSCTL_QUERY_NETWORK_INTERFACE_INFO IOCTL when called from
+	 * smb2_reconnect (indicated by CIFS_SES_FLAG_SCALE_CHANNELS ses flag)
+	 */
+	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO ||
+	    (opcode == FSCTL_QUERY_NETWORK_INTERFACE_INFO &&
+	     (tcon->ses->flags & CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES)))
 		return __smb2_plain_req_init(SMB2_IOCTL, tcon, server,
 					     request_buf, total_len);
-	}
+
 	return smb2_plain_req_init(SMB2_IOCTL, tcon, server,
 				   request_buf, total_len);
 }
-- 
2.43.0

