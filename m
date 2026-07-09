Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780D4335BA
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555570; cv=none; b=lA9RH9DlgFgL41+YM6cRCT27B50IhZYm+NTV0P0+fn4i+145eNOsbCiIijB//rnywNNiNxMSS+g6XMs+CVog8byOJZxfu8wCjBg2//TAYuSTLSI9gJJ9IPgohcYwn+65HjR5UTzzbsVNssM1Zb/lEyxiVZZQcXuJ2it3VJ8VGUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555570; c=relaxed/simple;
	bh=bhNg31cldVpu+mp6eO92bk1i+/neDrWKp+MngMx5pAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI1ZOFt13EXZwL9iFW7LFkdmplKXZvbTRI5Eguaz/RKbTueTvPS7uFporFNpSLt52k3m7Zi+cuCJeFWxxmMKl59g5XDtS/tvo4Olij4Uzhu3crsmYzMbfR5m3wiaKsvZedCIBmOPy3rjMvS99MgNUeNckwr45hYMhcal7ykTlLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o88jZjz1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o88jZjz1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493b61b52b6so11958755e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555567; x=1784160367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kbxt0d5MOq5lgdQ5FR5WepFI9qvG+xYexi9lmSoIA+I=;
        b=o88jZjz1jB5g44KBtXsRZSWj9mb8LyZgIQ04+ZUSSLEHh6zgeTXos1vNnHHhrrhYiE
         +xSAmhhjBZtEGAAt3aXlMNydfmM1o0ahB3zp3UMeYP8ZC2gXkzfhstRNio8YwyCL2FVD
         AknvVbcb5n9S45K/U3JxTHz6iAZjvv5m/iQjluW0X8IfS8xJ7+xOMQnmXEetgYCx3OpH
         a+n5o7A8CCLNFgLyJOWw0dEdXDrZFnJieznREzJVFyimTLC7PkuAUV5091Ubz0QgScvq
         1WuIJ/1q6pLWd9BQ0jqxOuE+n5LCurifg97HzTB12rbAQInJkJ/h/y6U5FkTv9eKFMKm
         CGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555567; x=1784160367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kbxt0d5MOq5lgdQ5FR5WepFI9qvG+xYexi9lmSoIA+I=;
        b=fhrrbzoCrW//U/R3xKG7Zmg+78O8u+MRrGX6d0ahcokG6YcrQp21Jdjenwh7/iqUVO
         a4+SOfyYXzvhPcyRej083L+0flKcP/GuyEEY1etd90W056T2Eee8ll9JbeKJxJI9Fp22
         cpPYd9V68EcrtEcgJUcGUK8WXHSgx9EtNIUbMo6+eGVUB+GE0b/2OgSAwfaRnPPifyZA
         z2kiy2MXhe2iiQu3N2tUhMbL/SAvZt4KNyg6EPGS6wtCmrVkcdoaDanFBLTF6jYu+xLK
         sL68ATpXbo+4KBqIZMYdPPaTdRU0pRn+wlU9ooa+0SrOiMXvUSbs0XR671mlej+l1oI9
         Lu0A==
X-Forwarded-Encrypted: i=1; AHgh+Rr73P/zUFNoetyRlBFavhd29CN6O7urnjvBUV2DzCyOaF4NTk5xXmNQ3uEQj87zbUMhIvpuHZoDiX/V@vger.kernel.org
X-Gm-Message-State: AOJu0YxLJ97zbwUazwCbkyOstw9tOZo58j/dxyDssk4egKL0UFiMM7bm
	jRO4D+a1YFkwSes/L9iLU8ItgmEm3lhqQt0qNqloI4fZKYsuqUn3x2MRaQ9dWqPC
X-Gm-Gg: AfdE7cla5jAMN8w93ImmaOBFIEZhrd6EDdpGGSR7YULjzwoq3p54SlkNikAr7m6c59h
	8aYSb3XKQpRtaxF4lCfcyq0ajFvTeiq7vHXFJ85DP0/Ro2rLrzsOaT1IDVWFqgA+Sdj+LkX6WJ0
	9D0UmoBpObhkmPLcg0VA/XHUF63B7QeFucf5gTYEbC/VQ9QxbnMSOIgnbcXE379pHXaGoKxPY1B
	ugVbrdiG8jvgzMw3UFtwd1l2ra4wqNY+m5hnPEdck8qmCips+2iy2FxFT2+O+8JtqNE41TTy/6C
	kd4n9lhbzY5DSClo1SEwkUH4tjy7OvN/uziUVTFAUZvFHzeyB9NVEJF6/KBckKoom3NJfvcLoxj
	PYiOPefHz7XvAZ5z6FkXsuzeMWeXn4JTFiMlMt2iVBjmvTgGDVP29fNfWbQvONZOJZSu4VdwW2D
	qOA+aX5JqdADzluZSyJzvP3S8RIT5xXxYs8qM=
X-Received: by 2002:a05:600d:2398:b0:493:e006:3153 with SMTP id 5b1f17b1804b1-493e68d667fmr30545365e9.34.1783555566548;
        Wed, 08 Jul 2026 17:06:06 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:06 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 7/8] ksmbd: don't check directory emptiness when deleting a stream
Date: Thu,  9 Jul 2026 02:01:10 +0200
Message-ID: <20260709000548.66445-8-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
References: <20260709000548.66445-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

set_file_disposition_info() checks S_ISDIR(inode->i_mode) &&
ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY to refuse deleting a non-empty
directory. A stream handle's fp->filp refers to the same underlying
inode as its base file or directory (streams are xattr-backed on that
same inode), so this check also fires when the target is actually a
stream attached to a directory, not the directory itself -- deleting
the stream then incorrectly fails with -EBUSY whenever the directory
happens to be non-empty, even though removing an xattr has nothing to
do with the directory's contents.

Skip the directory-emptiness check for stream handles, matching how
ksmbd_stream_fd() is already used elsewhere in this function.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7d7315e34..818353ad8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7272,7 +7272,7 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 		if (ksmbd_has_stream_without_delete_share(fp))
 			return -ESHARE;
 
-		if (S_ISDIR(inode->i_mode) &&
+		if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
 		smb_break_all_levII_oplock_for_delete(work, fp);
-- 
2.43.0

