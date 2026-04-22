Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D463B311958
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 15:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776871766; cv=pass; b=gjGPRfiKe/KDsotjcPkxWlhTubBH0ADQ9AFkP9mvY/F8ps6kJSvKK8+28GlqFKM1HnW9dqmtHJYcu5kv1J6hDKN9wHHhGesostCIa2eqPgUuD8xqlnPA5ozuKTGaY1oRpnvgFxfUjk0IKU+3rGL9blHYoECLMOf8YXrvfsZwGgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776871766; c=relaxed/simple;
	bh=bbLgZYOE6AJ8jCHJdOL+09lkP2yh7pe5MIuIIg2uedc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pXWMI1tZPLn8mfwEAEGCtrQoPwsZWy5NfH2xHJmhAKBYQ9doLTbXq/mS1vwP7hZl5hMHZjHJawYud5B6sQ8RILYaiC8D27IFvxtLfJCAMlLHDA1rMLJJqvKfalsdSW4xruEfOyUoFn4aTvPtDQ1KZ0q3tOLFJWBTidYRGkBuL2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJFA1y9D; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJFA1y9D"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8b1f2b7f1bcso28579796d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 08:29:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776871764; cv=none;
        d=google.com; s=arc-20240605;
        b=T6xDnhjQhAyJ2Nom3ERwS9Zrb4p3defTjQ4ZbI4Cxd5VNJ0nTT4sNYjNBem+CZYSxT
         zuEWTCO3TRl/x0QKVLySnYzm5RiguLjjVLmWetUO0teDjTcT/xuDsolJjgxGJzuvcmQB
         ar9HrOBouqKVM75S57ZN4QYGwIyAWFml79y8rk8y+chYVsfzYA031qyg7xr/RLfZsXF9
         O8uXBc1fT6imyA5ZK2zBtu4LauoNGtp2cdrS4a3nwKnV5PvTo1jis4XLNujKy3uP28xf
         Q7RSNIac6hDOPk88NlS78NluksvWpziqDFy7lX8pPE94Zl4TufVrdEuEZIZuBThvLHma
         H+wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YevzQRrNOo+gPhQzBoD7Ww0WDkuG/7kV8jzZyPSOCII=;
        fh=WqSlRZUUv0YdjgVols29NNCCkFk+gQ3WrQ911Zauug8=;
        b=W0QDPKX7xI2tvSRT3xyArNDkkoLxiWHrlvj7oLV3bACM8Do2GKqje5jqfXPEYhugWW
         +PX8JkI3WnezVg1OiS/vKre9u835YcE0iMxMwGpGRI+xuOJ4MO4xuw0Vx7+kKXkk/GjK
         KexGqGTb7uqV90T/HYhmreCsGlLE2RNlnrcCD7RaNG4VHXydWjqNANThQQkZMP/GPaZd
         oc3/LZ0NrJ/PGd1L5+1X9kXYe+EPoXBvSIImjotK0lK9HgIMp0aezqntXCgrHnaYr4oC
         SVpl10oalVVcQsXJCUSmRYNMwHW6JFuMcWfoz830QD7ynqjmuZrKKflir4OzpuYKWuai
         3ECQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776871764; x=1777476564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YevzQRrNOo+gPhQzBoD7Ww0WDkuG/7kV8jzZyPSOCII=;
        b=VJFA1y9DjA9qvnXrj4ieCVU7XnD1sm0T75WK7jVUnJunqYcLvIJvm2U5QKxZoV82uk
         Bc8DNjIWLzZDabj6Wo5XG3kit71pwx2VMKVH6MeOdalNYJTmsnAh93rdHGDAC7fiKgao
         8UW+TUUBcbugcP8kxoHf5MXb0kaEddZct8+oDv7J2C/KGj7hdp6ypZOVWBh+CdSzts0O
         d/p7+msy8HZqwQf3/vju+0N0R3V1BD6L0R59oh82zZ7tIQVVqCHaAT+FNeorAUxor8uI
         QvM6v+VVOsv0UNlw3L4Wnkib7c2ceOKnALko1w/02wMCIPfR4E7joOMae6pNR0Ekx5wA
         +H1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776871764; x=1777476564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YevzQRrNOo+gPhQzBoD7Ww0WDkuG/7kV8jzZyPSOCII=;
        b=Rw1iunDDEBLalZQmTSJ1PPRAJNXUaHeXN7i8Chw0ZMhI5CQkNjn6sevkTPJo/LJuDS
         KDrULobCY5zVRIiJZMMaswlxWZHI2r6+eTX1vnwMtaMkVPXKB5QqB049HK9zRztjoBZo
         LH5L5lhWgLa+J9o+A+b3ro+n3457TjBdeC77jgZt4mDRAU2foQmqGQZUigWhDoIx6xAF
         vAn+PtGJe8lMYU0saqvjvSqycZ16rd2A91ICflTckTG/QKbn9Qg/O789hy+6vsRSyuiw
         uJnV8aATUvamBMtqpRexibOox5xJZlbNauzTkkbks7jrs2uo4UOUv2D/ROy8sw/GufXc
         yz4g==
X-Forwarded-Encrypted: i=1; AFNElJ+jGr/cYw0lh1qOjWGuAK+wU6pNeChaE00F7T1VZe72ejL1m7N1Ccwcn1WTqTTpkSSHLuhDGflsA5HF@vger.kernel.org
X-Gm-Message-State: AOJu0YxL1ApN+0dT0nXJaTTRwM5BO8Y8BLNrHbSugq1eTv8lMTB0tchh
	2oo9bxlX9UeAv48pqdGiVowGxtIwmWPHqR2DUAAdyZAZsm/0JrI2RqqwKzpxR80CQUdc9rFbs0e
	Jee0Tjx/y32XnaepZXFH1HD+6JV5IPeY=
X-Gm-Gg: AeBDieuQOgSKsdlaIDC/sJLcDGHJqs3cCCrCBO6EIE7XCJ0MNgulS7foGvLTvWWwvFb
	11l95gdZBfvXC/m04Pkosb0dCeBOhvXR87igwlvWtY3mzRXBp46RZDveZOywkFQKmkNBu+rTgnz
	ZvIDeEGK2fS+ivVlvYiDUAOwKr1WIWaWNaLbKRqdeg/grMvln/iqYCi3FeOt+tllSGNS8bMj/xE
	YgcplPtMPyNfcFN1Z77oYHc/1GCuICa348q1eltUxOVJt43z6sd1JaPYVb3TxsdkcsihZ6CFZoh
	TOK6wg5rWGX3gORTFbVbvmWFVPqgjLmwBbESP2N5qqjK5I9APsZriFw2k33R67wUh9Nh4TGsN61
	EnSET/5o/wa6ocdCSjSkhtdDn4tVeGsn/WwbvwMH6QfEbnc6HKl9jAtCI1qxix5wUED9XOWE83Q
	==
X-Received: by 2002:a05:6214:5193:b0:8ac:aa89:6bb0 with SMTP id
 6a1803df08f44-8b0284715bfmr318019846d6.11.1776871763712; Wed, 22 Apr 2026
 08:29:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-6-rajasimandalos@gmail.com>
 <20260422050613.1136327-1-rajasimandalos@gmail.com> <CAGypqWz-rThJ3SaeJECy9mG3e+CCmozkns5k3UyatdVuXSonjw@mail.gmail.com>
In-Reply-To: <CAGypqWz-rThJ3SaeJECy9mG3e+CCmozkns5k3UyatdVuXSonjw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 22 Apr 2026 10:29:12 -0500
X-Gm-Features: AQROBzD91lrmXYvq4wHXIEaxzvSoMkIWPbELbnmYGOPhVZZFVsApizFNjO5hwg0
Message-ID: <CAH2r5msBOKixrOyyeEt4Es6W3eABVFMx2iwMcRakiRvD6fYatA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: allow nolease option to be reconfigured
 on remount
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: rajasimandalos@gmail.com, sfrench@samba.org, linux-cifs@vger.kernel.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 3:37=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> On Tue, Apr 21, 2026 at 10:06=E2=80=AFPM <rajasimandalos@gmail.com> wrote=
:
> >
> > From: Rajasi Mandal <rajasimandal@microsoft.com>
> >
> > tcon->no_lease controls whether the client requests leases from the
> > server.  Changing nolease via remount is silently accepted but has
> > no effect because the value is never propagated to the live tcon.
> >
> > Add no_lease to smb3_sync_tcon_opts() so the flag is propagated to
> > every tcon on remount.
> >
> > When switching to nolease, close all deferred file handles via
> > cifs_close_all_deferred_files_sb() outside the tlink_tree_lock,
> > since closing deferred handles can sleep.  Deferred handles retain
> > active leases from before the switch; without closing them, those
> > files continue using lease-based caching despite nolease being set.
> >
> > Both transitions are safe:
> >  - lease -> nolease: deferred handles are closed, future opens
> >    get OPLOCK_LEVEL_NONE.
> >  - nolease -> lease: future opens request leases normally.
> >
> > Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> > ---
> >  fs/smb/client/fs_context.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 45173f287f00..fb59b45c7f66 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -1317,6 +1317,7 @@ static void smb3_sync_tcon_opts(struct cifs_sb_in=
fo *cifs_sb,
> >
> >                 spin_lock(&tcon->tc_lock);
> >                 tcon->retry =3D ctx->retry;
> > +               tcon->no_lease =3D ctx->no_lease;
> >                 /*
> >                  * Note: this updates the limit for new cached dir open=
s
> >                  * but does not resize or evict existing cached dirents=
.
> > @@ -1325,6 +1326,14 @@ static void smb3_sync_tcon_opts(struct cifs_sb_i=
nfo *cifs_sb,
> >                 spin_unlock(&tcon->tc_lock);
> >         }
> >         spin_unlock(&cifs_sb->tlink_tree_lock);
> > +
> > +       /*
> > +        * When switching to nolease, close all deferred file handles.
> > +        * cifs_close_all_deferred_files_sb() handles its own locking
> > +        * and must be called outside tlink_tree_lock since it can slee=
p.
> > +        */
> > +       if (ctx->no_lease)
> > +               cifs_close_all_deferred_files_sb(cifs_sb);
> >  }
> Similar to deferred files, I think we probably need to invalidate the
> cached directory
> entries when we remount with 'nolease' considering 'nolease' is a
> superset mount option
> and should affect all types of leases.
>
> One additional case to consider: if an application already has a file
> open with an RWH
> lease acquired before the remount, that handle may continue to hold
> its lease and benefit
> from caching until the server sends a lease break or the application
> closes the handle.
> Is that correct.?
> I think nolease remount only affects new opens; it cannot
> retroactively revoke leases on
> existing active file handles. It may be worth documenting and/or
> comment this behavior,
> so it's clear that lease->nolease takes effect gradually as old
> handles are closed rather than
> instantaneously across all files & handles.
>
> Other than these comments, change looks good to me.

Should those changes be in followon patch rather than adding to this
easier to understand patch?

--=20
Thanks,

Steve
