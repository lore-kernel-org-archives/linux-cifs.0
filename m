Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A070C27E060
	for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 09:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755511164; cv=none; b=sRxZBl/iBLRC37r6t7BrdAzMFfW6mPYG7fZ4F8Ea58MKC95PWvqpPrSUK0Ur2VU0Hla4RF6O6W8Imr+Jv9PxYHNHeP4HiCi0KxDnRrxH9dYCUMhznzUtOGV+aNRNYpCZpNCMjYwRB6QSI3I95QtMxROhaApxETMmGrjULLRdxnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755511164; c=relaxed/simple;
	bh=/C9Csrxdh1sYcqWltONMtXTrt08x9QqeTMlZNgDLvCI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m/tgY7nBQYOtITt6xW2nZmguiz6a2P2/SeSf0B27FPZIh+kFXU5QNBL0wjDR0paAjzbOeF0TNdPi7iSg3JcKJFOnYB6BCSrOjpRfcOLu3SZP+N+yEg3AdBpPCUUghc5V+xYXiNlkVpQurVgtISoAP215v+BBa5k25+9je/9rw/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kuEHS/mf; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kuEHS/mf"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9d41c1149so3017438f8f.0
        for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 02:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755511161; x=1756115961; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qZDLlNuYLU9UmeoCuzZO1+X4n+CJQR7oR8AjhafJt6M=;
        b=kuEHS/mfIyAN3GAxIk1mSA1lt4VDPAKXPuOoZDzsOUvJgimm7zdIbPsix6fbyNMtZt
         kEfQvqKia2oFQHzd4rOLd+gwM9DlKm0NrXVLZ3KOXKvTPtEoY/y4bbTvAu1qeU46Vg2H
         mJNChdIixR2De/GddNzrHS+/ktE5suyDaulm96HyhgpdE8i1UjDk2oSIuegAvmDJGAjw
         WtxG0X1O+dTVQHgR/K83bjTwq8dg1tlt2zOgAfcdWybu7HR9lPN/hnq22Hak9hxdQoyH
         54FqEsRRakwPnoS5UYxTR68itfMc4INvkLOD0YYXtk3W+JgVvpeeKCQccmoDppARhaBB
         wcjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755511161; x=1756115961;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qZDLlNuYLU9UmeoCuzZO1+X4n+CJQR7oR8AjhafJt6M=;
        b=lKRjDeGoqZ0DUgr370inePZyR6r/B76503MgJam7hVXiAwfCMj6YKlMhRgXEIww5C6
         UGPY5nzEfyblCNZBX/pe69ufPIRdDBs1D26nALIc42tvFN14QWQ9avMqovNV+VgP9OWz
         kW1HVMdF/dx2ZqcUka7hNGQY4iLseaVvjI2Opj43ZyOKe1Fqk053zjB/hByVTu8AKGTr
         8ziIkHwQ3XTQYHHJpWxSEF/HdbTnd+0JoJ+5zO+wONOtRozLgWrAiSSRT5ikjk5Jbd9g
         XAxLOWgZu3pbD6GAxG8S19yN8jBV1KSdu02xvIkbgJ19jXxpv3ChJo20ZW8VR/5FWzNj
         vkJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPtGfnLHcm+VdkqRGBeNVcDHgj7bMhqqe5p3uOGOuWk+ptCg62FWt8cyCkpBFGGd8FsZgeuqyjHqql@vger.kernel.org
X-Gm-Message-State: AOJu0YzlaAnUBCnnjl2qFHhTYXYc+BJtfEKpmRHrwSpLkLKWgbS/6kYY
	gK8GEwXMb1Rxzxzcayog2FFX3bTvBa0HiWl4Bso4xwqGWgPQHiMA4O7KpQ6Y8zEger0=
X-Gm-Gg: ASbGncunvymBwVLObvcQR02qvGIt3ez3kxvNT3nAgavanVSg9rnwYLjA+C9z/U8Tse5
	dE+pWhRB8HCDSnpLWiWc5akwYQbDRCkH54WHoJ4+W7u28G9gXlzlYoeYVV/9capx66vl2xk46nw
	rT1X5CD/iD7Ez8a23upZwGchxnpCA5B9PxFlTF5icE2z5/vBXtcA7qV9p8gFrM1pGglETcA5ba9
	VQDLp3nHExawE3QO7towDFjPaDFR9A8cf5z2nilLsmagYIoYrEGsW++M1SVz35moMP7uuoENuuL
	gDsLFQ57pD6klGMh5l8gmq5CwpEOauRbmWYo1uPtd8XFzYfqsN3N86SX1ZIQy745JBP4iG0yUV9
	u72qYLTi7L2UremJ1gBN74f8YJAVFgAwqjnAX5aAJ2/V89PMry5TP7w==
X-Google-Smtp-Source: AGHT+IEAVhk6tBtT8QiYf3c/clKbpVmq0dinSHoKmOjMnv18pQ2Ji8dtljdjZJFXIYwlEZU7sho8fA==
X-Received: by 2002:a05:6000:24c2:b0:3b6:936:976c with SMTP id ffacd0b85a97d-3bb66f0f6f2mr7896857f8f.17.1755511160898;
        Mon, 18 Aug 2025 02:59:20 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45a22329b12sm126502615e9.24.2025.08.18.02.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 02:59:20 -0700 (PDT)
Date: Mon, 18 Aug 2025 12:59:17 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] smb: client: Fix NULL vs ERR_PTR() returns in
 cifs_get_tcon_super()
Message-ID: <aKL5dUyf7UWcQNvW@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The cifs_get_tcon_super() function returns NULL on error but the caller
expect it to return error pointers instead.  Change it to return error
pointers.  Otherwise it results in a NULL pointer dereference.

Fixes: 0938b093b1ae ("smb: client: Fix mount deadlock by avoiding super block iteration in DFS reconnect")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/smb/client/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 3b6920a52daa..d73c36862e97 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1116,7 +1116,7 @@ static struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
 	struct cifs_sb_info *cifs_sb;
 
 	if (!tcon)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	spin_lock(&tcon->sb_list_lock);
 	list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
@@ -1141,7 +1141,7 @@ static struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&tcon->sb_list_lock);
 
-	return NULL;
+	return ERR_PTR(-ENOENT);
 }
 
 struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon)
-- 
2.47.2

