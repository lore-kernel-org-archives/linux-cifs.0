Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262CA2EA723
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 08:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761293923; cv=none; b=AoNZM/BYFC6IKGV79EZeVaMBvsuQDgPoKt1Om9ZOK5GvN+j6v62tL7noDiQzU5m5N2K258bNuUEJJuFEPiSq4H6ohB4R9FfbWv3MIywcGrpLAT5hDg6Rc2Hg+7CuDMT3deAvYo3yKk9YvcSK9a9FNxaGDG6lY45oZj2btnY0xms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761293923; c=relaxed/simple;
	bh=F/AsaJWaXnRf4Ffi4FjdhMqFIbkputpBFXP+Dz5QhNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uay0dFVU8iplEr2xtmHwUJ2EeenlIWUEUXz5lKGVrOeO/vlmYKNPua6+0eIz76pr8dIvpRH3PCCtsG9WLXLitJ8UHanhjyNBlqTk4+KV9X9d5xyGHTa9noT/pQQN7/MYosseB2r3E/wLrCD46WNcJnpRwLpAqPDPMHrh1/TP+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXcLzuAv; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXcLzuAv"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63c3c7d3d53so2722137a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 01:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761293920; x=1761898720; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxtIHZNmwawyIJXtxXoptc40yR+RhBOnr00kmoWAGLg=;
        b=MXcLzuAvG3Bo481KRtE5dmDBuYRpbrc02Q8epcRI7uk1YJpgHs1BEVrUUkAIR7glfo
         eQv8iBtCDNKYuB2Yjjs+Uyr09NDQHPW4uJe1LUBRSUKjGxSc6TJ/J20STgu1gemUSzlJ
         EgVD2OmB++olvT41u0a7cWCqMYzB36U0+4Jgn9Lwqx6Rwozk9smzTsBAzmBwuJmTHkSF
         oLRnrUY50hE593Co+C8+IWk28Zk/Vc/HmpT9wVmQryWtoChF3tL1HhGOswC0AS2Ei5Sj
         Dt8en/LrE7Y0cIXYGmaWg0Ih5mbPaqVe5Diy4UsmMNgTVtGzNLIzhqmO9cIPh+r2ineb
         bBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761293920; x=1761898720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxtIHZNmwawyIJXtxXoptc40yR+RhBOnr00kmoWAGLg=;
        b=CjOiyVp/5WTRjWEYjSRg0nBm8g0+RfIMIcfXzVYZLpPVNBcyBg22WWt0eaHdfJkGJE
         8SN55HrCtXO2ZP2CB90Rm0buI/+yORXisw/5hJGLu65G994Kb45tGSUb59HLntpBYu0/
         AzFY9wpR6cyRKyUbFeJ7V5FfMeQWf90kiIEnmQ4oKB5DIqzhGBlv99Oa1hPnLfVOASxT
         /k0voNP2n4RtlNV8pa/KhlLPFCz1CcswVK3WSUQkfL2D2bReOKa/LlsG6Ki7a+MfnH26
         gs8V3EjDfNB5tHSOiqULX+SjAGcmNSMcuGtMzjsNsCxB3QqorsRFOQzLzEmLbmpMvGOk
         l18Q==
X-Gm-Message-State: AOJu0YweKTTuDJNBC6sMS+KAZBw+LlhI5vrHTf4Bn6HAWnk9eCkhsyPR
	GXU7WaVHsvnWq4IkfAAc6d4AAoY7jjaJuizxQ0HC2axovRiueRXJ76/kerB6+tLORH46LHNZu5v
	UNsGney5vcFR90HakbK/vZyX5ni6JzvbhBmcV
X-Gm-Gg: ASbGnct01BPn8ktOJuzsBKzVlyYAcofhQI6QgdJVgl46Ri7cGSSm9G6fXQl6LU4tQyK
	VDCzguR00AHVjEqijv41QI8hmp+gnEtoZRtcAw5mhxF6mZ+kdWcwk+FB6s6p99eUxGQMwwMn5yn
	tSi4OHhKPXc6wSsZ2/57oBQmcSx1oN8q2DCChhSOIXGo03zuwTFZ7zYZKxHOcCVkf8NSZLlp6LS
	Lcs3Ks74WFkDP+2qb9Gk0uIeT4ZGFDku2Cdrhe2lSXhpwEGxAMr+maNKqrcaLb03FDlsHLhbDT+
	kcH2
X-Google-Smtp-Source: AGHT+IEI9X6feGw2fa6YAfgN2jkYCV1nMnALxX2XoIVEifm4oXRk3d5oTwvSNW4e2MhT8hCSd3YlhWn9QczGNWS/N4I=
X-Received: by 2002:a05:6402:26cc:b0:63b:f76f:c87e with SMTP id
 4fb4d7f45d1cf-63e6000390cmr1367605a12.1.1761293920075; Fri, 24 Oct 2025
 01:18:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
In-Reply-To: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 24 Oct 2025 13:48:27 +0530
X-Gm-Features: AS18NWB1I3iJ0S7VZ8z-pHDVInxR5zM3xXdsJz2yaeC9XYBstvt3Xy1HDtitkrE
Message-ID: <CANT5p=qktRuzfwwAceyQWYx0k47udy7C4uQc8FASwRWfSYL_ng@mail.gmail.com>
Subject: Re: mount.cifs fails to negotiate AES-256-GCM but works when enforced
 via sysfs or modprobe options
To: Thomas Spear <speeddymon@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 2:22=E2=80=AFAM Thomas Spear <speeddymon@gmail.com>=
 wrote:
>
> First time emailing here, I hope I'm writing to the correct place.
>
> I have an Azure Storage account that has been configured with an Azure
> Files share to allow only AES-256-GCM channel encryption with NTLMv2
> authentication via SMB, and I have a linux client which is running
> Ubuntu 24.04 and has the Ubuntu version of cifs-utils 7.0 installed,
> however after looking at the release notes for the later upstream
> releases I don't think this is specific to this version and rather it
> is an issue in the upstream.
>
> When I try to mount an Azure Files share over SMB, I get a mount error
> 13. However, if I do either of the following, I'm able to successfully
> mount.
>
> 1. Enable AES-128-GCM on the storage account
> 2. Keep AES-128-GCM disabled on the storage account, but enforce
> AES-256-GCM on the client side by running 'echo 1 >
> /sys/module/cifs/parameters/require_gcm_256' after loading the cifs
> module with modprobe.
>
> I can see after running modprobe that the parameter "enable_gcm_256"
> is set to Y (the default value) and the parameter "require_gcm_256" is
> set to N (also the default value)  so I believe the mount command
> should theoretically negotiate with the server, but it seems that no
> matter what I try, unless I require 256 bits on the client side by
> overwriting the "require_gcm_256" parameter, it will never mount
> successfully when the server only allows 256 bits.
>
> It seems like mount.cifs should look at the "enable_gcm_256" parameter
> and if it's "Y" try to use 256 bits at first, falling back to 128 bits
> if the server doesn't support it or throwing an error if the
> "require_gcm_256" parameter is set to the default "N" value, but I
> must admit I don't know if there's some reason that can't be done.
>
> Is this something that could be looked at and possibly improved? I'm
> unfortunately not a developer, but just a user interested in making
> better documentation so if this cannot be improved, I'll go ahead and
> get something written up and share it with downstream teams like Azure
> Files CSI driver -- on that note, I'll appreciate any clarification on
> why setting this specific parameter is required if this can't be
> improved.
>
> Thank you,
>
> Thomas Spear
>

Hi Thomas,

This is documented by Azure Files here:
https://learn.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/stora=
ge/fail-to-mount-azure-file-share#minimumencryption

I suggest you open a support case with Microsoft about this if this is
limiting your use case.

--=20
Regards,
Shyam
