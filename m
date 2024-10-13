Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E261DDEA;
	Sun, 13 Oct 2024 04:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728793318; cv=none; b=HsVwoogp0mq//oEP4czALRtOFOcvgq4xBVWB5C/Oe9uZAzmVh4lE9jKJ3JAu5oWnOxX6NhBU6vM6iU4wDiLjnOv8nihNuIiSLvwi4PWHT7HBJxFZrbocUEcYMvm/cDsFvjRH59iv8zo8TpdLP/3S0cT24b5MXqedOCqb/BmxzHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728793318; c=relaxed/simple;
	bh=bD1eLSIVukcJcwfwsJc2icHacnOl1L4dGQapo9oefJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uFzTLIpQRN4CuX2nb6R5lSUbLkGF8m3ib3dp66+AN0pqQPOi4JzQPnSCDjR/xcR4fihzaQV8TvaftIfNsk28vEHpp/2zE//6Ccg8dtfXqIOXF8poCpWiH4Tzkd/xqzZKckkhldQqPrEOrsL+/ZZRj0oY4iBtJ+ymaIftvGmYshE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VKrtxWJP; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKrtxWJP"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539e3f35268so1396021e87.3;
        Sat, 12 Oct 2024 21:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728793315; x=1729398115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/bRRHZm3GLFkoKbSFP1GJS5S+v+JAWce8/1jXmXB6U=;
        b=VKrtxWJPLyUyHCky+D2h4bJBJAD9tkmtlIhBVPfxzYmRBZ90UaoUysIaOmUURJkDze
         DCZSVcNi1V8M69xXGjPB61fjBKh3ZFBd9bA6lTAjf70A6sCkNNH06NihGZ5zpbFh6w5P
         UxXXG2gseBSU89LEMoQhqzRrVkP8nw1UnOjeY/iBcdZ//iEtMk9+sGGEtg/7A/B6mAGk
         clAmO/ZzDvleij72TLqlZxi3VcX1xw711MlYlDZf/Cu0UZFTW/EyCIkNsFgUn96k/gWp
         aJ4Dhr4uzCOojdUeLf8uZjEIix3YFObaO6HzZMjPZO9nEBT/rC+k9L9pAHnWoVYA5vdh
         ubCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728793315; x=1729398115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/bRRHZm3GLFkoKbSFP1GJS5S+v+JAWce8/1jXmXB6U=;
        b=R+eyTQD1+cJLSJq2TMehfnHy9AipK1bHTdPIsKlvTiP1Si/vBcr+vaKPqoRWUUNM5i
         mb0UBPMXXUknPg1k6cXvsrMyChInYOR9yY13/4TiUPcynKK5EvTsSJtiPo1Ue7fVCfXw
         anGGD9YHegHxCHao+4oRxARaEQ6zTmNy5x5CDfXuP68ZVhf6SMilAvYyvvDFXUrNFm6u
         sXSkJvUO9Z9dJfGCp5BT0f7GzWErFY/1CFLw98ztXeihiZLheFDg7Ecr3Gt7F73aNs6m
         kNZwpRw+7oz8xpaw8E9KJnWy6EIcv0pS2bKKkFLkwkiqdRZhWqfz7hXJLCID0zMzqrbC
         xCTw==
X-Forwarded-Encrypted: i=1; AJvYcCUZqF4/+BzzZN0N1lEOzGcasKa8uE8jtWbef2/lAPRrce/v2E60OgjOHgWquncY5ObnncERrpBoFCVV@vger.kernel.org, AJvYcCXiqO2Xg+80UUQku6mSily9Zp5SFNYTEpVcC97rqiADFKo5AkIkBUoUBr7caOyzSp7Ne6Z0ExSAkrxBZLaG@vger.kernel.org
X-Gm-Message-State: AOJu0YyKEDK5/3x2Pa0lJI2CUape/fGvMU+8QwpGXVGUKTgpSBTIdef7
	3iA2gY2tJjTrqCoEstFL4mhucXWLNgdMsNC/0yQR8h3HQfchi4mXdbqtQUvcNRf4EAycMFatHfU
	Ytzwzkoo8gIGrQmSojQ3aRTA8HDs=
X-Google-Smtp-Source: AGHT+IFddTclpR+HtKSYtUuTNSf8V9VXsH9cRCk406tm3DjOxyH/PfpUNlBe5mwjs4qFejjmjKr0Nt55R70gWpt3b2I=
X-Received: by 2002:a05:6512:23a9:b0:539:9594:b226 with SMTP id
 2adb3069b0e04-539e5620d75mr1401220e87.34.1728793314765; Sat, 12 Oct 2024
 21:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org> <20241005140300.19416-1-pali@kernel.org>
 <20241005140300.19416-6-pali@kernel.org>
In-Reply-To: <20241005140300.19416-6-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 12 Oct 2024 23:21:43 -0500
Message-ID: <CAH2r5mswCDw+rk-f5Tcd1niTz2prPNxbOfwyG_XSL5xRwRsbeg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] cifs: Validate content of native symlink
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This looks like one of the more important of the fixes of this series
- let me know if any thoughts or Reviewed-by/Acked-by on it.  I may
try to send this earlier than the others

Pali,
Let me know if I missed dependencies that this patch depends on

On Sat, Oct 5, 2024 at 9:03=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> Check that path buffer has correct length (it is non-zero and in UNICODE
> mode it has even number of bytes) and check that buffer does not contain
> null character (UTF-16 null codepoint in UNICODE mode or null byte in
> non-unicode mode) because Linux cannot process symlink with null byte.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 0d1cea64ab6e..fb1d16b17f38 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -544,6 +544,25 @@ int smb2_parse_native_symlink(char **target, const c=
har *buf, unsigned int len,
>         int rc;
>         int i;
>
> +       /* Check that length it valid for unicode/non-unicode mode */
> +       if (!len || (unicode && (len % 2))) {
> +               cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
> +               rc =3D -EIO;
> +               goto out;
> +       }
> +
> +       /*
> +        * Check that buffer does not contain UTF-16 null codepoint in un=
icode
> +        * mode or null byte in non-unicode mode because Linux cannot pro=
cess
> +        * symlink with null byte.
> +        */
> +       if ((unicode && UniStrnlen((wchar_t *)buf, len/2) !=3D len/2) ||
> +           (!unicode && strnlen(buf, len) !=3D len)) {
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
