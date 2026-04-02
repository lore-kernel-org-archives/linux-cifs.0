Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F305B3EBF34
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139610; cv=none; b=YaYWFWSguIOEN+3p1LS/IqrSc32xlQjqGz4pZ2rdxTGmG9fJFrtqMUIg+BBQdWppmYrQBi3jkl2yn9gDkKhLK0LZ1feHwxf2aaXddme0+PoAp5wsbFO8LPvEnB8zPkQKJ5wyKecqOz7YMmrjvxUmDIABv/i4wzfyhQq5Wk+hoek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139610; c=relaxed/simple;
	bh=Yfmwh/QRf18KWF6Atj+6hGV+GLIzNHqkI9yw8DJTuaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duuViaJ5AGIuhHU1lRYtS6zLQx43CchySLA2XFp1rS06A5O//dtsc5Gh8BhDLlnZ930iDEG1Ka477fT6JqhwFR8hsZuzPEHeF/ZXCt5trZWd6DVrg3EMW1IJx4cNpJC4CHmEzzZhc0rBZdh2bGiQt6w9lutc4klKtSI7ulx+DgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BIPt2S0l; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BIPt2S0l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775139605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=osjGwu2xXHN0Iian/Q3Dg7gFlmnTolkgiOqCNdoN48E=;
	b=BIPt2S0lc/h5EdjqHHqEuSxtMLHAvr/I5D15ubqPh17qnYUYFpHeJYZnaCM8hyjY7iFOMU
	LE13CXBEQC9cq0uHCzn7K0BiILfarEgTxk0KKtLGaj+zfO3v41sLn3m/2yOVgqgbfCyzZ8
	H0Eggzd3uhQNnN4LyQ6bMOXs5qddlko=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH v3 08/13] smb/client: move ERRnetlogonNotStarted to DOS error class
Date: Thu,  2 Apr 2026 14:18:34 +0000
Message-ID: <20260402141839.461257-9-huiwen.he@linux.dev>
In-Reply-To: <20260402141839.461257-1-huiwen.he@linux.dev>
References: <20260402141839.461257-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

In smb1_mapping_table.c, ERRnetlogonNotStarted is included in the
mapping_table_ERRDOS array. However, in the smberr.h header file,
this macro was incorrectly placed under the ERRSRV (server)
error class section.

Move the macro definition to the ERRDOS section in smberr.h to maintain
consistency between the error classification in the header file and its
actual usage in the mapping tables.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smberr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smberr.h b/fs/smb/client/smberr.h
index 6fb63f9e9a95..5cdd958aaa35 100644
--- a/fs/smb/client/smberr.h
+++ b/fs/smb/client/smberr.h
@@ -95,6 +95,7 @@
 					   limit to be exceeded. */
 #define ErrNotALink		0x201	/* A link operation was performed on a
 					   pathname that was not a link. */
+#define ERRnetlogonNotStarted	2455
 
 /* Below errors are used internally (do not come over the wire) for passthrough
    from STATUS codes to POSIX only  */
@@ -167,5 +168,4 @@
 #define ERRbadclient		2240	/* can not logon from this client */
 #define ERRbadLogonTime		2241	/* logon hours do not allow this */
 #define ERRpasswordExpired	2242
-#define ERRnetlogonNotStarted	2455
 #define ERRnosupport		0xFFFF
-- 
2.53.0

