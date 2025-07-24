Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEDA2E370F
	for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 22:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753397455; cv=none; b=CN+QRS6Hv+qHEMOdtg1o+U5QsQAbbXd3y+C9WHahPr/mgVjOcN5FMeKDhOKoYyEg85cUtAhUt0Kp58XpBhFiv6xkSkZrsY5TZNykGO01o+GVkWSMuHgniFotDAM3CktH9QUnCNp4yW0On74+Jd2eEK6Dfk9PAxPhNYkNKJzswiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753397455; c=relaxed/simple;
	bh=vtwMUdMisOgVw9S2xO4Pp7DXE7QaaztMok6l5KkflIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+H6ljzuZGjhKDxV0+ZwjreZ3lLnwURWqn5z1CT1iZPi2L3zwR5Mi1gTJekO4y840SK9pPtK8FMtL4I9FwFbAygi5/S5424sS5H0xr785xXo+kxapaikMiA/ZiYljtSzJjBE8OoxFw6EPfvthGXZhVLlhBJMEQrHjqRUHdTnKeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bMX0sY8V; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMX0sY8V"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-70478ba562aso26796586d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 15:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753397452; x=1754002252; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39cgBMuM/za0y8OMAsLx2omC07JVqPDTO8m8S/8xgkg=;
        b=bMX0sY8VZKVBD4mSVxwe+26sXyNLkggFxrxefKUFqsowKQGiQnI//Ia796qqj7nvVO
         ec1Vx2uXzkpYWYxin1hmqCpKh2nO2KtP1HZpsnE+zA2izY4CGOFcW94GkmYhH9hF+sA+
         rO4aa1GLTSI6hXZ8hC6/6YWi3F7FQ7YN63Mj19cijCACGWYOnos+bRm84njVT/EP72Ik
         VMrXmnTQik8pqUcfttIogPYqh3Nl1LgL2UwyJYnH4iIELgm8LOPkuJMrwHFxPw4mTO45
         eSSovTSqKgp3gUWyKzGwDZBITYUtR/KD7VIeuq/VgHzhW3/TVehgSRKlpj+na+vAbewK
         irBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753397452; x=1754002252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39cgBMuM/za0y8OMAsLx2omC07JVqPDTO8m8S/8xgkg=;
        b=mQjt97y9cK66ZjxVf8X7VvwJeYhaBN9Xd9rbFvCmgimubeM1KrNarzHKfI4dUlDlIq
         ZF8G+KMS/dmIaWu+DdOHEdvv+YvAdVkGe8tBSVJvnAty9nsMbnN//r9CxUfIZKwUAyaE
         tsjrQBAtXuqZKo8AdbaJ66/vcm9uMddWYmy+l5UZpCY25PyL6TYTqvKhV6U7AcZikLIn
         JQ+DEHmiRJVCXUWJd77hgHq0rpwoc1atovdZxlyKFoSaNNSm8iFj/AnQ6fNvJee16E9Y
         pCOBkDBew7zKwZX1DbFTNPXTDnhExf2a73xrlEZD467F9uSOTvZi0nJEN1+KPYJSOwGQ
         uZEQ==
X-Forwarded-Encrypted: i=1; AJvYcCX44VpDRxTsKcCIs3j1USlloXYpfRCkraFfc4gnu2aPXlPMIQtAhe4MgK06eTGNVdI9gGk1ojP3CXS5@vger.kernel.org
X-Gm-Message-State: AOJu0YyS1jO0ZZ/sDQbT4/KVW+JS1xld1uFdF61UgCQJcA8RP0iTaH04
	zUicMEWOzmGhd3EnnGpO9b1ZLj8TYuYeNzRgYUbjdqOxfp+t0EHv6xmA8saD52nBO/nCMsrLuQq
	XJ7eoYm7reLExSdmuugt/uHNSwMOpN5k=
X-Gm-Gg: ASbGnctQEuAPkc6aSOedALmUbezcujx765lLkez7ptMopHO3RWJlBY7sCysOEmjsW+f
	C4O6sfrW5Ebz7vJKD5Mof/0hOeJJ3ZZ7ySlkeQCB9wEV9ABsMn/ZgJhj6KCXYaJseEZEc+GOVjt
	axkmfKLr0Pb0Iu+86wP7jAgxeEIhee4pTQfXyyRejwaASiIOqhsSi0TtTgn70PzAADs1PzGBQFa
	/UZMHl1dyTESFrCOt+TOjSf/ZHxrvuvTWDg3UoeaRw49Nihg/M=
X-Google-Smtp-Source: AGHT+IGJYYkdznCNZK8ndh/JVDvNHuERPApo/thCKR216DGsgLY6vCOQO8HbIixnO0T6K6FhM6sUac0eKpRhaTOEfIo=
X-Received: by 2002:ad4:5aae:0:b0:6fa:a5c9:2ee7 with SMTP id
 6a1803df08f44-70713bb257cmr49626456d6.8.1753397452124; Thu, 24 Jul 2025
 15:50:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516152201.201385-1-alxvmr@altlinux.org> <43os6kphihnry2wggqykiwmusz@pony.office.basealt.ru>
 <3d3160fd-e29d-495d-a02e-e28558cfec1a@altlinux.org> <CAH2r5mtG5pwFMRtu3EeXKPBdq0LJwjt84SbGtL0J4QuCg+AsgQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtG5pwFMRtu3EeXKPBdq0LJwjt84SbGtL0J4QuCg+AsgQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 24 Jul 2025 17:50:40 -0500
X-Gm-Features: Ac12FXxvZFvUMOFz7wEKAPWydtM2qEac4IApoUp3_vJs_WfmFh-SB63Seoe5DXk
Message-ID: <CAH2r5msnTMCHJ9kZmFWCbUUUnejOLv8mzGussaidc3yj3nk+qQ@mail.gmail.com>
Subject: Re: [PATCH] fs/smb/client/fs_context: Add hostname option for CIFS
 module to work with domain-based dfs resources with Kerberos authentication
To: alxvmr@altlinux.org
Cc: Vitaly Chikunov <vt@altlinux.org>, linux-cifs@vger.kernel.org, 
	Ivan Volchenko <ivolchenko86@gmail.com>, samba-technical@lists.samba.org, pc@manguebit.com, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Maria,
Since this looks like it depends on a cifs-utils change, can you
update your kernel patch with review comments (e.g. changing mount
parm to "dfs_domain_hostname", and there were at least two others in
the thread, e.g. fixing the noisy warning that the patch adds) and
then show the cifs-utils change, so we can make the upcoming merge
window.

On Thu, Jul 24, 2025 at 5:14=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> I will update the mount parm name, similar to what Tom suggested to
> "dfs_domain_hostname" to be less confusing.
>
> Let me know if you had a v2 of the patch with other changes
>
> On Thu, Jul 3, 2025 at 8:00=E2=80=AFAM Maria Alexeeva via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > On 6/14/25 07:42, Vitaly Chikunov wrote:
> > > Maria,
> > >
> > > On Fri, May 16, 2025 at 07:22:01PM +0400, Maria Alexeeva wrote:
> > >> Paths to domain-based dfs resources are defined using the domain nam=
e
> > >> of the server in the format:
> > >> \\DOMAIN.NAME>\<dfsroot>\<path>
> > >>
> > >> The CIFS module, when requesting a TGS, uses the server name
> > >> (<DOMAIN.NAME>) it obtained from the UNC for the initial connection.
> > >> It then composes an SPN that does not match any entities
> > >> in the domain because it is the domain name itself.
> > > For a casual reader like me it's hard to understand (this abbreviatio=
n
> > > filled message) what it's all about. And why we can't just change sys=
tem
> > > hostname for example.
> >
> > This option is needed to transfer the real name of the server to which
> > the connection is taking place,
> > when using the UNC path in the form of domain-based DFS. The system
> > hostname has nothing to do with it.
> >
> > > Also, the summary (subject) message is 180 character which is way abo=
ve
> > > 75 characters suggested in submitting-patches.rst.
> > >
> > >> To eliminate this behavior, a hostname option is added, which is
> > >> the name of the server to connect to and is used in composing the SP=
N.
> > >> In the future this option will be used in the cifs-utils development=
.
> > >>
> > >> Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
> > >> Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
> > >> ---
> > >>   fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++-----=
-
> > >>   fs/smb/client/fs_context.h |  3 +++
> > >>   2 files changed, 32 insertions(+), 6 deletions(-)
> > >>
> > >> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > >> index a634a34d4086..74de0a9de664 100644
> > >> --- a/fs/smb/client/fs_context.c
> > >> +++ b/fs/smb/client/fs_context.c
> > >> @@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_parameter=
s[] =3D {
> > >>      fsparam_string("password2", Opt_pass2),
> > >>      fsparam_string("ip", Opt_ip),
> > >>      fsparam_string("addr", Opt_ip),
> > >> +    fsparam_string("hostname", Opt_hostname),
> > >>      fsparam_string("domain", Opt_domain),
> > >>      fsparam_string("dom", Opt_domain),
> > >>      fsparam_string("srcaddr", Opt_srcaddr),
> > >> @@ -825,16 +826,23 @@ static int smb3_fs_context_validate(struct fs_=
context *fc)
> > >>              return -ENOENT;
> > >>      }
> > >>
> > >> +    if (ctx->got_opt_hostname) {
> > >> +            kfree(ctx->server_hostname);
> > >> +            ctx->server_hostname =3D ctx->opt_hostname;
> > > I am not familiar with the smb codebase but are you sure this will no=
t
> > > cause a race?
> >
> > The race condition will not occur.
> > ctx->server_hostname is also used in smb3_parse_devname inside
> > smb3_fs_context_parse_param.
> > smb3_fs_context_parse_param is called earlier than the updated
> > smb3_fs_context_validate, which is called inside smb3_get_tree:
> >
> > static const struct fs_context_operations smb3_fs_context_ops =3D {
> >   .free   =3D smb3_fs_context_free,
> >   .parse_param  =3D smb3_fs_context_parse_param,
> >   .parse_monolithic =3D smb3_fs_context_parse_monolithic,
> >   .get_tree  =3D smb3_get_tree,
> >   .reconfigure  =3D smb3_reconfigure,
> > };
> >
> > >> +            pr_notice("changing server hostname to name provided in=
 hostname=3D option\n");
> > >> +    }
> > >> +
> > >>      if (!ctx->got_ip) {
> > >>              int len;
> > >> -            const char *slash;
> > >>
> > >> -            /* No ip=3D option specified? Try to get it from UNC */
> > >> -            /* Use the address part of the UNC. */
> > >> -            slash =3D strchr(&ctx->UNC[2], '\\');
> > >> -            len =3D slash - &ctx->UNC[2];
> > >> +            /*
> > >> +             * No ip=3D option specified? Try to get it from server=
_hostname
> > >> +             * Use the address part of the UNC parsed into server_h=
ostname
> > >> +             * or hostname=3D option if specified.
> > >> +             */
> > >> +            len =3D strlen(ctx->server_hostname);
> > >>              if (!cifs_convert_address((struct sockaddr *)&ctx->dsta=
ddr,
> > >> -                                      &ctx->UNC[2], len)) {
> > >> +                                      ctx->server_hostname, len)) {
> > >>                      pr_err("Unable to determine destination address=
\n");
> > >>                      return -EHOSTUNREACH;
> > >>              }
> > >> @@ -1518,6 +1526,21 @@ static int smb3_fs_context_parse_param(struct=
 fs_context *fc,
> > >>              }
> > >>              ctx->got_ip =3D true;
> > >>              break;
> > >> +    case Opt_hostname:
> > >> +            if (strnlen(param->string, CIFS_NI_MAXHOST) =3D=3D CIFS=
_NI_MAXHOST) {
> > >> +                    pr_warn("host name too long\n");
> > >> +                    goto cifs_parse_mount_err;
> > >> +            }
> > >> +
> > >> +            kfree(ctx->opt_hostname);
> > >> +            ctx->opt_hostname =3D kstrdup(param->string, GFP_KERNEL=
);
> > >> +            if (ctx->opt_hostname =3D=3D NULL) {
> > >> +                    cifs_errorf(fc, "OOM when copying hostname stri=
ng\n");
> > >> +                    goto cifs_parse_mount_err;
> > >> +            }
> > >> +            cifs_dbg(FYI, "Host name set\n");
> > >> +            ctx->got_opt_hostname =3D true;
> > >> +            break;
> > >>      case Opt_domain:
> > >>              if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
> > >>                              =3D=3D CIFS_MAX_DOMAINNAME_LEN) {
> > >> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> > >> index 9e83302ce4b8..cf0478b1eff9 100644
> > >> --- a/fs/smb/client/fs_context.h
> > >> +++ b/fs/smb/client/fs_context.h
> > >> @@ -184,6 +184,7 @@ enum cifs_param {
> > >>      Opt_pass,
> > >>      Opt_pass2,
> > >>      Opt_ip,
> > >> +    Opt_hostname,
> > >>      Opt_domain,
> > >>      Opt_srcaddr,
> > >>      Opt_iocharset,
> > >> @@ -214,6 +215,7 @@ struct smb3_fs_context {
> > >>      bool gid_specified;
> > >>      bool sloppy;
> > >>      bool got_ip;
> > >> +    bool got_opt_hostname;
> > >>      bool got_version;
> > >>      bool got_rsize;
> > >>      bool got_wsize;
> > >> @@ -226,6 +228,7 @@ struct smb3_fs_context {
> > >>      char *domainname;
> > >>      char *source;
> > >>      char *server_hostname;
> > >> +    char *opt_hostname;
> > > Perhaps, smb3_fs_context_dup and smb3_cleanup_fs_context_contents sho=
uld
> > > be aware of these new fields too.
> >
> > smb3_cleanup_fs_context_contents should be aware of these new fields to=
o.
> >
> > Clearing in smb3_cleanup_fs_context_contents is not necessary, because
> > if opt_hostname !=3D NULL,
> > then the pointer in server_hostname is replaced (it is pre-cleared by
> > kfree), respectively, everything
> > will be cleared by itself with the current code.
> >
> > In smb3_fs_context_dup, opt_hostname does not need to be processed,
> > since this variable is
> > essentially temporary. Immediately after parsing with the parameter, it=
s
> > value goes to
> > server_hostname and it is no longer needed by itself.
> >
> > > Thanks,
> > >
> > >>      char *UNC;
> > >>      char *nodename;
> > >>      char workstation_name[CIFS_MAX_WORKSTATION_LEN];
> > >>
> > >> base-commit: bec6f00f120ea68ba584def5b7416287e7dd29a7
> > >> --
> > >> 2.42.2
> > >>
> >
> > Apologies for the overly long subject line and unclear description.
> > Thanks.
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
