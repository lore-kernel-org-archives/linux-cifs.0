Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A673A1B6
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753970430; cv=none; b=ma2XHbUUdVQH58GdkjgWwA6dSOELvgOltengU/JL9ZR2YjrBp9OcuvvZTfKRPkeE+IFt0dvoC6DKRAsQ97cvJ7H6g3TIZUAVB6a2VR+pUnsgSHI2LDnEqROT9kUTDzBMzko1G537uvrvdBoixzbn4XWVfc6fzYfw9HLFsYiCoEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753970430; c=relaxed/simple;
	bh=6MRP0d7lRPwyud43AOHepHiGOzyPSKbXSsR3DViac7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZVWyj//CTyGV90LW0uyMklEdtcm43/ddlli9M+swA9f0vKn/7v5c9O4ooTvInOuGtvKsfuDR3qDp3g03GQoNAAqdlypj6bYLeF5ySUpBGVscD3iKSf/F7/F2hexaxvoIeDXBUOpmie1CeNVZntooHN8AuPcIjBTdZ1ExIiELEBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HYeB5u/F; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYeB5u/F"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6fadd3ad18eso9455376d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 07:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753970427; x=1754575227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vhn9JbqxY6+MlILzyCmjqllaKBii5Z4mUdyeJUwwv9Y=;
        b=HYeB5u/F6YJ9wD4dKcrM7jKmnX7S7n+r+D3Sp1ot0WKfP4mdVjWYztHqpdsV1rXLrP
         V2EwY7l5lRzTWXcopk/EG5xB7q6O8+PfS2KQebYrO3mterks9QuSxeqyOHPrR4ix8QN1
         a8lGKzaFrhhSRQMZwTmEwP977OKDgtLzVvs1ZpD94vg+S9me+Dk5mQblxnZXltQmZxGK
         XwjoAFG2NmOJT1KrWurl3ZxfPL4sQlZOF/K4SeE5Nc6LvwmTZYMliL/jBX/PHk8Byuxm
         LvJaNy2/P7K+w3BEyUGUjE31j40qU3Q3LoJMqjyFqDCd6XhHZ0oXGhPFhylsB65fmhu6
         O1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753970427; x=1754575227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vhn9JbqxY6+MlILzyCmjqllaKBii5Z4mUdyeJUwwv9Y=;
        b=H9FGH4K3uRmZ+6Vd2orU1avhYUV/laG5PWq374UUqY9YR4T+suoGPy1E8eyQHAQE/2
         G60mqI0Y4R1K2XjYWYP4mWa6vg7K91WX0TxGeygyTTSh298XBLZ3klJDaFBgDV5fDu62
         kpFD2XoCzDWoIHC9cCHwc8BVM1+YmNn6j2ucovFd8qTVhBS+3bHaLObw8bvGWW7FBze8
         7MIYw2e7fYhygeCnYKdiqOh8r/dEEGnAUMLoTHpL60I0H7r6jbDg1cYFrsaq/UadPXVl
         i+F35/igtVRAecu0wjs7HYKWuhHI28ZQYChY1BwHJUPLmi7Ei1a/mQiX8j1XqAeD7sP9
         cEPg==
X-Forwarded-Encrypted: i=1; AJvYcCVwcRrRfTXCSPS+uXzpCqA0HDppABHwflcfRevIF2pQ4VuRcHt+Qf4/uMH+gQ6kFS0q2MxOqyClAhcR@vger.kernel.org
X-Gm-Message-State: AOJu0Yy16DT/uAwlp7Z0f+ajpVTbtG6MfuET3eYrR8jiM/fQijGNNeB4
	pFFS6kqd5a4V55WgoPLIu7VIWvZnU1y6xLuh/5rVzlXe4GVXkxi1sXI7jMfXOWTZhCK1Z3RqoJ5
	Pmv2/vnD4OTipQ8V9LkDRx+NZGALDYgQ=
X-Gm-Gg: ASbGncuM80abCfYPHnGsiCMDFAXRtVze1sKQRvlojrEB2m1aaco+pcjfxfiGOeXQ+Ij
	ydNcEsImZjW2oNiu5jF4eew7hy6Ta+QExTF+cY2K2ZlnE6fc7+j3/4AcItIvf34d3MOPzRnn5p5
	rWnCX54C5BFQyV3Fs/N07bOIM9GpyqvBATqH4LEcvSQRm3FxtlPgICdLsyHlDsPbSXuQB0if8Ed
	FTgW92QT8JehSDurobQuLL/a6ukvUVlJAXndyovUw==
X-Google-Smtp-Source: AGHT+IHMelhZCjPmtrZE7nkO6WfmoTLROWL+dInzPVyV86zG5qa1vR+amg2JYvs6Kx9j0Vh/uuF57YM9UGpNRaMd7aA=
X-Received: by 2002:ad4:5fcc:0:b0:707:38e8:d10b with SMTP id
 6a1803df08f44-707671e8ed0mr79775066d6.24.1753970425723; Thu, 31 Jul 2025
 07:00:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516152201.201385-1-alxvmr@altlinux.org> <43os6kphihnry2wggqykiwmusz@pony.office.basealt.ru>
 <3d3160fd-e29d-495d-a02e-e28558cfec1a@altlinux.org> <CAH2r5mtG5pwFMRtu3EeXKPBdq0LJwjt84SbGtL0J4QuCg+AsgQ@mail.gmail.com>
 <CAH2r5msnTMCHJ9kZmFWCbUUUnejOLv8mzGussaidc3yj3nk+qQ@mail.gmail.com> <8f2ad82d-0dd4-4195-b414-59f25f859a9e@altlinux.org>
In-Reply-To: <8f2ad82d-0dd4-4195-b414-59f25f859a9e@altlinux.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 31 Jul 2025 09:00:13 -0500
X-Gm-Features: Ac12FXzbyFiRSt3CuGBx5KjwUEGB3A3k_T7XKVkBoWzhj1t2v-Gao59X1XFhkms
Message-ID: <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
Subject: Re: [PATCH] fs/smb/client/fs_context: Add hostname option for CIFS
 module to work with domain-based dfs resources with Kerberos authentication
To: alxvmr@altlinux.org
Cc: pc@manguebit.com, linux-cifs@vger.kernel.org, 
	Ivan Volchenko <ivolchenko86@gmail.com>, samba-technical@lists.samba.org, 
	Vitaly Chikunov <vt@altlinux.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I don't have any strong opinion on: "dfs_server_hostname" vs
"dfs_domain_hostname" whichever makes more sense.

I will look to see if I can find any more threads on this in earlier email

On Wed, Jul 30, 2025 at 11:54=E2=80=AFAM Maria Alexeeva <alxvmr@altlinux.or=
g> wrote:
>
> Steve,
> It seems some of the discussion with review comments fell outside this
> thread (I can only find vt@altlinux.org Vitaly Chikunov's remarks).
> Could you please point me to where the rest of the feedback can be
> found (e.g., about fixing the noisy warning the patch adds and
> other comments)?
>
> An updated patch for fs/smb/client/fs_context has been prepared, renaming
> the option to dfs_domain_hostname. There's suggestion to further rename
> it to dfs_server_hostname - what are your thoughts on this?
>
> The patches will follow in subsequent messages.
>
> Thanks!
>
> On 7/25/25 02:50, Steve French via samba-technical wrote:
> > Maria,
> > Since this looks like it depends on a cifs-utils change, can you
> > update your kernel patch with review comments (e.g. changing mount
> > parm to "dfs_domain_hostname", and there were at least two others in
> > the thread, e.g. fixing the noisy warning that the patch adds) and
> > then show the cifs-utils change, so we can make the upcoming merge
> > window.
> >
> > On Thu, Jul 24, 2025 at 5:14=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> >>
> >> I will update the mount parm name, similar to what Tom suggested to
> >> "dfs_domain_hostname" to be less confusing.
> >>
> >> Let me know if you had a v2 of the patch with other changes
> >>
> >> On Thu, Jul 3, 2025 at 8:00=E2=80=AFAM Maria Alexeeva via samba-techni=
cal
> >> <samba-technical@lists.samba.org> wrote:
> >>>
> >>> On 6/14/25 07:42, Vitaly Chikunov wrote:
> >>>> Maria,
> >>>>
> >>>> On Fri, May 16, 2025 at 07:22:01PM +0400, Maria Alexeeva wrote:
> >>>>> Paths to domain-based dfs resources are defined using the domain na=
me
> >>>>> of the server in the format:
> >>>>> \\DOMAIN.NAME>\<dfsroot>\<path>
> >>>>>
> >>>>> The CIFS module, when requesting a TGS, uses the server name
> >>>>> (<DOMAIN.NAME>) it obtained from the UNC for the initial connection=
.
> >>>>> It then composes an SPN that does not match any entities
> >>>>> in the domain because it is the domain name itself.
> >>>> For a casual reader like me it's hard to understand (this abbreviati=
on
> >>>> filled message) what it's all about. And why we can't just change sy=
stem
> >>>> hostname for example.
> >>>
> >>> This option is needed to transfer the real name of the server to whic=
h
> >>> the connection is taking place,
> >>> when using the UNC path in the form of domain-based DFS. The system
> >>> hostname has nothing to do with it.
> >>>
> >>>> Also, the summary (subject) message is 180 character which is way ab=
ove
> >>>> 75 characters suggested in submitting-patches.rst.
> >>>>
> >>>>> To eliminate this behavior, a hostname option is added, which is
> >>>>> the name of the server to connect to and is used in composing the S=
PN.
> >>>>> In the future this option will be used in the cifs-utils developmen=
t.
> >>>>>
> >>>>> Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
> >>>>> Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
> >>>>> ---
> >>>>>    fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++---=
---
> >>>>>    fs/smb/client/fs_context.h |  3 +++
> >>>>>    2 files changed, 32 insertions(+), 6 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.=
c
> >>>>> index a634a34d4086..74de0a9de664 100644
> >>>>> --- a/fs/smb/client/fs_context.c
> >>>>> +++ b/fs/smb/client/fs_context.c
> >>>>> @@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_paramete=
rs[] =3D {
> >>>>>       fsparam_string("password2", Opt_pass2),
> >>>>>       fsparam_string("ip", Opt_ip),
> >>>>>       fsparam_string("addr", Opt_ip),
> >>>>> +    fsparam_string("hostname", Opt_hostname),
> >>>>>       fsparam_string("domain", Opt_domain),
> >>>>>       fsparam_string("dom", Opt_domain),
> >>>>>       fsparam_string("srcaddr", Opt_srcaddr),
> >>>>> @@ -825,16 +826,23 @@ static int smb3_fs_context_validate(struct fs=
_context *fc)
> >>>>>               return -ENOENT;
> >>>>>       }
> >>>>>
> >>>>> +    if (ctx->got_opt_hostname) {
> >>>>> +            kfree(ctx->server_hostname);
> >>>>> +            ctx->server_hostname =3D ctx->opt_hostname;
> >>>> I am not familiar with the smb codebase but are you sure this will n=
ot
> >>>> cause a race?
> >>>
> >>> The race condition will not occur.
> >>> ctx->server_hostname is also used in smb3_parse_devname inside
> >>> smb3_fs_context_parse_param.
> >>> smb3_fs_context_parse_param is called earlier than the updated
> >>> smb3_fs_context_validate, which is called inside smb3_get_tree:
> >>>
> >>> static const struct fs_context_operations smb3_fs_context_ops =3D {
> >>>    .free   =3D smb3_fs_context_free,
> >>>    .parse_param  =3D smb3_fs_context_parse_param,
> >>>    .parse_monolithic =3D smb3_fs_context_parse_monolithic,
> >>>    .get_tree  =3D smb3_get_tree,
> >>>    .reconfigure  =3D smb3_reconfigure,
> >>> };
> >>>
> >>>>> +            pr_notice("changing server hostname to name provided i=
n hostname=3D option\n");
> >>>>> +    }
> >>>>> +
> >>>>>       if (!ctx->got_ip) {
> >>>>>               int len;
> >>>>> -            const char *slash;
> >>>>>
> >>>>> -            /* No ip=3D option specified? Try to get it from UNC *=
/
> >>>>> -            /* Use the address part of the UNC. */
> >>>>> -            slash =3D strchr(&ctx->UNC[2], '\\');
> >>>>> -            len =3D slash - &ctx->UNC[2];
> >>>>> +            /*
> >>>>> +             * No ip=3D option specified? Try to get it from serve=
r_hostname
> >>>>> +             * Use the address part of the UNC parsed into server_=
hostname
> >>>>> +             * or hostname=3D option if specified.
> >>>>> +             */
> >>>>> +            len =3D strlen(ctx->server_hostname);
> >>>>>               if (!cifs_convert_address((struct sockaddr *)&ctx->ds=
taddr,
> >>>>> -                                      &ctx->UNC[2], len)) {
> >>>>> +                                      ctx->server_hostname, len)) =
{
> >>>>>                       pr_err("Unable to determine destination addre=
ss\n");
> >>>>>                       return -EHOSTUNREACH;
> >>>>>               }
> >>>>> @@ -1518,6 +1526,21 @@ static int smb3_fs_context_parse_param(struc=
t fs_context *fc,
> >>>>>               }
> >>>>>               ctx->got_ip =3D true;
> >>>>>               break;
> >>>>> +    case Opt_hostname:
> >>>>> +            if (strnlen(param->string, CIFS_NI_MAXHOST) =3D=3D CIF=
S_NI_MAXHOST) {
> >>>>> +                    pr_warn("host name too long\n");
> >>>>> +                    goto cifs_parse_mount_err;
> >>>>> +            }
> >>>>> +
> >>>>> +            kfree(ctx->opt_hostname);
> >>>>> +            ctx->opt_hostname =3D kstrdup(param->string, GFP_KERNE=
L);
> >>>>> +            if (ctx->opt_hostname =3D=3D NULL) {
> >>>>> +                    cifs_errorf(fc, "OOM when copying hostname str=
ing\n");
> >>>>> +                    goto cifs_parse_mount_err;
> >>>>> +            }
> >>>>> +            cifs_dbg(FYI, "Host name set\n");
> >>>>> +            ctx->got_opt_hostname =3D true;
> >>>>> +            break;
> >>>>>       case Opt_domain:
> >>>>>               if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
> >>>>>                               =3D=3D CIFS_MAX_DOMAINNAME_LEN) {
> >>>>> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.=
h
> >>>>> index 9e83302ce4b8..cf0478b1eff9 100644
> >>>>> --- a/fs/smb/client/fs_context.h
> >>>>> +++ b/fs/smb/client/fs_context.h
> >>>>> @@ -184,6 +184,7 @@ enum cifs_param {
> >>>>>       Opt_pass,
> >>>>>       Opt_pass2,
> >>>>>       Opt_ip,
> >>>>> +    Opt_hostname,
> >>>>>       Opt_domain,
> >>>>>       Opt_srcaddr,
> >>>>>       Opt_iocharset,
> >>>>> @@ -214,6 +215,7 @@ struct smb3_fs_context {
> >>>>>       bool gid_specified;
> >>>>>       bool sloppy;
> >>>>>       bool got_ip;
> >>>>> +    bool got_opt_hostname;
> >>>>>       bool got_version;
> >>>>>       bool got_rsize;
> >>>>>       bool got_wsize;
> >>>>> @@ -226,6 +228,7 @@ struct smb3_fs_context {
> >>>>>       char *domainname;
> >>>>>       char *source;
> >>>>>       char *server_hostname;
> >>>>> +    char *opt_hostname;
> >>>> Perhaps, smb3_fs_context_dup and smb3_cleanup_fs_context_contents sh=
ould
> >>>> be aware of these new fields too.
> >>>
> >>> smb3_cleanup_fs_context_contents should be aware of these new fields =
too.
> >>>
> >>> Clearing in smb3_cleanup_fs_context_contents is not necessary, becaus=
e
> >>> if opt_hostname !=3D NULL,
> >>> then the pointer in server_hostname is replaced (it is pre-cleared by
> >>> kfree), respectively, everything
> >>> will be cleared by itself with the current code.
> >>>
> >>> In smb3_fs_context_dup, opt_hostname does not need to be processed,
> >>> since this variable is
> >>> essentially temporary. Immediately after parsing with the parameter, =
its
> >>> value goes to
> >>> server_hostname and it is no longer needed by itself.
> >>>
> >>>> Thanks,
> >>>>
> >>>>>       char *UNC;
> >>>>>       char *nodename;
> >>>>>       char workstation_name[CIFS_MAX_WORKSTATION_LEN];
> >>>>>
> >>>>> base-commit: bec6f00f120ea68ba584def5b7416287e7dd29a7
> >>>>> --
> >>>>> 2.42.2
> >>>>>
> >>>
> >>> Apologies for the overly long subject line and unclear description.
> >>> Thanks.
> >>>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >
>


--=20
Thanks,

Steve
