Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1516136358;
	Sun, 17 Aug 2025 09:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755423942; cv=none; b=MNL1jlq6P444hgoJmg1sBi2rA8CKRKIsELRk+WulAUOkQqWS3wySWtpB/LsgDz2vqlEkiE+tzqrccxdexYyChpTGthpcnTE3MyYUxTKw6uh4ILdn78S/IZHhZJsjxCcf33JXJfSoJEHOynTHRhDuRnloNoaABrm48JlPdGIBUAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755423942; c=relaxed/simple;
	bh=kUKw3kLd7iexL+xRquTb47RXamJLX71sd8yk+SrZVAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lp3oafVfKz2SHjwQXIpl76Obun6p+3Hg+8emVJ2bnbzTc017ssUxmE7p1Xo/y2+8RAp71e/hYnjri+cG0LC/Iw3RXpZtQG0ZxaAXzHU260CSFaCOEaK9pup6nJHcQ+HN2wvGM/euPJ2RkRRtPQyOU3L/fzZgI1Ub56sKEmDxITo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nydQK3/p; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nydQK3/p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=OI4yJdSASRHDaXzs0fqnSdNo/8g/kJLlvZ5t0H3MptY=; b=nydQK3/pT2L0WvvHlWcIyMLeX2
	BW8oHniUT3OXbbW4b9nZmX16ioFslGIxeCZItCXnAqEE4s9Gtld1K1CwaeqKuaZZvnB4hgJ2DPpF4
	HdwCy8rqsKWoFSIUyhz188yJj0f/BE+MiBR/k/g9r1kwnUeFnkZzebxsLkaROn4QmBJ8wENcefJlo
	QAm8Fw0goAhWOYhAElYPVKmIxi4iFO7bpIhSTe8CAlZ+FIFzcpV9fXrts65tBk3hCYiB2ekkrjFdV
	JTG82YacO2mFBDhyVpvqgozuSfzgjUm+IuOLJSTX3Mi4vzgkb4a1m/Y0A4mXE7l+Ac2luMalvwzRa
	kckB8HwY2tT1Ub7IEyi2VYiN1n4wdl341xqGp5en6Sxvf/dKpwwCc5fCg1CMIATpn3jO+OuBlIfPT
	MQ3qKKLFYom5dvQuYeMx4gTtu1xMMfDOXnZhUsWKKd/F5cQT9TjSRLXj6JZ+G7JAmsEY5BP/GQIFP
	SVRZElSX7CHYTRV17Hf0rFvD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1unZxE-003GXO-0Q;
	Sun, 17 Aug 2025 09:45:32 +0000
Message-ID: <c582ccee-9425-4f4e-a04a-c86e9992e917@samba.org>
Date: Sun, 17 Aug 2025 11:45:31 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 563/627] smb: client: let send_done() cleanup before
 calling smbd_disconnect_rdma_connection()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Steve French <stfrench@microsoft.com>,
 Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173453.306156678@linuxfoundation.org>
 <527dc1db-762e-4aa0-82a2-f147a76f8133@samba.org>
 <2025081325-movable-popcorn-4eb8@gregkh>
 <6acc8228-da51-4528-87c4-4cb2c96d3e8a@samba.org>
 <2025081301-carpool-gully-cbfc@gregkh>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <2025081301-carpool-gully-cbfc@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

>>>> Am 12.08.25 um 19:34 schrieb Greg Kroah-Hartman:
>>>>> 6.16-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Stefan Metzmacher <metze@samba.org>
>>>>>
>>>>> [ Upstream commit 5349ae5e05fa37409fd48a1eb483b199c32c889b ]
>>>>
>>>> This needs this patch
>>>> https://lore.kernel.org/linux-cifs/20250812164506.29170-1-metze@samba.org/T/#u
>>>> as follow up fix that is not yet upstream.
>>>>
>>>> The same applies to all other branches (6.15, 6.12, 6.6, ...)
>>>
>>> Thanks, now queued up.
>>
>> Even if it's not upstream yet?
>> I thought the policy is that upstream is required first...
>>
>> It's only here
>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
>> as
>> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=8b2b8a6a5827848250c0caf075b23256bab4ac88
>>
>> But that commit hash can change on rebase.
> 
> Ah, I thought since this was in linux-next it would not rebase.  Having
> public trees that rebase is dangerous...
> 
> Anyway, I'll go drop both of these now, please let us know when you want
> these added back.

It landed as 8c48e1c7520321cc87ff651e96093e2f412785fb, so
5349ae5e05fa37409fd48a1eb483b199c32c889b can be backported
with 8c48e1c7520321cc87ff651e96093e2f412785fb being the fixup.

Thanks!
metze

