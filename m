Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F8C27A465
	for <linux-cifs@vger.kernel.org>; Wed,  4 Feb 2026 23:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770246605; cv=none; b=ZtTsXwZNcWQcUfX9JK1sjHOpjQLgilEqNpMscdyFz5hAR3zDi0jWXbFxf85jqhhb5Y0hD9LVyQKbwP8tvnBqRaxoHHaRWuyDuFP6XV1VajusM5Fiq4VJvXGj7JdJ1PjolZjhhuZ039093X18s59xgClnYOE/vuKkJsKM5bas/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770246605; c=relaxed/simple;
	bh=rImYixcrJnvPaJygPB3tSLn52Cqp/Pv1UYq8g825bEw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EzKxgdOCJcnQnlMBxO3AlMOEidEMkO03rfWpja6drBF0DWQxfL5ClkvbMa8i3w5DnpnzIGE0XGMTQbvAdAjXNWSOrs07aIB+KWMLJAP9WTcqyqLM/sGaUYJ4FuzpwZUpB46EBGThkFxuZR0uYsUXVenlK5pTc7Qpyrp4lt1dc6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dc2+0DcA; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dc2+0DcA"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so2912205e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Feb 2026 15:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770246603; x=1770851403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bFp8KGfgyMquCSctoZKejUeMlDxZtbunAgT7dT1mhuE=;
        b=dc2+0DcAGmBZSacQOH0OCansGVkSj65K31YU3rdTjoroMkdLkClQ6h0pvoXiTjhEDZ
         QpTQqsyW4jEZcmwCQ8j20vmrp/jJJngCwoUCC/NS3xhxKRxbvjwi8uhNkIZj5p3RFDlY
         eM22sqnUprgg1/aukr+XYmqe6ai2/grDzmXhMSMqPNxXog5Ro9pQPXK/lNjS5uOm4R+D
         mA7HkN6CQaCb41UVrRRhNAuArpfqGy8Ao+vUdfkHsYxE0OTKJTXl521bG9wT/V4kzhtT
         s61BRgA/TBYVHTanypBrOee6s9/KoJ0aAAqF0OFmMfxn/USrZ/kjdtw1TsMlFeZ2gxSF
         p9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770246603; x=1770851403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFp8KGfgyMquCSctoZKejUeMlDxZtbunAgT7dT1mhuE=;
        b=NZW2FImR0ARk1Pu3RXk6SIiF6YSKrK9eJwcL/zG1UXhqyMYAcn3IoIxKHtEWgjmAIl
         hfMIqky05IVzPDcXnbGBnQLOcmH57b+2wHiu3HyOsWy5iIVf2XGb0Tk8WraLN1AlNM7N
         p1m5LzcxcuyLmc34v5JvSv+zqHesrQgy5FpKPFfcCs1v5sEqZn4d4GpImQ+61a8caGiF
         g6tAIZ6JtlE+4NlvvfrOHiJeE9OqTFH1cTvKm/NlUWRTRNA8zGyl1jROHahs/WCPSQ4+
         b4udPOghuV+Uz2dMdobfDbTkpr1hcPXwhZzVm5Ubzh7a0moI8t3eo2R4Xw7il217MwG0
         oxoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXVjbyXFJcINMLutUKmikGeGx+DapjCGBMWJ85eJ16A406y6AxtunjR5dXqGgEI2609gt02jepJP+Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yxylb/XNWIt95wSfrQ06Rm6q3X9nYuk7EBq/mCTfq05+LQQ7jDh
	yJtHJx9+kx7zoKPm86g8hxEqA0KAUPX22M/OXnQ2Hsv/HOJiJkqa/sU5VLuZdgdXSTg=
X-Gm-Gg: AZuq6aJlB2n/ZqTVNOEhiCp0g7YE8O5TFbpAdOw8KYgcvgtBMXs3/Mxdadx6xwfE2Qi
	k9+07OJikj78d9B3YcwFoOhL3PJEI2OsUO9McsWIJic5xJR3ieEEXdJVperTbUsRtPDTjmmsOGp
	TAxIv1PbD4PqViuvt4yH+vHRq+7M0Wp6hNTP58UbCsW2t4RRi+RHtMj0HFDYlvYbY3jqlJ5Uksb
	bcWUjixoG5JwluYlQ70pX2rldOaHZvQFLvturHE+Qoh4ruui2h7ct5YxWAkun2mtoHtXDaabWCu
	uhbHIZavUhYcFzohONG8SBeljwWaA3gsS+8etiS8WscVhip7q4w55she5tTshZmD+fCCBgSKr6d
	RYpZj0BxCeqAU03gwQwUiqXDmdklhewLQBywj9RqNKOWNumMsGOhFjh2o27XNDGHpvPRRmBg5Fp
	1+TbI1fIWxv1eDz6ITxUPo2cBROKIucQ==
X-Received: by 2002:a05:600c:8b8a:b0:47d:6140:3284 with SMTP id 5b1f17b1804b1-4830e99572dmr57949495e9.37.1770246602933;
        Wed, 04 Feb 2026 15:10:02 -0800 (PST)
Received: from precision ([2804:7f0:6401:4338:fe12:6a4e:72af:4ca4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fa9f5c6sm285008685a.23.2026.02.04.15.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 15:10:01 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
Date: Wed,  4 Feb 2026 20:06:43 -0300
Message-ID: <20260204230643.387345-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On kthread_run() failure in ksmbd_tcp_new_connection(), the transport is
freed via free_transport(), which does not decrement active_num_conn,
leaking this counter.

Replace free_transport() with ksmbd_tcp_disconnect().

Fixes: 0d0d4680db22e ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/server/transport_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 4bb07937d7efe..2436dabada957 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -40,6 +40,7 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
 
 static void tcp_stop_kthread(struct task_struct *kthread);
 static struct interface *alloc_iface(char *ifname);
+static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
 #define KSMBD_TRANS(t)	(&(t)->transport)
 #define TCP_TRANS(t)	((struct tcp_transport *)container_of(t, \
@@ -202,7 +203,7 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 	if (IS_ERR(handler)) {
 		pr_err("cannot start conn thread\n");
 		rc = PTR_ERR(handler);
-		free_transport(t);
+		ksmbd_tcp_disconnect(KSMBD_TRANS(t));
 	}
 	return rc;
 }
-- 
2.52.0

