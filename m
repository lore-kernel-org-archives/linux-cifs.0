Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BE22F12DA
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659679; cv=none; b=DxcfA5shbYSNJuLfQw1zYKz74mo+J17WDEINCWtrK7+NXHy+GdeHd7E6eW91O1vWAyN458E9qGGjS1GK3tJ6RdpdmQR5Y7dil8/3baCMFyibV9bSDgCTcY3QmbDcL56DL3AKMc1t1FKHK/2QRu9tai4x5q8Ov7YGrLnwsUz7iug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659679; c=relaxed/simple;
	bh=jocSzeiCGrqKKX5qx37vHOCc60U+t8PiHlTjgPV3Tkc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UoPzan1MUOg1lGQqZs3OdGT3FKgTj/mq+z8eqA2/XpR+d9sk3Rc0eLL8rDkz7DS7KgqFe2uk1jHGhugVMg/f21zAbtt/xrCGlM0dDMV4tbbVZKuvotOYG8SJnuCwKUzjIKIxhqPKPF5jtLJstiHUE4F8BdVwxBw34YVea4LJyT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTIsYAiq; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTIsYAiq"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82310b74496so2356480b3a.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Feb 2026 09:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770659679; x=1771264479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y+SEhl0QFY4GYAMU2H0SGBR9bo98DAkauZSkM3tCtj0=;
        b=XTIsYAiqxhQ49Kg6MDdM9gikTpQ3j9FPy+zNdncUux65Hho1DSCr5ogElj4iWAaWCg
         xWIwZDofCJByE42QnM5CSisZD7efFPFJIcOiw8g1LMcZOOYkzNjLXfCEJBrDaKEzrOLZ
         FVb/kCsr/gWh7WRP+Ko9aMV1JHJwSGOHUgnb5e9e4VxI84a8rs+Duuc+eMGevqNGZCNM
         en+ono+gIwR7aoR8HaKZY+RkxGQhWTMPPZTw3yZNsMkm2NlQBwXShFUDjxFfYcers1Hh
         lmOOUbYKk/VLcmLg/uxCDPkX3skoD7+bB2t7dmn9dyExCSKAgNAl44L7dkjDmv6OOkux
         52XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770659679; x=1771264479;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+SEhl0QFY4GYAMU2H0SGBR9bo98DAkauZSkM3tCtj0=;
        b=XIBhS2h5jelztRXYWVjox8xruOg/3WG+YNsZTXeoTPKG8Etr472bLamwtTkBRWRixP
         rlkXbtNblXG3ANnfymYnZRVS86mlMhvBEv0z/NrlsPblQ2hEXAZc1s/UJq3Bsdak9GOl
         QXbOOjB4dVMeLzDTKN1PT/TSVdD7wT6reo/wI5DPLFpQAKJWY1lRC2XGDsTDuh1zJPZb
         KbSbdjYAxxOvvAjSeT0XL8o5m5DXKwXhoRODyY6TqFRMeoUOAf03OriYMxsUrlQ/u9YG
         dyfrhTBX74K/q/xANV9EUZZAAHalTjyOTgcv7SVXRkSlTrIyNSqGoi/iYzr4E24In00C
         Io4w==
X-Forwarded-Encrypted: i=1; AJvYcCXe12RdR/u1x6Z4TMR9s1e3mYwnv94XvpvwvXPNm5Lceqxdx04gEZRxTZZOi64BQ57jGSneNGK2v1GV@vger.kernel.org
X-Gm-Message-State: AOJu0YwfqmzDJLJ4nhBbyOXgGGSxkG6sKZm97hw76OF7MAFyXAsIudHq
	Ps/TinS0e8Khn1kn1vgNwOwxdP4kHUNwGPy/82LT31J/zPtUJ8rDoiVF
X-Gm-Gg: AZuq6aJIvbGZxs3NuWlJGbEHTCidt1VHYOUOxYyUQbhRJy+Jtim3mv5ZuIFMD5gGftE
	SqkkhpcvvYEA2EqtQQBmKYj2rk1njJccwMU89Z2GdgBk4SjAE1U+NSy2Yyw7Vt72Jj6L5R5kS5F
	Cqywq3xrngeDkd0y7qIzNIeS9vrNEoQS70/RzrOhNpsSwjhPDGE275oAeqVndOd4Cr+g9QhMeQA
	uQ/iYkaOgy+lxhXNhufYTdaLkrQp5JtGfW2PrdROEk3u57LWtY5nflsIpb7XgYX1CpYFaYz6kcw
	rWm4FovwrlSBVk321wjshG2adVmEkZ9Cah366QBnuFgxHmBYa/a6nST3xKQQK9zW/skIk/Xet5q
	Kn6XA58Xk3muP7MMhQTx0RRt6qDLN9dQ/4ZJmQ5WjHNOftiCB6fNvbixVki0SmrkHiaBNS477A0
	m2aVvbdDJnSe0AnZLm8BGBB2k=
X-Received: by 2002:a05:6a00:2402:b0:823:3079:7c7 with SMTP id d2e1a72fcca58-82441655149mr10546476b3a.29.1770659678784;
        Mon, 09 Feb 2026 09:54:38 -0800 (PST)
Received: from archlinux ([103.208.68.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244166f3e2sm11232882b3a.10.2026.02.09.09.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 09:54:38 -0800 (PST)
From: Adarsh Das <adarshdas950@gmail.com>
To: sfrench@samba.org,
	linkinjeon@kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adarsh Das <adarshdas950@gmail.com>
Subject: [PATCH 0/2] smb: simplify boolean expressions
Date: Mon,  9 Feb 2026 23:24:19 +0530
Message-ID: <20260209175421.66469-1-adarshdas950@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series simplifies boolean expressions in the SMB code by removing
redundant comparisons with true/false.

Adarsh Das (2):
  smb: remove redundant == true comparisons
  smb: remove redundant == false comparisons

 fs/smb/client/cifsacl.c        |  2 +-
 fs/smb/client/connect.c        |  6 ++---
 fs/smb/client/file.c           |  5 ++--
 fs/smb/client/fs_context.c     |  6 ++---
 fs/smb/client/misc.c           |  2 +-
 fs/smb/client/smb2misc.c       |  4 ++--
 fs/smb/client/smb2ops.c        | 12 +++++-----
 fs/smb/client/smb2pdu.c        |  2 +-
 fs/smb/client/transport.c      |  2 +-
 fs/smb/server/oplock.c         |  6 ++---
 fs/smb/server/server.c         |  2 +-
 fs/smb/server/smb2misc.c       |  2 +-
 fs/smb/server/smb2pdu.c        | 44 ++++++++++++++++------------------
 fs/smb/server/smb_common.c     |  2 +-
 fs/smb/server/transport_rdma.c |  2 +-
 fs/smb/server/vfs.c            |  8 +++----
 fs/smb/server/vfs_cache.c      |  6 ++---
 17 files changed, 55 insertions(+), 58 deletions(-)

-- 
2.53.0

