Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZL9Akmm"
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE7AD6A
	for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 05:44:22 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b2f2b9a176so3793964b6e.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 05:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700574261; x=1701179061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9qmweIpEFI1ma+T218nwjqBra3e+xCXuLJ42KeHWSE0=;
        b=CZL9Akmmbzg1y7Zc+MqwN5ATVVK6H6oDwqQeZEWByFcO2c763JQGAVM/OoiJyluJBI
         +Dsw9pIBoQIpyPnKd2YfeEZ2sGobAVM9Z2cLTtcOTl8aqELhvmRAxv79e/jmDFqpjrFx
         JpHQQmcJn7cPIHv17mNiaamTSxxUmQXKI0s0x5/4c7tAuHi01sMr2P/K8s2fy+skDvom
         f1PGbddWRcpe7RiBtF7jNfaCg5ikxVS1GoKd3mfwS2KAF5PfvjpuIPTH7kQZgyWTTRNc
         LHZXJnCiuz+yiTGSU5bu0N6W8yxp9zPJorUXGFMLSQFD5H6b1iI0/LOGXAid4bhBIJHB
         JNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700574261; x=1701179061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9qmweIpEFI1ma+T218nwjqBra3e+xCXuLJ42KeHWSE0=;
        b=iRtV9iLo0v8BcXIqvsO9yYtJSnjA4lz6p5ek6+GWk4E2/NvnYvEkX7DcQcCnecVHDR
         eDEZrk3TkOBDGBjk2oEeHK2Ud/cPCjk/539z8DtPtV8MwgArjH18GmBxOEvbHWerwC/R
         PbmX/ZczvDf8hi/APecceukMSNY/UpWrTVn5BRmxr26W0zDYFm5YyNqF33PO6i9RZnxY
         bGdNIbUmUzs5prEggARK93RIW2G+e4nIPy218qGBy8b07I13guUQ25y1hhSRuccf5mOZ
         wg5ySqD/VwgVolIVsqfU4Q5K3cept6kbPrRpUJ808m6WPCSqrVUGRB8epOvIvsFTc219
         itxw==
X-Gm-Message-State: AOJu0YxjIpC97dNELbH/61Tn9RmExvZKeLDE9hErVWllqjZHDzPIz91/
	XhV8usSY2Ki1xwfw+RR5X5rHVpP6x8CqoQ==
X-Google-Smtp-Source: AGHT+IG+oAzHMdAcNIdEhIJut+KUqSQeMRWsI5uymK0Y6T9HtjAJH2g20Osn6+1XJ0QZDZfhMTR67Q==
X-Received: by 2002:a05:6808:2207:b0:3b2:ec6d:e17e with SMTP id bd7-20020a056808220700b003b2ec6de17emr14512304oib.9.1700574261516;
        Tue, 21 Nov 2023 05:44:21 -0800 (PST)
Received: from ritvik-VM.. ([131.107.1.158])
        by smtp.googlemail.com with ESMTPSA id x64-20020a638643000000b00528db73ed70sm7880041pgd.3.2023.11.21.05.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 05:44:21 -0800 (PST)
From: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
X-Google-Original-From: Ritvik Budhiraja <rbudhiraja@microsoft.com>
To: smfrench@gmail.com,
	pc@manguebit.com,
	linux-cifs@vger.kernel.org,
	sprasad@mirosoft.com,
	bharathsm.hsk@gmail.com
Cc: Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH] cifs: fix use after free for iface while disabling secondary channels
Date: Tue, 21 Nov 2023 19:13:47 +0530
Message-Id: <20231121134347.3117-1-rbudhiraja@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We were deferencing iface after it has been released. Fix is to
release after all dereference instances have been encountered.

Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311110815.UJaeU3Tt-lkp@intel.com/
---
 fs/smb/client/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 8b2d7c1ca428..816e01c5589b 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -332,10 +332,10 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 
 		if (iface) {
 			spin_lock(&ses->iface_lock);
-			kref_put(&iface->refcount, release_iface);
 			iface->num_channels--;
 			if (iface->weight_fulfilled)
 				iface->weight_fulfilled--;
+			kref_put(&iface->refcount, release_iface);
 			spin_unlock(&ses->iface_lock);
 		}
 
-- 
2.34.1

