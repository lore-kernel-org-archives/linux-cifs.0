Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681E33EAED
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 20:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814896; cv=none; b=qIZbdWFdFcUo16C8/28UMDt7A8TTNIf4ZzKE9lxqenUSC1IEBnzHwdMSOVknElXCAGLSepgepEBYn1bo358J+uJl4GM4bzdmiVn8rCd3bYs80lzUgltmW56X8Sbqls2auobPqqC+jW0l1A2svAfORz8Ul39W/l2Vu16bjUBQPzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814896; c=relaxed/simple;
	bh=lp0Us1M4kfUY89WpS6zIQZNR1h351XJEk3N/5b1jBJE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E+wS4CDK1RoSpPUBhs27lXwbuQ1NuPDIcNS6UlNfp3NVMXlCwlTT2BpSbpda/JnA0GNER/wAtoau+rWD54HXREaONC0v3j83yGb1+zXCNqEW1M7zI55DcvCjtrhxUB3O2WxvflqWJ5vxDTetUgWvQBqkuYLuWGbDpq9h631zojI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bQrbijP1; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bQrbijP1"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so14296115e9.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781814894; x=1782419694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1XkStSBlBvo2GC/9K4djgXIKKOBITsjSwew1t+Sc2AE=;
        b=bQrbijP1AfC4w7jZ6GTEUXFI0bsgSWhgAbqt6vIQZQn2Mug92/iq/iC64bY9IYKAN/
         ut/WbQiqaK4Y8gcI2ykYGKrcukNM9TtRSK9BGSe6mfpyD9ve2TqPr+ux/Txnqm2mMiQj
         7YzP0mI3dk5bHyjiIjueefIJ5Tw5aM1e/d0zxEIBOv5VsAyUwfPmC+G55Z3JUISTFWl+
         GRmo5781kGIDSDNPbIYWL8evumC+8ItvNjtUwt9YsXN4I5e2ekzLXCqNSxmUQkHL7kKu
         2kyPOmlQghkyAJdy3lID/j1AjxXCf2wv5dYFilQeIaDrdZNIAcFY+mmFdtgKKT2FHFMA
         w6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781814894; x=1782419694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XkStSBlBvo2GC/9K4djgXIKKOBITsjSwew1t+Sc2AE=;
        b=AeBjXknxgeDoOa/1GNacsfYwgb4wODfP5N+tz7AHL69lXKgLH69uRAD8lcHRMmSS+8
         wYzITdQ7LR+esu3sSzXRrXTrifCKxedefusw+yUbDnmh981A0IS0Fb1jAFG3c71tHKKB
         TltikZoZSmXHX78nVJFfZWrHc4iUMdpQxzf9+ExHrFo2sHIFXsHFeJ7oURNnUoPLMHoq
         yRg8GbHRiOLI/jUEf/EXW+IMTuo7n9W/nl/0yCUFne5x+Sl2ZXtMKPjIBX+78csh3K5D
         vbheBZgR7raiV56aYekYcv+edYvEOIPIEoySiTQD4qW0b+vpS9coglt/lgn8t4kdBXDl
         /XZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8sNUOmcTKKKbGvdPFSFAAIsR/pZLEeHIlVEUNKA7ywW7FHlF5O+g1Ac54GPvUGIecNV+3kQIs8QKVI@vger.kernel.org
X-Gm-Message-State: AOJu0YxEg4JkQcfRV/Yj3JsgVaBC0DL1TAfX7APrGIMGK/ceEWeFvRYX
	mSR2aDdgGM8GwwhnsvcxzdG5iRT2EWyWCpe9EbM+enpfNERC+pT9nSCaRo1O2c8MMqU=
X-Gm-Gg: AfdE7cn0o7/wGj00r1Wdd/b3x1gQ3oKlkZwf4UUNl8hiI+gVJOEimiG1el1iVnlNDKS
	NLfFeZaTDj+PCqkJC95GRrHToYRWRKTyO8iVTJ2iy/hG0YVrWnJ2n7OrFUVzgdfaziXXCKi5XKW
	TOuUrhOOCDxV3fZyJdMgM4uiMaYvRGlaPAbRSMYqoLpll3mrnTonpjSZfYHpleYhJ/HJ2YuRVT4
	H1Zj+ZkKjQuwVsqWUkd0RLIN+PaegW8PK85I2M/T4O+qDzcUXx6piNLAHzm53hygzOSRgfDECd9
	tqYBbmZKNYZqXJ5vJYQk6ipQb6v9ZivrslFHNC4mcjXTF1PpR6vS+QluNuBLYv9OLqRSFBzJkL9
	t2GzrfN0Aayw0vSg1vIjcX2OJZDlzetDqjbJUuDZCOkQ9i3pT6mXHKr4/BXiP1TkAFoD3uEWmHY
	U4IoXG+pdrDJiGYRII2Uhp
X-Received: by 2002:a05:600c:4743:b0:492:3fa1:40e2 with SMTP id 5b1f17b1804b1-4923fa14123mr20898795e9.7.1781814893484;
        Thu, 18 Jun 2026 13:34:53 -0700 (PDT)
Received: from precision ([2804:7f0:6401:b508:d1d9:f1f3:d91c:79af])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-966fc32849fsm439109241.5.2026.06.18.13.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 13:34:52 -0700 (PDT)
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
Subject: [PATCH 1/6] smb: client: fix double-free in SMB2_open() replay
Date: Thu, 18 Jun 2026 17:34:33 -0300
Message-ID: <20260618203438.667881-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_open_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 318559cd00db..4d6a989748f9 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3305,6 +3305,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 	oparms->replay = !!(retries);
-- 
2.54.0

