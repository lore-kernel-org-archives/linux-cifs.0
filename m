Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE52D26A
	for <linux-cifs@vger.kernel.org>; Thu,  2 May 2024 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714652079; cv=none; b=NCjaohdk2LsJAzf1MuBpV5weNE0gyi5CB1Jxdzjlw3Bj3pGAyy/M/Xh71EMR0TdHSwN/HseWdk4ZV52abMXAaiqyzfmoL1Ks//X1AjR3VH3WPyBMwTiv/ot1TXQCm0KwnI2wYkte6zduuniRIztep1e3b73B8QOXXa/HRd/sHT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714652079; c=relaxed/simple;
	bh=y+rEG/lgWqLgenAFfn+iBAJG2EHN4eJLVnw/B0Q1zXI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=BjM6T1MXnGlp0jp31arG2MNGILJ1EbdMAu3mJ4Blu4+O+WPM3Sfulm7kB+B5Hv0OhZtPcRfJ39oheMAaopkJfGp/7yiTO3c3jMQOPfGZtADoqlHfLV/4R3go5Mv59x7Ds28AdBZ+2ARp0tr/5sw3iMqDBGjdNtp703afhD+qJl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ed112c64beso7181473b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 May 2024 05:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714652077; x=1715256877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1MuseCl29xUlMaZE4OBahR+A51bMJtT1eLW9w8ZMuLc=;
        b=E0Mb5v6odz5Cpah8Zz6gZsoCzVb59vIjdthX/VPyjTwhOezXT48YMFXJBw0gUw/ksi
         p5OS2NhEhTdCp/UKIupbtJ9X0iy/pYobe3WY5dO26PLrfCUDvHqHqX+gVxtOigGcZ5SQ
         038PVw9lvzm8pdbWVAvzMZWyv8AwzjSRRlb+jHglSDINGlh+Bo2LoM2Kw1BHdg13ns95
         FfcGIKNcZcwuOGxJd5uZy2B7wED1/OYoonIcu5mZ2cKFc58P/RVv583aNBDtL0os9jJ1
         d6vEy/kWXa2DBkEbIhn0trZOdYu61OB+mjps4QbYmTZ7edFRl3l90ccQRY1D4Ej9a3ed
         ubow==
X-Gm-Message-State: AOJu0YzeZJ5CRYM2yn+42zsaR7TfcFWTHDofgTId164FhV2OgpvAeKKP
	bPVbvkljY7b7c+yRvG7sUFRY5Ex8RFYkv9Y86WOOkZiZlxMA8G0sRAsaIw==
X-Google-Smtp-Source: AGHT+IGasgYVcms0dE1gclCTxydNyd+4MQcce+0aRA5RXdiiZlIBJQK7NP66tNqokSrmAuKXDlSoWw==
X-Received: by 2002:a05:6a00:b4e:b0:6f0:c828:87ef with SMTP id p14-20020a056a000b4e00b006f0c82887efmr6192429pfo.3.1714652077249;
        Thu, 02 May 2024 05:14:37 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id gx8-20020a056a001e0800b006edec30bbc2sm1069840pfb.49.2024.05.02.05.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 05:14:37 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	=?UTF-8?q?=CE=95=CE=9B=CE=95=CE=9D=CE=97=20=CE=A4=CE=96=CE=91=CE=92=CE=95=CE=9B=CE=9B=CE=91?= <helentzavellas@yahoo.gr>
Subject: [PATCH 1/4] ksmbd: off ipv6only for both ipv4/ipv6 binding
Date: Thu,  2 May 2024 21:14:22 +0900
Message-Id: <20240502121425.5123-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ΕΛΕΝΗ reported that ksmbd binds to the IPV6 wildcard (::) by default for
ipv4 and ipv6 binding. So IPV4 connections are successful only when
the Linux system parameter bindv6only is set to 0 [default value].
If this parameter is set to 1, then the ipv6 wildcard only represents
any IPV6 address. Samba creates different sockets for ipv4 and ipv6
by default. This patch off sk_ipv6only to support IPV4/IPV6 connections
without creating two sockets.

Reported-by: ΕΛΕΝΗ ΤΖΑΒΕΛΛΑ <helentzavellas@yahoo.gr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 002a3f0dc7c5..6633fa78e9b9 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -448,6 +448,10 @@ static int create_socket(struct interface *iface)
 		sin6.sin6_family = PF_INET6;
 		sin6.sin6_addr = in6addr_any;
 		sin6.sin6_port = htons(server_conf.tcp_port);
+
+		lock_sock(ksmbd_socket->sk);
+		ksmbd_socket->sk->sk_ipv6only = false;
+		release_sock(ksmbd_socket->sk);
 	}
 
 	ksmbd_tcp_nodelay(ksmbd_socket);
-- 
2.25.1

