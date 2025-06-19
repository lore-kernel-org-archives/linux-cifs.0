Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B15818024
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750347366; cv=none; b=eoLyBQckFJBPG8NhWihYILS/V6yN7PyHC66pHEJ2SNADwA0mzbHInMfLNjx73+tyZxBNdZQMly9Ap/6y/0Smc/W+ZDiA6NE9AytQ74xi1YQx1cCFjey5IfqQw52CmoL0fbDn3Ft6nJi3UrFH4hdtihEupDG5SwZE3599DyCVc7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750347366; c=relaxed/simple;
	bh=0cWZVh1DnDmgtRRclO/Rq8SYgkk8Z9YOtu7IV9etMkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XV/TnEb/7Iicp351e1LdEIxKKQd1LcKQfl6YeF1we7/VI7AFxjCYHe/EFVZ2ci+l76MHT6ZTVrNlHY3Yst1MtYk1JTPE2XFvnHDhLKxiM9zE6a2B+2umcKUNQyidzrWkO69mT5cgz4qEfTTd9NbgtURGQRCH31OBUy2XW5x7ug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cJWVO7gC; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cJWVO7gC"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-748e378ba4fso1150792b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 08:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750347364; x=1750952164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CTJnJaUuZ2xHV0DzJu8wPKdEDEt5tRdn+2X5Ga6KcwA=;
        b=cJWVO7gClWSDFdBw6kWajh7HfkyRbVNHaKFssxHvZ+Qpoz7yAbmvKi9BLeniSyuWJF
         wAi0v1veXpfWf/d583t9D5F0ydVm47Tm4bNYZish2GCJfUn3LskpwQW7jNcd2br/EUUG
         U5gExNMUdX8KEzXGTPwxQ/Bwn239VC58ISZb0YiGk873iSX1TQ/9ibyLnUK+aQwatVOF
         xqS1zYyJ8hJGuNOPi94yldG2qfHnj09gTNCmYi21A9+xLUxsJWNhXmHCQuK85RENHVM6
         avbeoI5NuR5E4rPPv7dGV5UTKLk5sq6ZHmwagv2X99D5LfiYFqKQN6jjaslIHSmRZqcx
         Znkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750347364; x=1750952164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CTJnJaUuZ2xHV0DzJu8wPKdEDEt5tRdn+2X5Ga6KcwA=;
        b=JTJPO9weMFq3fonU1LcLfmchVHquzd6oK3lLh6dkf9VpgIV1P9djFFSpgiDqDD+mUm
         LeXK8jgRwSUoZaMJqbfqjgWltWlgEWMyMGN2CkZ+f1kiTfftQ877OhJaCtdq35Ps6J4u
         4zIEFlwTGk2dewyov2AbQbOageuWzEzSPAfMhqVGsnUPWva0Gvrby//Yi8XP7W0sireX
         QcYaRsL2a6dy1scoRC4RF0eVlzC+zHMkO9RDvEYHm3HOK3cniaUpKU6jdXl8yyDrlLuq
         b+dkGzrlfyaPdA4D0jvp6qoaYuOBmWv/5M4IG26FHRXNsk+ay2Zlk0eX6nFmv+D1HpgP
         pvdg==
X-Gm-Message-State: AOJu0YySeIqs6XwzM1rJrq+elJYMmZDCoD/tfX5wo2Qobr1KKgIzn7tN
	Aq/p9wONDlPllcCeZLiikkFcNjXw/jWlc/fPI4Y5iAp77OK27edWM3x8D5TcPtNE
X-Gm-Gg: ASbGnct4fgB+3gnuwQ+SY+Oil0FEoFA9fVD8Pyjevmg+N9jJd9+9ki8AL2WlgSWMyvJ
	azQ0kX5NDdyToYy1I+qYy2F/v9nfJrWmI463QYrYawYMNE48DoE2aPpitMh5+C9GtXLfxV2OUmE
	8ETMMbXnLbRrRCiIIN+84ctrU9DZJaqEnWyiZ3lWcsdbp+ogKoWwuAEXH814k0XuD2KRjtPTZvF
	GyAXBmN0P8E2lRTyq2Hi7Zo79TxDEYYWFUxVaGk6o9WajDpVc6nMMdEbtpafk0qrvCTxMsdWpnG
	iqV573VmwCQrBZBKiGAxNsGY5UcytuJh3UHGxpxeMhtAsmmvgPAV/74c8Sbq5jHpq7o+hbV2jL7
	1pDce8HOLetd33Ca+zCpEh4o=
X-Google-Smtp-Source: AGHT+IHmWYvz2qvQYJDl2c9cLnQDcXPafp9kXwWuNqU3Cwx0oyYS49QDQIoaaoJsawlJflq2QViMrg==
X-Received: by 2002:a05:6a21:9ccb:b0:215:eafc:abda with SMTP id adf61e73a8af0-21fbd4d48f6mr30825024637.18.1750347363956;
        Thu, 19 Jun 2025 08:36:03 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.253])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7490a46b574sm162838b3a.15.2025.06.19.08.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:36:03 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 1/7] smb: Use loff_t for directory position in cached_dirents
Date: Thu, 19 Jun 2025 21:05:32 +0530
Message-ID: <20250619153538.1600500-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the pos field in struct cached_dirents from int to loff_t
to support large directory offsets. This avoids overflow and
matches kernel conventions for directory positions.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cached_dir.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index bc8a812ff95f..a28f7cae3caa 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -26,7 +26,7 @@ struct cached_dirents {
 			    * open file instance.
 			    */
 	struct mutex de_mutex;
-	int pos;		 /* Expected ctx->pos */
+	loff_t pos;		 /* Expected ctx->pos */
 	struct list_head entries;
 };
 
-- 
2.43.0

