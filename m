Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B06E3FE350
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782493964; cv=none; b=ZmECaPBvSfqwwdil59JnV5q5tldTedE8T8WGYi8io3NaKkf5bOlox67Kh7FEQyuVYAN0Kro4DXafC4CP7G4zRl2xZeEjIlMFqXyPqlJIJHm2PoPQfeuBiza3WNu7nU8rFDfslb5v2JXjA3rKrFJelI4YI0Dg1Xx4izgDzMAvb04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782493964; c=relaxed/simple;
	bh=hoZicXXCk23LxItuA5EXawRnF7q/bp56UiVveaA+7xc=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:Mime-Version:
	 References:In-Reply-To; b=EQIfbi4jxBwgtHpDD0OieRFMEFEchvVdCG/YLVhnbdviFlvmrPW3PNG32JQLJA31tLeYpSfg1TGIosiyTgxn40B/APWk7T8Tzmec6b8leYnmg61N/PPqbEQ/TvFVqRKDC3u/OHd3M3H8aRKiL3Ybt2CjzbgyclExNfD3iHxbAK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JaSNU4bX; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JaSNU4bX"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so16981405e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 10:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782493962; x=1783098762; darn=vger.kernel.org;
        h=in-reply-to:references:mime-version:content-transfer-encoding:to
         :from:subject:cc:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJWepJo+Jhb78LLfLcJQU4+8fCjO4IKujxiP3a2czbE=;
        b=JaSNU4bX07DC3s2X4yWGYMEXeLelkrQMb4rgK1qDzHiy09hdwMbN0OvT+GCCRUtdVy
         leZSYp0U5a0/MLN/RUsngfmRaV9Afm18XwwnDUtg6n0VewEaFW9Cr5ADVchAonAwizRW
         pf4ZFbdvpilrvy4sekD+ibYGu3nwbEN0AFw+EJ9vdVnGpiyvK4qfF/JZEqyqWlgERZfI
         YgKmyDn8Z7rN9ozi+Hhyf3dZ29n/UV8BJpRHdYpcebQhRNK74ktF9g++fd7kfwl0QTx/
         D9CJZwP5MM7TERAWR/ZmPxy6WFlwJWpyHj/HmBC903WULGzuxg2iQFcYgPeCFssGj7Ad
         zD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782493962; x=1783098762;
        h=in-reply-to:references:mime-version:content-transfer-encoding:to
         :from:subject:cc:message-id:date:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NJWepJo+Jhb78LLfLcJQU4+8fCjO4IKujxiP3a2czbE=;
        b=psl25VU412po2dpgHzzE7e3vKKw/zmRop/0LgKaA8JQwp3wZwCunbcS0X7qI9r4T8H
         csLrMtRi/p4sruPKRorSWysr9ozht5fRA4yI639ceHf8Ugh1yRkg3AXplEpN5A/S2ulK
         TyBXDUiwhQIH7BkqMAL868PyixwF6wFpavQmoBBz31cw5vFNcVj/Tjm7XGuykQ271ceK
         yZWvmYhX/8kew9zGcZxQDv8kS+34Kw0HPjP8T5seMSClcMOXmWMmdtI0CULwIXCxbA7r
         1jJybocxMn4OCVc749Rv3BsGJHRTX5u/SYr7v8hMSRaqCzKjA+w+/hVI5zrrZOJV+3zw
         iwIA==
X-Forwarded-Encrypted: i=1; AFNElJ8sqoQNwthUPuDyVngpJSbKqHEyUXAkxfl+Zy4cbNChsl3Pn4NpCsVTZDVRXQwAFUj7j9/XYt9GC3Fx@vger.kernel.org
X-Gm-Message-State: AOJu0YwBR+2dz3WB6+Ptl8udw9Ku0rrACWQrjrysU+tJwpREvKtNeoS/
	4oQjMt9Rq5CjrmZxnMz6wb3LPIGS2g3UcbWehCrix/i/bBM9FTuZXlpaMGFpVHBXXqA=
X-Gm-Gg: AfdE7ckYRCypWtZxcToVnODsX2U+muZtCKE2MkcOTOc3RDywK/X/jE59IGFVKrUJB+H
	Zgw9HeWJgLvIijNpdBi7CwocOOi3vdgrOsXion/oNEf3+zXg/Z0p3iWmL7uCUtaTEGBI9GfOL3m
	DkYltXBWJObtikb92q8fN4WyUyi/YoS94r/dphczUf78ZRutb9W5bV/0O/gRtNekzwGtb9XbtPN
	wi3Za105q0kOAI5zPHoXfVB0s6JeqDZhxby+913CowPVSPwR9EdtYKoaGCA6avGgbYIdsTZxzBZ
	p6kMlcDAvZ827+eKCehQ/sIJHqOcs2IqBWl+RB2wsxkIl3cCawpFKBPve+k7XgCmwBCIZ2GS2xc
	4VofkNljL3EbUGQoGC+1uFb6BlFve/G0tF7FUDH97w2BMb6aYyVLW+Z1mS53biyFRmeM6/1YXyX
	PdGEiB9gt1Pl9ALMlW+io=
X-Received: by 2002:a05:600c:58d1:b0:47d:52ef:c572 with SMTP id 5b1f17b1804b1-4925a0a4fe4mr216744445e9.1.1782493961548;
        Fri, 26 Jun 2026 10:12:41 -0700 (PDT)
Received: from localhost ([2804:7f0:6402:38cd:c905:3f5:b088:d65d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d9105b57sm19619883c88.14.2026.06.26.10.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 10:12:40 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:12:37 -0300
Message-Id: <DJJ5DFOAO268.3SBYMHO182EDE@suse.com>
Cc: <sfrench@samba.org>
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
From: "Henrique Carvalho" <henrique.carvalho@suse.com>
To: "Max-Ulrich Farber" <m.u.farber@freenet.de>,
 <linux-cifs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: aerc 0.21.0
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
In-Reply-To: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>

Hi,

On Fri Jun 26, 2026 at 12:39 PM -03, Max-Ulrich Farber wrote:
> Hello,
>
> Here is the bug report:
> --------------------------------------------------
> Subject: BUG: SMB3 POSIX extensions: Creating absolute symlinks from=20
> client strips leading slash
>
> I am experiencing a bug with the SMB3 POSIX extensions ("smb3 unix=20
> extensions =3D yes") where the leading slash of absolute symlinks is=20
> stripped when created from the client side.
>
> Steps to reproduce:
> 1. Mount a Samba share on a Linux client with SMB3.11 and POSIX=20
> extensions enabled.
> 2. Run the following command on the client:
>  =C2=A0 =C2=A0ln -s /media/Raspi/Test/Reisen /media/Raspi/Reisen
>
> Expected result:
> The symlink points to the absolute path:
> /media/Raspi/Reisen -> /media/Raspi/Test/Reisen
>
> Actual result:
> The leading slash is missing, creating an invalid relative path:
> /media/Raspi/Reisen -> media/Raspi/Test/Reisen
>
> Additional Info:
> - Symlinks created directly on the server host work perfectly and keep=20
> the leading slash.
> --------------------------------------------------
>
> Server: Samba Version 4.24.3-Debian-4.24.3+dfsg-1~bpo13+1
> Client: Kernel: 6.12.94+deb13-amd64

The website https://www.smb3posix.org lists Linux 6.13 or later as a
requirement.

--=20
Henrique
