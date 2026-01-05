Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB16F2DC78F
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 08:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600240; cv=none; b=MVpL3D0F50iEEVCqui/9uKNEzNgiFAHA/CZvF/1T4028p1LNzx6YZk6XwYjj4XEFOwZ0+xTFEhrlL/K1IdotqSUFgW4UU/7JkhzWcM45dRgLnjiwoOqC5mFjYGkfHHT4T9NmtqGayaG91C68mH12PQiqVCVKfuMEjDBcjDv/3xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600240; c=relaxed/simple;
	bh=eIo18OvaljjE88k2RBK2ExZ0RXbq84mgtbnMlTAPf7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X/VR+ysXnHZEemej+XRUp6grg29dyhW9J+bvXDDu3PjjFMOQ79iRn46uaJZjGyB4ldyKH0x3vD6fupX9jb39DtHnXJd3HEXl+w0RVE4hfa98TwLura+FnrqWcENBQ3icvGUJooJZvFQRaZQ8IpQxv0FMtl2Fr1yQbwLEVluVH5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wio8DSvR; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wio8DSvR"
Message-ID: <5677f64a-9607-41b9-93d4-7c256d1bbb14@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767600235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTL92kBBKt6BbkH5oW90ZMKBcmuBhIdKFswpaVt52Bg=;
	b=Wio8DSvR6u15gQLKHkXWNx/FD50C74g/WRYB0I8frVv94aUT3MeIxWB+QmMjEc+Xq7NuTB
	hDfaCKY6s9tYNa0vCgtQW6xiPlxrgJY26lt3lPG446Ban3ZYsRz58uCZ7YGdNEroK1jbTC
	w4df1W/7sSzZvpUI5xgQIuyGqRKt0zc=
Date: Mon, 5 Jan 2026 16:03:13 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/5] cifs: Autogenerate SMB2 error mapping table
To: David Howells <dhowells@redhat.com>, chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
References: <20251231130918.1168557-3-chenxiaosong.chenxiaosong@linux.dev>
 <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
 <1696856.1767599900@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1696856.1767599900@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

The SMB code currently uses __u32, __u16, __u8. Perhaps we can consider 
replacing them all with u32, u16, u8 in the future.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/5/26 15:58, David Howells wrote:
> Note that you only really need to use __u32, __u16, __u8 and suchlike in UAPI
> structs that userspace will be able to #include.  You can use u32, u16, u8 in
> kernel internals.  But don't worry too much about it - it's not worth
> respinning the patches over.

