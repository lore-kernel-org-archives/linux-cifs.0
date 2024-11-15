Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7D18CC1C
	for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 08:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659579; cv=none; b=IrB9U0BodDBzkWr8ABvHcOC8Ndtn5m4fAhDYYC+A40M2g5jpaYGMTxIch+sa4c+zLp7UDCApKukAZL5X6AH2OdoT/0wpKOQQQB2E94WNE9ieWE77QR4rYnGE9ux206JsSK5LdyS3MIDrhVqlnja0Teh4ydLe1SDVfHnVLMPrQKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659579; c=relaxed/simple;
	bh=54mni3iTajw4DR3xdzQsdu/Chh5F48gsSo9KvuOjIDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DTebO57kfGNr1Irtsfr+JuW73yLHvjaFnlR9Q9607aR2gFAvXlsnTblJBx/uyA2443DmO0itU1gm+AQyDRmKyKyXsg4O/03tKBHoq/1Il5chlzYLLt7EbXYLbU7dBUvQ1gfEZPuk1G40/u7t8Db8my7eyTyUO6ZSH9Jw9q3tN9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=IBZudi5C; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IBZudi5C"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6ecaa45af7bso4831947b3.3
        for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 00:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731659577; x=1732264377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kVk+wA7Hzqqbm+HZtE5Q8quohvyj63w+EnDU9/WQw68=;
        b=IBZudi5C/S5fTYrNYlC/CG4jdL59Prhrbz/3F0dqoqjrOABZ0y5QQiGgZQs1VOTKuj
         5UmMGu7u67sjEe3Xy6Bc3KR6LMphhUDAlva0Wh1APjx9SXT6ZWK+Xqa0E0fmFmUA5bL1
         /edbV3sbT2TPb+XbHERqbyMd1l47JUYI20CwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731659577; x=1732264377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kVk+wA7Hzqqbm+HZtE5Q8quohvyj63w+EnDU9/WQw68=;
        b=aCmqprJ3vrfsMEQnJgt8E2JSIC7Vi3GTXTpp6u5PPwSMKmt+tcZjTjGx7JNigMcCgL
         N2V+NrTuvVmzAFPRNOkKLaGqCCCGDKAbV3t6SIPg5lwE5Rz75Kq1xh2V4IyJP9J1M1oh
         aMe1sep5JKscCDagDTDBRtQ9WeRQ9r6PRE0HQwZYTjLUl11ZD2z4Y/jMM1UR/uB793P4
         lUbfcYkmQAOZH3p8i/r+Pd0x4rhuV4bqHRkl+Vc/SnQpdbT4QSZF/yxgQLl7oc2GLCZq
         1lb087NuZ4TMjN5llkVTw2lWNSHnMJP+ozXQMYj1feH7gd1KQj7L507X6PyqvubdcCRk
         kEgA==
X-Forwarded-Encrypted: i=1; AJvYcCVDUXGKb3hm+0WQVPR7DdbVR5I3eq479dmTRawTovX9kPFiPKh3Q6fiICRTLshyUYYJ9wL1yqQJwA8U@vger.kernel.org
X-Gm-Message-State: AOJu0YwrFrhRC1OoIX8Wu1hpGe83pZ2t6zZzIP5JTfuWKqSp/rXp6TO5
	E7PPh7DLXQb5kZgGUmV6ziSSmV/ifK7erU3YcFb4L2S3SnwxKmoxRaQoo9hURw==
X-Google-Smtp-Source: AGHT+IGhoGxCNZRH1MLfMJH1sClc2oTWPqp7sgf+UUkz9D2SciqwrZP1OjWUqLdY7aFalNaYgAhmHg==
X-Received: by 2002:a05:690c:7005:b0:6ea:84e9:1612 with SMTP id 00721157ae682-6ee55c615d5mr24358737b3.29.1731659576809;
        Fri, 15 Nov 2024 00:32:56 -0800 (PST)
Received: from vb004028-vm1.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4635aa37c54sm16584231cf.53.2024.11.15.00.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 00:32:56 -0800 (PST)
From: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: yuxuanzhe@outlook.com,
	linkinjeon@kernel.org,
	stfrench@microsoft.com,
	sashal@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Subject: [PATCH v6.1 1/2] ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
Date: Fri, 15 Nov 2024 08:32:39 +0000
Message-Id: <20241115083240.230361-2-vamsi-krishna.brahmajosyula@broadcom.com>
X-Mailer: git-send-email 2.39.4
In-Reply-To: <20241115083240.230361-1-vamsi-krishna.brahmajosyula@broadcom.com>
References: <20241115083240.230361-1-vamsi-krishna.brahmajosyula@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a80a486d72e20bd12c335bcd38b6e6f19356b0aa ]

If ->NameOffset of smb2_create_req is smaller than Buffer offset of
smb2_create_req, slab-out-of-bounds read can happen from smb2_open.
This patch set the minimum value of the name offset to the buffer offset
to validate name length of smb2_create_req().

Cc: stable@vger.kernel.org
Reported-by: Xuanzhe Yu <yuxuanzhe@outlook.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Stable-dep-of: c6cd2e8d2d9a ("ksmbd: fix potencial out-of-bounds when buffer offset is invalid")
Signed-off-by: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
---
 fs/smb/server/smb2misc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index 03dded29a980..7c872ffb4b0a 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -107,7 +107,10 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 	case SMB2_CREATE:
 	{
 		unsigned short int name_off =
-			le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset);
+			max_t(unsigned short int,
+			      le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset),
+			      offsetof(struct smb2_create_req, Buffer));
+
 		unsigned short int name_len =
 			le16_to_cpu(((struct smb2_create_req *)hdr)->NameLength);
 
-- 
2.39.4

