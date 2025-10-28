Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B692E2FFDD4
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 23:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761695444; cv=none; b=WfkiVrlL85MtS272AH3sUNHbXU/HOG/g1q87iQ1tbNz6o/gEekwA83TiU0DHoVegS8+3CTdFRDZMdDrs+MAFgIUgHTP+XC4QZRW70mjO4KEJdDm7XMS2Sm6BLIZZrQbH7xv2Z1zL/MeqSze93HgjoT40bssSg6iEU8c3qYNyHbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761695444; c=relaxed/simple;
	bh=vWlIS3Y/oVX7SW5js/ioA1mtAuSAo2zoDhgZ1h9PcRE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=i2rDZtvYw0EC09Dl7LRvpaHkKtfnmKg+IatFcCxiLS/clxXL/p7UAWY29Wgbtj2LT81slhPHxtkLQdf7ck3q1IR+so0ojettSWfyOla47KBsJsrkAc9AUcnE5ZC9KOmeRibGyoeAtwdAAyTRJ6ewgew8YasVN2lC7z9cvhDRxe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRY+4Rf4; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRY+4Rf4"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-592f7e50da2so511934e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 16:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761695441; x=1762300241; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BcCjrRgOWUo5URvOluVp+lygBcH0R5GiU5s65O64e98=;
        b=dRY+4Rf4UEUxc7iRNg70WCEfkd12JgKkIlZu6ZNMNvCsLkRyeOZdpvBeyeZyt1rmnH
         3pUy/5I9J4qXPq3dvDF5jUK1E5eMdcLwSUhgYqtwlXqCn1g4n1DxPPV/Ce4xK+V8pbbg
         xyxsTihHykN5lC1yD7Xmrpo03rbLdjP8ep4F01daNAh1TlHIK2xI9QVvusttahGgDDIW
         rhqs7t878lu+3xXsvjDaGzKO3Ah2UgJHTtIi/aIoKmlf/PyW8hrj4sQUQRXtijFE0EKP
         pjwUD7UTFUSg1IuxNdnNg6lGryPvhKjXxFLG1Oq8kIhgK1NSN3fyPKwvk4lz69xvHtRq
         d9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761695441; x=1762300241;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BcCjrRgOWUo5URvOluVp+lygBcH0R5GiU5s65O64e98=;
        b=JIVbj72iO8GZkWrbsLp7RX9pZGMXAwU6KkYsXPYqLGqBquAFLz3dprlr9TrdoZ1LKP
         QrUCbF8JrNtfNRvG/mR3PPa1qEps2USysSSYCc0aCElJ6dhdH43Cnfwd3DMP7dWlhAHB
         z8lzJK4PW2HZ5xDYSo4dGTvSBXXMft/6CLnUFB7spH4dU3NOL+VoF5Npo3o2nsjXZyZd
         Brx5n/7OWKZAFnljDFn4Bei6UwaaCKz9gy/aHYv6bGlJylcS86zij5gQ8S6seyvRHbYx
         xku1wSSlr43Cjyp2ySp8c9KacwLz1q87oaplbQbse0uVjNq367i0DzIjms0AuQLnpkQL
         hUdA==
X-Forwarded-Encrypted: i=1; AJvYcCVfuP4JxFdgkkiKdyaHl0aO1hfvQSF/arWwHzCXUDL7/wthnIZJW6V/eYRV6kBcWvdanyiTMEQP20ki@vger.kernel.org
X-Gm-Message-State: AOJu0YzTlxpC7liT/eqP2AgUP0Gv8tCFhlLzMh2RVo4japNr1w/UEj+2
	ZnWA0QSCmwdMkq3EMJ5eVLr2tUJjXiu/gbh/LlUdH3+2jxq1fTknCwkz831MDzrKAavjQ7BP60w
	LLQcDCsilV9pv8u/A6PT9JK13gsR+6UOOroTbKZI=
X-Gm-Gg: ASbGncvopBdXi4jVQ9uIsubt15n9DUdYjC1rLnJkC/KmuQsEP23XOMZSyqu93Etsfyu
	EoarijqezUBrb9LIvf3X1CpBe0EPusNdASbR1k6248DVybdTfyvuPq3gVz5z1wm87Ermg2R9oEw
	v/18Ze7Ack3PG4gGikXa0oIiUqW5m3YlAthV6eKGDAE8L5nN4/HphNHirH1Ne/aqJ9GB6rkuwFl
	SMonTTZI1fGIxrhE+v6jW8QU6Lblwm2jc4i/Zx6/QfvKkPFWrQkymVbSz/qFfIrrQuV1xZ4+Xev
	JvbuhespJMXiIpSbGq3e7JVhUjjxuQv1sm/l4nS7LIY6qcMw4oN+6NByqVW4bEo6T+2RXU1m6+B
	EOD8qYKFzVjZ1uHMe8A/gctSdPFJFLORIYuBxvhqNhg==
X-Google-Smtp-Source: AGHT+IEDzoOaSGsGdbeO3X6wLVyV4eHafi+2jrHwh/fj2DuhlHGmtB/8y2IAX/KeBgZufayT6+WEuejDRJEX5cA1JkQ=
X-Received: by 2002:a05:6512:4012:b0:585:1a9b:8b9a with SMTP id
 2adb3069b0e04-5930edc3631mr1517466e87.9.1761695440522; Tue, 28 Oct 2025
 16:50:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 28 Oct 2025 18:50:25 -0500
X-Gm-Features: AWmQ_bldv1tX4lgQDkpyYvPXZCLltojj1sUsdHeJ-3n6birSyiXJ4DFqxsfAYEw
Message-ID: <CAH2r5mu7ZOL06JftZt4forRyQy77+OYZQ0gWYn5Cs9Rvk62vjQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa:

  Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.18-rc3-smb-server-fixes

for you to fetch changes up to f574069c5c55ebe642f899a01c8f127d845fd562:

  smb: server: let smb_direct_cm_handler() call ib_drain_qp() after
smb_direct_disconnect_rdma_work() (2025-10-26 20:47:32 -0500)

----------------------------------------------------------------
Three ksmbd server fixes
- Improve check for malformed payload
- Fix free transport smbdirect potential race
- Fix potential race in credit allocation during smbdirect negotiation
----------------------------------------------------------------
Qianchang Zhao (1):
      ksmbd: transport_ipc: validate payload size before reading handle

Stefan Metzmacher (2):
      smb: server: call smb_direct_post_recv_credits() when the
negotiation is done
      smb: server: let smb_direct_cm_handler() call ib_drain_qp()
after smb_direct_disconnect_rdma_work()

 fs/smb/server/transport_ipc.c  |  8 ++++++-
 fs/smb/server/transport_rdma.c | 47 ++++++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 12 deletions(-)

-- 
Thanks,

Steve
