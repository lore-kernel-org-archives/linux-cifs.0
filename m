Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC51D250E9
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jan 2024 10:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PIPPdcPF"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50e7dff3e9fso1653340e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jan 2024 02:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704450235; x=1705055035; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lraO2XeH29IEphDl7lyWKGHaK/kn7b8KfS/+Ygu7O90=;
        b=PIPPdcPFAk3uL0U+tV2x/BTJ1xnhJ8XC9158eExyM1WzPetF5YMN37ieVDayZMaSBS
         1PreaI8siXr5AIKubyD84NH70ZLZ0rKOTIhFD8dVXf7ubo+cNkz6Nx+aeyOgYT/xLOc0
         xFuPHw3xGGjC+s6t7XuBfeL3GUys8kevD/x0/NbNdUMl340QW7R0q+6A57orvFvKMUfl
         7kEeJtVFUB1XRUqkZp7fAI8086jkGfTPZaVHvrpwoFHDEpjjxxFkskug+hwhrNoOI2bQ
         c81FfipWthaQvHJDAcoElCbQYEJ3rYmSN0B5GAUgbFmQhVZGE0Yd1I8pTrQuwxff7mEw
         1Z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704450235; x=1705055035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lraO2XeH29IEphDl7lyWKGHaK/kn7b8KfS/+Ygu7O90=;
        b=sboRUpRToFCcjQUf2Vr7SBZRM8gJXR8gmDsPrGNjXnbNJl4URiblfb+87lr1z1wO+r
         rGMKr5Tj7GU3QmTiszaYzxnIxSgLhGxEphakdcxEB6jrJmNYdZByxU5TVZA7WVpTDl3L
         m3WH6C3GkQSSwm//6dkl4SjY6HPq+5zZCQfYoxADESGWqWH2JZEIXeUmHJBmxhj550Xz
         ZR0BR1YUgg+j4nCBN/TrdQx4DNreegPPddbtmmyC3BlkLVWtRI1Ji9ZcFXISv4BF0J3P
         ZrX/+eMdkHB1jMXMlXoG036tMQRl6//0IZfZNh1QJGLQddwepyJ/lcqYWM56OVLPE9dr
         +xHw==
X-Gm-Message-State: AOJu0YxP5wofOxJYd1dqMWfW8/b4LK3/KgDcVvCd5KaQaetlJmsza+3M
	Z+udDR9suaEm8FKbbx8dQOc5YsaKVmF8H1qKdVA=
X-Google-Smtp-Source: AGHT+IEhxJ6rzAN3ItavqYUezN+dWr+l5CN5kAUj7vCDCjan4UdmOQBt+vGMwskzlpAj8lPWpQKSoD/Y3hsuX8O2tBg=
X-Received: by 2002:a05:6512:3e07:b0:50e:714f:f2ca with SMTP id
 i7-20020a0565123e0700b0050e714ff2camr1238829lfv.91.1704450234583; Fri, 05 Jan
 2024 02:23:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com> <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com> <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
 <CANT5p=qqUbqbedW+ccdSQz2q1N-NNA-kqw4y8xSrfdOdbjAyjg@mail.gmail.com> <242e196c-dc38-49d2-a213-e703c3b4e647@samba.org>
In-Reply-To: <242e196c-dc38-49d2-a213-e703c3b4e647@samba.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 5 Jan 2024 15:53:43 +0530
Message-ID: <CANT5p=oFxQEB5G4CzVuJBkg76Fu-gqxKuFdYJ8NCnGkS-HhFJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing lease
To: Stefan Metzmacher <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sprasad@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	sfrench@samba.org, Meetakshi Setiya <msetiya@microsoft.com>, bharathsm.hsk@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Metze,

On Fri, Jan 5, 2024 at 3:30=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Am 05.01.24 um 10:39 schrieb Shyam Prasad N via samba-technical:
> > On Fri, Jan 5, 2024 at 2:39=E2=80=AFAM Tom Talpey <tom@talpey.com> wrot=
e:
> >>
> >> On 1/3/2024 9:37 AM, Paulo Alcantara wrote:
> >>> Meetakshi Setiya <meetakshisetiyaoss@gmail.com> writes:
> >>>
> >>>> As per the discussion with Tom on the previous version of the change=
s, I
> >>>> conferred with Shyam and Steve about possible workarounds and this s=
eemed like a
> >>>> choice which did the job without much perf drawbacks and code change=
s. One
> >>>> highlighted difference between the two could be that in the previous
> >>>> version, lease
> >>>> would not be reused for any file with hardlinks at all, even though =
the inode
> >>>> may hold the correct lease for that particular file. The current cha=
nges
> >>>> would take care of this by sending the lease at least once, irrespec=
tive of the
> >>>> number of hardlinks.
> >>>
> >>> Thanks for the explanation.  However, the code change size is no excu=
se
> >>> for providing workarounds rather than the actual fix.
> >>
> >> I have to agree. And it really isn't much of a workaround either.
> >>
> >
> > The original problem, i.e. compound operations like
> > unlink/rename/setsize not sending a lease key is very prevalent on the
> > field.
> > Unfortunately, fixing that exposed this problem with hard links.
> > So Steve suggested getting this fix to a shape where it's fixing the
> > original problem, even if it means that it does not fix it for the
> > case of where there are open handles to multiple hard links to the
> > same file.
> > Only thing we need to be careful of is that it does not make things
> > worse for other workloads.
> >
> >>> A possible way to handle such case would be keeping a list of
> >>> pathname:lease_key pairs inside the inode, so in smb2_compound_op() y=
ou
> >>> could look up the lease key by using @dentry.  I'm not sure if there'=
s a
> >>> better way to handle it as I haven't looked into it further.
> >>
> >
> > This seems like a reasonable change to make. That will make sure that
> > we stick to what the protocol recommends.
> > I'm not sure that this change will be a simple one. There could be
> > several places where we make an assumption that the lease is
> > associated with an inode, and not a link.
> >
> > And I'm not yet fully convinced that the spec itself is doing the
> > right thing by tying the lease with the link, rather than the file.
> > Shouldn't the lease protect the data of the file, and not the link
> > itself? If opening two links to the same file with two different lease
> > keys end up breaking each other's leases, what's the point?
>
> I guess the reason for making the lease key per path on
> the client is that the client can't know about possible hardlinks
> before opening the file, but that open wants to use a leasekey...
> Or a "stat" open that won't any lease needs to be done first,
> which doubles the roundtrip for every open.
>
> And hard links are not that common...
>

That does makes sense.

> Maybe choosing und using a new leasekey would be the
> way to start with and when a hardlink is detected
> the open on the hardlink is closed again and retried
> with the former lease key, which would also upgrade it again.

That would not work today, as the former lease key would be associated
with the other hardlink. And would result in the server returning
STATUS_INVALID_PARAMETER.

>
> But sharing the handle lease for two pathnames seems wrong,
> as the idea of the handle lease is to cache the patchname on the client.
>
> While sharing the RW lease between two hardlinks would be desired.
>
> metze



--=20
Regards,
Shyam
