Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF54A60B85
	for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqoNtZzc"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6d2350636d6so842319b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 09:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702660624; x=1703265424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GRU7I/eeZw1LGutUSgW9yoZO4ClDgANacK7Uia9/ZEg=;
        b=WqoNtZzclJVrxaAHb7DNGrSyWFgjUv9U4lnfWT26ytAP4ILGrgeggS8DBjDH3Ep4us
         HJxiitFrZl9DlEomh48eJlfTe/9pmN33zfGPwJjFcyheFtCRf+qb/UtQZI5GpKE9KhiG
         mXvVpqtlwPSX6x+FlDkD7+iEwszGNIA4tJmotXu1AaEa/9TG3fY7nQLbZJs8KmMTPMjX
         D17vuQcF/fLTzep18LrwKVOUHdGWEZhp7DzqSzBYHkycK8aO/VrDFoqWaeuY4E3C795I
         I2IptmvSXVm15bXyAzc2rWrGzGHKgXeeUItBt2Bl2E2lbz/orj/rjWgxM4Lz731KO2ol
         5zPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702660624; x=1703265424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GRU7I/eeZw1LGutUSgW9yoZO4ClDgANacK7Uia9/ZEg=;
        b=iNLG1qAvF24+Cb0/J8SPKw03VXuPBHr1VkCJSTM2mZlI5xjKNLZ5014a2GG5amjetf
         KmzSYxW2dF9E0CHZA6uD8RxFJeQ+BNSRJsTMkTYN/3WPgz83hiC+9QXS18SLs5w8jkFF
         c64AqaCZYhAHLF3/YWmw2ihceGT7jMgE7+enxT0L0kaL0mjKsJbnwGB7wMKe8zukaz/a
         kH6W1lxZSX8yQZ4UiGN7woR/hWE8sEdRNC59ZQqA2zrHrjTFqvq5vPTdSf21JmqLCCQo
         85X0cbB+WVaf1RPOh1o2+/C+0mVoO97wwYPjdDFZifxQaZQdHSOm3t0As3SaYcCSQ+Pu
         Tz0w==
X-Gm-Message-State: AOJu0YwpiR/K6XOSe9aDfQfzIkd+GLCjBT8ORKcmYKXvHf8hOf5uG956
	a5zJexe0OGSIacj4G86rqb+AsvbZxrgJrQ==
X-Google-Smtp-Source: AGHT+IHyFVE7b8+XpY13jH/XZn9uaI4Cv5n4WFY24fokJmafVGRscG7cUtbOs2zcay1bHxAc8nNWuw==
X-Received: by 2002:a05:6a20:85a7:b0:191:309:1646 with SMTP id s39-20020a056a2085a700b0019103091646mr7603792pzd.20.1702660623908;
        Fri, 15 Dec 2023 09:17:03 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id g13-20020aa79dcd000000b006d26eed29a8sm2125970pfq.95.2023.12.15.09.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 09:17:03 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: pc@manguebit.com,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/2] cifs: fix a pending undercount of srv_count
Date: Fri, 15 Dec 2023 17:16:55 +0000
Message-Id: <20231215171656.4140-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

The following commit reverted the changes to ref count
the server struct while scheduling a reconnect work:
823342524868 Revert "cifs: reconnect work should have reference on server struct"

However, a following change also introduced scheduling
of reconnect work, and assumed ref counting. This change
reverts that instance as well.

Fixes: 705fc522fe9d ("cifs: handle when server starts supporting multichannel")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 20634fc6d4f0..d2437aca6a76 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -411,8 +411,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
-		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-			cifs_put_tcp_session(server, false);
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
-- 
2.34.1

