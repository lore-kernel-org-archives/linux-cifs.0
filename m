Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113D117E0;
	Mon,  6 Jan 2025 03:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736134804; cv=none; b=X7Y8BVn5vDl4AmLdM/S64XdkHtRd3hUvNr0bXt0FiaJD0+I1HQwcqBcA0740FzsrdxZYio55ul2Pi9/tOlnZ2wMjjJfAtVpspmxOtrrvWuAu/Jufx4M6HUz7mC6bqn6b7oPFGjeyO5xbs1fkbGp9zgF3KYQCRtqY+8ECTPHrLhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736134804; c=relaxed/simple;
	bh=SHeQYOpF8NFrbOfG9iN8YdvN08uft9MrIkuuE9S0IMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qyagiu9T/RnQgAqR5M3IJnIy+g0Ihzrje9ZhLWXdVAb/JusfPpq3j0gwTX8aeas3onVx7qXNZC2kUeOEEcoCWQqu6FE7w5KCMPVYuZZgqtaDLKiIi4GQ0uZpGCJHlbI9BheVNkm31v6wRL1ct5jPLz4mNKXmxcR6w4QBZG/ryMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W0Gr55pA; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0Gr55pA"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2163dc5155fso193648005ad.0;
        Sun, 05 Jan 2025 19:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736134802; x=1736739602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AvNvAKAz7D6jFIUyYqknNzaJHYcSWZtuX9Z9kYB2JiQ=;
        b=W0Gr55pAxzpe+atqH8L+RttuI3BC+qh63sRFr2B/Axck4gZfQf9ljlMhEJBajijViA
         HFR2yMADxKmiWLEgs0fLhHc8j+bgm/Gb7+yAdqxsWE6Nh3755HHeiAgZxM8kCVuDkR3h
         1OxGf4rZ3krYFHZpfVYLHyRK7Yd+wqaY1SGfof2DQ6H5Y6OaoT18MtK/jjn0KjxpW11m
         uIR/eugtN4obW8mnLCa++AjUr13IbnGN2S+a89yaZT1yBl1Vd4Yj4ng7yQ6pAuDr1qJQ
         DUm2VGlsVjJpDC0d5FMLibjpPUHSm8iOfa6PBFRFX4qAxYkW0JzRrDS41IT37Fn4zm3k
         T6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736134802; x=1736739602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AvNvAKAz7D6jFIUyYqknNzaJHYcSWZtuX9Z9kYB2JiQ=;
        b=A4XB2KPn9lKkOqLm2vglpwmACbuadSfXURRWVKp8Dqd1JiQh0c5sAp5JN6QJvB1XEf
         DNnGBQrVdmB08tRU6jgfgAC2sQjtEuAQlt8bUtQ38BgnNhUyQY8zBI3JbTVSaix4oS1W
         4w0qYmqncA0gJaSUqeBPDj+ooQw7d+7Zg8/1F6uv5qyJCeb48YpgBAgzmn/BIwEHVFte
         +P5LyEgoCXm7h462GJQyoeewy4hF5sGK1L0JZihf/hBtnDzJjdqoPrw1DcsKhFrqPsZi
         mpbTuPOpxnBjz5Wlu3QpQ7CbPMF+3OcZJQ8sxSCllIk3mdjUGb3hUkGFEYCPnNae1d7b
         TSbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUt4fA4zXdioLWZodjRw0tTQaLMaV27MQwGFrqKFCZAjQXpLi8Sw6LGPuHOg4r4/dYSY8J+bdHfaD4k@vger.kernel.org, AJvYcCWavl7kJVspjnB0bSYmcNib4lKxb51rIQ2E6yV0JlXQZvDEWB4lI2IvScmm+sA3c59/Z1wwtKKLerI0taIQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwKfZ2njrLSWrTtdGX1aLZqKLVOZkmEDHkbhxbSASUoxAtc8JBX
	rAOmwURbo8u60S1f4+Vdyxcx77KjTygqjykGnD13v0dKM6IVtMMk
X-Gm-Gg: ASbGncvwF+4KhBvPzzNyqJdW+/mcbrU3if3TzjeTuom/d6V/UebzIUq8LDqkmCB552a
	PDUs9vlHf/L+rvkxqbeNJLw4k53VOIwsu/KuqPuoEawmXE0DD12yykFSKNO8jKAdxs1QyLsf0ei
	Tmb62w5cI9GE/DbitoCuRk1d0TB6klV4uA9I4Nh6ZJZ4D9ikJylouqt//w6+B4VD1B8zLO6HN55
	S8Lc2S7+RTwFiu37y4fQqtKuKI9REsLqHGRzNQGHSLMJRUUAEKdjT6O
X-Google-Smtp-Source: AGHT+IGG93OQqcvtPOxEHYcuXYb7acByhQWeRhAGG79hq3NLUb+u6x99Ivv7sEsvw+f1SnJhA7hn7Q==
X-Received: by 2002:a05:6a20:8419:b0:1e1:ca27:89f0 with SMTP id adf61e73a8af0-1e5e081d7c7mr88624048637.37.1736134802313;
        Sun, 05 Jan 2025 19:40:02 -0800 (PST)
Received: from XHEGW.lan ([111.196.227.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad830adasm30232955b3a.44.2025.01.05.19.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 19:40:02 -0800 (PST)
From: He Wang <xw897002528@gmail.com>
To: 
Cc: He Wang <xw897002528@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: fix possibly wrong init value for RDMA buffer size
Date: Mon,  6 Jan 2025 03:39:53 +0000
Message-ID: <20250106033956.27445-1-xw897002528@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Field `initiator_depth` is for incoming request.

According to the man page, `max_qp_rd_atom` is the maximum number of
outstanding packaets, and `max_qp_init_rd_atom` is the maximum depth of
incoming requests.

Signed-off-by: He Wang <xw897002528@gmail.com>
---
 fs/smb/server/transport_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 0ef3c9f0b..c6dbbbb32 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1640,7 +1640,7 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
 	int ret;
 
 	memset(&conn_param, 0, sizeof(conn_param));
-	conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_rd_atom,
+	conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_init_rd_atom,
 					   SMB_DIRECT_CM_INITIATOR_DEPTH);
 	conn_param.responder_resources = 0;
 
-- 
2.46.2

