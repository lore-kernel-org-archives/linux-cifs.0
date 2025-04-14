Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708882DFA23
	for <linux-cifs@vger.kernel.org>; Mon, 14 Apr 2025 19:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744658179; cv=none; b=bFydFljS/Tg66YODC/BUINZTbCBCLBBESYU7gUzNIGv3F/hiV6jDtWrXeTF6nCrzNoXhDyTQ11DwQ0JYnbT/oZXrMIqpoaa+aAmdBTfdiQ/WVAt2nmuz/Ktx40qDttZBos4TbCgGKk5u7oWVmYbQbcD9SiOGBzQA6HSsttGxolg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744658179; c=relaxed/simple;
	bh=wTy0hufwaKzH8e6rbLpI8eQ1C2L9E/6pu+YXhbo4w6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEdod9lcBHCOUvIH31iUT7D/b1sG4XeMYCm7y+NbD+My6WclHl1fg0g9j4g1BRdy4D2wWQz6Lh7hy6kiWjVNCSNvTciFuz1D9pVbC4MILKIS01PODF0ApuHc/MuB+/Zwh/W5poPHETbZqdRX8GrsKrf9fWp7XZaQVvm5msoer5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=auCdUFQ7; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auCdUFQ7"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54954fa61c9so5807621e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 14 Apr 2025 12:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744658175; x=1745262975; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wTy0hufwaKzH8e6rbLpI8eQ1C2L9E/6pu+YXhbo4w6I=;
        b=auCdUFQ778RCq5a9Nwe50CoYzr7ECzmV+GpdFVutWttA4j9fX/NhOI+4v4Jba9pkC5
         eqJTq+fVfWsaREr0Hk9GBB6Yivy6pNh4bUBG6159LuOgixtHRHDqUDTZVskCpQ9HrkWo
         VORVUpdegaknWsE5OMELrANXr+V4dGDFHfaZr1nGK4BAF/ZN0bxW+Bzr8B1FCrUoMmxz
         wtH8dRlhglQmdMEi/S09MOavtnaQJ0sgqyVFSytO63ckPZPYdVxKSisLF3up1/Vt9M0J
         okGo/Zvzc3EndBCf1JdPlF1MljKViT/mP+K/Z3ezszJs9/iOBXQ1sMNRBD9gwWGSDK/H
         5ecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744658175; x=1745262975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wTy0hufwaKzH8e6rbLpI8eQ1C2L9E/6pu+YXhbo4w6I=;
        b=MO3gZpMR7WpzjAltRlYPkvMBNqE0hCcMK1r5RLsQ5yGHZexv5nh1sNEpUBW2C5QxHY
         1lv+us5E/tWWSiAbpC2kCafw9cgxg2QvYWX7kaCMtQTVIx5OQnh9NNxPVvmJY9NoV3P0
         wPtku1Ei7T3qvQMoLBktBZjiLPuj9cIt/tR03hl+W6VKwwcFlajZadj2m+2NVsx3C0HI
         kKwKM96PVMUpAKvpOsYsdAvXojFZJ9Ehw2DzOoP69KWs31wgjlliOeloYqUwfV5WYMpw
         P1GR6suyiUZVK42123M0Oyki2F2fIZcTxAbRJCKTziNtHGqpe165KSFpXSVUaHgbj3Ge
         gWzQ==
X-Gm-Message-State: AOJu0YzMjMykNnWFwP8T6RWPGxzKCtG+RAk4xOhdH1neMWZrzGtrZdPT
	THkTK0SykMmtMGW0UWl5i29vBAPBexNuSH/KbTE7bp42cWp9J3v3n7KJYdd8i/Ik1pIjjudJoqJ
	t+mnzafDOuvBI0Qe8YjQ+zMrq/C0=
X-Gm-Gg: ASbGnctpXnIm8aYlvH3HEJ+dhxxD1z2S4CuVJ6oFmt3j8TlNmuG3mjiHQJJL0czQLlY
	PWMyr/QjqPfWwyojSRtY8Hsplhzvjkbczjn8zbYPKV5d0D43IPmmDK1G/V1XI3cmmqRzulJ36Xw
	/YLfhPmmm9fIXkASzpIlfIaqXd3bAUofzeARJnNkkYTS+YDMYXH07xHhovauyG8JlA2A==
X-Google-Smtp-Source: AGHT+IFjEWDG1eENnZoy+8gcW96gdUQ7ayMhUYTIjxD8Kde43Cp9n2w5iQJB+LKOKNn9bSjxIAyRlchVZO2LFyoucCk=
X-Received: by 2002:a05:6512:308d:b0:549:4e88:2e6a with SMTP id
 2adb3069b0e04-54d4528bae9mr3195487e87.6.1744658175096; Mon, 14 Apr 2025
 12:16:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org> <bfe46e3d-5c7c-42ec-987d-d70b4f513e85@samba.org>
In-Reply-To: <bfe46e3d-5c7c-42ec-987d-d70b4f513e85@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 14 Apr 2025 14:16:03 -0500
X-Gm-Features: ATxdqUHLvw5QfwYJbQUy5KoEoX5aswH1BLVBqTNzBFdyVXs6uKZosRyPhAXZc3g
Message-ID: <CAH2r5mu+sYcx6rtoq=P_b+0_rSoRsoUCrUrfaAjfOFvswuGtqQ@mail.gmail.com>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Tom Talpey <tom@talpey.com>, 
	"vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>, 
	Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks fine to me

On Mon, Apr 14, 2025 at 2:03=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote=
:
>
> As discussed at SambaXP, what about this?
>
> https://gitlab.com/samba-team/smb3-posix-spec/-/merge_requests/6/diffs
>
> On 4/9/25 8:18 PM, Ralph Boehme via samba-technical wrote:
> > Hi folks,
> >
> > what should be the behavior with SMB3 POSIX when a POSIX client tries t=
o
> > delete a file that has FILE_ATTRIBUTE_READONLY set?
> >
> > The major question that we must answer is, if this we would want to
> > allow for POSIX clients to ignore this in some way: either completely
> > ignore it on POSIX handles or first check if the handle has requested
> > and been granted WRITE_ATTRIBUTES access.
> >
> > Checking WRITE_ATTRIBUTES first means we would correctly honor
> > permissions and the client could have removed FILE_ATTRIBUTE_READONLY
> > anyway to then remove the file.
> >
> > Windows has some new bits FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE to
> > handle this locally (!) and it seems to be doing it without checking
> > WRITE_ATTRIBUTES on the server.
> >
> > <https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-
> > fscc/2e860264-018a-47b3-8555-565a13b35a45>
> >
> > Thoughts?
> >
> > Thanks!
> > -slow
>


--=20
Thanks,

Steve
