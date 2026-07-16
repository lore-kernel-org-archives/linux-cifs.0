Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D01C329396
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784215116; cv=none; b=Pa5lxXTA0hF45encfBdjpaqyQsp7J+sIfFzZH13l2V03g1RVq0IPwfDVXXVlM21izsHXdBUbxbuJ37nEVPuFKlOoGrmN17qlSLXNtoNLwBG2TmJ2PM8AD+YxorDWNT59LvEv2LQ0N0Z7KZnjaXgAfVsPco5JEKvIPvbqMgag5KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784215116; c=relaxed/simple;
	bh=a40QT9GZYmQEb86gMBhsR7I9Wu3fsWVQbztdr1ob7U0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nqilYmqIc0J8hwnH59xrh5YjEKlMJ+wRsNm0lIRt1KNIu6vYlQZHYKBJdt9OShRoN3O9CTrEAzy6BWuHXbkOeXLKl6ZPMUGKjTv3jNYlBK1zkJ6RRzbkmOEwEI1uNbFLPVd+E85dqsacR1WiRVMcZx+lo35oWEDn9OuzaPlL2ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eSmuIPLN; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eSmuIPLN"
Message-ID: <5ae8ed4b-4f63-415d-83e6-d1f196b87191@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784215112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0qNbyQzdzWsIOe2Hs6h4wn0XqYLbYO9Etm8DuUgT0AM=;
	b=eSmuIPLNWSpLl6QF+LQdw+WZcfLsnsF4rL1uPimR1YrG0t+CnRF6Lee744LllkiCza8JBR
	BimAjoxeC1DWhroD1WfP1ZI/G7ilxDRf3kMQe4Ej1YnQkbnd6MFLr2x55Y6DJhw/i7ER6f
	5Du60XoelQfwJPacGSIHbyDGRszenDQ=
Date: Thu, 16 Jul 2026 23:18:17 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/client: fix unaligned fallocate emulation with
 O_DIRECT
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
References: <20260716144731.729559-1-huiwen.he@linux.dev>
 <0727f6af62bc986a221a720e7f180be0@manguebit.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <0727f6af62bc986a221a720e7f180be0@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for pointing this out. I tested the patch against Windows Server,
Samba and ksmbd, but not Azure Files.

I will look into this further.

Thanks,

Huiwen


在 2026/7/16 23:09, Paulo Alcantara 写道:
> Huiwen He <huiwen.he@linux.dev> writes:
> 
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> Commit 4a7d2729dc99 ("smb: client: fix atomic open with O_DIRECT & O_SYNC")
>> made atomic O_DIRECT opens correctly use CREATE_NO_BUFFER. This exposed
>> an issue in the fallocate emulation added by
>> commit 966a3cb7c7db ("cifs: improve fallocate emulation"), which may
>> reuse the handle for unaligned zero writes.
>>
>> Windows requires the offset and length of writes on an
>> unbuffered handle to be sector aligned, and rejects these writes
>> with STATUS_INVALID_PARAMETER, causing xfstests generic/760 to fail.
>>
>> For SMB3.02 and later, fix this by keeping the handle buffered and using
>> READ_UNBUFFERED or WRITE_UNBUFFERED only for actual direct I/O requests.
>> Determine this from the netfs request origin rather than the file flags,
>> since mmap writeback on an O_DIRECT file is still buffered.
>>
>> For older dialects, retain CREATE_NO_BUFFER since they do not support
>> per-I/O unbuffered flags.
>>
>> With this change, xfstests generic/760 passes against Windows with SMB3.02
>> or later, while Windows SMB3.0 remains affected.
>>
>> Fixes: 4a7d2729dc99 ("smb: client: fix atomic open with O_DIRECT & O_SYNC")
>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/cifsglob.h | 13 +++++++++++--
>>   fs/smb/client/dir.c      |  2 +-
>>   fs/smb/client/file.c     |  4 ++--
>>   fs/smb/client/smb2pdu.c  |  6 ++++++
>>   4 files changed, 20 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
>> index 08e94633a9c1..2e43dbd564de 100644
>> --- a/fs/smb/client/cifsglob.h
>> +++ b/fs/smb/client/cifsglob.h
>> @@ -2374,17 +2374,26 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
>>   		WRITE_ONCE(cinode->oplock, 0);
>>   }
>>   
>> +static inline bool
>> +cifs_server_supports_per_io_unbuffered(const struct TCP_Server_Info *server)
>> +{
>> +	return server && server->dialect >= SMB302_PROT_ID;
>> +}
>> +
> 
> Unfortunately this check is unsufficient to tell whether the server will
> actually support SMB2_WRITEFLAG_WRITE_UNBUFFERED and
> SMB2_READFLAG_READ_UNBUFFERED flags.
> 
> Have you tested this against Azure server?  IIRC, the server would
> reject the write and read requests with STATUS_INVALID_PARAMETER if any
> of those flags was set.
> 
> I had a patch to use those flags and improve reuse of open handles but
> then gave up as Azure server seems to be the only one broken regarding
> those flags.

