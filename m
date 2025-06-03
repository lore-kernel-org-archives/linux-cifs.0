Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888C21FC7F5
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 06:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748931617; cv=none; b=RyYTk7wQ8Mf7189vHKqFIjj2w/MJgiIEA3H4+ZSlsSQZiRqCoqJrhi7r2ZMd7wu+6yjFNl0A1zW2BltIDDumbFf4JXJGCzaOuVzEXMClrbwFeiCFNh5r1ix01v7JXWDFAnN7DMh0zZHEAA8OI+5dEA4Y99X0Lk1DF/aH0PzOGmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748931617; c=relaxed/simple;
	bh=3eWaOx+xfALn4tfpgFidvxGl9CfQns1LRintzC2bFl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tMbxqYG2iCscr8Y0TwPblqUgPtNKAVWHR7VNF997f9rJDksJbrdrg/bX3KL1JzT4Lhnh2YIfUckss1JXoyzT8gl1hSDlS+iDFsfhi40I7wPMSf0AAtm5U5O7qHlO4az+p+KwgAX5Lvl+O9i034UfU6I1OcKo1XR0RRLxlJ8zG+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMdWRIzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMdWRIzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FCDC4CEF4
	for <linux-cifs@vger.kernel.org>; Tue,  3 Jun 2025 06:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748931617;
	bh=3eWaOx+xfALn4tfpgFidvxGl9CfQns1LRintzC2bFl8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XMdWRIzT+aZajOLiF6ElHGRWLmFKqnai2BICfbARIz5HkA8jGoi3psyn7vb0sae85
	 DXzNKv8CnCDKdVdve7RBnHQe6g+iNcJzKJy3qseRD6SVlCSWfIOJIQWIf5FBtrw7I5
	 w3zEM5r7zm5mEjxIYyHZhJLS/oIyFT1AWuiVfuep8NNVrF7D/VbZOnKhhaN8HsHpGT
	 0j9aw11QfP4ZMl+eTc/LeN5Tp9nMeXZ7HYumwNxECmI58VjnxrYKr0sv6/WmjQPUj1
	 orWG7kw92UFNIBeyJPqFueYTgp2IY53ONjRm280J9AHFmRvDBuUzUQTJooQljyD6oU
	 emkcSPI4etlvA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6046ecc3e43so8757372a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Jun 2025 23:20:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXJ7leXvUk0qybMpnXZoba0pA4+bKxHH+TqWymfhRuRgfbH/8/KwGLMFMTUMAZBBhFtqus/Ju93ekgn@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt2iXolhUsTwAiqctVL/7gKccLc3ebwOWNxnbzC5/je5mv6Zsi
	LtnQa3bmfMd5nN1whw9aXkVR1BmLgkArWLw7oiuL0SzDDox/shSJBhQRAcovyfLaqq9gu0S2MuZ
	+1IekFn4HEsKgtFDYCkOvrpCH/+KJCvU=
X-Google-Smtp-Source: AGHT+IH8NfHU5JisLnNpksjaWB8HnN7+axLczTKFUWZHIyqUrKjavB0SPC2fiKaURvAO8U4lL7ahDLcswNu6SRTb4Rg=
X-Received: by 2002:a17:907:9612:b0:adb:2e9d:bc27 with SMTP id
 a640c23a62f3a-adb324500e8mr1578219566b.54.1748931615565; Mon, 02 Jun 2025
 23:20:15 -0700 (PDT)
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
 <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com>
 <CAH2r5mvygcy0-WwZNu6NvjXGrMtB5ZFLK7_w0rc6rVpaVDeBxA@mail.gmail.com>
 <CAKYAXd-4-WRw9bL-shqELhMO70fyznmeh0HByA=pyOcccu3sgg@mail.gmail.com> <5d0f7f91-8726-4707-abd4-c1898c8ba65c@samba.org>
In-Reply-To: <5d0f7f91-8726-4707-abd4-c1898c8ba65c@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 3 Jun 2025 15:20:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9h8LpaOX9JA5Mdduw1CQ4RnYFgkU9dXf6NnNbTFYFJ8g@mail.gmail.com>
X-Gm-Features: AX0GCFu3rDi-mws5YPEDC4dwNEThwkYsP51o6sity0E8_OhD1J_nXr3273juXeg
Message-ID: <CAKYAXd9h8LpaOX9JA5Mdduw1CQ4RnYFgkU9dXf6NnNbTFYFJ8g@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 3, 2025 at 7:03=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Am 02.06.25 um 04:19 schrieb Namjae Jeon:
> > On Mon, Jun 2, 2025 at 10:57=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
> >>
> >>> Can you explain why he has split it into smbdirect_socket.h?
> >>
> >> The three header names seem plausible, but would be useful to have
> >> Metze's clarification/explanation:
> >> - the "protocol" related header info for smbdirect goes in
> >> smb/common/smbdirect/smbdirect_pdu.h   (we use similar name smb2pdu.h
> >> for the smb2/smb3 protocol related wire definitions)
> >> - smbdirect.h for internal smbdirect structure definitions
> >> - smbdirect_socket.h for things related to exporting it as a socket
> >> (since one of the goals is to make smbdirect useable by Samba
> >> userspace tools)
> > There is no need to do things in advance that are not yet concrete and
> > may change later.
>
> The current idea is to merge transport_tcp and transport_rdma into
> transport_sock, see
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dblob;f=3Dfs/smb/server=
/transport_sock.c;hb=3D66714b6c0fc1eacbeb5b85d07524caa722fc19cf
>
> Which uses this interface:
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dblob;f=3Dfs/smb/common=
/smbdirect/smbdirect.h;hb=3D66714b6c0fc1eacbeb5b85d07524caa722fc19cf
Hm.. I can not access these links.. Is it just me?
>
> But note that is just the direction were it goes, that current code has a=
 lot of resolved merge conflicts,
> which may not work at all currently.
>
> Instead of putting my current code I try to take the existing client and =
server
> code and merge it, so that we don't have a flag day commit that switches =
to
> completely new code. Instead I try to do tiny steps in that direction
> and may end with an interface that is similar but might be a bit differen=
t in
> some parts.
Okay.

>
> > He can just put these changes in his own queue and work on them.
> > I am pointing out why he is trying to put unfinished things in the publ=
ic queue.
>
> Because I want to base the next steps on something that is already accept=
ed.
>
> I really don't want to work on it for weeks and then some review will voi=
d
> that work completely and I can start again.
It was too tiny a step and unclear.
i.e. the patch description should not have comments like "It will be
used in the next commits..."
>
> > If You want to apply it, Please do it only on cifs.ko. When it is
> > properly implemented, I want to apply it to ksmbd.
>
> I can keep the ksmbd patches rebased on top and send them again
> each time to get more feedback.
>
> Would that work for you?
Okay, Please re-include the ksmbd patches in the next patch-set and I
will check them.
>
> The key for me is discuss patches first and have them reviewed early
> so that the following work rely on. Any the tiny steps should
> make it possible to do easy review and make it possible to test each
> tiny step.
Okay. I agreed. But It should not be too tiny.
As I said above, please don't send it in pieces that I can understand
by looking at the next commits.

Thanks.
>
> metze
>
