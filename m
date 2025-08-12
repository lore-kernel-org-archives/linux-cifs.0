Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76292CA8
	for <linux-cifs@vger.kernel.org>; Tue, 12 Aug 2025 01:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962441; cv=none; b=hkRxwX6CrgUbB/baHY3lVSxx3LM0Dvz/Fs2L7EHXV8OPYGbXwVhwplX3mF8gFHQkFBNSnMIO/sVlw0i1Z5UjQh3qUvcdn2XGk764GXej35SBxM6tKXZJmckFa3xZ9+RMaSzeK49yVzkulPVN3V5vnj6/Y2KTxIKwheygLMrfXXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962441; c=relaxed/simple;
	bh=8EtIZ6FEyuvxi2R7D+9HOVsOL2F1UDEdrzp7//HxEqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VNLE7GPi0fits4y2/Al0mukfKg1/cJbwar7UntjJS9VQT8Mmq4TRoc7wXj0PMJT8diTFaQVWn5zbNFOO60K1WH7f1T4yVoj8Dhy5rtgK7l/wL7vYT0a7P1LB1tSXlypyl1nXZWBEbRh2ijiWXSpEsVEGrgpabcmezXZQIoNpTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV3yqPrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV3yqPrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45865C4CEF5
	for <linux-cifs@vger.kernel.org>; Tue, 12 Aug 2025 01:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754962441;
	bh=8EtIZ6FEyuvxi2R7D+9HOVsOL2F1UDEdrzp7//HxEqs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hV3yqPrD8D+lAsxZFM8GMLH3a4FlPSSpdh2SrlaG+3HHJhYU/TUyGqRYbZ/aGYN3q
	 HsF+aCSvnStIVEgZ3ZmgFM1QJh1sciWwBsDkJ9dJFc2vuW5v7taGeRJB+M+ct6RPd2
	 dDELjs1iYooHxznNyUelzlQ5QvS3RgtLrTZYM+drrHOsEYmU7FFkEFGweBOLos7DLD
	 Tp09uaoG49Xb9W72O2q5WOOmvICHh9UsLMZAAdMTSEtQ+6pD0NnjyeWgHS9RrhLo/f
	 zwLMCotoeCU7eqUsrHhloGyIKr1iVnx6q6m+qMuIw4ZN9BdpQrMiL6YG3TfUdvI4tS
	 FiEhWqxBG1TBA==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-af9180a11bcso960332566b.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 18:34:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWDV3FDSwuyzkeJs6R0T84HnvGfOrnf1FbLvLOlI1RLUZv5oi0t7xFD9RhSh8s9JgGUk1mA6lMpWpUc@vger.kernel.org
X-Gm-Message-State: AOJu0YxBGaEZHtzmlctH49oc7FLa4ryGptCvROrULnkY1QL39ASJNPi5
	f59JQbtLHDXJukS0dKsldQdnpNrXQ17pTHL/p3wgpXkrEIr3jet5/A6JX8LmJ1A07ola+y7qRov
	/y2nQkGjdT1N2c1oeg2DWcRD3VVVcxZY=
X-Google-Smtp-Source: AGHT+IF1+XKoYDCZ9KuhbPTibRtzIc/dMbhIJT8cH8IkQsyCO08/38UMwhR71kPg7UwWXhp/ZeSmFoDsBjr6to4FNCg=
X-Received: by 2002:a17:907:1b0e:b0:ae3:6038:ad60 with SMTP id
 a640c23a62f3a-afa1d6173ecmr144131466b.1.1754962439833; Mon, 11 Aug 2025
 18:33:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
 <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org> <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
 <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de> <f9401718e2be2ab22058b45a6817db912784ef61.camel@rx2.rx-server.de>
In-Reply-To: <f9401718e2be2ab22058b45a6817db912784ef61.camel@rx2.rx-server.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 12 Aug 2025 10:33:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-niMc+73jbw8V80S3OdntUpDVij=yd_krnqcAM1e=TbA@mail.gmail.com>
X-Gm-Features: Ac12FXwaum8yW6_NBTGNqNQiHd1A1uK3HBlOx9-WKiu1CTcEp3-_u8iI6LK-V38
Message-ID: <CAKYAXd-niMc+73jbw8V80S3OdntUpDVij=yd_krnqcAM1e=TbA@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Philipp Kerling <pkerling@casix.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	=?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 2:32=E2=80=AFAM Philipp Kerling <pkerling@casix.org=
> wrote:
>
> Hi,
Hi Philipp,
>
> 2025-05-27 (=E7=81=AB) =E3=81=AE 11:57 +0900 =E3=81=AB Namjae Jeon =E3=81=
=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> > On Mon, May 26, 2025 at 11:24=E2=80=AFPM Namjae Jeon <linkinjeon@kernel=
.org>
> > wrote:
> > >
> > > On Mon, May 26, 2025 at 9:39=E2=80=AFPM Ralph Boehme <slow@samba.org>
> > > wrote:
> > > >
> > > > On 5/26/25 1:37 PM, Namjae Jeon wrote:
> > > > > On Mon, May 26, 2025 at 7:45=E2=80=AFAM Steve French
> > > > > <smfrench@gmail.com> wrote:
> > > > > > If the POSIX/Linux context is included in the SMB3.1.1 open
> > > > > > then we
> > > > > > mounted with ("linux" or "posix")
> > > > > Such a context could be created in smb2_create context like
> > > > > apple context(AAPL).
> > > > > However, I wonder if there is any plan to add it to SMB3.1.1
> > > > > posix
> > > > > extension specification.
> > > > It's been part of the spec since the beginning. You can find it
> > > > here:
> > > Right, I found it.
> > > Thanks for your reply.
> > > >
> > > > https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> > > >
> > > > POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT
> > Philipp,
> >
> > Can you confirm if your issue is fixed with the attached patch ?
> after some more testing, I've found out that there is still (at least)
> one special character causing problems. It is the ':' (colon), because
> it is used to distinguish alternate data streams on NTFS, but is a
> perfectly valid path character in POSIX as well. I have attached a
> draft patch on top of the current master that fixes the problem on my
> end. It does mean that alternate data streams cannot be accessed when a
> posix create context is specified though. Anyway, I guess you can't
> really have it both ways given the current specification. If you think
> this is a valid approach, I can submit as a proper patch.
Okay, Looks ok.
Could you submit this patch to the list after filling the patch description=
 ?

Thanks.
>
>
> Before (being on the client in an smb3-mounted directory with -o
> unix,posixpaths):
>
> [philipp@atami smbmnt]$ echo 'hello' > 'a:b'
> bash: a:b: No such file or directory
> [philipp@atami smbmnt]$ echo 'hello' > 'a'
> [philipp@atami smbmnt]$ cat a
> hello
> [philipp@atami smbmnt]$ mv a 'a:b'
> mv: cannot move 'a' to 'a:b': Device or resource busy
> [philipp@atami smbmnt]$ mkdir 'f:g'
> mkdir: cannot create directory 'f:g': No such file or directory
> [philipp@atami smbmnt]$ ls -l | grep 'test'
> drwxr-xr-x?   2 root root        23 Aug 11 19:10 test:dir
> [philipp@atami smbmnt]$ ls -l 'test:dir'
> ls: cannot access 'test:dir': No such file or directory
> [philipp@atami smbmnt]$
>
> After:
>
> [philipp@atami smbmnt]$ echo 'hello' > 'a:b'
> [philipp@atami smbmnt]$ cat 'a:b'
> hello
> [philipp@atami smbmnt]$ echo 'hello' > 'a'
> [philipp@atami smbmnt]$ cat 'a'
> hello
> [philipp@atami smbmnt]$ mv a 'a:b'
> [philipp@atami smbmnt]$ mkdir 'f:g'
> [philipp@atami smbmnt]$ ls -l | grep 'test'
> drwxr-xr-x   2 root root        23 Aug 11 19:10 test:dir
> [philipp@atami smbmnt]$ ls -l 'test:dir'
> total 0
> -rw-r--r-- 1 root root 0 Aug 11 19:10 a
> [philipp@atami smbmnt]$
>
>
> Best regards,
> Philipp
>
