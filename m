Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B7533D6CA
	for <linux-cifs@vger.kernel.org>; Fri,  6 Feb 2026 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390951; cv=none; b=mSujYXuG98E0fepCf2+W7pegkO2oJDus5WPgVPyB0PwlyRcDsNbMSrHdt5ioF1nuQ9U15wNFlUzEWOcrTZ2skpNFrwlKU2B2m6/0fcyY0yHMPGm4XISTlpZaXJgwiDlKWaotRSq8fGv9jgnDoIzG87ttw0t2fEtGOuxMcch/Qh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390951; c=relaxed/simple;
	bh=ubRPE22dYPcVS743CCDeR7wr4K4O6mDQ7ObCOoewXDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9izRe0QPHY6ApTgV6DQR1ojzdCS8UmCDmFD6J5pORXk9yeSP4DlUCZjGRCi79VB3+K1JKz5GaUa5d7PHX0eDj+pdpsrWuBRXFVCrz3OaST3mhHAnN7JGBj2qh+LRnIQRPDgWbi0+GdIFDZ+EjWEM2moCY2f1mLF+JMfdA2mQ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=sLCGhHjd; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="sLCGhHjd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=U1lpGlCPqpk8XjG9zwL1i8LWAkt1pVzR8V2hTITOLz0=; b=sLCGhHjdXrM/y6AAbUBkaIb3VJ
	ZwJIBt0ZOgruYPGqOiUhB9CeG7TGg4bD3E4yuG9sJGS2fDbTK7VxUuKgNBOFiEpD+0UBnx4lCarAV
	psljP//HtYe5orjxXoJWHHCv8t/6w1IgJMp7/f7MH6jVmw5o1RKBAf+dgm4WUCK4ZWvD/Zn2Vthqu
	dmo70p+vsJisox4OWFvhszjy5e3ScXEsmpP60pC12JWVJHhtACoIMyGuzWzP1Az8uhSyWPDUwP2FP
	xtEqIZ1rBOIUlr4ZiTYx/LD0CFNv2UcImJ1wduhf39EJhvROR70jDtdOziZMSztvi7Mltv1NlvMiC
	3GSJNpkl/1hV0ffQDuPUj7eK18obzCT8J+CvbAHRAj8hrD6M9jvqLzBY5vpCS2nxJSaIxQJd8uG1+
	87L62p5iXVUzdTLonrf6GVm1+Ds7GmtLKF6fKe/B6jatvfVtMooJZDtvghKVn66RDOJb+vgX10Afb
	YpTUrC3o+e34IInDHswXu8IE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1voNYi-00000004fHQ-37ah;
	Fri, 06 Feb 2026 15:15:48 +0000
Message-ID: <47c97aeb-ad4b-4032-aa2c-b04c85c74322@samba.org>
Date: Fri, 6 Feb 2026 16:15:48 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: server: correct value for
 smb_direct_max_fragmented_recv_size
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
References: <cover.1770307237.git.metze@samba.org>
 <2e28ef145e4d88216e52f156ad592085adc55e61.1770307237.git.metze@samba.org>
 <CAKYAXd-FraxgAm-yO6dM5XZF_MgOS0JzHhfwqVTZA1NkPztGew@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd-FraxgAm-yO6dM5XZF_MgOS0JzHhfwqVTZA1NkPztGew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 06.02.26 um 16:09 schrieb Namjae Jeon:
>> -/*  The maximum fragmented upper-layer payload receive size supported */
>> -static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
>> +/*
>> + * The maximum fragmented upper-layer payload receive size supported
>> + *
>> + * Assume max_payload_per_credit is
>> + * smb_direct_receive_credit_max - 24 = 1340
>> + *
>> + * The maximum number would be
>> + * smb_direct_receive_credit_max * max_payload_per_credit
>> + *
>> + *                       1340 * 255 = 341700 (0x536C4)
>> + *
>> + * The minimum value from the spec is 131072 (0x20000)
>> + *
>> + * For now we use the logic we used before:
>> + *                 (1364 * 255) / 2 = 173910 (0x2A756)
>> + */
>> +static int smb_direct_max_fragmented_recv_size = (1364 * 255) / 2;
>>
>>   /*  The maximum single-message size which can be received */
>>   static int smb_direct_max_receive_size = 1364;
>> @@ -2531,6 +2546,29 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
>>                                    le32_to_cpu(req->max_receive_size));
>>          sp->max_fragmented_send_size =
>>                  le32_to_cpu(req->max_fragmented_size);
>> +       /*
>> +        * The maximum fragmented upper-layer payload receive size supported
>> +        *
>> +        * Assume max_payload_per_credit is
>> +        * smb_direct_receive_credit_max - 24 = 1340
>> +        *
>> +        * The maximum number would be
>> +        * smb_direct_receive_credit_max * max_payload_per_credit
>> +        *
>> +        *                       1340 * 255 = 341700 (0x536C4)
>> +        *
>> +        * The minimum value from the spec is 131072 (0x20000)
>> +        *
>> +        * For now we use the logic we used before:
>> +        *                 (1364 * 255) / 2 = 173910 (0x2A756)
> These comments explaining the calculation is currently duplicated in
> both the global variable declaration and inside smb_direct_prepare().

Yes, that's exactly what I wanted.

In my smbdirect.ko patches smb_direct_prepare() will be removed
and the comment moves to smbdirect_accept.c where there's no
direct link between them anymore.

I'd also like to keep this in order to remind me that
we need a more useful solution to this.

Windows offers a max fragmented size of 1048576 (0x100000)

metze

