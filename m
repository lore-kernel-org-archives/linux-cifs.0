Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3669E2C3272
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748829421; cv=none; b=UFs46h8hD3QPqHGzPGGiAKvaKFRxddeNm4q9Sc64+A7+dycHcxRpuoKJRkOTn21VvvmO5fzqA3TiAx16ep73vb9hfLYC5HXiE6VWEmdBvW1qNkb2GMYZa84dzNorTzUY1ELLHcIjmEw2ONUPA27a4zT/Bjr+n4vcd7Rcchjt6Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748829421; c=relaxed/simple;
	bh=1J6E88rvPYFAL2ImewEdS2w0ABBmVlF5stHiyz0f+QU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WEgj3SoPbq6CgxKDe5I7oNbQn8Cp79QoMlHkAdIdS6Z7Ep1u8kofG4UYmuXjZrix7JVBp+f2ywHxdDemDTOwrxwREcbD95qkMSWchoRY644s/G1M3ORIlh8FU7/hm/g4tweSeGJHxOsEJ/to0Jv27wBgmSY3a2aPZTEjUCVbvQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQvxqe2Y; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQvxqe2Y"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-32a826ad3e0so40354461fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 18:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748829417; x=1749434217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHGTRI4OoccGkRynWoGInJUpFy17mwKB39OxXBmCuH8=;
        b=FQvxqe2YL7RzS3YoGyRNsVWJssSbfqdTBvSVccdFaYwz3lhZmQvck0wnjb3BuoxjTD
         qMmSnnkT/4LmXbzAA61ziVP3ieAr7Sx+6BzXnK+0BIjzYSbvalKBRX7IhnudE6Zxj5Ys
         liKXCgDwvW9FmJYs9qAbYzEWincAnwkClAf72Y8Cd++1JnjbhYd6u3Ixj6Cf993o7N6M
         9PIpdKOL5zIXXAApM//gvq+HuqP98ao0OkPcBB/9Yf/CMI7ccnLPEetEkQpNyhzGQyL1
         bUOw4BZYhp7kPDElxGcvpMCPysU1GxllMuTOpX6ZQATnNg6grjVVRuHUUWollSZ3lnrv
         LVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748829417; x=1749434217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZHGTRI4OoccGkRynWoGInJUpFy17mwKB39OxXBmCuH8=;
        b=ONVRKIIKGVchFt8pW2RGQZAThvV0gK2aMD/1ZVf4lDH+glJdus+u3sTMWN2scwL8lK
         g0gFyyXL78LDw7BlybrUKW04ghEp+7fUYsdzbyrpwyPO7FVH00PFxGr0e2tyAxC04nms
         +emNFfeXSBoKaBXD+Lx1lAH3iuciQjdETTv8X/o3d+jsrhDQ3qpl1Lg1vBMfyexIhckc
         s+se7jAZgJSpwb1UL0JudFwknI2s0pwg/WDptCKjwWi8+XZNAXZIlQ3gXiyHKQOV7vjy
         G3+RRLPOXLlIHUOhScbW5YQPn4TDPW/ZiDYZGCHV2xZihIIZ/BvGfb2lQpHtj7uZlafJ
         jM+g==
X-Forwarded-Encrypted: i=1; AJvYcCW49Cq84P7+MYEAotv8NIw8N9NeumXsjDJLGzbcn9EFf75bG/oKC2NsShL3t846R7tR0siLIhJ33rN5@vger.kernel.org
X-Gm-Message-State: AOJu0YymivviEpoUKHs6AH8g5zbgGbIhoFYTYszaFGqLudexY25Jzb3Z
	z0uvak+xxtXzBRpQK1ews5jJMzqTcNzH1EPsQx6kbx7mI5UZYaySHTw7w/phWJjaQQ+l8Ulc1Vd
	suSCYmMCCKFbWqmwbbVIpbR9zSi59uAI=
X-Gm-Gg: ASbGnct9XMB9DjTTqgcykAr1bC/JZaV4N5+Gxzsxmjmwhf+buY4VMCPBwEZXdr4Gf6E
	Vo9WykHm97q1IzCzfRPIwcWqrr6lcjSojapgUeKnwuAaIiuGK1IniKhzyfYhefS+aY5Zf0XYjnD
	9/9RVJsHwSppjJmeteFYbeqT9AjFxcLKtgqzPAtUS5mroLpuCyPQI/B1mT8hfoVfPPK0TR2fDgn
	aWc
X-Google-Smtp-Source: AGHT+IEJVs0h6mmYJxZYvbe5X10CMO2Kyt68ftrFl6gVFuRA5aY8nZgVqa8fLfU9yQzt/nFb3Hvuu43oMkpzwc6APYY=
X-Received: by 2002:a05:651c:221a:b0:32a:6b16:3a20 with SMTP id
 38308e7fff4ca-32a8ce3871amr38651951fa.29.1748829416867; Sun, 01 Jun 2025
 18:56:56 -0700 (PDT)
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
 <CAH2r5mso54sXPcoJWDSU4E--XMH44wFY-cdww6_6yx5CxrFtdg@mail.gmail.com> <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com>
In-Reply-To: <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Jun 2025 20:56:45 -0500
X-Gm-Features: AX0GCFsrkFzp3OvWJF63SovgSoF5lPD082yGsAPlfjTR_bDrLK5Z8cNbb9dt3lc
Message-ID: <CAH2r5mvygcy0-WwZNu6NvjXGrMtB5ZFLK7_w0rc6rVpaVDeBxA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Can you explain why he has split it into smbdirect_socket.h?

The three header names seem plausible, but would be useful to have
Metze's clarification/explanation:
- the "protocol" related header info for smbdirect goes in
smb/common/smbdirect/smbdirect_pdu.h   (we use similar name smb2pdu.h
for the smb2/smb3 protocol related wire definitions)
- smbdirect.h for internal smbdirect structure definitions
- smbdirect_socket.h for things related to exporting it as a socket
(since one of the goals is to make smbdirect useable by Samba
userspace tools)

On Sun, Jun 1, 2025 at 12:00=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Sun, Jun 1, 2025 at 12:49=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > Moving to use common headers is something I did multiple times with ksm=
bd and cifs.ko already, not a bad first step
> This is not simply moved to the common header. He splits the header
> into smaller pieces for some unknown reason.
> Can you explain why he has split it into smbdirect_socket.h?
> We doesn't need to do it now if he's thinking of creating a
> smbdirect_socket.c file later.
> >
> > Thanks,
> >
> > Steve
> >
> > On Sat, May 31, 2025, 7:01=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.or=
g> wrote:
> >>
> >> On Sun, Jun 1, 2025 at 8:23=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
> >> >
> >> > I do like the small, relatively safe steps he is doing these in.
> >> Small is okay, but I wonder when he will send the rest.
> >> What if he just separates it like this and doesn't send the rest of
> >> patches later?
> >> I've never seen a case where the headers are separated first,
> >> And send the main if it's implemented later. This is not a personal re=
pository.
> >>
> >> Thanks.
> >> >
> >> > Thanks,
> >> >
> >> > Steve
> >> >
> >> > On Fri, May 30, 2025, 5:29=E2=80=AFPM Namjae Jeon <linkinjeon@kernel=
.org> wrote:
> >> >>
> >> >> On Sat, May 31, 2025 at 4:03=E2=80=AFAM Stefan Metzmacher <metze@sa=
mba.org> wrote:
> >> >> >
> >> >> > Am 29.05.25 um 01:28 schrieb Namjae Jeon:
> >> >> > > On Thu, May 29, 2025 at 1:02=E2=80=AFAM Stefan Metzmacher <metz=
e@samba.org> wrote:
> >> >> > >>
> >> >> > >> This is just a start moving into a common smbdirect layer.
> >> >> > >>
> >> >> > >> It will be used in the next commits...
> >> >> > >>
> >> >> > >> Cc: Steve French <smfrench@gmail.com>
> >> >> > >> Cc: Tom Talpey <tom@talpey.com>
> >> >> > >> Cc: Long Li <longli@microsoft.com>
> >> >> > >> Cc: Namjae Jeon <linkinjeon@kernel.org>
> >> >> > >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> >> >> > >> Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
> >> >> > >> Cc: linux-cifs@vger.kernel.org
> >> >> > >> Cc: samba-technical@lists.samba.org
> >> >> > >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> >> >> > >> ---
> >> >> > >>   fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++++=
++++++++++
> >> >> > >>   1 file changed, 55 insertions(+)
> >> >> > >>   create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
> >> >> > >>
> >> >> > >> diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/=
common/smbdirect/smbdirect_pdu.h
> >> >> > >> new file mode 100644
> >> >> > >> index 000000000000..ae9fdb05ce23
> >> >> > >> --- /dev/null
> >> >> > >> +++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
> >> >> > >> @@ -0,0 +1,55 @@
> >> >> > >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >> >> > >> +/*
> >> >> > >> + *   Copyright (c) 2017 Stefan Metzmacher
> >> >> > > Isn't it 2025? It looks like a typo.
> >> >> >
> >> >> > I took it from here:
> >> >> > https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dblob;f=
=3Dsmbdirect_private.h;hb=3D284ad8ea768c06e3cc70d6f2754929a6abbd2719
> >> >> >
> >> >> > > And why do you split the existing one into multiple header
> >> >> > > files(smbdirect_pdu.h, smbdirect_socket.h, smbdirect.h)?
> >> >> >
> >> >> > In the end smbdirect.h will be the only header used outside
> >> >> > of fs/smb/common/smbdirect, it will be the public api, to be used
> >> >> > by the smb layer.
> >> >> >
> >> >> > smbdirect_pdu.h holds protocol definitions, while smbdirect_socke=
t.h
> >> >> > will be some kind of internal header that holds structures shared=
 between multiple .c files.
> >> >> >
> >> >> > But we'll see I think this is a start in the correct direction.
> >> >> When will you send the patches for multiple .c files?
> >> >> I'm not sure if this is the right direction when I check only this =
patch-set.
> >> >> I don't prefer to change the headers like this in advance without a=
 body.
> >> >> When you're ready, how about sending the patches including the body=
 all at once?
> >> >> >
> >> >> > I try to focus on doing tiny steps avoiding doing to much at the =
same time
> >> >> > or even try to avoid thinking about the next step already...
> >> >> >
> >> >> > metze



--=20
Thanks,

Steve
