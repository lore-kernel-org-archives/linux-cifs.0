Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769FA502BE
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746455248; cv=none; b=RBCioEnFV3KCwYdnnTon+XsYdcuG8sgYmlwTSx7Sxl+klr+aarr3FBjKlETxZ1ze94OmH7UYq11ujwRhhMwZ4ktw8ZsOFtbuAl9iXRxRL6unfWVbTj975H8zY0izWkM5js8HLbQYkkV/eRhZLWHNcqmdXYXzTVtlN44c4ljPnOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746455248; c=relaxed/simple;
	bh=Ly0CvE3a7Ft2cguZwUX08mOhOyHbvdJxbcYNTMDul48=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JerEDi6aIUfPl181dIRy5+h3ajTrSCyPloa+KywGMDd04+MirTofWTOfHfCar8HWk9FLI+uDiX4xEj+ZqVkUI080zI6U0gVgSM6YAxdUyR22JemsyugvNvgNIwtYf3LJeSAY9LXntsJ8Y2vUbUseLfJa4nWnyVNxLZQvt2lDOSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hw9zGMpK; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hw9zGMpK"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso38446125e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 May 2025 07:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746455245; x=1747060045; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oAtVszf1vdrmHz2MZSZ/fpRznhrZHx8AbHdFOY7qIPA=;
        b=hw9zGMpKmVUHTAtRLOzfTBFRB2Mgum2BJuCXuGBnWHTC+aN6ruDP/oTg6iqSUJL0eW
         iErNIwjpqpqYBeIu5SvADdpPFSG6U58CIrLnqVF5h47cfBaWm4bJUtlrEbOMYpWLRBVV
         K17JdBBJ8ZFVs+yjm+4k0sy3jNAERytEnjVYNc6Vq+VZL1uT9F+PP0cDU91fnvFMPW4I
         FStqDEPzemnzZZE7SkYSkl40X+8d5aV/KrU2nAez87aAMRWzi+KUM3kWbanJf8OgbJm7
         GEacw5DSq+YN2I3iZDYASIzKhrHQl+90HN+1xXKbHned67p9NBJeZsofmcwkC9g57HqJ
         LLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746455245; x=1747060045;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAtVszf1vdrmHz2MZSZ/fpRznhrZHx8AbHdFOY7qIPA=;
        b=fu3m2zRpKpwB6hHty0kYokFnhL8hc03toDxu74z8YKD0PodGPNu29CZU7iGIo4mUS+
         UbSsfxRNdQ+N8zA7zWBMVWEND9/VBchpoVI5jUiCftM1qShQxj49oB+xd2QsvXMJpIOs
         ti3kEAgFSwHzj2tGMxVSuEvHfhkjjE4Y7H+/ClO7GJ1oWra9snn2T44NtK7rTxxgMtTU
         gT0mnrmRNUMwje9aEM/sf5SkyZ++XPKi6tWkiEyUT8JreOEuwvb7We4c94VgqQcIAc1A
         leBnCFKu/IEjUBtdlXRiaV4pxYSrfcRtBCfBBtdhOo2rM6DkY/eyTr8RqFL8DNT1G1NM
         lOig==
X-Forwarded-Encrypted: i=1; AJvYcCXtGwrf38IkHf+v37DfKRSIQrtnYlpzSdnyUJdPofRgI2Kj4+sMJYxsnonLOd11TWCYGDsTMKKNYFDG@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2FVuMMuwKgi+cxIBov8cB/TUgLjyZbAEv+VRDFdlPdRVr6X2t
	3LYY7lqKBQVFAw96Fkwi9ohPz1qO/Y+lMY2WuUAdyqAioWKzwGKBX2PkTlew1qA=
X-Gm-Gg: ASbGncvmytCbRh47TAIB431e/87/3kQHEBpHjOa4r2QxmyPTAj9JQlcNcSOgHO6PxOw
	b0xlY58igt1tyKZvchb+F2WooATFDHLeMo+m9E7zJEB4vcVfUuV3JdN5cTsOQEcM0dSxi8Baf00
	9LGN2nbq0DAhOlqzAETQmvYrHBLmTGYwqE+JAzCxeVxdpikiVcWImnxm0qKZxpuIpiUEwpAC+dN
	69QnZ2+LmdqW5tXfFfGcroWsQnWWfmjfCZaMX36SUVMaWJSmga7Nya7lGOb6kdU/ncUmCaGHA2z
	f9T2skI05e2selUHwIfi07GrHPx0f1cThD1FNHNX+cdRAg==
X-Google-Smtp-Source: AGHT+IHdZ4eHWjSeHJWyp03pTCeFtVQb1fWivNtID+bl+XU3/4RJV+jvA1o2S7f/8WrZbEMT8MT8Rw==
X-Received: by 2002:a05:600c:3494:b0:43c:f5fe:5c26 with SMTP id 5b1f17b1804b1-441c48aa314mr72504945e9.4.1746455244822;
        Mon, 05 May 2025 07:27:24 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-441b2aecb60sm180087725e9.11.2025.05.05.07.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 07:27:24 -0700 (PDT)
Date: Mon, 5 May 2025 17:27:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Shyam Prasad N <sprasad@microsoft.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH next] cifs: Fix double unlock bug in open_cached_dir()
Message-ID: <aBjKyIM-OqMBjFNv@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The "goto out;" also does mutex_unlock(&cfid->cfid_mutex) so delete
this duplicate unlock.

Fixes: 62adfb82c199 ("cifs: serialize initialization and cleanup of cfid")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
To be honest I suspect that we're going to have to revert
62adfb82c199 ("cifs: serialize initialization and cleanup of cfid")
instead of fixing it?  So this patch might not be worth applying.

 fs/smb/client/cached_dir.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 9e20e3dc2c03..3f4fe1ecdcaf 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -238,7 +238,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 */
 	npath = path_no_prefix(cifs_sb, path);
 	if (IS_ERR(npath)) {
-		mutex_unlock(&cfid->cfid_mutex);
 		rc = PTR_ERR(npath);
 		goto out;
 	}
-- 
2.47.2

