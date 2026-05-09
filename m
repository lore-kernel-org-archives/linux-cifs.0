Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC7D282F3F
	for <linux-cifs@vger.kernel.org>; Sat,  9 May 2026 16:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778342631; cv=pass; b=XD/7e7xdOqmfNZBIqPwhcZz1gMD01mr39sok8pkurxznoG1fDP/3xevRrtiDc19s1/0aUdLlK/BVvzNPz5WIkhMAT5nJTOIy/k7v6oMPfWUvwy1ReF3F/jWcpVjUsZ/5gjqeNPEsSxdp8JdPU+Q/5WQUr2Nm6GpbwYkkpwzbQMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778342631; c=relaxed/simple;
	bh=iPJMXqE2O0sd8/kDN9rNPmOaJ7I5ZX8eviKqhywp4kE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SO7IQCDzm3UkCJWNQRdzEGryCpL/g1qJl/Fzn2fpBQ/FYB/pPtFTKHYLFBJaHZPF3lvdarKcor0U0UEcaKTNjxVcNSAzN4vvj2ncDEde8NuwLN2qqUEuoEBYzQJywm3Rll/8GDWg7jtEMN8PSPVykm8xH2KpdIDSGbV69U7jums=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=prU6w0rv; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="prU6w0rv"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6967080e6c0so1768658eaf.2
        for <linux-cifs@vger.kernel.org>; Sat, 09 May 2026 09:03:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778342627; cv=none;
        d=google.com; s=arc-20240605;
        b=SuQeR6ZvC4nQ4N+ZN8gCBYO7bic+lSFbvu8AIfSyY1wTvkgwWzEsmuTz4SvygVfHx7
         aLmN9xlUcgaUYi7kB5FPW2wJ+UAKyRkgJAe1T7z4ozRHqaKe/jYPW0IhqG4UogEK8fv0
         FpEja9OD5VnkvjcfqW9rQYToSXnNY6PvORMNr6VXp5NkobYB5MUKh21UtGAHiBz8MHlj
         QU+Y3i6YT3kQ48pqSvj62Uzqyk/gSJcqHusS+hu5YFWNR5h4VRFaYbz9lvOMGnKvUV5/
         zGnKLCYyZMw2qCZ1ZlhLPpHT4xN1US8H635q3SNDHY2QVbl7CmtoDL6yhNrqXwo4pF7X
         mv/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=VmKm0gCGiYfBbSugurE6fggWrUrtZ3asf13CCkMmOlY=;
        fh=4pZOygrxjUMSWMqRiZ7YhJnexf31YCNZaShWtwPX3Q8=;
        b=ToULATBQvfRLI10dh/xSP1wsS/oDutdEv9QP9K3l8NvXE/Fi5FN8j2FcLvmawkoqjf
         XCc1IfHDoTdJ/pQaNh2sQeOHyNHSAfuNgkfmZejY4yWbtiISs3SganPrMJ7j8Qs8DGOY
         9NYB5LeLNV6nksTqsNGmFG4FidcD8E0n/v8M3Du8Jl/t1JDOljsd66TywREl9mCYRSdU
         NwuZHYeBDmc5gW6jPaxuo0qPOSi00QvJB5gzlIMbjsqc/zW2RQVkMCRf7QyWWdurUHZf
         aufla2U0AjP6JSGq60gBkv/pxZ+o6m0VgwUpzNhQ++oz+21hYzJu7kaYLXM3GtppaFWW
         Nl1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778342627; x=1778947427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VmKm0gCGiYfBbSugurE6fggWrUrtZ3asf13CCkMmOlY=;
        b=prU6w0rvA2r/LCEFQMqNl7OWYa0+Nrl+/9zvSuFeptMIBedhqVhvnfrihPTiByggeu
         6HTAG1m+TeDAVkfGLbn5J9hwQnQvOJ7NkHiopWzQOadx9TVCZ6L0RRFXDzwqTrBOtVDm
         oxdCWUnsOJj5FHYF4wQFjtNIFnwhTb3QPH0RRzQRpjBs52kf+UrJ9wCn4NUnOrbawRAS
         TYlfBrdjI25wl5iqvUH083nMzAsrx3pREXuAmnfUJ+i57USWKItc+8q+0w25MuSKvTni
         JnBFTKcmnb55qpdrsJ0dsqrGyFs7cPYgVS5EfCPISIGR5V58xyXAFtJJEQ9e+VXFxQtV
         Sr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778342627; x=1778947427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VmKm0gCGiYfBbSugurE6fggWrUrtZ3asf13CCkMmOlY=;
        b=AtuN1IO9dja8OMLQl5bnCQkkEgimeBBI9a1iGTviEK98UNP2sjDTigpIasuqnIoPcV
         4JmiO/DcDzpfdkX8ZunR6cdAycFkk7JwGb7NwVKlM3NKas8LgTV/KahIsy7DBcqOhi1r
         tumgSeZhbFBu6h6/eCfuJJnnQovjJPHJ1FlkCAxLBVNvrCS+XwW8IWkC7IoPDljn57zO
         RAtEgM7g1OEOocws32wkgr6I51jCDBJQyKYtkrRoJz1H9hIMv8bKv0LteHMepDeNgrZ4
         V9MtpwykhoEZi3Or6e96KkS4vl+H8S2ucdeByJ1LauYRncPfU/De/vRyVs59olZL0ogj
         IJKw==
X-Gm-Message-State: AOJu0YxcKXrStFfUJ4xbXS9BllImn56ZQc3PRB2pC6mkWDhb9mA0nftW
	mg5n8fuWZek7EOV7qjYBMJW3FdxhgONKoV4t7UbqGZojgim4EHgRya60/NmuhiBOnt8A3l0azUX
	XvhlyQcvAY1hX2M2Z3arY4gXOg9ne2Xc=
X-Gm-Gg: Acq92OFJvag9OjwF6wsFiOFu0MVHYDhVe54iX5jdrDpQQvxo9qJVF7D/0LACFHBTxmy
	FpKHwklTq1PbExKUoHo0VFsYFhzizRuV2O3Rgr7CsEhlYNuBAzI6o8pye/mICwKlQlHMopvP4ET
	PqH5VOYI0i3BxuhFCvCueZeLAYnEMj3cUIB2QXzZpS0IzLLC05/6+jutGAi/yJmCgMuix1h2TYK
	jAI8HDOjs49vgscNTM4lCR1XC2DEUf+vidi4HzTmbQlJfYMVxaVauw6lCVEJu7LAOZXCRKJR14B
	J3g4B0EaECRiPnMw3S+M2UUWf/+B7uyRN9R4kdzQAUKlUO1l29tpJez0yqekfAQASNOqYua3cLe
	nn1bEOnWubuuNlTOaMT1nBWTYM2jOBON9ateY5+MB9Wf3rH9xMIFBf/0Elp8OjoykReanLrN2O2
	ISTmG7G/GXSWFQXM13L1E5UXHNJvzRU9E=
X-Received: by 2002:a05:6820:1c86:b0:696:2674:8a18 with SMTP id
 006d021491bc7-69998d0dbd8mr9226223eaf.35.1778342627136; Sat, 09 May 2026
 09:03:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 9 May 2026 11:03:35 -0500
X-Gm-Features: AVHnY4JM6yNWGNWwKZpV8w4xCZeGyj9wWq7uMsMiGuQ7eJrOYudIsfzvi-Zco7Q
Message-ID: <CAH2r5msznQbtjUWfS7_s6Xd4R23LispAFSJQtFAGg5s3THc=UQ@mail.gmail.com>
Subject: problem starting ksmbd
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed that ksmbd.mountd was failing on one of my laptops (running
current Ubuntu, and current mainline kernel) and the reason was a
missing directory /usr/local/var/run.  Manually creating that
directory fixed the problem, but was wondering what is responsible for
creating that directory and why it wasn't automatically created (e.g.
with "make install").

2026-05-09T10:59:04.054852-05:00 smfrench-ThinkPad-P16s-Gen-2 ksmbd:
[ksmbd.mountd/40000]: ERROR: Failed to create file
=E2=80=9C/usr/local/var/run/ksmbd.lock.PNL2O3=E2=80=9D: No such file or dir=
ectory


--=20
Thanks,

Steve
