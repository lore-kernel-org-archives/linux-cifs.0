Received: from mail-lr2-f3.google.com (mail-lr2-f3.google.com [74.125.230.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C132DC79B
	for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2026 03:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791602622; cv=pass; b=qiH8y5rYWRX//17d4y2qAC1zXCAUqT7hiZZT0q3RKtZ+EK8qcE+7ZNzFIfiGCZvQJKdMwFP/5MqZPcGnNgYPEZnyJAugf4/agBwtxge2HTdVHU6njPaOmmYyQ+BUO7mSDIf/UVpZ7fNfAtEw50CLbPKJmuWFAKDP5y8utlIiZKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791602622; c=relaxed/simple;
	bh=DilpxP77Wf5IGboFkUym9zfEMniRVTNtL7kIYRWXCaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UhS8eVfpvpQu6nenjjyzBuYs+LdaRvhietbkIa1mmhtiXXXSiC2qFEg/v7o1OpeXv+b1O+LabU9j0zAhiWbybl0kPsEHjqZdUMOCv1AZv2v5ten5AunJf5C+5ra8ZEcuaeu0DyDdtYCxKBjechPrZWQZxwlEtorVUXQZd+o8sv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iy9l2wXq; arc=pass smtp.client-ip=74.125.230.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iy9l2wXq"
Received: by mail-lr2-f3.google.com with SMTP id 38308e7fff4ca-3a77f4bc209so2956241fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 20:23:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791602617; cv=none;
        d=google.com; s=arc-20260327;
        b=i5r9JBL/dRQicc0zU3WUdK3fAekvrSYnBD14n3QGa+GLTBFXwGkOCmi6Vi62tApsJK
         /qw6QWIz2LogQolsWp64BFNg8TCkwN9Jr93rkZu6I3nWu8W277XuaA+HRe0PCWED9EMs
         +Mp4tkH1cdX+nj6jr6KAsMbAMVIPSSpiciP5DO5cvLMq8O8p0Yz9rof6qEHY9DWfRCkh
         /LWypNdFoueF0mEiSDq3ddiN1Hi5P5MDKELhoQcrkQYtNonDuXk6RioarwXnJMHlwo9H
         rUj8HtkUsVHmQQ5ZEFgMn5jfaifAroSMBXMaiHWY38K9Xu8WadWpMn2fFfsc+fTEJoYM
         YutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vieoj/AaG5T84Kvl4ASa8xKsULW9X7IG5LBpCgMJAnA=;
        fh=JFtkVqaE+rl7/mCLSKctQonPCT2DPVYu7OoTRN+vXyU=;
        b=jQeCRgGpx2kYxRYxUmcLhs9wy+/irnTR5QZMHXWBuxK1OgVV1978yqlONBVrtXNsh1
         nfV9sYzZTNiie+zfABV5M7GFmfNg2R8DNKzICYLSepOsn8gQEogWoVquoxQ4yYfUYFxI
         cn67FbyLZNnAp17g6ShD/RXIv8Ic26fzGK1D6Jo2G+xOVeeJnu4tSJCxXStJK58JVUxS
         4EpncbXWOOJwrTUkPAvokJDCesc37zLynB+iKh8IEfgSSgINwXHxGHuTlX+91DluMEIb
         X6hZyogOdWjZ37jtMcFisfJUv/9UC19++a2FcCQsOAeOb63Buog8GKiGm3JkdZzx+GCe
         6DGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791602617; x=1792207417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vieoj/AaG5T84Kvl4ASa8xKsULW9X7IG5LBpCgMJAnA=;
        b=iy9l2wXqxs450eRlYYluXw+MWY1jZUo5eEy2HK9P7AhZRvHGzif8YV2/PI7V4uSMq4
         zze9yMaEWfjG5aavLkL8YTBS2sTJF7nHf16ddDDulRdQP1p7JDSNbyN/hCwxdh7Mi3x2
         o6oXlGFPcniIRo3RlexBjlk7INFFCPA5uOLhprd8YiP5SjWFFBH0zk7xt+U9VbTjkpRc
         IhSzYfXvy+eU7FKtFc7EQ0wK94DfRBSwnG52EPZ1L83L+Rtru26xZKoQJAjlsMdw8uuX
         cGn/d8nDMFicpHj8xYl9d1G9DPeP/d8b1PlxGbC9LhJ4WWVqe1QJj/sr20Bgtx2A7nFC
         SqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791602617; x=1792207417;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vieoj/AaG5T84Kvl4ASa8xKsULW9X7IG5LBpCgMJAnA=;
        b=nyAHGPZbR5rjDlDMpIKDLogcIUUcw9qh4lX/9I8rPClCfHHEETAh1ldKSzGOV8KMsi
         +Zuu5e83wUWZ3Hg2Q9MTqvMb/l0ymhcVKQ20/WrNOPUUC4GFBpJikJxbhlQVZ+gLDIms
         i8ttU+z2v7ifPD31REWBOlfiiTlektGp+ObhoWw3f2up7MKo7qdsjk/xZ9cgtpYtxPfh
         PpQUcQyLlsb3vTdE9w3V4WmTfOedC4dJjt618nX6LhuLkidfnQu+aE9ouTIhgKNcX9I8
         Dyc5vlR23ouDkDSPgjBPzw6+Xb59EHpei+eWOe1+1Gi6kJGlFF8vSBJDKk/QaGWe1Iw8
         zUxg==
X-Forwarded-Encrypted: i=1; AKwUvBxODIuwwPSyHp+uuTLw3JPS3eRtIv87rE3aW+GcS8vRqhcEA/lActX/Oca35m60UEEzj7FyjlaaVRUZ@vger.kernel.org
X-Gm-Message-State: AFq9FYIkR8V7xtvrLiKsVOBPTB2GB7MGBJKoFXJxmijytDhtqb+E8aqt
	PRPbGnMsukKM7APHBup/irEKy8jrBCER8+iF8mUJl18HeP/rL8Jc92uJ2K2T5cOw+salcUcgudd
	hVmm6/PSrKGja/lqDMmKDqlUYba/uKH8=
X-Gm-Gg: AYBFou2O7RkaMRggdRQtn/RWEpbNsKdOJATS3ThLRqJA4XDF3WfmncN2MlQ/K84TRvL
	r+iTrkElKK5bzTLSp0iLhXadHLe9voTFyJgJGraHClKy/3p02c1bIiY6bihyE7HU6LpIs7UgXuU
	NAvy+XzUyx6Gwd4g1ByJ5cSFMJsqMIi6ElPYKiPVBhJPUHoaviELLHrC1bTE3lYQqI+d+w106Wb
	4RxXsyxCElno1LOa4wgojcqqP5GSfItXQ4ZxCP5LLpKbxZ5//JDBc7KJrj56mXCKcUGjFeTDvy2
	DMxpyswnzqNM+NIntkm5GN1ymQZIn2iZGsoN/dcQofaZFoCHrQ1qWTDQ
X-Received: by 2002:a2e:be0d:0:b0:3a9:707e:ad88 with SMTP id
 38308e7fff4ca-3a9c4eba34emr9355861fa.2.1791602617190; Fri, 09 Oct 2026
 20:23:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009080252.2805877-1-bsdhenrymartin@gmail.com> <CAKYAXd8MyiCVhdN_PaQ=aSEO3yYYQ-Qb-2TnC68o0_pbchM0mw@mail.gmail.com>
In-Reply-To: <CAKYAXd8MyiCVhdN_PaQ=aSEO3yYYQ-Qb-2TnC68o0_pbchM0mw@mail.gmail.com>
From: henry martin <bsdhenrymartin@gmail.com>
Date: Sat, 10 Oct 2026 11:23:24 +0800
X-Gm-Features: AclHuK-ClitBdOErynduKFQRc6WJDbowcHXBQ97nLFTy84wq9FJpNr2s6fS0Too
Message-ID: <CAEnQdOrta-P0OptZ+6qCKGxHN00=fR71JhjdP1b75bS+3EMFyA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix use-after-free of server info on
 cifs_ses_add_channel error
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Steve French <stfrench@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jeon,

You're right, thanks for catching that.  chan points into
ses->chans[], so once chan_count is decremented under chan_lock a
concurrent add_channel can reuse the slot and overwrite chan->server
before the unlocked put reads it.

v2 caches the pointer in a local under chan_lock and uses the cached
pointer for both cifs_chan_clear_need_reconnect() and the final
cifs_put_tcp_session(), so the reference we drop is always the one
this error path took.

Regards,
Henry

Namjae Jeon <linkinjeon@kernel.org> =E4=BA=8E2026=E5=B9=B410=E6=9C=889=E6=
=97=A5=E5=91=A8=E4=BA=94 21:32=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Oct 9, 2026 at 5:03=E2=80=AFPM Henry Martin <bsdhenrymartin@gmail=
.com> wrote:
> >
> > The error path of cifs_ses_add_channel() calls cifs_put_tcp_session()
> > before cifs_chan_clear_need_reconnect().  The latter reaches
> > cifs_ses_get_chan_index(), which dereferences server->terminate; if
> > the put was the final reference, TCP_Server_Info is already freed and
> > this is a use-after-free.  Same put-then-use pattern as the recently
> > fixed sibling in commit 717e0a25036b6.
> >
> > Reorder: clear the reconnect bit and drop chan_count under chan_lock
> > first, release the server reference last.
> >
> > This vulnerability was discovered by Tencent CodeBuddy Security.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: ee1d21794e55a ("cifs: handle when server stops supporting multic=
hannel")
> > Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> > ---
> >  fs/smb/client/sess.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index e095f41b5882..650c0f855a29 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -626,12 +626,16 @@ cifs_ses_add_channel(struct cifs_ses *ses,
> >
> >  out:
> >         if (rc && chan->server) {
> > -               cifs_put_tcp_session(chan->server, 0);
> > -
> >                 spin_lock(&ses->chan_lock);
> >
> > -               /* we rely on all bits beyond chan_count to be clear */
> > +               /* Clear the reconnect bitmask BEFORE dropping the serv=
er
> > +                * reference: cifs_ses_get_chan_index() dereferences
> > +                * server->terminate, and cifs_put_tcp_session() may be=
 the
> > +                * final put that frees chan->server (use-after-free).
> > +                */
> >                 cifs_chan_clear_need_reconnect(ses, chan->server);
> > +
> > +               /* we rely on all bits beyond chan_count to be clear */
> >                 ses->chan_count--;
> >                 /*
> >                  * chan_count should never reach 0 as at least the prim=
ary
> > @@ -639,6 +643,8 @@ cifs_ses_add_channel(struct cifs_ses *ses,
> >                  */
> >                 WARN_ON(ses->chan_count < 1);
> >                 spin_unlock(&ses->chan_lock);
> > +
> > +               cifs_put_tcp_session(chan->server, 0);
> As soon as the lock is released, a new channel can be added in the
> slot indicated by the decremented chan_count. Then the final put will
> act on the new channel. Please save the server pointer under chan_lock
> and use that for cifs_put_tcp_session().
