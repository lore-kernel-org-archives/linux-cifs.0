Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9D6BFCA;
	Sun, 29 Sep 2024 21:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727646545; cv=none; b=ed1ufGc0SqWeFOxC4QMLDD8XS2Fn5tWNbIsNX6unP/Fj9RNOnXSzYDWhPrs7HJNbW6YUAG2AzrSqnzUqh7+WI5oLQnp6cS9hAmtTWI2ggJcYDc9JKCtxpJFAw2kNWAi+q0DLsjp6iOmlHZ+C4RXcYH/Ruiuj3WjuOEiS1QZtirg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727646545; c=relaxed/simple;
	bh=0JgCixH5FluXdf88a1/Jhc11DXcFU1GqBKRfOgZZ+UM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qEfQjo16Khc23DUmKpFH1zY2fhR3lFKJiKovO3hc8Z0etbdUjgKinSsKkpSmDtYS5r3F+grumQsHOnjVFqwK4ez7GRmtS4BiwiT7nXZRYNUFpGyEcrtx35VqFO5UG/bwCRrSMqulgdb9jD0vePPhJ3B4GfF6pcE9qxPq/NWrQp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUkSgfRG; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUkSgfRG"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5398ec2f3c3so1000701e87.1;
        Sun, 29 Sep 2024 14:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727646538; x=1728251338; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/TcG7vou9Wf2a+IlytxJnqOqdLIx9ul6bGE+91mWzg=;
        b=gUkSgfRGZ/CkrOfB9jXBwU3iaLKKYRn8hgodo4lSpSgeEvHi0CnOdmCEA2KE30V09o
         0XLzMEbhaJJOoy+dk9Y83kg8USmakbdM5kZ2CH5EPeu4m/er7XwCGZG+622XSR/GEvIq
         AMfv4oFg7arBGDiOMlSCgsVgxkMPAfGU4XMW4ppc1LszXRIOJbAz0gE0TKH8aEywgG9y
         Awk8k2jJuquejmNGMgaPfyqshU+I0YZhh01ejQZh1q2JmGSwJSHVIP/RfDk8gHSgvlba
         TFa74ttK/CEC+GsfLowRQ7nnkLoWwF8x4kvNUZZ6RX6o2F6IP6WPrBHQrVi0vxumOUjt
         OCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727646538; x=1728251338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T/TcG7vou9Wf2a+IlytxJnqOqdLIx9ul6bGE+91mWzg=;
        b=KcekQT9CdHOVd8rIuGm0o32wTsWfc6MB81nY+YcQ4ZcZb0riyZ1DJNEA7Ua0OSiFWK
         Pse/ar1fHrjDwAp93WnJTnvuP/Z3YmUAhV27DoDyZh9tOXqloKrsREKLah61jhlECjX+
         nNs1j/DIbLnRxd94dfgaIHe9SsR8cUB5byxJyJ2+3DRNQlLRQeo0QRD5n0DPIW0qM85Z
         5+ZR8uRQfdzTaDjxwtbfDqToR/sHLXE5jq11IywThFoZYIJzxj5AXSXTPupNJlyUxu7n
         +4x2b5HYfD3gqgM7otn1V2CLeFW1I76V/qTZuqqGtTrwIy780W6vLJ8/eUGj8kyNIEl3
         N1gw==
X-Forwarded-Encrypted: i=1; AJvYcCU3ka51JjT0l8GPpvfcNrjx/ahL/crz6oKvheyNhFbluOyjxCPr9ZT/Jn4C9Vkatnf8YcXgY2dfP7SaKrVN@vger.kernel.org, AJvYcCXlZwevV4Q5LALALVRMf1LhJ4Y++zscVjOtcvbjU2j4JjmLA/9+iwgyIr2lktDrMXm3A7t9rFyBEIvR@vger.kernel.org
X-Gm-Message-State: AOJu0YwmU2LjI8VBfd35QrPObT9AJSxD8THHGaRKe0Z6QOL4fgTd3BYR
	Ng2w5jn4MoPnay1e4KtCst2cVkyyRJQ++dQBjFW+bXTvun60m/Rmd21ySeC9lFSfGnkqNPUOat8
	OZJ7zWWlj/kMi3wlLSYG32JSP8DA=
X-Google-Smtp-Source: AGHT+IFWfXtRLedwqtSsUyNC2MJiY110RGOcZPzSjZy37ZJ9ReiCTZoOJbSVIGBjvmdrYMjkebxNIvquFdrWENy6y8w=
X-Received: by 2002:a05:6512:b8d:b0:539:8a9a:4e63 with SMTP id
 2adb3069b0e04-5398a9a4f75mr4031639e87.42.1727646537631; Sun, 29 Sep 2024
 14:48:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org> <20240929185053.10554-7-pali@kernel.org>
In-Reply-To: <20240929185053.10554-7-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 16:48:46 -0500
Message-ID: <CAH2r5mtRN04+X-J7C__qHL6S+VzFbWoRGdb=cBDQfDVLGgWwew@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: Validate content of native symlink
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Is there any easy way to create such a symlink (with null in it)?

On Sun, Sep 29, 2024 at 1:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Check that buffer does not contain UTF-16 null codepoint
> because Linux cannot process symlink with null byte.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 5a738f65b190..ca4f96c43508 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -509,6 +509,16 @@ int smb2_parse_native_symlink(char **target, const c=
har *buf, unsigned int len,
>         int rc;
>         int i;
>
> +       /*
> +        * Check that buffer does not contain UTF-16 null codepoint
> +        * because Linux cannot process symlink with null byte.
> +        */
> +       if (unicode && UniStrnlen((wchar_t *)buf, len/2) !=3D len/2) {
> +               cifs_dbg(VFS, "srv returned null byte in native symlink t=
arget location\n");
> +               rc =3D -EIO;
> +               goto out;
> +       }
> +
>         smb_target =3D cifs_strndup_from_utf16(buf, len, unicode, cifs_sb=
->local_nls);
>         if (!smb_target) {
>                 rc =3D -ENOMEM;
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
