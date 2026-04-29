Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E141030B529;
	Wed, 29 Apr 2026 10:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777456952; cv=none; b=AKAxOeAvFja/Jmsj2gm8xY9W71ip31gMxgE9bhdmX/xDc4mJntPMRi9u1ASQUfk6lTBatclMdvrc20l/Omd9QPoh3dtclibNQM4uaIcM1N89LCd//+7/sWj7GbOFAIhIWwhIaJG+h5KzOTXwWOFNnfAnJHq3IAyFAB/etF1jdyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777456952; c=relaxed/simple;
	bh=5YxoJVw44KcgxBvVmsrpnvEKT6/I3k3MSEPJNDbF2po=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sJXxFN4FDr6O2T1mJnRQk25I/e786Kq75ggfi9p/HYjOoNEl2+eUx2SwuABTBRmThMRbuHmV8aHSZ2OKgYVsEfGymoPf9qIKDXEv/GBn8m5lawp7uNTChv98lERR/aUUJQSitqaDkzDEDwQaeyPWsTVVkY9kQ9q4KSQaAVc/IEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JRFiHFj3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JRFiHFj3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=et6/844maY07PTlAUxa16aWNjywP2dUE1B0QsoENJXE=; b=JRFiHFj38HyueftVID3uiVuy3F
	1NuuHKe0PgmjEgAsok8icjbtTIPwKLZ+TXULWIG7M1tKsrJskkI4NK0+TQPYsHmX9bcByNHZGgWs+
	QjB+awnY15BRvwKK3BN1wldo/MyFBdeZ+L/btRNQazOBcwmYGI7zLzpP6nzbCDNvRo/5Q6If0rfhX
	fp4w9o++U0rkKkFCpyMWGdxmF6KX3cOBsgh7j206CR9prglktXxDzfHhM92IG5TXUZptMz2wryT0Y
	fgCV5SqNwFIULiUEGdDYktnmYgydQz8VqyFyO2NGL8zACoodiMjACc0jkZjAfmQka1TzqqqmxCEVi
	Hh1ol5yKwPqlrzJ0T+J+2grLnSAAOmS2Cwrmooiy9xEjTQGZsw/S9mk/3VKObC1HZpQ4vQAEfGsHb
	aDM/y6OYQW9sv6FhH8i8H/DajXisCGFgWEQeVVfJfxvRUmW/rRvX/q7qD82Gezj7EKZWW3q7MToeK
	xvhp/BApLl0DMqRBpHJRUCum;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wI1kS-00000004xya-1o8N;
	Wed, 29 Apr 2026 10:02:28 +0000
Message-ID: <60857c4e-0d72-40d9-ad72-c2132a19c6ea@samba.org>
Date: Wed, 29 Apr 2026 12:02:27 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: smbdirect: fix MR registration for coalesced SG
 lists
To: Yi Kuo <yi@yikuo.dev>, smfrench@gmail.com, linkinjeon@kernel.org
Cc: tom@talpey.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <5b221fc2.AXEAAJjZnuQAAAAAAAAABAMtJJkAAYKKIjQAAAAAAC-ZZgBp8da7@mailjet.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <5b221fc2.AXEAAJjZnuQAAAAAAAAABAMtJJkAAYKKIjQAAAAAAC-ZZgBp8da7@mailjet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 29.04.26 um 12:00 schrieb Yi Kuo:
> ib_dma_map_sg() modifies the provided scatterlist and returns the
> number of mapped entries, which can be fewer than the requested
> mr->sgt.nents if the DMA controller coalesces contiguous memory
> segments. Passing the original, uncoalesced count to ib_map_mr_sg()
> causes memory registration failures if coalescing actually occurs.
> 
> Capture the actual mapped count returned by ib_dma_map_sg() and pass it
> to ib_map_mr_sg() to ensure correct MR registration.
> 
> Also update the ib_dma_map_sg() error logging to drop the error
> pointer formatting, since the return value is an integer count
> rather than an error code.
> 
> Ensure a proper error code (-EIO) is assigned when DMA mapping or
> MR registration fails.
> 
> Fixes: de5ef8ec3c46 ("smb: smbdirect: introduce smbdirect_mr.c with client mr code")
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221408
> Signed-off-by: Yi Kuo <yi@yikuo.dev>

Reviewed-by: Stefan Metzmacher <metze@samba.org>

Thanks!
metze
