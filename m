Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3502FB965
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 20:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814910; cv=none; b=N0cbA18N83KZv4dck5wHdtkRyvujgtY3dTmeOcjvxR8mfcRvh7/kMgvNVdEDzqkauERnWum996sM8lW05DmPwcitWuJ6SV6kCF+Fsm6II+qh1xEXVDBd07Inp7lagiiFHCgen97o6jS9LOXZ1irJUNZy4csmN6hOB5Lpvj1PfjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814910; c=relaxed/simple;
	bh=l5SWmHOPEp/fKKXA0NMhkVfZhOFqhqmyUo8J5uUnm1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXDWDhFnU8kuEUODUyIDDVB3kBjXPZIttmpEmN0g2c1E6YSyNtxhaiPahKdO3nl01nKvPcVMM2TNT42K/TmQRP7UItCP+yEStjhsPDfU4A4BH3ds2hGlh8JhPyRUY5h6lhwxodvpqwXTzofhtfoNTuVFfVDuFLMGz9a87aWlXf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eBuaVw4b; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eBuaVw4b"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b7866869so12958125e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781814907; x=1782419707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gI48IBVTEyFqc2Ik1E773JFNV7tYr6QkOjv/gDbHgc=;
        b=eBuaVw4bUn2TW4V0CC8IGUYKOzNnrfM4j2iFV3CdC/zLSyJVLJvxYgDFcnvRW21M0z
         3rawYabr/FgDllEkTrc21IFAuD9woa5qBhJ4aPOLO62Wxo0xFm+Wn2caMcLxINVbC+eI
         RorbRQ/2QFb+mYTtZuDEInyse7ijz1oBqi/LY3V4efSk7bywB5K+AVi9i2DE0t72RqU8
         C7O2E/tSfIRcGZdqAR9wjyMQBiJUpz6VXhlpMUrZFoXNHu00rvZ13haGtKwQWVAKhAi3
         fPfij/I1TOTZJa1yb5HO+nQA+rr1mvzkEuC2cY8VM27a+PI5XURoKDSaxsdJFzUUYa2I
         26xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781814907; x=1782419707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6gI48IBVTEyFqc2Ik1E773JFNV7tYr6QkOjv/gDbHgc=;
        b=F/C5JI3zoK9xiM5D8hUHon0S0QJSNKfifYZS9P95g4pAVSXfLaPpbe15MuWZnZvOiJ
         aIzZbLSQo9EVybRX/e3Rfd6lEDUvjzWppMoDf8RoDB7bYzEwy2FUsoSUseQHqTUq+7UM
         yfhRGyTeNG60TTTh1LVJEZjjIWHiKB0g4XmlRy2mVtLTZNbR7HzU4vJmgYh00EITi0iX
         TCw6g8rolyRowsIOpHNCB9b2ubVRMBhbrGwQE4Ml/allCFnaOYgoe+7TAsJM6N6BZtD4
         ZB/b9vJEum70T2t2sTeu951r42csvrSLWIqeKCpYpeuNoIvMZOAELuB+yDGecDsETYCx
         ey3g==
X-Forwarded-Encrypted: i=1; AFNElJ9BYUYamUEmRDG8uuELKqy9SaWVwVf7gKoghl27ommcRSJqUd7ujj+raknzuL4F3+l5h/1wCqb6f01N@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1sOjiXHTGFguLjnW7ZCu3lb1U1qmOgh19dHG9EJSxh6iMhrrs
	Pw26LQP+/cTQA06eMGhs3uPE00Z38I/U0iCeNqJ0dqc3RnIvzlVTVQFRgWA6CyI/oW5xzvqk1ZJ
	9KeNHyjs=
X-Gm-Gg: AfdE7cmGt2MYFcxPV7zLTIOuev/sNpa3ZGy5+/zE6LNhnTmaH6zeMTLtIS00L8gued1
	vEbpCGTeaZBeO9QzGrO8pp0UPEE7PPLk75H0cZmv3+EFkkIrX+cf/OSsgB7ntdAmYZQJkAopwoh
	PALQ1obD3lfuq06LjO6KOPjoYd9oS9b4PC2IXWVet8gtLD4a1CeZDvqRmZ4aB/N+iflvYtMMqeq
	dd/xqq7JSwqhFAoWL5Hlz+Az9FoYDssf2sPRd6jAskRQho3gBwZ5YwCdevLe3W346UQVaGTOBhV
	lVtjAFTvKPW5O7WKGsgiV34y6qP438t7NjcTuJICeyWADmdH67QgyfcmGeVEJLSdo0u//gDaoc3
	fWzYAcqEd9YsgUATQUJzUTQG3xr0MhgqRt8C1ByPv2NqrOmn0nYuHunbNciLx0oBpiS6gF72Bn9
	Xrt5MKuKPC+7h9YJ9U+3IfV05Do9NReKk=
X-Received: by 2002:a05:600c:34c9:b0:492:2f2e:e7e7 with SMTP id 5b1f17b1804b1-4923f5a3152mr19500245e9.17.1781814907016;
        Thu, 18 Jun 2026 13:35:07 -0700 (PDT)
Received: from precision ([2804:7f0:6401:b508:d1d9:f1f3:d91c:79af])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-966fc32849fsm439109241.5.2026.06.18.13.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 13:35:06 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 3/6] smb: client: fix double-free in SMB2_close() replay
Date: Thu, 18 Jun 2026 17:34:35 -0300
Message-ID: <20260618203438.667881-3-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618203438.667881-1-henrique.carvalho@suse.com>
References: <20260618203438.667881-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_close_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 121ae914c3cf..a7b1fbe28a2d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3728,6 +3728,8 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	query_attrs = false;
 	server = cifs_pick_channel(ses);
-- 
2.54.0

