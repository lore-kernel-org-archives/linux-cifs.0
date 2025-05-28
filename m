Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AF277813
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449204; cv=none; b=VkfYpI2pJs+JM4BpOPIejiBQHlStCJy9xv7AKmPJ1YjYizNnd+IgCIZUj0QGYINjiOtU3q/2LG4OsWj+BaxpjcSQlvCme/OResgUdH4le1bdSVWVGa5Qk5CiXsAf7FL+bR0wJxNXGwvRMbmHXolGyQmbcb+H3oEsRKCz+CcTUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449204; c=relaxed/simple;
	bh=zQsToknU7Um4tfacTDHfPQBzmo7OSbWskJAquiO2fGQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=BmEHrjKb2/Z900wZB3hSddpatuxp5BVFSp5ilHT2QTgM6BetYNWxM8n85eiDFZOZAERCvdCBYPuRCAkpSk7yJDENOj2vaw8nY2kUP8Gnhkll5vZqhanz7ysaEPp0j1VORdDx/PkqpwsKjezh8SVCS4wGgBRo7cZyyQxHt0dAhBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yN+/7Izx; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yN+/7Izx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=zQsToknU7Um4tfacTDHfPQBzmo7OSbWskJAquiO2fGQ=; b=yN+/7IzxRLA8sqFl2bd1dLMGHC
	8sVI8R6jyQHoCYXFYFAhBB2vGsM/fEVlhok6ytlkwxkQF/f4JM2mrx8fcDbxdvn/iCaufyCVk7Cyt
	3b9bCMH8bw5TGMAkK9qFg4c5oEXLuILKP2AQkHmEUOYnNub6s+ypPVpDL2XUNXtY5q/6roKtxS/3C
	jpGJ1ln04xyvhZyBrmO0FjwP8iTFbaz7f8cRKV8xzFE7zu57Pj56L+7BjKoPM7SoJBAVJJkHGfIPz
	Sb0XBwJsMlh2zNWRO3HJaJ2zw39uIhYgJ3jp0yENW3/96QTxH3rWiNeZtmBQEOrpO83b9KNhxxu8K
	tByiT//mjypfzoQnqtJHDimg9Qqlmyl6HE9mJPJQSZjI4aWQ+aAFutw6Glq9w04VjbFfUUgab+p6H
	5c/YKiKh5QmPlmi+eqZ08cBWJDR3FQ83turWAwCPsXXKMx6HdSkFOl4E/0hdT+hwTxTzU2XJihmM3
	8KD84vv7FLqhd2CUxLJjMdrz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJVQ-007huB-2X;
	Wed, 28 May 2025 16:19:52 +0000
Message-ID: <04ad8564-4a55-4308-86ad-dd6dc47fcaab@samba.org>
Date: Wed, 28 May 2025 18:19:52 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
 Hyunchul Lee <hyc.lee@gmail.com>, Tom Talpey <tom@talpey.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
From: Stefan Metzmacher <metze@samba.org>
Subject: ksmbd uses ib_destroy_qp() instead of rdma_destroy_qp()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Namjae,

I just found that you used ib_destroy_qp instead of rdma_destroy_qp in ksmbd,
while rdma_create_qp() was used to create it.

Is there any specific reason for that?

The only thing that is different is that rdma_create_qp() takes a mutex
around calling ib_destroy_qp(), which might be a reason for a potential problem.

Assuming there's no real reason I guess we should use rdma_destroy_qp
in order to get trace_cm_qp_destroy().

Any comments?

metze
