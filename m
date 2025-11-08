Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778312253FC
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762617447; cv=none; b=RV11caXs/IkhmUCquoz9EUNWmw9ev+ge+mQ5fTOzyItNYP0OyvAYuv0ym2P+3paShUEGkyMQGhk257GWHjj6U4FpOO3yEu+jW9kVYegam1/7oaRYgqDuP4jNEOKCnrOwtvnkisd+MDsSb09Jh+Pr0oG4ciaUsY2JA20DykIChfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762617447; c=relaxed/simple;
	bh=1B6qJxhbK00jLGFc+/1YeYK+A12GIKfCTEsHFV4BWFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MZSgmLctyo2tR9BbEDmFqhgT+z7KFF+5rEUWa/zDEP/YCA6fTG4o/2so/Sk/doBTvVGzCyHxbTUTiCUDge5edsR25bZNuDarNxucGRO+726iLoUJV0Bn5GfISswSS9yZO9HD9ZoGamVeT2KlwkWBm/Bzfr2iGVQh1wXBnFA2/b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPhw8UE+; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPhw8UE+"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3436b2dbfb9so63642a91.0
        for <linux-cifs@vger.kernel.org>; Sat, 08 Nov 2025 07:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762617446; x=1763222246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UF04VjpCgrtM4AACwnQlzOMrdSH/wb0uO//xFFcApf4=;
        b=NPhw8UE+uGSqouH7donjkwGs8XsLpQPCFsj2zK/upWEoCA2ckn30uTNztMiwWsFhwJ
         RUi2UQud8H7gjTorRjPKJk3d+uzhHRMvAauypLHQl7EaUI+tUKLZWSgnVfT/uta4R0/+
         x6Rx/HLFB6O1QQfqF1rjozka19gFNDSTcYp1WO7iGAg0WvjLPRZfFvuGv8bSxHzJBgON
         qXLHdGuLUb1CTUuCjirhLE1U+JrmKYfEF0WmdHyc3uqrfT1fna+Q7v63lktBZUM7MV1Z
         ZvrFhOiMY6IwvPKDRPE62N9WzDhQfBVMobAD6rRpo9bgWB+KW0INgiU19HnPEdMhWXvQ
         uHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762617446; x=1763222246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UF04VjpCgrtM4AACwnQlzOMrdSH/wb0uO//xFFcApf4=;
        b=cqjQDgcFzGwlomt0FEp/wd4We04oL86+xcP4BCndWGrLPazmn5jrFHCQ8iIDESnxhM
         uJb91CsNpc52A7vbz+KKlnGhgqZSLQ/xJ4Vq85k7Wgjh4WDGxgSBgddZgiTFqZuA5jHh
         v+ji079bZgrlOQF2BZHOpfx55IHDMKFomJWfcAZZLhiNqYhdbC04Owo1psfXZYOQHA2x
         a1MmFdc7eMKzkkdOILN+e6zJpsXnEytU+hBY0EJiGK7W/vnkl9aZ9d5bBIt1rtQhcuQt
         U/NGIEzStRVxM3HtqOq5i9al8HRwmsBNDzwEfbDWnUNchw6/l2Qzi5hV03rnIBbzxDJg
         xmCQ==
X-Forwarded-Encrypted: i=1; AJvYcCV37nO4Qs3s3eHJnUHrdvmYCNrsVBKYFLAL3A2qC8YvVs6A7YXJxZdcAY1jLps5zoV+UlXN3EHkUwb1@vger.kernel.org
X-Gm-Message-State: AOJu0Yxulbwf0p4h0Pzw9fUQOjCENlLuCk0ge9/q1vlDcxOTJRrc+Uan
	VZZYUdALHAvU11tQTyWVC7I9yw81NOm/zEtHX30KNE651+I8goNZ1Nsw
X-Gm-Gg: ASbGnctt2uACp4BZz4VoKMGeroctCYnWkixDeJdROBNJ1d0xD0jcyLMvhW0hlkpp/48
	VCx37Mh+OoY0BNejcl26mrX1GzdlgUWVmu10j+4zAOw1OY3vHxAM9z0Ixl8Qn6xNH6Fc/D4+AKI
	7aewJIGcwj7/Sg88IPOwbtuKE5TGd7s4i1d1jXGhOXGAxRmKv7I5W1ekDNeOftczF3Amws3j/4/
	0hKQ/k1yZhabddwx6fwV6x3Nb/JBxZS8UcKXZ8b1/dIwH32mrDlZyGG4S2/8JJ4jXixF6PW8Ofp
	cfeYlgKiQlAjIleUm/32h6IVtOp4YawSgIynum1oG5b8+g5/U/hmR3+qBSzq2eDbJu/hzQPbiSf
	sxkG33la/Q/EXkTLp56zpOz5rXdQKPI/qkg14CbZYiMGZe5J9w0XFWkHfshHNM/ootSa+TtECx/
	WxUEIarvoWHk7TF5MN6GjIG3g3o35JxwW1a6/7LS/t9OOn8izC7F8i+akDt4HLDLOzHq+ExvT3
X-Google-Smtp-Source: AGHT+IH9LyA7/tnKICrBnlW9MvtAHS+5SqO+iVA2GT69gP6cJzXTVGRPCBtL5DJXPhM6hg6KNiVtoA==
X-Received: by 2002:a05:6a20:4305:b0:2e3:a914:aabe with SMTP id adf61e73a8af0-353a026aa2fmr1974504637.2.1762617445630;
        Sat, 08 Nov 2025 07:57:25 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba901c39ea7sm8200832a12.29.2025.11.08.07.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 07:57:24 -0800 (PST)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: gregkh@linuxfoundation.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: vfs: skip lock-range check on equal size to avoid size==0 underflow
Date: Sun,  9 Nov 2025 00:57:12 +0900
Message-Id: <20251108155712.384021-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAKYAXd-R8NGDzQ-GTM67QbCxwJTCMGNhxKBo1a0sm0XBDqftLw@mail.gmail.com>
References: <CAKYAXd-R8NGDzQ-GTM67QbCxwJTCMGNhxKBo1a0sm0XBDqftLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When size equals the current i_size (including 0), the code used to call
check_lock_range(filp, i_size, size - 1, WRITE), which computes `size - 1`
and can underflow for size==0. Skip the equal case.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2..d068b78a3 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -828,7 +828,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
 		if (size < inode->i_size) {
 			err = check_lock_range(filp, size,
 					       inode->i_size - 1, WRITE);
-		} else {
+		} else if (size > inode->i_size) {
 			err = check_lock_range(filp, inode->i_size,
 					       size - 1, WRITE);
 		}
-- 
2.34.1

