Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57818F40
	for <linux-cifs@vger.kernel.org>; Mon,  9 Jun 2025 05:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749447940; cv=none; b=ZckQMqeMWdAtrrW1zHaWSF7O9Ahmyra+E1ZDiikchxXTIYsGhoqYjxstgksFqRoU229OHHrUaIk+BuwMYyXtpN9IQ38gMO/gkPoj2Hkvesncyk9qfZHiRCVWBrOqwCPhXbhw2Gl5SQs8On+arlaYNWOtBn3lLoIZMNPp5XqvoQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749447940; c=relaxed/simple;
	bh=2fNfAtAabnehq5D+BW+gVWFK++a5Ymt+bmvzvZFX0p8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n1yFMPnW7NmOU4ji89hJNPd3+ZSPmSe9bxU6uuq8I5XpychnB0TJ4Y/3Lh2aKSPY4JHrMR3fN0LATvC8SjfbO3DZUFoarKWzgeG1kDnaM5QzT9T3l8uEGp1n2/Bag85whQpZvRn/70vGG5Vsc/mWNwSdsuw4w2aeTJljURBLVxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkCzXoTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkCzXoTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DACC4CEF3
	for <linux-cifs@vger.kernel.org>; Mon,  9 Jun 2025 05:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749447940;
	bh=2fNfAtAabnehq5D+BW+gVWFK++a5Ymt+bmvzvZFX0p8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KkCzXoTcXzIUjfc80fIScd84deVJmCh+cAEbPZPItQJ1EdAc9jrq65r8bzoL6+gW1
	 M8XTJjeOvjVV8Ht6oS5WHhDxuWq6j3O3iHM+YdO6CHxN/sYght0z2ZNatBvTiukGYn
	 6cD9nihUDdqjEctNQZFE/OyiGzq05DJpx/S6SFZQl5rqE08fnLduHgMTqeyFsnacKE
	 plh9PIg7+aRBVqSS2O/WnvzfPl0nt+oS2uhJj0VmU28Inuq7KjtKqu6UstUfmtGO3j
	 myHcZPXBLKIPU4ZaPdbfTIj7LKl8H04rzjTB4ZVs73z0LI2yO10UWyXRfJpCU3bz45
	 HvZ2mwA5pu0JA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ade326e366dso353099966b.3
        for <linux-cifs@vger.kernel.org>; Sun, 08 Jun 2025 22:45:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YxNi4tKV1efhq0cc4mqQjv6RTwSakP9SLkNzP4qwsNdZKSWXNFW
	KKFATsSdeteHU1nAO8qKKGhf2xGPfBAZxURya5I+FSBpofK7P76csXu43+ze/snispl1nw1RoFz
	lGztO+8Ln6o0J8pxc56XIO8Jta+HIB/k=
X-Google-Smtp-Source: AGHT+IH9Ooc8eDsm/9zmldccEQELFGMVmEgKxEwkDyP09huMIrOhTqvGZal5E/iyvpae5VqqVeO9gyJciTNZPAPFAE4=
X-Received: by 2002:a17:907:8690:b0:ad8:9466:3348 with SMTP id
 a640c23a62f3a-ade1a978de5mr1115972066b.36.1749447938886; Sun, 08 Jun 2025
 22:45:38 -0700 (PDT)
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
 <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de>
 <4195bb677b33d680e77549890a4f4dd3b474ceaf.camel@rx2.rx-server.de>
 <CAKYAXd9OQW9oOfjUDWSGmh+b7QtHSc7M=rHhCW6QEsFpEkVFVw@rx2.rx-server.de> <5891ee55f912ceab918019f59e6cd35f809132d9.camel@rx2.rx-server.de>
In-Reply-To: <5891ee55f912ceab918019f59e6cd35f809132d9.camel@rx2.rx-server.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 9 Jun 2025 14:45:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8cM-6z-FE1+Y4PSCjHQ4eewsKcsG3uNN=k5Zm__5HWFA@mail.gmail.com>
X-Gm-Features: AX0GCFtqMVUMINdzDx4Q23lRpVBTf5ozaKDvbGQQuJs4lfAh6NSbCCoorJW-5lE
Message-ID: <CAKYAXd8cM-6z-FE1+Y4PSCjHQ4eewsKcsG3uNN=k5Zm__5HWFA@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Philipp Kerling <pkerling@casix.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 4:20=E2=80=AFPM Philipp Kerling <pkerling@casix.org>=
 wrote:
>
> 2025-06-01 (=E6=97=A5) =E3=81=AE 23:30 +0900 =E3=81=AB Namjae Jeon =E3=81=
=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> > On Fri, May 30, 2025 at 6:47=E2=80=AFPM Philipp Kerling <pkerling@casix=
.org>
> > wrote:
> > >
> > > Hi!
> > >
> > > 2025-05-27 (=E7=81=AB) =E3=81=AE 11:57 +0900 =E3=81=AB Namjae Jeon =
=E3=81=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> > > > On Mon, May 26, 2025 at 11:24=E2=80=AFPM Namjae Jeon
> > > > <linkinjeon@kernel.org>
> > > > wrote:
> > > > >
> > > > > > It's been part of the spec since the beginning. You can find
> > > > > > it
> > > > > > here:
> > > > > Right, I found it.
> > > > > Thanks for your reply.
> > > > > >
> > > > > > https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> > > > > >
> > > > > > POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT
> > > > Philipp,
> > > >
> > > > Can you confirm if your issue is fixed with the attached patch ?
> > > >
> > > > Thanks!
> > > I can confirm the following behavior after applying the patch:
> > >  * Path with "&" is not accessible with mount.smb3 and default
> > > options
> > >  * Path with "&" is not accessible with mount.smb3 and "nomapposix"
> > >    option
> > >  * Path with "&" is not accessible with mount.smb3 and "unix"
> > > option
> > >  * Path with "&" is accessible with mount.smb3 and
> > > "unix,nomapposix"
> > >    options
> > > Perhaps "nomapposix" should be the default for the client when
> > > "unix"
> > > is enabled? Tough call though, might break some backwards
> > > compatibility.
> > I agree that "nomapposix" should be enabled along with "unix" option.
> > You can try to submit a patch for this.
> OK, I will try.
>
> > > Furthermore, in the last case in which the file is accessible, I
> > > can
> > > only access the file as root. This is because enabling the "unix"
> > > mount
> > > option leads to the origin UIDs and GIDs being taken over from the
> > > host, which do not correspond to anything on my client. I usually
> > > set
> > > "forceuid,forcegid,uid=3D...,gid=3D...,file_mode=3D0640,dir_mode=3D07=
50" on
> > > the
> > > mount but, for whatever reason (might be intentional? might not
> > > be?),
> > > these options do nothing at all when combined with "unix". I can
> > > sort
> > > of get around this by setting "noperm", but it does seem odd that I
> > > would have to disable any and all permission checking just to get
> > > special characters in my paths working.
> > Please tell me the steps to reproduce it.
>
Hi Steve,
>    1. Create a folder on the server and put a file owned by UID 1000,
>       GID 1000 with mode 0640 into it.
>    2. Export this folder using ksmbd. For the record, I am using "force
>       user =3D <user with uid 1000>", but I don't think the options on
>       the server matter much.
>    3. On the client, mount using "mount -t smb3 -o
>       vers=3D3.1.1,forceuid,forcegid,uid=3D1001,gid=3D1001" and list the
>       folder -> file will be owned by 1001:1001
>    4. Unmount and mount with ",unix" option added -> file will be owned
>       by 1000:1000; most likely forceuid/forcegid is not applied with
>       3.1.1 POSIX extensions (tested on Linux 6.14.6)
Could you please answer this question ? (forceuid/forcegid is not
applied with 3.1.1 POSIX extensions)

Thanks.
