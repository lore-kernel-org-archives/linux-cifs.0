Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF1D26056D
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 21:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772226479; cv=none; b=IUlVvsH+2Nc0VqAp/ji3Xp7OuOUcOATC/j9t+vVcXXBiiZtvKBZkkN7sIJ1zxiaL+xKvnUbX0mgGoRR8bXjdpKo2ilPtCP8blLBbo9HM4oLwVvx3jKg2kGMTBbnfKOurlCQNVP5/43XWjaeUBLL/sX94rqz9nycLgcOQJeNvtNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772226479; c=relaxed/simple;
	bh=kDafxzEooEdi6LizAZm3zzhRF10c+h2+Yi2ID27vnJ8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Fj1oz0p9sJttVFjtQ5LMNz73MWDFYY5mbyUIiCPeVI0CTXm0KN2rhZqgMBl6gnaQ4TGLtNRPElQ4iILVw+EUSDvOHtH8WM5SrOpnPDZg7WuOru+tmEUKn4cupQdVvN5/Sx4hy2/cItoGQVUoK2E7tZExd/rSO9usSsJaeZdGJSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=sHGC7Viu; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="sHGC7Viu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=RmCMhMFC4g19QCH2fxWP11n5ZtSOariWL7wvvZe1HiQ=; b=sHGC7Viug/jNGSwo65H9PWqviw
	c8S+aTk915HHYgwtRH6LadySvB10OohCl9br4xCOHa6UR7Lpqtw8ZmDeC7iQ8xiwoQTDQAZDfaRtP
	BWBNbtWq9dyWO68nKw1mrldQBBD02NeG12GHBuRBtshd08boyIQDLb6YyMBkLZMqc6rVKultYa6lp
	0nkqBDKplEvlwiym0utL+PldeeNhaAn9P0Q/0Ve943v5IX0xf+HLr03YAe61lyiOwFWoR6UzwHL1Q
	ozNrPTVWiGmLZ2LVlFZeruD2BHnCJuSYL56UziS+GBcQk8mRmpSC9+eDV70eUSI/hyu5Hdlewwksa
	wjFU0JNw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vw53y-00000000xpw-3BWC;
	Fri, 27 Feb 2026 18:07:54 -0300
Message-ID: <05a9968f75f32f9c33a16eb7ab4e66f6@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: =?utf-8?B?0JjQstCw0L0g0JLQvtC70YfQtdC90LrQvg==?=
 <ivolchenko86@gmail.com>
Cc: Maria Alexeeva <alxvmr@altlinux.org>, smfrench@gmail.com,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 tom@talpey.com, vt@altlinux.org
Subject: Re: [PATCH v3 1/1] fs/smb/client/fs_context: Add hostname option
 for CIFS module to work with domain-based dfs resources with Kerberos
 authentication
In-Reply-To: <CAG5KTOZ6s4AjE0e66D9CMnZTP68YHzUb6p9nQKgeZeBV9ZVVBw@mail.gmail.com>
References: <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
 <20251230164759.259346-1-alxvmr@altlinux.org>
 <20251230164759.259346-2-alxvmr@altlinux.org>
 <fcfa2783d489660bd152189ed34d9ddc@manguebit.org>
 <CAG5KTOZ6s4AjE0e66D9CMnZTP68YHzUb6p9nQKgeZeBV9ZVVBw@mail.gmail.com>
Date: Fri, 27 Feb 2026 18:07:54 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=D0=98=D0=B2=D0=B0=D0=BD =D0=92=D0=BE=D0=BB=D1=87=D0=B5=D0=BD=D0=BA=D0=BE <=
ivolchenko86@gmail.com> writes:

> =D0=BF=D1=82, 27 =D1=84=D0=B5=D0=B2=D1=80. 2026=E2=80=AF=D0=B3. =D0=B2 22=
:46, Paulo Alcantara <pc@manguebit.org>:
>
>> Maria Alexeeva <alxvmr@altlinux.org> writes:
>>
>> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>> > index d4291d3a9a48..f0d1895fe4bb 100644
>> > --- a/fs/smb/client/fs_context.c
>> > +++ b/fs/smb/client/fs_context.c
>> > @@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_parameters[]
>> =3D {
>> >       fsparam_string("password2", Opt_pass2),
>> >       fsparam_string("ip", Opt_ip),
>> >       fsparam_string("addr", Opt_ip),
>> > +     fsparam_string("hostname", Opt_hostname),
>> >       fsparam_string("domain", Opt_domain),
>> >       fsparam_string("dom", Opt_domain),
>> >       fsparam_string("srcaddr", Opt_srcaddr),
>> > @@ -866,16 +867,23 @@ static int smb3_fs_context_validate(struct
>> fs_context *fc)
>> >               return -ENOENT;
>> >       }
>> >
>> > +     if (ctx->got_opt_hostname) {
>> > +             kfree(ctx->server_hostname);
>> > +             ctx->server_hostname =3D ctx->opt_hostname;
>> > +             pr_notice("changing server hostname to name provided in
>> hostname=3D option\n");
>>
>> This is just too verbose.  Consider using pr_notice_once() or
>> cifs_dbg(VFS | ONCE, ...).
>>
>>
> I intentionally used pr_notice() here because the message corresponds
> to a mount-time event. Using pr_notice_once() would suppress the log
> after the first mount, which would make subsequent mount operations
> invisible in the logs.
> Since this path is only executed during filesystem mount, it should
> not be a high-frequency path. Can You provide scenarios
> when that verbosity is the problem?

Consider an DFS mount with hundreds of DFS links.  For every DFS link
accessed and automounted, this message would be get logged for every
mount.

Note that the automount will inherit parent mount's fs context, hence it
will have @got_opt_hostname set to true in the new fs context.

>> > +     }
>> > +
>> >       if (!ctx->got_ip) {
>> >               int len;
>> > -             const char *slash;
>> >
>> > -             /* No ip=3D option specified? Try to get it from UNC */
>> > -             /* Use the address part of the UNC. */
>> > -             slash =3D strchr(&ctx->UNC[2], '\\');
>> > -             len =3D slash - &ctx->UNC[2];
>> > +             /*
>> > +              * No ip=3D option specified? Try to get it from
>> server_hostname
>> > +              * Use the address part of the UNC parsed into
>> server_hostname
>> > +              * or hostname=3D option if specified.
>> > +              */
>> > +             len =3D strlen(ctx->server_hostname);
>> >               if (!cifs_convert_address((struct sockaddr *)&ctx->dstad=
dr,
>> > -                                       &ctx->UNC[2], len)) {
>> > +                                       ctx->server_hostname, len)) {
>> >                       pr_err("Unable to determine destination
>> address\n");
>> >                       return -EHOSTUNREACH;
>> >               }
>> > @@ -1591,6 +1599,21 @@ static int smb3_fs_context_parse_param(struct
>> fs_context *fc,
>> >               }
>> >               ctx->got_ip =3D true;
>> >               break;
>> > +     case Opt_hostname:
>> > +             if (strnlen(param->string, CIFS_NI_MAXHOST) =3D=3D
>> CIFS_NI_MAXHOST) {
>> > +                     pr_warn("host name too long\n");
>> > +                     goto cifs_parse_mount_err;
>> > +             }
>> > +
>> > +             kfree(ctx->opt_hostname);
>> > +             ctx->opt_hostname =3D kstrdup(param->string, GFP_KERNEL);
>> > +             if (ctx->opt_hostname =3D=3D NULL) {
>> > +                     cifs_errorf(fc, "OOM when copying hostname
>> string\n");
>> > +                     goto cifs_parse_mount_err;
>> > +             }
>>
>> No need to kstrdup() @param->string.  You can simply replace it with
>>
>>                 ctx->opt_hostname =3D no_free_ptr(param->string);
>>
>> > +             cifs_dbg(FYI, "Host name set\n");
>>
>> When debugging is enabled, there will be messages logged saying that
>> 'hostname=3D' has been passed, so no need for this debug message.
>>
>>
> I use kstrdup similar to other options processing code and to simplify
> further
> processing of the replaced "server_hostname" field (see below).
> I will think about no_free_ptr if it's that important. Is it?

This is an unnecessary memory allocation.  Could you point out the other
places where kstrdup() is being used for @param->string in mainline
kernel?

>> +             ctx->got_opt_hostname =3D true;
>> > +             break;
>> >       case Opt_domain:
>> >               if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
>> >                               =3D=3D CIFS_MAX_DOMAINNAME_LEN) {
>> > diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
>> > index 7af7cbbe4208..ff1a04661ef5 100644
>> > --- a/fs/smb/client/fs_context.h
>> > +++ b/fs/smb/client/fs_context.h
>> > @@ -184,6 +184,7 @@ enum cifs_param {
>> >       Opt_pass,
>> >       Opt_pass2,
>> >       Opt_ip,
>> > +     Opt_hostname,
>> >       Opt_domain,
>> >       Opt_srcaddr,
>> >       Opt_iocharset,
>> > @@ -214,6 +215,7 @@ struct smb3_fs_context {
>> >       bool gid_specified;
>> >       bool sloppy;
>> >       bool got_ip;
>> > +     bool got_opt_hostname;
>> >       bool got_version;
>> >       bool got_rsize;
>> >       bool got_wsize;
>> > @@ -226,6 +228,7 @@ struct smb3_fs_context {
>> >       char *domainname;
>> >       char *source;
>> >       char *server_hostname;
>> > +     char *opt_hostname;
>> >       char *UNC;
>> >       char *nodename;
>> >       char workstation_name[CIFS_MAX_WORKSTATION_LEN];
>>
>> You're introducing a new field to smb3_fs_context structure but forgot
>> to update smb3_fs_context_dup() and smb3_cleanup_fs_context_contents().
>>
>> This will break automounts as well as leak
>> smb3_fs_context::opt_hostname.
>>
>
>
> There is no any leak and there is no need to process "opt_hostname"
> explicitly in smb3_fs_context_dup() and smb3_cleanup_fs_context_contents(=
),
> because it's just a temporary pointer, that just copied into
> "server_hostname" (if specified, i.e. not null),

What happens if @ctx->opt_hostname was set and an invalid option that
follows it was passed?  IIUC, @ctx->server_hostname will not be set to
@ctx->opt_hostname and smb3_cleanup_fs_context_contents() will be
called, without freeing @ctx->opt_hostname.

Besides, regarding the automount I mentioned above, if
@ctx->got_opt_hostname was set, the new mount will set
@ctx->server_hostname to @ctx->opt_hostname, causing an UAF bug.
