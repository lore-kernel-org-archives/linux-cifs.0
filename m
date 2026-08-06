Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB0248F82F
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 20:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048543; cv=none; b=QKubfaSpNXgIPFQqz1XXZUUi/8ULXsDM1ZpJ/Dejd8NINpzyze1ruSUsMqu3MAxzf9J16IexI46VVyILA2wzQr0DGaCOWcv41tzRo6TCFYFnvtUnRPG4qh3Sow2tJZhN6kDwwWMwZCX6VlBT0Te4eJ4oafuAnNhl/gBbxCdTZRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048543; c=relaxed/simple;
	bh=jepbOpqdyblXAPqRlQtWkvMhtNA1YXEtX0Kxd9NX5tg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AYAFGsEvQoj2wcYkavJ078LcewKAnM9IY01nA+SknJDoAlqfuVtvmUBM4p53VtVp8rzpvQAWnr4kwM8XgLB36PpqJAmd9XAb1G9B06aZn/uPWwtjLJEK+06sutsc7gB9yrvnfRuN3kYuVEUL8QvLlAlQPRQ2KeAkJ/OmUloLVas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=EKMjEhBf; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="EKMjEhBf"
Message-ID: <b626fa81-e019-46e0-b071-e4806f08b1ac@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786048537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYeS2bqv4TLDnAQfd1CuXH1ZrUS7nChO81BnU8HyNb8=;
	b=EKMjEhBfWXcuu3uP/3pwBQy+Did4oVSfBkrSV/fIXHihYRWAbJiWAVa5UI2+MRAEcWf6J0
	MSsLj0dbwxBso+oM2DT1P+83DQuPcbZ4tKNWunk4g25kYquro3SGD4wgTavY9faWvVORLv
	vylTIUx3OV09hhJJAdBuWbMmZnEodEOIAuXpnLXpwst+NqsDi5KvZy+OgDSOy5l24mr2XL
	ZJuaECVogJeCX+bxPN7zq5jbEqZGDTSdrhaRgRBBjyBDKaAUuX/6zWNPnEslHabQoNInEB
	7Df+w0NDNtI1sF0Xe0VNVrdUeEnIzpdvipfcvw7VcGi+iAha4Gmyag1OyAAuUA==
Date: Fri, 7 Aug 2026 04:35:43 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
To: Hang Nan <2122295973@qq.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_1C4F8C48E45F6AE9D165CC17B3F620C40C08@qq.com>
In-Reply-To: <tencent_1C4F8C48E45F6AE9D165CC17B3F620C40C08@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Hang,

Thanks for your patch. Please rebase it on ksmbd-for-next-next branch.
: https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next-next/

Could you share the semantic KUnit test harness?

在 2026/8/7 0:04, Hang Nan 写道:
> Validation:
> - semantic KUnit harness shows the post-boundary ACE is selected
>    before the fix and rejected (EACCES) after it
> - linux master (7.2-rc6), x86_64

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

