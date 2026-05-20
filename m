Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC621233935
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 09:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779269595; cv=none; b=jtL/gEdiYOj8eIYbexsUgcw0JL+btWxAh2FFz9OlkhHJlpWLv8FyncVTrIyjibkjKyB8w97MlgTIsagh2NIZ9C97Ju0kFdF5RzeGYuH1SpU4vWAQjmpzgVrx+44j3K5bwZBchkrmbdWZH1PpzdNq2Vj2ty5yvHoCcowjVNVQs3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779269595; c=relaxed/simple;
	bh=Vj+0ec96/gMK0TF99sB6jBxba2hf7p8evkYNIZmuzLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UqINPuf9vCx8iVhEcRfn33yBGKWQDV5krgQ7dYWR5P++zpr1Vc7nQiG6oX+73883X7yWst+IVt17kfAFXgdUHx/9s1t3Iirnm2ZGfj2sI8YevIP/kjzp1fMFcXzcgQFdw39B0EAGWQSD9lrZoP6B9E4Dtu5BpY2HfALUHlvVrRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Fvi59smC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Fvi59smC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=5x6xK0mRM7omKqbhi8qcBCSdvZqJqK+sklNFzj/W4V4=; b=Fvi59smCise5iztGbo2LFkHw69
	st8x9dTo1lI2qVAwl2UvgvCbtUdLDwXsf1u195yw6qUYMJHMysnMLGF053OcHeGrGDBhlXHspdPDj
	LxJp6Cw5sXUf1FUtTsqphKRx+P28cYmAxIhrNAS/x6dGyEgVPqqonO8ZeYYX81gk2FYhiBYQtcx+k
	22W9jE2oSwqGf26yJXPWiN/j0D8UtV+WLXcUjpXpr+SbBqp+AGc7ZVnbWexO/C/kInT4KV0B1qsMW
	TPmHZKDZ9EXNilaCrDndGCime9/rOoa+67Irc1TNQRKbY74ZdhcWc1CkHNOqv0fAdglx9x1LPJyla
	h6+LqIa4N27B6SGT+uBd0dkVcuvRtYuGl7FCJqfB45YUQtylpN8x1yisXoodpM2zKkWIsWTHomipC
	vdeyCRzkWeDuNRsMSAU8CMaoEqZu683g3mrRg2IocFQqup+6xNH9yIgzjR6w4m8sC9nT/kJm4r8wi
	Zed0h474lD6evPJ5Az9oZVUP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wPdIN-0000000AMFn-3BYN;
	Wed, 20 May 2026 09:32:55 +0000
Message-ID: <9b73c105-03af-4e71-93b5-a94e13b8c7dd@samba.org>
Date: Wed, 20 May 2026 11:32:55 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
 Samba Technical <samba-technical@lists.samba.org>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
 <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
 <60328fa3-1370-46a7-9114-0267ef0551ce@chenxiaosong.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <60328fa3-1370-46a7-9114-0267ef0551ce@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 20.05.26 um 11:21 schrieb ChenXiaoSong:
> Once the implementation is finished, I will test it with smbtorture. But right now I'm still developing it, and some issues require an open-source client that supports 
> cancel notify to debug.

That open-source client *is* smbtorture

torture_smb2_notify_tcp_disconnect is a very simple test for this.

metze

