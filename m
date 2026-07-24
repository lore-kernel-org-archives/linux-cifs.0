Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46F928504F
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 01:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784857125; cv=none; b=VhWETRczSNaVD39nePKECP0HmjOgdUJVCB+9ndNGsxMBzmd1PiAPWO8VLmeD29JiljI3h0e/Nszezemn67VGvAcSeOOmOaJPq67Dza3JmIhAq9W9loMgDBxuOoGIpUDnGccgHKcZXsFBbI1kNRyZbobcUTDTzs34Ffo1VnHEiTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784857125; c=relaxed/simple;
	bh=jNYQHIUkbqByED6v3tgKaKTS3GoX2TeoMX93HZeSf80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pn8Whs9o4F6/YbiqIuJaclRhz/+SoLCaT+FeEEvznB2CHs+RkQy4ZzCiukiOsLSWWbFSwdzGPKKVCH58DIflA0Ilv4g/FaU8KgZs9cFknk+WbRNk2E3H0nj8O9Dl91HDD6enIZEL9gyH9Ytzdq74IoDVCOX5/7nbgUhBS/yabYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nue/XSCp; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nue/XSCp"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so1174131a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 18:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784857124; x=1785461924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QnFMxdSo3llZpZ5BFe9yETSRjO+wdEOw2lS33Rp4FlY=;
        b=nue/XSCpJ9zGsDfV3aC+JSVR06gd1jIx3YwhFk7NuYLGP3zGGUAY180G2A6fmd5Jah
         rGHEyteqxlo2H9/cVzAZwbFWmesV30wACnmIr65KXVMarVHoSdXmQwMOpiDWrN9IJwb3
         R015/R1iDnTPOAmldHzZhNW/Y5ER4FA1xf1XrXPQqbdV3IvthtuGoay92pQM2T+GPNpe
         QK3TC+9EuG+IPGUO2vo4rBIfclOGMVLfr1jvjappfNurtvoRSLN34LcWX4rEB83o3AIn
         0ddBcDNpc1Pyfq14JeXvQr9xhNYT0Svo747wofZ69Q3i47BzsilOCrcJwh83NbsvRIDB
         tSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784857124; x=1785461924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QnFMxdSo3llZpZ5BFe9yETSRjO+wdEOw2lS33Rp4FlY=;
        b=fq29wR5GjjWNl/WhWm+RLwt78kNKQYTsUp/nR8Wi6WyA78wFaeA2H5DfsGIuCwo2BX
         0rB5sxe7jnEnkrS3Tk26SZYjfF05+i0O5tqWZNrdFJghZ2KmpwboCl8AGodfjPMPpd/D
         kIXm+n2gkth7bXzX9lEzxXk136zR1e83X8fyTLIyNwTPGsEMOxcCB3vHMQisRJUEXHZm
         T8ZVxo5IogQeSV5qBURKxHKCLnMV7AoUlGiUaeok96FilYM1rU9iqLnYzuU21+/jI7uQ
         YSiGYEKsgJG/zeFJ3xAygv76EbkC9E0FAZRCO1abAp2fqKWI+agp+0xnt4S0805tU4Ba
         MTDQ==
X-Gm-Message-State: AOJu0YygJ89++SP2x6bGNmtWlZuQ2TUptR17IIH7wpjdlmgXNOlgs872
	KuGTl4JvrR0SB9XyD0GaJhHPcqAPP4ToQOUUNWYqgI6OHfqRSohv1LZXKb8GhQ==
X-Gm-Gg: AR+sD12ZJsiIDRfrFXSktdEohIRjlcP0kNCNIi4rSBkDGfOmQb4E4oVJ1yn86/5EcVs
	jo2DFdCEJUHsny3W1u7M/V0Dtq0AZS9fpmNZQt+Yhv3iM7Eq0N8ezguXHCFkP01eg4uLRxYEeAh
	gIF5vTHgS08xfehrStHeRCjpPF4SJMKXpxJQ7jRqNsr/2kGcsOYnqMql1p5TXbwQKWovQXpQ8gb
	0WzJonjS3rzhafo1BtfILQJwS3aYNbtlzCxF3iyScB+61oF0SGSdppy8oSFQAg8mkI1HRPcDRg+
	17LTuWmoNqGTH3N5qrjtrrOlOTtc54ioFaI7P7r3w5Gky6aXw8yDy5sZOxF2TFb6YpoAPPWBpRU
	11+PXgvvZk5eJ1GiZuKBYmEuF08OEv2T4+ehVrk0bJ0p5ERawSt0DFeCbtmFmD0k6BTuLo+KGo/
	1LcfHDGhSe7ypdyF6QBoU9gLpAdO1kKFvftkgb5EuwDyD+saSaDNH8jOPmLjBXlRSMqnsJWYUqL
	6AVwPr2eSYpChjZag8PELUsscwNyRUZkhHZhOyxnbiK6SM38djLh8Xi6TDHtvXshw==
X-Received: by 2002:a17:90b:1802:b0:36a:c4b:76cf with SMTP id 98e67ed59e1d1-38ec6a515admr5347860a91.23.1784857123875;
        Thu, 23 Jul 2026 18:38:43 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f056472f0sm256163a91.0.2026.07.23.18.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 18:38:43 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ksmbd: remove extra byte from ipc_msg_alloc() size calculations
Date: Thu, 23 Jul 2026 18:38:41 -0700
Message-ID: <20260724013841.1345481-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three ipc_msg_alloc() calls in transport_ipc.c allocate
sizeof(struct) + payload_len + 1, but the extra byte is
unnecessary. The payload data is binary and copied with
memcpy() to the exact size; no null terminator is needed.

This was present in the original commit that introduced the
file, where the structs already used [0] zero-length arrays,
so the +1 was never correct.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Assisted-by: Opencode:Big-Pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 fs/smb/server/transport_ipc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 0c581b9624d3..41611c013d81 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -658,7 +658,7 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len)
 		return NULL;
 
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
-			blob_len + 1);
+			blob_len);
 	if (!msg)
 		return NULL;
 
@@ -839,7 +839,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
 		return NULL;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
+	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz);
 	if (!msg)
 		return NULL;
 
@@ -898,7 +898,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
 		return NULL;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
+	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz);
 	if (!msg)
 		return NULL;
 
-- 
2.55.0

