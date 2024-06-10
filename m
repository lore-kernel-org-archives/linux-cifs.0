Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8CD84A4A
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718028878; cv=none; b=UHIiP15mKUzGMM5jWAO4KzZEmHQkuJSDLBI6pfHoKivraR3MABZDOJ/49MLhcBGPS8i/aeyRr53fhx/g1Hwe0lisKbPyWJH/fqHoVen4VeAeYBqN2r200de0Ft1cJMC+PPf/F0TxwwN0V0aO8/7+XOnVqbwpTFZ0IWZ7VEE1SGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718028878; c=relaxed/simple;
	bh=sxypidAh07N80PAqjVcFf6bncu8VEjW2XRAKIPR58Jg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ELKLFSODK3g57CeYVJB12jvU7nYqslPE33CGASYhOLFXqUpwuNLqGY6IPZd05w1j3I5SAKT6Q6+wjIRSLkuSiNii5hlQ3hQ6P5CS2iUYZvvaQuZ2za7NwMrkeVD3qLxRRC9HVuyUtgvXqFnUHDU8EDDtH5ghk0QjJclkuali6jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70421e78edcso1924738b3a.3
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 07:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718028876; x=1718633676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMmlNgQ03r50DOf/E/bzZooE0MwVPRkltwV2KX9dfpI=;
        b=n/nKKoFHWf7PTSEjMNO6s7cYooxTBgeRRDY9MH/jjkNSjgMlBJJpZilsd/ewk56VVj
         8R4OelfzmnwTBLnNDXswgm+TOVVaDt3fXZWEjGWoNysEJLUn1/S3lkQWYpOrdYKEMEcv
         Mdt0ezOMeaXuIFjJf/aFnCdcsKr7s9VITQHr19GPXJ958sVZuROhGV9F9Q0+GME7Zz5r
         /RyMezMXXa9VcUx31af+cX8zC2v7QqjzbzE8jnBxHUW9CBrTqmQX+SyxCWfNgYoUWuwB
         S/PmEGQTjJFutGfgaPG7DSzGo4kCDIsEAJT7zbfiBP0RgvB8zTCSNtu+AoCPyMag2iaP
         TSbA==
X-Gm-Message-State: AOJu0YxFaSFG3LlLedas5rr1/FNg3rI9UDUiF19dvKvtX4Qzyo1YY4Is
	ZKs8WfdsUU93rBYp3s/vpRzZ0kwCVGR4YV+3QFAM7X8NFguipzfc0bLwsA==
X-Google-Smtp-Source: AGHT+IEQtiaQvC3FdFaR6htla0Vm4IJltosY9WDryteDYJONBU2oCBH6/OPbm+MF4Oxssocd5pNfnA==
X-Received: by 2002:a05:6a20:6a10:b0:1b5:d01d:1998 with SMTP id adf61e73a8af0-1b5d01d1c6emr6887458637.10.1718028876044;
        Mon, 10 Jun 2024 07:14:36 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70419a36c16sm5144392b3a.175.2024.06.10.07.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 07:14:35 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: avoid reclaiming expired durable opens by the client
Date: Mon, 10 Jun 2024 23:14:13 +0900
Message-Id: <20240610141416.8039-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expired durable opens should not be reclaimed by client.
This patch add ->durable_scavenger_timeout to fp and check it in
ksmbd_lookup_durable_fd().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs_cache.c | 9 ++++++++-
 fs/smb/server/vfs_cache.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 6cb599cd287e..a6804545db28 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id)
 	struct ksmbd_file *fp;
 
 	fp = __ksmbd_lookup_fd(&global_ft, id);
-	if (fp && fp->conn) {
+	if (fp && (fp->conn ||
+		   (fp->durable_scavenger_timeout &&
+		    (fp->durable_scavenger_timeout <
+		     jiffies_to_msecs(jiffies))))) {
 		ksmbd_put_durable_fd(fp);
 		fp = NULL;
 	}
@@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	fp->tcon = NULL;
 	fp->volatile_id = KSMBD_NO_FID;
 
+	if (fp->durable_timeout)
+		fp->durable_scavenger_timeout =
+			jiffies_to_msecs(jiffies) + fp->durable_timeout;
+
 	return true;
 }
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5a225e7055f1..f2ab1514e81a 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -101,6 +101,7 @@ struct ksmbd_file {
 	struct list_head		lock_list;
 
 	int				durable_timeout;
+	int				durable_scavenger_timeout;
 
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
-- 
2.25.1

