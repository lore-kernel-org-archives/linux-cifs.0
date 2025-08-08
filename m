Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477C31E7C34
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 12:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754655410; cv=none; b=MPZjxKiPsjM71AecBTgEZ0SOaQZEQ7gtmYqw0dJwIV0ardatihhaNFcd8KuyU3rzfm/iXH39SHcs1Q5bmdeknUJYIqMFYEAvc7sIo/SdlkQk0Clyd7n4kJhDyIIEjECXnwuHHeO2MY+U1xBF4V/P3Ji1OtgQ3b1CbhvZBZstfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754655410; c=relaxed/simple;
	bh=OYbbsBmlhhx67h41f47YK0gxQsek//YILertc8XlYPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eXZELGZhvu7bocgPGB4mVQNalHbhNciftUgOAEIs/ZvYAVytiHPGjC24OCchR1LabLTHCGQlACuw3tQyBGbC+uAVvU1cPq1Q9ULk/TXFnTEjYmXBmSZ2O3wHTa0lviJqDtduu4QaKDRwqm++QADFF2RTpQhq6fWvgxXc/3UKXKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AsuPKSlt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AsuPKSlt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=OYbbsBmlhhx67h41f47YK0gxQsek//YILertc8XlYPM=; b=AsuPKSlt5dZMNxqgQUkvUu4NNu
	Hl5P+jJsWrO94DtcGfEMGF4q2Ufuh73gThBOReh4mhZPtPxp7RHFaNjLbIuXokuziEMZZl/vMYuJx
	jXUlUgbQLmbzIR+vMHsuirGzc5xrO47zzCPdw7qfaZ8fAqv95d+FPmovrqTJ82Bluj5Pa3t8fhqsF
	EYBffi4RmsWtkPbemMYbM+jtyl2z44NJLBEmpP4vLe/Bc/ePXAszHukWl5X6gl0+PhEd9Mkl24JQQ
	HVnfVByU+0wQhUkZ/65cEmlIuHaXAMHb3clXh+UgO0L1iTjhfqjh72ft3XfhX5KCb8kN6EmOfgpTh
	2gP8EIcb1MAMbEyT+G2pYIqTReu5oo4TihKTp2I4qh+nFJL7r2YvsV2bHW4E24VR2SFI9p+m8Ig6i
	JVUXfva6K4JFHIGhO6OgtKfEmAMSB7r5RS74wRkFTTLL5P/ip/5UrmEG9JIGiINxUvaHLYkRALpft
	XrLKbBW9D52Oqe4mCLqKoY4f;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukM1X-001njP-01;
	Fri, 08 Aug 2025 12:16:39 +0000
Message-ID: <84154c26-ac76-4a2b-9662-b3c4f2df98dd@samba.org>
Date: Fri, 8 Aug 2025 14:16:38 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] smb: client: make use of smbdirect_socket.status_wait
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>
References: <cover.1754582143.git.metze@samba.org>
 <c1dd7da5ea65b9867693eb9ecfedf9f35f71b5d3.1754582143.git.metze@samba.org>
 <CAFTVevXk40jHJqdHyt1gfKHC6wuGMTR49mZMjZ1W-e+t_+eNsw@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAFTVevXk40jHJqdHyt1gfKHC6wuGMTR49mZMjZ1W-e+t_+eNsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Meetakshi,

> &sc -> status_wait is initialized in _smbd_get_connection() in line
> 1691 but it is being used by smbd_ia_open() -> smbd_create_id() before
> that. This is giving an OOPS on RDMA mount (attached).
> Could you please check?

The problem comes with this patch:
[PATCH 7/9] smb: client: use status_wait and SMBDIRECT_SOCKET_RESOLVE_{ADDR, ROUTE}_RUNNING for completion

And yesterday I was thinking the whole day about in which patch
I move init_waitqueue_head(&info->status_wait); to the top and then forgot it.

The strange thing is that all tests I made yesterday evening worked just fine
something between 3-5 times.

And today I got the crash immediately and was about to debug it.

Thanks that you found it! And sorry for introducing the stupid problem.

I'll post v2 soon.

Thanks!
metze

