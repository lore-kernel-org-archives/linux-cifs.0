Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274781;
	b=CEu7gMM762qxHvudLh+S5dHQIsp9MhZKOFmlz8ugWRwhKCQq35C8sVNaycXcRYKCXv3N
	 TBbw2KPuYP/lqohk+bqPATAPsB/9ydYXuZYdLj/NsaI2N/s8UjoAVCJI5EPp0YNQddvVo
	 QI8OYgDztxUDcnionWCktG0cT832lEs2fdIrQzLvOI+GwLttt/X5gC+4Ka8Txo9xk9u38
	 9Q8uIkPRH3GtWd3+RykVBxzZLQkxpKFkixSM00AgKxh5yn0OqtL76hEI7MEuw/Xgrr59e
	 koIxNtNxU5ohs3yqll9K1Tm97Jwm7i0MHsnrq9TGe3/3Y1mOWN/7JmZR1rYx1De+xKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274781;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=B6fFfQE7RrEN57mIZD+kdgqs70BufHGSWfMzjOpwU+U=;
	b=JOvlYmvxZPGvuZ5RdZPqQ0jYV0H9izM1SZr+i8h97D+UeE3FlquaEZLd6qjUHeqzpDA2
	 wou+CLM+2sxP1LRZ1JjuZNWbFNutkFTD+yVLRrfvzSUQaOtDNl/jjTkhiULhswfcy51Ic
	 gaiDtr0PBKZFpoMeZljkEQ4FgtZACTZf8x5PwR9SIfDhx5h3g4xXW6JnqyHoyJBAH+wGB
	 OD9lp0etr1tOqhtnACN4VE1rprm3hk6EffaTXb+AnhuOpmNVesZjW7ztBQo2r5W1qIoK/
	 f9x05qE1AI/Ubdv151ytBlR9G2YsYPwn81NgSerBpYNL83ATKaJawPo829KLodO0AXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GqzIuOBU;
	arc=none smtp.remote-ip=91.218.175.200
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5149D606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 11:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5149D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GqzIuOBU
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lS2RsKxNaMi6eyWMVxwMVQS/P8x6d1KNXff8k9wBiKg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793274778; v=1; x=1793879578;
 b=GqzIuOBUOLrrFoTp6swnjL58TcaG22yxSt2Qlg+rHlOgFnSdLX+c08ZFntQ8lnzU52pTYQyR
 FoirYGwy/CyY4nYzzGH04t/5rYgPd6f188HropH8V2UFlLSH76LwOCrOO+NyMOcL3Ar3V8Fk59F
 ssY6JhE/K6V11uxbW4il1vvs=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e413e8c6e9ff3dee;
	Thu, 29 Oct 2026 11:52:58 +0000
X-Mizu-Trace-ID: e413e8c6e9ff3dee
X-Migadu-Flow: FLOW_OUT
Message-ID: <eebfec12-d0dd-433c-9332-f1e894fdcda8@linux.dev>
Date: Thu, 29 Oct 2026 19:52:53 +0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] ksmbd: route WRITE requests to an unbound
 workqueue
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com,
 chenxiaosong@chenxiaosong.com, tj@kernel.org, linux-kernel@vger.kernel.org
References: <20261022092514.2590010-1-huiwen.he@linux.dev>
 <20261022092514.2590010-3-huiwen.he@linux.dev>
 <CAKYAXd9Ow2SeZ1EjR7UBF3rmMn4=HKZrKajNdFU5TAnLVf=THg@mail.gmail.com>
Content-Language: en-US
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAKYAXd9Ow2SeZ1EjR7UBF3rmMn4=HKZrKajNdFU5TAnLVf=THg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Namjae,

在 2026/10/24 12:26, Namjae Jeon 写道:
> Since this improves performance, why isn't it enabled by default?
> Also, I would like this setting to be on/off via ksmbd.conf.

I left it off by default for now, since I've noticed some
regressions.I'm testing more cases and trying to find a general
fix. If those regressions can't be avoided, a ksmbd.conf option
would be needed.

> For 4 KiB single-channel WRITEs, throughput drops from 219.55 to
> 193.01 MiB/s. Should we add a size check here to keep small WRITEs on
> the per-CPU queue?

I tried keeping small WRITEs on PERCPU and routing only larger ones
to UNBOUND. However, this did not work well for workloads with mixed
request sizes. For example, a workload mixing 8 KiB and 64 KiB WRITEs
still regressed. Small and large WRITEs share the same connection and
send lock, so a size check alone does not avoid contention.

I then changed the send path to let one worker send several completed
WRITE responses together, without waiting for more responses. This seems
to work better:

Single-channel WRITE, 16 jobs, QD32 per job, tmpfs on a 128-CPU server,
Throughput is in MiB/s.

Size       PERCPU    UNBOUND+batch    Change
4 KiB       228.12           248.89    +6.96%
64 KiB     1797.26          2091.17   +15.34%
1 MiB      2188.42          3330.72   +53.47%

However, I found that there is still a performance regression at QD1.

1 MiB WRITE, one channel, one job:

With schedutil:

QD    PERCPU    UNBOUND+batch    Change
  1   1945.94          1021.28   -47.52%
  2   2844.66          2567.18    -9.75%
  4   2338.03          3547.42   +51.73%

Performance governor on all host CPUs:

QD    PERCPU    UNBOUND+batch    Change
  1   1974.35          1785.16    -9.58%
  2   2904.12          3038.52    +4.63%
  4   2418.45          3659.93   +51.33%


CPU frequency scaling makes the QD1 regression larger.

The main challenge seems to be balancing CPU locality and parallelism.
Keeping the work local helps QD1, while allowing it to run on another
CPU helps when receiving and processing requests in parallel. I have
not yet found a suitable policy that works well for both.

Any ideas about this?

> This walks the entire channel list and sets multichannel_seen again
> whenever an additional channel is registered. Since the flag is
> sticky, all existing channels are already marked when count > 1. Could
> we walk the list only when count == 1, marking both the existing and
> newly added connections, and update only conn->multichannel_seen when
> count > 1? This would avoid the repeated traversal and stores.

Agreed. Thanks for pointing this out.

Best regards,
Huiwen
