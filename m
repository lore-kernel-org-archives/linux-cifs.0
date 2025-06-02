Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF2115A8
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 02:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748830810; cv=none; b=Sc5Mzb3DacRHrqe1BGJgVXfLD3lWstfMK/eA+dOCS8hELl4oMkYTQtFRu4a/K6ZBfvH40bkoQ2UVKWERjUndWfpUhSieNY1H43Sk/MFiIG0CPXKdTKJFvgbqeOCNsnMB6J8XYKBdadjzCTmEchr7Eg88MWQzwdXI4m0+FvuUi30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748830810; c=relaxed/simple;
	bh=7risdpGz7FAd01z0rm02eT/UBIee2qwgomiUozxpsec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bSdHOWxlTWYoRqGKD5AJcch8heNlCiskIu5O0kr0jgJeYTur258r9JzjiTyW7FAvxl0Sg+vEKPzqXUtOw/Gpfon9BsSWGhgoMfW6QzmzyP5VhMo6YZkYERwueNPA+QkZ+CFJGdQBLF30LvQSpns/mmljnsDT1vEvaBkFVQBKvOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAFW5wI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAFW5wI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F720C4CEF3
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 02:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748830810;
	bh=7risdpGz7FAd01z0rm02eT/UBIee2qwgomiUozxpsec=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dAFW5wI1cZL0qHqO5bLdmDc4DsxYySWfdiLkiYg+UGbYTYWmlVBtcCnKhVCQlA0wi
	 1ooD4Zdr+qmfSNbyl+gB/kjUYm85j4bEAEvnTXrG7vNePIE9bC8sWtXJW9dtA1natx
	 VRe/Z07EdKFqdM2JQTPtigtzNjx7GRE6bVGQoMdojNLm4TpVXykgiTuS1F0PLJhQrr
	 sNAcQMMbrECgQrYzzwSKIgnTOFl9BdSxkXz8QdekjUEJQqUNqGTWqYhfBvfM/wJ0Il
	 WN/VgKWWeyV+OZK8PLwH2W/Ctb/qfK2hgbln1yvlOqJSCjLRXHiSbtUqlD1P+QX9sX
	 xIWMjAobOtxoQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad8a8da2376so621605166b.3
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 19:20:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUmSmejhUasR5LgDhwk8Y62OYqCaCdLot3PI2x5YVNkluWHbUgpoRFxYI0lfg4bRmoD1iwnM84w3HKc@vger.kernel.org
X-Gm-Message-State: AOJu0YymhTP66Ogzjt+74/uT/4EE1a23tDs+NfTa2jdw8qA7EYnzu3YN
	m6q1MlUvpOxAoF9/XuJ/1TYvIINRYohX3Xd0xfFe4o031K1RkgqvpDr5MGicqgy6qxGkyE1gP7m
	Ub9bjCgXh83RNSBFEQtzhorz+QzkuQhk=
X-Google-Smtp-Source: AGHT+IHRq1uDEdiPHSPdQUH2Nnj980Ixe/uA4Lo/f7Da1mvZ/2PN3NLTMgQ+SSSZsB2BarXLIlWJsPUD0BvX6GC+/jQ=
X-Received: by 2002:a17:907:7212:b0:ad8:9257:5733 with SMTP id
 a640c23a62f3a-adb493cbf58mr693342066b.20.1748830808831; Sun, 01 Jun 2025
 19:20:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748446473.git.metze@samba.org> <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
 <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com>
 <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org> <CAKYAXd86mLGAaAEUFcp1Vv+6p2O3MSJcwoor8MmjEypUo+Ofrg@mail.gmail.com>
 <CAH2r5mvQbL_R9wrFRHF9_3XwM3e-=2vK=i1uaSCk37-FZmJq9g@mail.gmail.com>
 <CAKYAXd9T81En40i3OigiTAmJabMr8yuCX9E1LT_JfaTmyefTag@mail.gmail.com>
 <CAH2r5mso54sXPcoJWDSU4E--XMH44wFY-cdww6_6yx5CxrFtdg@mail.gmail.com>
 <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com> <CAH2r5mvygcy0-WwZNu6NvjXGrMtB5ZFLK7_w0rc6rVpaVDeBxA@mail.gmail.com>
In-Reply-To: <CAH2r5mvygcy0-WwZNu6NvjXGrMtB5ZFLK7_w0rc6rVpaVDeBxA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 2 Jun 2025 11:19:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-4-WRw9bL-shqELhMO70fyznmeh0HByA=pyOcccu3sgg@mail.gmail.com>
X-Gm-Features: AX0GCFvRSzqkyCX0CC4bt_Ydy_QDFwc9l63WU8_kqYdKU6UKzHw2VQU2oSdGhpw
Message-ID: <CAKYAXd-4-WRw9bL-shqELhMO70fyznmeh0HByA=pyOcccu3sgg@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Steve French <smfrench@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 2, 2025 at 10:57=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> > Can you explain why he has split it into smbdirect_socket.h?
>
> The three header names seem plausible, but would be useful to have
> Metze's clarification/explanation:
> - the "protocol" related header info for smbdirect goes in
> smb/common/smbdirect/smbdirect_pdu.h   (we use similar name smb2pdu.h
> for the smb2/smb3 protocol related wire definitions)
> - smbdirect.h for internal smbdirect structure definitions
> - smbdirect_socket.h for things related to exporting it as a socket
> (since one of the goals is to make smbdirect useable by Samba
> userspace tools)
There is no need to do things in advance that are not yet concrete and
may change later.
He can just put these changes in his own queue and work on them.
I am pointing out why he is trying to put unfinished things in the public q=
ueue.
If You want to apply it, Please do it only on cifs.ko. When it is
properly implemented, I want to apply it to ksmbd.
>
> On Sun, Jun 1, 2025 at 12:00=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.or=
g> wrote:
> >
> > On Sun, Jun 1, 2025 at 12:49=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> > >
> > > Moving to use common headers is something I did multiple times with k=
smbd and cifs.ko already, not a bad first step
> > This is not simply moved to the common header. He splits the header
> > into smaller pieces for some unknown reason.
> > Can you explain why he has split it into smbdirect_socket.h?
> > We doesn't need to do it now if he's thinking of creating a
> > smbdirect_socket.c file later.
> > >
> > > Thanks,
> > >
> > > Steve
> > >
> > > On Sat, May 31, 2025, 7:01=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.=
org> wrote:
> > >>
> > >> On Sun, Jun 1, 2025 at 8:23=E2=80=AFAM Steve French <smfrench@gmail.=
com> wrote:
> > >> >
> > >> > I do like the small, relatively safe steps he is doing these in.
> > >> Small is okay, but I wonder when he will send the rest.
> > >> What if he just separates it like this and doesn't send the rest of
> > >> patches later?
> > >> I've never seen a case where the headers are separated first,
> > >> And send the main if it's implemented later. This is not a personal =
repository.
> > >>
> > >> Thanks.
> > >> >
> > >> > Thanks,
> > >> >
> > >> > Steve
> > >> >
> > >> > On Fri, May 30, 2025, 5:29=E2=80=AFPM Namjae Jeon <linkinjeon@kern=
el.org> wrote:
> > >> >>
> > >> >> On Sat, May 31, 2025 at 4:03=E2=80=AFAM Stefan Metzmacher <metze@=
samba.org> wrote:
> > >> >> >
> > >> >> > Am 29.05.25 um 01:28 schrieb Namjae Jeon:
> > >> >> > > On Thu, May 29, 2025 at 1:02=E2=80=AFAM Stefan Metzmacher <me=
tze@samba.org> wrote:
> > >> >> > >>
> > >> >> > >> This is just a start moving into a common smbdirect layer.
> > >> >> > >>
> > >> >> > >> It will be used in the next commits...
> > >> >> > >>
> > >> >> > >> Cc: Steve French <smfrench@gmail.com>
> > >> >> > >> Cc: Tom Talpey <tom@talpey.com>
> > >> >> > >> Cc: Long Li <longli@microsoft.com>
> > >> >> > >> Cc: Namjae Jeon <linkinjeon@kernel.org>
> > >> >> > >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > >> >> > >> Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
> > >> >> > >> Cc: linux-cifs@vger.kernel.org
> > >> >> > >> Cc: samba-technical@lists.samba.org
> > >> >> > >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> > >> >> > >> ---
> > >> >> > >>   fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++=
++++++++++++
> > >> >> > >>   1 file changed, 55 insertions(+)
> > >> >> > >>   create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
> > >> >> > >>
> > >> >> > >> diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/sm=
b/common/smbdirect/smbdirect_pdu.h
> > >> >> > >> new file mode 100644
> > >> >> > >> index 000000000000..ae9fdb05ce23
> > >> >> > >> --- /dev/null
> > >> >> > >> +++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
> > >> >> > >> @@ -0,0 +1,55 @@
> > >> >> > >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > >> >> > >> +/*
> > >> >> > >> + *   Copyright (c) 2017 Stefan Metzmacher
> > >> >> > > Isn't it 2025? It looks like a typo.
> > >> >> >
> > >> >> > I took it from here:
> > >> >> > https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dblob;f=
=3Dsmbdirect_private.h;hb=3D284ad8ea768c06e3cc70d6f2754929a6abbd2719
> > >> >> >
> > >> >> > > And why do you split the existing one into multiple header
> > >> >> > > files(smbdirect_pdu.h, smbdirect_socket.h, smbdirect.h)?
> > >> >> >
> > >> >> > In the end smbdirect.h will be the only header used outside
> > >> >> > of fs/smb/common/smbdirect, it will be the public api, to be us=
ed
> > >> >> > by the smb layer.
> > >> >> >
> > >> >> > smbdirect_pdu.h holds protocol definitions, while smbdirect_soc=
ket.h
> > >> >> > will be some kind of internal header that holds structures shar=
ed between multiple .c files.
> > >> >> >
> > >> >> > But we'll see I think this is a start in the correct direction.
> > >> >> When will you send the patches for multiple .c files?
> > >> >> I'm not sure if this is the right direction when I check only thi=
s patch-set.
> > >> >> I don't prefer to change the headers like this in advance without=
 a body.
> > >> >> When you're ready, how about sending the patches including the bo=
dy all at once?
> > >> >> >
> > >> >> > I try to focus on doing tiny steps avoiding doing to much at th=
e same time
> > >> >> > or even try to avoid thinking about the next step already...
> > >> >> >
> > >> >> > metze
>
>
>
> --
> Thanks,
>
> Steve
