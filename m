Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661153;
	b=jRugmDufF3L2AXzMoijsLD54cY91Qzk3TDKypG5KfiShU+sMvuq2/RjDdfSjWAHylYzC
	 EWWv4SzgLB/PzKrpGY8AFc6r3V5MX+UvnliDdWqR17XqAuE4Zf3BYEGLO09tbnnng3vx6
	 dNFZEnSUiqaXW2/oXrbJGCqsvALS73pNNErTUtnKRWap09EbCU5vzQd1gfhDplWlbFuZH
	 FiOBbPM9+9N5K0PEvDOGQTCIGaOjABw610P0kpZvIPzNtCq8avlcuCw2+PD4JSj4NqkBx
	 vfCmmd86m4R5GpAojLpXksP2n/ugcFFcYwq5eg1M7/Q3oME2BVPe0jZ94MW9ce22n3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661153;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AQgdCZwsPjFuYKXLps23Oal53mMZKLM0pyLIrt3gG7g=;
	b=s3a4mZtNxisA6gz0Yt+73Rp3Z05DeOjYlKAh+5SPuO2v4h7twQfSraSCMtb5vgve5RZB
	 r2zYbOCQrGBAB7FManAhuRHnK8MQGetQ4fi2yAM7yq8Vr4NL+VCUKnOBO1MxddtO/P0n2
	 MdjlbBP3AKfP5INJ49P+wjDfK+KcDRKfKAdg/tGwDF1eDEUEiEDnkTZ2iN21lAlLpnOSn
	 si1C+4APJlAnpC6267MBfccIMPNebAiyrA/18b1vH4whEd+cdyuMj0Njww4bS3nfFWHch
	 dztsMIHeflJoJ7FXiwVg6kRJZTxvQJdY2iqq8sV/W44JlmGfYxqvxIuuBOHe1atjrow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R3X1ZN7F;
	arc=none smtp.remote-ip=95.215.58.209
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A17606A31E
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 09:25:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37A17606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R3X1ZN7F
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2yJVVc9YqY0/+reoiHnYhCuNBUGsT9L5rjAhU3GjBh4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792661150; v=1; x=1793265950;
 b=R3X1ZN7F+ribIKOTyewA6Eza233ASaLBhnshv8RB1ofp727BI3mhDJZdQMNwPpB4n6dQaOJS
 qi9t+HTYb1xINYnjxr/9QSl/4T05cAhdBJM5oJjIoZg0hgRxBbtlJMv63E3M2eHio1jYLqy5TZf
 n28Ie7YL0nNyv1qZ8etVJJDU=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1d283f1937ad0db6;
	Thu, 22 Oct 2026 09:25:50 +0000
X-Mizu-Trace-ID: 1d283f1937ad0db6
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	tj@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] ksmbd: improve WRITE scheduling and TCP READ sends
Date: Thu, 22 Oct 2026 17:25:10 +0800
Message-ID: <20261022092514.2590010-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
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

From: Huiwen He <hehuiwen@kylinos.cn>

Hi Namjae,

This series addresses two sources of overhead in ksmbd:

- WRITE scheduling: requests from one connection can accumulate on a
  busy per-CPU worker pool even when other CPUs are available. Route
  eligible single-channel WRITEs to a CPU-scoped, non-strict unbound
  workqueue, while keeping other requests on the per-CPU queue.

- READ sending: TCP copies READ data after the filesystem has filled
  the response buffer. Use page-backed buffers and MSG_SPLICE_PAGES
  to avoid this copy, with the existing copy path as a fallback.

Test setup:
  Server: Linux 7.3.0-rc3+, dual socket, 128 CPUs, tmpfs.
  Client: Linux 7.0.0-38-generic, local 4-vCPU VM; file-data caching
          bypassed for both protocols.
  NFS: Linux nfsd, NFSv4.2/TCP, sec=sys, 32 threads.
  SMB: ksmbd and Samba 4.23.6, SMB3.1.1.
  fio: 16 jobs, QD32/job, 1 GiB total, libaio; four 30-second runs
       after warmup. Mixed: --rw=rw --rwmixread=50, READ + WRITE.

1. Baseline throughput (median MiB/s)

  Block  Conn  Workload       NFS      Samba      ksmbd
  -----  ----  --------  ---------  ---------  ---------
  4KiB      1  READ         195.59     241.71     292.64
  4KiB      1  WRITE        154.68     228.92     219.55
  4KiB      1  mixed        172.49     232.42     236.85
  4KiB      2  READ         346.23     274.58     401.12
  4KiB      2  WRITE        312.62     292.39     325.75
  4KiB      2  mixed        329.28     286.86     345.04
  4KiB      4  READ         428.34     277.92     463.80
  4KiB      4  WRITE        387.19     285.59     415.65
  4KiB      4  mixed        402.74     284.52     397.76
  64KiB     1  READ        2156.89    1647.55    2152.98
  64KiB     1  WRITE       1664.58    1956.34    1808.18
  64KiB     1  mixed       1790.19    1854.00    1961.47
  64KiB     2  READ        3607.94    1526.36    3345.74
  64KiB     2  WRITE       2969.75    2706.88    3223.25
  64KiB     2  mixed       3469.13    1990.95    3285.02
  64KiB     4  READ        4375.82    1850.92    4213.09
  64KiB     4  WRITE       2622.47    2908.68    3016.62
  64KiB     4  mixed       4293.94    1857.41    3950.03
  1MiB      1  READ        3688.67    2266.23    2142.63
  1MiB      1  WRITE       3750.42    3782.38    2184.30
  1MiB      1  mixed       3986.36    3108.39    2827.65
  1MiB      2  READ        5756.65    2245.04    3960.96
  1MiB      2  WRITE       3858.07    3418.41    4063.92
  1MiB      2  mixed       5347.24    3151.78    4614.56
  1MiB      4  READ        7908.09    2378.32    6750.79
  1MiB      4  WRITE       3422.60    4138.59    3566.57
  1MiB      4  mixed       6161.38    2676.61    5471.26

2. Combined throughput (median MiB/s)

Before/After: both optimizations off/on in the same kernel.

  Block  Ch  Workload     Before      After    Paired %
  -----  --  --------  ---------  ---------  ----------
  4KiB    1  READ         292.64     282.21      -3.61%
  4KiB    1  WRITE        219.55     192.84     -11.01%
  4KiB    1  mixed        236.85     240.15      +0.36%
  4KiB    2  READ         401.12     404.66      +1.17%
  4KiB    2  WRITE        325.75     342.19      +5.37%
  4KiB    2  mixed        345.04     336.34      -2.12%
  4KiB    4  READ         463.80     456.10      -1.95%
  4KiB    4  WRITE        415.65     417.24      -1.06%
  4KiB    4  mixed        397.76     386.93      -2.74%
  64KiB   1  READ        2152.98    2558.10     +18.34%
  64KiB   1  WRITE       1808.18    2031.92     +11.69%
  64KiB   1  mixed       1961.47    2176.16      +9.53%
  64KiB   2  READ        3345.74    3591.95      +7.32%
  64KiB   2  WRITE       3223.25    3205.70      -0.54%
  64KiB   2  mixed       3285.02    3317.22      +2.39%
  64KiB   4  READ        4213.09    4427.29      +4.65%
  64KiB   4  WRITE       3016.62    3047.30      -0.59%
  64KiB   4  mixed       3950.03    3962.34      +0.44%
  1MiB    1  READ        2142.63    3353.03     +56.51%
  1MiB    1  WRITE       2184.30    3460.33     +58.75%
  1MiB    1  mixed       2827.65    3096.88      +9.71%
  1MiB    2  READ        3960.96    5546.88     +39.95%
  1MiB    2  WRITE       4063.92    4174.43      +2.75%
  1MiB    2  mixed       4614.56    4954.98      +7.37%
  1MiB    4  READ        6750.79    8311.51     +21.79%
  1MiB    4  WRITE       3566.57    3612.88      +0.74%
  1MiB    4  mixed       5471.26    5604.89      +3.85%

4 KiB single-channel WRITE regresses by 11.01%. If no better solution
is found, a request-size check could fall back to the per-CPU queue
for small WRITEs.

Thanks,
Huiwen

Huiwen He (4):
  workqueue: export attribute and sysfs setup helpers
  ksmbd: route WRITE requests to an unbound workqueue
  ksmbd: complete TCP frames before reporting send success
  ksmbd: send READ payloads with MSG_SPLICE_PAGES

 fs/smb/server/connection.c    |   1 +
 fs/smb/server/connection.h    |   6 ++
 fs/smb/server/ksmbd_work.c    | 141 ++++++++++++++++++++++++++++------
 fs/smb/server/ksmbd_work.h    |  11 +++
 fs/smb/server/server.c        |  78 ++++++++++++++++++-
 fs/smb/server/smb2pdu.c       | 126 +++++++++++++++++++++++++-----
 fs/smb/server/smb2pdu.h       |   1 +
 fs/smb/server/transport_tcp.c |  71 ++++++++++++++++-
 fs/smb/server/transport_tcp.h |   1 +
 kernel/workqueue.c            |   4 +
 10 files changed, 395 insertions(+), 45 deletions(-)

-- 
2.43.0

