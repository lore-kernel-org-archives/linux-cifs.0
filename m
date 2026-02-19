Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992BA334C20
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 08:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771489023; cv=none; b=Z9SHHLt982m0qIW/fMKLgKrIs8tAt6+G95vEaQURF3MjnNr1mcyV8dpF+503miniUIIKSFnG+tB+tMRgreBofRorO/x7l9xMBc5H9DJVmYcgnJ5R5OTRQZMaYxE5qLe9V7BveKK36aq+YRWeU+VTt5vDryMyw+a+IYsF87VLjFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771489023; c=relaxed/simple;
	bh=Cnn6qkyVwretvKPjzIREbKvCNHJXsQ2q18I7LVBES80=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=gJ6E7QGJb5fJGDPtjCFQfi1TbzW5G3U434vRzmRyKjWQUzJkISXoFC5H6UPk4yse80RAA0Nv7ljt6GmTf58pbaYOgnPbGSPRZvueW/cGydlQu8DdVDgiXWNsieR0Sm/3A6jjtTDOVeHBzr0OhFqJOqMZX2u7+ccqivPGptidK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L/rbcAzD; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L/rbcAzD"
Message-ID: <75cc11b4-f459-454f-a733-a2f25ee76287@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771489019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ulmof93vM7g/hw2zqz8nIdw4vGVscvNcgs0Ya4ZgLw=;
	b=L/rbcAzDNAQgXla0NfkiwgSxaqS8R8UZjy3OdQke6R2+p8Incg1/fzDawDMdVUcdsMq7SV
	JD46pNUW7ihsvGKNwzLHZMx4K14tDJv9XDKlUR5YH4VAbJL21LWdDJz3I3E56YVMEuAlNN
	fPP5tjbk0T1iEehgg61kkQoluMESI/M=
Date: Thu, 19 Feb 2026 16:16:51 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
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
Content-Language: en-US
In-Reply-To: <d6149e9f-9607-4379-a74d-c4bbe12fef00@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The changes in parse_posix_ctxt() seem to be fixing a bug. Perhaps we 
should submit it as a separate bugfix patch (add Reported-by: kernel 
test robot).

Steve, what do you think?

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 2026/2/19 15:19, ZhangGuoDong wrote:
> I can now see these warnings. We should make the following changes, what 
> do you think?
> 
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1270,7 +1270,7 @@ struct cifs_tcon {
> -       __u32 vol_serial_number;
> +       __le32 vol_serial_number;
> 
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2362,9 +2362,9 @@ parse_posix_ctxt(struct create_context *cc, struct 
> smb2_file_all_info *info,
> -       posix->ctxt_rsp.nlink = le32_to_cpu(*(__le32 *)(beg + 0));
> -       posix->ctxt_rsp.reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
> -       posix->ctxt_rsp.mode = le32_to_cpu(*(__le32 *)(beg + 8));
> +       posix->ctxt_rsp.nlink = cpu_to_le32(*(u32 *)(beg + 0));
> +       posix->ctxt_rsp.reparse_tag = cpu_to_le32(*(u32 *)(beg + 4));
> +       posix->ctxt_rsp.mode = cpu_to_le32(*(u32 *)(beg + 8));
