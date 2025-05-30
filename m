Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F055E254B1B
	for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 19:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748633284; cv=none; b=kymXbtmVfln5WUhcdUdLp4K9eqFBLRcM65BqPD8qxtXkCrwk4uu360IG16aqp6Cdmr9PROsoaPXLyBjqrvUlFqr6XTGeA1W3Yvit8od8BXyh8MH6OJLHLIh6jV2cemOzdaaZhu+vmQs8/zo/hKZka/NaZu5IJXe25F7PXrhnafg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748633284; c=relaxed/simple;
	bh=nzkqybvVlGXMQTmim/Gq+vJQb6wSR1iKJcNl6GOsHYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQLZ2DNgljqUlQZeHS4S8YpnaLLN+4aFnvLGqIfOuCPnyNaaGE+rX1fZ8CYc42xZrSmikGYvw8E8MJLQT+vJuSB6QOFHPPFr7agSEFt9wobAHWv9NdCi35fz9Ik1vLH4ocwbhSH0yx8w/X269sacb2sibxGt9NbAla5Rnos+yfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nifwVcWj; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nifwVcWj"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54b10594812so3014381e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 12:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748633281; x=1749238081; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=re2ChLKOQ+JxwBs930OOJvsEwxjS1nTmkImmlcIrOWs=;
        b=nifwVcWjLCZEdt47V0ULfYj+BbrZe2hMyNqOs+t4xocPYNI8h3HaDO5O+aNfVpYI+7
         KRdML8D6g+wAcLoE0Q2WcVfcBv6dmCv44H9pWRYinDMIREYXpHaxCQbVjVdZ8lt2/AUR
         JEOUoKCO30M07u9RoQ/FjX42xCOCnb8muk1Rg1WX+2v1LicTkszgbjDo5aIZlXaP8IFs
         PQvbd9k+q7TrCmfMf4trwcgez/n1Pkk/x/Lc6fjyQw3s7yfeANnSd1KShAHTqnC4yxZP
         mtRlzuUbpMmUj1y2boB0EAiajcEpGF8l7qhw0GvV+MLsnE/db2wi+GQel06T+OIIf2yB
         zsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748633281; x=1749238081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=re2ChLKOQ+JxwBs930OOJvsEwxjS1nTmkImmlcIrOWs=;
        b=F2DgQFeMeBSvrdLBe3eKAJ/+xkvf/2CWD2+D9ILGEViT1qbGs8ODl5L8coyKA1BhZf
         h+BUWFUGkkWzOXadbndMsmvp3z3JaSm897m/aO6SdBBBfMx4+cbaFHpQ+yzsGqBYaawn
         P7aPg4R+D9l695czQTAsKnHjgf+M/5+KmqiqYGKMNWw8diTvjqQ0jx+IbO+h7Ax9b+YA
         Gzg4rn9+p/H08Ywpn5Hajy+BsLr8JbcdVEzpND1fJgHS4wNmMIb+lgTY3wTyPtGU77QS
         qMY0YZl5CjAE6vuTVkEuZiEZk2pSQBLWisKYavxOHOatciDwaDDZEy0ugoX74z+3M5ph
         77ZA==
X-Forwarded-Encrypted: i=1; AJvYcCWxK/3RGiGkauQ73Q9zgzzYfk0Kg01o19fr/77FQTyBeHoFNQiWHiH5SimFL7mYTYRj4mtIS2yjU4j/@vger.kernel.org
X-Gm-Message-State: AOJu0YxOWXJCRCokuRxS8Ev4eDthb6LmGr1ksz3UISvGqJf9ete4F1GB
	z1uTC4dZ8tkI7DAvhMGXbrqG5LJqsfaGCKEKHbrfdMhbsdwY08niLhMSsxrMQy68D8EKM3U19NI
	pvH3MaOtKpdFc/H7s0/NkiYmGYnEm+0M=
X-Gm-Gg: ASbGncuAxnrxgX0I93oE+rAVj2E473JeWVUpSwpuH6r5W+qHt+gytwbXUnGe7eXcB45
	bq5jp03q9+/IwixL7fNhBN+b/Ay9fLXQDqIGfY1VGyKYQ+F9LWNwayQ96DTqUb8qXp6qCZC+hsa
	lqNlusrMhyYDFEVlthJLqAk8oE79fUnKagwIoe34x7wPtfWB92WJeTBIT0UkWmTQYlvd0=
X-Google-Smtp-Source: AGHT+IHZY78+ghfvx9mHgZXp/sRB69mVFQcBsMxlpHgIJsCVofks9XNNhIOo6Wfxtl39c/v4RMyQKweHO3sLxS3HUcg=
X-Received: by 2002:a05:6512:1595:b0:553:35bb:f7b7 with SMTP id
 2adb3069b0e04-5533b90aabcmr1981315e87.32.1748633280806; Fri, 30 May 2025
 12:28:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748446473.git.metze@samba.org> <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
 <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com> <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org>
In-Reply-To: <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 30 May 2025 14:27:49 -0500
X-Gm-Features: AX0GCFubCs8sKHn0tAwQeHSs-E4R094BYFfcCaE2Dk4sKG1XBLp8KhEo9FrbH-U
Message-ID: <CAH2r5mvCm=W-XsuQF0r43x5wV_O64Jzh-6HxLLD0KSYm7zgsSQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 2:03=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
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
>
> I try to focus on doing tiny steps avoiding doing to much at the same tim=
e
> or even try to avoid thinking about the next step already...

Makes sense to me. Seems like a very good plan
--=20
Thanks,

Steve
