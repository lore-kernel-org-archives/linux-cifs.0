Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D713913D2B2
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731517468; cv=none; b=lnrH3R+Uu1WpglXW+vvk9Gsgo9IaZMEIVk2D6cuohTb7ZtYdiDxsM8CycTZQOHN4pf8zuZCdbETMVvwQ+V++Y9iTh+42mikVn9UqA9YjpPqhArKRxOIeZU32lfeU8mGCjq3X6I5D49r/4GiRm9CkIUQy6FPBg2OFFB8OBD1dM0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731517468; c=relaxed/simple;
	bh=+t7Ygx30bf4KsLE3UVTazDkBrJs23DwsoYh1dhmXXtk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T4hP2c9ImsGK0zecy0X79xzHgsob9u3ov32gFnlhRDihwukCNqNHxegQqyrGY0z6R4fZQZE6+ovy+Te6amvQRJwM/z780I1CsmJ/SDrTIhiZYaD7IdBPjXi4xBjgcC/h6A00OVh68234bd1vqcITia7cm6S3bRugDH3aGHJlUaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LOU/jgmY; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LOU/jgmY"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539f8490856so8281704e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 09:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731517465; x=1732122265; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJ/pcY/JaTJbrFO5jCOxzHamlEyzkqqNoCuBlWWVw2M=;
        b=LOU/jgmYH8FHtZ0Jl2rNMiCYduUE6ya2yImeWPhvwVRjyCLzBJk9pS6/RQ1lqn5vAR
         1YYvLWNKlcHHpSupLhTZA+VoVCdk2O7C5z803sqa1zXLbu+Hi02p+0vIRjasjl8xOibs
         v5IfnJ7Eede0Z84EDvOT/IbVQPv3M/q2n7cDbaI3B4qLWN9pI9m8M5AxQrsqiSe07Rir
         7CGavXFRbM326mBBwhsTP+NkMbx+sIeGyVS7siu0Tze//7p4gelnT+UyJsZlmnGQ0+Ta
         9pvzCA2RcuIaXubtrEqidK31jPzQeNT0RdMXy55TfbLpP67SFCNj8rfHPmNC5tHIF5EQ
         wA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731517465; x=1732122265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJ/pcY/JaTJbrFO5jCOxzHamlEyzkqqNoCuBlWWVw2M=;
        b=lSm9A/W8tdVuCS9OT+beq/QQcqaxUwJpxEFGPoFmLuJezVReEs7lch/LVhIctmaXuM
         Qx1r5id1pJ3b3ii36ggPNCBw0lUPN7zI15Cw6CQVqZbUNDM6BMdbRql/YEO8Oih0TlzL
         URuTAD7jPEJM1up986sDt9SldWuQVvtk9O7MzUWDegAJjBIJ0nXW4Gxy4rd+q5biVXkU
         KGJBCRBMKr+dcazcYM2DBBvM3lkSTOE1m+Lig+WWrfJ1TjZ8m5UpVZI3I3ujD2NJlDJl
         j/Dy5YupzjeOOQ+Kst0FN+NAQz9BbbLSWgdCvxCk3xwGiNgtR0lmmyZw1RekU7HyM3/R
         B/5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUMBT7Ts7QqNh+lEHwDEH44IRZnziyiYtKhYHJYZB/eDJehzbMWm2VgD2McUVJu96HRcYpQUbuSaajW@vger.kernel.org
X-Gm-Message-State: AOJu0YyZfzKcDW6sIJ/X+pMUsy06yD2r1o7ME7E8fe8a+o8EV3UR8v3i
	skvpoeEBKuTMNeTmcfq7rPXYAgcwz7CdtbziRjMpYg92vl9vFmothHHUgmWBwagkT8Z2A8Q0l5+
	Q0XhkBybs65q90K7+m1m50cLTS+E=
X-Google-Smtp-Source: AGHT+IF2iDx30ZgeBgTfAhQoKjBJ6lwJCcDs3fukSFgmJxsTUWEYRqUiQ0++5kv6DtjlIhWiBZ6EvPvsebN87A+joLc=
X-Received: by 2002:a05:6512:b81:b0:539:e817:967f with SMTP id
 2adb3069b0e04-53d9fe7e306mr1785336e87.19.1731517463222; Wed, 13 Nov 2024
 09:04:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241111114351.200984-1-budhirajaritviksmb@gmail.com>
In-Reply-To: <20241111114351.200984-1-budhirajaritviksmb@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Nov 2024 11:04:11 -0600
Message-ID: <CAH2r5muang9fMK++S_=OUfWf97tbEnTKun8ZArUL9HmfE7PW9w@mail.gmail.com>
Subject: Re: [PATCH] CIFS: New mount option for cifs.upcall namespace resolution
To: budhirajaritviksmb@gmail.com
Cc: pc@manguebit.com, dhowells@redhat.com, jlayton@kernel.org, 
	sfrench@samba.org, linux-cifs@vger.kernel.org, nspmangalore@gmail.com, 
	bharathsm.hsk@gmail.com, Ritvik Budhiraja <rbudhiraja@microsoft.com>, 
	Shyam Prasad <shyam.prasad@microsoft.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing and
additional review.  Any suggestions on whether there would be a better
mount parm name?

On Mon, Nov 11, 2024 at 5:44=E2=80=AFAM <budhirajaritviksmb@gmail.com> wrot=
e:
>
> From: Ritvik Budhiraja <rbudhiraja@microsoft.com>
>
> In the current implementation, the SMB filesystem on a mount point can
> trigger upcalls from the kernel to the userspace to enable certain
> functionalities like spnego, dns_resolution, amongst others. These upcall=
s
> usually either happen in the context of the mount or in the context of an
> application/user. The upcall handler for cifs, cifs.upcall already has
> existing code which switches the namespaces to the caller's namespace
> before handling the upcall. This behaviour is expected for scenarios like
> multiuser mounts, but might not cover all single user scenario with
> services such as Kubernetes, where the mount can happen from different
> locations such as on the host, from an app container, or a driver pod
> which does the mount on behalf of a different pod.
>
> This patch introduces a new mount option called upcall_target, to
> customise the upcall behaviour. upcall_target can take 'mount' and 'app'
> as possible values. This aids use cases like Kubernetes where the mount
> happens on behalf of the application in another container altogether.
> Having this new mount option allows the mount command to specify where th=
e
> upcall should happen: 'mount' for resolving the upcall to the host
> namespace, and 'app' for resolving the upcall to the ns of the calling
> thread. This will enable both the scenarios where the Kerberos credential=
s
> can be found on the application namespace or the host namespace to which
> just the mount operation is "delegated".
>
> Reviewed-by: Shyam Prasad <shyam.prasad@microsoft.com>
> Reviewed-by: Bharath S M <bharathsm@microsoft.com>
> Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
> ---
>  fs/smb/client/cifs_spnego.c | 16 +++++++++++++++
>  fs/smb/client/cifsfs.c      | 25 ++++++++++++++++++++++++
>  fs/smb/client/cifsglob.h    |  7 +++++++
>  fs/smb/client/connect.c     | 20 +++++++++++++++++++
>  fs/smb/client/fs_context.c  | 39 +++++++++++++++++++++++++++++++++++++
>  fs/smb/client/fs_context.h  | 10 ++++++++++
>  6 files changed, 117 insertions(+)
>
> diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
> index af7849e59..28f568b5f 100644
> --- a/fs/smb/client/cifs_spnego.c
> +++ b/fs/smb/client/cifs_spnego.c
> @@ -82,6 +82,9 @@ struct key_type cifs_spnego_key_type =3D {
>  /* strlen of ";pid=3D0x" */
>  #define PID_KEY_LEN            7
>
> +/* strlen of ";upcall_target=3D" */
> +#define UPCALL_TARGET_KEY_LEN  15
> +
>  /* get a key struct with a SPNEGO security blob, suitable for session se=
tup */
>  struct key *
>  cifs_get_spnego_key(struct cifs_ses *sesInfo,
> @@ -108,6 +111,11 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
>         if (sesInfo->user_name)
>                 desc_len +=3D USER_KEY_LEN + strlen(sesInfo->user_name);
>
> +       if (sesInfo->upcall_target =3D=3D UPTARGET_MOUNT)
> +               desc_len +=3D UPCALL_TARGET_KEY_LEN + 5; // strlen("mount=
")
> +       else
> +               desc_len +=3D UPCALL_TARGET_KEY_LEN + 3; // strlen("app")
> +
>         spnego_key =3D ERR_PTR(-ENOMEM);
>         description =3D kzalloc(desc_len, GFP_KERNEL);
>         if (description =3D=3D NULL)
> @@ -156,6 +164,14 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
>         dp =3D description + strlen(description);
>         sprintf(dp, ";pid=3D0x%x", current->pid);
>
> +       if (sesInfo->upcall_target =3D=3D UPTARGET_MOUNT) {
> +               dp =3D description + strlen(description);
> +               sprintf(dp, ";upcall_target=3Dmount");
> +       } else {
> +               dp =3D description + strlen(description);
> +               sprintf(dp, ";upcall_target=3Dapp");
> +       }
> +
>         cifs_dbg(FYI, "key description =3D %s\n", description);
>         saved_cred =3D override_creds(spnego_cred);
>         spnego_key =3D request_key(&cifs_spnego_key_type, description, ""=
);
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 2a2523c93..ac89bd199 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -535,6 +535,30 @@ static int cifs_show_devname(struct seq_file *m, str=
uct dentry *root)
>         return 0;
>  }
>
> +static void
> +cifs_show_upcall_target(struct seq_file *s, struct cifs_sb_info *cifs_sb=
)
> +{
> +       if (cifs_sb->ctx->upcall_target =3D=3D UPTARGET_UNSPECIFIED) {
> +               seq_puts(s, ",upcall_target=3Dapp");
> +               return;
> +       }
> +
> +       seq_puts(s, ",upcall_target=3D");
> +
> +       switch (cifs_sb->ctx->upcall_target) {
> +       case UPTARGET_APP:
> +               seq_puts(s, "app");
> +               break;
> +       case UPTARGET_MOUNT:
> +               seq_puts(s, "mount");
> +               break;
> +       default:
> +               /* shouldn't ever happen */
> +               seq_puts(s, "unknown");
> +               break;
> +       }
> +}
> +
>  /*
>   * cifs_show_options() is for displaying mount options in /proc/mounts.
>   * Not all settable options are displayed but most of the important
> @@ -551,6 +575,7 @@ cifs_show_options(struct seq_file *s, struct dentry *=
root)
>         seq_show_option(s, "vers", tcon->ses->server->vals->version_strin=
g);
>         cifs_show_security(s, tcon->ses);
>         cifs_show_cache_flavor(s, cifs_sb);
> +       cifs_show_upcall_target(s, cifs_sb);
>
>         if (tcon->no_lease)
>                 seq_puts(s, ",nolease");
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 9eae8649f..7878d1197 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -153,6 +153,12 @@ enum securityEnum {
>         Kerberos,               /* Kerberos via SPNEGO */
>  };
>
> +enum upcall_target_enum {
> +       UPTARGET_UNSPECIFIED, /* not specified, defaults to app */
> +       UPTARGET_MOUNT, /* upcall to the mount namespace */
> +       UPTARGET_APP, /* upcall to the application namespace which did th=
e mount */
> +};
> +
>  enum cifs_reparse_type {
>         CIFS_REPARSE_TYPE_NFS,
>         CIFS_REPARSE_TYPE_WSL,
> @@ -1083,6 +1089,7 @@ struct cifs_ses {
>         struct session_key auth_key;
>         struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challe=
nge */
>         enum securityEnum sectype; /* what security flavor was specified?=
 */
> +       enum upcall_target_enum upcall_target; /* what upcall target was =
specified? */
>         bool sign;              /* is signing required? */
>         bool domainAuto:1;
>         bool expired_pwd;  /* track if access denied or expired pwd so ca=
n know if need to update */
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 5375b0c1d..57766bca0 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -2352,6 +2352,26 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, s=
truct smb3_fs_context *ctx)
>
>         ses->sectype =3D ctx->sectype;
>         ses->sign =3D ctx->sign;
> +
> +       /*
> +        *Explicitly marking upcall_target mount option for easier handli=
ng
> +        * by cifs_spnego.c and eventually cifs.upcall.c
> +        */
> +
> +       switch (ctx->upcall_target) {
> +       case UPTARGET_UNSPECIFIED: /* default to app */
> +       case UPTARGET_APP:
> +               ses->upcall_target =3D UPTARGET_APP;
> +               break;
> +       case UPTARGET_MOUNT:
> +               ses->upcall_target =3D UPTARGET_MOUNT;
> +               break;
> +       default:
> +               // should never happen
> +               ses->upcall_target =3D UPTARGET_APP;
> +               break;
> +       }
> +
>         ses->local_nls =3D load_nls(ctx->local_nls->charset);
>
>         /* add server as first channel */
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index bc926ab25..2bae49507 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -67,6 +67,12 @@ static const match_table_t cifs_secflavor_tokens =3D {
>         { Opt_sec_err, NULL }
>  };
>
> +static const match_table_t cifs_upcall_target =3D {
> +       { Opt_upcall_target_mount, "mount" },
> +       { Opt_upcall_target_application, "app" },
> +       { Opt_upcall_target_err, NULL }
> +};
> +
>  const struct fs_parameter_spec smb3_fs_parameters[] =3D {
>         /* Mount options that take no arguments */
>         fsparam_flag_no("user_xattr", Opt_user_xattr),
> @@ -178,6 +184,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] =
=3D {
>         fsparam_string("sec", Opt_sec),
>         fsparam_string("cache", Opt_cache),
>         fsparam_string("reparse", Opt_reparse),
> +       fsparam_string("upcall_target", Opt_upcalltarget),
>
>         /* Arguments that should be ignored */
>         fsparam_flag("guest", Opt_ignore),
> @@ -248,6 +255,29 @@ cifs_parse_security_flavors(struct fs_context *fc, c=
har *value, struct smb3_fs_c
>         return 0;
>  }
>
> +static int
> +cifs_parse_upcall_target(struct fs_context *fc, char *value, struct smb3=
_fs_context *ctx)
> +{
> +       substring_t args[MAX_OPT_ARGS];
> +
> +       ctx->upcall_target =3D UPTARGET_UNSPECIFIED;
> +
> +       switch (match_token(value, cifs_upcall_target, args)) {
> +       case Opt_upcall_target_mount:
> +               ctx->upcall_target =3D UPTARGET_MOUNT;
> +               break;
> +       case Opt_upcall_target_application:
> +               ctx->upcall_target =3D UPTARGET_APP;
> +               break;
> +
> +       default:
> +               cifs_errorf(fc, "bad upcall target: %s\n", value);
> +               return 1;
> +       }
> +
> +       return 0;
> +}
> +
>  static const match_table_t cifs_cacheflavor_tokens =3D {
>         { Opt_cache_loose, "loose" },
>         { Opt_cache_strict, "strict" },
> @@ -1440,6 +1470,10 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>                 if (cifs_parse_security_flavors(fc, param->string, ctx) !=
=3D 0)
>                         goto cifs_parse_mount_err;
>                 break;
> +       case Opt_upcalltarget:
> +               if (cifs_parse_upcall_target(fc, param->string, ctx) !=3D=
 0)
> +                       goto cifs_parse_mount_err;
> +               break;
>         case Opt_cache:
>                 if (cifs_parse_cache_flavor(fc, param->string, ctx) !=3D =
0)
>                         goto cifs_parse_mount_err;
> @@ -1617,6 +1651,11 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>         }
>         /* case Opt_ignore: - is ignored as expected ... */
>
> +       if (ctx->multiuser && ctx->upcall_target =3D=3D UPTARGET_MOUNT) {
> +               cifs_errorf(fc, "multiuser mount option not supported wit=
h upcalltarget set as 'mount'\n");
> +               goto cifs_parse_mount_err;
> +       }
> +
>         return 0;
>
>   cifs_parse_mount_err:
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index cf577ec0d..e3ceed48c 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -61,6 +61,12 @@ enum cifs_sec_param {
>         Opt_sec_err
>  };
>
> +enum cifs_upcall_target_param {
> +       Opt_upcall_target_mount,
> +       Opt_upcall_target_application,
> +       Opt_upcall_target_err
> +};
> +
>  enum cifs_param {
>         /* Mount options that take no arguments */
>         Opt_user_xattr,
> @@ -114,6 +120,8 @@ enum cifs_param {
>         Opt_multichannel,
>         Opt_compress,
>         Opt_witness,
> +       Opt_is_upcall_target_mount,
> +       Opt_is_upcall_target_application,
>
>         /* Mount options which take numeric value */
>         Opt_backupuid,
> @@ -157,6 +165,7 @@ enum cifs_param {
>         Opt_sec,
>         Opt_cache,
>         Opt_reparse,
> +       Opt_upcalltarget,
>
>         /* Mount options to be ignored */
>         Opt_ignore,
> @@ -198,6 +207,7 @@ struct smb3_fs_context {
>         umode_t file_mode;
>         umode_t dir_mode;
>         enum securityEnum sectype; /* sectype requested via mnt opts */
> +       enum upcall_target_enum upcall_target; /* where to upcall for mou=
nt */
>         bool sign; /* was signing requested via mnt opts? */
>         bool ignore_signature:1;
>         bool retry:1;
> --
> 2.43.0
>


--=20
Thanks,

Steve
