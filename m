Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9A919B5BB;
	Tue,  9 Jul 2024 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720537094; cv=none; b=g3K++pAB5CEHZ9C7dFULjDMQzKpRN8DAMJIK/tls1S0kSwOMde26KjWWPzhhaBg1w3Qrz/7NJuqkzybQ5CKhDAXehO7hNOptdM1Yr6o/YW9abryY1A/qfUswt3R592RvXo+jYZzMJt29x7g7HZhClvMrhti7Yx5e5T1P5cw+WVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720537094; c=relaxed/simple;
	bh=nY8+xvmsInEI3IOA7nCHv3bo7hczGHl37Q5vkMLMWsk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=up3xQSQX43oI+lY7/NLd6txLMWmBfPthQOXg1lG9md9krdO/vqh8Q9C+yyMp3w6qKovnbcdZfGkWS8S5z4D8kf5zsr+6+pmYcd9s2YpMw2XVBVYn4m+4v1FCYUs+oJZYgU6eCFyrC7FLu+NuUFgk7W1kfM+wB+6SJFwpGoIIKoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jz8VA2l8; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jz8VA2l8"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52ea2b6a9f5so5519564e87.0;
        Tue, 09 Jul 2024 07:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720537091; x=1721141891; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aEpWpbi2vCRpaJ2fwVAL3KSelE0/RbdGtq3ZazN7orE=;
        b=jz8VA2l8xuuUvqBlKbv5FJkGHrtOF4DkYAD6LdeiRqSDYUGOTCLer1WFD3cpt4V1n7
         RRhANEFB03A5jBTnSsWUn6RIXcyztUakxF08VfPzuvH4K4zvdseDE7hMU1MT4f8bhyMo
         R9de/hIqlu6nEtjrXRLQzeuIeqmV5xXOhHOpjd/kP/1SQ5Y/qV6tzozCJfTP9hDwDcWN
         13/19I/63LK24fDOzbpJWZFFDx1VnVUibD0sfx3iyKA42o+6uSqYMejXqEpN166crpUw
         zCbqqLHmJ4qUq4hJTAKHWhKu1NS39MxVHvE59nRY8Hkex7MNA9LMo/bo8sBoqmm/LyhW
         PGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720537091; x=1721141891;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aEpWpbi2vCRpaJ2fwVAL3KSelE0/RbdGtq3ZazN7orE=;
        b=Gz7na8lfC02d5MX19BETWSeZnxljUb0mSH8SbjBl6gtImzmzNT1h8Hn+zTkvxZtCTX
         AgAWyqA6BhwYAC8HD5SNTBUFhAFmlfKFltK4o4TRVLbE1dSBzGwBgWIiKChgjY2tk0ty
         kTPJ/XWV11yRVS0xXWzPYPS72Jya75Pblyq+A9U2Mu54K6sobxOWjYCpkWqcEhHYClPC
         DE4eScZPKmQJQliFOp5bjso4w5My9+GenUayQMbgc7XJY1rbiGbbtEPA5yTeViGKazub
         3JwcGK8WGsxc+GIjAJuSAXhFFnFNudqveaC0G+XEUTbBTFh4Ga/Q5xu5hB5QjGkLMc7t
         ocUg==
X-Forwarded-Encrypted: i=1; AJvYcCV5I6LDhAWBWRm0D4YHFDjFPs9MxcBluxge8c6mpH5e1LmVUh+RyJ1UtsrRtGuPYRnsKLFadYqPp4c+/0x7rvzzCNF5mr7lsj5kcjuB
X-Gm-Message-State: AOJu0YxBO+3RgY3ZThdODMo+2oZodF5Z8Po8BGQ39n25nU6TuANGXlfh
	LsHILNlaI+qiA4z0B1LgprSvMFCx4+xnKX34HG+fisknX6nIacVi5YJXpyRw/Cvrxq8d1yaX86x
	UPrmK6mLE25U88n+I61OmSiiQpKx23IUP
X-Google-Smtp-Source: AGHT+IFQb5SlNR9pHKWIvFEDZGC0KZxsb2G2iUidk5UD4i3BtnKn0YfMLNprw1FkLUDu12/neBNAT8HLSAnQogQ2qOs=
X-Received: by 2002:a05:6512:1319:b0:52c:dbc6:8eb0 with SMTP id
 2adb3069b0e04-52eb999783emr2097613e87.21.1720537091137; Tue, 09 Jul 2024
 07:58:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 9 Jul 2024 09:57:59 -0500
Message-ID: <CAH2r5msc+xJSJcGhf+bV3++0M8g1C8f+oLLwA2R2G_cf_6S_8g@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
22a40d14b572deb80c0648557f4bd502d7e83826:

  Linux 6.10-rc6 (2024-06-30 14:40:44 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.10-rc6-smb3-server-fixes

for you to fetch changes up to e2e33caa5dc2eae7bddf88b22ce11ec3d760e5cd:

  ksmbd: discard write access to the directory open (2024-07-05 09:56:13 -0500)

----------------------------------------------------------------
Two ksmbd server fixes
- fix access flags to address fuse incompatibility
- fix device type returned by get filesystem info
----------------------------------------------------------------
Hobin Woo (1):
      ksmbd: discard write access to the directory open

Namjae Jeon (1):
      ksmbd: return FILE_DEVICE_DISK instead of super magic

 fs/smb/common/smb2pdu.h | 34 ++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c | 22 ++++++++++++++++++----
 2 files changed, 52 insertions(+), 4 deletions(-)

-- 
Thanks,

Steve
