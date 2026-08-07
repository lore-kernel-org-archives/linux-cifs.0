Received: from out-171.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87069459AF8
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 22:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786140283; cv=none; b=dkR/tAU0ikTNb9p7m8hD8E8xYGnWGmqUqQeIBRpIpehNhNR6cSnxLIGJD0R9beguNJCmEMwb6uFcj9XZX07eFrVhc3M5vuu0Liy07PjcbOl70/FQE4EKg0iBlcrHVNMhSCD5D5nrDyN8NSnC5NWXuBODm5air00hbY+gp2bAJzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786140283; c=relaxed/simple;
	bh=y8pLwhFS2NnZHYiaKMjb4k30VsraZ7rjsX51AGMxpxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQkSEGYaAePD6Xl4vZEzMIw+DF0iRlI4hu2WuXYbXbv/uNPuF9AYFbCGFB/cFisJpVdR3hZuQNAJk9RxYGQoLTvrAxqDFjnawgEeGkK1bhTivPHPu9+ekFwWtY+fwUFjHv5B2sx6UZDutusUMjyAq+jKuJIfN8LRTgCEXbhogx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=qe+xvABW; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="qe+xvABW"
Message-ID: <38db9743-8d3f-4746-abad-2d649e3c1614@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786140276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tUyLvZwL9FnmsObGAKF1X+Nk2ZAGLlogOCAhd9gITcQ=;
	b=qe+xvABWm3xGJGymKJ8GhkCcIIphsOwLN7VGp/FjkL2PJQrMqVOvDhVEJ7OR6iM2CwnDXQ
	r5C0E4e6zxYxxuh+t3yYbl1jf9Uhtw9fGpkocSi2xw1Oq/b+0BOBlIHtLemStk26fevEeJ
	+6Dla2BY5le9JabX33Kr+b32eEuCKErxnM8Pji9R2Xl31mT0l2oGYU4DPFjC0yMNCa4Y8u
	Q9DFJ4ROZCB1CJcvsmRTqVKO9+YtTP9Dpjw/IxIJd+CD+O4o2/TMELwQzckK8PILGf2f6A
	SptC9n3c9nFfPsubq87aLZVxim7C+EskU0xnjpVl2TyuHn7F9xapWVsF0SItow==
Date: Sat, 8 Aug 2026 06:04:32 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb: server: Clear sensitive stack and heap data in
 auth.c
To: Thomas Huth <thuth@redhat.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260807171024.1529513-1-thuth@redhat.com>
 <17fe311c-f47a-424f-8977-81c88d820e80@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <17fe311c-f47a-424f-8977-81c88d820e80@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your patch. This patch cannot apply to the 
`ksmbd-for-next-next` branch. Please rebase the next version on 
`ksmbd-for-next-next` branch:
https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next-next/

在 2026/8/8 4:16, Thomas Huth 写道:
> D'oh, self-nack, I really should not send patches in a hurry on Friday 
> afternoon, sorry!
> 
> I will send a fixed version next week.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

