Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AF237A4F;
	Wed,  8 Oct 2025 19:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759952448; cv=none; b=Ixf4pkBh6pm2dnWyHEIoz/MT7XSBebdZ4axVzPw6Ht88AaQQlk/nCUvL/xi87iJHtyc03x2i/cyJTedLZ+Ad5T41o9uNGbNb30aWsoPcEv2pYs3CXOr3a8Ctf5rF2RGBaWw9JVg2xo1xNTGl6w4zziqBI8klF1TjJPqxoLYAg2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759952448; c=relaxed/simple;
	bh=XOnrmMWwxVFBnMVO7Ta7eL97SgQLueAuXSlhk5sHuxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ApN04xOOaJZ4ZD1rjUPbjwU0AGuDwqry0QkYrbrgoW2Shql6QE57Vg4g4w01ERH/I62SbfGhenr49eqqEYSxYQ3FIWwWYR8m60cV3quL9ut99VZ2XayvI3rGWpDEA9kpUFNPcff0yUG0EmMMh6vZyyJioTz9+753IdZANFdO850=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=mXABxiFt; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="mXABxiFt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759952427; x=1760557227; i=markus.elfring@web.de;
	bh=ryyxa63Wy3N8dRSeueUjZJIkSdeBzBk1q/YZMtKe2/Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=mXABxiFtOzewx/2064n6kVzyD0dRWgaa/bbs+oxXaQAdx4vZotHIIcYk6t00wB5A
	 s4Vg2BIUC/LKzZnkIP9sV3+o9etUpZIeifKTNCXeLxNHDvpxep8lLofT4YNjjt/32
	 kWhFBZAYeubuxWy3j49Fhvota3Po9BUj203pVAcDNWzrU68ictnBmsXzvzK10psy5
	 12/lpK9hMhf4hICbyT3RrU3Qo1wvAZdaTwfC6eq5rOHZE+AmnrKBsPGkS8Yhoeohf
	 aSajHfGO2/VN+P23bS12PvCl1fvNqXOx4CVs0ZEvN2BRnwOiBFtvM9x85W+8pU9Qb
	 xNXuLehZ3vep+2d4Vg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MzkSZ-1uKNFy0Jph-015a57; Wed, 08
 Oct 2025 21:40:27 +0200
Message-ID: <717a6d2a-b3f8-4296-b0b3-8738d1c1dab2@web.de>
Date: Wed, 8 Oct 2025 21:40:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: Move an error code assignment in
 smb3_init_transform_rq()
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Pavel Shilovsky <pshilov@microsoft.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <02627021-da2f-41f8-9ea7-fd2da96e0503@web.de>
 <5bd37df6-1743-4b9c-a83a-a811e221489b@suse.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <5bd37df6-1743-4b9c-a83a-a811e221489b@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jIVMvqdyoOWT9UqqOXm69WtFzMHQBCQdaRcA2wIh9HDAvjkNCad
 8PmiSUFa6t0eLJDEW7PIjPDyujvIXWOvKi7pBulmQDVLBKDTLDv3AQQ5Yjoq+IxwkXz7QiE
 Sf9QWp99VVo6/DTUPNX8S8/S/D6awh+05m0Sosbndn/RWGjFH5dWxfNtiGz1Xwr4A7T5kB/
 ynDMpHUkGPTGGzRaxcxNQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:81HFVJ0zwQA=;RS/KV6zD6a2LP0xfMyEeHCxQ04B
 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
 Jru4W7xTa3mDITHA8FVoRv6B5o=

>> Convert an initialisation for the variable =E2=80=9Crc=E2=80=9D into an=
 error code
>> assignment at the end of this function implementation.
=E2=80=A6>> +++ b/fs/smb/client/smb2ops.c
=E2=80=A6>> @@ -4611,7 +4611,7 @@ smb3_init_transform_rq(struct TCP_Server=
_Info *server, int num_rqst,
>>  		if (size > 0) {
>>  			buffer =3D cifs_alloc_folioq_buffer(size);
>>  			if (!buffer)
>> -				goto err_free;
>> +				goto e_nomem;
>> =20
>>  			new->rq_buffer =3D buffer;
>>  			iov_iter_folio_queue(&new->rq_iter, ITER_SOURCE,
>> @@ -4634,6 +4634,8 @@ smb3_init_transform_rq(struct TCP_Server_Info *se=
rver, int num_rqst,
>> =20
>>  	return rc;
>> =20
>> +e_nomem:
>> +	rc =3D -ENOMEM;
>>  err_free:
>>  	smb3_free_compound_rqst(num_rqst - 1, &new_rq[1]);
>>  	return rc;
>=20
> I don't think this change improves readability.
>=20
> I understand that making the assignment explicit is good,

Thanks for this constructive feedback.


> but why not simply set rc to -ENOMEM if !buffer and then goto err_free?

I proposed to adjust the affected if branch in this way
because there is no need to add curly brackets then.


> Also, I think its a bit confusing having inconsistent naming styles `e_`
> `err_`...

Which naming approach would you find more helpful for the marking
of a variable assignment instead of a subsequent function call?

Regards,
Markus
