Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72833EAE6
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 06:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729848; cv=none; b=kjXL04fPrkFMpf5j7TWGju+xsdM7Y6s5SXvShZFtEY+/DvdCH/HNnuenfefAOEYQ40cCjJw1LqftqhoRzu3Kwpcp+oPGW1W9O1RBtvMWkmj6i60YI9l8IBcn7PNxm0zZ3neekYQMY44HTJSPqNVXRawMqzC6eYeTajk9ZOypAkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729848; c=relaxed/simple;
	bh=0PnczQPsAzp+2qKiXxduJtqJzsZh4nAVKpPNeXxzLxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UEhhLwn3TXjU8D64YBsRWUVH+IdJaRF9UuT+UQ5xBiSWA5jgtX7BuOn+PV5xleaVbpleN0iO26s4MB4cwIqmCUhiu5rIV7gxxKhowVl+KbA27F4IoZNGQgP+MknRvFQpPpVVF08O0sRK48RPLbe4aVu5eGj5hqQpHKc9F/+Zk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=QYsuZetB; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="QYsuZetB"
Message-ID: <1e0882ea-4e59-4b70-b1ae-90fde86c252b@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1773729842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O8Q+eLbEhLpsxmANAK27dLrmscb8tjCtN8GADEvXHMI=;
	b=QYsuZetB/OSIl8yjBzEQD/Mub2vP1Yb+n4lgn61g7UXoiUMXnSs1fwHGl7OysbYCbQoU9E
	Y0lZSK2iQ0rBcA1oHbyJGNvRZS3CLofAn7XKRkuHPFBMW2YG2nbqN/UT1NuM1STtVZFDuR
	sICp+geljkcASZB4oaTUfEatlr75HtZ1+9P5GC+BqrD+4sied1HdXJRP/JOAvxsG07cF3r
	iOuW5w5QK9XMOKN6QLQIf7dkRpgkTdzxKJDMEc8aTzQz2SdeAWYPa7CmCCaRV8CSeSmVlQ
	pJ/ewqNSF184wzWdgW2PGW5XAC//yPEXjZRArWeJcfb1lzE4SV9MlGL6BJOCcA==
Date: Tue, 17 Mar 2026 14:43:21 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
To: Werner Kasselman <werner@verivus.com>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc: "linkinjeon@kernel.org" <linkinjeon@kernel.org>,
 "smfrench@gmail.com" <smfrench@gmail.com>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260317021757.962692-1-werner@verivus.com>
 <6b98c261-b17b-45a8-ab09-efdb0d658f4e@chenxiaosong.com>
 <ME0P300MB0853F9FCE2F9C416FE3820B0BD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <ME0P300MB0853F9FCE2F9C416FE3820B0BD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I just saw your v2 patch, and it seems to be the same as v1: 
https://lore.kernel.org/linux-cifs/20260317063456.1696853-1-werner@verivus.com/

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

在 2026/3/17 14:36, Werner Kasselman 写道:
> I sent an earlier version of the patch by mistake. The version with the complete changes (including alloc_lease_table() split and add_lease_global_list() signature change) was committed locally but the email went out before the final amend. I apologise for the confusion.
> 
> I will resend the correct patch as v2. The full diff is +45/-27 lines and includes:
>   - New alloc_lease_table() helper (extracted from add_lease_global_list)
>   - add_lease_global_list() changed to take preallocated lease_table, return type changed from int to void
>   - smb_grant_oplock() restructured: set o_fp, preallocate, then publish
>   - Error path uses opinfo_put() instead of __free_opinfo()

