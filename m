Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C454A21;
	Mon, 16 Feb 2026 11:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771241166; cv=none; b=IYVTcs4fzu/WGlwzvJHoREPzv/cS/ZHpDqTaBhEyMoL/b9H+6EtzkmoDVESLaMgEaJ0wgm4VH5pROeiYm5D8ct8IL7NK1m/8JzIBqP4NA9lGmJPb7tRTV4VYuDOtngNqvpgCRIdgD/x2lyvMP1jFY2BbZL+pOXCeAHrR/woyT5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771241166; c=relaxed/simple;
	bh=wEEOEWjBL0GcGbsjzN6SSAJ6tm4YgU2XHU9AxhklG0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lFy29PKJonAz99QmmtNhjXg7hPsjlKwF+zcuH7AqESOFGUDMDt4J49AvfnJQvIXUhoSVegXLeHiAp+q+VGNz3N8Ao4MdIROHO2nhsq7KLVW2vMuBzgfzMbdOahrDfBwQVtrI+zAhZMPx1KpfDsdgWfkkIw/GtVLSX2IxVut8HjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CikiNdn/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CikiNdn/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=EUjkH0cJwPpaPF2GQRC5y4BTRPyN6YRP+MwwQSXnqew=; b=CikiNdn/CviBhsZKOdjCXkIif3
	2J8z0zGi/0Di42e/OCTs82RsBQKdtjYM9GvNWj1+zRRX8lswfqk2mBUGQyqagDgmf/87WcljNtTe8
	J1AuVnpA4Bds2Gp0m8pnQ+72P4iHOzAD2cBeXMdy8wLfXLpOZBIbKfVAtyeXkv8p60fiOuC3Ztel9
	NEIvV5NjOJzvSJ0JCDO4lfhiimyzd5/AX+2kc2TvB2MLsum7wbJ0HaZ/z/3u1/ysJpSKWDANc+fJI
	FMSVnUnToX6bcw6nTRbvvIZc3Dd93tqhx7hyCwJYMuzDCvmE0JW8YdZIhX8VRDxGu+2lAiTGbbhmQ
	PFcAiL3XBXrQQcfkfYjHzr6OOW/HA/d7PJlwBkkwJc+J2E+9DherNQAQcCeMPd+eCgjV50XTxp6dr
	SZ4k+BHo4DmlgU8j/XV88JBY4EDKIxcRfBdvVgyRrSS18AijtHPRhkVDGvMbom6lpJ7GokqgHz/tG
	qEG1mf2nlADr8W+By5sByOoL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vrwjq-00000006am0-2EVm;
	Mon, 16 Feb 2026 11:26:02 +0000
Message-ID: <fab7376b-2435-42ad-bf84-ec0df59fe79a@samba.org>
Date: Mon, 16 Feb 2026 12:26:02 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: smbdirect: select CONFIG_SG_POOL
To: Arnd Bergmann <arnd@kernel.org>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Shyam Prasad N
 <sprasad@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Arnd Bergmann <arnd@arndb.de>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 Ard Biesheuvel <ardb@kernel.org>
References: <20260216105404.2381695-1-arnd@kernel.org>
 <63908802-3313-4118-bbd5-b1c677d23ac5@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <63908802-3313-4118-bbd5-b1c677d23ac5@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.02.26 um 12:15 schrieb Stefan Metzmacher via samba-technical:
> Hi Arnd,
> 
> I'm wondering what the top commit is that you where compiling,
> I guess that's before the 'smb: client: make use of smbdirect.ko'
> commit.
> 
> As we have this at the end of the patchset in ksmbd-for-next:
> 
> fs/smb/common/smbdirect/Kconfig
> 
> config SMB_COMMON_SMBDIRECT
>          def_tristate n
>          depends on INFINIBAND && INFINIBAND_ADDR_TRANS
>          depends on m || INFINIBAND != m
>          select SG_POOL
> 
> I'll try to change the patches to have your hunk
> in the temporary phase in the patchset where we use
> smbdirect_all_c_files, as it's gone at the end of
> the patchset.
> 
> Thanks!
> metze
> 
> Am 16.02.26 um 11:54 schrieb Arnd Bergmann:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The smbdirect code now uses the scatter/gather pool interface. This
>> causes a build failure when the interface is disabled:
>>
>> In file included from fs/smb/client/../common/smbdirect/smbdirect_all_c_files.c:21,
>>                   from fs/smb/client/smbdirect.c:176:
>> fs/smb/client/../common/smbdirect/smbdirect_rw.c: In function 'smbdirect_connection_rw_io_free':
>> fs/smb/client/../common/smbdirect/smbdirect_rw.c:76:9: error: implicit declaration of function 'sg_free_table_chained' [-Wimplicit-function-declaration]
>>     76 |         sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
>>        |         ^~~~~~~~~~~~~~~~~~~~~
>>
>> The other users of this interface all 'select SG_POOL', so so the same
>> here.
>>
>> Fixes: 5ab0987c492e ("smb: smbdirect: introduce smbdirect_rw.c with server rw code")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>   fs/smb/client/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
>> index 17bd368574e9..725422b45ef4 100644
>> --- a/fs/smb/client/Kconfig
>> +++ b/fs/smb/client/Kconfig
>> @@ -182,6 +182,7 @@ if CIFS
>>   config CIFS_SMB_DIRECT
>>       bool "SMB Direct support"
>>       depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=y && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
>> +    select SG_POOL

I'm squashing this into the
'smb: client: include smbdirect_all_c_files.c' commit
and the 'smb: client: make use of smbdirect.ko' commit
will remove it again.

metze
