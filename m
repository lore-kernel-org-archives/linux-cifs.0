Received: from mail.pre-sense.de (mail.pre-sense.de [213.238.39.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB07946C
	for <linux-cifs@vger.kernel.org>; Wed, 16 Jul 2025 06:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.238.39.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752648350; cv=none; b=swbkSFl0QYselkBdmPlVPcY8ug7vKqhahDUkCkY1ZRE1ZXo7r3ASoCNXwrlkHM+Zd+CgCuvOzZdiZNVDWLKLRiBDVlHhnKTnqQfaun05UZPJP0uLpoCPRuzqpSGwcaJrsVpm4p3nHLuCCmF4rJXEa/VabRmRjHBr5cKW51qUz3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752648350; c=relaxed/simple;
	bh=JVnsMskd5W+DiHivDnw0g22YJcZLMre3LXucevp3YCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KNrqLpM1X9cgeeE7tUuDycS21AJYav2xCva9k2NjU4DnnqLH6sGzyU6L81Nt8osw/cnV2uMYVvm12Fz2tFxvVJb7mAeGDPkJaRuNmiNjYCY0pSMZ3HUDxel+ReqeA2M3wCIN9pl+rtHRjxCX3ys8zGAv+5S/m6wfEAvLcPgSi1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pre-sense.de; spf=pass smtp.mailfrom=pre-sense.de; dkim=pass (3072-bit key) header.d=pre-sense.de header.i=@pre-sense.de header.b=OCQzgAp+; arc=none smtp.client-ip=213.238.39.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pre-sense.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pre-sense.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=pre-sense.de header.i=@pre-sense.de header.b="OCQzgAp+"
Received: from smtp.pre-sense.de (tetris_b.pre-sense.de [10.9.0.76])
	by mail.pre-sense.de (Postfix) with ESMTP id 6B1005E057;
	Wed, 16 Jul 2025 08:45:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pre-sense.de;
	s=202407; t=1752648338;
	bh=JVnsMskd5W+DiHivDnw0g22YJcZLMre3LXucevp3YCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OCQzgAp+aQUlalYi4QabDIgQdoKWhuQ2VEiDHUBLI3F/Q4dqKUlxacnAOmf45xR+r
	 0HOn/2YAGBxBpMOii48mDluOBCNZYKpmPWFh9x5jB0aGD9X1RIkkyJLhIkz/lz6A5h
	 Fdm2LumANxkWpsmBiXYgGzuPEhPDGPTGWYLW0GfBnK1A+wb55qh96nr0bLjeoVDccT
	 SUJq24USg7gXeOek/pK0c7TZF4ao9bbnwsjV7KLEwO15yh/GWBHhYKY9w64Qcb2wEw
	 6M6S0Ci3a85WwIVLdxgJQjSHzNsvsnAgZL7AldydhMPRRUCTn9GeY13Qb1/aC5WVTL
	 glBhkvzQlN1EYwo19jDthhiJugDfCs/Al0UYUiv6n0fjvxZ36Zgr78aKBY9zgTvuOh
	 B8Ud0aGzCz/VYcDh6cyjDIOnYXdPWw71BNWEriFmpKm2CipmkrzFAsiQ2qwHnV8vT5
	 dDN1Q+5OxRbQClxhTzqgXonbg3Ikj07G1MIXt+AkGIZdNl3e0mD
Message-ID: <26a52d1e-f829-4264-a39b-a9591a5d9eb1@pre-sense.de>
Date: Wed, 16 Jul 2025 08:45:37 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using UPN with mount.cifs?
To: Alexander Bokovoy <ab@samba.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
References: <a97b22e8-144e-45ed-8850-c3fd18769a6c@pre-sense.de>
 <CAH2r5mtgWfxQtoy2gwnMiWM3HXno2icuWmiuhMJ64yTAi_jsyQ@mail.gmail.com>
 <aHXuSKMsQsPWd5NC@toolbx>
Content-Language: de-DE, en-US
From: =?UTF-8?Q?Till_D=C3=B6rges?= <doerges@pre-sense.de>
Autocrypt: addr=doerges@pre-sense.de; keydata=
 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
Organization: PRESENSE Technologies GmbH
In-Reply-To: <aHXuSKMsQsPWd5NC@toolbx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

thanks for your answers.

In our setup we use NTLMSSP and a NetApp.

If I understand you correctly, mount.cifs basically cannot use the UPN to 
authenticate - or at least not reliably.

Simply splitting up the UPN (<user>@<domain>) for mount.cifs doesn't work either, 
because the SAM account name has a different domain and also a different username scheme.

Is there a canonical way (with Linux) to map a given UPN to its SAM account name?

Thanks -- Till


On 15.07.25 07:59, Alexander Bokovoy wrote:
> On Пан, 14 ліп 2025, Steve French via samba-technical wrote:
>> This is an interesting question.
>>
>> mount.cifs will pass it (the UPN) down to cifs.ko so it will get sent
>> on the wire, so behavior will vary by server.
> 
> Is this with GSSAPI krb5 or NTLMSSP?
> 
> For GSSAPI we either expect already existing credential or initialize it
> from a keytab. In the first case cifs.upcall is not doing anything to
> enable enteprise principal because it is not handling the initial ticket
> acquisition. In the second case it doesn't do anything to mark the
> client principal as an enteprise one.
> 
> The difference is by how that client principal is marked down in GSSAPI
> negotiation. It needs two parts:
> 
>   - a client name should be an enterprise principal,
>   - client code should make sure it sets a flag to accept rewrites of
>     its own client principal name by the KDC in the returned ticket
>     (principal canonicalization).
> 
> Neither is done by the cifs.upcall. More to that, for GSSAPI krb5 the
> username passed to the cifs.upcall is pretty much ignored except for the
> keytab initialization.
> 
> With NTLMSSP you don't really have 'enterprise principals', as it is up
> to the SMB server to interpret the name you passed.
> 
> The client has nothing to indicate that. A server may consider
> interpreting it as a local machine-provided one (username=testuser), or
> consider to map it into the local one even if it has domain name
> explicitly set (such as with IAKERB case on a standalone Windows).
> 
>>
>> I tried it to current Samba (passing "username=testuser" and also
>> "username=testuser@somedomain" and also for
>> "username=testuser,domain=somedomain") and it worked fine for all
>> three cases (with and without UPN, with and without "domain=").
>>
>> Trying it to Windows though:
>> 1) "username=testuser" worked
>> 2) "username=testuser,domain=somedomain"  worked
>> 3) "username=testuser@somedomain"  did not work to Windows server
>>
>> So looks like the behavior varies by server, but safest way is to
>> specify the UPN as "username=" and "domain=" rather than
>> username=someuser@somedomain
>>
>> On Mon, Jul 14, 2025 at 7:44 AM Till Dörges <doerges@pre-sense.de> wrote:
>>>
>>> Hello everyone,
>>>
>>>
>>> I'm wondering whether it is possible to use User Principal Names (UPN) instead of
>>> accountnames + workgroup/domain, when mounting a share with mount.cifs?
>>>
>>>
>>> The man page for mount.cifs does not mention UPN. A quick grep through the latest
>>> sources (cifs-utils-7.4) doesn't mention UPN either.
>>>
>>> Searching the ML in particular and the web in general came up emtpy, too.
>>>
>>>
>>> So, is there a way to do it?
>>>
>>>
>>> Thanks and regards -- Till
>>>
>>> --
>>>                                           www.pre-sense.de/fcknzs
>>>
>>> PRESENSE Technologies GmbH             Nagelsweg 41, D-20097 HH
>>> Geschäftsführer/Managing Director        AG Hamburg, HRB 107844
>>> Till Dörges                              USt-IdNr.: DE263765024
>>>
>>
>>
>> -- 
>> Thanks,
>>
>> Steve
>>
> 
-- 
                                         www.pre-sense.de/fcknzs

PRESENSE Technologies GmbH             Nagelsweg 41, D-20097 HH
Geschäftsführer/Managing Director        AG Hamburg, HRB 107844
Till Dörges                              USt-IdNr.: DE263765024
