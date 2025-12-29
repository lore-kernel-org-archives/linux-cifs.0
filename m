Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5546110A1E
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766974515; cv=none; b=QwBTUSusUktb9t91346b6vqxGXPxRPm8HTrJt7upPAaRLxV9CDXBz8WcZuI9XB3NgJVUkZX8jlJxqk/Yozas2NAwtetVLNNBDFsM/beQb208ErPSEEh1YsQW9AK6lFwnoXflwzozR861AUexJPvChq39XFhsvCNWheNLBTP/geI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766974515; c=relaxed/simple;
	bh=2/EFFNtK/RIM2Lx7G/RKStv/RurX36CdMPUsWI2I9qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMq01ssij01Yr1UB4plha4eo5UMjS2DMijifd4Q7AbsnqvQV3Z3a3Tx4dNslpN0P7h34Fu1xNkZM+tsQpvLDYGNiFLN5cy/We7zipuAnqKin9H5n6khu90rfATmUIRQihcRoFu/xOXlhmL8Lm8QJQCGd0H9KbHdb0DyoRJ7Phdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mMIqylr8; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mMIqylr8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766974511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H1TAoEoPDuqKDbe8jDmhuFo3vhIXOVlqrmtzfuo/kWM=;
	b=mMIqylr8JmQCuicFsc65PbgmbpLQlWbIY5tiFgKIqJeGzfty4tnVfUbTyoaj3WfwvDGE5/
	L6DPtyf615oQM78CWLOx9UlfkPrgkT/86MNTPJhrOcx3ZvlKm+lCkJZWWP2hGOQuOObWgR
	u6CRa4DlwqjZKdx2V/BIvhKcLcyw9v4=
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
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/2] smb/server: fix refcount leak in parse_durable_handle_context()
Date: Mon, 29 Dec 2025 10:13:29 +0800
Message-ID: <20251229021330.1026506-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

When the command is a replay operation and -ENOEXEC is returned,
the refcount of ksmbd_file must be released.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 469b70757dba..6a966c696f7d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2809,6 +2809,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 					    SMB2_CLIENT_GUID_SIZE)) {
 					if (!(req->hdr.Flags & SMB2_FLAGS_REPLAY_OPERATION)) {
 						err = -ENOEXEC;
+						ksmbd_put_durable_fd(dh_info->fp);
 						goto out;
 					}
 
-- 
2.43.0

