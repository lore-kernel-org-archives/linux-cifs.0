Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9072417D9
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780761915; cv=none; b=JBG8Tmu6KtTO035ICx1VqLm1azVXcPUMU4fkpu+eYnIoTdv9L20jN5yg7hOj0xQ1bCQxoEc90MtfGVYVg4BoZM9Np+jKEu75/d6QMFdYVMBWedldAUVjdHaYfAinaLPFHtccX3kOOhAdlVqUacDAVpFr2Ek+R4zcHNmk/KXedEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780761915; c=relaxed/simple;
	bh=fOnp/VUUFqUh19TAZKjJ5iM9jb0ka/sb7+ADGZy6VvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPGJHz+gFpTI8+26oKV9fb1L3ij66JFusGQqy6ZU2Cc1wbtT0HrX8ln10G49AD5JuNHx8gXhhFDTBPlPlAvsRNGKbIcaeqd0FYbTPH/boF8ubAGT+2Xq9p+FIj5Q1QARSBJv3mjyvFP7rSoW8dO0RkFhVqYKWeIyKqe6IWADStk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=gwaLzrjA; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="gwaLzrjA"
Message-ID: <4f5b8af0-190b-4c45-aba9-1403dac1b06c@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780761908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2N30dRn8WDHixHDKmoSy+gpcFcUQkSoXuFeRfQnBhQ=;
	b=gwaLzrjACBpDT64L0NdDgExEuXCsfinodldqfVo7B5F3slSyXvqkEbzBMRVfrmpR1bJBfU
	IHKHcAJ0+NdM02lQ4Re0dFCUBBqVa8FXetHFggFAqoiyTCREoWLEHuLeudVykbBT6zik0q
	LBUbdW3IQpmNB2uhtTPmxrBmn+qXLA2+cSrAIGktzUk9D/RKtWhCrLraTNyy/0nSiOTxX/
	o+1498Xo26tRbzGoU4BlwsirdGkX3oXCKbWwsjKkGjhahEj2VMo1t3JqezEbpZcFv7DYfE
	LMhjcy8kjww0CgRXky/+gOO2mZb/Vunl1P0PiT3vpfV7dnHzjyVnPtxt5351Aw==
Date: Sun, 7 Jun 2026 00:04:40 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl
 handler
To: Tom Talpey <tom@talpey.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
 <8135aa2d-d576-4cb1-98cf-d76bd2bdd20a@chenxiaosong.com>
 <CAKYAXd9QPcOHWn13gRZHPJhy_pEVwRpJVr87+4mv5UXmR4juNw@mail.gmail.com>
 <13768420-79d3-46ba-9144-c517f47750bd@chenxiaosong.com>
 <d53829b9-5e8d-41d2-bf3e-4c33208bbbee@talpey.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <d53829b9-5e8d-41d2-bf3e-4c33208bbbee@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I understand now. Thank you very much for your detailed explanation.

在 2026/6/6 23:53, Tom Talpey 写道:
> This thread has forked badly. See my other reply.
> 
> Bottom line - servers must never send DEFAULT. Clients may
> choose to.

