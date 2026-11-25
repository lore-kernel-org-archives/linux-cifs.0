Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.194
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597114;
	b=Az4VGCX3qHmjVM3QF40HZTQQgVou17Vwa4/NZvJHNIfLyG96z9JBd8XtCQFA2yrC80/Y
	 Frq3xfExejSrJ5w3lRp1XDiEQkWINLrWcDugcCcLCV2svX6Cjt2igEZ6VA2rMmbLGpJZh
	 jZrS8v11FU0mTJ22xxShFh0y9jzBpLCjK2kfIh3plWUXxJZyMBLhPD411ezfDkvV6ocbm
	 0tcXq/ZecYk0CQR8hVE+BRxWaBVdexVMvUh0KPwWp1NfxtM2DJbfzKMjl0nWJdcxkSbb2
	 JZoJEO5Xv2RYUZRO5oOBELgM50sC95Ah5VQ+ShMwV9pRBIo7CHH4SUYYwrfFdy7x34Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597114;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=bc7nuZMJjZ66RAXa3XZY4QgSdXa+1/f74i4Vd6ipG/k=;
	b=cpLmhjBHJOlS4oq1WB+hWpXgKD70wTQ+FbODVOmqo4zgI/PNJ1dGaH0uoYcJcXBcVYrs
	 74VlxEGoiJEFg3rsuQ1jKjE132GbAZaaxnqpg9Ws1hEJY/vbKY5QwBGKsHLyZzKMHo/1K
	 puBabntaIhrr7h3DKT+CYJOI+lGSJdT5f76J9r8Z4T0bXrxu0FoVk+2pJnv1+1OsBA+ZB
	 EyaMWeJzHFDJjmtjyOcvT776YGSN3PzAngp5KO2CpmIS9K/qtpSYWll9WVAte/7BWHHme
	 lRfyW2y/pWVgysC0A14SJPbfTIBr3UmYfxcMwArSC5Dv7/p8NufjxkanLSmI9M0bHlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QUsAl538;
	arc=none smtp.remote-ip=95.215.58.194
Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21D3606A330
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 08:58:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B21D3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QUsAl538
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=23kp1HdGjIM/G8/9zl1qp3aH6HKsh3N0XvtatOV79V4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795597111; v=1; x=1796201911;
 b=QUsAl538dWTfDlpiXoNuSpX6tiLDrai6hCFVGrpE4QOjfibJ61qzB8XJaT1ZmKPgq5YSUdVI
 9hPhiQDwxHaBaxBPx8ALiyFLBgTsoCtMzELBJs3LTCxXzLOXxVYy2ASuDPZpWrYzA3lk5drnvUI
 G5M2lTqtmNpBSZjoMLLNvCC0=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2c9cec84fe8096d0;
	Wed, 25 Nov 2026 08:58:31 +0000
X-Mizu-Trace-ID: 2c9cec84fe8096d0
X-Migadu-Flow: FLOW_OUT
Message-ID: <ec609ac9-c250-4e38-a0d1-9f7ff5252436@linux.dev>
Date: Wed, 25 Nov 2026 16:58:23 +0800
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
Subject: Re: [PATCH 0/2] ksmbd: splice READ payloads over TCP
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-kernel@vger.kernel.org
References: <20261124132554.1185817-1-huiwen.he@linux.dev>
 <CAKYAXd_GDhds=X8OgLCU6f6MqtF4A-7fZiQz-829SWSdUKJbdA@mail.gmail.com>
Content-Language: en-US
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAKYAXd_GDhds=X8OgLCU6f6MqtF4A-7fZiQz-829SWSdUKJbdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Namjae,

On a single TCP connection, pure per-CPU makes the RX thread and workers 
fight for the same core.

Pure unbound fixes that, but causes other problems: parallel workers 
still contend on srv_mutex and send small replies one by one, cross-CPU
execution hurts locality, and under schedutil spreading the load can 
drop workers onto lower-frequency CPUs (on the 64 KiB READ send path we
saw ~1.97 GHz with per-CPU vs. ~0.9 GHz with unbound). For serial 1-job
QD=1 writes, there is no overlap to benefit from either.

For example（Throughput：MiB/s）：

Workload           jobs/QD   PERCPU  UNBOUND   Change
-----------------  -------  -------  -------  -------
1ch, 64 KiB READ     16/32  2051.38  1387.34  -32.37%
1ch,  4 KiB WRITE    16/32   215.82   182.71  -15.34%
1ch,  1 MiB WRITE      1/1  1948.84  1109.46  -43.07%
4ch, 64 KiB WRITE    16/32  2788.42  2497.57  -10.43%
4ch,  1 MiB WRITE    16/32  3482.73  3291.34   -5.50%

So I tried sending only WRITE requests to an unbound workqueue, batching
completed WRITE replies, and only using the unbound queue when WRITEs
actually overlap (keeping serial WRITEs per-CPU). So far, across 
low/high QD, small/large blocks, READ/WRITE/mixed, and multichannel, it 
performs better than per-CPU without introducing the unbound regressions.

However, given how complex the overlap-detection logic is, I'm not
confident enough in its reliability yet and want to see if there's a
simpler way. Right now I'm thinking of keeping a few switchable modes in
ksmbd and picking the one that works best in most cases as the default.
What do you think?

Thanks,
Huiwen

在 2026/11/25 15:29, Namjae Jeon 写道:
> On Tue, Nov 24, 2026 at 10:30 PM Huiwen He <huiwen.he@linux.dev> wrote:
>>
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> ksmbd reads file data into a private response buffer. TCP then copies
>> the payload into an skb. If the reply must be queued, ksmbd also
>> copies the unsent bytes into a queue buffer.
>>
>> This series uses MSG_SPLICE_PAGES to avoid those TCP copies for plain,
>> standalone READs: patch 1 splices the initial TCP send from private
>> pages and a header page fragment, and patch 2 retains references to
>> unsent payload folios on the send queue so the send worker can splice
>> them as well.
>>
>> Summary of fio sequential read results (16 jobs, QD32 per job, SMB3.1.1
>> tmpfs; each column is relative to the preceding commit):
>>
>> Channels  I/O         Throughput change        Host Gcycles/GiB change
>>                       patch 1    patch 2          patch 1    patch 2
>>         1  4 KiB        -0.3%      -0.9%            +1.8%      -1.1%
>>         1  64 KiB      +28.4%      +0.9%           -31.5%      -5.9%
>>         1  256 KiB     +60.8%      +5.3%           -40.5%     -22.5%
>>         1  1 MiB       +51.5%      +9.2%           -33.1%     -32.2%
>>         4  4 KiB        +0.2%      +0.2%            +0.9%      +0.2%
>>         4  64 KiB       +3.9%      +2.6%            -6.9%      +0.8%
>>         4  256 KiB     +12.1%      -0.4%           -43.0%      -0.8%
>>         4  1 MiB       +17.6%      +7.1%           -39.5%     -34.7%
>>
>> Huiwen He (2):
>>    ksmbd: send READ payloads with MSG_SPLICE_PAGES
>>    ksmbd: retain unsent READ pages on the TCP send queue
> I don't see any patch using unbound workqueues in this series. Will
> you send it to the list later ? or need to check it more?
> 
> Thanks.

