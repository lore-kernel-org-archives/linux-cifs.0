Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E2A1DF970
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766851568; cv=none; b=T6e3yMQx/fKKZVxRTh9rvFdD1KgkIF4n0/i/Qhdhf2/z9P5M/LbQB/k41/5frjpa2QQOXwuzVViQV9xMy9SdocupcIeq7wUot5TaK+dzrGuzCQvKefhEoRIFH/6RzqQVG2VaCh00lkzb/m0lKwKhAvBAVZeJlLIRwf/vWNKMJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766851568; c=relaxed/simple;
	bh=3yLzZQ0aoOyBHXlnwt5mBQd5Fy9Hhu4J2w3cBU8/tWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G8t77rngf59xJvfsKrEzduDYls2lnL+3n+C+aOmWUEAtOC9Xh+B0VV8znLJfvNZQl0/lDrluTPBjLtse5riygp2mhV4Uh6AUZJ63EC2Rp0Rr7i2ECp/MwCFMsR9JuhvPuMjEqlF5zTUTHnTteSbBQkCmdMIZVk3IHFdXnCVO324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UXuRYcMB; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UXuRYcMB"
Message-ID: <1692b7a8-c208-4aa7-a9f4-02fea6d31733@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766851559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kNSUX0WLxYQ1RWkhjlmi03wAc5NW8LdloumhlVwvII=;
	b=UXuRYcMBDI6g4kmY/apFCnGUy7tkAWMcbxgJeOa2anzOoPOQe5uyx4LVIFoqSWp6YxDSHg
	+JZR4K2xkGSx8Y+ywjJBiFn1D3AMAP4AbyrdC54XLiiTYedqyQhA0h2m/nlUh5JTAXZB00
	GY9rkU26XBc2JtduPvDOSfZQpjS+bc0=
Date: Sun, 28 Dec 2025 00:05:45 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
To: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <5b74f84d-3de5-40fd-b0c8-f2743834bc1a@linux.dev>
 <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev>
 <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
 <1266596.1766836803@warthog.procyon.org.uk>
 <1276266.1766850638@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1276266.1766850638@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

If we merge our patches in the 6.20 merge window or later, it should be 
safe to do so.

Steve, what do you think?

Or, David, what do you think of the following modifications?

```
err_map = __inline_bsearch((const void *)(unsigned long)smb2_status, ...);

static __always_inline int cmp_smb2_status(const void *_key, const void 
*_map)
{
         __u32 key = le32_to_cpu((unsigned long)_key);
         const struct status_to_posix_error *map = _map;
         __u32 pivot = le32_to_cpu(map->smb2_status);

         if (key < pivot)
                 return -1;
         if (key > pivot)
                 return 1;
         return 0;
}
```

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/27/25 11:50 PM, David Howells wrote:
> Personally, I would, but I don't think it's likely Steve will agree to that.

