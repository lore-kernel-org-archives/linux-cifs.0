Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1333597C
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 05:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748754001; cv=none; b=HKtFBgFUcP+14Yw6y8B9Ey00cDh7sbrtqER23oxWL1hT9wutOqjS9GTAOl35H5nUA0UTOP8hVxv/mDF+5LrFl+VgRkAgvqA9uuF3xO+dSR/RGzgJLzg4JZu7/Ct8Df9CITQw/n7UUdWfZUqYknbRGUOcLGO4EqXqt59jQx70R28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748754001; c=relaxed/simple;
	bh=jziMLCYfG/IxcjddNwH84wkqmhcfMsiuDMt7+e3MGRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B9wT/h13Zxk3lSQq211RKz40B0ILMEDiASF8dqmNZxTN1HpAwc7unDwnbxdA8yCg4KydaQD3h5jyI1n3bO69syAzZmZxOkSfG6mracd8fHsggvxSE3S2OALUFMyGKSoJ00GFzNIzCnKQFbOqMfFb+EwfpNQblLUub1UwvfGfOE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRsTeyzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRsTeyzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938EFC4CEF1
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 05:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748754000;
	bh=jziMLCYfG/IxcjddNwH84wkqmhcfMsiuDMt7+e3MGRs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GRsTeyzmEW7jZnwNXs66UMF2hEa1Us5Gyma6cghcCzlVqE5Zvisy2Bu2kheJiL/9h
	 ECz3ksjUwAMjtlA8b+hH9LCn5GQ0AvMidn9QAWEjd0CA5QZvQJkeWRV5mmw1Sk5LVZ
	 nM+ivpKn6yMf9T7XNrI3+geSrnJ2JwBqOBY1dGcvdLbJMkWlllXy1mzRPyv57O8y4A
	 i+9wZVXluPJ+uISikQEK8GuFVBg/wTUVBd3+oQbQW3CXdMwkFYKYwvFuFbtZt4Ulj7
	 noHQ+wE6XYjQcjFm3x60/nyiZZ/xDfsdPBskZMEgU+na5D5vNtwWY7ag48uDOdHq9d
	 XarndC1YBz8IQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso622469966b.0
        for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 22:00:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXXhKRUT4sy9YXXkr4OZRliw0YFz1wCLTyeWGOHWit2pqg9gGNi546bIcVh+pV9ZSDSEfC6eBfxmzll@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7bAS560JxQrPLGkGWwdI+VgnnuDZO/16vz5+yckVEDYkE0q5K
	/0LIZH0RDKGgMZ4A4raicD1a4UVFWK99PiAdOPSqwf9Ww2CN04IFBPbruE7b/3ur8GeFUrN2PJe
	1L9KqRGvlj36cpPtdNLKd/DbCCdxpr0s=
X-Google-Smtp-Source: AGHT+IHBmixlrV+bNrpHCDSQFAtm1q9Soxc/KdMAbUMA7EMydYsIgj4O4t5zQ+7NS6VwHe0vrZktRis23VMhgWjvN/E=
X-Received: by 2002:a17:906:6a09:b0:ad5:3743:3fa1 with SMTP id
 a640c23a62f3a-adb3244fff4mr663385666b.50.1748753999171; Sat, 31 May 2025
 21:59:59 -0700 (PDT)
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
 <CAKYAXd9T81En40i3OigiTAmJabMr8yuCX9E1LT_JfaTmyefTag@mail.gmail.com> <CAH2r5mso54sXPcoJWDSU4E--XMH44wFY-cdww6_6yx5CxrFtdg@mail.gmail.com>
In-Reply-To: <CAH2r5mso54sXPcoJWDSU4E--XMH44wFY-cdww6_6yx5CxrFtdg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 1 Jun 2025 13:59:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com>
X-Gm-Features: AX0GCFtQ5-YDPzNW5y4CUF3RsinJIjhF4__cD8m27f_Y-FFUjpKHlmIIfl2mie4
Message-ID: <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Steve French <smfrench@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 1, 2025 at 12:49=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Moving to use common headers is something I did multiple times with ksmbd=
 and cifs.ko already, not a bad first step
This is not simply moved to the common header. He splits the header
into smaller pieces for some unknown reason.
Can you explain why he has split it into smbdirect_socket.h?
We doesn't need to do it now if he's thinking of creating a
smbdirect_socket.c file later.
>
> Thanks,
>
> Steve
>
> On Sat, May 31, 2025, 7:01=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>>
>> On Sun, Jun 1, 2025 at 8:23=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
>> >
>> > I do like the small, relatively safe steps he is doing these in.
>> Small is okay, but I wonder when he will send the rest.
>> What if he just separates it like this and doesn't send the rest of
>> patches later?
>> I've never seen a case where the headers are separated first,
>> And send the main if it's implemented later. This is not a personal repo=
sitory.
>>
>> Thanks.
>> >
>> > Thanks,
>> >
>> > Steve
>> >
>> > On Fri, May 30, 2025, 5:29=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.o=
rg> wrote:
>> >>
>> >> On Sat, May 31, 2025 at 4:03=E2=80=AFAM Stefan Metzmacher <metze@samb=
a.org> wrote:
>> >> >
>> >> > Am 29.05.25 um 01:28 schrieb Namjae Jeon:
>> >> > > On Thu, May 29, 2025 at 1:02=E2=80=AFAM Stefan Metzmacher <metze@=
samba.org> wrote:
>> >> > >>
>> >> > >> This is just a start moving into a common smbdirect layer.
>> >> > >>
>> >> > >> It will be used in the next commits...
>> >> > >>
>> >> > >> Cc: Steve French <smfrench@gmail.com>
>> >> > >> Cc: Tom Talpey <tom@talpey.com>
>> >> > >> Cc: Long Li <longli@microsoft.com>
>> >> > >> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> >> > >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> >> > >> Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
>> >> > >> Cc: linux-cifs@vger.kernel.org
>> >> > >> Cc: samba-technical@lists.samba.org
>> >> > >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> >> > >> ---
>> >> > >>   fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++++++=
++++++++
>> >> > >>   1 file changed, 55 insertions(+)
>> >> > >>   create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
>> >> > >>
>> >> > >> diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/co=
mmon/smbdirect/smbdirect_pdu.h
>> >> > >> new file mode 100644
>> >> > >> index 000000000000..ae9fdb05ce23
>> >> > >> --- /dev/null
>> >> > >> +++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
>> >> > >> @@ -0,0 +1,55 @@
>> >> > >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> >> > >> +/*
>> >> > >> + *   Copyright (c) 2017 Stefan Metzmacher
>> >> > > Isn't it 2025? It looks like a typo.
>> >> >
>> >> > I took it from here:
>> >> > https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dblob;f=3Ds=
mbdirect_private.h;hb=3D284ad8ea768c06e3cc70d6f2754929a6abbd2719
>> >> >
>> >> > > And why do you split the existing one into multiple header
>> >> > > files(smbdirect_pdu.h, smbdirect_socket.h, smbdirect.h)?
>> >> >
>> >> > In the end smbdirect.h will be the only header used outside
>> >> > of fs/smb/common/smbdirect, it will be the public api, to be used
>> >> > by the smb layer.
>> >> >
>> >> > smbdirect_pdu.h holds protocol definitions, while smbdirect_socket.=
h
>> >> > will be some kind of internal header that holds structures shared b=
etween multiple .c files.
>> >> >
>> >> > But we'll see I think this is a start in the correct direction.
>> >> When will you send the patches for multiple .c files?
>> >> I'm not sure if this is the right direction when I check only this pa=
tch-set.
>> >> I don't prefer to change the headers like this in advance without a b=
ody.
>> >> When you're ready, how about sending the patches including the body a=
ll at once?
>> >> >
>> >> > I try to focus on doing tiny steps avoiding doing to much at the sa=
me time
>> >> > or even try to avoid thinking about the next step already...
>> >> >
>> >> > metze
