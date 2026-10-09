Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4A63EDAB8
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 18:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569103; cv=pass; b=muAqM542z9a2bDoeaPaG/kzuulUGD4IJMco4X7U0bwf+oLXi2dfRkv2T1JtXU372y1iltdNA9UYeLzK60QeLcSVgtEFwi/ttEbNdfB0W/DpnVq8QEScNW6BshgS46YXWBsZa1tWvf+Zo+1WMPfBf2zqtmA6N+l7JLZSdlAzsvxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569103; c=relaxed/simple;
	bh=zG2GYbFOx/yr4T6AS9CRERuFYMHGPxlfCsX97qPRAoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q8h0Jf6sX0sKRKy5u5vXptxRcQ8jw5qNJL4XcLNju1zNM/vqRD5Cvd6pueoi59oejLUrP9s8JpLxYOu2fl0ORWuLez1UTShVZx6C7qoBgeDF9oEaWKtJAm4Jm9pUrh/PYmpezjZ7i7cCyEf8/JZ0yIsL2eSLVhc64T+wIUCbqWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+5tIT8N; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+5tIT8N"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2dc63f8d8aso23743566b.0
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 11:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791569098; cv=none;
        d=google.com; s=arc-20260327;
        b=BiJntZGAGtbkfUtc88XKDkfyQOzEn/Qs9xn84PzPcKoRkIJyoaSHJdhOIeEqUMlGan
         DsSA2eKZEZ5TP8tFMQpCq4MRzKaOwKLaujISkUeW82c6TuUQ4JkXI4ErbvT9NIj/p3bw
         K94pcrNSoPZETVTaK249YxyirWqL4GdVlmUiZn5svFnSxQ80J1aREiCOyP4l8GiUmNuI
         jN7YlbqzZUk6hVy9QrJogPV59baYX7QSIFP5uExE5XIxxpUR/vm+p+HQFT65fAiM4GLp
         opMyPi15y1b6XeJrp0BnCCmIARFmY8xHU4OSpiIIEMt8NB+7ZkpJp2so7/fx8Di4TtQi
         GMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Nb/iVyVuqCqZPtjYpmZN8jbx7eWKt3E7mfsFqbnN7k0=;
        fh=ryzDfyb8CiN0Wy1nem5qGRQJ84s/U5OcFdfDX93tidQ=;
        b=YWxbGs8MMrfMMVRnierk7uDCdmrbf6jdqxR/ftticCasnu8IvVcfrVLDbY49D3VaYX
         vM6sDCNi787LM3i0I1kHabWsoBA8XkX0rfCW9z7qiYTRKQEw6h2mNIhIv6FvDch7QV2S
         BKt+y7/6N7KKjFI0T+7J/pfOx3nZiLNWDmWXLFRs62x+AnBUFDdH65mKivQj2roKG1rC
         TG6ZJl2HsleCsM+AVLLXUp3NG33I3KIK7QRZHBAGh2NWc7CSOY+e7NPdFmBPzeTrtSfp
         d30UB8JtB/76jzBtKTwqa9wu8yGje3To7UuRVlP+phq6G/Z9HPXAgii7MH30OB8NEOCE
         +HFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791569098; x=1792173898; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nb/iVyVuqCqZPtjYpmZN8jbx7eWKt3E7mfsFqbnN7k0=;
        b=h+5tIT8N1V6ssHj3l3CE7bSVT/w+k1+h+HVQofon5ogTLC8wMMiWdWmjtCpUb+BzXw
         5oZLOypGH9lxBXbpDLlCcbStFDt9r1shfftRFRaQHwaeCAcs9Dwcik+5QBLFJ6MurasE
         pJbCK0V2Xcbn9EmEa31SBzxfbOZG4ECvtw/9/g76/y7xQJmlzsiq8mXTFYo4TS+nUzmU
         UUCTPepvbL0A1S2+03HJlHTwxySaXEzWZGFKKSTg1UfEch+rH9X9FVbmLTN49SAyC0Io
         EtZw7Qxjn3X6JldCNMjZCOT+VE9eAdx87sdECBS0mzRiX+39lM9JHZ1rrY0r6d2FpKr5
         Fsyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791569098; x=1792173898;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Nb/iVyVuqCqZPtjYpmZN8jbx7eWKt3E7mfsFqbnN7k0=;
        b=OQVf6r/SSmFu6hZ40UNQMWPMMphah1ZUV0j6hFbxqFd9MOZjMBgErzOSduzYP6Ysyy
         GFx/RSA4KY5zhZsNeVThg4ksLXWIFIs8D4J9WaqeUY+mK/I2w3GFjhWOhZWJnbldEGty
         9v6O5tLgx12ODtd5nmvRnWi6MmRAs4H4UHc3PFhh3cP/b/BSZoSlqWLRJzrjVb41USnL
         d19k3CirhibHfeph3zf8YcoSSasxT/p9ZEdW4RtVM3IPotGYVmL+aqPVsM+r6b3CLV/1
         CBWOgBQifEOvPxaX/z0AGiuoHYgM8odIjFjgTZc23uK9rM143gPBOi13oh7VHrkIvpfa
         MyTA==
X-Forwarded-Encrypted: i=1; AKwUvBxCTISEnb2qLyOK2BxhDxRkuNmSggZ3PoHarybnKs49MmrF7HGptvU9l/KK9izUJF6k1FqTJgUmt3e2@vger.kernel.org
X-Gm-Message-State: AFq9FYLujPjsEXUiciihnJ/JO9r29RI1KZrgxqY0wLKAltebDoqdXjT+
	MO7kpbi1FLeoHI8drcg2jh5WW9OCgT77xRYId1Qatc2Xk3AvW50OHh+aPCsxlM9MdBeDIgkxJBW
	fJ4rTkdJo7gvEbXimn0bm0wnEZ2m/2c8=
X-Gm-Gg: AYBFou1Kx7/C9LH94e/nnRL+rhaXFxwiNWQujdYyyOaIMZd7woAcsBIEuOx+jyqgHWZ
	QbAsyzsnIsqJ7Z5ucOKvrw9QZdeZXvUagFaR4deSIyleweDvPxorNGFa+m/g01q50jzPeW3l7YI
	GIbOT4uky5O6wAfFaNX9nMH5t4TIx/pAZldo8rVHkdTRRORZbsp61mUGgBKV6Zt8356dS9bvQ2t
	Pm/qEAXURaIjZS+3QxNgpqZi2xyb8Ysszg7UBXCItWqZCuq6188IUTcE81yRhxE0/LQyIWpkLsf
	m/xxnnIU2otHxV8OMrJb65ubqO1VFitr+ZKA4XP52DuyNuXwc1lKp2/YeaVTPPnqCPJZ7gdlvpN
	9/ZJS3u+t
X-Received: by 2002:a17:907:6e90:b0:c2d:ca32:2176 with SMTP id
 a640c23a62f3a-c31a9fd2ca0mr292220166b.8.1791569097838; Fri, 09 Oct 2026
 11:04:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+i7WArBKHotAcKVS8iYZp0qBK2rRvuuCw=YHEoyM0TUfvbONw@mail.gmail.com>
 <CAKYAXd8a-SpSgvEr39LSpu7XqmOBejjFAUEGm=0nXvbVHWTjSw@mail.gmail.com>
In-Reply-To: <CAKYAXd8a-SpSgvEr39LSpu7XqmOBejjFAUEGm=0nXvbVHWTjSw@mail.gmail.com>
From: Tea La Forgia <tealaforgia+alias@gmail.com>
Date: Fri, 9 Oct 2026 20:04:21 +0200
X-Gm-Features: AclHuK-GP_nlJK7MK1rJT4Em8EGEUoZ44R-SoD3XsbfMPsVlSa2aqoPf_fnvzmg
Message-ID: <CA+i7WAoS-25bVQ3_3czQADJ-3-R4SpHt90bn+vMV1b5-=OEFug@mail.gmail.com>
Subject: Re: ksmbd: second session setup on same connection fails
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Il giorno dom 4 ott 2026 alle ore 02:39 Namjae Jeon
<linkinjeon@kernel.org> ha scritto:
> Can you try to reproduce after applying the following change ?
>
> diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
> index 1b24eb3f3998..88953315b160 100644
> --- a/fs/smb/server/auth.c
> +++ b/fs/smb/server/auth.c
> @@ -336,8 +336,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct
> challenge_message *chgblob,
>         if (cflags & NTLMSSP_REQUEST_TARGET)
>                 flags |= NTLMSSP_REQUEST_TARGET;
>
> -       if (conn->use_spnego &&
> -           (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
> +       if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
>                 flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
>
>         if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)
>
> Can you try to reproduce after applying the following two patches ?
>
> 1. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/smb/server?id=906a62216339d7eccc336bfb4531ce3d7850b8ac
>
> 2. https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/commit/?id=adecff0c5ba981640216ac5ba382c4a0b9d907fe
>
> If you can still reproduce this problem 2, Please send pcap(packet
> capture) with oplocks=no.
>
> Thanks.

Hi Namjae,

I have applied all the patches on top of kernel 7.2.8 and compiled the
module. I can confirm that both issues are completely resolved!

The Administrator process issue is gone. I can now access the share
from both elevated and non-elevated processes on Windows 11
interchangeably without getting any errors.

The oplocks freeze is also fixed. Browsing folders in Windows Explorer
with "oplocks = yes" is now perfectly smooth, with no more
SESSION_SETUP spam or 56-second hangs.

Thank you very much for the incredibly fast and effective fix!

Best regards,
-- 
Tea La Forgia
