Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDC03E9F65
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996270; cv=none; b=bVedX7TPu+qP2uQbT+rHQJeugZ9GQEiC7pYWS0zeaaLA6VyQ8xI9fYyeBUxc0wSSN1CTVAIxVOLKsGnKrXWLEuCWwro5tJ5K3Bfe7BquOmRaAQUs4ALvOePZxxrkoHl8aO5hbUEE4YyqYv5dDpxCny6q4jI8rP55SOcO1Q7fSnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996270; c=relaxed/simple;
	bh=GkbLwNMY+r/QSYB9OTMddJkhnR+qc2p0vAaspvXqCdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbvJMZKIDyerEXlAIub3mVc+KbK3ISL7ol/zcl6a5VjM6j55UcDVk37SLMsIJNm2ZsBrgj5yT5uPMuMvverVDQqJvEIeIXfW0hJ5ImZ7cVuz8dRTRR4iwJlnHFKkn32KT22XnIXKiOW9LFpN/RXURHJSJxd1MxzSt0ARRBSzdGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NPKdnsG5; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NPKdnsG5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHdcvuUf5LR3Bwbp3t3z9sKUqnZFWS3+x79ZWWgShoM=;
	b=NPKdnsG5DScXpvLIyTrjGWtR+4gN6uvIlh0BQOZ4wpLKc4bTon+skjbaQXv/4NrArqn1uC
	2Do1fmcRnppiQsLfTtM3R/Q4yiOETU8aA2B3tkrt9tzHR/xsSHjMJXyVsBA4e50c2HnjCV
	SLJwNQSTTbOkqbowZmc7clADLqN9ghs=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	hehuiwen@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 17/17] smb/client: remove useless comment in mapping_table_ERRSRV
Date: Wed, 21 Jan 2026 19:49:12 +0800
Message-ID: <20260121114912.2138032-18-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

These array elements have already been defined.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 0924ebebb65a..e8aa7d44cbc6 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -94,10 +94,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{ERRusestd, -EIO},
 	{ERR_NOTIFY_ENUM_DIR, -ENOBUFS},
 	{ERRnoSuchUser, -EACCES},
-/*	{ERRaccountexpired, -EACCES},
-	{ERRbadclient, -EACCES},
-	{ERRbadLogonTime, -EACCES},
-	{ERRpasswordExpired, -EACCES},*/
 	{ERRaccountexpired, -EKEYEXPIRED},
 	{ERRbadclient, -EACCES},
 	{ERRbadLogonTime, -EACCES},
-- 
2.43.0

