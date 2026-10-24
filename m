Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792867570;
	b=j/o8fznkZZFovchvE6qrfmm1voc9QLy1oxMauL39PFaq7Tz1Uz1oTD5mCBY/aymN+LFl
	 dR6umNFZq0U3sFNGbdv5Y5IVpTgRo1LzyUo80WO/0U2BdLLriUz6q0ZK0AlDxV0grxjlp
	 b7jLByPmbre+W0ANCuzLG565cY/A7977sLkAMzYe7YrnGBcwwoL0cPYa1wvqtY0rFuRYY
	 7Q2yJsRzj9Zhkb2cr6XMmqvL8+GrU+JE2pKewa3Zc/c5md72AsoK0XrOp/gjM03Xh3Gsh
	 RDRQQf1TJOXjHB7Y+i6rF9s4mKsXSBSUc47rDDYgLqdUc1dtoh5vmsKuAkWBsgo0smQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792867570;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=os+CpApFAeFMQFmoyWApV92IYG427+6BdGY0Jd+kTAA=;
	b=4dizVQa6/wnaHagKncMgusIPGj1LSHbxI8HIzCsHb/DAuOmt/fyLWD4LZzSS4CVbNrZS
	 IX37pmI0N3lX1XbgkXJSSI40M7/OaZkf6yL5Fq6VWrxAvmhyZtpe20bvGPtIL3sgrY6xL
	 aVZHLFTZjBMadLeohTqq0ttOgu7c9E/I8+PZmnmYdECw9o2ozx2QHC+SDOte5W2i5xgXm
	 ALjLjCEGu21TRP5sK9RHsmpwIsGpndQdahvgxqib/hXUSvccqmaDIkBgg3GZJlaNgwzoq
	 MQEyoUhiUGXOR2DeFxsS8VdHUWLYFsS3sKiXKZphGOdT1LzkuKrAmr2bYfiLV3K4EPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JlCvgwFE;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C58606A31B
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 18:46:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02C58606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JlCvgwFE
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c450ab1483cso251919266b.3
        for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792867568; x=1793472368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=os+CpApFAeFMQFmoyWApV92IYG427+6BdGY0Jd+kTAA=;
        b=JlCvgwFEtJmWven3RZlWYJVNV/wI8QiKhnv6L8OdjttpmsxQ3YqwRTrhfOUraRHtQe
         vNaJ8ebwvLE+ayX4JoPkuPrRGjReWjqbOJwFxrYflLxeKGQITSyVxpdfCjHtkO7SlW1L
         SwcRKkNlHL5qc9JQM1VOxJLGcAdeUefzFL2ZRiz46A5vRekSVtkg1rhG1NRzYegACKGR
         4nusgAQpMuRhywl/nIiGcbM9E7oUUDwbNAjdz2Tx0riuIVgATKXimbyraW85py+uVSRo
         fr4jmsWq/mIYYYZjCQiqjbv6TaFydtu52bsEYTcPHwQzCOM1a8qVS5G7JBSQ77PvkjDr
         A6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792867568; x=1793472368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=os+CpApFAeFMQFmoyWApV92IYG427+6BdGY0Jd+kTAA=;
        b=Nur1iMp9IvDfJ24Qg/Ixj3cjE4WB9ujuuYjxCyTDPtsBhhoodOCZOTQSiB5dBTe1ok
         NYDwiJeh9ISuI60gkZMNYvO7eDip8MOPH0hlluLTFJqvsmXBTdA/lOb3mbaH2Be2ipWP
         P1CW8ga04Q+3GaFd7TJU1KtC/4GW9ebsHGkR41NFxCKoO5vGNpVGPcUThi6XpIyjWXZz
         3+yoJHoq8fGVCGWw7CDHTD0QrSsapCrh6LHPNks+QcIkZ3i0b/4dozl/rx5fVVRU7ikU
         W71p5dCk3Q4yrkf4YLbdzjrL5PFwe47Z4hhF09gIxEhy0dnSd77p/8L8xFDF/Ggp1kSH
         Kc2w==
X-Forwarded-Encrypted: i=1; AKwUvBw8/m5tAB2Vrya0PYQNH0roBTCi45i07ThToOxOIEy4DeVa/S7n+Ynm7DZNU8Jj6bGZDMtCpCIP3+3k@vger.kernel.org
X-Gm-Message-State: AFq9FYLDPK9XxpVzM7z5jWnBZnI/2DtxpvCETPBUZvNYCJO3mZKMzPlv
	PI9Nu/T5ica2/B/8WisPfygPnzVr0RedSMBeibNs1+HnB6LZGu/84qzG
X-Gm-Gg: AYBFou3esh/yeigvZH8Ee+4NBMebL6owhtlrx6UaKK9ILpn3h4t3QM2sxSqq3Y3D2MT
	6Q/iWmoT0rCwpiiS33VQskdXG+ju4Kp6/5zKWHCbQ1N0xZe3q/BDN0DxV1dReiVnltf0OOyivlj
	yP6u7LD+CGBsX4RLQtmxgYWKZ5Y5Sqh2Oy1RHB9XHwu4raGFezIe8L7ZWF/lEWc/L8X+HEaYvOL
	RzatTnnwpSlbACH364vu8zd+kQK2oOQu7C2cUjsvva3qWh8tKAD2y9gVWXvTvOVoO5w5kxaJytQ
	3SXOfWp2ivWRdgpY+pdEW+eOaY25aXYXqWGRqgl5+N72s+HNrr/8cSL4JY44WMJAcpChsCgfkKJ
	apDi0yiI9Mw/Zxq3x0Lc6lOq+LRznVyRhlIU4ktt0BkNiBRTrzKfcpL3TAB4qkzaLA32sXjaV9W
	7hBWoDOU6vIIXcyVrNMmGHlfkWT4/e9zpDRHtBiRbH7bZqMh8XCmzXbDqawEB28upDnzxU9Q4Hc
	enQqZ9MIvGv2gkiXVMIfgO1ydO3+IQyeZgzJnwMVbfTMc/rrZt4SV8s70dJn7GtTOoXpqeHhF7q
	Dq6bRMPuBNbfYp9bWGKHczX0Ft/miBAzK6+KwPb/kJ6Rl6sutgiCfO7MWLG3kEmSkpFpQOcBAgZ
	XE1ififMsT0Jc
X-Received: by 2002:a17:907:930a:b0:c2d:ca32:2176 with SMTP id a640c23a62f3a-c46bdc2abbcmr300585866b.8.1792867568098;
        Sat, 24 Oct 2026 11:46:08 -0700 (PDT)
Received: from wlan-199066.nbw.tue.nl (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd4e7c94sm117451666b.27.2026.10.24.11.46.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Oct 2026 11:46:07 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: pc@manguebit.org
Cc: bharathsm@microsoft.com,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ronniesahlberg@gmail.com,
	samba-technical@lists.samba.org,
	sprasad@microsoft.com,
	syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	tom@talpey.com,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: Re: [syzbot] [cifs?] KASAN: slab-use-after-free Read in cifs_crypto_secmech_release
Date: Sat, 24 Oct 2026 20:46:05 +0200
Message-ID: <20261024184605.44432-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <8bb0534e33a5f5d152d2b1768d1fd7c6@manguebit.org>
References: <8bb0534e33a5f5d152d2b1768d1fd7c6@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Paulo,

On Tue, Oct 20, 2026, Paulo Alcantara wrote:
> #syz test: git://git.manguebit.org/linux.git cifs-fixes 

Not sure if you already have verified your patch but
In case this is still helpful:

syzbot has no reproducer for this one, so I tried to make one. The
natural window is tiny (the demultiplex thread only rechecks
tcpStatus when its 7 s receive timeout expires), so I widened it
with a debug msleep(10000) right after tcpStatus = CifsExiting in
cifs_put_tcp_session(). The trigger itself is simple: a TCP listener
on 127.0.0.1:445 that accepts but never answers, a cifs mount of
//127.0.0.1/share against it, and SIGKILL to the mount after 1 s, so
cifs_mount() fails with -ERESTARTSYS and drops the last reference.

Without your patch this gives the same report as syzbot:

  BUG: KASAN: slab-use-after-free in cifs_crypto_secmech_release
   cifs_put_tcp_session
  Freed by task ...:
   clean_demultiplex_info
  CIFS: VFS: cifs_mount failed w/return code = -512

With your patch ("smb: client: fix UAF of TCP_Server_Info in
cifs_put_tcp_session()", fcf942f9eeca) and the same delay at the
same point, 5 rounds run without any KASAN report.

Tested on UML (x86_64, KASAN, PREEMPT) on top of ksmbd-for-next
4623da395dc4, whose fs/smb/client/connect.c is the blob your patch
applies to. Without the delay, 50 rounds on the unfixed kernel did
not hit the race.

The reproducer, run as root:

  import ctypes, os, signal, socket, time
  srv = socket.socket()
  srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
  srv.bind(("127.0.0.1", 445))
  srv.listen(64)
  held = []
  if os.fork() == 0:          # accept, never reply
      while True:
          held.append(srv.accept()[0])
  libc = ctypes.CDLL(None, use_errno=True)
  os.makedirs("/run/cifsmnt", exist_ok=True)
  pid = os.fork()
  if pid == 0:
      libc.mount(b"//127.0.0.1/share", b"/run/cifsmnt", b"cifs", 0,
                 b"username=u,password=p,vers=3.1.1")
      os._exit(0)
  time.sleep(1)
  os.kill(pid, signal.SIGKILL)
  os.waitpid(pid, 0)

In case it helps when you post the patch:

Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

Thanks,
Michalis
