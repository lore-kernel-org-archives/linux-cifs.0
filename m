Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F041265629
	for <linux-cifs@vger.kernel.org>; Tue, 16 Dec 2025 00:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765845035; cv=none; b=qHFaGdynvLK0oIwCvDuyh54Nl9MeouRcwSRBFhO6P9FeGLHYnERHymPO0TwgqKVnbKYhZC7KCdHoAtuJ8UPY9hjy9l1oi+N6Czui4j0U1DpLlTHI2b3HMV+WMRIab9ghjO+EMDFjcORneXngBM4K/eG71+aikc/a41kogXBSwzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765845035; c=relaxed/simple;
	bh=LK+qyKo1v9fRFaIBEfvIYD/koHav6UrJJYMbSwGnmOY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GA51qkEdPMHCIkAiQufXQv3MURcnc1BHnHwSuPa9C5EuOj2fZeC4maViVV+p8h1p3TRmLW2DsajmZvraqgRHkEIrXLMDvRceDJuvr08lTryidX7aLkJ3b9ORfy/JNFIbx2/yRyki5LGpvBplbxmECmbjX/MLdcECmGFoBhHMgnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TNmm0ptH; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TNmm0ptH"
Message-ID: <a6c17d48-ca81-4318-966e-67fe7df9dda3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765845029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyvQzwOYiRfKq34N/MVhHBFKmaQ2cR/EUemKftac6BE=;
	b=TNmm0ptHwgExY/P8kMBtzAdBVO1miiMmhVt1c1iBWzWdUPpcmtQYWCuTMIcZ1KQnnALSrs
	/llPVHeh2+T6WzkODGd2De2Rj7YCin8KeAMaRYIlJ9d2jP+2q6Zk72aMBm8ccpVcPvT3bz
	RKg9hc6A+JLSluMKw0SXxNU1H3OQ3NQ=
Date: Tue, 16 Dec 2025 08:30:16 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Questions about SMB2 CHANGE_NOTIFY
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>,
 Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 CIFS <linux-cifs@vger.kernel.org>
References: <d745d9cf-2dc6-4240-a4be-1982082c0d28@linux.dev>
Content-Language: en-US
In-Reply-To: <d745d9cf-2dc6-4240-a4be-1982082c0d28@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Steve has already told me that I can use `smbinfo` (which is part of 
cifs-utils) and libsmb2 (which is unrelated to Samba or cifs.ko).”

Thanks,
ChenXiaoSong.

On 12/15/25 9:11 PM, ChenXiaoSong wrote:
> Hi,
> 
> I am currently using the following two methods to query a directory for 
> change notifications on the client side:
> 
>    - `smbclient`: https://chenxiaosong.com/en/smb2-change- 
> notify.html#linux-client-env
>    - Windows "File Explorer": https://chenxiaosong.com/en/smb2-change- 
> notify.html#win-client-env
> 
> Are there any better tools to print detailed info about change 
> notifications on the client side, or any userspace C program examples 
> (using `ioctl`) available?
> 
> Thanks,
> ChenXiaoSong.
> 

