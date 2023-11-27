Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xsb56h6y"
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8AE11B
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:41 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6cbb71c3020so3247874b3a.1
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701060760; x=1701665560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JwdK+jEr6Ipps30SEjJjB1pVi3bO7y85nSCuPw4Un9I=;
        b=Xsb56h6y73n4oz39e6GbLsqTnEISbsrFEv/Js/tWr72F+PqsK6D+kGtc9B6eSY4n3B
         lpgMaFFSz4MC8DUy77Kt4NLGhiB6RM4TImHjFD2MxGgav/esbhCjJPClC7FttqvD43MH
         7YGU87oJvONSrnIAV/ddGEys1vaqAjqLdhjJY2rVu/XYzQDtkFkvsKUKmKTNeNQ5OD63
         J/sNENFZgS2XughiVhTGlbhFWyeWyDfjUafqdR/e5U2GuYKBH51pIsXbEjyMh9W+86CL
         XWQ36FxEjDV+3PvbV9Zj5iwgNwdkjd49FYBCVmDQhlirMs4RDrXTzPmU0z9eA1yYalRV
         UcDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701060760; x=1701665560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JwdK+jEr6Ipps30SEjJjB1pVi3bO7y85nSCuPw4Un9I=;
        b=wBPlT5uNNeTBUgRA0+AhxQnnBm54PfWZnetsVAZboKdxVsLatvwwb4NRv95fwLLTfW
         Bpl8uLEN7drL64324Z4+c6RvTX66nAItfs3+Yc5aiMvP92sLsFsKkMhpNvKWHT1Z7Av0
         L9zvOA8gmEZ5PfOJcAmQbPlCLgux9hzY3Jqf4RrE0W56NPF8k0VXn/U4dQWRiELiTcQr
         3eQckhWITexuqbh/ZKuN+uYG+BfOcb+b2ZOpTJ69G+McP+KPEP9v0glUD2F8Bo6BB1wa
         gL0LlqwbzpU4l4W+XHvmyYZpRM8QOzt3Ty922EWK7+DQtPhBxCLpbaD+UbQC6EuSMKq4
         XjeA==
X-Gm-Message-State: AOJu0YyWBlsuPnQcxW1xe+6VitmFDOd6IWLX0WlaKxLm81cSNo64VpaQ
	u4kmJGXxrgLzZP1iT5juoz3rxh4Yg5M=
X-Google-Smtp-Source: AGHT+IHXSVfYqjHa145rUwYgwEbzYbedA3gsAWhwi3hbGnOq3FfqZFmRA4J4RbISDuLrWqo9Idj59g==
X-Received: by 2002:a05:6a20:6a20:b0:18a:d791:6629 with SMTP id p32-20020a056a206a2000b0018ad7916629mr13013222pzk.11.1701060760448;
        Sun, 26 Nov 2023 20:52:40 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id fd5-20020a056a002e8500b006cbd24d8d0dsm6308203pfb.85.2023.11.26.20.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 20:52:40 -0800 (PST)
Date: Sun, 26 Nov 2023 20:52:38 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pierre.mariani@gmail.com
Subject: [PATCH 3/4] smb: client: Protect tcon->status with tc_lock spin lock
Message-ID: <8ba54b531064f48c90bdac82dfc43efedaaaed71.1701060106.git.pierre.mariani@gmail.com>
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>

Protect the update of tcon->status with tc_lock spin lock as per documentation
from cifsglob.h.
Fixes Coverity 1560722 Data race condition.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
---
 fs/smb/client/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 0512835f399c..a381c4cdb8c4 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2710,7 +2710,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
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

