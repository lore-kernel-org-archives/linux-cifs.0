Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4BC28BA92
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 11:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754480721; cv=none; b=p8Eqzf6L7GLWFsjdZl1z6h9Pjd4Y0fq27zsuaZovtTZJ5nadL/ABMKUUSCYxSCN4LBXCea/urtQUcUW85n2iATfaSB+Z8Jo50N53Rb3oiYwHzgYX1A8YO0e9hK/joY4wJvE6MRAhaqga9mfxVNoumMFAXuuFb9elphbdoTS/kG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754480721; c=relaxed/simple;
	bh=F5eRXrtsxffdegpuQ0f4xPChPgfV/JPNT5j2y0VgMrc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RAX2ELpwKnl7djAGiGi9oPmvvweHFOnmssFRRyNLtapDoevXgArJ6CvDWViYBBQhfK6P6Hybd6fMM6rvdYBO9uBiRPqhQzT3woQX5ux25Bpq51UM7IUClBZp92adhYqlvuFdVqiInVVW+qDiomMPhy7vpEsHSqFz6sdCTg+FRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mUsa2BFn; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mUsa2BFn"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b78b2c6ecfso3814003f8f.0
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 04:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754480717; x=1755085517; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzJczgeb2E2EatXdWgiOPTAxDTD2f2zBu8DeU1yQO2Q=;
        b=mUsa2BFnbNPGG+KtAsxrAg4KKJUIQlbfDjU1ZVbwgHYBeSj445hqorARUFAaC6vuWd
         f5k3SYTBxoBT6VMgKWJTOJixcf3TORX5ogXM978FTjlVRILTHjbuy8nDUxdKGoInt7CB
         Swm+G4uiqyxJEx4OZggG1W14sq5DL9ciR5tpclVBY2vC1DEFrmrXZVLq6njvs8DhOwQg
         zGM/RzPs8UT0SYu1q5K6pg52Jna+wF5hrWAicHiAeX1Bqwe3RI+lYyWSPlV+/430nkuF
         w2UOtRNPvXYFMO1p5bGgWW12TEGO6kEk9wXqT+WHUkvkhAK92H5f4HpxLF8VsP1wQb8d
         xzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754480717; x=1755085517;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gzJczgeb2E2EatXdWgiOPTAxDTD2f2zBu8DeU1yQO2Q=;
        b=Z9R3NbH5kkkxtrQX6kyxvsD57auXYfrF6x7E1+2bdPe0FYWHs6grnD7B3G+kdypaxN
         OgpTfuoMsmhFBadLhlG8sKS2DGaS2I83sh4P6fT6+V73zcMCEUQJINYrjc+NnL0dWMKS
         ZbOsebSbjOoInY0D3JfirRHxY37P3ZRvA/RrOfAt9FkPwox525KkmGFwYCr7hyHR5kJV
         fghALa93gACLrF8kDZ2cnOOefsLdew2mxjJQOIMnKVodXF+Kyew56t+l0hhthhKhfY0f
         m5FX24EADwRjKjmq9zH8W5Hk+iVTa0CN+PCHd/iQEYLVVzoUU9B6K1BRD5xHc/w2MN5o
         YEww==
X-Forwarded-Encrypted: i=1; AJvYcCU7BQzqcZYJE3kY+ab7xU9Y3LAszIG6UqShzDG9Q9J39FKABHvwCqnUn/sHuiGKNtCGqFHO+d8IZe1p@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6DOwMTt8R2G8KF6H8od2QladCFOeo8+FNlnSgwifQp+8BxLe7
	zQuPBmIvEXln11KsvtKI+j5LYm/ce49uduRv1trVe/fWPhsL5TPmTn3j9rB1X11HJhs=
X-Gm-Gg: ASbGncuH3a5OeZmj+LsICXnpsC42JG1502RWu6sNUoNrOnrESbtkZ3nl2tdcBga7/GL
	zOdlMEgIfYCROeVoIwlnNmkWN/vUcX61iPggOCPDCOmYWBPQiXXUY+DYgcxJDuq8RPJQ1mcwME1
	wh3p8lF1Apj42IH7Z26N7LLBY6+sKzMAWeoUzfaCMsQ6Vj6KkuIlKieKdZFVtEHqVtnwgUPlZTw
	okUfsOEoDCzDk3CDWP39e0pSub5qVBBZ3R2cveNLvGrMwm56LsSg/Kp9KE9Ea5GvE9Pz5Vx55Ej
	5n6Pyof5QCOYOhm2xehfemnFN0Jf/AoQXxrl00R0ykSJEqYVBtZWlF9mgNWbrEzqMpQloO28/7B
	R8NhZErqCVqG2n/C6MWW/rQu8E+U=
X-Google-Smtp-Source: AGHT+IErH+bIbW86Py9obhBfpJ7Ic4nUmflEhhhvraU68gExR0HV14Ll3Dg9SWn5Dg7piKiH/oo48g==
X-Received: by 2002:a05:6000:2dca:b0:3b7:973b:39bc with SMTP id ffacd0b85a97d-3b8f41bea48mr2156278f8f.54.1754480716705;
        Wed, 06 Aug 2025 04:45:16 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459c58ed07fsm142317845e9.22.2025.08.06.04.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 04:45:16 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:45:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] smb: client: Fix use after free in send_done()
Message-ID: <aJNASZzOWtg8aljM@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The mempool_free() function frees "request".  Don't free the request
until after smbd_disconnect_rdma_connection() to avoid a use after free
bug.

Fixes: 5e65668c75c0 ("smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/smb/client/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 58321e483a1a..162f8d1c548a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -286,8 +286,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
 		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
 			wc->status, wc->opcode);
-		mempool_free(request, request->info->request_mempool);
 		smbd_disconnect_rdma_connection(request->info);
+		mempool_free(request, request->info->request_mempool);
 		return;
 	}
 
-- 
2.47.2

