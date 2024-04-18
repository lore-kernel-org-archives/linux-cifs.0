Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830CE15AAB7;
	Thu, 18 Apr 2024 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448029; cv=pass; b=qVWMezjvp2z5DVdPwtoaqaLcVgK1cZkiteG2cUuuMV29rU20f5GIg4TpRFxeTRo591bi1XcxcXyXaBvh72l78pyhkmOxltIRInYKcgGQ4QUJJ9M6lf4Aene2ug5RBeX9WbHPiYLZHtVigue0psHuv8JWj2NuGEuJT72fBRPtzzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448029; c=relaxed/simple;
	bh=O4NLUl1PjH8QiQoDvqx/qELU67RP3FS7QbuTtQCXt20=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ZQPcl0UlGIZGPzH0N6q1OFoZOlyby6wRHSb++3ZfO5d+ZZpvgcWOe5xz2iLA+H2ktsSYCtaZ7dhUtYq/nGG1VtIFWVDAirGGjFfkqrUGKU/NGYNH+VGIC3abe+lRRr3y6l6cN7tkJc7OwY4R2v4fZZTNdygPG9JcWkDWfX3eTSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=UB8HuKZl; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="UB8HuKZl"
Message-ID: <29e0cbcab5be560608d1dfbfb0ccbc96@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713448024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7rU0kOVmyBLX9ndqmurxB34d6Cclj332xnTjEKvm7HA=;
	b=UB8HuKZlNT0DFaxFELpQyJIHcVKpTxtAd3P8hAyt5sJuunUsJ3b6l4pAsRezCp2MGzu4xI
	I0/SQyhtEO9HILsKY3b20D8O6ufJ3pxz2uhiPE8c/9+6OBMsfWYohMO4YnYpETMb48JwtG
	IFNgXoCYWsm8oi59KzT5eRQEz0VX/grQozCt2y7lMFXyubT1avJbMOuy+L5tIAU8sI6VCY
	hsamDTIMnHHYDMneURyrfvgu/aA9LfRUKkR0s0301vE3A1BYvjMO+Br2mI1VNt6ybin41+
	2HcDsCdXhX/f1gRqofpzJk5OXGU0qZN26AXj6n8m6OZ2Oi9SfupY6NuhBGncQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713448024; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7rU0kOVmyBLX9ndqmurxB34d6Cclj332xnTjEKvm7HA=;
	b=a2Bi8TZD3NAuhNV3ohoMtEBiMtrH+9kRTWj6jKFEVsXQp6N68s5JgLgE5Plocme8zP4T/D
	CzwC7y8qFBV4g5rGojVB54TjR7u2uujOQjVmf37vLvLi+6bTEOiPWKayQKruAe6pyn0Ggx
	hoiappzpHfJPRh5rY0233exMp8eIt8WWCwQG+TXLEghJYSh3ibeQU7Gra11FywU3iqBakX
	BBgTwJGFEDxp2+em5NZrbOQbB0QIOvwOhh0ZB6WERHwd/6hANWtI1QeyAWefGcs8gwO+aM
	o5CBmt+bJ7aiPwHVcOmUz4qUPGy5zG3IbKsjcxVhpvCFOtU1T1i8YF6TzQqdKA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1713448024; a=rsa-sha256;
	cv=none;
	b=kUtYyctEG3LKddBFEQCb7K3qzEgAOzCZ8ZymcGRwUG3IJetAsrrQPH3mLO84p+xuMrgJzp
	Ne3OKlF47QG0xyUJQy13AOZhhKWKPpSkJOcbPqKzkdDnPjYqdbHsQg9EW7h2U9Is5295Fo
	eE9qRK/Wdny4Asok8QXSgKxAUgvXOE9yiZPbpLwU+TTteQIHEDYl8wVG/lP6UXZN7KSTie
	b+FV+bCdS9z+V2ciJkxGzyyLVI3DbNRKGMsTNhdbQbcQrJrjFK5/dumdlWyG/AoAEVpQVd
	+lKrHgSalUou3Nu2uRbFGtLJrnPIiy1/ou6lW9xilglvW3Y75ezYGl5ARTCdHA==
From: Paulo Alcantara <pc@manguebit.com>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: regressions@lists.linux.dev, Steve French <stfrench@microsoft.com>,
 gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [regression 6.1.80+] "CIFS: VFS: directory entry name would
 overflow frame end of buf" and invisible files under certain conditions
 and at least with noserverino mount option
In-Reply-To: <ZiCoYjr79HXxiTjr@eldamar.lan>
References: <ZiBCsoc0yf_I8In8@eldamar.lan>
 <cc3eea56282f4b43d0fe151a9390c512@manguebit.com>
 <ZiCoYjr79HXxiTjr@eldamar.lan>
Date: Thu, 18 Apr 2024 10:47:01 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Salvatore Bonaccorso <carnil@debian.org> writes:

> On Wed, Apr 17, 2024 at 07:58:56PM -0300, Paulo Alcantara wrote:
>> Hi Salvatore,
>> 
>> Salvatore Bonaccorso <carnil@debian.org> writes:
>> 
>> > In Debian we got two reports of cifs mounts not functioning, hiding
>> > certain files. The two reports are:
>> >
>> > https://bugs.debian.org/1069102
>> > https://bugs.debian.org/1069092
>> >
>> > On those cases kernel logs error
>> >
>> > [   23.225952] CIFS: VFS: directory entry name would overflow frame end of buf 00000000a44b272c
>> 
>> I couldn't reproduce it.  Does the following fix your issue:
>> 
>> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> index 4c1231496a72..3ee35430595e 100644
>> --- a/fs/smb/client/smb2pdu.c
>> +++ b/fs/smb/client/smb2pdu.c
>> @@ -5083,7 +5083,7 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
>>  		info_buf_size = sizeof(struct smb2_posix_info);
>>  		break;
>>  	case SMB_FIND_FILE_FULL_DIRECTORY_INFO:
>> -		info_buf_size = sizeof(FILE_FULL_DIRECTORY_INFO);
>> +		info_buf_size = sizeof(FILE_FULL_DIRECTORY_INFO) - 1;
>>  		break;
>>  	default:
>>  		cifs_tcon_dbg(VFS, "info level %u isn't supported\n",
>> 
>> If not, please provide network trace and verbose logs.
>
> Yes that appears to fix the issue.

Thanks for quickly testing it.  So the above change indicates that we're
missing 35235e19b393 ("cifs: Replace remaining 1-element arrays") in
v6.1.y.

Can you test it now with 35235e19b393 backported without the above
change?

> But as you say you are not able to reproduce the issue, I guess we
> need to try to get it clearly reproducible first to see we face no
> other fallouts?

I couldn't reproduce it in v6.9-rc4.  Forgot to mention it, sorry.

Yes, further testing would be great to make sure we're not missing
anything else.
