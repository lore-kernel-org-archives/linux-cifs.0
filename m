Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D98D22EEF
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 01:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732324541; cv=none; b=L3cFVlOIjbexTEa8kJY80yYDkSOolP35ohalx9HM05x24v6vXWYhsq1vUJxWEluVfa7v/skby3TllemMW447sqW1+QF3RuZIRklQNFAmQ8nRFehq8Nb7hRiXsNOoEzNbIjGLaFqN7FYMMbigWdBYRY3Xpvr1H+fuRlPostcYnhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732324541; c=relaxed/simple;
	bh=//BJwjnRDoaHJifWg5x7JC3yCdSUWaA6DjlMhEQ4yNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcoHu1UCcDf0tTbUgVZdKldkYwCOFU2xbq5Y6LHFinkC1Mnak/cVTffxbz3xrUQOe9EWzieqxXb6S4uyhwW1Pf9qUhQ0wbY7Jy9TZyZoEejXVTJXNSRYVNKA/2V/4d/E295fr0bzMLB8WxvtCojkzKs7WRWN3SJHi2AIovQ9+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VXfyFGn1; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VXfyFGn1"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-382378f359dso1812999f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 17:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732324537; x=1732929337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEn2rjj3s87nZuDyW8085na2MCPjKtNREiV9c9/HAn8=;
        b=VXfyFGn140+kioy5QBgM0VUzzVcUrmPep+UG0zab6xnFNqdUDeYD+Y0IyHtwDlcLKw
         CpghApTrXoa3fgIw9/00VV5Y15NqPGrNC2jrPdLJv/OZjsShNX9Xap1LMSmuXs0o+Bnj
         rcFptDcAlcc/Ry4tp+/RkfIcxZ4LrBgBwCSgTUWT/fQ1b5YDNx95muPTsXm66tBI9/oj
         Q/CAR7eHLBp83XMT0NNsr2qFnFlYwBUaT/ZUma3La1619WuVkoC/yhLj4VSSCOK0LwCq
         6V+gzhEz6+4QujweuXYnCC61PZGWJFRjBET9cT9yeSP1KqDYWUFlA9YOsEOpEzcvJusR
         ihVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732324537; x=1732929337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEn2rjj3s87nZuDyW8085na2MCPjKtNREiV9c9/HAn8=;
        b=CTu2bWGvxJL90e/qa2AgytzmTpY//R+v/YWen84O3yJxR5jNrNouglqkQdjVEgGFFS
         +HZ+iBdgjqMwFe1iYBcEF9S0kH2arrSbmJwsfLAciltV6plmnAiIDW0fc5GwznoDbRgw
         GCtsYldQ7uCD9byoMMRtQHGrCuoRU2fLIUnSWXN+9gEfjz/S/rTrGXDwj4HeQBblgJXf
         ClFreC632XHMgg9kA9RlBEVzG4q/Y5wbIpfA4UwpLOp0q8ADxzyDa8DvCHUWEdAy7rkh
         6MUJHU9w9Y4Bp5GGlBVLQDiDXh/tscpLcC4mdvaClIycFVTYxxAozEBkW/bASTSCPEv+
         VIBw==
X-Forwarded-Encrypted: i=1; AJvYcCWA58T9ojktJ8P8wDzbV1NaTgKKDS0E66I+kvQGFod3SfDtc7Hel/CG+xnpHHb8TnJ09ZTTDPddCVuR@vger.kernel.org
X-Gm-Message-State: AOJu0YzuJWCFlXNzSe//kKuIF6TwBEGC7qoJvUw8E5Lc8bnwzuplU1p/
	rf99pOZ4rxwqpXFmc6j409XtDroOVoj4W6ALCwSduLUFOnqLypZfk+maoMtegu0=
X-Gm-Gg: ASbGncu6FZPFnneHZgQb5KkkdwGLH9vI+vLEpYJdXeYuVvkewazIX/O7h5THLI7I3+U
	L8d2tSzCJlHWIqnDSsHDNn+vQPdK1pBXMmAIrO93jOcBGKKoRDcxbRkjEf1fRXOf/bvLcyxW5K2
	0CjF0XzbllScW9/Qq6mWhozuLn5TAA6DxDamsRrakEr4HsjX4ZtSypkznLBQ2kNOxncrnoEqZH+
	AGs09ntXGeRZfy5OL7MS+90LJijydS2SMxmUvbUoq2Xv5n03aI1Z2C6m3QmFu0fLOoljQ==
X-Google-Smtp-Source: AGHT+IExRtuU8aZvJasVVGL+kQ/pCYfspDDu1A2VLP7eJ7bdf1cG9KkT82iNYnJ5WzkgW71Mq+8rQw==
X-Received: by 2002:a5d:47a8:0:b0:382:4a84:67c with SMTP id ffacd0b85a97d-38260b8be1bmr3805786f8f.32.1732324537632;
        Fri, 22 Nov 2024 17:15:37 -0800 (PST)
Received: from localhost.localdomain ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eaca70371dsm4043040a91.1.2024.11.22.17.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 17:15:37 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: ematsumiya@suse.de,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 3/3] smb: client: change return value in open_cached_dir_by_dentry() if !cfids
Date: Fri, 22 Nov 2024 22:14:37 -0300
Message-ID: <20241123011437.375637-3-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241123011437.375637-1-henrique.carvalho@suse.com>
References: <20241123011437.375637-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change return value from -ENOENT to -EOPNOTSUPP to maintain consistency
with the return value of open_cached_dir() for the same case. This
change is safe as the only calling function does not differentiate
between these return values.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2: Split patch and addressed review comments

 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 85a8cc04e2c81..d8b1cf1043c35 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -396,7 +396,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 	struct cached_fids *cfids = tcon->cfids;
 
 	if (cfids == NULL)
-		return -ENOENT;
+		return -EOPNOTSUPP;
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
-- 
2.46.0

