Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5732EACF2
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 02:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776394731; cv=pass; b=FNDwlFR88uQn+9LfWdkH0KHfeEk6ieoQNk79VCDVdCxDBjierQvc9npxFAsMlfu+9a+PW450McvptoYuKg+R1sz2Gb+VWpx/MbttNb4JO/n0i3hqU11adRNECSzCbNZKarrCQK9knFolrjvwdaKAi10AZhPAy0or4m3088nXxW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776394731; c=relaxed/simple;
	bh=rR1liQlAztVMGE+LKdTCzP+X3Rl7c7twLoi7YOzzO90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcOpqRiPofx1YeCioR0Plzri2iRxNwYDLAxwCWzDFuSS4Nat1MFNFDgYDbSPeBy/6fY9JqNkTLuFQJ7dKH/asOm0lwAgDkn7f70A2GUNtYuIw0WSWHGSUT45ioFo+mEZkf7e6jHP+tG+bs/jHfBPHh6Ql8eu6q+jeWzaIF12GmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDbNydmJ; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDbNydmJ"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-651d692e833so212030d50.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 19:58:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776394729; cv=none;
        d=google.com; s=arc-20240605;
        b=C46bISo/ZAfr2n5xnlOOuH7GCMeTlMXV7KB/wez786PfY2EJvNSAoMKPbgroAMJEgN
         6fsPQZMnGKUt07vpnd9FL5kx6MtLac5F49G33cXOskvyVUWU5cpiBvOZSUXHSbpqroSo
         66fBkOXTZX4wT+4/9a7k8PdiGgaKOb/SbDoGV2e8tSgULkXwQeRUnnRQQPuhx6kjCfnx
         Cxz+x0GvMdVAgnVqH7/2fIOM/QdfAtvqFFd5mWUM0GE/Uptgx1gEU9f19qDrAPlnqO22
         hj0ZXcrOd3qqA6RFzBw4LHKfLCH8TcJtn3lpPvkuoWJceyuuEwHEAxMhk/Yde2LzEvXz
         RhIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zMky0cVeh2idyOgOmX8kaKwnJVvVHTaqDBxjuS2oOdg=;
        fh=JZlc3zGrcF4XllN+25mf/LNVk/xgPOYRUxBBHEr23HQ=;
        b=Sb/StRrCeNUhjYJ7OzA2W8i+d531y5pxQ9uz6PcoFg+y9KWdvC3f7t5tY5o5kXD1T3
         /jegm+70Hx63tUP5Ron8XbPcZxISd//kMuz+73Iqgn8t19CgIPpPmXUOxhxaoC+2xTio
         41XIdt75QFIp8SW4Dyi1LOJEzwGpFe0/+U1+D0vnpbaYI0juyMecGG3YE4c5XlPCEyrs
         eClwDtQ73FW9a6EX6Kg8dOiyGboL7CYMzGVy7/rsabzvjZdKvyRKPoSkWtKTGxj7Qe95
         8eki6Bo+HdT2CPMAVBfUZ0hfVyKHuVx3QTVbAOfS+Rm3tMjmZdtMyHrjQvWZy+zASV0S
         k1vA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776394729; x=1776999529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMky0cVeh2idyOgOmX8kaKwnJVvVHTaqDBxjuS2oOdg=;
        b=lDbNydmJsIBdhQ/ZKHbwlkhnkvCaSpOEfmFZ97Y2Emh4OZQdmHRjDWjWdN4FDmKEQG
         6HmG0hUrBYVtTjIIOh/05/ozo0I/y2PKngOjQ5L6d1viyflOKr7z8L8bu0ETdXBGqPlM
         yUoSItgqIVSvi6DVt307nDZ5VYPwr2CnsvNOmiqx50vUjDrad+CDUIzVmTBPINfHeotp
         ArhwFBK4e8/hAJdUkeMpOcahNypIar8xE6324GJ9yrXxu/8MlqLlHMQvJAnY/W5BCKzV
         4FTaKObGvRF33TfMyzNcfz6N7UrAboTZ8Kwk5tB1JrXMNzB8eDoYMbV296zAxYTEt+4h
         FnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776394729; x=1776999529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zMky0cVeh2idyOgOmX8kaKwnJVvVHTaqDBxjuS2oOdg=;
        b=UCl+3VD1kNukYh0YzGsH613FBDfPD/u+2+RH7kQREWl5+m4mtQiq1XeUti06btviHU
         wKEC/C4wfhj8d+gyS+q7UMTKUtu5iwADUbNLB2/obabzvZd8OSqv4nZknbHf4ms/Mn5q
         feGw4f1mIdeYCtblH3YH6uj6cG5US0GiaM3fFe/Z0sKeZM0Kaenz4rUHXcDDWrirIcgy
         jZ5LdR+8Ak2bgjjfTb7UmhPjEcPhbdeXXQSImyv4nOfiJuLf2nilMITvSwSNqBATwSw+
         VKIdVSBMKtpfSgq7kVroPlFwI41X54suPKCz8okh3PbMWkH54gsZ+3yQi7qycDoXEzEn
         a73Q==
X-Forwarded-Encrypted: i=1; AFNElJ9DM+pxbo0JuylZMrYlJDt7Xyvql2VBKPxy4jcvIvRlgXP0xMjWwsTrulUM/1v4O6BMKHpk9yUvgjD+@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq2o7vv5AM8NDHcYhuYWLUAa/YPxQyeGgf3TLVSFATqsBCaJv1
	6dVJyO1R19+ikO76eZ2+uh0Ph5lW5H4D2gz0j4l4F+Kz2ziDfdAwFHATxa29QesPNNkRHeqpzw0
	rmQCAs1CEwzgLrLxdspm+tJX9XjtPZoI=
X-Gm-Gg: AeBDieuNPX740kgfNyeVaaIfZSZD9k2Me9GX/asMRgv4MvBVzgEYFGJNWBAVYpgpnJo
	83jJxBoytuWaW6CRBiGHVMkfhLWMEspUJr8aiWs1XB26q8UG1GrC7tlM3mKdB1nioIPyZ46ivS3
	5tJywtNAydVeViaf/JyZAOx5jSvJPqiqkdbNUb68ReB/7+bgchxXYFK8C3uyzZAmeJbFdEfOnje
	c3mqusAQuzZoRUwunDd9Nv1AtBibJiACpnbaznahALZw6gbYfAEMqGTKDM3cTIlD7RgTwWxAAey
	JQLew4CEgFj6jpANlWAEXO4r//xFZe2940poQBwym0DXpYo=
X-Received: by 2002:a05:690e:13c9:b0:650:5316:175b with SMTP id
 956f58d0204a3-65310b028f7mr1140874d50.52.1776394729349; Thu, 16 Apr 2026
 19:58:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416200439.2987930-1-michael.bommarito@gmail.com> <CAKYAXd94w_Mi0gzAKrHiMnV2LsVk-Rzo6JcGtXNbEJZG4xXF4Q@mail.gmail.com>
In-Reply-To: <CAKYAXd94w_Mi0gzAKrHiMnV2LsVk-Rzo6JcGtXNbEJZG4xXF4Q@mail.gmail.com>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Thu, 16 Apr 2026 22:58:38 -0400
X-Gm-Features: AQROBzAQfRoNPv_BCLl4UjKUpp-kGov1M25b6YcO0KYyM5811sPTveZqffffwHg
Message-ID: <CAJJ9bXzRpb0-B8LwUNc_yx4ADt2CEzH_wSbtQ5CZP6K+YKS7rw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 10:47=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org=
> wrote:
> There is no kcifs3_test_inherit_dacl_old function in ksmbd. How did
> you reproduce the problem?

Sorry for the confusing splat.  I pulled the pre-fix ACE-walk loop
from smb_inherit_dacl()  to simplify the setup in a test module and
re-used names from another harness.  _old keeps the original weak
offset guard, _new uses the tightened size, and the patched version
survives.  If you want, I can run through a full repro with qemu
tomorrow using the real paths.
