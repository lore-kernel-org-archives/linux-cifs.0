Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937921422AD
	for <linux-cifs@vger.kernel.org>; Sat, 17 Aug 2024 05:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723871396; cv=none; b=JT32k4nL9A6WxF/9RsyFPWWE0mnP8Cp1ravARMos1PLa0LOoecL0MbRyiUIkG3mU9+AosAVmbdRaj2FruLNWab/FiBq42ZfuQdwaXUINdzkhV0jIAhU4/QHPIyi2D7alIVpWk9h4fDkz12HLc2VunwKtSomHhcawbTWYbJQUKCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723871396; c=relaxed/simple;
	bh=JpSY2rRIer4fxBniOBc5Qk9nEk7AOr5sLCX5QfUa1nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XfFvRVs/w6Lap+2+WXHg2CMzS2fOHSNayA2Yt984lI32qYnneg3XctHHPkOVJRkO7YCjwBjt6sSZrY/VVyFWzr4AsnoKA8YcxGkew6ne3a6K/zjt9eBDel8LrNXRfzP65eXxwp78tf8y5JNBGBq70Q4mAvZ/doJFcuiNjYmemKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MGTUjVmt; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGTUjVmt"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52f04b4abdcso3272688e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 22:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723871392; x=1724476192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vpw4ruIk6m9iYAtQj7A1prh84SlH6kPrgDxN0w+6Ubo=;
        b=MGTUjVmtmNKi8Y4ZzvJpDAm7E1/9g+wfHASmmf/v7L+HOq9sfb/u9GJ8lLDuKIIjJA
         X88dYYSitwHPwOtHgBoiICM14R81E6nwE495Qiefhv9xaGnP87lB+rvp0X5YAId07bQx
         1uPWypi85dBVvDz2eskUPY3r2xExZP/a6m2vKt9Z5Iz7QYGYfJa2bDAVoz9Y8vM0Rqnp
         ZffkG9yB+ERl1ivBCIt1LVyG+/Vb4fD6PlzZjB7JJD66oJwOjkJino67DoX+8eXzD1RA
         uXGek8bNEV6743EjZIFJT3adW/DjuFo4pi73LZqtTYMpTuz4WzTJ2u5kHWViud4n9DLC
         0pYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723871392; x=1724476192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vpw4ruIk6m9iYAtQj7A1prh84SlH6kPrgDxN0w+6Ubo=;
        b=DR8c6dpEgsHgfozOfByCKvani+nzbW/RmtGfA9hUK2mucTQGyo36dOJguEOM/ySuH4
         d6hiPy44TNNdCjYKpO7MxQOgFt7gnRXwHNKd4hl6/rDXMWh46b7KIpWNKtWxgL9AGetr
         jA0YHOgZ5vmtaFJgUc+HSj0bRvvQTFEfiH+ZNRRgRgFCxCZv7lkf7r4LT8EqcoCeH/ui
         OyPrLqNOnd/35jmDtZ1BppZ11CPXAYqNTNVWh98OprmsyHGxNi1g56kFsA+kT7u68eej
         KexUeRTMsbzZQQkOOX8OvqCMCQ1HPjCMgfylXrDA/1auWmgqjCuCkEaPoghFHkWlFM7Z
         +PgQ==
X-Gm-Message-State: AOJu0YzjoJk0sD9YnvNfJ8Iv36G9nCcrtXlMfbXaTu/X67dwvnvjN7KJ
	SbYUrMvxLnAPJWwwwXzncfHKv7pO+PCiAb0CJ7/+tqyfw4+5r5ayjN7jjMqBZ6tvXK/sYMBcyaB
	hzewHZOMoh219O52OGf/kKjZ4OTNhdw==
X-Google-Smtp-Source: AGHT+IHBZwUGB8VLqTQcg1aadVsu59JH49rKFCK0/SJCUhSIxo5rNaprpp8i2mUPm2CO7OoK5A8JdA9Km0LPAjKCnEc=
X-Received: by 2002:a05:6512:2386:b0:52e:941d:7039 with SMTP id
 2adb3069b0e04-5331c6f3ab3mr3223187e87.59.1723871392106; Fri, 16 Aug 2024
 22:09:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtJA0AO+5YGXUKhnb0rtnezrNufZkpMAAuJ5tEKTibgig@mail.gmail.com>
In-Reply-To: <CAH2r5mtJA0AO+5YGXUKhnb0rtnezrNufZkpMAAuJ5tEKTibgig@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 17 Aug 2024 00:09:41 -0500
Message-ID: <CAH2r5mt=7PjoDbZYFm8fKN-7YCtMLE4d-fs=U7nc77sxZEmehQ@mail.gmail.com>
Subject: Re: [PATCH][SMB CLIENT] fix refcount issue that shutdown related
 xfstests uncovered
To: CIFS <linux-cifs@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This does not fix the umount/mount busy errors you see with tests like
generic/043 and generic/048 but it does fix the rmmod problem.   And
FYI there is a workaround for fixing the umount/mount issues in those
tests - by simply adding a 1 second delay in umount.  We need to
continue to debug the generic/043 and generic/048 umount busy errors


On Fri, Aug 16, 2024 at 4:56=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
>     smb3: fix problem unloading module due to leaked refcount on shutdown
>
>     The shutdown ioctl can leak a refcount on the tlink which can
>     prevent rmmod (unloading the cifs.ko) module from working.
>
>     Found while debugging xfstest generic/043
>
>     Fixes: 69ca1f57555f ("smb3: add dynamic tracepoints for shutdown ioct=
l")
>
> See attached
>
> --
> Thanks,
>
> Steve



--
Thanks,

Steve
