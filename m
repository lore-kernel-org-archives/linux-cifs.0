Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700C42E3AE3
	for <linux-cifs@vger.kernel.org>; Tue, 17 Jun 2025 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750166373; cv=none; b=RbrA/QEkM2WLbX3T7ul+nehFfCBywxGqST8o0RtlVbIS7NdZG5qTHjmBcisXJbqnq+/9M55XiOgq2Wg3kxZREWQQpj1NQhrw5rtiG+at+J4nAVcSHB/V+6UMAH3OraCEJvQhyHq2f1hgjiXu1jixUraWV1J/NugCEWc3h70E2L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750166373; c=relaxed/simple;
	bh=03GAEg6zsfTuDne01wHNaeMc2CmT17CyAcQPd0eLXFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJl4YR8LZ/K6A+qa2wBzc5KiKD9sAJGgFQM2B1Na0eyY5lVdpWAsHqIBRptTm4hsgSFmWBD2k8420aycSWMCo3YJL9uFHrUjcrPFP0KWYO4Lxw+aBl55wOjJ4M0tHqcj7o+1TQfxLaAEK5Xg4KBMcrn1RsO60IxOkOCn2ZIP5K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GlgkVmyZ; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlgkVmyZ"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32ae3e94e57so50464801fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jun 2025 06:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750166370; x=1750771170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rErtEAvy+GbL2WFWOKGCJbHi9YowFZb0ep0jKvo2Udg=;
        b=GlgkVmyZd9huhL3E1EwbZE1CZkodapwmyrq+9FDcrTijhupdspXOfECh1GZV6DTC5t
         BafE4hKfiJC4xf/j4VrGL5yJnIhkl+YhsEtkq+rORxJ3TBKmjziVouxzGFEBFCCw/ObH
         fNc+aReIbi4aoxUq8QRsN0jlwFYdoisqXjdtZeC578uEhHqyGaFPmZ7HZdAuHZIAFGJ4
         LXmF3irTinpNJ/5dVrbsosqfGV3vKt6Tb0gcksivNshhpr7C3ZmFn5XCvI4Mr3Fk+eym
         Zzi0DO7xVrRTT0r/cS4zGSxGQ/IpeHJWGW6E4+dsJQe07CSP1spPuHXDsKjVBtqwzM2S
         4Syg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750166370; x=1750771170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rErtEAvy+GbL2WFWOKGCJbHi9YowFZb0ep0jKvo2Udg=;
        b=LlAaeB5B7eV1o7wczWoKUUk6vtdNn5mXOL4ThDL61UhkLxMBHUTMopJjB8RdxaKR2J
         h6XB3Bj9Jq4zJCUAPsUn3e2mQdzzxDgAprFK5T+PxQPU7FB4EPzOHuRXRMoZD8Q0vt5a
         JIo8ypUTdkYM+kNn8q/AGprb0tOhWDZpGFMynC9rzTJ9BIRuFjyeVjbKJt+UYL/NkM6d
         PiJJynhREq8wVbvuD2+sVJIsHHAdcEev7+47xDnQUGc8ZfgruFvKcBeFvmwpXQT/Z4/t
         tczGLzQ0y/KMx25DVogGRIHmT+O9PH76RKCeT8Sxep2lmFuZVj5cEyUCfP2B7bXkcc7H
         6frg==
X-Forwarded-Encrypted: i=1; AJvYcCWpVRJTroAuKTPCfGprWXsa0dp1XjlNlzh5rngjnk2ArYFLLbVxcXuwOUxQe+ik91vgYS5UlLsFlEtl@vger.kernel.org
X-Gm-Message-State: AOJu0YyssXkz8WQxB3UbFJi0dO2B74S4I8LmLPEJTq17SgdSSt84tmad
	vNNBMxYcmBcMIyy4Mo2xWmNokn9je0etC3PtSDpjWgIW1kh0jAO491mrVfOIzHG5/GZOCxf3CSO
	ZuBEht4awMS/M8BlMscpbsZtIHaCjiz4Sug==
X-Gm-Gg: ASbGnct+BExZfYerb5zXyK3BmzGMVixI0ZCoz7nV2Y2zEi/qNp2JL1Q4iLSm/nLaoFf
	Miv6hyf9+ikMvpOHpwECDVQNi5Fy0zKUXl5IDxOwqVTtBVF5b7HiW9RdYLz2Pu6fC/G07MvRKK/
	Fzao8/Q/CdnfU/gsKbtOoQDquiBgoYWmyRV+LgRxlu96KZ8LHYyfCp
X-Google-Smtp-Source: AGHT+IEr5q3KPJXRn2o0RRP23hrJN/mAQHvChCi11JVCr78+Rnkq5ACoGrRGWeosBj96GkbITAykpCFELQYsMaqz/fg=
X-Received: by 2002:a2e:b8c2:0:b0:32a:81a2:8aa3 with SMTP id
 38308e7fff4ca-32b4a658deamr38123681fa.23.1750166369274; Tue, 17 Jun 2025
 06:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317102727.176918-1-bharathsm@microsoft.com>
 <20250317102727.176918-3-bharathsm@microsoft.com> <CANT5p=pmsUx8FGxZARcOdWXCVQo5V6zZV8k5pn7AZPt+6bGj9A@mail.gmail.com>
In-Reply-To: <CANT5p=pmsUx8FGxZARcOdWXCVQo5V6zZV8k5pn7AZPt+6bGj9A@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Jun 2025 08:19:18 -0500
X-Gm-Features: AX0GCFsFVnQAPVkVA-2q1Lh7AoPmEXJiZ2sFEoDOEOUJfqne9-ZY_gYdkssDUBw
Message-ID: <CAH2r5mvbBsGnjo--+0b20BBpjuwGEebOx4=-6KjyTsQTnfP9nw@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: fix secondary channel creation issue with
 kerberos by populating hostname when adding channels
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, 
	sprasad@microsoft.com, pc@manguebit.com, Bharath SM <bharathsm@microsoft.com>, 
	xfuren <xfuren@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next

On Tue, Jun 17, 2025 at 6:05=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Mon, Mar 17, 2025 at 4:04=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.c=
om> wrote:
> >
> > When mounting a share with kerberos authentication with multichannel
> > support, share mounts correctly, but fails to create secondary
> > channels. This occurs because the hostname is not populated when
> > adding the channels. The hostname is necessary for the userspace
> > cifs.upcall program to retrieve the required credentials and pass
> > it back to kernel, without hostname secondary channels fails
> > establish.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > Reported-by: xfuren <xfuren@gmail.com>
> > Link: https://bugzilla.samba.org/show_bug.cgi?id=3D15824
> > ---
> >  fs/smb/client/sess.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index b45b46b1b792..f2ab8513c3ed 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -494,8 +494,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
> >         ctx->domainauto =3D ses->domainAuto;
> >         ctx->domainname =3D ses->domainName;
> >
> > -       /* no hostname for extra channels */
> > -       ctx->server_hostname =3D "";
> > +       ctx->server_hostname =3D ses->server->hostname;
> >
> >         ctx->username =3D ses->user_name;
> >         ctx->password =3D ses->password;
> > --
> > 2.43.0
> >
> >
> Looks good to me.
> This one depends on one of the patches I submitted recently:
> "cifs: dns resolution is needed only for primary channel"
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve
