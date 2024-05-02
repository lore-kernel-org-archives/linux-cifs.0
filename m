Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211EFD26A
	for <linux-cifs@vger.kernel.org>; Thu,  2 May 2024 12:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714652082; cv=none; b=gi8ukuLRsqcTiGP2tZmPneqndZfXkhpbNAEbWAEzlp1Ku4p/zYU9yQCfh8JuLHXynf5jFuthHYKxHsU80aKKhEf1gSnhFhJMgWrhwiBGYyrIRisy+a21ky2THYHdTcSj8h1sDUdCQ5p2jpOi0eRITYpZOEjHtYQRN5HIRfvj87A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714652082; c=relaxed/simple;
	bh=5Ov1TTexz0ihZRUSJuJgl2AetkWSI0KctNOBwQFrQTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bvNzFb/ZZo4pFC8hidAz8qIH3K3opxm5VKwb8HNl4Ewgqm2WsBhst7VdrqELi4Xp++kRSD5GYy1drmnCPCEStHgGQlCSQif+jwp51xxd+H0t7KHFPSvrwRc95XcN1XfY+LsiekGx/VyrOIKpdhKJXR9Gwhb+H7eT+eBDIVlaqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ed04c91c46so7454568b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 May 2024 05:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714652080; x=1715256880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KJeaFGNwVt7VspE59Sf1aCUfAUOmqBVXol4PgC1G+g=;
        b=qCUDO82j6YBJfgzQpb3lPtS5NP2Jd3n1nhs68GacAUzzc1R/ItJInIWALz0jS22ule
         nB9PcsVZaMM4eGvHLE67lzHC4gGxQ4kPgBpZHy089852T7ZqfiLx2eei1V64yFR2L+1I
         XDvScW27jtFkHfWXkgSlP+xb0cFWxKJppmnnbMlu8Xv7Ntc3nFoYWfB+2UpKRmuO0MIF
         VnYx/phpGnJDjCR7RHDScUOJRZwsGghw0r9Ezxa8u7mAL8WX4CdXC1TDl6SIGYmk9RJ7
         MyTA+ZBYtDjXy1SNP7ZDwFqF+6+um0W97Enm6Mbb3HmRoqZ+zoY48F3phGTi1ez2Q9TF
         S8lw==
X-Gm-Message-State: AOJu0Yw8hOIb+krCyWdOG3whiRMwn3SHSvATutSCtDZneBym3p+dJ2Ei
	GKKXof+kjwvkIXFjnWGkzFMpQym1mdu5+e9TwPSPi3jTvV5StFLF+yKtBg==
X-Google-Smtp-Source: AGHT+IHwvAk6TcNMhCcR1t8tmULyhGpuQj+yBdBtJM6NmJKGR+0oPZh6vVzSA8k88aw9eW7y4CzaTg==
X-Received: by 2002:a05:6a20:dda4:b0:1af:66aa:783f with SMTP id kw36-20020a056a20dda400b001af66aa783fmr6205154pzb.30.1714652080118;
        Thu, 02 May 2024 05:14:40 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id gx8-20020a056a001e0800b006edec30bbc2sm1069840pfb.49.2024.05.02.05.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 05:14:39 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/4] ksmbd: avoid to send duplicate lease break notifications
Date: Thu,  2 May 2024 21:14:23 +0900
Message-Id: <20240502121425.5123-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240502121425.5123-1-linkinjeon@kernel.org>
References: <20240502121425.5123-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes generic/011 when enable smb2 leases.

if ksmbd sends multiple notifications for a file, cifs increments
the reference count of the file but it does not decrement the count by
the failure of queue_work.
So even if the file is closed, cifs does not send a SMB2_CLOSE request.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 4978edfb15f9..6fd8cb7064dc 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -613,13 +613,23 @@ static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 
 		if (opinfo->op_state == OPLOCK_CLOSING)
 			return -ENOENT;
-		else if (!opinfo->is_lease && opinfo->level <= req_op_level)
-			return 1;
+		else if (opinfo->level <= req_op_level) {
+			if (opinfo->is_lease &&
+			    opinfo->o_lease->state !=
+			     (SMB2_LEASE_HANDLE_CACHING_LE |
+			      SMB2_LEASE_READ_CACHING_LE))
+				return 1;
+		}
 	}
 
-	if (!opinfo->is_lease && opinfo->level <= req_op_level) {
-		wake_up_oplock_break(opinfo);
-		return 1;
+	if (opinfo->level <= req_op_level) {
+		if (opinfo->is_lease &&
+		    opinfo->o_lease->state !=
+		     (SMB2_LEASE_HANDLE_CACHING_LE |
+		      SMB2_LEASE_READ_CACHING_LE)) {
+			wake_up_oplock_break(opinfo);
+			return 1;
+		}
 	}
 	return 0;
 }
@@ -887,7 +897,6 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
 		struct lease *lease = brk_opinfo->o_lease;
 
 		atomic_inc(&brk_opinfo->breaking_cnt);
-
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;
-- 
2.25.1

