Received: from mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA33442FAB
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611402; cv=none; b=lh/OxtVMksqqkbyLeMmezvkrVzDOfSO8cZiHTvIom7L5FkbEFN2oOEC2VAvc5EvYoQm7ZbmYSnnxz3G82nYG9d5lqd1fZrZhVHwmeWn1Kc+LgXMEJO1L38iE8euln7PAL+4GVTE1db78P/wJIK9uUhzWCM5sZ9dtkeSHEhOTYTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611402; c=relaxed/simple;
	bh=PrY3Ry77G1rxTGrVVyfj+EXbSi5ldofGD7Z6ZJtkEds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5dq/NfuWJYHaW+Rx6YEWMtvC/r2Cp9bhtqZPratnJD+gTZMKDCGDuM6KwHtHUPeL5nANjbiPI7UeqenODNeIcdJY/4XijPv4DAx4PAlQelxII6hCbPFiNJwD6rkW0xWuVPBa6mEUo02wE4lWoRYyvD01OVCfM+A7yEyS9nHpzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GlxUXEw/; arc=none smtp.client-ip=95.215.58.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GlxUXEw/"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PrY3Ry77G1rxTGrVVyfj+EXbSi5ldofGD7Z6ZJtkEds=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786611396; v=1; x=1787216196;
 b=GlxUXEw/TBjBOt5/B/lwZd/8Sm2ubrWNp29vEjRIzQxUuWK3B+iStHOarqQgMNd2BGt2y46s
 iGpLUVG0LgPZrS3bzAUQEhQVYuorCiqBtNRYWvrTdUee0NS7dj5ZkrBbSvs7JApN37HVeqqCke1
 YCB1BsH9ymHOa2oh22OTcVp10xpgQ6ZiOlOo74YTmtk/jRsFN+AaRWUzSG0KonDaavKkeWk6ypt
 9DkP9LLcfCA9YcWPNLs8708nvNyENBuy1svq6vmm5+Uocu1xIaxjao8+0QAmh/0SRo5tKAWe1ET
 dhP5TX4yLQui4tBCWNPIGZUMlSp/WrXs/RJl3lh1zL0jg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 64a1a7d5ecc15d8f;
	Thu, 13 Aug 2026 08:56:25 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <9ad355b5-5ae9-4dc3-98d9-cf46795d877b@chenxiaosong.com>
Date: Thu, 13 Aug 2026 16:56:23 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Blue bird <obnred@gmail.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
 tom@talpey.com, linux-cifs@vger.kernel.org
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com>
 <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Could you confirm whether you can reproduce it on `ksmbd-for-next-next` 
branch?
https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next-next

On 8/13/26 16:23, Blue bird wrote:
> Thanks for confirming it on mainline.
> 
> One thing about the for-next-next run: the output shows locks_sent=0,
> which means the harness never managed to send a single lock request, so
> that run did not exercise the path at all. It is not evidence that the
> branch is unaffected. The harness silently retries on connection errors,
> which makes a failed setup look like a clean run -- sorry about that.
> 
> kfuzz2.py defaults to:
> 
>      KFUZZ_HOST=127.0.0.1  KFUZZ_USER=fuzzuser
>      KFUZZ_PASS=fuzzpass   KFUZZ_SHARE=fuzz
> 
> so it needs a share named "fuzz" and that user to exist. Please set those
> to match your setup and check that locks_sent climbs before drawing a
> conclusion.
> 
> On the UAF you hit: I think it may be the same one I have now root-caused.
> Captured on a clean untainted mainline boot with continuous logging
> (ksmbd's own log spam overflows the ring buffer and hides the earlier
> faults, which is why I missed the ordering at first):
> 
>    [284.826] BUG: KASAN: slab-use-after-free in smb2_lock+0x33b4
>              Write of size 8 by task 1984
>              Allocated by task 1984: smb2_lock+0xa90
>              Freed by task 2119:     smb2_lock+0x23b4
>    [285.088] same task -> _raw_spin_lock on garbage -> Oops
>    [287.598] kernel BUG at fs/locks.c:312
> 
> Symbolized:
>    alloc +0xa90  ->smb2pdu.c:8156  smb2_lock_init()
>    free  +0x23b4 ->smb2pdu.c:8213  the cross-request unlock kfree(cmp_lock)
>    write +0x33b4 ->smb2pdu.c:8323  list_del(&smb_lock->llist),
>                     inlinedlist.h:260 == next->prev = prev
> 
> struct ksmbd_lock is on three lists: clist (conn->lock_list), flist
> (fp->lock_list) and llist (the*on-stack* lock_list / rollback_list of the
> request that created it). The cross-request unlock path removes flist and
> clist but not llist, so one worker frees an object that another worker
> still has threaded onto its stack-resident list; that worker then wakes
> from ksmbd_vfs_posix_lock_wait() and list_del() writes through the freed
> neighbour.
> 
> Note this UAF is the*first* fault, on an untainted kernel -- it precedes
> the BUG_ON rather than being fallout from it, and it is a write, not a read.
> 
> Also, please do not treat my earlier vfs_cache.c hunk as a fix. With it
> applied the BUG_ON still reproduces in ~5 s; the trace just moves from
> __ksmbd_close_fd() to smb2_lock+0x23ac, i.e.smb2pdu.c:8213 -- the same
> cross-request unlock path above, which that patch does not touch.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

