Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152A2625
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 00:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748736105; cv=none; b=u8CWtQ3a5H9plVcDnFtYJrDXk4iZjiTAV/u/Lb/0Zgdp4UAcsJQqxlwH29h6ABBy/4Lj4Lyp/hSLAwFcUClqvxJFsFgCaKRhpCK39nBPl+rW0xmnxJWxaXm1yXyQtxKhUEEjzn96rQBYeT3PhqybxMpvXMIEwQJIuJVf6KAmsL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748736105; c=relaxed/simple;
	bh=7N9hoi9D9+7rJ9bK4htUXWXyIIc3cgyWmv6TtmoD6/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G6WVC+rqvp1VGKoMEJ9Gb12pAnYrX7nDN8lBUswCCTombkiNLk4GvjOfO3Smo+OwULpfrLoWkkBcgoXg1+85Ayk457FbglLOQX3Z7BeH5yA1IbzzB0W+kVblKz+B8Jbx1b0Xb6O13oVDlqUPOpYDdYFd8rQWh557EVZxCzlzYTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=maxXABHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="maxXABHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6AEC4AF09
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 00:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748736104;
	bh=7N9hoi9D9+7rJ9bK4htUXWXyIIc3cgyWmv6TtmoD6/0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=maxXABHkjCL+y3sJ3DWx9oKA0De4CmpFBZRrIvEqasdmbG42uNNjNDemi9qEQAF77
	 ek/8MQcqJbJ1PmZf1lii5kR5M5E68Bmoh4YK0GDnu1pNADPXo0ZzRdRRMJMTnKrn8D
	 acWwqRMgQAsPKn77NJ3kPsKw01bDs6BVOOafVVKXGdAeXo4RA1EiGHEEZw+raCCz1y
	 pU7g0t1PBa9W3cl8WANwigg5H+PI4omHFStipP6RAf1Tw8/iWjhUkb8OGGJtj7WjV+
	 7cy96cNzeUkCsAzHRiako2oy3WjqCxzICMwAgcMlPrr+ZuErjK95pgN7scwDYpvoWd
	 mQsJypu4nLVBw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ad89333d603so618276866b.2
        for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 17:01:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXiNc1v3Xqof7IvWDvXXHfyJitth3PTb2W4eQgcvsb7l03X0+NKQYne8rdq8v2KCB3KyrB9efYOq9/g@vger.kernel.org
X-Gm-Message-State: AOJu0YzOMEUcQgfbrsuYTXxUfdj151/9ifu3sjsFZjU8WT87sX9VDxNy
	nO0UDiN93sTrNlQ+U7ejTaXi+JLDtoxC89utR5FGz3NuoVIvgsjeKX7zShJV7mbOiFNkKXn61BM
	G83YaSOB8xPQGeiuSSfIZGPuDJYrFefc=
X-Google-Smtp-Source: AGHT+IGUks0gx7vn1CETHtFOfTjkJNMoEW3DezYuieuHwvWpsEO/KUWQ9n0Wo/kp0uItyAD5/Im8jvwbqNmQL440mEE=
X-Received: by 2002:a17:907:d90:b0:ad5:3055:a025 with SMTP id
 a640c23a62f3a-adb32248ccemr808741866b.6.1748736103035; Sat, 31 May 2025
 17:01:43 -0700 (PDT)
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
In-Reply-To: <CAH2r5mvQbL_R9wrFRHF9_3XwM3e-=2vK=i1uaSCk37-FZmJq9g@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 1 Jun 2025 09:01:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9T81En40i3OigiTAmJabMr8yuCX9E1LT_JfaTmyefTag@mail.gmail.com>
X-Gm-Features: AX0GCFvyiO_QsNb12aLyqhWjxv7hr6witTjdvmtGLMm57pqSHq_DJ5HswpiiSWg
Message-ID: <CAKYAXd9T81En40i3OigiTAmJabMr8yuCX9E1LT_JfaTmyefTag@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Steve French <smfrench@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 1, 2025 at 8:23=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> I do like the small, relatively safe steps he is doing these in.
Small is okay, but I wonder when he will send the rest.
What if he just separates it like this and doesn't send the rest of
patches later?
I've never seen a case where the headers are separated first,
And send the main if it's implemented later. This is not a personal reposit=
ory.

Thanks.
>
> Thanks,
>
> Steve
>
> On Fri, May 30, 2025, 5:29=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>>
>> On Sat, May 31, 2025 at 4:03=E2=80=AFAM Stefan Metzmacher <metze@samba.o=
rg> wrote:
>> >
>> > Am 29.05.25 um 01:28 schrieb Namjae Jeon:
>> > > On Thu, May 29, 2025 at 1:02=E2=80=AFAM Stefan Metzmacher <metze@sam=
ba.org> wrote:
>> > >>
>> > >> This is just a start moving into a common smbdirect layer.
>> > >>
>> > >> It will be used in the next commits...
>> > >>
>> > >> Cc: Steve French <smfrench@gmail.com>
>> > >> Cc: Tom Talpey <tom@talpey.com>
>> > >> Cc: Long Li <longli@microsoft.com>
>> > >> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> > >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> > >> Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
>> > >> Cc: linux-cifs@vger.kernel.org
>> > >> Cc: samba-technical@lists.samba.org
>> > >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> > >> ---
>> > >>   fs/smb/common/smbdirect/smbdirect_pdu.h | 55 ++++++++++++++++++++=
+++++
>> > >>   1 file changed, 55 insertions(+)
>> > >>   create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
>> > >>
>> > >> diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/commo=
n/smbdirect/smbdirect_pdu.h
>> > >> new file mode 100644
>> > >> index 000000000000..ae9fdb05ce23
>> > >> --- /dev/null
>> > >> +++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
>> > >> @@ -0,0 +1,55 @@
>> > >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> > >> +/*
>> > >> + *   Copyright (c) 2017 Stefan Metzmacher
>> > > Isn't it 2025? It looks like a typo.
>> >
>> > I took it from here:
>> > https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dblob;f=3Dsmbd=
irect_private.h;hb=3D284ad8ea768c06e3cc70d6f2754929a6abbd2719
>> >
>> > > And why do you split the existing one into multiple header
>> > > files(smbdirect_pdu.h, smbdirect_socket.h, smbdirect.h)?
>> >
>> > In the end smbdirect.h will be the only header used outside
>> > of fs/smb/common/smbdirect, it will be the public api, to be used
>> > by the smb layer.
>> >
>> > smbdirect_pdu.h holds protocol definitions, while smbdirect_socket.h
>> > will be some kind of internal header that holds structures shared betw=
een multiple .c files.
>> >
>> > But we'll see I think this is a start in the correct direction.
>> When will you send the patches for multiple .c files?
>> I'm not sure if this is the right direction when I check only this patch=
-set.
>> I don't prefer to change the headers like this in advance without a body=
.
>> When you're ready, how about sending the patches including the body all =
at once?
>> >
>> > I try to focus on doing tiny steps avoiding doing to much at the same =
time
>> > or even try to avoid thinking about the next step already...
>> >
>> > metze
