Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795580954;
	b=R/lQzI8dOAIVs8M559Ghih0ISd4vLgVqf2UmYoxvIS4ittcq2mG7yKGa/zmHtxtN7x71
	 Jpfm/EjGp7evC9RSdBZpVATH9icKunIYPUuRFCGUNL3FDQzmeG7rcNv5/+BAvqB7uBARb
	 5dBf0NYvdMVWwJ/Lm8yiguciJZmDcWEy3Dz+tw4jCS4eC5KdSMGqL9Ux7CElU1MW22hPY
	 E62m5m4t+nVoabVT5i/y7Htnp8DU00MnCaOg4v3JbAmVhIHwpsYeEsG0ncjwT8XKqSMwZ
	 DbLsZ4lwIXfhMH6m6OgB8GSbQKyfu/vti+h2eHxAJ7bl4iRtg4aUJ8PdCAd1XT5IPTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795580954;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=rqapGEif3pOFnTQjLzudYGSBpb8F1n57DN8SWyMte9E=;
	b=zX15VEW7RWJ6iv4Yatotwln621iizJK77Q9VX4qyYPYVe5cLeP0RxP7nUbUIfxlXrkXs
	 wZJ8hX4YD8WD7tsVKq1uHDv0hWUaKDLlN52nZnOKSM1Dtnq6BCDNtVosM4+4fPMGTySrS
	 QjmpFg/XNkkT9O2D6eHY0qjz92dSgTozQttqv10lQGcvTcd0h+7jLIo1U8nx8dPBSw5nb
	 FUgDnfBoYXsqtk1oz42GnKf37tSflk95BD/Qv+oPQqryjKHkHU1PpSIlmkX6uAy6BnJ8j
	 1b2O9/aHvt3I2vED7UoS6ivR7vLRlOfTS4PIpQzqvBjXULdg28UjJZCGDkk2fXBFgsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=o4Qzim7j;
	arc=none smtp.remote-ip=95.215.58.17
Received: from mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F56606A321
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 04:29:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32F56606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=o4Qzim7j
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=W+sC4+T1oBRbe2aR0eng8GaPnp96q47rE2lkk+nu9V4=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795580951; v=1; x=1796185751;
 b=o4Qzim7jPimtxnu1EOxk5IiMOP8bNgJ7m8Uyx2UZ1hk6Fy+kOoUbsaKuvraRg4tk7jkFjRqa
 cEsP7SY/nHyfXk2h3C2bCXnQ6nxHwu23qdVltVTT9vLIPUsHVsCFu+9Q4SOzOOQF+531DROk/34
 e8FKyqjicbuVIcjEw2wv0mHJm/PKyVW1oYeKMteAnYKljOb2NZUEWtuYLsRjAjsfthkZGWIa7AD
 iM0JqSZLEN10+rs2Y+7zsLnLNzAT3irXTt11UbPz38AvlJsMAiUKLklQhZfExpI7S9uiczkGAYz
 XEVjk/p06pZtJ9jAHOLdu5i/n1ST7EyqpcyzUaokHBaYQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ef756b0f33637438;
	Wed, 25 Nov 2026 04:29:10 +0000
X-Mizu-Trace-ID: ef756b0f33637438
X-Migadu-Flow: FLOW_OUT
Message-ID: <a5b87baf-0573-4c47-85f4-0629dc1cf000@chenxiaosong.com>
Date: Wed, 25 Nov 2026 12:29:01 +0800
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
To: Huiwen He <huiwen.he@linux.dev>, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, linux-kernel@vger.kernel.org
References: <20261124132554.1185817-1-huiwen.he@linux.dev>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20261124132554.1185817-1-huiwen.he@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 11/24/26 21:25, Huiwen He wrote:
> From: Huiwen He <hehuiwen@kylinos.cn>
> 
> ksmbd reads file data into a private response buffer. TCP then copies
> the payload into an skb. If the reply must be queued, ksmbd also
> copies the unsent bytes into a queue buffer.
> 
> This series uses MSG_SPLICE_PAGES to avoid those TCP copies for plain,
> standalone READs: patch 1 splices the initial TCP send from private
> pages and a header page fragment, and patch 2 retains references to
> unsent payload folios on the send queue so the send worker can splice
> them as well.
> 
> Summary of fio sequential read results (16 jobs, QD32 per job, SMB3.1.1
> tmpfs; each column is relative to the preceding commit):
> 
> Channels  I/O         Throughput change        Host Gcycles/GiB change
>                       patch 1    patch 2          patch 1    patch 2
>         1  4 KiB        -0.3%      -0.9%            +1.8%      -1.1%
>         1  64 KiB      +28.4%      +0.9%           -31.5%      -5.9%
>         1  256 KiB     +60.8%      +5.3%           -40.5%     -22.5%
>         1  1 MiB       +51.5%      +9.2%           -33.1%     -32.2%
>         4  4 KiB        +0.2%      +0.2%            +0.9%      +0.2%
>         4  64 KiB       +3.9%      +2.6%            -6.9%      +0.8%
>         4  256 KiB     +12.1%      -0.4%           -43.0%      -0.8%
>         4  1 MiB       +17.6%      +7.1%           -39.5%     -34.7%
> 
> Huiwen He (2):
>    ksmbd: send READ payloads with MSG_SPLICE_PAGES
>    ksmbd: retain unsent READ pages on the TCP send queue
> 
>   fs/smb/server/connection.c    |  18 +++
>   fs/smb/server/connection.h    |   1 +
>   fs/smb/server/ksmbd_work.c    |  24 ++--
>   fs/smb/server/ksmbd_work.h    |   8 +-
>   fs/smb/server/smb2pdu.c       |  74 +++++++++--
>   fs/smb/server/transport_tcp.c | 223 ++++++++++++++++++++++++++++++----
>   fs/smb/server/transport_tcp.h |   1 +
>   7 files changed, 301 insertions(+), 48 deletions(-)
> 
> 
> base-commit: 89d5e8fdd5a74a318d18b7267c4ec5d70b2285f1

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

