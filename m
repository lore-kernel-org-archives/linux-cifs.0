Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0JMx/C2"
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99CA11B
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-280351c32afso3361924a91.1
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701060725; x=1701665525; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qVUcsPlrwME0u9Qs7h+gqjVo/2eH/y9kicIkm+ey17Y=;
        b=F0JMx/C21F1akWL0cQ8J6eqnPrg9EhDMHxYzGYAd6XlmdCBF7y/8lrBbpHtxr6oY7j
         sV2egi516dmzME32KcBelCJ2WTWQTYGxSL90b5kCRME9M8484/bgAGaskMZFywxzef+x
         eRC8Mt4hLzxqUcA/U8Ctc2qKb3YvgZpmX4ce4J94NWt0bWexvD/4HwhSWkrWW7EMnjPd
         +VkZUBnHaGbZSCZHz43J6eLmW+IEVlpVhbmZ0wg+sy3/EGsZ32A7dU8qyIqEIpnuIegH
         HyOea7QdlWUIQXwQFg9fMC7THdXMk0QS5aX1tiuhuda5fNK5GA2pDVxsz8CMbSVgTxqR
         ncQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701060725; x=1701665525;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qVUcsPlrwME0u9Qs7h+gqjVo/2eH/y9kicIkm+ey17Y=;
        b=ffmxsTsZPLJZLJFn7pnx51i2J9GE9cDP1uyKidNvsOOBCqLaE4Zuaw/4U0GVrph2QY
         GIBO66o5JfAuTZ8aXT4nxiU+XOy/0EEz7Ft5Co4beBOH3tqmkETCnf5woti/nvZwk2PR
         7smS5Ib8eUMwLaRibUANDOSiH1iuPWMH2mm1anH5WTIA/9MQyC4oVhn3UAPzAPQCDACa
         bNi/HkrVyLgvU+6eU6GAtZIo20BDQnfx9Sy+LL9t6jS6SOnBvrm5jdNaGouZAh7PJQG3
         JcYtbJ+3noQo2/Sf1VkNYRZ9x5ZhCke6/XgjiMGgfnFnCmLtDnUtx/wCeU2Oy/KY6GUy
         wXVw==
X-Gm-Message-State: AOJu0Yy6rDGg3lz3G3qlPNOOhuWw1uZyZk8e+POSsvNz3XNQHk8cg0IY
	Aw4ZCpbgcoRcdo0R+tDV+w+pIf27Hb8=
X-Google-Smtp-Source: AGHT+IEanu52AC2HRziGDxBDWT5Eh44EYiFZ+vS3XklucOxhbEpQ6HrI0CVrkocb5rGpvUxraO9NTQ==
X-Received: by 2002:a17:90a:1904:b0:27d:1f9f:a57f with SMTP id 4-20020a17090a190400b0027d1f9fa57fmr13108920pjg.32.1701060724946;
        Sun, 26 Nov 2023 20:52:04 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id t14-20020a17090ad50e00b0028514c397d7sm6464779pju.17.2023.11.26.20.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 20:52:04 -0800 (PST)
Date: Sun, 26 Nov 2023 20:52:03 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pierre.mariani@gmail.com
Subject: [PATCH 1/4] smb: client: Delete unused value
Message-ID: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

rc does not need to be set to any value in this location as it gets set to other
values is all subsequent logical branches before being used.
Fixes Coverity 1562035 Unused value.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
---
 fs/smb/client/connect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f896f60c924b..449d56802692 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1770,7 +1770,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
 		if (tcp_ses->smbd_conn) {
 			cifs_dbg(VFS, "RDMA transport established\n");
-			rc = 0;
 			goto smbd_connected;
 		} else {
 			rc = -ENOENT;
-- 
2.39.2

