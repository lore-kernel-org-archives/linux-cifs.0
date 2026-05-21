Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE9130567F
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 07:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779349601; cv=none; b=uXV05EfvuhYFB7rrW6nBuG2pjPXoamrp8ERrib3R3bI/C+3Hug77E7mONGZr27Rz96EOt1tGgVHw3SZQMqUTKzugw2qz+mkPV0I+TMjQhAbHhUbDHHgpfuyQVkYLowROxTAcjvA1KZdA17DmidDuL3wLkknbb+HSCxX7yh9USvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779349601; c=relaxed/simple;
	bh=kkAlJmtFCVSGO7EYw9N8XdmqkovW6LfCwRjZma3/HhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CNDJFj1nip3flBRVQMUrjk5sUUVhSh0I09jbBLDb/mLNyEyqTAdR9aN8rAmWmKvvKC3HZGCaMBfsoHtPuP8kx1SdypF5Z9xgcB3HU8QKeV9bI0dyS71WdylJZU9u7iw9TpADx6EJkywGx4j1L3TLmqW+pnYIKS7IsGq1aSYLzNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gxYKWCPI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gxYKWCPI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=6sNVoSJfDQw5vwBAftN5erjx4xjoSYtdrO1eUZva3mg=; b=gxYKWCPIQUzv1OTR6P6LLz5H0l
	BKQBl4wZXzumjkfTJpkCli9zyDRlxqCwUew26pH/YuIKjjRv6eD7Jtv8cm55Lhuv91M3JKJGoLD5A
	OWWWxVfXjPwokDic084ONOBTKMxYs0e+yesdxIUqkYdEbWljX2glRmuSUJQcr72T9ODtjqG2rdbok
	jT5qt6+v59qOJ9ehOC22cNw7toByRMSsukuFnD1QD9mArIH3m4lXaxmnsyUvzFLVedd/7g8j9dEqh
	bfjEZ66ma9Yrakn/Vzc7vRLLuESQGsmcOOxnmZ3Xkq8Pl0vIoRMzAjzwo55eOhk0m25mU/HpbIWoP
	i0tvj773WouCk8DivU8251nduUH3Wgl8RPyD0v0GH17LbvabKqqJt7yb6NPTvZUiWL7J9c9eyUSa7
	ZTUYLESaT5nbNqlHX3ffF+1N+ZNiMf4lD3ZXyid34fCtjA4CFUL9Sz02JMmaxLKFIvzcEyI0XK2E+
	xnrss6Od5vbuVRMROIB2r4Or;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wPy72-0000000Ac8L-3rfC;
	Thu, 21 May 2026 07:46:37 +0000
Message-ID: <bd3a60e6-1af0-4780-a797-3b31abc0034e@samba.org>
Date: Thu, 21 May 2026 09:46:35 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: smbdirect: divide, not multiply, milliseconds by
 1000
To: Namjae Jeon <linkinjeon@kernel.org>,
 "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 samba-technical@lists.samba.org,
 "linux-kernel@vger.kernel.org (open list)" <linux-cifs@vger.kernel.org>
References: <20260520180401.539215-1-grandmaster@al2klimov.de>
 <20260520180401.539215-2-grandmaster@al2klimov.de>
 <CAKYAXd-GeH2o6a_rHs-CiPR5N=CZMDOP17Xc9Ry998kMqTVQsA@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd-GeH2o6a_rHs-CiPR5N=CZMDOP17Xc9Ry998kMqTVQsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 21.05.26 um 07:41 schrieb Namjae Jeon:
>> diff --git a/fs/smb/smbdirect/debug.c b/fs/smb/smbdirect/debug.c
>> index 05ba7c8d165e..3445843445bf 100644
>> --- a/fs/smb/smbdirect/debug.c
>> +++ b/fs/smb/smbdirect/debug.c
>> @@ -40,7 +40,7 @@ void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
>>
>>          seq_puts(m, "\n");
>>          seq_printf(m, "Conn keep_alive_interval: %u ",
>             seq_printf(m, "Conn keep_alive_interval: %u sec ",
> 
> It would be nice to explicitly show the unit so readers don't have to
> guess whether it's seconds or milliseconds ?
>> -                  sp->keepalive_interval_msec * 1000);
>> +                  sp->keepalive_interval_msec / 1000);

This all comes from keeping the output of
smbdirect_connection_legacy_debug_proc_show() stable
as it's user visible.

If we can change it anyway, I'd just output thet msec value.

>>          seq_printf(m, "max_readwrite_size: %u rdma_readwrite_threshold: %u",
>>                     sp->max_read_write_size,
>>                     rdma_readwrite_threshold);
>> --
>> 2.54.0
>>
>>

