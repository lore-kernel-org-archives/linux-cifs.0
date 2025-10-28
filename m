Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E10334C2E
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 13:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659048; cv=none; b=VO0xk3/NTLqTfDsMNDS1rB7r3p8laen4+CV0S00IICQ317Gw2DNRP6Uf4t8j+OzajcHju30Yh/HOVoDBQFIRnBfYap9cQcnEo+v5Zv1pT6y/uzKIyOE+gWS3S0nXY7h2IKJeOZ0ut7VHr2GTFop61vPbKlgg9xNC7TprEnloW4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659048; c=relaxed/simple;
	bh=EXBWS4FRbrtoz66Oh5+WL9INm/B3cJR2hXjxORL8LrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bajFC/H1BMgSS2Swt8wAI2vervzK6WaxbxRgXkyaICfwtB56/3LxuoRuIfWcaclSU+WiruMSR64VGNYDNmFySOzlxoG5b+KDRgJtksBEIFnnogaq0/85xnDs+gWE1bdnSyXlT9/n77ETh8yB+xJsusWh2aTMctUy8JICDkJGB7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=giGyV6wI; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="giGyV6wI"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-78f30dac856so68526496d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 06:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761659046; x=1762263846; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rSJYzANYlfbndGglc8/K4z8OqiM2GfifuS+s2hRORM=;
        b=giGyV6wIOlRqVNn7JG+m/g3ppv4y+bzNp66ZRIIMOiTQMIw53xsAP5UQyXWY8LsEd0
         N+cSApPXNxB2AVUe5VYV3E608OMZVyg5kLipCl7XPCpwhex1uDO1PU6DPYsgkmwZB8VL
         wNtPZKv92FdB/YURWOk+Y8TGlQehbw2YRsUNq3MsptPBaAnzFd7phxIEEVIjJMAdrW1a
         ih9T5Cz/UHfQCNOqNFhJFx/auCt/7g63RIU+d4INp8iLHgvlZRUPzCOkacTcP9iRl6yw
         CCDB16zG7jUHsYXClYlTZCNrJyY50gkV019MC/ippdBYjSkin9fw+/5x92VYc1p1eDwY
         3igQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761659046; x=1762263846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2rSJYzANYlfbndGglc8/K4z8OqiM2GfifuS+s2hRORM=;
        b=g2hxBxoz7MhnxfO0j4fNS0qblASKDFpX9I1ZbSj1LgrobmpoOcV7TGKrY8eW5BX/JH
         BQTDG2n1wdlvx/K7ElR055GKKuM7Mpkjlt6BlMuROmmefs119mGPDSE61t3kBOwZSg8P
         qXejUBMSGYwU3r0HSZbiFGxCtIjDl+Mi48vA0/e4UFN17wtvxqaSyDii7jYX59DeNEJ+
         +Wyl2V6mVbHNLehjNPwDG+DZVQAv0+aYMbHNNBnbtLaCKJf4qzV8y8qvq3TnafrLumUl
         yioYsf65/YYSVWoeXLXXbsxjWCKO0OjGWThFKAS9d94Z2mT8fsY3TNFPWGwLifjXmK7j
         bZbw==
X-Forwarded-Encrypted: i=1; AJvYcCXW60k7x8OWgGJe6ENB5D1wS3q30xVRAR6weVrGdBiBANPriDnMcadt3f1acIRFtlPbHDOKnhcqd/hu@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt7BPjm7YWBgHiQNqo21j4q5jMU43rnQM3bhMblzf716/15zJn
	hkpBSHA1vgB9LlKBc+idcz+5olieOMWYw4ynVtdxEg+VRtIcLTmdO7KxVaG2KvkkYXf6WQ1p0Mp
	33ek43QzXtBqiob16wCVMyRdIyETxUJ8=
X-Gm-Gg: ASbGncsu9YqCeNkBl/rRTEsY2S0LjZi0wYhUebNhsZWEMhVdqQBdZSKPqexooTfwWWf
	izpZmceBtKj0SMmXXyHzyl+WkzkzCu8yh2ejFg7Tc4vv52hStmAfjWNwqkR/6pYFHudJujr1RfX
	UBJe3eLZgKgXm1i8HiQi2F0hMA2A3RSwtzk3fGGkJ49RjiMtQVu5jCDeGUIzsoDwYkSmB959EuM
	EU9XcT2rSedWlRe2XCS283uVflMSU41naj5ohiVbsf2dnrIkNhx6/yJuX76LApiQqVwLAzKm7Ii
	nBW3U8uwW+xHecYV8Nv/FbqBDHoxmxdCLwxoPgHGwGoUOdUWd6CzEsuJS3ooBwNjrIQgnhhiqiZ
	bxCabzb6tjkj76JrXZeKaWhXjzpavmzqyYAb4z6amjA==
X-Google-Smtp-Source: AGHT+IHwqWEDw82xQO+E8D7OHUOzxARr1PrVXRKPbZouWAFWV64wvpD0MJypEIh4SoR1mUUKw4DPwBhYXq5wpUznI54=
X-Received: by 2002:a05:6214:2624:b0:7f5:6df6:6ce4 with SMTP id
 6a1803df08f44-87ffb0c5171mr34214076d6.33.1761659045969; Tue, 28 Oct 2025
 06:44:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027212919.2082212-1-henrique.carvalho@suse.com>
 <CAH2r5mszqYAxcvuQp+VXMqx1OA--KvqNAXzX0nQN1BeDg6hFJg@mail.gmail.com> <CANT5p=qooR0ieHbtuG0APbJvF7+F6o7ZMHtezm40kiEWTs+oaw@mail.gmail.com>
In-Reply-To: <CANT5p=qooR0ieHbtuG0APbJvF7+F6o7ZMHtezm40kiEWTs+oaw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 28 Oct 2025 08:43:54 -0500
X-Gm-Features: AWmQ_bmAeoaachRYf6X6abev5imiqInXJc2L6S9uI05theQtvIymh5rF41Wax48
Message-ID: <CAH2r5msT3tWaFXTGNhLMZDobZ7f=uKeNZQH3QfJ=WaR1srz43A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix potential cfid UAF in smb2_query_info_compound
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2025 at 1:02=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Oct 28, 2025 at 6:03=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > merged into cifs-2.6.git for-next pending testing
> >
> > On Mon, Oct 27, 2025 at 4:31=E2=80=AFPM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> > >
> > > When smb2_query_info_compound() retries, a previously allocated cfid =
may
> > > have been freed in the first attempt.
> > > Because cfid wasn't reset on replay, later cleanup could act on a sta=
le
> > > pointer, leading to a potential use-after-free.
> > >
> > > Reinitialize cfid to NULL under the replay label.
> > >
> > > Example trace (trimmed):
> > >
> > > refcount_t: underflow; use-after-free.
> > > WARNING: CPU: 1 PID: 11224 at ../lib/refcount.c:28 refcount_warn_satu=
rate+0x9c/0x110
> > > [...]
> > > RIP: 0010:refcount_warn_saturate+0x9c/0x110
> > > [...]
> > > Call Trace:
> > >  <TASK>
> > >  smb2_query_info_compound+0x29c/0x5c0 [cifs f90b72658819bd21c94769b6a=
652029a07a7172f]
> > >  ? step_into+0x10d/0x690
> > >  ? __legitimize_path+0x28/0x60
> > >  smb2_queryfs+0x6a/0xf0 [cifs f90b72658819bd21c94769b6a652029a07a7172=
f]
> > >  smb311_queryfs+0x12d/0x140 [cifs f90b72658819bd21c94769b6a652029a07a=
7172f]
> > >  ? kmem_cache_alloc+0x18a/0x340
> > >  ? getname_flags+0x46/0x1e0
> > >  cifs_statfs+0x9f/0x2b0 [cifs f90b72658819bd21c94769b6a652029a07a7172=
f]
> > >  statfs_by_dentry+0x67/0x90
> > >  vfs_statfs+0x16/0xd0
> > >  user_statfs+0x54/0xa0
> > >  __do_sys_statfs+0x20/0x50
> > >  do_syscall_64+0x58/0x80
> > >
> > > Fixes: 4f1fffa237692 ("cifs: commands that are retried should have re=
play flag set")
> > > Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> > > Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> > > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > > ---
> > >  fs/smb/client/smb2ops.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > index 0f9130ef2e7d..1e39f2165e42 100644
> > > --- a/fs/smb/client/smb2ops.c
> > > +++ b/fs/smb/client/smb2ops.c
> > > @@ -2799,11 +2799,12 @@ smb2_query_info_compound(const unsigned int x=
id, struct cifs_tcon *tcon,
> > >         struct cifs_fid fid;
> > >         int rc;
> > >         __le16 *utf16_path;
> > > -       struct cached_fid *cfid =3D NULL;
> > > +       struct cached_fid *cfid;
> > >         int retries =3D 0, cur_sleep =3D 1;
> > >
> > >  replay_again:
> > >         /* reinitialize for possible replay */
> > > +       cfid =3D NULL;
> > >         flags =3D CIFS_CP_CREATE_CLOSE_OP;
> > >         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> > >         server =3D cifs_pick_channel(ses);
> > > --
> > > 2.50.1
> > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >
>
> Thanks. Looks good to me. Should CC stable.

Done. updated to add Cc: stable and Acked-by


--=20
Thanks,

Steve
