Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7AF3358DB
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772167997; cv=none; b=TAeiQBODODfkiJV+KpYgbHil7oTPrEwlgScPSsCozBqSgvI7eyz/X8P0ejnoW6FecMEma9FJwNT251cDoRt6jsMNOMIYJMtc9elssRk77Gg0V+mzQ+5mcKJEHzUPYov9FM/uE3+nW9bj/x8mSWp8/7kQR6kHJ0RgTkMMpFFoEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772167997; c=relaxed/simple;
	bh=JtwmAbyNEEmo8vtYqAtOdIntGH/NkvGKPypjqiaULWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhDvI8KaRl1Wz+gVOHMxqS3bqYrY6jIWzcsvDNWBEC4fB1MbkRJWcCc4/JGM84Y4RgVp5ysKRPAf0AQHAf8mfEyYZR9tJHEkskr+N5/mU6kFfK2C3qP42MFIqGaThpBS6nbyYzmq2EucX01g8oril4T4VkbWFFWEL3nT4ULps6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Tsen3Sgm; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Tsen3Sgm"
Message-ID: <739c9e8d-238a-4f2d-938c-ed0ab9706098@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1772167992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5j8OLG7RvGxdPeUXucGehQ+0DC0FudAegj2hClQldVo=;
	b=Tsen3Sgm8RCZY2DDCBWE7cnwFflGa8as7510ORvvCRTDRyIhSzSlLslrm1WRs3HEA7cxbl
	o/lrpFCXSXi6/Pg3lbbppMxL9gAWAy5B9HUQYfWZJG9BhICEwW4z9v1yshOW96IPpCmvWU
	UrO8Sr0vCeAl0cj5JBIqa0W83kX9MTFt0379Z9rKh5weZoq3fjH46syam2VcuWCpMayFZD
	lQ2GV6bxcfh/bBvE3maqbCC21ykXu48ChftTdi5biXGU3ChQ1Ek/I8kzHR4AZ2YMHsNblU
	R5lilVgPHyyumEaiPFZDsLr8LTG4thDwzpM7zqPznPFHoDQEzLKnvVq7ERFUIg==
Date: Fri, 27 Feb 2026 12:53:05 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: Guenter Roeck <linux@roeck-us.net>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
 <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
 <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
 <59d5c1a6-7a7f-464a-aa62-e53daff8870d@roeck-us.net>
 <f3604a74-3caa-4737-bfc0-d93feb988176@chenxiaosong.com>
 <a99db1ba-2b96-44ba-b4b2-11754f6c6aab@roeck-us.net>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <a99db1ba-2b96-44ba-b4b2-11754f6c6aab@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Yes, you are correct. Thank you for pointing this out.

Could you submit a patch to fix this?

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

On 2026/2/27 12:42, Guenter Roeck wrote:
> 
> void ksmbd_put_durable_fd(struct ksmbd_file *fp)
> {
>          if (!atomic_dec_and_test(&fp->refcount))
>                  return;
> 
>          __ksmbd_close_fd(NULL, fp);    // first parameter (ft) is NULL
> }
