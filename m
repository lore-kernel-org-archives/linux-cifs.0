Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31742248B4
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059542; cv=none; b=DELuhkBVolvHVQIGSnJEPqB7xmcG4ch7GYeBDdBq8ZNsOgeHxTnqp82u0k/G3k37QzMmlBeEHzomJVdJ8md6/g7ppaTGFG1Uz7p9bWkcVhTorm9P2H2AyPR/sRSH8qvbGX6SIowCcnkuicy78jtSmyRspNHPENpBq25qERAfOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059542; c=relaxed/simple;
	bh=7GwzdWbBoU2nndr5PnGua2IkIkrVy6Oux/JlI1Nfl5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrrJGVI8zHqYaIYsHtFkoDk6bGUM6zt/BxzWZwf48zRTq29AczKhYedULJysvEBuelPd8mj38uenxYE/xnGWpdGYZLxcmECnWK2doX2cjJfYWGTESTe6KhwUr3z1Q/mn5ROjQFhS5DG+OpXLw9f9PbhqIlLo1Tph6eWoGONdW3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lo7vLqIS; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lo7vLqIS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1IfFzqiOdXz100WdtuLduBClIwRQf+l8XC3wQs0MNQ=;
	b=Lo7vLqISxyIvbnOCmch1UTXsu77wehfLG4H+MYWvOhgdMyuRgekOBZgWwTMMgEyJvu8sTl
	GROEOdRsfTbdyl22G26Bx0wB7vYIZJgv9x8+WYKioxupmARzS/px+pfX4jNQ84vNI2WRi6
	z12y4Ck8fcgpZEdjlg5MWyYY6mPdUng=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 7/7] smb/client: move NT_STATUS_MORE_ENTRIES
Date: Thu, 22 Jan 2026 13:24:02 +0800
Message-ID: <20260122052402.2209206-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

It is an NTSTATUS value, not a Win32 error code.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 03d120e2ce09..9a4a450c6571 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -22,19 +22,19 @@ struct nt_err_code_struct {
 
 extern const struct nt_err_code_struct nt_errs[];
 
-/* Win32 Status codes. */
-#define NT_STATUS_MORE_ENTRIES         0x0105
+/* Win32 Error Codes. */
 #define NT_ERROR_INVALID_PARAMETER     0x0057
 #define NT_ERROR_INSUFFICIENT_BUFFER   0x007a
 #define NT_ERROR_INVALID_DATATYPE      0x070c
 
 /*
- * Win32 Error codes extracted using a loop in smbclient then printing a netmon
+ * NTSTATUS Values extracted using a loop in smbclient then printing a netmon
  * sniff to a file.
  */
 
 #define NT_STATUS_OK                   0x0000
 #define NT_STATUS_PENDING              0x0103
+#define NT_STATUS_MORE_ENTRIES         0x0105
 #define NT_STATUS_SOME_NOT_MAPPED      0x0107
 #define NT_STATUS_NOTIFY_ENUM_DIR      0x010c
 #define NT_STATUS_BUFFER_OVERFLOW  0x80000005
-- 
2.43.0

