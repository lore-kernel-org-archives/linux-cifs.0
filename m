Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A815D2629D
	for <linux-cifs@vger.kernel.org>; Wed,  9 Oct 2024 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502998; cv=none; b=jClkLVxGnwyaNFZGQecIy+RGk6AgsjZpN2rs+KZ5mKE2cTwGfy80izp6p8kSnTuLRQbU19Zi3Ittj38X+y3vEYiHGRp2r/M1Ip0wc2yPRX+BZHfWZH1KaGFFKbNG7ZAkPz+AE+rawROo8D+vzadp5jV6iiOMvwXBTJWSP/Ip3+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502998; c=relaxed/simple;
	bh=Ij1kO7u9V9cX9s2oEyK1VX8R/Sl2d9WeprmcniF/0Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1gk3xl0+x0UwowXdusOFfEE1/BoS2OhyX7Nx3t60yTwH6pvUhEFdrSGuaOwtwnpPXXpWW56KAv8VQ5anIXP7QQ6AiSaYIALu0Aju/YTUhxj2OBuE1h1qT2xpXWmhmX2CKCBr4OtR+9AZR3KnEe/zZpN5jP97xvPyVlbP1w9y2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cPdskftL; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cPdskftL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=mJbCIKSNymdP0JuBAmlGHDVFpevqFviZQ+cMQqealV8=; b=cPdskftLJ3fjOIqd9GRJ75S+XZ
	ndwL2DxQyDnfq/nbeBcmcZqaQyAogViI6/jkMaqC+Rk+Y6pb7RAxDarnWlR2d03RdzlmyPIwZwxgL
	vumWMJWsEjagoozMJKKozgN6tvCcFerd+2aHBhyHK9GsPsdDx+XQSu5extcj0yLNpAom/GqvOf0wf
	Rq9NhqrCsOhhGMY9krcGAAuQCEwG7cdPlwUwwWYA7CqNaY5tyz/j2tum7x65hEMwyutBgxqr2W/Ws
	owDHWUISOuhefdw+f7kLAw8Xe3udLxIhVnCzQT7Bn6Lh0KnEPxuHjaiZ7euQDlZNjaX/xvV05QBl8
	7xVfjSrXj6GFPcnk4cpLpPqdGpc9IeXvBBq1ReAlGNZKdmb077bi4iIt5187xZBwkYOl9vvKdZ8cx
	HO4JtVmuT+uJok1GdvufWCa/rHh/Pju6GZoVZOYFx7JLi1rSzv/QvA2/3ibTE80kmtqO22IS9n5tv
	uzvy1c3lCiusvIm5lDOkTEIq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sycaW-0045wd-1G;
	Wed, 09 Oct 2024 19:43:12 +0000
Date: Wed, 9 Oct 2024 12:43:09 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE
 on copy_chunk
Message-ID: <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>

On Wed, Oct 09, 2024 at 08:54:12PM +0200, Ralph Boehme wrote:
>On 10/8/24 5:16 PM, Jeremy Allison wrote:
>>It was done as part of the SMB1 extensions - trying to "pass-through" all
>>possible POSIX open flags.
>>
>>Just remove it.
>
>ok.
>
>But then we still need a way to pass O_APPEND over the wire with SMB3 
>POSIX and we're currently lacking a sane way it seems.
>
>What about using one bit of the 17 reserved bits in
>
><https://www.samba.org/~slow/SMB3_POSIX/fscc_posix_extensions.html#posix-mode>
>
>There are more possibly interesting open flags though and I wonder 
>whether packing all of this into those 32 bits is a good idea, but the 
>alternative of changing the SMB2_CREATE_CONTEXT request to add a new 
>field "OpenFlags" is not really a great looking option either.

SMB1/2/3 has FILE_APPEND_DATA.

  From the definition of NtCreateFile (the NT kernel
system call).

https://learn.microsoft.com/en-us/windows/win32/api/winternl/nf-winternl-ntcreatefile

"If only the FILE_APPEND_DATA and SYNCHRONIZE flags are set, the caller can write only
to the end of the file, and any offset information on writes to the file is ignored.
However, the file is automatically extended as necessary for this type of write operation."

Can we just map (access_mask (FILE_APPEND_DATA|SYNCHRONIZE)) ==  (FILE_APPEND_DATA|SYNCHRONIZE))
to O_APPEND, regardless of POSIX mode ?
