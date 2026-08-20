Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8863D566B
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 21:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260938; cv=none; b=NwUO4m7T++PSlMtpDwPpigMfq6qzTHF2mgHt5e/C0TQDa/yZ3d4T8yXRwJ5CUHhF49ooMY7e7OKXluoWgiMNSptCWOMrNtn2/P8VEMxLiqUECJaaAuQfYEZV+i8hhQCvPerb7phUvvx1t+1lzYw/cMsWMDfxYjGmwRz6QQ1ubWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260938; c=relaxed/simple;
	bh=53slcbkbEBL8Rm79rTcFv4mLcds1G4ZiVKbzMQvXQmE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UQtlQvAmxp06ylrVtXr35vWs83WBdxVhsLjzli9OuGaD/G09LZamsrcdmVRWG7XvIYEEXoa52a4JjagfRNog8USQ6EGla9VX/87WbQdVO7rvYWocLhGuoPd+Bk0JbZcqLtPslBWEcKLvfNf6s3kPn87Cs1blCxW7/v/ODMJirjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PSLLCLrV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=h4pBgauF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PSLLCLrV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="h4pBgauF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787260935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a6ae+9Zx+uC5nDUKbM59YHQRGfjeCrCTMYZZummnApE=;
	b=PSLLCLrVFEZ11Lax7mCBoUfdCbHD7O9voH+6OJkxnOHZgfXfNNx4SLl/PtJoGN8MMeiMNp
	iallnA7nDk6AVcCDb5Itp8h9QmqnPLav4vDHejGcnbnAt1pD0VKzx9yWnq2+tXHLwcuIjS
	GPMzbYVeeJXXBrJI2Op2Y07Or5D26Nw=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-otdwmvneOK-ZNVOrcj0iWA-1; Thu, 20 Aug 2026 17:22:14 -0400
X-MC-Unique: otdwmvneOK-ZNVOrcj0iWA-1
X-Mimecast-MFC-AGG-ID: otdwmvneOK-ZNVOrcj0iWA_1787260934
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e6b59d85dcso587242a34.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 14:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787260933; x=1787865733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a6ae+9Zx+uC5nDUKbM59YHQRGfjeCrCTMYZZummnApE=;
        b=h4pBgauFyX0itPwrrsMkY/09jLqY32G2To9OHsdKoMKLq7CpUFbB2+pKHY6H5sQs5B
         XUvY6Lp1kfzLStJ4rEiUQ5cVqAGPeT5qspW7ZqTks+RYl5cK2A+vNrNF9PTyNslsFGfA
         i8FND6bnjD2pwifnwq6sIJkZizEmoI6Hh7vncVecBggU9QN3UVZLM0YLCfj10Cqx7oX0
         AzgafJ678Y1HCFC3n31mYVXLueuattPsp+Ehr+DmLOdK37xZ2LKuMdwhkLvCyNUitQew
         VyASTDt+vAbfrku0Z0blagtMFc0KyOpEdulqBMDXBypENfXBK0jTe7VEc7AiK/CvkF5U
         EVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787260934; x=1787865734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a6ae+9Zx+uC5nDUKbM59YHQRGfjeCrCTMYZZummnApE=;
        b=AkZt1luERZWTDwqdUXq7FpCxCB3xUEOTDc4zUe/ZD60dSBkIFZS5Nj75UMKJh6S2mz
         +tK2NB3nHQ7qim8JcR8vczj5XNG7EUkekvqBpHydcKchASdLGsMLC9TOOkdIFYnIIWt6
         OOsAfvGvdmP+bxD9eq54RdbiScb4Ik5hLbUWYLwKpX6V3lKiezYR+3yMckB9A8g8elXL
         aYwph7aW4GidEwpgTwpJHG1J1eKxzBk8fQ8xNXm96wcphAkF/JFlEQRPMhnK+wZfkhQx
         1/MawbdC9Hy+ogPQR+PH+UqvFOOvGIXl/EN3veTLI3VhyIzlPxGpl/oMyH3owrmnO04V
         FFeQ==
X-Gm-Message-State: AOJu0YwRmEAaVNs5rUSuLVLEqnr4NRU9p8Rc3lVTolUpac/d9cjbahZn
	VoDtEXW40xDdHvyJ3+yuIZGcKZz/xSnHyVFN0Xx2qskQ4/G4fOPe2OX+sIlMlPxg8WJdDM9fhrO
	MRiDacVb/I8OMG8YGuybf33vmVLsvmnKmeBsWl53VS0bGoB5kViOEXtz0k5Aj2o3TbYYuZAewGC
	oNWWXc3XcY4oYDH8RVuZtOs3VkjXcZ4FQzive631byxPamRsQ=
X-Gm-Gg: AR+sD12RVQSoGv2Tx+Ccpca6m5EVcMGUWmJAfCAW4o2wKg+5YmFAatFjaOv3vND5T7z
	tQIJuaOT67dOpZvHbbLxPGm47ZoFhzVqb779WbVdqM5V86lHfSYtd/wcVxQBuqYCrVTTtkVZKqX
	7LFsHgOpTh8Q1iZtU8jFcZxjgYHqbJN9OSs7q+/6r0O7wzddzHEV05PUCqOyKdlQCnSr1Mou9WD
	Z14j8kcGXZebKeK6DiFDX2E/4pYhQ4afHAb/xeNUsuyErgitsNb6e+K+Is8ATaF/gn16IKMkKmV
	89b7akTUVu6cIkdf0zLXxBVZ4xIR6TX1pQk8z3yaM99tKoOHxdMHJLIVeFhAzqVowBH3D9nhOSN
	kyTEBEKbgewmGR6u1SaEsrzOtQLRS/07ijFKwf1j3Qual19EK1fQ4cG1Z0iOX61pj5w==
X-Received: by 2002:a05:6830:6187:b0:7e9:e257:81cb with SMTP id 46e09a7af769-7f461845b89mr1874603a34.7.1787260933667;
        Thu, 20 Aug 2026 14:22:13 -0700 (PDT)
X-Received: by 2002:a05:6830:6187:b0:7e9:e257:81cb with SMTP id 46e09a7af769-7f461845b89mr1874530a34.7.1787260933167;
        Thu, 20 Aug 2026 14:22:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f440023019sm5816925a34.15.2026.08.20.14.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 14:22:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix copy-paste error in WSL EA length accounting for $LXDEV
Date: Thu, 20 Aug 2026 16:22:10 -0500
Message-ID: <20260820212210.1475817-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The LXDEV block in cifs_query_path_info() uses SMB2_WSL_XATTR_MODE_SIZE
(4) instead of SMB2_WSL_XATTR_DEV_SIZE (8), undercounting eas_len by 4
bytes per $LXDEV EA.

eas_len is used only as a zero/non-zero presence flag so there is no
current functional impact, but the value is incorrect and misleading.

Fixes: 97db41604555 ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb1ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 7e2b29060f51..3ac4126267f6 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -721,7 +721,7 @@ static int cifs_query_path_info(const unsigned int xid,
 			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
 			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
 			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
-						   SMB2_WSL_XATTR_MODE_SIZE, 4);
+						   SMB2_WSL_XATTR_DEV_SIZE, 4);
 			rc = 0;
 		} else if (rc >= 0) {
 			/* It is an error if EA $LXDEV has wrong size. */
-- 
2.55.0

