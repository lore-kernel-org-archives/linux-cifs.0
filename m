Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0672DCBF7
	for <linux-cifs@vger.kernel.org>; Sun, 25 May 2025 08:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748161158; cv=none; b=bXGQk1cMYsZlt1eIocOvh2K6gvIH3TQkpqq4bosvJcJ2ttuCp38/L4o20CrjU2miibHGySjhHQwKRe/HNWvzc6vICOOBYWqJUeszUm67WRsxGw5grhQp3TMTy6qWWxucEGtYe/w93W4MgdKFAGzWvHbO7bTP2agVCZug4S4ETdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748161158; c=relaxed/simple;
	bh=jg9sgMJ8Xvd53SyA38noj697ggyXIyJ1t4i5Kv0FJ1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UY3h7aEc4uqfSPqLv0U/vmJj01ZcJLVO1aGQbGBBA8fJ5R7ZZhnoTwlrZf3OsuJEb/4XISk/BSuXY5GMIoW3QFy7dtL0SvBnyGBa3BQ7sm5a4m/Yl6V/Lqa5os9FXxLtadPuWLEYpD2nU59832eWMFGEecHQt2XufEqerUddZpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mt5h8TU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mt5h8TU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDCAC4CEEA
	for <linux-cifs@vger.kernel.org>; Sun, 25 May 2025 08:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748161157;
	bh=jg9sgMJ8Xvd53SyA38noj697ggyXIyJ1t4i5Kv0FJ1c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Mt5h8TU3g2ehYh/DkgUZQ3Uygvp5wfWfq5JJM/+KhnzK2awtvNu3BPxSS/oN1DLw9
	 GzttxXBAVUTcez6rJbLBlM+MKV0S5ohRbC2RHcncgEsGZE91uGaIsrxFccjuZyiOOj
	 vkjmQxMARdA6ntENXXGDJZBHVDgItIRC5dv8FGmUgT/qQaQX9XEcRqD164J4zmNxb/
	 4+lo9ONIzMnCHYNY0B1vOt1M09VJbuTzwLky3eIUgQDyIUqTyao2HcRuRlD4SNWAEd
	 g46gsS2okUK7+eZFdmlfB43yH8LmcBgJKANYLGUb4T5Yh9Prgi5JAo1WTjTUKe7YkJ
	 pwa9v9GfnKKYw==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-603fdd728ccso1324834a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 25 May 2025 01:19:17 -0700 (PDT)
X-Gm-Message-State: AOJu0YwSBJOU6ilaYYwz7IPojus3wbZeao9ph1o89rmRmgfSSPMtfDt0
	/In14hnXowmlO0WmCzXbl0Pfcf9qeUIFxUmBKzi5AY7jfXnrTnRxmAB9KbjdzDolFwW7IxVVxh/
	zkhX1pZQGN2y1D9kcj8b+Ip8iHUC8sL4=
X-Google-Smtp-Source: AGHT+IFiWopBQqcfwPnq/sOwLDNGRur3vSc6kOdNloVntek58saRFM3zoPTJplnTgSoIdKyIbjSalefmueumnf/15Os=
X-Received: by 2002:a17:907:7253:b0:ad4:cfbd:efd0 with SMTP id
 a640c23a62f3a-ad85b1f547dmr465457366b.36.1748161156348; Sun, 25 May 2025
 01:19:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
In-Reply-To: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 25 May 2025 17:19:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
X-Gm-Features: AX0GCFvc_eibFFH8fy5iv6EwaUow0RdS9t5bLL3gt7VVe-8SLbHEcUZ0ZgY-ciM
Message-ID: <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 25, 2025 at 6:57=E2=80=AFAM Philipp Kerling <pkerling@casix.org=
> wrote:
>
> Hi!
>
> I've been reading a lot about the SAMBA 3.1.1 POSIX extensions and had
> (perhaps wrongly?) hoped that they would allow native support for all
> file names valid in POSIX if the server and client agree, so I could
> continue to access my files that contain colons or quotes as I did
> using nfs. I know there are remapping options for the reserved
> characters, but they are very annoying to use if you want to have
> direct access to the files on the server machine as well or want to
> serve a directory that already exists and has "problematic" file names.
>
> I have been playing with this on Linux 6.14.6 with ksmbd as server and
> Linux cifs as client. Unfortunately, I was not able to access any
> file/folder containing, for example, a double quote character ("). From
> what I can tell in the logs, this is due to ksmbd validating the name
> and failing:
>
>    May 24 22:25:15 takaishi kernel: ksmbd: converted name =3D Jazz/SOIL&"=
PIMP" SESSIONS
>    May 24 22:25:15 takaishi kernel: ksmbd: File name validation failed: 0=
x22
>
> This seems to be an explicit and intentional check for various
> characters including ?"<>|* [1]. If not for that check, I could access
> my files just fine (mounting with -o nomapposix of course). I've
> patched it out locally to test and it's working great. Even smbclient
> and gvfs are happy with it. Is this something that would make sense
> (even if only as an option), or are there other restrictions/security
> concerns in the SMB protocol that prevent having the special characters
> be treated as valid?
Files containing special characters are not recognized in Windows.
That's why ksmbd restricts the creation of such files.
However, it seems right to allow it when mounting posix extensions.
So we can probably handle it like the following change.

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3a4bffe97b54..de66eed6afb9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2925,9 +2925,11 @@ int smb2_open(struct ksmbd_work *work)
                                goto err_out2;
                }

-               rc =3D ksmbd_validate_filename(name);
-               if (rc < 0)
-                       goto err_out2;
+               if (tcon->posix_extensions =3D=3D false) {
+                       rc =3D ksmbd_validate_filename(name);
+                       if (rc < 0)
+                               goto err_out2;
+               }

                if (ksmbd_share_veto_filename(share, name)) {
                        rc =3D -ENOENT;

But There is one problem. cifs.ko always sends
SMB2_POSIX_EXTENSIONS_AVAILABLE context
to the server regardless of mount option -o posix.

Steve,
ksmbd assumes that the client is doing smb3.1.1 posix extension mount
if it sends SMB2_POSIX_EXTENSIONS_AVAILABLE context.
If cifs.ko always sends SMB2_POSIX_EXTENSIONS_AVAILABLE context
regardless of -o posix, how does the server know whether posix
extension mount or not?

>
> Best regards
> Philipp
>
> [1] https://elixir.bootlin.com/linux/v6.15-rc7/source/fs/smb/server/misc.=
c#L80-L84
>
