Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632D33F6;
	Thu, 13 Feb 2025 00:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739406295; cv=none; b=CHjZBK2juHH+kwNw+El/hGWBmjozQsXefyuiZNstsNqWt5HSYTpby26KgtHsAlMWGKk8Y6p+pt0BQqKiVy3f7SevtoqWBSRimWmpKTX9sPMh6McjocFUtM8BYeisXRVRwxM/+0pWib9IebHI9twmiKITlJxRxHjY23WDSljHMzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739406295; c=relaxed/simple;
	bh=DjDGu4LJiaJWSki44VS4+hsfALcexCLDcVp/zpu6xhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AfhyK2pExgON/6tEIoV6eHJbf3Kz5PCG9VLU2jPJeiXiNWZ3eWqI41FDpacOGfWFgQ0SJNoiOJ12Mt28J+neLfe40+D4eg5TL68czpfo7v9vDUvSxv5GulCgw654988/fZ05a7uPUnQd3SD8Jj9+LgeErxQUzaSDK/xoZI7a9EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqCWwRZ2; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqCWwRZ2"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5450f38393aso224684e87.0;
        Wed, 12 Feb 2025 16:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739406292; x=1740011092; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFKAoAFFmffHtnq7ewhn5vFC1+6V/tfY4TsdLPDBRck=;
        b=MqCWwRZ2s4poMKR16p9lGLCpvck0QIJcNV4ECFj5nT03FAA7TAabihKXXZjfQ1ePA/
         90TvQbR9TafT3z2Iag5EvxfaiKkfXDZmupuU268aNItvVRrhpBkEhVMdaCLWJYnRsQvq
         Vx7VbznCCvgYZU+rIIKg3OLynoGBJp5TXCiJOgl7ABjw+vT0m2UZ2SjJpFP6xR+Lbdnd
         jTvNR3s63G2GgjfnbDmacpZM2VHKkHgug35FulOyecabu/vCbSUh/t9u9oUKDGHLdBVg
         6H0gpA2x+wJn8vPLFCbCj9ucbUagBZVTXk0N3qNarpXqE2fn32MfA6At+Ua+UPOzp9Pw
         ycLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739406292; x=1740011092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFKAoAFFmffHtnq7ewhn5vFC1+6V/tfY4TsdLPDBRck=;
        b=WuHvEx8B+XGMsqLX85YscCI9onOYUimz6dg0SmoFq3JwHahMVRTstniCR0wbiJkoYw
         nb8RMQ2HLaVYX6LF2vOx7ez9s4q0SlUcP34SlF0rcnF9wDgSH83x8eX25QKg09M2aOou
         WW4XKfEP0yDTJBRJ1uB4ztcGm4SSyLPcgrQPFg68xEm0vV9T1Zv2oqn6IuqRMv5HJkb4
         HeQ0CbhdnrWrZ4aYD+M4qqVsUATHWtJ4r58a0pluKFS8Kzs6wHcClMMuvZZmItQWP1lM
         9uNblCav9aw3VPdCQ0OjpFAowVfWr4ZNML/c4VzwiP7kQrJhldNg0vtzsydRPiwMJiQV
         NlHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSHAiv7i3ZPXq/DNKZnXawCmfsvz+aNKWacAhSZVlcUvhjIDR2LH2NC/zsQ7CwOP58vbtJKKo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0pQc9AP7Niy7B5gfkglpLbO2wEtIaqFBALOG7SovpRiVT7Wsq
	KE8mXcIbHFdf22uzU7jQa6ZqI/mSSGAOodZisc9ZomdVAfJq/R889cXs7gFSXcCiD+xfWb7NNju
	bJZtnvcTzVPLgXC0kFQC7Nk09zb8bT6Bg
X-Gm-Gg: ASbGncubGwQtPcJTomidKwQNDN3gDoYkQxqUITE0ZZFqoSOmxPTlV3uUjpLVu/FjLph
	mvJyhPVcb4V7jk3vT5H6QOewl2sujKzdltGpX8du/92ujO0VaSWCP0HAjfuC5S0oK2jm6UNmFIw
	==
X-Google-Smtp-Source: AGHT+IGcCBr8faoW1VnoAxsY8E8lL+KD76utgfX3ofSMhWm5Not7DRy6s2/mOVHq0SkC0X4NEOt/szkPpJXxSaFasvY=
X-Received: by 2002:a05:6512:2039:b0:545:bda:f0f with SMTP id
 2adb3069b0e04-545184a2e5cmr1332840e87.34.1739406291678; Wed, 12 Feb 2025
 16:24:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212073440.12538-1-sprasad@microsoft.com> <CAH2r5mtOoCrMwo=O+9XxcSuis2GH_Qo2fXhmXd2EyWGKtoBcMA@mail.gmail.com>
In-Reply-To: <CAH2r5mtOoCrMwo=O+9XxcSuis2GH_Qo2fXhmXd2EyWGKtoBcMA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 12 Feb 2025 18:24:40 -0600
X-Gm-Features: AWEUYZldIzzY3etfIhKCLZvVO9AmPN0tpKOtoafzdS1Uxh4usmgN5Rt7JiJVMEQ
Message-ID: <CAH2r5mv0jw9Kb2vyZxzjkD6LhajpM04HfYhJDQL=Co+xcrRY7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: deal with the channel loading lag while picking channels
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, bharathsm@microsoft.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Shyam,
Could the two test failures in:

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/3/=
builds/386

be related to this patch ie tests generic/133 and generic/471 failing
with hundreds of "CIFS: Status code returned 0xc000009a
STATUS_INSUFFICIENT_RESOURCES" errors.  The only failing tests were
multichannel related.

This test run was with these six patches:
600ed21fe802 (HEAD -> for-next, origin/for-next, origin/HEAD) netfs:
Fix a number of read-retry hangs
9f75ff5536b1 smb: client, common: Avoid multiple
-Wflex-array-member-not-at-end warnings
fab0eddb9fe7 cifs: Treat unhandled directory name surrogate reparse
points as mount directory nodes
69476da76b9c cifs: Throw -EOPNOTSUPP error on unsupported reparse
point type from parse_reparse_point()
ef590eae88cf cifs: deal with the channel loading lag while picking channels
f1bf10d7e909 cifs: pick channels for individual subrequests

Anyone else seeing the same errors with multichannel on these tests?

be related

On Wed, Feb 12, 2025 at 2:35=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> tentatively merged into cifs-2.6.git for-next pending more reviews and te=
sting
>
> On Wed, Feb 12, 2025 at 1:35=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > Our current approach to select a channel for sending requests is this:
> > 1. iterate all channels to find the min and max queue depth
> > 2. if min and max are not the same, pick the channel with min depth
> > 3. if min and max are same, round robin, as all channels are equally lo=
aded
> >
> > The problem with this approach is that there's a lag between selecting
> > a channel and sending the request (that increases the queue depth on th=
e channel).
> > While these numbers will eventually catch up, there could be a skew in =
the
> > channel usage, depending on the application's I/O parallelism and the s=
erver's
> > speed of handling requests.
> >
> > With sufficient parallelism, this lag can artificially increase the que=
ue depth,
> > thereby impacting the performance negatively.
> >
> > This change will change the step 1 above to start the iteration from th=
e last
> > selected channel. This is to reduce the skew in channel usage even in t=
he presence
> > of this lag.
> >
> > Fixes: ea90708d3cf3 ("cifs: use the least loaded channel for sending re=
quests")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/transport.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> > index 0dc80959ce48..e2fbf8b18eb2 100644
> > --- a/fs/smb/client/transport.c
> > +++ b/fs/smb/client/transport.c
> > @@ -1015,14 +1015,16 @@ struct TCP_Server_Info *cifs_pick_channel(struc=
t cifs_ses *ses)
> >         uint index =3D 0;
> >         unsigned int min_in_flight =3D UINT_MAX, max_in_flight =3D 0;
> >         struct TCP_Server_Info *server =3D NULL;
> > -       int i;
> > +       int i, start, cur;
> >
> >         if (!ses)
> >                 return NULL;
> >
> >         spin_lock(&ses->chan_lock);
> > +       start =3D atomic_inc_return(&ses->chan_seq);
> >         for (i =3D 0; i < ses->chan_count; i++) {
> > -               server =3D ses->chans[i].server;
> > +               cur =3D (start + i) % ses->chan_count;
> > +               server =3D ses->chans[cur].server;
> >                 if (!server || server->terminate)
> >                         continue;
> >
> > @@ -1039,17 +1041,15 @@ struct TCP_Server_Info *cifs_pick_channel(struc=
t cifs_ses *ses)
> >                  */
> >                 if (server->in_flight < min_in_flight) {
> >                         min_in_flight =3D server->in_flight;
> > -                       index =3D i;
> > +                       index =3D cur;
> >                 }
> >                 if (server->in_flight > max_in_flight)
> >                         max_in_flight =3D server->in_flight;
> >         }
> >
> >         /* if all channels are equally loaded, fall back to round-robin=
 */
> > -       if (min_in_flight =3D=3D max_in_flight) {
> > -               index =3D (uint)atomic_inc_return(&ses->chan_seq);
> > -               index %=3D ses->chan_count;
> > -       }
> > +       if (min_in_flight =3D=3D max_in_flight)
> > +               index =3D (uint)start % ses->chan_count;
> >
> >         server =3D ses->chans[index].server;
> >         spin_unlock(&ses->chan_lock);
> > --
> > 2.43.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
