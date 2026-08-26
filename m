Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068242DC783;
	Wed, 26 Aug 2026 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758249; cv=none; b=desQavCKGM9xitjAjBg8k2r4fiAA236uaPkQ5uYsoH5U1UmrE7N64kYk71mL09tQNAn6I66R4hpCtM5s8PZes1O7h3umRsaI8gitrSpbE6Xom+K4O+WuPupF4w1a+mgTOV24ooGkfDwB8xdJipjxqoxxOFGQjM2delQhDePeQZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758249; c=relaxed/simple;
	bh=+Um2CgugFn6r2dezM726FcrQNbrpFK7o8Xvtlm8ngX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5XS8JczeFPnbSG+2O56vhBWnNR4D7ZYIMoPt0Y1K9SBcuJzg/gvJPW0/Mn1zN5c+rXS1Jeu5XCBPNmpNStIjPw7vKq9HnCL4M5yrTr+/sBVX6rg+HaeGCAq1d/jaPN0cNuyZM8L7rLixdRO212oo7jl+Y49T7rJKQwpLaasnE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2TFGA8ZI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2TFGA8ZI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=AMBIicEQi5Dvgq8hxYz7Ll0KubEmVdgYfxCoqFx+Ito=; b=2TFGA8ZImhlzPmyR9mW8bQxJqp
	dEXlDlsxg9+Ta9m1YfaicwzZTSGQ90vTZaAoOVVQ7aggaQeI6j60K0xtoeto7bJWGqDiJO7ipQ5uk
	GAn4cNiGrjvrN5ah9HIs0OO2QYH71nqwgHf6bb92pB5hMUbQ38lueeUafmpG7jOvwWVZrvYqWgqSj
	bF6aCDFX0TU2jQGj+huZvVChvdMyPbF2hTNupKPLjHdDLTUmyq5g+wyE83TW0SYktnkTaHjHDvOxi
	gymArqNkY4Yq/iA5t3HhxiKcUlut/qQGM9B7nUHVbgaozKaIYZShHWc2otXgNdeJ3sy4GCM1V+3U+
	eyH36sD2y7h5ZU8lYPPCEmzg5oLM/Pcg2G6XzNQ76JMgFsTNYCwhm0m7wsr4/l+20KKjq2TlTmsHJ
	hHOSE2cCjgcOQRq736Aav0Jmd5cG6ht8J7niGjS4IrBKWxhX9bOFvIs9V/lsz0RwtguOl//R0mMIq
	0vuNdW+pNFhTlinEcmEC3nbd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wzFF2-000000013Li-2Us2;
	Wed, 26 Aug 2026 15:08:40 +0000
Message-ID: <f2bdf83b-70b3-4d55-af52-9a3af7c512e5@samba.org>
Date: Wed, 26 Aug 2026 17:08:40 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add Paulo Alcantara as an SMBDIRECT
 co-maintainer
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: tom@talpey.com, Paulo Alcantara <pc@manguebit.org>
References: <20260826150106.15352-1-linkinjeon@kernel.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260826150106.15352-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 26.08.26 um 17:01 schrieb Namjae Jeon:
> Steve French passed away recently. He was a long-time maintainer
> of Linux's SMB support and will be greatly missed.
> 
> Add Paulo Alcantara as a co-maintainer of SMBDIRECT alongside
> Namjae Jeon.
> 
> Acked-by: Paulo Alcantara <pc@manguebit.org>

Acked-by: Stefan Metzmacher <metze@samba.org>

Thanks!
metze

> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   MAINTAINERS | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e05570c393c5..7e1d14406619 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -25105,10 +25105,9 @@ F:	Documentation/admin-guide/LSM/Smack.rst
>   F:	security/smack/
>   
>   SMBDIRECT (RDMA Stream Transport with Read/Write-Offload, MS-SMBD)
> -M:	Steve French <smfrench@gmail.com>
> -M:	Steve French <sfrench@samba.org>
>   M:	Namjae Jeon <linkinjeon@kernel.org>
>   M:	Namjae Jeon <linkinjeon@samba.org>
> +M:	Paulo Alcantara <pc@manguebit.org>
>   R:	Stefan Metzmacher <metze@samba.org>
>   R:	Tom Talpey <tom@talpey.com>
>   L:	linux-cifs@vger.kernel.org

