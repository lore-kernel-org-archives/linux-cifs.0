Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196F32FE59D
	for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 08:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758529524; cv=none; b=c0tbHKg1ZNoOzxBJkvATSRDpVX8sf28RveB8vPw17N0cn/JkLYjd0SfvlgaS88ygg+meL5SJSWuwQX+R4BVXOP7i09OqNkB5ut9in82reMZLO0EFJgKhvboloar1SHk9oV4MxW6eSt0S2Y3YvHsJo9DNOS2qEOoxeoelYnKKElQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758529524; c=relaxed/simple;
	bh=oLrFhF92HdArUx15fueLaKz7PNKuzX+jtAfAeTiwpXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CxA0J92+gKD1o50IabQLaZua2YL0y4CGwz1rzOV5v216QEyJFePDGSWfoXUtZjP9mTGT8xd3SL8dfzoChClX9bOIl5UH4+8EVMTUYMmbp9HVYmR3SoIZHNUoUucb1uIXk9mHqKAmXeuV9eh/bcsr0TIRta7I5l3hBmBKGY8gBI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkDtHcUZ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkDtHcUZ"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso2697684a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 01:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758529522; x=1759134322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ggi5B9vLvJ8tH3G1KF/mQ7XMoVTE3nlPVTBcBye3zVQ=;
        b=NkDtHcUZOILSbaBzJ9mUuDk10oCNm2DmbhvbTUHSwGwGJ4T5N+E+YIwuIYocj5Woxj
         n/wCLiZ20zaj07fxBePozicvqjuGPTCrQ0CJOzeWQ7wNH0SEAe2dNfR4i5U5WIjjPavX
         tMETlfIrdmV3fr1dj1B/hdBNlS7b32W+IIvFDy6E6Wmv+E7+R2wVyMi49oq0qpQOzyKN
         b583XsTEWBxBcjtmFD2qkUqN6nli8ZYzY6fFlXPgNLH+KkfwlDGw2y/CliOvHOiJ0jdS
         +aa9FF5n4us54umHCGdlb+pmlBx0eqMSSMHsOo36NNfhGSlgBQ8VcjndiarJoa763Ya+
         8cUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758529522; x=1759134322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ggi5B9vLvJ8tH3G1KF/mQ7XMoVTE3nlPVTBcBye3zVQ=;
        b=UQMisIcOkmb7e1vFlr1Epnws+iX+LI4pmYiI3ad7kRZUc9yK7zIAkG7sWVzLxWPXdL
         6SuAavwEktLkm1gbaEo1xhQjQ4af7WMa0yIgdypXo6VEEOkX3aHyN2LmQW1bwyOEgvx0
         Gw4fZ7nyTUn6sA4Hz7AWGhQ/MQWv+o9Li0qmWnEn9+arXaNgg5BVcdAP2daIXWcqJ/2u
         gdG0KuAq5XzfUZDRyvR/pNtJWGejD+DADhzwACLClIZllPvorO+F+Qbt3qOy1RblwKh9
         Wb2oF6hfk9xWfvJNyBFWz0sM3zzep5vsKCGzazzxsdCdHWhrrhyZAbpS/WD3D/8Ahm75
         aqsQ==
X-Gm-Message-State: AOJu0Yz6dH+sYsCLY1DwZVo3CdgYINh8aQoiPO8Udg7Ja+gZ4fPxuRX7
	YNrGr1XQ5/g0QdJTOow6uoi4O7wW+o3myHRKkv2ZnqNW6r4suFZDq9Cdy8zhSw==
X-Gm-Gg: ASbGnctAho3Gbu8PzoZFclZpvknyrAv5SUzRF+ZbkTa5d4Ktx2NjGjEnwj2iS3gKlDJ
	CZJl8YmLI4EFHGHG4UBqyvV5hp2jpBVbNkk84s2/2lkXohkdPqwZsUovx4nKRMZKRRoCU4jMFUp
	Va9ap5Vz5XGDiQCTkWoIW4cRCd1H2iH1emjieuqJVT9ua3HxFHWzlJEaNtOL7xMa8MZZeJjmL0k
	XzVE7bA2KS3BeGCJOy9FyKnvM67qCNDbuJ7/+U/UTu1eCOUpSZmV0+gpOblXHtJJTGBMFDuIvpB
	Du8XMpgD8wYEEX/21U7H1ByQLegsxkHiXk/9I+9bCAQeQ+eFyY1tFJ+UOZMQXbGNpEN0AUNl7ge
	ImTI4OJ9Q6KMnhMaF2j1YfsG+JBoC5Po7/sWUuyHmIsNhp+yAf962bkOjyw0FRzNCANIfRHlCsb
	9RRW11WoBvhhVaFLRQwa/KD2Saq5o=
X-Google-Smtp-Source: AGHT+IHESfgiWX1583jgQOasqZLBM8Q7dyrYwWIi+YyG7D00B4yjVWdeH/3CCyl3mLO2dR0NwhJ+5g==
X-Received: by 2002:a17:902:cf03:b0:276:842a:f9a7 with SMTP id d9443c01a7336-276842afc51mr57163045ad.57.1758529521976;
        Mon, 22 Sep 2025 01:25:21 -0700 (PDT)
Received: from rajasilinuxtest.zztcpmrl4zvulnxionwmgqorff.rx.internal.cloudapp.net ([40.81.226.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980318743sm122818375ad.118.2025.09.22.01.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 01:25:21 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 1/2] cifs: client: force multichannel=off when max_channels=1
Date: Mon, 22 Sep 2025 08:24:16 +0000
Message-ID: <20250922082417.816331-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Previously, specifying both multichannel and max_channels=1 as mount
options would leave multichannel enabled, even though it is not
meaningful when only one channel is allowed. This led to confusion and
inconsistent behavior, as the client would advertise multichannel
capability but never establish secondary channels.

Fix this by forcing multichannel to false whenever max_channels=1,
ensuring the mount configuration is consistent and matches user intent.
This prevents the client from advertising or attempting multichannel
support when it is not possible.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 072383899e81..43552b44f613 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1820,6 +1820,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		goto cifs_parse_mount_err;
 	}
 
+	/*
+	 * Multichannel is not meaningful if max_channels is 1.
+	 * Force multichannel to false to ensure consistent configuration.
+	 */
+	if (ctx->multichannel && ctx->max_channels == 1)
+		ctx->multichannel = false;
+
 	return 0;
 
  cifs_parse_mount_err:
-- 
2.43.0

