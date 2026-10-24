Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792846800;
	b=kDWSKBnu1FeKFBYfnMXf+ujL4Jl0tEc8t9WFJ4pgCwNI4UiLe+SIE1uqiXbTmGkD/sSC
	 KiCIXga4bFudeSOQsrt35Xddz1z5V/6PcXFL3KVsV+vAZU6KAqnZKZMz+I+511gEvX96z
	 DTYNTANXxNXfNFEE8nAmpgqi4voqI63NbpLantEeTzDVsUIS5xznEpG5LObsj5QlSHwSC
	 nOGWB5eQyF86IT1mu6P/DjfSVWi7ktCIaEl7Yiah9PTgolctRYKbdaMHMJaRB9CHSSCZw
	 FPNnYKYNNdbGtYt/OA/RK7iA+ENd5vcGNTNxmeQNYRA4zks7KB4O4E/2EC2KLUY0fLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792846800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Content-Type:Mime-Version:Subject:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=dqHs8tDmNMEZi1+5bLJJimo/fl1tge4B3BTmCW5R1Jc=;
	b=pvLc9J/TqoKxCgpWtR97/ti5hj6L8s+a1FLAS7P2FyIndh3c/sZwdc4FN6YAy9XvLN0W
	 HO2oKN1JXHIdYmVXH9MDaD7oeBgYUoNoMGAhZK6qFKqbWt2OfUvdckMO9KF7MB9EudtgA
	 UoqA8QkwuaSWungdasRTyvZdH3CuQoP4RezsYc6ep8qsKHFtgZfffxFbEOHGfsxouFxPy
	 a1q85UjXJGge2S4r2rboN5rf9nWFeLe+as9blvXbzV91HojOW4bSSplNdX1o4Z+Yg4ej3
	 ZT0UQqvSknr8zdflntMSY/24LRuEwNsYdp3uMTUncBDPRln0B1H0PXaUKRlZDGdhv9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Htff71u/";
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CA0606A320
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 12:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5CA0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Htff71u/
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c46822eefb6so211560066b.2
        for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 05:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792846798; x=1793451598; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dqHs8tDmNMEZi1+5bLJJimo/fl1tge4B3BTmCW5R1Jc=;
        b=Htff71u/WVtWjSdou3dc1unebAF6GladU2NLWvY11CmtvdvsF5g0bfeRUWdPlOYZzW
         ODxyjZTeGzlh8LU2Gthf4zW3CyT9S9KDjVPphbnFZg23hMAZByPx7aYWNFAyT1a7U+/Y
         pyGiAAoeOm3xQz91x7zRIGlksL9o8S/3ccgFhdU903yB4IPYXadi67w20aVkPTZhXmOL
         +ukVGJR7d7lrlgJL7CDwWthtpyeyENKpTV6LUOJd/lKhXKnCUYgXaUmKDakTtAI+4Hur
         EmTGUd3PanHGStybBk53Oh6hfOYHC2tvEeZhKFdYHrShugpArjWDTJQTek1Is50uJcvL
         2HgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792846798; x=1793451598;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dqHs8tDmNMEZi1+5bLJJimo/fl1tge4B3BTmCW5R1Jc=;
        b=i7be6fcVCiUFG3XneGHZrJxQXj30+SQsTSTykMxV/nMATeqFUAibhhQ8wGusIDV6yX
         j/Cmd0VDuA0uTYefoj28eWgI+mEpBAx/SiGdTuQDqglq5c3HpQluI5tdR9oGt9V2291c
         PjPG1pagkU0ZC7o18fa/FTsf+Q3FEAZpW514wVyFQ7TlfukBvDH149/nFWeul4WiNQGU
         DejfOxS3Sw6g/PyHlBdRCzNn6MrrzTtnxYOWp69ld3ORmCuAAVly7kKMHqccfOaBIUp2
         cWnjY+Uf5k7R4xY04n5MYk4Dh6pdzmaC5Rjbj4Ok/rvsiA2ssy1/8yxf8IPHWC8a+ZCg
         Skig==
X-Forwarded-Encrypted: i=1; AKwUvByKBrGPBRhTz4Rxi8joFQdBy7TSngEaX21B4Nw1edJsxexepGsABuIFkJIqHX+eiccnz8TZ5d6Y0MJq@vger.kernel.org
X-Gm-Message-State: AFq9FYJIE29U+ygtZzqe4nrP6twGN63uHB0M8LztivI0OhrHgp6e3JZk
	khpvkcQ7DaZkqN58BgjM91EohmZ0YaxAmz+rVFaki5B/zIZsqEOeFNZH
X-Gm-Gg: AYBFou3pDOzhF2e2QhpL0oRiNT/ucmr1GCTgoDlxHenr2NaE5aSwAtejmHipaI+lPq5
	MGkYATyH0cgHYMRXCtJYCJ6pzikgj66XI6L/QfXNCuOW5Nl3fZ7tCJ2A+SCURMZL9NzvVXjqmAw
	rg+84vca3nKpN6is1kjqPB9lyv3ioKsnBb4YIc89xC0JXqW/TY0RHYkoh6e00nuVzUf2HiUgLnv
	XKzS2TJn0M7FoMsiyWrFE8kS7EyDhk2Q1+icQ11YKKmDnrP08iQ0/LIlMrFivz8smeprndrMpDf
	9mjBSZfnRjjwsg01/amdQM2SOi9xp5D48RK0l0LFLs/dyaBd/pRNv7Ax7GY6Pg0uf1d/bRtILtT
	Bc72NbUv8OjWcoCHyDToKpi/quoyefPy+g8wvplrhGEaKXozq4TsQLZ/m356Zbo4ynJzWj1EJU9
	Oc6osIpkgCu1Td+8GcikFlBp1XNv01r2niopZxbT2/XKgNFDre+4BssTX/s2sXEFLiDj5zeZPzr
	/4xV0GpreDLP3tsZA4RRpDdjxR+J4waxSKgAnH4sH8uMmZA4vLQL04cmsZjDKe23NTTF48ItY2U
	6JkXLuJAnBp+aw82SeFUt+/Jlm7NniFWy18t3lcc407TPfxhUjJu3/T8muo=
X-Received: by 2002:a05:6938:e081:20b0:c45:b99:f282 with SMTP id a640c23a62f3a-c46c19961d9mr119556366b.7.1792846797805;
        Sat, 24 Oct 2026 05:59:57 -0700 (PDT)
Received: from smtpclient.apple (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd4e99a2sm87430066b.24.2026.10.24.05.59.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Oct 2026 05:59:56 -0700 (PDT)
From: mixalhs <mike.michalo@gmail.com>
X-Google-Original-From: mixalhs <Mike.michalo@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: ksmbd: AES-GMAC signing support?
In-Reply-To: <CAKYAXd_zM0K9oAjEMzYinBeZEF=0=ozsd3+LRY6gy_O95btzRw@mail.gmail.com>
Date: Sat, 24 Oct 2026 14:59:46 +0200
Cc: Tom Talpey <tom@talpey.com>,
 Enzo Matsumiya <ematsumiya@suse.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D0F05F9A-5097-4A2D-9235-AE395961F456@gmail.com>
References: <20261023174821.17552-1-mike.michalo@gmail.com>
 <atugaviJxR8nzHQO@suse.de> <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com>
 <F6CE78FA-AA06-4F00-BAE0-80B0819CE6DE@gmail.com>
 <CAKYAXd_zM0K9oAjEMzYinBeZEF=0=ozsd3+LRY6gy_O95btzRw@mail.gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi Namjae, all,

A quick follow-up with some early numbers, and a few questions I'd
like your opinion on before I send the series after mid-November.
Cc'ing Enzo and Tom since they asked for numbers, and the ksmbd
reviewers. There are three parts below: the patches, a speed
experiment in lib/crypto, and the benchmarks.

The series (2 patches, on ksmbd-for-next):
 1. ksmbd currently overwrites the algorithm picked from the client's
    SMB2_SIGNING_CAPABILITIES with AES-CMAC in init_smb3_11_server(),
    so a client that doesn't offer AES-CMAC (e.g. HMAC-SHA256 or
    AES-GMAC only) is answered with AES-CMAC and fails to connect.
    Patch 1 fixes that and keeps each signing key paired with its
    algorithm (session vs. channel keys for multichannel binding).
 2. AES-GMAC signing using the AES-GCM library API, plus the binding
    checks smbtorture expects for mixed GMAC/non-GMAC channels, and
    the feature table update.

The patches aren't posted yet; I'm happy to share them, and the
experiment, earlier if you'd like to look at the code first.

Tested with smbtorture 4.19 and 4.23 (each algorithm forced) and the
macOS 26 SMB client, which offers AES-GMAC first: 256 MiB copy with
signing required and encryption disabled, read back identical. I
haven't tested a Windows client yet.

Numbers on arm64 (Apple M4, Linux VM).

Signing only, 1 MiB message, median of 3 runs:

                    HMAC-SHA256  AES-CMAC   AES-GMAC
  library today      3160 MB/s  2750 MB/s    990 MB/s

So on arm64 GMAC is currently the slowest. The cause is in lib/crypto,
not ksmbd: the arm64 GHASH library code processes bulk data with the
NEON fallback, not PMULL (the migration commit says "though only with
NEON, not PMULL; for now the goal is just parity with crypto_shash").
As an experiment I computed GHASH through the existing 8-way PMULL
POLYVAL code with byte-reversed blocks (no new assembly; the lib/crypto
KUnit tests for GHASH, POLYVAL, AES-GCM and AES-CMAC pass under QEMU
and natively on the M4):

                    HMAC-SHA256  AES-CMAC   AES-GMAC
  with experiment    3150 MB/s  2740 MB/s  12230 MB/s

CMAC and HMAC use the unmodified library code in both tables. They
are inherently serial (each block depends on the previous one), while
GHASH can process 8 blocks in parallel.

End to end with smbtorture smb2.bench.read, signing required,
loopback, median of 6 runs of 5 s:

                     HMAC-SHA256  AES-CMAC   AES-GMAC
  1M reads, today     1354 MB/s   924 MB/s    797 MB/s
  1M reads, exp       1355 MB/s   930 MB/s   3370 MB/s
  4K reads/s, today       22330      21540      21100
  4K reads/s, exp         22650      21650      23700

These end-to-end numbers don't include the key-caching follow-up
(question 3); only the library change differs between the rows.
Small requests (smb2.bench.echo) are the same for all three. The same
approach on x86 (the kernel's PCLMUL code in a userspace harness,
Xeon) is about 3.8x faster than today's x86 GHASH (1.7 -> 6.5 GB/s).
Full numbers and methods are at the end.

Questions:
 1. Is the series OK to send as-is, given GMAC is slower on arm64
    until the library improves? ksmbd uses the client's first choice,
    and Windows and macOS put GMAC first.
 2. Would you mind if I raise the GHASH speedup with Eric Biggers on
    linux-crypto? It's outside ksmbd, so I wanted to check with you
    first.
 3. I also have a follow-up that prepares signing keys once per
    session/channel instead of per message (in a microbenchmark of
    ksmbd's signing path, AES-CMAC on 64-byte messages drops from
    about 125 to 32 ns on the M4). Should I send that later on its
    own, or as part of this series?

Full numbers, for reference:

arm64: Apple M4, Linux 7.3 VM (Lima, Apple Virtualization),
8 vCPUs, ksmbd-for-next + the 2 patches. "today" = unmodified
lib/crypto, "exp" = with the GHASH experiment.

Summary for AES-GMAC (details below; "cached" = key prepared once):

                       GMAC today   GMAC exp   speedup   vs CMAC (exp)
  sign 64 B, cached        108 ns      57 ns      1.9x   0.6x (slower)
  sign 64 B, per-msg       192 ns     234 ns      0.8x   0.5x (slower)
  sign 256 B, cached       395 ns      68 ns      5.8x   1.5x faster
  sign 4 KiB, cached      5608 ns     435 ns     12.9x   4.6x faster
  sign 1 MiB, cached     993 MB/s 12227 MB/s     12.3x   4.5x faster
  1M reads (smbtorture)  797 MB/s  3370 MB/s      4.2x   3.6x faster

Signing microbenchmark: a module that signs exactly like
ksmbd_sign_smb3_pdu(), with the key prepared per message (as ksmbd
does now) or once ("cached"). Median of 3 runs, ns per message:

  64 bytes            HMAC-SHA256   AES-CMAC   AES-GMAC
  per-msg key, today          125        120        192
  per-msg key, exp            122        126        234
  cached key,  today           89         32        108
  cached key,  exp             78         33         57

  256 bytes           HMAC-SHA256   AES-CMAC   AES-GMAC
  per-msg key, today          190        184        495
  per-msg key, exp            188        190        240
  cached key,  today          155         87        395
  cached key,  exp            140         99         68

  4 KiB               HMAC-SHA256   AES-CMAC   AES-GMAC
  per-msg key, today         1842       2083       5756
  per-msg key, exp           1838       2091        643
  cached key,  today         1799       1981       5608
  cached key,  exp           1786       1983        435

  1 MiB, MB/s         HMAC-SHA256   AES-CMAC   AES-GMAC
  per-msg key, today         3152       2740        994
  per-msg key, exp           3153       2746      12202
  cached key,  today         3159       2753        993
  cached key,  exp           3149       2739      12227

The per-message GMAC cost at 64 bytes goes up with the experiment
because preparing a GHASH key now also computes H^2..H^8; preparing
keys once (question 3) removes that.

The kernel's own KUnit benchmarks on the M4 with the experiment
Show the same picture, in MB/s:

  bytes      GHASH   POLYVAL   AES-CMAC
  256         8255     12895       2407
  4096       11047     14028       1507
  16384      11145     13718       1524

Workload: smbtorture 4.23.6 smb2.bench (nprocs=2, qdepth=4), client
and server in the same VM over loopback, SMB 3.1.1, signing required,
encryption off. Median of 6 runs of 5 s each:

                      HMAC-SHA256   AES-CMAC   AES-GMAC
  echo ops/s,  today        27673      27433      27583
  echo ops/s,  exp          27861      27900      28002
  4K reads/s,  today        22330      21537      21097
  4K reads/s,  exp          22650      21650      23700
  1M MB/s,     today         1354        924        797
  1M MB/s,     exp           1355        930       3370

x86: the kernel's x86 GHASH and POLYVAL assembly built into a
userspace harness, Intel Xeon @ 2.1 GHz (PCLMULQDQ + AVX). GHASH only
(no AES, no CMAC/HMAC comparison), best of 5, MB/s:

  bytes          GHASH today   via 8-way POLYVAL   speedup
  64                    1664                3519      2.1x
  4096                  1772                6674      3.8x
  1048576               1700                6472      3.8x

The GHASH-via-POLYVAL result matched the real GHASH output bit for bit
for every block count from 1 to 300 and for 1 MiB.

Disclosure: I used an AI assistant for the experiment. 
My background is in electrical engineering, and I have
some familiarity with crypto from security as a hobby, but I'm not
yet familiar with the kernel's crypto library code; the
experiment is only meant to show whether there is a gain, and if you
think it's worth pursuing I'd be very happy to rework it properly
myself.I ran the arm64 numbers, the native KUnit run and the macOS
test on my M4. The x86 harness, the KUnit run under QEMU and the
smbtorture 4.19 runs (UML) were run by the assistant in its own
environment, and I've reviewed those results; I don't have an x86
machine at hand right now. I'll also run the tests on a server with
two Intel Xeons soon; for now I'd mainly like your opinion on how to
approach this.

Thanks,
Michalis

