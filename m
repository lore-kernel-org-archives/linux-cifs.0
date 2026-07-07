Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92D13D9DD3
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418479; cv=none; b=stisU20cNhe2fclqeWR3prHK2iHfbfyO2FP5mJnXQqpItduIU7GwG4ywwO0jj46KJ8mlt9jyljceqNXoBdkeiNuhETe+qVExZRgoFVkkeeOGHwGdMPZE1RpMHG401tWLDcM6JaoE5KMOklAGxgqWtyBTGfcuqE5OTvpyHI3CxWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418479; c=relaxed/simple;
	bh=tno8eSUXDBY2fqLPv0oxCvj+N85Q98SSY7xy8G7Wz40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=czGm8UfgcNLLpxueJn56Lg1rJY2DbYa4/yOCDvQGnxCsjn9csCG9Mf5ODXw4AxAzpHApsgkNu3zZM4rL9dHsviBiJJD5MTQty1hUfLcFDsIvkCKZvPMLVg8jJ8itG0kq3WtqJcMWwaoTJFME5yOndAdZB58fcEh9xKgKrRqlhVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dm8mqv/W; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dm8mqv/W"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493c2c0b9a8so34982675e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418476; x=1784023276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sfISjCZ+9Y3UW7Cq0TsRBOKLfdSwoKWiciOw5tqJkpo=;
        b=dm8mqv/WiM2x3qlmiQxBhW5mKQM1vKiOLEG35Lxd0C7uUa0KMl6eK7Y15wSrjxNJcN
         DceauAWw/8f2aXi74H0HKZT9Ja0zSLtgbADsSHrzhTwD7albs5XCv9iaNiszxpkoV/kj
         66I0181SwAtrk46EuNNymhJtGP917A8CrR+ksAbSMUcRSrAX5hjtSFU//ek//GMNSVwA
         ML/ddsx+o2NKTds+nbAZ2xBL54GIx3CvuyElK9JGu6yaLRv3Ef9zMJJF4UGabQtw6Iux
         3DbaK+/yteqNE0xKHjKTnXvFxltKm1PtYpaLD6ylJK3MPtkxcu1h6OvoZPME2qylVlvN
         71Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418476; x=1784023276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sfISjCZ+9Y3UW7Cq0TsRBOKLfdSwoKWiciOw5tqJkpo=;
        b=sDNJ6nlNTXPumDmfdKfAJsL0utF2sewKIE1MgTcwRt2OKi5P9rNxDAl/j9sO0zBsni
         nORSVPdk/H8DwnA7KXq+ZMxZjR+BS9h3L9T8Th1nNkGZmWj73VMr9jinH3o1ZLq2+x6l
         1aGa0/y+uzjP2ODTvFXXLUbzc9XS4zI7GNDC1N/redVqWOxm54bcbYIFv0S3omG9c/3f
         GBYpCv/T6SXrVXnfCExmyfVqh+aAYhgWHaG0taUiuix/iM4B6ZUA71C7V0bpaFJGKkUR
         YuruaXSrgpCdpQrSdRoAmdb8jFVMSDa8pVpIlBSSii48+1UVth5xns7P7ThWF2awRpjY
         4nIA==
X-Forwarded-Encrypted: i=1; AHgh+RoUsxXaNXSdWjcdCfRwRdGZ3qwwKEIsY7Wkv+zVHVSk9HYJQaGUf1+EVsI0IZUxsJ+wc3/dolagWhfy@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb9U6aWxTQavidORw0qcP6Fin3F61lV5na8niqf5SThjksLGrs
	T37NGIpEWQaKF3XCfwhW7nb/u5Lkyn0PgpizKWkC+EfO7tmvKAj4AXx5
X-Gm-Gg: AfdE7cmav7EWaBLFjUpbUKevFlK4UaJ3xLy7h3NXTs/n0h/ReQBSPsHoK4560v6piw3
	pCm9Q/lJqBmA8Ypg6WNmearmLZw7XlOEC8KXoGLI5PkGVuUhZTQ3tiVQzpeZt/fSbRA1hh9z6i6
	0hPGF0Ci+8q/ZuuwFcPv+GvqagV9xu1bGJNSO7xZ6abB39TO6Z9NC1RuNq1IUNB+uJnLLZdyn6Y
	gE51wNFrvwwPykfiXNnT1Uz0+yKXrur+mozI3bJNv8ftQWGwThEC7TtHfBCqPCKvItnIG2ATYQt
	yPOHJD0Ol5iuzPGbfJU970l/yUJ6dxZ/Ovhyf00aXo6mLcv6bnBD3Tw4G/ye/wHbRUXb5AwtlsK
	tahdbAcxaItj52Vqy0d/DU0Ghbc0UDdIjR2qFk9is5wrY3MJo3an1YwEpX8rhBs2f+0UouKNXIn
	tSSGGdUDpBPEC9lcxz31oCiaYAT7iprTXus2U=
X-Received: by 2002:a05:600c:1550:b0:493:bf84:53d8 with SMTP id 5b1f17b1804b1-493df06a55bmr51942375e9.9.1783418474742;
        Tue, 07 Jul 2026 03:01:14 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:13 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 0/7] ksmbd: assorted fixes found while adding macOS/Time Machine support
Date: Tue,  7 Jul 2026 11:55:00 +0200
Message-ID: <20260707100033.47512-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

These 7 fixes are independent of each other and of any Apple-specific
behavior -- they affect any SMB2/SMB3 client. Found while developing
and live-testing macOS Time Machine support against ksmbd (that series
is being sent separately, based on the same tree).

Two are worth flagging specifically:

- "fix COPYCHUNK for ADS streams" and "report actual xattr value length
  for stream EndOfFile/AllocationSize" affect any client using alternate
  data streams, not just macOS.

- "fix off-by-one rejecting minimal COPYCHUNK query-limits request"
  affects any client probing server copy limits with a minimal
  FSCTL_SRV_COPYCHUNK request (ChunkCount=0).

Each commit builds standalone against ksmbd-for-next-next and has been
checked with checkpatch.pl --strict. The underlying bugs and fixes
were found and verified during live Time Machine/Finder testing on an
earlier baseline; this re-derivation against ksmbd-for-next-next has
been verified to build cleanly but not independently re-tested at
runtime.

Gael Blivet (7):
  ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request
  ksmbd: route stream FileDispositionInformation through stream delete
    flag
  ksmbd: report actual xattr value length for stream
    EndOfFile/AllocationSize
  ksmbd: return STATUS_OBJECT_NAME_NOT_FOUND for unknown IPC pipe names
  ksmbd: quiet mdssvc RPC log spam
  ksmbd: fix stale sparse-file attribute after share reconfiguration
  ksmbd: fix COPYCHUNK for ADS streams

 fs/smb/server/mgmt/user_session.c |  3 ++
 fs/smb/server/smb2pdu.c           | 79 ++++++++++++++++++++++++-------
 fs/smb/server/vfs.c               | 46 +++++++++++++++++-
 fs/smb/server/vfs_cache.c         | 32 +++++++++++++
 fs/smb/server/vfs_cache.h         |  2 +
 5 files changed, 144 insertions(+), 18 deletions(-)

-- 
2.43.0

