Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10653A9638
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391201; cv=none; b=iYyKIv8+jfNmZJFgBhsJ0MqbM0SU9MQk03PMnBjM8WARrQNXT/rd6lDbb+hDimsY2zuMoeV6E1+G60P0YsXpoxtb+YP7CRN7f/rdzvtEXZRqBe1COPg6pFzcYxztiYNtvWXxZq/8RLArgUUA41pZjOdAyfTymKIXUL51OuHIW8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391201; c=relaxed/simple;
	bh=o9AxzB6iTIxvV3zczxNnobMq6mUvwYWWzYA0xI/jRJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJwqSOTPhCK7K6gvAbRnTvPicz5uiFG5tx9c6QKJLqggpb0q3Khfm89R/nVDuzxT7TC5bH9eJmPToIwb1HcaMWgeUbQuS6Cqn05kw9fBIDSGrei7/SFmOBZKDeWpPsLcy9UUqhLYrd/2q7tOOuGGnbKwZ2IVTWa7vstlFn2ZbeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CmW6FEGc; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CmW6FEGc"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso128745025e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391198; x=1777995998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaDqba+Z9YUDbJcQeyPUHQc2cEFoh6ewPsWR4yOwgNI=;
        b=CmW6FEGcjQ+8F+5HoWZaPjMdO6fS/CG8FRBp7PihKXRLKLuXuQR0yOWNj7lCOSZW19
         999kFdfXBOem6zmOkeJkFszNNHmkRdsGMRcQ/RKoamC+tM7rAyJ0AwvG2HYmecjjCKjZ
         W/57ymz6Ax6KmbIvIZtSAWQXnXBmaD5WwGUB+PdQ3Q54dRk35oADKfVBqPhXisOfGyBS
         BM5DfbEO424cXf+Sv06EdwQMPjYOfqH+a1y2gCbYfes0e1t5v2KUxL7oPFS0s6XPB+nz
         stDEJW9uZelsQzmUsMePNpGC0wJQaXYvo6sUNdhkqYS+YEWea7Nq9iQ6jAAtUcR/Q7ri
         yh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391198; x=1777995998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HaDqba+Z9YUDbJcQeyPUHQc2cEFoh6ewPsWR4yOwgNI=;
        b=CXwACb+xAW8seetwgAxm6bW+HsINhQEXrrEb1GEco+nshLTwS9EJvJgHKCOZku5eaE
         82EYN4qybWo8oCZiTI6yELqUJAVg54rNNEPecEeBIAipOhzf43JHdALJIwrS8nujPIXO
         sHrdMNn9m1bOd2Z7a/3c765O114/eXq+kuQ0qJpldvv/WLw71yFhgWXJeTSg7PRCMtx+
         CY/tR53EuJZXLlrG007lSIFLDUzAVpfL+obGxgCUUG1/hXiABW7z63feZA0S0t10x7aW
         R0p8WFJMgtG5lToDZePcxggKLmgicQ7PTarExltAvCwth9eJj/ZCn8qTpyRWs5/5gP+2
         7hFg==
X-Gm-Message-State: AOJu0YzG7e9qhsuZsD6Fr8xJwiHnzGAi76kRESRUAZvcEC/e06EBx1UH
	M7RGMiRpyQiav7+15aUaIiZXl8u2fm/4tNq3FWnbE019sg8G+z/qyFS9O/SUnvGkFnurm1YGe5O
	EeSHJ2L4VnQ==
X-Gm-Gg: AeBDietRMlhcNDfl8EliWnW9nNBCt5QiO+Wx3bOlljZ2MCmfG7z28lq6mAX+4fzgtCK
	RAiIiMj0vZu1rIMZLSOtXPHZi/qnTP8Se0bVBylW2MMOoRh54EoX4ImRbuD+lAI6ggpBo1yTfUi
	vt30gGXFjOTO7s2h9yGDbLw2fjPraOv/Gf4Of1k46s3utqcnM1NQfKK6vgn8dO3gOwhCCGG/AYU
	bh0z+Xx42XLcQ8k3r3xYzz2SRLc1A3VjvG6HzJ+UJZkyamFSNUJlEzmlhkrS4oPY70ay1S7XZDK
	NIkyUr0YEzx9fMKaXgLbvK4YGxuh5rk3CvJXtDSB3Mn826SDgBoE+R4kXxfA2XgPsWa5gzoJdxT
	2QWmjkXlYiYCdNUGC8puXIKoLEJef10DqV+PM2G2BrGBlPnKKFkmA6LyAuMQQeJrYiL1gTwZlKb
	8zm8KtMgmZ/O4Lxx9KUurm/Zh8VHfl2CqqxbfnqomtqXPh
X-Received: by 2002:a05:600c:1395:b0:483:7903:c3b1 with SMTP id 5b1f17b1804b1-48a7b53bd9fmr3075445e9.20.1777391197780;
        Tue, 28 Apr 2026 08:46:37 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463d4fa52bsm7725384f8f.15.2026.04.28.08.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:46:37 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 01/11] smb: common: add smb_tls struct shared by client and server
Date: Tue, 28 Apr 2026 12:45:58 -0300
Message-ID: <20260428154604.222551-3-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428154604.222551-1-henrique.carvalho@suse.com>
References: <20260428154604.222551-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both the SMB client (mount path) and ksmbd server (accept path) need
to drive a TLS handshake over their accepted/connected QUIC socket
via the kernel handshake API.

Pull the small bit of state shared between the two callers - the
completion, status and peerid populated by the handshake callback,
and the tls_handshake_args structure passed to
tls_{client,server}_hello_x509() - into one common header in
fs/smb/common/smbglob.h.

Define SMB_TLS_TIMEOUT_MS (3000) here as well so client and server
agree on the handshake timeout.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/common/smbglob.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
index 4e33d91cdc9d..a08d804af0ed 100644
--- a/fs/smb/common/smbglob.h
+++ b/fs/smb/common/smbglob.h
@@ -11,6 +11,9 @@
 #ifndef _COMMON_SMB_GLOB_H
 #define _COMMON_SMB_GLOB_H
 
+#include <net/sock.h>
+#include <net/handshake.h>
+
 struct smb_version_values {
 	char		*version_string;
 	__u16		protocol_id;
@@ -66,4 +69,13 @@ static inline void inc_rfc1001_len(void *buf, int count)
 
 #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 
+struct smb_tls {
+	struct completion handshake_done;
+	int status;
+	key_serial_t peerid;
+	struct tls_handshake_args args;
+};
+
+#define SMB_TLS_TIMEOUT_MS 3000
+
 #endif	/* _COMMON_SMB_GLOB_H */
-- 
2.53.0

