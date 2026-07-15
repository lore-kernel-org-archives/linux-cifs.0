Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7E83E8333
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 15:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128778; cv=none; b=jm6BEf2TkJa07eZXiExKglmp2OmwXXKtvYNad/G5xfA88Nm+G6oyook8F6lrwg8ZiD1w/IwMjeAFQ23cQY809J1zGP5f9Xy8SzSCvdQkxOUcFmBGYv7UNtWM/FYLPYp2f5iwlRe2b8d/JIPeiVoEkfeAp+S5nbPM8y6IMxvfeZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128778; c=relaxed/simple;
	bh=eUua5znndPJrXa+6zCKMZtKfDnRzAO2e7DoRxTXILFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SgcKtSDnKQjIXbq5O3WZ/AipmDJSPrGjvyl3pdNJPD9cg8I1HntABBrV3/+SWneSiSefJ7wn+uzh/octLWaO16/JbKUD5dud0498Xcvk90NVm3ovh9Zq2g++Bg15Ao9TFE/oFlXA8N8ZRfd+TVcrtPCqBcasDer6KCOYOb1ybRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=TzAt60+c; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="TzAt60+c"
Message-ID: <81841519-05eb-420f-9487-e6217a95ab15@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784128770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHSWJ8T9HOn+X9gGahPrwTiUrqgZHLLPv+g56Nk4v70=;
	b=TzAt60+cCuwYR0AWcGvKzwmEAnCVnkGeJETblSqj8Rc+kdTdyufdK8Qow55BiO2dB50fv3
	jgYj0R5xx3vJnAuzH1PrmEYRoyrYY+zp/j4Dxn9wnvsIVZYpun6u6uL4vFCdTyL3+cLVcw
	2BOFkSRuc8p6tXqaRFLjxB4pNro7Y12uNZHvHQ3ogzLeF/NaUseUbNN34ygcO68P9+OBLh
	4+CgyvjjSOla6WVd9H/opmf6gWTd5XMIDpkYeR0k4fX6qV79GWpGr8qaT5xnjrxT5YtpFi
	L2OHvbJJJZlpySjhpRc23nSij7KBzw6YStaOLBOqmgnJTpDWvVfR3ST9OViWDA==
Date: Wed, 15 Jul 2026 23:18:43 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] smb/server: fix signing when a response uses more
 than one iov
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, linux-cifs@vger.kernel.org
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
 <20260715135513.667260-2-chenxiaosong@chenxiaosong.com>
 <aleYRhKFI_cdGkC2@ashevche-desk.local>
 <665142dc-bf1d-44da-99c2-08cf0209b39b@chenxiaosong.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <665142dc-bf1d-44da-99c2-08cf0209b39b@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Andy,

Please ignore this. Sorry, I sent it to the wrong person.

在 2026/7/15 23:04, ChenXiaoSong 写道:
> Andy, could you update your patch "ksmbd: defer CHANGE_NOTIFY completion 
> instead of STATUS_NOT_IMPLEMENTED" so that my remaining notify feature 
> patches can be rebased on top of it?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

