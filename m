Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDA41B86F8
	for <linux-cifs@vger.kernel.org>; Thu, 29 Aug 2024 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724959362; cv=none; b=bzFTm1CrmJ1H9BIqgD6mikJ25HYB5Di/0ZeoAzSyu94ND2SVaD20x4/wse1JpVzWIHOa9l3+f1ZDHq2LXJAW3MqxFizrvZnPhZ3FzJgc/80hU2eIXmB7dNUKTXIzVy4kNC6RbocQSzreDTvpsxguNHH0YPIT2rcizHxcESGbfKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724959362; c=relaxed/simple;
	bh=qm19Gvoz82XJIblwayPtkbMrwDBs9ju0c2xYk5h7T9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LW2UEFmMU3T/pbNhec0GJVsnUikMBN9WWCbMRJ59Q/ZkeNcfMIKJBMUOkWG+qQrl9DanbQxcZjuuqMbrQ4SLeqMPuCGARExW/EbuAbSWntP8CRfl1D654igd1AQ19hURT3s+CzFhvxEFh9hWWfa9SsF1VUOMOXb7g3VYLMB2Fh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JsKlCMUy; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JsKlCMUy"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42bb8cf8a5bso5439625e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 29 Aug 2024 12:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724959359; x=1725564159; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7hIZjb11n3DqyAA9+P4eJZLp72biRJ3AAbi9kWILsZ0=;
        b=JsKlCMUyICUC04SoUZs2LyYmTJ7lryHd95jPzMWyQXhaCeWQlVwBDVaPuCNMoixJZU
         71Ka2Gs9JqMwCTL1T+DhhBFEo5UZAyUNZ8vQAVDwpl7thB6PHlz3gYo1cMW9u6yTq0dQ
         VngGxCHTmVP2aDr6eM//PLJ2TkIplXhHDv4DFJSrddAWQ8G7Zu7Ej2JzL15+mqAZCl4B
         GlA8xf0vIaQ3A0IqPQUtTw5S+qbEqcXHRN8xvgAmFzL67eUhJHdE7kMuooq7aHSrqsXS
         Vwn8vwaZ9vIKHfwifhQhKSLd0sRsohDnuj10aXka6WZACyahQrQtnHs+K/WvKE8MU/1R
         sWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724959359; x=1725564159;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7hIZjb11n3DqyAA9+P4eJZLp72biRJ3AAbi9kWILsZ0=;
        b=mI9MN/LVJcGDtTej9Gwr6BLHu5AZz3a8wJx72ntCM77dliTvIp9dFvnvHhkbcMICB1
         D4p1v6TRrLY2b5M9FfEaGMSggzaB+AQG1p5YC/MMiyzIUHBkBdkvKqYTCwouGeCodRUt
         +rrQF6aJIX3cCPsky/H4JVRnnQfGg+1dyKwOrFzVAYF0hsow3v7WuutRq9dR4d4N6BXU
         CZGzAXi+Z7qemlgpf1xVqVTPm6jx3QSIYNb8jP2VYLD6957csi1j9+dL/u9QNCj/jyMx
         AdX6yQug1hcCcPW7g8E7gitZdBaowQLSBD8n0pVmj6bsaU3NTEK1eiyVwT6zmhcpHyK+
         Zlqg==
X-Forwarded-Encrypted: i=1; AJvYcCXv9GHSrT2c7+Zqf6zgYUHINNNlVyYvNtfC7UTq+nRWoCr2tk9hxPwwekfr3hxI24eX85nwBqpBilcf@vger.kernel.org
X-Gm-Message-State: AOJu0YwoPWibghcx4ccwc3NrExSpYpFfRix6Y2nKbm8hABNA/oeBveis
	9owTr9WzKJYf9a2flMKRevy9sXRtsGirNvfnk9rQBxL0NYZnoGlAD2zfI8oILgiX+u8Rwsl9MCS
	6D9xqmw==
X-Google-Smtp-Source: AGHT+IGTymteNaS4QWlAktRpMUvs68NdpmgcKtVmjCHiVHP/sCFsHOFzLywZcr2xcxkbNPQRnu+rOg==
X-Received: by 2002:a05:600c:3596:b0:426:629f:154e with SMTP id 5b1f17b1804b1-42bb02d970dmr25349155e9.30.1724959359098;
        Thu, 29 Aug 2024 12:22:39 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ba642593asm59424265e9.39.2024.08.29.12.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 12:22:38 -0700 (PDT)
Date: Thu, 29 Aug 2024 22:22:35 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: Unlock on in ksmbd_tcp_set_interfaces()
Message-ID: <89c440a9-27bd-45d9-9d5b-5b4bf51ec950@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Unlock before returning an error code if this allocation fails.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/smb/server/transport_tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index a84788396daa..aaed9e293b2e 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -624,8 +624,10 @@ int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
 		for_each_netdev(&init_net, netdev) {
 			if (netif_is_bridge_port(netdev))
 				continue;
-			if (!alloc_iface(kstrdup(netdev->name, GFP_KERNEL)))
+			if (!alloc_iface(kstrdup(netdev->name, GFP_KERNEL))) {
+				rtnl_unlock();
 				return -ENOMEM;
+			}
 		}
 		rtnl_unlock();
 		bind_additional_ifaces = 1;
-- 
2.45.2

