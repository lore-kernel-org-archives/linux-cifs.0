Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD671BB684
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723816875; cv=none; b=n2wgXFhzY3mYMkegU7w9tPQKj0IPcGINcrqOH8uMsRRez8zitqKZgaDl8PTee3suCyvKxVtYgKgGSWsZ1UQ5HQXf3xgo+WGu4NdJVP/q0O67PutIwlG2YuBomvoPw2jNg/9+bni01koIuwID3qKaUGScyxJ4kO10qgtiv+ctAD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723816875; c=relaxed/simple;
	bh=4xMB4wV0bzU1rWl4OnYy2ycpN99cfvkyKF68IIjc4nY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mCDI0JxiFVfTiidkVYWJJfMxTejpPA+b6IgJkdJbJgVPBCjggij4NHBL3CIr4UjHS7ZqiGSLaJIWWCpAhszMDpHcaofzDYeRzLlNPxX79piF0ecY1i1fVqUZU0iPJZNOAiPVmyg4jjNZgAM0FkShrT5vGw6P1uE576ojkmKOM88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=VNV60IEG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="VNV60IEG"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-429d2d7be1eso10581435e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 07:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1723816871; x=1724421671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9/5X1k16EYpBBKIpPGRfGv59lkLEqMb9uiWXLCIOeeY=;
        b=VNV60IEGT3jiUfTVlRFSFRE8Gr1dcGpq79zJEti8jTtlq8ZzwZBJDrVHWJd3CYkmMy
         GIV7fZltBET8WaMOvQDT3n4y9YpHVioQX9TMxd21vZYLgCVJAygDYY4d8YXDqBxLI/MF
         XpzzzxF9L+IwL+LmUOPSewtP8YKywGIFQY74n0TUMIPg95AxvZk6nJBcw2MyXqRLNCR8
         pVfqcR2VY/s75NarnCWhOgC0o8cdama1rvLfFQ431fCLc6gTXKzAapZWf2B6LYGXoDgW
         00A7UO1n7IomTHMz2H+ELHNqT4GdkM0y/ZGMeyUltLEDd0SE1iXmjHK031BAgIDwQB0+
         uQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723816871; x=1724421671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9/5X1k16EYpBBKIpPGRfGv59lkLEqMb9uiWXLCIOeeY=;
        b=i0hCnJh0o6oPmlMgdXWc3ZCwo5Ir4JBj3BGdjiIjaje/B8trmk2nNZVppIOFyfxWJ1
         wCwbWumpJOhcLd9Gb27rmlL2FjFCjpKTUc5vr4enqVmE+JTTZDWbeCwRwOXpwM8LWrvG
         57r2hj3i/LmP88B/2/5t5FmBe1iCyjukYbHMZACVPsyit7DAhZbduP0dkFpRpraXitXE
         ZE1oKPz671N8fqgQAqZOco6Oq8qA7w2aDPYMReerzQsdQf78Oe4yKra/Kd/+cb590q3y
         V8IPfVrWkXHZrom1AGaPzs6RQbGTqCSDa3U+yZgmEQ0gWJfCMPVQK641HmFd21xeQ4BG
         kj3w==
X-Gm-Message-State: AOJu0YypQnMV/8A42kCk1LhVhAkgdmJejUsiI0uUTyvKq2BnTCVODu63
	V8TLz4kqj9vyaAna0FtjlgSHpOQ2V57g3gEbwtmRX5mEzg7TuAgEg4a1sQNs/7I=
X-Google-Smtp-Source: AGHT+IHx+E8JE/2sKI2lQ5yIMDh/ro+6Qr4zAjLgFJ8mSlWxe20T5N1HUAwL8t2W9oFxj9a6JIvJCQ==
X-Received: by 2002:a1c:7909:0:b0:42a:a6dc:3083 with SMTP id 5b1f17b1804b1-42aa6dc3617mr3806105e9.13.1723816871234;
        Fri, 16 Aug 2024 07:01:11 -0700 (PDT)
Received: from debian.fritz.box. (aftr-62-216-208-163.dynamic.mnet-online.de. [62.216.208.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded299a9sm76182895e9.18.2024.08.16.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 07:01:10 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] ksmbd: Replace one-element arrays with flexible-array members
Date: Fri, 16 Aug 2024 15:58:25 +0200
Message-Id: <20240816135823.87543-1-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the deprecated one-element arrays with flexible-array members
in the structs filesystem_attribute_info and filesystem_device_info.

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/smb/server/smb_common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 4a3148b0167f..cc1d6dfe29d5 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -213,7 +213,7 @@ struct filesystem_attribute_info {
 	__le32 Attributes;
 	__le32 MaxPathNameComponentLength;
 	__le32 FileSystemNameLen;
-	__le16 FileSystemName[1]; /* do not have to save this - get subset? */
+	__le16 FileSystemName[]; /* do not have to save this - get subset? */
 } __packed;
 
 struct filesystem_device_info {
@@ -226,7 +226,7 @@ struct filesystem_vol_info {
 	__le32 SerialNumber;
 	__le32 VolumeLabelSize;
 	__le16 Reserved;
-	__le16 VolumeLabel[1];
+	__le16 VolumeLabel[];
 } __packed;
 
 struct filesystem_info {
-- 
2.39.2

