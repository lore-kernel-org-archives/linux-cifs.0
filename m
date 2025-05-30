Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F254652
	for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 22:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748644158; cv=none; b=FEn/8lakxMkSAdieY7FhQqVuZ7eVol5fgucEE35Hfp5vP1RbtXD01JlnC3aQBYgsPDrl80UiDPyveZKuHv87Ox/uNdpCs0jPs73S1yVAoq3f4+y2G/O0DumAi5ii/7aMQUiL0i2a9coDls5FG8648odijovF/pXfhBvMdterUoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748644158; c=relaxed/simple;
	bh=aYrAz1A+HHeen4hKf9OBy9NdxZ9wDeOfzlo6epG//g8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K08ZRsEDT23QAoG2A9PdVl81HgmYBnsQDMn3ejc+wp2YKj+a2D/dN4CgK3KdkohL0pKiDkOCfDzSx3hsgpNmEX3SHROPfbPvlsaiFCNv7CR667YUesKjpbcBM/vzRyjcfSlSXKrT6f6oBTEbZCXfrZBUB+LCu1CMXME4fOKnq0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7YJ2P5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7YJ2P5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD7DC4CEEA
	for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 22:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748644157;
	bh=aYrAz1A+HHeen4hKf9OBy9NdxZ9wDeOfzlo6epG//g8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E7YJ2P5f6zkGacD1EuwbFFWb2iLrCTH6t4xYz0MCGwYzKSvKqsYBFGbeetKu3Q9wI
	 fz/sctOZK8izojhBgM0ne+jOyRaGqfg5DkMcy/xXxBf2ZIlN4Lrw7QuYk1SJ5WHn0D
	 ESvNLn52gpVvHdfKEt8x1W8/m9PMlM0HbONcbHxLFzhKcnhlKR84mGCh/cdSHi2Id0
	 33w1hVcWQgi9Acle4L4rFz2d1mDxy4JUpyu4CRlhAx73zC60fE1svs9icMRqJ2cp2y
	 w9ro0sujJZ5cf/wt5picdxSEvWOk5tusv/ZYexkiDOZrTHiobIXK03kiplOWYZKx8D
	 BnMy5Afe+8oOQ==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-601f278369bso5025067a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 15:29:17 -0700 (PDT)
X-Gm-Message-State: AOJu0YxS/y7v5S1ZfXZrRD27D7mVVbY/baEkGtwK2uipkrNqEYSsF/QY
	ELTjBtcjYnGRtbpMZwGZzo1IayxKTU+lAbq8aJ+e+siGE+d61SJg2E79u1xP9tN1LmUKE4mWAKM
	uC0h2bAuUOj8ku5du/HaIZmyiPkPZwic=
X-Google-Smtp-Source: AGHT+IEq2kuUc5h63qtNYhbKdqCcQBoilIbCV8vV5aH4VJi8jFhqUey6HD0o9XnWyJUPTiR6PmL606dnntfdDypPpK0=
X-Received: by 2002:a17:907:9285:b0:ad8:9257:5735 with SMTP id
 a640c23a62f3a-adb32264a13mr486222366b.3.1748644156367; Fri, 30 May 2025
 15:29:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748446473.git.metze@samba.org> <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
 <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com> <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org>
In-Reply-To: <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 31 May 2025 07:29:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd86mLGAaAEUFcp1Vv+6p2O3MSJcwoor8MmjEypUo+Ofrg@mail.gmail.com>
X-Gm-Features: AX0GCFshD-6nROV9r-RLT4OWJmza-sC10zJAD3TFU7xXLqNjxGp03nFNb2u5Omo
Message-ID: <CAKYAXd86mLGAaAEUFcp1Vv+6p2O3MSJcwoor8MmjEypUo+Ofrg@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2025 at 4:03=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 29.05.25 um 01:28 schrieb Namjae Jeon:
> > On Thu, May 29, 2025 at 1:02=E2=80=AFAM Stefan Metzmacher <metze@samba.=
org> wrote:
> >>
> >> This is just a start moving into a common smbdirect layer.
> >>
> >> It will be used in the next commits...
> >>
> >> Cc: Steve French <smfrench@gmail.com>
> >> Cc: Tom Talpey <tom@talpey.com>
> >> Cc: Long Li <longli@microsoft.com>
> >> Cc: Namjae Jeon <linkinjeon@kernel.org>
> >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> >> Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
> >> Cc: linux-cifs@vger.kernel.org
> >> Cc: samba-technical@lists.samba.org
> >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> >> ---
> >>   fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++++++++++++=
++
> >>   1 file changed, 55 insertions(+)
> >>   create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
> >>
> >> diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/common/s=
mbdirect/smbdirect_pdu.h
> >> new file mode 100644
> >> index 000000000000..ae9fdb05ce23
> >> --- /dev/null
> >> +++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
> >> @@ -0,0 +1,55 @@
> >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >> +/*
> >> + *   Copyright (c) 2017 Stefan Metzmacher
> > Isn't it 2025? It looks like a typo.
>
> I took it from here:
> https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dblob;f=3Dsmbdire=
ct_private.h;hb=3D284ad8ea768c06e3cc70d6f2754929a6abbd2719
>
> > And why do you split the existing one into multiple header
> > files(smbdirect_pdu.h, smbdirect_socket.h, smbdirect.h)?
>
> In the end smbdirect.h will be the only header used outside
> of fs/smb/common/smbdirect, it will be the public api, to be used
> by the smb layer.
>
> smbdirect_pdu.h holds protocol definitions, while smbdirect_socket.h
> will be some kind of internal header that holds structures shared between=
 multiple .c files.
>
> But we'll see I think this is a start in the correct direction.
When will you send the patches for multiple .c files?
I'm not sure if this is the right direction when I check only this patch-se=
t.
I don't prefer to change the headers like this in advance without a body.
When you're ready, how about sending the patches including the body all at =
once?
>
> I try to focus on doing tiny steps avoiding doing to much at the same tim=
e
> or even try to avoid thinking about the next step already...
>
> metze
