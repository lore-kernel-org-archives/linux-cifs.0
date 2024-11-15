Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3285318DF6D
	for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731662044; cv=none; b=ArVwKBFSUKTVB3ZHGitjaG0uEWhvKvUw+vyanNDO3QhX4VfLGyTDHUhLdq4L9gJZ5qQWendiNe+FG2aABQvEbcoBkKD5NOl4J+kYf7BjuZZdzRLhduvFzrpbuoxAl1ODtiyvtEz/X9DT87Lu/qfsLSXcqMHuJPN5Gec7zEREbtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731662044; c=relaxed/simple;
	bh=oL0UzlFZqjOr/6ocBd/mXCjQcqAFgGA2jsO52+VBifQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g9bbbUM3wqWER2pRuGvt7swrzF4V50NWPdiyZbOlZl7wqxC4TtaKh/lSlhJn3xhUycpf1bv9cYs8BeYAgilCVXN/DbrIPyF6ycBoZBvC0oop3pZ+PegoSAEB2iDOy8Q2QV5r8GiqxTQVaPQ8C6DBIfIIVW7tLFR4du7a1zeBYNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TeRfDmx0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TeRfDmx0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4314f38d274so16985005e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 01:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731662042; x=1732266842; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7YuB/szIEkMxlq3tPJ1z9SjBnVW4504PF0OtGMyd9Ts=;
        b=TeRfDmx0sSznIaXIO832QZ3lrjOKmsmr3ZuKVWR6RfILfEReImRvSg153NjPKvpLwg
         IdV/y/y8iPPUjb50MApxbLOeit1/zbKduAGAIappbfVINE7FvemoiPteUN/mfF/BfMJx
         pEDv71PQO9/RNOegrxJdhrTmjcgSurepFk0rr1uscrB1JPhTOujk1ESuAUpS8T+Mwt1I
         +ApDcfd/zwyaOxw//N/SkdEq+Ayl61MtwiBxJAZ1vx1K4br3M3Mup7cAjpGqQlfegirE
         oROduPYLOv3vPOf5wnlSaZGABEQy6HpUDu9cpPqAfiYvBOLSTaL8Av6BC5lRjEsAoafo
         XwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731662042; x=1732266842;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YuB/szIEkMxlq3tPJ1z9SjBnVW4504PF0OtGMyd9Ts=;
        b=g20GsmLaVRZfKzeeRtcyzB/3ij/SKGL4XnM4v2uDby8BXSLivsoAQGV6lk8Cg+HMOM
         N7Yed54btDoL5gFqIi2EZMRqAILdss4zpeyvlEgPgE7h2yQnAJVwo7AEF1FD89lZD4M7
         uapj081/CWJdOYozUtfubM+2RqJXZaogJUzIf7f9tqXhbqv9kbYm4ozApKWTfMxHsgD5
         5kmMR5Tq0bAk6QaRn1kFE/lvMo1dVybd9NqMtPQptEX2G3K+81cdvPdlwy1yD344mhYj
         mqaMAjG/KVaxM9Y/5kI3dg21qyy33Ut/kvq9ZHz7aOH8sHtWfiOZDkAG8s3HZmsVOaob
         TO5w==
X-Forwarded-Encrypted: i=1; AJvYcCUFp7nTL85cMckL/v9rcknprp9jowdTH2N3Y31bXVnzmoj/Jkw2wzjn30JhuwdLwevh86yIzQPaPWbS@vger.kernel.org
X-Gm-Message-State: AOJu0Yydq3Pq5F9ctP/mKu89SHFuJbA3L0XkU25vpRx0nRXfkpi1SmL5
	k+buUIV2bCllbB4LPOfp3/+aApbWu86ybLDz/RrNoHEqK0Bv41SgE0Ehy34/Us2Hta6p0FNdTuN
	C
X-Google-Smtp-Source: AGHT+IG/yzx2BrirfQLi4fTkAmm6tdWmADdgYhJai5mJ+OObY3rJiGs8gvXT6Hvgka4TOkojxVFw+g==
X-Received: by 2002:a05:600c:198b:b0:431:4b88:d407 with SMTP id 5b1f17b1804b1-432df723048mr17674985e9.5.1731662041725;
        Fri, 15 Nov 2024 01:14:01 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0ae04sm46823735e9.33.2024.11.15.01.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 01:14:01 -0800 (PST)
Date: Fri, 15 Nov 2024 12:13:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Shyam Prasad N <sprasad@microsoft.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH next] cifs: unlock on error in smb3_reconfigure()
Message-ID: <e4ea558b-5124-4f3b-83a1-267097d067f4@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Unlock before returning if smb3_sync_session_ctx_passwords() fails.

Fixes: 7e654ab7da03 ("cifs: during remount, make sure passwords are in sync")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/smb/client/fs_context.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index c614c5d8b15e..49123f458d0c 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1008,8 +1008,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 	 * later stage
 	 */
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
 		return rc;
+	}
 
 	/*
 	 * now that allocations for passwords are done, commit them
-- 
2.45.2

