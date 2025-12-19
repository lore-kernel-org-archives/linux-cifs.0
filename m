Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B3B3A1E7C
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 01:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766108811; cv=none; b=A+MyUzzP7OnS46PM7wzMYqHy146fsxkygMywM3Wk5RWSDZTzJ2W0lhFe2clLd9uKR7ioiOnWe86FZAzd1eVxpVe5NzEMHob7HK1NUQBpSvq+hUAFOsJatgbolU8Q9zHML3Vc/J4PngPFc0/L0aaSfoGR1917gC0adZg8vnF7adI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766108811; c=relaxed/simple;
	bh=lIPdWIN661kgDJOj4YHHCR7L09zE+t6o3gaMEFrB3jA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=luzyF0aPAyymLZtkIVTaao86S7jVvamnKAqLvUg1RpSvBreUVuDbfP+ushM/S+4EF7FqjPNnzSzSFrixjOC0Ms3y53FmyLgl6a+5Bm9nYehClMiDb0gAleVfcpKn4WE0VQHk0wDAVN3nR2i8/KjluIv6MBG+Rfoh5qKqYWPfP9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DG4RhEcN; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DG4RhEcN"
Message-ID: <2e403314-e32e-4f48-bbf3-e014a0143095@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766108807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09teA1AO6j2ZOS1Spp6iDSY+DvrNcXUOi1Q5jv28uPE=;
	b=DG4RhEcNwLCtfIRF8v2JKDGloi1RXy0QHRvhentGSkSY51GGlJ764n7wMwH+5cETw3U0hO
	9s+GDjQA9xBhl2MdJPYjYjTqFNhisyolKiV54PKaav6vDVK5giWEf8dJd7NYKgsUsR8CMM
	16G7DZYpo9oZ+aKld76VYeSCndzZ6DE=
Date: Fri, 19 Dec 2025 09:45:54 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: dhowells@redhat.com, sfrench@samba.org, smfrench@gmail.com,
 linkinjeon@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
 <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev>
 <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
 <9f9031de-6749-4de4-ae5b-d574b9fc06bd@linux.dev>
 <CAKYAXd-J2-t2315ibQX6GvvQx6Wqd-Y=tOc=if3eFANWBEggXQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-J2-t2315ibQX6GvvQx6Wqd-Y=tOc=if3eFANWBEggXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I will analyze the code in more detail. Thanks for your review.

Thanks,
ChenXiaoSong.

On 12/19/25 09:42, Namjae Jeon wrote:
> On Fri, Dec 19, 2025 at 10:31 AM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> Hi Namjae,
>>
>> `SMB1_MIN_SUPPORTED_HEADER_SIZE` and `SMB2_MIN_SUPPORTED_HEADER_SIZE`
>> are only used in `ksmbd_conn_handler_loop()` to check the PDU size, and
>> seems not to cause slab-out-of-bounds issues.
> Okay, I explained it but you didn't listen... So I can not ACK this patch.
>>
>> Thanks,
>> ChenXiaoSong.
>>
>> On 12/19/25 09:16, Namjae Jeon wrote:
>>> On Fri, Dec 19, 2025 at 10:00 AM ChenXiaoSong
>>> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>>
>>>> Hi Namjae,
>>>>
>>>> We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and
>>>> `SMB2_MIN_SUPPORTED_PDU_SIZE`.
>>>>
>>>> But we "should not" add "+4" to them.
>>> Not adding the +4 will trigger a slab-out-of-bounds issue.
>>> You should check ksmbd_smb2_check_message() and
>>> ksmbd_negotiate_smb_dialect() as well as ksmbd_conn_handler_loop().
>>>>
>>>> The `ksmbd_conn_handler_loop()` function is as follows:
>>>>
>>>> ksmbd_conn_handler_loop()
>>>> {
>>>>      ...
>>>>      pdu_size = get_rfc1002_len(hdr_buf);
>>>>      ...
>>>>      if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
>>>>      ...
>>>>      if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
>>>>      ...
>>>> }
>>>>
>>>> Thanks,
>>>> ChenXiaoSong.
>>>>

