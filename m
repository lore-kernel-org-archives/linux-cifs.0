Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A3D340A4D
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761058507; cv=none; b=tQKE7xLyf71ZXTLfN3UzEVFZWhRf7gjeE+zgR6qyZdnTu4y1RTWxDtTex51ym1HclPkiNLPBEPZ94898BgVno+ESNlkzNk6eACdGf4kTbz7wVUpwZrcB9I4708s+FMyLJp6ZG1pWr7KzxseMe1SQWn/oNqumWoA16jk91L/YvGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761058507; c=relaxed/simple;
	bh=DfZMU0R0dRnRuQiWcl7q8VsHGYmCXQ9jXTVQm1yN/2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OkE0D4UEQYJpRn85Rfu+wdJFxGOegEUxg1BVoiLBZSBnvhXk4At8K4nAM6u7WMfSL0IHZvX/cr4cEEMl6EHyNSsMqsMaF1aqeqrJ/0hzQv8jvVWpGSZWYgr2x4YObdgkNC9/93v5mYUbMSIsrJDT6g77P8X0CIwfXVJBaXV0ChE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3lOkytZ; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3lOkytZ"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-79cf7fd45afso569926b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 07:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761058504; x=1761663304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8VP2I0PGCA2sfJ++TfsZS3uJgWd3RCZmM7e0QrTU2A=;
        b=U3lOkytZnhJ3xunlZBIjvy3C2PSJcTAcZ6oS+atQJgKbX2eTCVitmX6MdpKdCbGatW
         MYa0EHzhU397hRnxYGmo6mkR478J+ald6CE7/bTss8OnzqI/aV3CQ+sK+esjUzZMZrNy
         cqlKDtHAnohEVGD5h+p8aerW2mruuUEjg8t4GlRrH6Wa2Za53Rd5LiJIs5RW/o+GgKlW
         jXOL9JyEUBilSfUxRs/a8PVCOBkHm+uJ4fzJXXwntc3xLhz5NwmzxEC/8So0k4UVtrRM
         OX56UckZtTDrj+Ye8K4XVMtKQtpYpJd9Nk2t2N9f0s7I/qAV+m1iuMqKPdYtPS1HmEIq
         s2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058504; x=1761663304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i8VP2I0PGCA2sfJ++TfsZS3uJgWd3RCZmM7e0QrTU2A=;
        b=aWLKQtCUUMQfNgtpsVQZ0yN/uDh5WA8dUa9e2vzfhBAsjbYLBEjG8xXxHcF8sO3MmX
         da3UpeGyE51t2InGQxbPH/JDIEwxko3VASjx3XWZ6cHIlNxc3FHBwwvhIpJe6gUbEKo1
         D5dcb6fK2PbXOGd09MLvp14JNT5oQM1/xkJbBVFipCN8MtR7NPapCmGbuz9TpDF1XSap
         gncOxGytlUdBijIAKFEC0w8aIa7YJUgv2IsPBfBbFSFocjnrCkL4duDGL5tUjs+NTZWu
         fx1zBFx5ZJ5FUWYWUZBar1D7/tHcw3qmYUGniWI4jwRzI3G0zzUHQcXh5Dz540YaGXAK
         1Ggg==
X-Forwarded-Encrypted: i=1; AJvYcCVROv2H6TQVW7r+FnxAEusOZvsfVZhy3e65GWGO2mvPU5JZ8T3fR1OymPfWxsc10mnvaBkWJA3Nuq80@vger.kernel.org
X-Gm-Message-State: AOJu0YzlA46m9JjONpuBB9E6xElBxjf5Xdti2UVno3a78F/Me5t8YDfL
	ZuYzIEerhRWVUYM+R9r4ytbuHS5G3As94dOktEoaULgkS8MwXPUKRqQ3
X-Gm-Gg: ASbGncvTYW698/2UVryHphNsTAG3HykaMFyQgI6QqlhpkbMGFcobKJm649YLKCPSKjn
	XTNJhtvKzcWbsvrqRKxqQfDnDVNsY4zoNOBjb2L4fVeSbStnR2FhIzrLxyMNLT6O7X3lL7sOpsc
	jvjpVykufRvZ1ET799hXIzgreoyU9L3dj42O8oyAPhTiahTtbFYbxJoyqYwXtkuzD1wmT08bw/H
	f7IeVE7zQ79tYaPJJTyas4chy+vd25Es8i2rQ8Fk/N4QI5ShcxNNpjXD/HrcwFzJRoslTprQFq7
	D07GoYpVULrpnCsBGchsgwgUlxFIokAC6kg4wEgIfCDadYH8uFpRPj55XTF1yjIvM/RZ8nZk400
	cEKl1SNvJUvJgsrFvw20+BTU7nGWAz8bpWG6+hwL/ID7U0jLblctOuGmG/YV2tVWY0KbaSTx5md
	8PoALxtWuz1PLceG0z6EecUhAj3U3ACg9Jwv7Exo1cmmQVATV5UnRH9JLTdmH1oG24ZOVphZ4x
X-Google-Smtp-Source: AGHT+IFGdbtj0ivIPfYSgKjRnJx+JRIuBP/TzlLHzhX/tcb7pAq49jg9nE07bVQ8DwbDuxENZ1F91w==
X-Received: by 2002:a05:6a00:1408:b0:781:229b:cf82 with SMTP id d2e1a72fcca58-7a2572d4b3amr2639509b3a.3.1761058503854;
        Tue, 21 Oct 2025 07:55:03 -0700 (PDT)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1581dsm11484614b3a.12.2025.10.21.07.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 07:55:03 -0700 (PDT)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: transport_ipc: validate payload size before reading handle
Date: Tue, 21 Oct 2025 23:54:49 +0900
Message-Id: <20251021145449.473932-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2025102125-petted-gristle-43a0@gregkh>
References: <2025102125-petted-gristle-43a0@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

handle_response() dereferences the payload as a 4-byte handle without
verifying that the declared payload size is at least 4 bytes. A malformed
or truncated message from ksmbd.mountd can lead to a 4-byte read past the
declared payload size. Validate the size before dereferencing.

This is a minimal fix to guard the initial handle read.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/transport_ipc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 46f87fd1ce1c..2028de4d3ddf 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -263,6 +263,10 @@ static void ipc_msg_handle_free(int handle)
 
 static int handle_response(int type, void *payload, size_t sz)
 {
+	/* Prevent 4-byte read beyond declared payload size */
+	if (sz < sizeof(unsigned int))
+		return -EINVAL;
+
 	unsigned int handle = *(unsigned int *)payload;
 	struct ipc_msg_table_entry *entry;
 	int ret = 0;
-- 
2.34.1

