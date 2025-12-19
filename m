Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CAA2D29B7
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766152412; cv=none; b=Emzz+IC7td5bfMmonD35U4NvH67N+MPAtwRi6tay6wLL3sOgY4/XTSOvYTnQSYyJAWaV180ZMfw/qcK29F4Io9DIywN88wvetRtrjZnshRnTjVFuceQq9a/SocEB70jJ8rNpj3m9aH7RxaVmEzgxrPHh4ijfYzHAhRvido+GtOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766152412; c=relaxed/simple;
	bh=QBHv0mhA2dinl3lqgV6s93PFZ5Km8at0j6xebx+l9TQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kaiuYj4MXQmQhCV4gphR1+feeNknduSTfuLxYePJy83x+iz87XuY1sxOHKmhih7qtO/MnxUui5C+0pBGIkdOsdEOocQwfoozdwjBtbV9iqGT52KBLmAXsP/wuL2YQFc1asd++JqLQ4qhzi5hMXR2ST88PftmPrmsw1cwuAA2mls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BolAVjzt; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BolAVjzt"
Message-ID: <f6c69efd-f3ae-4884-873a-0e261f771368@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766152405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/4riFPoYLi6ZumPKDCiua9YGVBezfIBdnXweC8dRiUM=;
	b=BolAVjzt0a+EofBfDZGe0TVU1HVG+cJh2F+PAh79g4VaQDqn8Mjqh2tHxpoCXTTsvkDHfk
	/F3qz964auDWUr9sIrYKu2yAdcC84wSBUTNiNJ2VgmRsvL9tY97GUhRW73JWXVZB/tubm6
	GTNgH8b57A1VZgLSe4tOdgdjWE6oNYs=
Date: Fri, 19 Dec 2025 21:53:07 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
 <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev>
 <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
 <805496.1766132276@warthog.procyon.org.uk>
 <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com>
 <812021.1766141424@warthog.procyon.org.uk>
 <CAKYAXd-MGFZL5AKPebdnEJhg32rHOTJHXvGd0OmfkWhdQCoi-w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-MGFZL5AKPebdnEJhg32rHOTJHXvGd0OmfkWhdQCoi-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae and David,

Should SMB2_MIN_SUPPORTED_HEADER_SIZE(will rename to 
SMB_MIN_SUPPORTED_PDU_SIZE) be sizeof(struct smb2_pdu), i.e. 
sizeof(struct smb2_hdr) + 2?

If my understanding is incorrect, please let me know.

Thanks,
ChenXiaoSong.

On 12/19/25 7:52 PM, Namjae Jeon wrote:
> On Fri, Dec 19, 2025 at 7:50 PM David Howells <dhowells@redhat.com> wrote:
>>
>> Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>>> ChenXiaoSong, If you agree with this, Can you make the v2 patch ?
>>
>> Can I suggest adding a comment to indicate what the +4 represents in the
>> SMB2/3 case?
> He will add comments for both SMB1 and SMB2/3 cases to clarify why the
> +2 or +4 is added.
>>
>> David
>>

