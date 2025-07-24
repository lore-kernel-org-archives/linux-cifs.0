Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CF02367CD
	for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 22:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753395262; cv=none; b=MUil1H/WoZlIrLyDun35CFb9Am08uIziVU5OznEYpBDLBx/g63k4z0ugmr7diHkuz5pv+eT1/P2em20ePA939RRTcLlE39/wka4Kp02QatE0uv7xHGLtnbUet39caKdnGhchekB6qL+gEULHCtOTLv0b9IhdQ2QXV8ifzb3UaAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753395262; c=relaxed/simple;
	bh=0OaXjDbaAyAoENMEZDxPyHAvLJNP1qGbcmmGUEJtUYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UxSADVCPObDBTEylK4desY7indqLBFoRsl8S3a7/GQNeiPQAqw2ca24Vp2flHejgmj5n+yzqg6IqVrcOzumacWaUb+QR+Ynbv7UDYDIPhe90fMyoOG94rPN5l3cYBkKmx8zd7ANpV00lkgI9rvzO/37C8kEuKq68uai0QNtO+e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fs6VEH6F; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fs6VEH6F"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6fac7147cb8so19959766d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 15:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753395256; x=1754000056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZnVVLlrcEVEr5hjD+iZ2LCCZaPGWsO8wLtJ8esj5Oo=;
        b=Fs6VEH6Fa3OcyheABTOPgJtR1uLO5MGsiLPFWv3aoESpRLAVdhW10UsZWILqcSWnVV
         0N8bNWib2L2uQGfPhWq2PSkM1l1xuLIIZOQvVDZ9YNYUKY5G9LkHxkZ0Wdi7OQ0pGCva
         ws1u4cFj9yblAxFcPlPa3zENjS4am7BqYQtpj6G88Q9yR4Us0DCNo/480pw+VluJ6YEX
         hIwJPVQxGkrCf8uiwzi18YbIIyW5yNSe+UHcF35npPlOcDbYPLF/PQAfejvgRIrVMfdO
         taonszCtlVW/iuO+feCRrT0rW6DI6EqB4BgN3Zz4uuAh56mmWAPgi25wMjvBEDPK0PQI
         2LUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753395256; x=1754000056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZnVVLlrcEVEr5hjD+iZ2LCCZaPGWsO8wLtJ8esj5Oo=;
        b=E00ZIP3BQfdC9UKVMZ/nOUJhXa1KxOEEBy5828XFIPMPJx6rrLAzU8LUsQeircuBBH
         8Tsp53e1OxC/AaRIAXReiHLf2MN0LJTfzciYiKAmwfgpZoEB2/uZTn1UYPCCs2Z5MDDo
         XrYzNDR34feAgeG8cWZCary0/MF8iGKAvxbcu8PExBV3ybIkycvrGL3boQLBckbai6H8
         28Kpm6uojupEoWG40b+Y16pUdOUiU5XH4WjOUpeW7Cjq6br8l6jewBnJDXa0d6AR84EC
         KknkVJ+XfYviVd+3e/rYarF1xsn91fyG1gmD15j6df/FtC1AwuSsXuKzOtOFlTauxFEQ
         /Bqg==
X-Forwarded-Encrypted: i=1; AJvYcCXz4ztfMUQKcH1Zs1WjaJV7zh+CCTnmvdvUJhtlg4Z2/97Jx1lLo531DAowo3sHYBfi8O+kRLzdR2tR@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq5N07DH7pJHZpqV45+8aLn4U9NBbXnJJMOIoVYgRxSB6emq6Z
	pr8ikEI7Wc7/qwsSTYyAN+pPefDxx9rgMpscg92yxYZJj1fy3hoKtxH667kYHhcskHS3i3t1wh+
	bSCL33PnSkU7YQZKfHGZvJJ3fd2rfmrg=
X-Gm-Gg: ASbGnctcdUuVYp14jU7Y2B5FEChRkv4O53MCmCwxhz4iKrNpibaR72uOWOQcGodwAY5
	F+lqF4vviTeGrUzX9AMOLHfGxGCG/m4bPH8wQd0XRmNLQhRz5jrMqJCFpBLOmMlyfC9dPyVSgji
	mlmqVFGkUih2svBbx1bNNpoNXyZGd/1l6A9GZcy/553A22nOQxD2QwHuISiWYHNl218+E6PnC/t
	CKfVOgcrICJwLQvXRn6MThFpmrSnyF0oDK6dqGE
X-Google-Smtp-Source: AGHT+IF8lDKSbsv7Xt/nQAjmr0n187VN1liTWXgRffnaeVPKl7Hh/ao0HbxePDhr7FOLi4zRLbWtVLZlLhWSozAVqFI=
X-Received: by 2002:a05:6214:2022:b0:702:d7e2:88b7 with SMTP id
 6a1803df08f44-707005d411emr108291256d6.6.1753395256336; Thu, 24 Jul 2025
 15:14:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516152201.201385-1-alxvmr@altlinux.org> <43os6kphihnry2wggqykiwmusz@pony.office.basealt.ru>
 <3d3160fd-e29d-495d-a02e-e28558cfec1a@altlinux.org>
In-Reply-To: <3d3160fd-e29d-495d-a02e-e28558cfec1a@altlinux.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 24 Jul 2025 17:14:05 -0500
X-Gm-Features: Ac12FXxtNpL-4toS9CgZ6_OrmNbwHgoMuFbu24XVtF_8dGytiZG7QyMPJoZDvsg
Message-ID: <CAH2r5mtG5pwFMRtu3EeXKPBdq0LJwjt84SbGtL0J4QuCg+AsgQ@mail.gmail.com>
Subject: Re: [PATCH] fs/smb/client/fs_context: Add hostname option for CIFS
 module to work with domain-based dfs resources with Kerberos authentication
To: alxvmr@altlinux.org
Cc: Vitaly Chikunov <vt@altlinux.org>, linux-cifs@vger.kernel.org, 
	Ivan Volchenko <ivolchenko86@gmail.com>, samba-technical@lists.samba.org, pc@manguebit.com, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I will update the mount parm name, similar to what Tom suggested to
"dfs_domain_hostname" to be less confusing.

Let me know if you had a v2 of the patch with other changes

On Thu, Jul 3, 2025 at 8:00=E2=80=AFAM Maria Alexeeva via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> On 6/14/25 07:42, Vitaly Chikunov wrote:
> > Maria,
> >
> > On Fri, May 16, 2025 at 07:22:01PM +0400, Maria Alexeeva wrote:
> >> Paths to domain-based dfs resources are defined using the domain name
> >> of the server in the format:
> >> \\DOMAIN.NAME>\<dfsroot>\<path>
> >>
> >> The CIFS module, when requesting a TGS, uses the server name
> >> (<DOMAIN.NAME>) it obtained from the UNC for the initial connection.
> >> It then composes an SPN that does not match any entities
> >> in the domain because it is the domain name itself.
> > For a casual reader like me it's hard to understand (this abbreviation
> > filled message) what it's all about. And why we can't just change syste=
m
> > hostname for example.
>
> This option is needed to transfer the real name of the server to which
> the connection is taking place,
> when using the UNC path in the form of domain-based DFS. The system
> hostname has nothing to do with it.
>
> > Also, the summary (subject) message is 180 character which is way above
> > 75 characters suggested in submitting-patches.rst.
> >
> >> To eliminate this behavior, a hostname option is added, which is
> >> the name of the server to connect to and is used in composing the SPN.
> >> In the future this option will be used in the cifs-utils development.
> >>
> >> Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
> >> Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
> >> ---
> >>   fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++------
> >>   fs/smb/client/fs_context.h |  3 +++
> >>   2 files changed, 32 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> >> index a634a34d4086..74de0a9de664 100644
> >> --- a/fs/smb/client/fs_context.c
> >> +++ b/fs/smb/client/fs_context.c
> >> @@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_parameters[=
] =3D {
> >>      fsparam_string("password2", Opt_pass2),
> >>      fsparam_string("ip", Opt_ip),
> >>      fsparam_string("addr", Opt_ip),
> >> +    fsparam_string("hostname", Opt_hostname),
> >>      fsparam_string("domain", Opt_domain),
> >>      fsparam_string("dom", Opt_domain),
> >>      fsparam_string("srcaddr", Opt_srcaddr),
> >> @@ -825,16 +826,23 @@ static int smb3_fs_context_validate(struct fs_co=
ntext *fc)
> >>              return -ENOENT;
> >>      }
> >>
> >> +    if (ctx->got_opt_hostname) {
> >> +            kfree(ctx->server_hostname);
> >> +            ctx->server_hostname =3D ctx->opt_hostname;
> > I am not familiar with the smb codebase but are you sure this will not
> > cause a race?
>
> The race condition will not occur.
> ctx->server_hostname is also used in smb3_parse_devname inside
> smb3_fs_context_parse_param.
> smb3_fs_context_parse_param is called earlier than the updated
> smb3_fs_context_validate, which is called inside smb3_get_tree:
>
> static const struct fs_context_operations smb3_fs_context_ops =3D {
>   .free   =3D smb3_fs_context_free,
>   .parse_param  =3D smb3_fs_context_parse_param,
>   .parse_monolithic =3D smb3_fs_context_parse_monolithic,
>   .get_tree  =3D smb3_get_tree,
>   .reconfigure  =3D smb3_reconfigure,
> };
>
> >> +            pr_notice("changing server hostname to name provided in h=
ostname=3D option\n");
> >> +    }
> >> +
> >>      if (!ctx->got_ip) {
> >>              int len;
> >> -            const char *slash;
> >>
> >> -            /* No ip=3D option specified? Try to get it from UNC */
> >> -            /* Use the address part of the UNC. */
> >> -            slash =3D strchr(&ctx->UNC[2], '\\');
> >> -            len =3D slash - &ctx->UNC[2];
> >> +            /*
> >> +             * No ip=3D option specified? Try to get it from server_h=
ostname
> >> +             * Use the address part of the UNC parsed into server_hos=
tname
> >> +             * or hostname=3D option if specified.
> >> +             */
> >> +            len =3D strlen(ctx->server_hostname);
> >>              if (!cifs_convert_address((struct sockaddr *)&ctx->dstadd=
r,
> >> -                                      &ctx->UNC[2], len)) {
> >> +                                      ctx->server_hostname, len)) {
> >>                      pr_err("Unable to determine destination address\n=
");
> >>                      return -EHOSTUNREACH;
> >>              }
> >> @@ -1518,6 +1526,21 @@ static int smb3_fs_context_parse_param(struct f=
s_context *fc,
> >>              }
> >>              ctx->got_ip =3D true;
> >>              break;
> >> +    case Opt_hostname:
> >> +            if (strnlen(param->string, CIFS_NI_MAXHOST) =3D=3D CIFS_N=
I_MAXHOST) {
> >> +                    pr_warn("host name too long\n");
> >> +                    goto cifs_parse_mount_err;
> >> +            }
> >> +
> >> +            kfree(ctx->opt_hostname);
> >> +            ctx->opt_hostname =3D kstrdup(param->string, GFP_KERNEL);
> >> +            if (ctx->opt_hostname =3D=3D NULL) {
> >> +                    cifs_errorf(fc, "OOM when copying hostname string=
\n");
> >> +                    goto cifs_parse_mount_err;
> >> +            }
> >> +            cifs_dbg(FYI, "Host name set\n");
> >> +            ctx->got_opt_hostname =3D true;
> >> +            break;
> >>      case Opt_domain:
> >>              if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
> >>                              =3D=3D CIFS_MAX_DOMAINNAME_LEN) {
> >> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> >> index 9e83302ce4b8..cf0478b1eff9 100644
> >> --- a/fs/smb/client/fs_context.h
> >> +++ b/fs/smb/client/fs_context.h
> >> @@ -184,6 +184,7 @@ enum cifs_param {
> >>      Opt_pass,
> >>      Opt_pass2,
> >>      Opt_ip,
> >> +    Opt_hostname,
> >>      Opt_domain,
> >>      Opt_srcaddr,
> >>      Opt_iocharset,
> >> @@ -214,6 +215,7 @@ struct smb3_fs_context {
> >>      bool gid_specified;
> >>      bool sloppy;
> >>      bool got_ip;
> >> +    bool got_opt_hostname;
> >>      bool got_version;
> >>      bool got_rsize;
> >>      bool got_wsize;
> >> @@ -226,6 +228,7 @@ struct smb3_fs_context {
> >>      char *domainname;
> >>      char *source;
> >>      char *server_hostname;
> >> +    char *opt_hostname;
> > Perhaps, smb3_fs_context_dup and smb3_cleanup_fs_context_contents shoul=
d
> > be aware of these new fields too.
>
> smb3_cleanup_fs_context_contents should be aware of these new fields too.
>
> Clearing in smb3_cleanup_fs_context_contents is not necessary, because
> if opt_hostname !=3D NULL,
> then the pointer in server_hostname is replaced (it is pre-cleared by
> kfree), respectively, everything
> will be cleared by itself with the current code.
>
> In smb3_fs_context_dup, opt_hostname does not need to be processed,
> since this variable is
> essentially temporary. Immediately after parsing with the parameter, its
> value goes to
> server_hostname and it is no longer needed by itself.
>
> > Thanks,
> >
> >>      char *UNC;
> >>      char *nodename;
> >>      char workstation_name[CIFS_MAX_WORKSTATION_LEN];
> >>
> >> base-commit: bec6f00f120ea68ba584def5b7416287e7dd29a7
> >> --
> >> 2.42.2
> >>
>
> Apologies for the overly long subject line and unclear description.
> Thanks.
>


--=20
Thanks,

Steve
