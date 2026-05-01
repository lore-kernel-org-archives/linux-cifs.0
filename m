Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7363A39F185
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634435; cv=none; b=YN0N8Ul4cJunsjBk/0vNV5/Nd+B/kbZz1EXfI48GGV4Rj2c9mSzixPTUWM1HrvgvftTa6a+NpvsPMsadWi3tMI1/sdD7eK5vPEmqojqRvz65qCVY6k3WnrBx2Sj1IZ9EQi0HRr1NOcjuBcXfN2mYAeJuZqZWHVZZam90mPWRL88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634435; c=relaxed/simple;
	bh=8qx2DRUX1B48lgDcMV0H/JoKZ5REdvkIb7aId73YRXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBG2egKmk1zSnXSY+uR4dRj2Vy4VeRufifrff8Gf5tIiD8eX0I9WPQ7Me59ayeIix3P39Bse/tO0efEI/5xNIMa/b1fCzIfMbEnzyz359FSMVM8i8HkO1p481MDOtRN11REYsTnsPGVXMazKYmJ9VfL0J51hfxxhfU75FR+Hk4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pyAE3tWa; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pyAE3tWa"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8296d553142so1244073b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634432; x=1778239232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMpfJfDPYLUjScq5XH3LfedUkhoimyWrZal8ssI+6ww=;
        b=pyAE3tWa4H76IrY1V5zhrKlgEPf8fz7lqrhU+L4fmmOWgQHbT2J6YCMlBW77Ma68oG
         cnQ8KnPJcUHKoY+RWeuMBlODBnV3yR/P19x4DCepwcVIk31/NaSyZUd4QHSk22DhOmBH
         PcIEYvHIxV0PN7rTgFB/JNdEi92kp4pna5lmD1rf/jKAIIGe0pMBlKgKeHDNBTQ4YIHC
         dFLbA04gpZFGh5Dw9pr5j3ghDiOjXSDMDuR0ws6mJy89ziIsFyV1R+dEKSvA2wmNhS5v
         rJ5D39oiwZ5PV0tTG52+0x2ew3WYp4HnaT+m4j9Ay4M23tXPfsWvKeUFzRUyajMunSMK
         xolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634432; x=1778239232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tMpfJfDPYLUjScq5XH3LfedUkhoimyWrZal8ssI+6ww=;
        b=mpuUYbdPA/47Du4IrXfZIXFDd/SJsDxtazwi7/Pa4ujEiXPHROf+X3SeteJiPetjre
         m1D42qv2FhecE2plWxtN6/J3yAyxa74O8OT99OZJ4mJ3cnrWmU9mItDt/IsR834/fpis
         00YYWKB3c2eJH1/5Jv/aDsUhOsz4pjaRN7bfhzuGhClUWNsd13y4JzPDJTr7hXodhAci
         tgo3383JSqGsLKm/05Mav2qxI+xTNz05JJ+UVu9GinspUWNxtqEn/fkI0hcv6CH9QVXr
         VmbLh9V56r2xPhJiRNxbu99IGs8mMsvHwuySzI/OpzJQsQS15WVrjAxPwQ25K83Bj3Lp
         DA0g==
X-Gm-Message-State: AOJu0YxuMU+6n6yXsZLZOjtITPkcYGaT57oyPBsCl9g1+xQL+/to3/lT
	vpdUmZVnJy7AtjNDijrhnlF9VQ1HfD/ezC5ugTYLIu8w7fNwyk9JKq6ZQmEdlQaAwtg=
X-Gm-Gg: AeBDievusLKM3bG0O4HWQxhPWJZZaBtxZoLuY5tH3Ml/fZKUm+OvHnRdOIxyFpXXf2K
	oyAhTAJ4BadF+7ff0VbHIM5aq3A+MGFipczjCLe+sU07v03BjyWPihb5Az/JiVmw9RaTt/sMC0u
	ZKTAgNoZqaZA9Z7E+wk8HrWMCf9/9bamtZtq35Sc6gDbXlK+jm22qkuQRvW9wmMMHsIFMPbCbQd
	U/S9KHqenHlzn0At2JrqiPObXhHZte8NSfp1SlaIfwZq4n+m8sJI3jSS2FWo7dQjOCXmd2RJ3ng
	wVLeXspg3tx/5xHP4kj6a6XR5Zj4OO4l+i6cS1cjWMtxS397Y/w0btWbqr/mbEdLdDoFR+oFrK2
	5rteAfT9UWExjLV8H11s8G8ZmmKqU9CzO3a5VP4FzwdLxUho3ZPbBuphbiIwiBYCwvBKTNOYXaX
	yd7oQFD1GDPxOnu8WRQHfFbTPJKALpb2Ug6oaFSq4GV5JtpKB1rfi6OcyQzQRkMdw8
X-Received: by 2002:a05:6a00:3d51:b0:82f:8a29:e3de with SMTP id d2e1a72fcca58-834fdcbcd85mr7927940b3a.40.1777634432321;
        Fri, 01 May 2026 04:20:32 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:31 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 02/19] cifs: abort open_cached_dir if we don't request leases
Date: Fri,  1 May 2026 16:50:05 +0530
Message-ID: <20260501112023.338005-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

It is possible that SMB2_open_init may not set lease context based
on the requested oplock level. This can happen when leases have been
temporarily or permanently disabled. When this happens, we will have
open_cached_dir making an open without lease context and the response
will anyway be rejected by open_cached_dir (thereby forcing a close to
discard this open). That's unnecessary two round-trips to the server.

This change adds a check before making the open request to the server
to make sure that SMB2_open_init did add the expected lease context
to the open in open_cached_dir.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 04bb95091f498..64e22c064fa0a 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -286,6 +286,14 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
+
+	if (oplock != SMB2_OPLOCK_LEVEL_II) {
+		rc = -EINVAL;
+		cifs_dbg(FYI, "%s: Oplock level %d not suitable for cached directory\n",
+			 __func__, oplock);
+		goto oshr_free;
+	}
+
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));
-- 
2.43.0

