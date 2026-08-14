Received: from mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88023346A04
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 06:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786690450; cv=none; b=SN/YUogRqIHT4zZ3xI45DTm618ZeZNm6S/4Hv73/LacsbZwwa8BedP5J0y8GhrcJIkB3lG1hYA7Vz+Y3I04ScccgR3wEhhxp7zObkExG99gfZkZO+m9xcxRa/J15lhgcOw6S+VEmDfJnwok2EYzmLqJqetZADxEe0GA7FQfajgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786690450; c=relaxed/simple;
	bh=KdlIFbgznjim3/u/SQSk/mZxKLT8y95RNimSlZME7T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=flLOBOeTobpxZLz2h4KuiQ82LI978DtWUd0TjmUZmDrRQha4WsW6uRYGHURmknh2gypPio9IqAnMXdRUeV/ZYyweTKQpGGzTBu6FBIIQg1+x1ezcH7V1xeVP8GrO/VhHEUfeA1M10B7PcQmTOT8mw2nFxkSy2/APJIdzA+1jQAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=vsBNyZA2; arc=none smtp.client-ip=95.215.58.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="vsBNyZA2"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KdlIFbgznjim3/u/SQSk/mZxKLT8y95RNimSlZME7T0=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786690445; v=1; x=1787295245;
 b=vsBNyZA2/69jO8fIVmr1mUdX2zcH4d6JYMANo5/wngeVNedV/q+iNXHUwsuwCx/kkcXXW4GW
 ty1yDA4Ur+aNJU/NCIShrl+975HXdzqbHmWv6E5kUHw8K9h3/pHfvNct1+gZMa/MCBLs6bvt9oU
 sZujGHF3au5YyqFGjXijAYmHtHs2iw6yWWUt+526n/CW+zwfc5r77uGOyy+8CBN3P6IX0k5RTmL
 7NGb1fOp4fB0WyEOwbW+XDsRbZSgiT3PKoFQACXhNYNfOOjrfP4yqU9lKdBpkhtk3cfa59WnzGb
 oVE/MzFt7G4hV290MjFo6pb4u5WCaHDkgMOPWrQf5T4XQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id e5cdd6f85c070ce0;
	Fri, 14 Aug 2026 06:54:05 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <e983cf59-ef97-4ca8-945e-079e8a44b3d4@chenxiaosong.com>
Date: Fri, 14 Aug 2026 14:53:22 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Blue bird <obnred@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, smfrench@gmail.com,
 senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <CAKYAXd-B1mjT-JONqToLMeQKmV_GRdR1Pogi9VugyCADATpO3g@mail.gmail.com>
 <930abff2-18f6-4a68-ae07-1e3675c90ae3@chenxiaosong.com>
 <CALT=-84nzBrQx62WgOkdQeDfB6+75O31uPoN2hAiBO=xO=tnWQ@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CALT=-84nzBrQx62WgOkdQeDfB6+75O31uPoN2hAiBO=xO=tnWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for updating the poc. I have confirmed that the issue can be 
reproduced without reverting the patch.

On 8/14/26 13:51, Blue bird wrote:
> The one-line fix on my side is to continue impacket's sequence instead of
> inventing one:
> 
> self.tid = self.c.connectTree(SHARE)
> - self.mid = 4096
> + self.mid = int(s3._Connection['SequenceWindow'])
> 
> With that, the reproducer works on ksmbd-for-next-next with the sequence window
> patch in place -- that is how I got the 1.6 s / 142 request figure above, and
> the test of your patch was run the same way, with nothing reverted.
> 
> The other thing that silently zeroes locks_sent is the per-IP connection cap;
> the harness churns connections from one address and hits
> "Maximum IP connections exceeded (32/32)". I set
> 
> [global]
> max ip connections = 0
> 
> for testing.
> 
> So: a non-zero locks_sent is the thing to check before trusting any negative
> result from this reproducer. Sorry for the detour -- I should have flagged it
> more loudly when I first hit it.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

