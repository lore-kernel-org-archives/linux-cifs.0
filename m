Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5951443E31
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512111; cv=none; b=AgqQs6EMe3V/ZZvxZn/ddDKL4zBGLHMgqKGRR+BoUlGlDMVxYwN04uvElFf/S+zxZ4JbjLsGPZqykoAMZf1xh4KOKxewdkf9KEpttd58CkEDQ4hW6Dm5zJXxrdkkoFRPuWVQFVXateXxtB3w+/Bg5CHb9iRAM6UeLGRLrbrE8gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512111; c=relaxed/simple;
	bh=52nLRTTzZW53P+KhFXoiebuaaIZj5U5rrocnkEh0ovg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cwbx5X1h22FtwBqCl5xGs/34fo4mSa5YmVupOZ4CRZD2yD59L7fVLvxOYxuNezWx2qOnvSKlEUmO2C7udIy9yM3FNN0DhM9SOE2GdDMDwVZLr8cCSjrYhZjnBk2tGuh/SzmJGW71WoVtJtKAJNKT7FwLAGrvlJJ+8Yyi8oqSw5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DExVsOpH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=keAqPoJw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DExVsOpH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="keAqPoJw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785512108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDt42OCPMiF5ACU9K3Vyp5738A0ZbescXylCCtt+Clc=;
	b=DExVsOpHHeCQHI65u7Gxk2S+I8PnAjfSu1n/wjzF6EEASCoGXgBoChzupGn4QJkp1xsmjn
	jbxFNxexmtSC8VhC+gVvNxxu762xkhNqPSeHSSZsZmyp8kLR4BC1GDR9nt71IDR1s1ZIWx
	yGFqVwZyE7BRmXGFTvugqLuttkyAg78=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-OMbtHOVrMUq8NBggrq51mA-1; Fri, 31 Jul 2026 11:35:07 -0400
X-MC-Unique: OMbtHOVrMUq8NBggrq51mA-1
X-Mimecast-MFC-AGG-ID: OMbtHOVrMUq8NBggrq51mA_1785512107
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49d4cb3ca23so1432436b6e.3
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 08:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785512107; x=1786116907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lDt42OCPMiF5ACU9K3Vyp5738A0ZbescXylCCtt+Clc=;
        b=keAqPoJwocTdfb0TI0TXgQEIZEp6Fc5L9n36I1pSdkG/4F3kEADDVPrwXUXFdXF3/V
         YCSfrHNO9WfGwWfMuRiCoYsvGKap+3wLqifdmUEHCIH9tJ8pv+iDUxAjeDIf5vMkTj/1
         jOmf/LAyo38Nju1zpcJVZY/Ctke6hZTUD3OTOOahVgXc1SxjDo16sSs/Hz6laARdnlK0
         1qAVvE8xGc4DG2qnJxKDWbXKgJVWtpSGM4t/Jgx2WOuJs6UK/s8gh9L9DClzrSFj3y3m
         T5uLsNrWoV/QfopNOWlgViWMdAagEgmhjk1Dhozc1J5CpAy2xdJ9sKMe9+MngK/jjXak
         +HvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512107; x=1786116907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lDt42OCPMiF5ACU9K3Vyp5738A0ZbescXylCCtt+Clc=;
        b=Q7LjlMjol32KFavPbae6jFIPeAaIBTlAiXibPR3SemzwqkIF/xMjuD9opJLmwLviLh
         GDWGaoV6uLvp+QIDWrSG9CDDQX1eIhyPKfWG2mp38kiM1Z2YbR24sNsFLTZsHvmIDBhr
         45S+95ghQJ8pPIwq4rJkcMqTYAW3g3+p6C5Z5WrO70rg4cnf9oWj83tHPw6z6Bsuhm11
         bNP+K1Cr2oBNBg1ORGbFQmmTH2DWhj7xVOhtgDAQcJ+pUE9AaArPuByzTtgOGlmVhTOM
         8TwXMAMcbE+jb5P8iIfM45YJohnXWMxOQzqfHeX+d3nYuwv5FygqpxoZ8Q1WHzX+Zii2
         Y8CQ==
X-Gm-Message-State: AOJu0YwIqlo+7C22TLIT4LDqEF3GuMAg73tbzxFKXYqU9yVItsQquYSf
	cGnDg07lYwXnfKNK3rh8beXruryeplfUUHZ8TISAPkHke2cF/H8bRsIblmBmKuwuXOODV91uSox
	rXdJerWhqiSXsxSrRXZFtnHR+QWeRzhoNPir3wzQRILnSm0LLCx5auY+GYQAaR4suf7lOagcTt8
	lqF+sDQP+KYwH+19T1nFXOXCijJkVA939ZYICATeI0PdFNVo4snA==
X-Gm-Gg: AR+sD13P3Ke/KJS08HiZ85GuV2tso+xbr1zp315FBhwGu8CtrMgylSUXATzXo4yX6xi
	moZKM4fGwvPjej2Iukdo4perjpEPTolhrNbWYkpm6cBo4hopqxyvcobD1fn+8Xxr2NoPWykQkPU
	FTZstyhh9tXQbChfqpxNJbpF6ikBW3+ncJBfcNDh82p69V7Z0c6WmTvmuo2et49wzHKAtMOsLhG
	/JmnchHP+3nfPnAvaI7axUv0LegwGCn4yeZAe2OLfM9H1fxS3cscoZwdBFYADOdN30+XnKamiog
	r/HzgNhC8Iq8VsHitImNHZ2+Bg2fk6uAJlzTQYiXJe/6Lu27LZGuxC7Lb9EBpF0xX4WYhiUEjnb
	5v4Raw5uS/GfNNQPbywWcSEf1sPjgNBLsbHgIV6lU7gCBMMU4dyqCvlARLs/r
X-Received: by 2002:a05:6808:6c82:b0:496:11f1:f2ad with SMTP id 5614622812f47-4af5e037ee2mr651200b6e.6.1785512106718;
        Fri, 31 Jul 2026 08:35:06 -0700 (PDT)
X-Received: by 2002:a05:6808:6c82:b0:496:11f1:f2ad with SMTP id 5614622812f47-4af5e037ee2mr651136b6e.6.1785512106226;
        Fri, 31 Jul 2026 08:35:06 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4af58ce144esm855813b6e.1.2026.07.31.08.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:35:04 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Cc: stable@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 1/4] cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
Date: Fri, 31 Jul 2026 10:34:57 -0500
Message-ID: <20260731153500.660569-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731153500.660569-1-sorenson@redhat.com>
References: <20260731153500.660569-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_do_truncate() is invoked from cifs_open() without i_rwsem, so it
cannot use cifs_resize_file_locked() to perform a proper fscache cookie
resize.  Instead, add cifs_invalidate_cache() after cifs_setsize().

cifs_invalidate_cache() calls fscache_invalidate(), which works without
holding i_rwsem: it unconditionally increments inval_counter and sets
FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data is not
served once the cookie is later activated by fscache_use_cookie().
Truncation to zero leaves no valid cached data, making invalidation the
correct semantic here.

Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index ac89c1ba56b1..389083f9ce00 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1016,6 +1016,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 		if (!rc) {
 			netfs_resize_file(&cinode->netfs, 0, true);
 			cifs_setsize(inode, 0);
+			cifs_invalidate_cache(inode, 0);
 		}
 	}
 	if (cfile)
-- 
2.55.0

