Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E674328DC4
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 04:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776832967; cv=none; b=qbRyJcitV/aCun2o4fhT72/21ZKKWNAF5ThGIIjD9ArVhTOUGLFPVEOJEeswuVAtrj2Be/SrT7IyI8woTO4F5UqKPdqBrknIBsNP3k01TfF9Ae2jit0Yaw9L2ujCvPptUT0UzlEAFnJtHaNCqJGjg+XTu/GYNOLpfw7kRvJECJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776832967; c=relaxed/simple;
	bh=+Sn8u0DLRQ7gia1mCmaJ+HRQsiMMm+xdqzgaYSxQtoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOtU0n36t1ciGJCVr9exQUuK3O32Bs3+hDSZnpUrBjUOu97ZZMrIkM8+xhbb7U1qC44WGRgnLXSm+6GCVeGksmx5Qmg4O9Oqu/zhke9j6ruFCvBkdvdjcI12ThqYixNFgJnzFGFPxh4QwATWcA1V/JttyimxE8ZFiAd5wIC+Kvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOZXoQbg; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOZXoQbg"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-354a18c48b5so4604725a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 21:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776832965; x=1777437765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZdBnyRsrmiV1KN7ybACpvzeRlAkDgk61lXOxjaTu8lg=;
        b=VOZXoQbg7P1yE+HBum6unD07eO/nvU9inRh9BB3ET68bkhFZLtDqxQQOq/pIHG2IWd
         TN9QGxsUvliiURk4AGwJeKjpX9+FAjqf+ZvpI4htXAiRX2VRYXwMslsjRXyZQrV1E046
         PR1gxF3t59Lj6BralSe6OQ8ToXhwDydToyaDwMbUrx6riLyPfgwz+oHUUPMylXw4sKm1
         vcaqA8j7IdkftIjuUiWQ5uxITVsAKl3voAC/vg4dK0LhlKqcqo9qEPWzoFu6HbsBB/OR
         8xBNErgbpqEeN//nNYC6RF7+Z3EFFjdJOEvPMDUIg38x0JRIXoirUnYaAzXiKznDRP6g
         7Z5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776832965; x=1777437765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZdBnyRsrmiV1KN7ybACpvzeRlAkDgk61lXOxjaTu8lg=;
        b=e/Y4cAFYsWWBNt5viUC+O6PIltkbHb0y/DH1O08b0Jrv037PVumWbnnWULIPFxIyad
         QzIgVsE1XgGOTHNv9qDxEu2VT2IhqlCNjK7Id+zBsBudVKlS0nHkis2Q4whHOCAC3Nwn
         UL3w4QEz5SY7qmHgeSszBtJFBQS8MkrteNnGOlBWoYEz184HCyw2EkblnH7Zrc7QS4x1
         PL9oU+n0ESOXJpuXFdTzJd+q4Hsx0BKu1DNFIlnwAT6zbw0oboA11dgI4WdnG1+W4Csr
         oHYARRWY4P8NsppnyqG7Juan8HsB1TV21wwsYg7joV5mmWVfw2BKBe4NZBDPFdj+ObfR
         AXlg==
X-Forwarded-Encrypted: i=1; AFNElJ+5TjtJ1zvW1iPNkko9QBIiDa1ZBWgHT86JOc+rGRw1i+DS+ro2iiWUwNmnnl1gEyUpikqr9H3dJwaY@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+bK9HWFVsDGTldFq6JIjcv9e0zeyJlWLxjZ1V6EoxG3qloxiu
	7D674uPRPdMfHS20fyuUJo+z3qSSOB9rv3nw27XBLQwzjr5ZtTfa7tka
X-Gm-Gg: AeBDievv9n1PvAsWUOhZR0XL9zS7xkuzdxfwXYm+WTuapNGZWAayPAeerxP/GyCy2zz
	VqmABRzAIV5xjSGDaglIWYtbVSt3jTpuLk6S//EauFthiVue7THY376xCUOzder6wru7qBgO8sJ
	MwmEd812jfFhyW/9AB2X0N+ufjCInBwV9nA9kLNjFdcXpC9qIch0UzFB/MeYwqM9CHVUs0YuJUb
	V8DOhIAZAw5OUGF9bL0ItDjzpkMNRPE1NnzCJTVN/gpZ2m/V/jHKqKN0RJXAf/u3TsXCuUZEIWV
	8+/jDIMWeFBwpCAO64EDgp3yseByN1eldf1N6rn9Cym6lRXGEQgKt90i3ZrjvC/mw1rXaqMUEUR
	UDt6jsbjBDIIgSPX4gEvYpYctskiba+md3tykrSuorc9jMgPDKNoL6+v8jDqWLqZw0BaIFuFupr
	nUV5SqJ9IcRuR00faFQ7HadscYmq2HOxWIVmGynZ552VKRmDoJ4YlZbS6RbWqTCPmnfrBrSIp1Z
	+maUtcvqtQg/DllPuVBq25Yr/lGYoLVFQ==
X-Received: by 2002:a17:90b:1804:b0:35d:9da0:4947 with SMTP id 98e67ed59e1d1-361403f15abmr22007260a91.11.1776832965189;
        Tue, 21 Apr 2026 21:42:45 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362b9b6f5b5sm2012643a91.1.2026.04.21.21.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 21:42:44 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: rajasimandalos@gmail.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v2] smb: client: sync echo_interval on remount
Date: Wed, 22 Apr 2026 04:42:30 +0000
Message-ID: <20260422044230.1127071-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-5-rajasimandalos@gmail.com>
References: <20260409095926.905020-5-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

echo_interval is accepted during remount parsing but
server->echo_interval is only set in cifs_get_tcp_session() at
connection setup. A remount with a new echo_interval value silently
has no effect on the echo keepalive timer.

Add echo_interval to smb3_sync_server_opts() under srv_lock so the
new interval is pushed to the live server struct. Reschedule the echo
delayed work via mod_delayed_work() so the new interval takes effect
immediately rather than after the current timer fires.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index fd1060483bf2..45173f287f00 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1329,9 +1329,9 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 /*
  * Synchronize server-level options that are stored on TCP_Server_Info
- * at mount time.  These fields are consulted at runtime (retry logic)
- * so remount needs to update the live server struct in addition to
- * cifs_sb->ctx.
+ * at mount time.  These fields are consulted at runtime (echo work,
+ * retry logic) so remount needs to update the live server struct in
+ * addition to cifs_sb->ctx.
  */
 static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 {
@@ -1341,7 +1341,13 @@ static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 	spin_lock(&server->srv_lock);
 	if (ctx->retrans)
 		server->retrans = ctx->retrans;
+	if (ctx->echo_interval)
+		server->echo_interval = ctx->echo_interval * HZ;
 	spin_unlock(&server->srv_lock);
+
+	if (ctx->echo_interval)
+		mod_delayed_work(cifsiod_wq, &server->echo,
+				 server->echo_interval);
 }
 
 static int smb3_reconfigure(struct fs_context *fc)
-- 
2.43.0

