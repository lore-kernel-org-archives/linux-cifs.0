Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fb/Wc8iB"
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6BB133
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:23:43 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6c398717726so3003568b3a.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701062622; x=1701667422; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b93OBEvVcmS6QkKGhcyxd7pIYP7K7A8ayVFFUcT/Kd8=;
        b=Fb/Wc8iB0IwL2RQtDkdAnfPAyhgOdhlDoRgF5MT/nG6+w5yGheMIQtLBQUHBGqpej+
         Njty5vdGBsWnyjJBa3drER9TPWDoYTgRxNXd5x1DQfoFIasIuZodl7iUroecxTTvVDxh
         NCcf7Ziv5ZuKCWbdVN1J749ZaWPp8Rqu7A6fc9XVCVDIEuw96c2fUyugIa6LIy1boCig
         H/kCh3oLfxae70fXDCCa6mHgYZY+Xa0+R44FO30bClszV5ImPT6aU0SfAQSCHG6bo6W9
         14JdZGYuQhNA+suEZ0VjzxW15KCx0xjmDAgbfelhS7pFOakVOZ8t28QFxC0sgE0KUW3e
         /Xow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701062622; x=1701667422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b93OBEvVcmS6QkKGhcyxd7pIYP7K7A8ayVFFUcT/Kd8=;
        b=Efgfp9hnMxNiZEYZmmq9dCqZTRpAk8FbGbS+Jr+uTu7csz1Upfsi4TEIbAA3rAPew7
         5QFQpqIeK+EWat19gvBEIqrrluPh6eqdpwtFOfazLIGE6pruHPeSXE6Tr7fC8BScn8zk
         p5D9yNOHlwI5SXSOM1/QIZR59G6jinQ6O+qFjNZ36FntEEp9TdU+4KpyBm7g7FCkcLZ1
         jdwRwlSq/AUvUrY4LAW8WEkGKrMkiuJej0Ts+MJFxeqccMMrPb5Z7F+30Dwc4s1phdtU
         oqR0WniueghcEiK6p5XhQ0BMe+qJDiq70GkWooHCZNFChD1GtBKw62aua6RJzYqZbiI/
         hpkQ==
X-Gm-Message-State: AOJu0Yy9E6RbJIFl5/E7YOBiTLcucabY6C9W9DvHpPz8OkUfPn4LAy7i
	QVa/DHyiX4TJMhetd4cs61AVFfKF1WI=
X-Google-Smtp-Source: AGHT+IENW0Yrng2IQ+IJEPcw92dQsYLJw893Xa8TCB3H01YxxGN98+Un7leKxD4QxD+50eFmg5EK5g==
X-Received: by 2002:a05:6a20:7d90:b0:18c:159b:7f9 with SMTP id v16-20020a056a207d9000b0018c159b07f9mr8523056pzj.9.1701062622223;
        Sun, 26 Nov 2023 21:23:42 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id ob14-20020a17090b390e00b00285a17f9da1sm3199390pjb.43.2023.11.26.21.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 21:23:42 -0800 (PST)
Date: Sun, 26 Nov 2023 21:22:19 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pierre.mariani@gmail.com
Subject: [PATCH v2 2/3] smb: client: Protect tcon->status with tc_lock spin
 lock
Message-ID: <1f2c738ab53d6aa430001b5847feee0f73dd51c4.1701062286.git.pierre.mariani@gmail.com>
References: <3c4154d3192607277bc3a7453f05cbae8a7bba5b.1701062286.git.pierre.mariani@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c4154d3192607277bc3a7453f05cbae8a7bba5b.1701062286.git.pierre.mariani@gmail.com>

Protect the update of tcon->status with tc_lock spin lock as per documentation
from cifsglob.h.
Fixes Coverity 1560722 Data race condition.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
---
 fs/smb/client/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f7d436daaa80..26e3eeda0c4c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2711,7 +2711,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
+	spin_lock(&tcon->tc_lock);
 	tcon->status = TID_GOOD;
+	spin_unlock(&tcon->tc_lock);
 
 	INIT_DELAYED_WORK(&tcon->query_interfaces,
 			  smb2_query_server_interfaces);
-- 
2.39.2

