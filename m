Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A031F09A5
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 06:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761631339; cv=none; b=OvgOadJhKqniXeQWzfmzDB3t1686o3vDvNNSTmBsUzcWwq851D2HEX/wkAUK5AnXUWSfWi1B7ub2Y1s3zhdFUHTj5nFiPlTrQg7pHpvWRnfl/l9fk4AkRODZNQahqN/3LPNwXBvCbcGe5Rhlr6a9SpH2rZ0Ce3D/uN3CzLSOyNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761631339; c=relaxed/simple;
	bh=JJYFDPtwPw60/e3UdHvVX2lFom2sbXSwKZKRS2FvdVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lEBB2uNvx+yzpwfJkrptRSs8dY9+ypy1A2Fri2zJSVa38n5c8qoDNcXlaIiZ6+1MlSH4dKvLwNfa+8ZzhArJs99pcOrGGB339bSNzaeOg98X5DAoSMLoLJaTEGKydrWwKCrB4MSAovlfR5rq6rZoKFpVEhsv7rzwjqiQzkDEQi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sd4uEf8a; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sd4uEf8a"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c12ff0c5eso10967114a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 23:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761631334; x=1762236134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlARzrWJNBVprd/Qw7crUGx3tMnhy8uCMpOBUPi30D4=;
        b=Sd4uEf8aS/A9jEeHglE0CpSevJdJ8CwBrVmgG7lVW1aDvi/VganjGa/B6Lh3aWFrAs
         xYd3HKX9KEDzicsz6YqLNR4ITNwYrdB2CJ55AuqNx9WUokbvP/fQTGTnesoZrs2gaFw5
         BYPg9lRAiGI0uKGsRlEOt9edz6VkLyrtN3AglIIbRQd78AEQGmTxJdLqMZnJhM8sKNoy
         p5EwoXvGRCSzPCu7U7fHt57aEg/fqGbhA/igAyoL2xUm2tYGWpgMQ3hsrhteVMqj6uyg
         KKe9oxSx70ysswOf3CX8MgSXjze+z2xHGnskIuOzXpoVPFb/CExdMc/Cg8kBsd59m8Vt
         njhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761631334; x=1762236134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SlARzrWJNBVprd/Qw7crUGx3tMnhy8uCMpOBUPi30D4=;
        b=ryGBH8FFUeGZgTqg3J+5wpqogF/nTGTI85WlOIdcDRtXF6NLwwg7IJH5vxBjTmZmyH
         38zPGdX6wSGysSK4Q62GAiA77bY1oMgIOIvF0EQJXOD0Eiedbjm7nBsddhZfmDwKIE9A
         q3BuucqMyCuPG9+o9A5MEdh41G6Hh3iXsMSK04/UEfFe0e9UsFqlxEpKkOgRNleywcF+
         x17hfEmL4Hu6kJqtyczsW+HnC66fc5W03x+cfKbGAOKgIYA2O1cTgcgYY31mLWolUmLj
         Jj2WNRVynR3xxvTMLRXFkTzr7+sf13FJClrkfJzMSAfi+FCKhLAFEoF39iPSt0vuaNm6
         V9Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUP5okVDKBAqdFbzOSGH4MUIY4q3XQ27dAWRDEEwij4mj/gpuo6t6lnbW1EAASR5xX0dZXSfKTuwKyU@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+hTQk7PowSTS+8RKbX1uv0Sa4UmSgh5A9r3B7QAWqbd931EHy
	WUjxYiaJOE+YbmLX4T/Kx3JM2wn0qzhqdZMp+TtSHLIAxbG4d3chyf7ia9ISRI1Kk86Uj23aaiy
	oSeEOtAL3pYQ9ZaW9tEntMiaMQqTq/jtYYg==
X-Gm-Gg: ASbGncvUQVnP7CH26smQqf+aFLAL1EnV4a4eCMB8ewaPdsR+XnkEE0szJgTUqSDzc0o
	86G5EWCUwQzqwfYEH4jLeS3wZxGPutg0Ri4I41ul+cAt1Mrr6sENsqyHV2iOdNtJNKQzVu0zNnP
	wyxzyxHsmQTqCDwv/MUiP2eULr1mmwTYeuDnPLU1Pjf1G9WnHpTCvj4LDiNjl1nCz/CKsle9Sl6
	Y7x3e6PATDfJlQ7cEdT83yW2TMi/0cnmwLYkJ1ImJx1x+KZ/GNJMo+Kftfcac8L/57uUA==
X-Google-Smtp-Source: AGHT+IFxY2I3SNv+urNzRbsowzGuR/Gu+tpbasiHKkLeKU8LSr4Mh13pxE4NFxQBPKcEe9IPwPMPdfbz9CoMVxh8dBM=
X-Received: by 2002:aa7:c14c:0:b0:636:66e7:1a69 with SMTP id
 4fb4d7f45d1cf-63f4dc70abfmr1179698a12.17.1761631334140; Mon, 27 Oct 2025
 23:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027212919.2082212-1-henrique.carvalho@suse.com> <CAH2r5mszqYAxcvuQp+VXMqx1OA--KvqNAXzX0nQN1BeDg6hFJg@mail.gmail.com>
In-Reply-To: <CAH2r5mszqYAxcvuQp+VXMqx1OA--KvqNAXzX0nQN1BeDg6hFJg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 28 Oct 2025 11:32:02 +0530
X-Gm-Features: AWmQ_bmFEdb0M5z2Lxdv8Sw3U3zJFMbKKw7fxu1xo1FOG2Rjr6ezpd5pJ30SS-c
Message-ID: <CANT5p=qooR0ieHbtuG0APbJvF7+F6o7ZMHtezm40kiEWTs+oaw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix potential cfid UAF in smb2_query_info_compound
To: Steve French <smfrench@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2025 at 6:03=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> merged into cifs-2.6.git for-next pending testing
>
> On Mon, Oct 27, 2025 at 4:31=E2=80=AFPM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > When smb2_query_info_compound() retries, a previously allocated cfid ma=
y
> > have been freed in the first attempt.
> > Because cfid wasn't reset on replay, later cleanup could act on a stale
> > pointer, leading to a potential use-after-free.
> >
> > Reinitialize cfid to NULL under the replay label.
> >
> > Example trace (trimmed):
> >
> > refcount_t: underflow; use-after-free.
> > WARNING: CPU: 1 PID: 11224 at ../lib/refcount.c:28 refcount_warn_satura=
te+0x9c/0x110
> > [...]
> > RIP: 0010:refcount_warn_saturate+0x9c/0x110
> > [...]
> > Call Trace:
> >  <TASK>
> >  smb2_query_info_compound+0x29c/0x5c0 [cifs f90b72658819bd21c94769b6a65=
2029a07a7172f]
> >  ? step_into+0x10d/0x690
> >  ? __legitimize_path+0x28/0x60
> >  smb2_queryfs+0x6a/0xf0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
> >  smb311_queryfs+0x12d/0x140 [cifs f90b72658819bd21c94769b6a652029a07a71=
72f]
> >  ? kmem_cache_alloc+0x18a/0x340
> >  ? getname_flags+0x46/0x1e0
> >  cifs_statfs+0x9f/0x2b0 [cifs f90b72658819bd21c94769b6a652029a07a7172f]
> >  statfs_by_dentry+0x67/0x90
> >  vfs_statfs+0x16/0xd0
> >  user_statfs+0x54/0xa0
> >  __do_sys_statfs+0x20/0x50
> >  do_syscall_64+0x58/0x80
> >
> > Fixes: 4f1fffa237692 ("cifs: commands that are retried should have repl=
ay flag set")
> > Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> > Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/smb2ops.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 0f9130ef2e7d..1e39f2165e42 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -2799,11 +2799,12 @@ smb2_query_info_compound(const unsigned int xid=
, struct cifs_tcon *tcon,
> >         struct cifs_fid fid;
> >         int rc;
> >         __le16 *utf16_path;
> > -       struct cached_fid *cfid =3D NULL;
> > +       struct cached_fid *cfid;
> >         int retries =3D 0, cur_sleep =3D 1;
> >
> >  replay_again:
> >         /* reinitialize for possible replay */
> > +       cfid =3D NULL;
> >         flags =3D CIFS_CP_CREATE_CLOSE_OP;
> >         oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> >         server =3D cifs_pick_channel(ses);
> > --
> > 2.50.1
> >
> >
>
>
> --
> Thanks,
>
> Steve
>

Thanks. Looks good to me. Should CC stable.
--=20
Regards,
Shyam
