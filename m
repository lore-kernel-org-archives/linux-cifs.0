Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ue1eSjyK"
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9013131
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:23:02 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cfabcbda7bso13440325ad.0
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701062582; x=1701667382; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ycItwyA4HopmqsPeMJYuMNkQzOdw+WpGPjI9Ym4hH4=;
        b=Ue1eSjyKEfzquAcNHh6+ex9iJpuCbSCfmMsd2/dQpwqSkW7AOzONUMncea8b2tyG9K
         RFIhWTIE5xsHQKFN7VsUmPnrtBedEXMT+xlER6LdvPEdIQTSNHtO/UBwgb5llGTTi9+e
         tnJh89oXc7hoLaPrXKH8imPy85HNOovQbb88mX8rvS2r8X2jQ3Mh/XcZjDRNEKw0CMjA
         XYoHGYMF8gl3cypT3vwkGKH0iYX6B1cYA0OIf+BrtUcQ/gjr1VNJ49MWctvj3YUUZshq
         xNo5T4aZCOvDZnwK765jjCbrVCHxl2mHMUNbXtduZY0L2XB+/0OVTpNeA7wAwZcEcYKu
         Qoew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701062582; x=1701667382;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ycItwyA4HopmqsPeMJYuMNkQzOdw+WpGPjI9Ym4hH4=;
        b=KVQMrRPa258Td/zCKOFFSMkSJzTyt/Ixdo1R4gXLhTYBdv88uGg/F+EBII5z4UFyKH
         cA2HJ3z0bqI6uUHnZG1twqmTbuvnOZPSeqhkmSHr3+wovpyR5pfOM6lDuJIO0SyFck7v
         Z1MoKbwHnAb+hjrSeHYiZmN/NE/By8i80KuvXsa3TcpdUKepkTI2Z5V2FDxBDc+CkQ6m
         B9uzefKmiAG+uMZJFdfmk2zMjwgGa96UuA9rOKh8sHCGXqswgu0Weecvu4t6bV6Xctik
         f+PmYDxsP63Ak7G3DQY32f7jRfdLpJ/2W3TmzJOmwB8GUbbcpAs8Nao0i6bWvgQndXdQ
         zFgQ==
X-Gm-Message-State: AOJu0YxcFPBsVvubmjYW+mRsTHuArOKcyoq01tFWfcZo4OAebLXJ3WWv
	obHVqMNeC+11DFXfYOBkuZ1bbK9PnH4=
X-Google-Smtp-Source: AGHT+IGWQOSDHtl1mT3Mo3AlS0pMpK3UFTBw3UIuRZGnkm0E467OshiBxB1Typmixa9tIscZire9lA==
X-Received: by 2002:a17:902:f681:b0:1cf:a652:471f with SMTP id l1-20020a170902f68100b001cfa652471fmr14972195plg.26.1701062581734;
        Sun, 26 Nov 2023 21:23:01 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903244800b001cfc3f73920sm1968404pls.227.2023.11.26.21.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 21:23:01 -0800 (PST)
Date: Sun, 26 Nov 2023 21:21:38 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pierre.mariani@gmail.com
Subject: [PATCH v2 1/3] smb: client: Protect ses->chans update with chan_lock
 spin lock
Message-ID: <3c4154d3192607277bc3a7453f05cbae8a7bba5b.1701062286.git.pierre.mariani@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Protect the update of ses->chans with chan_lock spin lock as per documentation
from cifsglob.h.
Fixes Coverity 1561738.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
---
 fs/smb/client/connect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f896f60c924b..f7d436daaa80 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2056,6 +2056,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* close any extra channels */
+	spin_lock(&ses->chan_lock);
 	for (i = 1; i < ses->chan_count; i++) {
 		if (ses->chans[i].iface) {
 			kref_put(&ses->chans[i].iface->refcount, release_iface);
@@ -2064,11 +2065,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 		cifs_put_tcp_session(ses->chans[i].server, 0);
 		ses->chans[i].server = NULL;
 	}
+	spin_unlock(&ses->chan_lock);
 
 	/* we now account for primary channel in iface->refcount */
 	if (ses->chans[0].iface) {
 		kref_put(&ses->chans[0].iface->refcount, release_iface);
+		spin_lock(&ses->chan_lock);
 		ses->chans[0].server = NULL;
+		spin_unlock(&ses->chan_lock);
 	}
 
 	sesInfoFree(ses);
-- 
2.39.2

