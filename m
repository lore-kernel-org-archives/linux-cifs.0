Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1945D21ABBD
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 10:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742207279; cv=none; b=unRV84Ck08zJUErbyjDYrZvW2913sE6FAgIuCG3/86qxAbGTemv/xU5PEMJ3h6x3Zz36ezPUaa3komVy4TzLSGFdq9UnqSxgnEJ8w0VkUaRE3apq+2lLh7c1AeEVrGZ+IKwYMSUglUOFr5nzi/PLh20ma2R54YTaT5hw7IJQGao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742207279; c=relaxed/simple;
	bh=joC0FfI9R/zsaj2hUG7YGS6cm0VTcOFbBDbIVtP4Js8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JaRlW939tfvpXrsak+unr/0tEuqUkqp3djnW21sZsSTwm4oEZzy8D7FmMNeUX1yQdlB+ZOafvSX3YPpG/Ny9pfNTrzOWn9NsaJuLIB3xyOk9C2ihmbSlQLfLUEAvSsIoW0s4gA4d08vkgaX0RGX+sgItgxmYxEpEGWMeoPoybK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wmxq2naq; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wmxq2naq"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3014cb646ecso2060152a91.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 03:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742207277; x=1742812077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LvZLK1SD9HMrEMDfOJB8gpe5ENAtsg0cbaNhdl8V7fc=;
        b=Wmxq2naqoWmpWKek9i4t2UB6LPBFGX196MMaZA2qhfa8s9acp1ND3j0lK6V1s6ot9x
         l7c+JGgceh0fMPj2c3Y3a+3d74sJHIzfmgkQyWMW9hbR6X18yxZTbmaOaH1zFbgCWOTB
         FwWfFxxWV+Zgs1ynBx/VD9ZCYY6re3wdmuUGiZYJzhPhFPWwbWrsTwj5b3G4eFOV38Hv
         Q3jTStlVcq24iXd1VYP0Krus8PysSFcRSuzsvIRPMTFO9ICVHJKY53yYbs59XV3t4X5Y
         /WWzGkJHPWOeH4MDL/YJ2jpDaouTxibyVNmgn1o4h52qVE/YXPz1GwUOna+zPK/1xYRP
         /CJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742207277; x=1742812077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LvZLK1SD9HMrEMDfOJB8gpe5ENAtsg0cbaNhdl8V7fc=;
        b=Q3CrQMembcPQd0UMMvqynTVrw7JOPDovcSK2445Xe6VuMsErqjfSu6nfx3xEa2FnfV
         8RlFVpIT1qZgE+yPI+WgbP2k4js4UxYBUEsAYsQwlvJJySpMPXahzGldXVkRjLlt1trv
         vS/pm7fGawownQiPR4cvLpG6GfbgbJ7Sa2AEUXfH4FgynD/s0hHDqqv8A5oSalOmt+FB
         TZx1NXEG/2aPn/36DbyyhFuTI3ZjfsowrNp6w+u2cSWz4U1HfHWTp6gPfOezFZkyfWYY
         TLMQceWdKbeOEAmtjGNHjxW4nVherRpI1PK3cUqvJSmk2M5yzMzkFBLWj2PDJby6ylcR
         n7FQ==
X-Gm-Message-State: AOJu0YyzOdPw+8FJATZLPPuM8IaoNjXLpQ/RQLGYlFGRNSA6fMU7CR/F
	vfRhAhZtSAu3h2CVn+oT9OmNdDNh5VdQWJJTczxATKRLndbnD49oUYFrcfoM
X-Gm-Gg: ASbGncuZ8J8kSsNj4eYw0RDoKnhcAR9VgfVRo7vN2nn7yD7BOZ5gMD9mTepslDNzy3W
	2vIujPX7/Sbs/aM/OFEAifIT0EMTLOO3cXTP+qu/ejqr4LDaU0w0B4f0u/RjPdLPx2Z2P6mw+vd
	rO4+kBP9AtwQ9ZngtqFGhlggtwOl7FPrYG+Ivcz//8togG9w6PLFo3zyJHsCch3jCu3ditCG/+O
	RdkuH1AN9DcgO+lNuEqIr81ZouxyJRayBFLXHbvjGlGYMLIsATOKy2KC2a2giP0prVjP8x2Ia5X
	w6orm5qy/zeopsaWOr8J/1EInlJMGiaraRTIuJM1e0vq7Ven+m0Ocm/dFRzDihIYv2yR8A==
X-Google-Smtp-Source: AGHT+IFNMpNep8CylO6nSTPrUBdLJZgVg1ao0/qupUL3Ri0yMrvb2nsaO7Itxbk0jokBRWnH+xoD6Q==
X-Received: by 2002:a17:90a:fc43:b0:2ff:5357:1c7e with SMTP id 98e67ed59e1d1-30151d049ffmr14809235a91.20.1742207277084;
        Mon, 17 Mar 2025 03:27:57 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.189])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-301539ed069sm5738238a91.17.2025.03.17.03.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:27:56 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 1/3] smb: minor cleanup to remove unused function declaration
Date: Mon, 17 Mar 2025 15:57:25 +0530
Message-ID: <20250317102727.176918-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

remove cifs_writev_complete declaration from header file

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifsproto.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 81680001944d..39322b4931da 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -592,7 +592,6 @@ int cifs_async_readv(struct cifs_io_subrequest *rdata);
 int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 
 void cifs_async_writev(struct cifs_io_subrequest *wdata);
-void cifs_writev_complete(struct work_struct *work);
 int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
 			  const unsigned char *path, char *pbuf,
-- 
2.43.0

