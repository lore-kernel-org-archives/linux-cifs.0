Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F2D33D6CA
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 13:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506906; cv=none; b=RGBZttoqovDjUuc/BiQKKLgdLoyM/K6shr7PaCIz7fItRWhAfEbTZFJ0jE6xIOU8j2hvSjpkvBHtQjxVF4SimjHJqo3oySLMomcEr901FXlRA/P5mKOuFkoxv50gIX+Hb8k+efuHdSHwitT28HvetmaOHi9Zrf1gJzBQ3FC7v1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506906; c=relaxed/simple;
	bh=5FVTPDm2pZdt52OH7lr+CjIg4i6h8onW0mwQridLJNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B29kwyUYFu2ik3StB/G+/d0SEgl/d9LAVJfWj4ilMuOdN4RZk7gimDigEgshcj5H7pW2I0soM57oPYwEIzljeQNZdfEtbtbjhuOoif+UpF21fIPr8SdahBm199Jh/b+ZLmE06FnoaSmyQkAWT0SEe9/q8SlBNF3kYgZKXIVHJts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZskyMHzO; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZskyMHzO"
Message-ID: <c9d1c233-facd-4387-bed2-b2c1dbc88cbe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771506901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uLrq27h05lmKjTp5bF+P86u7rqg517vyNgKJuCmp1S8=;
	b=ZskyMHzOPZLcSysmKPI+oxVXyCf3ldbiB/d8BjkYOnaklqUILImp5m6LMHekl6gpRUBPac
	Npuid8eyzxaAHJX+cib0N4yBwbpPaU9aIcZdvXvwo4wcnm8wH2/W0DnDdgOYWaF5X3SOK1
	/me/yDw/ISJ6QxTbpssrKW449c3ldgs=
Date: Thu, 19 Feb 2026 21:14:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/5] smb: introduce struct create_posix_ctxt_rsp
To: ZhangGuoDong <zhang.guodong@linux.dev>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, chenxiaosong@kylinos.cn
References: <20260216082018.156695-5-zhang.guodong@linux.dev>
 <202602170244.C33LgPOh-lkp@intel.com>
 <db00bf7d-7c48-48be-8c82-f4de18dab0cb@linux.dev>
 <CAH2r5muK5WrHkJsJ=Rix7ceFFZNzpQkUZSaSsHi8PMXVpw88pw@mail.gmail.com>
 <b840459a-8a31-46e7-817a-3b80e9ed1353@linux.dev>
 <CAH2r5muScb7NmeJa1BNwAt8Qzb7WmwVfvskZ=9LEV6WWyO5HyQ@mail.gmail.com>
 <d6149e9f-9607-4379-a74d-c4bbe12fef00@linux.dev>
 <75cc11b4-f459-454f-a733-a2f25ee76287@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <75cc11b4-f459-454f-a733-a2f25ee76287@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi GuoDong,

The changes to patch 04 should be as follows:

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2362,9 +2362,9 @@ parse_posix_ctxt(struct create_context *cc, struct
-       posix->ctxt_rsp.nlink = le32_to_cpu(*(__le32 *)(beg + 0));
-       posix->ctxt_rsp.reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
-       posix->ctxt_rsp.mode = le32_to_cpu(*(__le32 *)(beg + 8));
+       posix->ctxt_rsp.nlink = *(__le32 *)(beg + 0);
+       posix->ctxt_rsp.reparse_tag = *(__le32 *)(beg + 4);
+       posix->ctxt_rsp.mode = *(__le32 *)(beg + 8);

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 2026/2/19 16:16, ChenXiaoSong wrote:
> The changes in parse_posix_ctxt() seem to be fixing a bug. Perhaps we 
> should submit it as a separate bugfix patch (add Reported-by: kernel 
> test robot).
> 
> Steve, what do you think?
> 
> Thanks,
> ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> On 2026/2/19 15:19, ZhangGuoDong wrote:
>> I can now see these warnings. We should make the following changes, 
>> what do you think?
>>
>> --- a/fs/smb/client/cifsglob.h
>> +++ b/fs/smb/client/cifsglob.h
>> @@ -1270,7 +1270,7 @@ struct cifs_tcon {
>> -       __u32 vol_serial_number;
>> +       __le32 vol_serial_number;
>>
>> --- a/fs/smb/client/smb2pdu.c
>> +++ b/fs/smb/client/smb2pdu.c
>> @@ -2362,9 +2362,9 @@ parse_posix_ctxt(struct create_context *cc, 
>> struct smb2_file_all_info *info,
>> -       posix->ctxt_rsp.nlink = le32_to_cpu(*(__le32 *)(beg + 0));
>> -       posix->ctxt_rsp.reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
>> -       posix->ctxt_rsp.mode = le32_to_cpu(*(__le32 *)(beg + 8));
>> +       posix->ctxt_rsp.nlink = cpu_to_le32(*(u32 *)(beg + 0));
>> +       posix->ctxt_rsp.reparse_tag = cpu_to_le32(*(u32 *)(beg + 4));
>> +       posix->ctxt_rsp.mode = cpu_to_le32(*(u32 *)(beg + 8));
