Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39D8274659
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 12:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758802905; cv=none; b=CI9KhIjr5Rw0llM85QrHEQgXbiBYX3Xb9IPeJ4I3TPX5WbCN8h4GhHmq9HKHlsz3E9LEFCpcNF+dsmuTQR/qdreIEmqWy8tQLYunL67wgkhHFvv02SDm3V0cW8bsGRFQXqSc9UkV3bIClKzXAj02nZ8LZtc9zQptsBVuhRMr2fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758802905; c=relaxed/simple;
	bh=KzO1tGLhnmwgC2czsymfEJYe8XJH4fTmuOhq1x6NFWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IPIgLg+fgJBMk/jOlfC1boJcM/g+pK7po1OTszXX42GZMnLbnEanFZAIFA1TRfmiADWvAgZLFRzRsv2FjGh/lh0SfGjD7rn4I17EmmtKpl7sCiAgzRRiT9EXWTE8zqO80BWhiVwadps1rIjo7j2wi4fDRSkcXYPr1QKx4NElKlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-77f207d0891so918764b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 05:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758802903; x=1759407703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x43SjsbcOABMmM2+fBnffN5xjqvn0zaJtauzfd7L1NY=;
        b=qy26TTch/Vpn0wSUO5YW71qHJxQBZ5muPfcu07UIbiVbA7nJjS6LqlY54dGOzzivvK
         t7v69gryMZAPpKTfBj9BCiVtLrWkY+XLwb+6MZlYI9Yd2pCf3NFJJzYp5n5lKdlewIAd
         EDjZ5Q8/FxAq/r1fWNQx4c4dlIO3Az66jM7FwollCGGgy4veNru2XXwtdcKQsiaXLR5l
         hnerFFOMlvmNSZ80Iw+tZgbTN+DNKbxeV6gNEvvCgFsxbZnVBqUgUfkr3oVtqJDp2rmO
         dKW0CzpCKscvikzvh0MqX1zABSNaAmS5SlCEbyQhBsTm82EOzCz8DxbXUpavNGYuGaHX
         ZOYg==
X-Gm-Message-State: AOJu0Yw1wdicRtPlcbs6ZFWp1YGi+xN7TTq3miUaFES5owCbwf8DYMEB
	L42pXlrKkDONfSyenI1ghe3tufzwWw5vrTHW2zh5pXiV3DaJXDReHCzwQC/xQA==
X-Gm-Gg: ASbGnctJuFbXGKg52dqS5tCyGKO58e19BMWE58idUqqYRvG+PeZNmuSbi2XLlyDFmIc
	ra+6aCAyDNy50kYfJuC4iEXmQz5svutHKgDo/la0zSWNtXPt8ShIKbUCkmdcYtsyCW11LylgIhr
	NSrMD+m3ZotENbMA5od6Mjl7SwK8SlQY1ghhv3QS67giU5fsaKi3PjfsfMvNXmkgkSOP1AcdJ/B
	n3WoIMPPQgD4ztp1GOigMH4Z25dz2bZTiRSZ+tmBeNkcMuzFT0keyW98r3L6fKuqJt505Tu86rU
	NWwt05ZkzJrCHleC0eXq8D6xnJmuF8k/f7v14+vOTjwGOEpAgJYh25puTHw6IPYAV6RClb53z3/
	oLNjQu3fD2Tgi3QwIXv3iWd9KHKo5s+hgrCU89A==
X-Google-Smtp-Source: AGHT+IHir9rCnvk8w1AHAbDApWQJXUJ1+TyI8/A56aqdQwUiKj9B15bStHhy/r9xPiD5tV+0rlq/vg==
X-Received: by 2002:a05:6a00:1382:b0:77f:383f:61f4 with SMTP id d2e1a72fcca58-780fce1fa18mr3714286b3a.12.1758802902420;
        Thu, 25 Sep 2025 05:21:42 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810238d309sm1843628b3a.7.2025.09.25.05.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 05:21:41 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: use sock_create_kern interface to create kernel socket
Date: Thu, 25 Sep 2025 21:21:17 +0900
Message-Id: <20250925122118.11082-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925122118.11082-1-linkinjeon@kernel.org>
References: <20250925122118.11082-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

we should use sock_create_kern() if the socket resides in kernel space.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_tcp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index d5db1c5eb2dd..6075f506fe92 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -469,12 +469,13 @@ static int create_socket(struct interface *iface)
 	struct socket *ksmbd_socket;
 	bool ipv4 = false;
 
-	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
+	ret = sock_create_kern(current->nsproxy->net_ns, PF_INET6, SOCK_STREAM,
+			IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
 		if (ret != -EAFNOSUPPORT)
 			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
-		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
-				  &ksmbd_socket);
+		ret = sock_create_kern(current->nsproxy->net_ns, PF_INET,
+				SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
 			goto out_clear;
-- 
2.25.1

