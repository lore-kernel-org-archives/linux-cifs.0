Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CAE21D59B
	for <linux-cifs@vger.kernel.org>; Wed, 24 Sep 2025 02:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758680517; cv=none; b=SA1HITTn3C4Ca6Wkp7cwIURRSD4xIdt61/qeNzTDgwE2phqXuqIKvzb2s0CuarHI8oPfuX1Z14LswlXv80KeMAPq+iAaGRTLN08kIG7K+CVo9nLjX/uftx2PXlMekT3hZyGPpOg3wMwmm+AC34Phcwyws+Dz9fVdWV4ATI679jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758680517; c=relaxed/simple;
	bh=HFHmdE57JXCjKHaQD8SUjF/RrHNTUnZebd0jUZ724UE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=oHezaQ6DrYiAfDoMc6TvhtompR3PTGxLOdmfXxgPjrxJYrQmGfzpTVDlzglQ9XAUXF00LgjigQQFgUucb0zjptFxYEDb7cZS3ebE7JHVsHdTZzvOz/pLtchka7u8REaH4/ip/qSnRcT2DArKOI2LHINwdhPIKzBi5SQvodwiQNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lq9C4i25; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lq9C4i25"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-76b8fd4ba2cso49120956d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 19:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758680515; x=1759285315; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uqyfLm8v6T0qYv16JlYYlcUwd5Gfyhb7apOWrngvLGk=;
        b=Lq9C4i25Dy00dIS6rmK0aQW3YSjKO1Ge3El4drhmWR8TtUvA56/5wP906JlNyfzD1H
         nzTND4Ed5p1pTR0c77W79N1mT1IcIhDhLNft+msrkSa6DHYqw1YbIohO4H9lzfYxde8+
         5fNyMyG7ndAelsBopXNTQNV1xvJUEjk/OPQVpEJ83h3rUzs6AyrIFHdHxsrW7o4pKQXd
         Nof5vj2AewbKWkRE4KhjJ9xEJUcg0kCbOiZxnpS/F/XGdWemD66bJtTvwOPK3MI7eicd
         moYhd/AGVXU4oBrYVWW6ncPIwwycWVhODNpJJqhAh4m1bm6h4SUdD/TOmrIt1mmR81/x
         np6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758680515; x=1759285315;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uqyfLm8v6T0qYv16JlYYlcUwd5Gfyhb7apOWrngvLGk=;
        b=DqauaFiYWmfKar844IRtncQVcTiKgREfbtZIWnBX71N1A09iBefQV17l3vwnjslJ/I
         FHOOWluDUtBXor2SpP6tA9z4gmezhePI1HJHRUBUrt3i1LUyNWCb3ERYMEWostxeWQTn
         J4cSyRXa2sTGApP1qMQNMcfxToQw8GTeIdBGanhOLbre3CvgzQn3FCMk4/TYwtD6koqt
         yVPGgUOgpGgbnPOoM3QHh8kFhu3062Sde58SbPZexy8OGSIb6cQFmfcZFKbqjgXjZcqq
         UZjenA0XsPasFylxa6QpSLyj8NMF0qpHQP1ZZY5U7fEDpoVdzDQvVloSoKPVWFFZ8Lpj
         ijFA==
X-Forwarded-Encrypted: i=1; AJvYcCWzgh5NKpLa5McRsv1ALJq2aYMXJRcGif8LLRlO0PvSfV39Ox2kE7e2fVo2Pc+qrM8hSUYpn4g2ifdH@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4ZQ4EGwj1zKHqTtCLSgm12NHAZ//w6S2z/dbhc7b713us7VEi
	lGlcwGwFRHN0acxPPruUzwaoR6jm4RC4HsfbG8NaISi3k9dlHSDZ6utilgqzwWQUeIIS8ww3S0K
	52Up69IE+YGes3t3tjTDfPjz1ymTi3rwryRX/
X-Gm-Gg: ASbGncvWa4RvITj/NbFxGaaDBU7fC9xUVEJU2CvnYj0wn0zN2IruZlpR8W+udqnMaLd
	Zetd5MEwJUMHO30HUyYJv4NjrmVqNkLPU6eWwhhmjuDGJqB6ZDWhgAw16RfmM77113143xByd+I
	mWlCTKUTM2ZxruND+o/FCZ3nH3AevSlHwjRtnZbw5zeplIzNRtEZWzA85G9Hxa2nZ6RErJEeBu/
	pTWv6nCyO9LT2RW6d7sYcEsfk1XiZ+4/5x63SSfBeAJWFMre6A0MzCueFbYmbVm/OIXukp5CHNd
	oj907l3O5eZAwK1QDLLPSNAi+fvSCXtH5zRu+RAjM5h0MCm6IcO7p50hSn+OjaMcYNHYsAMNmAa
	X5IKOoOUuLMyWtRISHq4XUw==
X-Google-Smtp-Source: AGHT+IGC6vYlvhs66ktmkSH4DNM8gnu1Y+JkGwS0f32FuoBMmczQj3Zw9gx+tsGTkFNEZOt8dXwS5okLfdhpl2/fdhU=
X-Received: by 2002:a05:6214:e6f:b0:7e6:6528:a2ff with SMTP id
 6a1803df08f44-7e710d84958mr51832006d6.38.1758680514753; Tue, 23 Sep 2025
 19:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Sep 2025 21:21:42 -0500
X-Gm-Features: AS18NWB2bfaevaok-t0yRcDHeIiepjkPSc3MjLEZsgCVPtK2pHBCYZGFf-QweVs
Message-ID: <CAH2r5mux1-atMBd92EjpP9HYrLWWJDCC+=DNx+yVxti7ejDNhw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
07e27ad16399afcd693be20211b0dfae63e0615f:

  Linux 6.17-rc7 (2025-09-21 15:08:52 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.17-rc7-ksmbd-server-fixes

for you to fetch changes up to f7f89250175e0a82e99ed66da7012e869c36497d:

  smb: server: use disable_work_sync in transport_rdma.c (2025-09-21
19:34:52 -0500)

----------------------------------------------------------------
Two ksmbd server fixes
- free_transport fix for disconnect races
- minor delayed work fix
----------------------------------------------------------------
Stefan Metzmacher (2):
      smb: server: don't use delayed_work for post_recv_credits_work
      smb: server: use disable_work_sync in transport_rdma.c

 fs/smb/server/transport_rdma.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

-- 
Thanks,

Steve
