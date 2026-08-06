Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE8A42BEB1
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 23:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786059798; cv=none; b=msDZhB0eEzRvUjg/SXS6Pq8yarOyoc4FRsn4KNo0LNobNIkRLdJJQisZPTKl5+BDEOxvbfSUtmS/EVlmRKAsm03mHhljQzswgYrLmDAWKF5mKzF8oZxDza/pOwFTfzn/+78zjVOr6Wmv7zEt7IwCUbdir3kuKOJPxQ/mWWVGWiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786059798; c=relaxed/simple;
	bh=V5iaY52poqbJzhu7Zsven0kiM3cFpSh4ek/1jKKpNcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtjiA0vH7lTxo2bW394cHFr6eaIdD+F+dyIVF9jBfQeLa/ax/4SipX63H6/w/CRnHQaXUIUQK7ZAsKEu5/iZRLBvSXWMtPBm2A4DyNEqBV2m+Rflj72OAQP2dIW2RmF0ci/uGBrMGd1FtNab9I8OCkqIL4ZreIVyQVkAlaVC7kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wt2DPRru; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JqAXfWrI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wt2DPRru";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JqAXfWrI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786059794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mPAnVyLzB8u5cZd4HHGxxAzPmugX7mgogomHsS+ogH8=;
	b=Wt2DPRruIlEd9Nqc8gD0ksEjUHlW6QP+zLRTnrexNbqCpvzAcKZsw0Rl0qTXRE1egEdZ6X
	zQ9e7B+LzP8wCw3tVNCaRAI7BVSFR5CG/23YYmG6duE5UB0OcGbDk2wQVWzrK4w6iYGUoE
	mT19D4JoaBVHHD7BYo5nyES0dhweQAQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-rtEAmCaAM9GOzH3v3HQEhQ-1; Thu, 06 Aug 2026 19:43:13 -0400
X-MC-Unique: rtEAmCaAM9GOzH3v3HQEhQ-1
X-Mimecast-MFC-AGG-ID: rtEAmCaAM9GOzH3v3HQEhQ_1786059793
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92ef13b61bcso360123885a.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 16:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786059793; x=1786664593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mPAnVyLzB8u5cZd4HHGxxAzPmugX7mgogomHsS+ogH8=;
        b=JqAXfWrI65MRAqOBXfy2jZnMvxKi1LMfw8cUIbaPjHV/VO8PGkzcwUfnoB+/A+9w1R
         XR6+nHGf/thnz/DhNsCxAq9FsmB03lmRvW0UNvHyCmEtN+/KazZ7h/s/vQTZtHr+gC6U
         Ag0fQDMihqtmGxmMSB6HsY4ZHKtvxF4rT0EPzhKgelxSLaHcNf5igF7AkYkib8+mNcRp
         RQZeutF0qa9j6UjdNd7Wf7NBuUpHBNlEKO1LRhe5B9aRgW4/PH669DFTVotIAUCQgnq/
         Og2uJLnZbhagPbjVOthbxLgrHbhRsjl3E3p3osWIjvIvT3IRG28wUFSO12oRkaNaej6P
         hSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786059793; x=1786664593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mPAnVyLzB8u5cZd4HHGxxAzPmugX7mgogomHsS+ogH8=;
        b=TFrSfPDvYtfstuzb/+XuL1hVgF2HhOVgEGfuAMzuppXJI6QC77D2naIcetpjnp7Pmk
         3jrc9y6w9XbUfcG/m1VNmUhATvOvyCVN59JKOfRMbm1A8dAjQjri70OogejQppghXDab
         MOB5SW3/Bg9epkqvpDRzYxZax9dvVK1OuAGjkR3xxg3RvWaV0dzXVV8U7yBaJhpq3Xku
         daW7ykTD6zq1uwlfdlTettPtDwYD1AmXx/gazl/qg1xAm5xuXaIuN4k0Bki3GNkcBT4i
         SIY/vkIMw5a/fUhjV08QHHrIbSTA63ZRmDoJy9HDfz/7/xeYcox/+2Pgt1Bg0TwCW9vg
         z4JQ==
X-Gm-Message-State: AOJu0YxAWydYDfebjprsVVf70Ul02hbbVZKTIxNu/Q9MUWijf/UM74uv
	AReILSMsJlZNd+zsSWUOG1nr727BJi2TeY9nJULNxCRtxxTSizuDAQmwT3IudQ27TQMqFfeFiiy
	DwrxxeKqMZQzLqWbmRQsxAc6pOcSORkpw1x44L2qkoQXX3QOQlqUQanRxa50kENuYZj9eI1SDNQ
	pSNvP7pQr9u72VsZHc7KFr+l+rQ88R6eVP251t0ICFrxOiG5M=
X-Gm-Gg: AR+sD11Svm3PXcbWF+JgJHaxcHnmdcNOKDiWdSmulWPns/PfLKxzueVksZ8zKJlrHJ7
	ViMSKgdxT2QnuDeefnKkwrLXN7fynjDJ6hhK0QI1rGNTBrhS6ndlsquD/iezn2y8FCAq3zjGzzN
	obzV+58dWKvIPZmkUp1TXfE0KWsDhDx6ZJOsM2+WYGXaK5mNj9jQNhtud1ezi6JKSZ6mGXVH5sd
	6Ywk4qksObRmfLgK7ujgeXHBf8u3uiDmCRrTxRavEsuljZXwV/B7HGJw+IQPBWjpHmoaOGtRCcy
	0G96o8DJG3heX7/lj3nZC0SSzGqqRDy0e5P+OpFs8q1AbpAh4HNdNaYziGzPGIaxBk1kuN486Dv
	C1bivhHy6J74V2k+YHvz3vF4N+pVMj0+oLT+HBJrpUvlO63nX7z8bk/0YY18Yxu3E8w==
X-Received: by 2002:a05:620a:1b99:b0:930:91e0:8dac with SMTP id af79cd13be357-936491f30b8mr2046196985a.41.1786059792994;
        Thu, 06 Aug 2026 16:43:12 -0700 (PDT)
X-Received: by 2002:a05:620a:1b99:b0:930:91e0:8dac with SMTP id af79cd13be357-936491f30b8mr2046192785a.41.1786059792515;
        Thu, 06 Aug 2026 16:43:12 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e03f05bsm26891485a.2.2026.08.06.16.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 16:43:11 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Cc: stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/3] cifs: don't update i_size in cifs_do_truncate() without a cached handle
Date: Thu,  6 Aug 2026 18:43:05 -0500
Message-ID: <20260806234306.3662175-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806234306.3662175-1-sorenson@redhat.com>
References: <20260806234306.3662175-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When cifs_do_truncate() is called from cifs_open() for an O_TRUNC open
and find_writable_file() returns NULL (no cached writable handle),
cifs_file_flush() returns 0 without sending a server set_file_size
request.  The outer "if (!rc)" block then falls through unconditionally
to cifs_setsize(), setting the local inode size to 0 even though the
server has not yet been told to truncate the file.

If the subsequent network open in cifs_open() fails (e.g.
STATUS_ACCESS_DENIED from cifs_nt_open()), the caller receives an error
but the local inode remains at size 0 while the server file is still at
its original size.

When cfile is NULL, the O_TRUNC flag in the subsequent cifs_open()
request tells the server to truncate; i_size is updated from the open
response.  Move the size update inside the "if (cfile)" arm so that it
only runs when the server has been explicitly told to truncate, and call
cifs_invalidate_cache() in the no-handle case to flush stale pages
before the open is sent.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/file.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 389083f9ce00..acabe2ae237e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,10 +1012,19 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 			server = tcon->ses->server;
 			rc = server->ops->set_file_size(xid, tcon,
 							cfile, 0, false);
-		}
-		if (!rc) {
-			netfs_resize_file(&cinode->netfs, 0, true);
-			cifs_setsize(inode, 0);
+			if (!rc) {
+				netfs_resize_file(&cinode->netfs, 0, true);
+				cifs_setsize(inode, 0);
+				cifs_invalidate_cache(inode, 0);
+			}
+		} else {
+			/*
+			 * No cached handle; the server truncates as part of the
+			 * O_TRUNC open request that follows.  Invalidate stale
+			 * pages now so they are not written back after the
+			 * truncation; i_size is updated from the server's open
+			 * response.
+			 */
 			cifs_invalidate_cache(inode, 0);
 		}
 	}
-- 
2.55.0

