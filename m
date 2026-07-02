Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C7529D26B
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 01:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957323; cv=none; b=r+7WpAzIsFIoveHilKYGe97+1Hd1sDviPl2s6jqU7i1fMrjDzwAzdJH/1rcyKG5vE0C3cu2Qe7vAmYraUQ5CDuqoI1h8VfYKXTduh4H7nTcUeki7m4+ItK/mRPbKOGusojzg5pswOijACYgmfTLYVVVFeAeGwFAhtEayNeWP7Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957323; c=relaxed/simple;
	bh=QWO4NdOmmo6fMXuKdc1YflyHtxuW0VXLATsI1zFyejs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofNLqbbXvkJrAd653OD99dzYEowdc/SyoHk7QzgJqfIgAlcvhU9OtHdRhPymKfrUgf+gt97DrFhzj8+PVIVQuiB0WZZcM9RySvkS+qDJBmJgtwL2uHUfg2OTBYFQLrZleyXf347kUTn9GddDiYCwTAhw82BtQzqXPQeR1oabE18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wcp4d/1y; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wcp4d/1y"
Message-ID: <ec6b4552-618d-41cf-a262-0c14ebd354df@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782957319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WHgmDEreUpdkHrS4TsC6R/3AWJTw+NKZPTX+nbDh8yo=;
	b=Wcp4d/1yPen7/H2Btpsp6QTCoQp3Hx2KkOwlRPvMmlKruY23QLG/J8f2RbKtfu9cgRs2ia
	huk7KtSVtsU0ISF5WOsmi4Xxf3RDrobPvbGppUZef859DKq+V1iJ8v3EHof3+dvH6n0vWc
	xbl5g6fsST/4QTGPEZibjHtznSRWJvU=
Date: Thu, 2 Jul 2026 09:54:25 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/5] smb/client: reduce fallocate zero buffer
 allocation
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn,
 linux-cifs@vger.kernel.org
References: <20260701152157.822207-1-huiwen.he@linux.dev>
 <20260701152157.822207-3-huiwen.he@linux.dev>
 <CAH2r5msyi5nvObkx+JUP78DKdthQLR4p+sg61SEW0RXATorcLg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAH2r5msyi5nvObkx+JUP78DKdthQLR4p+sg61SEW0RXATorcLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi steve,

The normal write path can use larger writes, and dd is a good example of
that. But this patch is only changing the fallocate zero-write emulation
helper.

That helper already capped each SMB2_write to SMB2_MAX_BUFFER_SIZE 
before this patch:

        if (io_parms.length > SMB2_MAX_BUFFER_SIZE)
                io_parms.length = SMB2_MAX_BUFFER_SIZE;

So this patch does not reduce the write size on the wire. It only avoids
allocating a 1 MiB zero buffer when the current helper sends at most 64 
KiB per write.

Using the negotiated wsize here could be a useful performance 
optimization, but it needs more care to make sure the larger
write path is handled safely.

Thanks,
Huiwen

在 2026/7/2 05:44, Steve French 写道:
> Won't this hurt performance since for most servers the default max
> write size is 4MB (e.g. Samba or Windows) or 1MB?  I did a quick
> experiment with
> "dd" and I see the 4MB writes over the wire not 64K
> 
> On Wed, Jul 1, 2026 at 10:22 AM Huiwen He <huiwen.he@linux.dev> wrote:
>>
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> The fallocate emulation allocates a 1 MiB zero-filled buffer even
>> though each SMB2_write request is limited to SMB2_MAX_BUFFER_SIZE,
>> which is 64 KiB. A high-order 1 MiB allocation is more likely to
>> fail on a fragmented system.
>>
>> Allocate only the smaller of the requested range and SMB2_MAX_BUFFER_SIZE,
>> and reuse that zero-filled buffer for every write request. Also reject
>> a successful write that makes no progress to avoid looping indefinitely.
>>
>> This reduces the contiguous allocation required by fallocate emulation
>> without changing the written data or range semantics.
>>
>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2ops.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index cc8e0595e504..23505ae9bd81 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -3559,7 +3559,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
>>                                               char *buf)
>>   {
>>          struct cifs_io_parms io_parms = {0};
>> -       int nbytes;
>> +       unsigned int nbytes;
>>          int rc = 0;
>>          struct kvec iov[2];
>>
>> @@ -3580,9 +3580,10 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
>>                  rc = SMB2_write(xid, &io_parms, &nbytes, iov, 1);
>>                  if (rc)
>>                          break;
>> +               if (!nbytes)
>> +                       return -EIO;
>>                  if (nbytes > len)
>>                          return -EINVAL;
>> -               buf += nbytes;
>>                  off += nbytes;
>>                  len -= nbytes;
>>          }
>> @@ -3611,7 +3612,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
>>          if (rc)
>>                  goto out;
>>
>> -       buf = kzalloc(1024 * 1024, GFP_KERNEL);
>> +       buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
>>          if (buf == NULL) {
>>                  rc = -ENOMEM;
>>                  goto out;
>> --
>> 2.43.0
>>
> 
> 

