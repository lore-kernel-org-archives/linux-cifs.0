Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82005146D6E
	for <linux-cifs@vger.kernel.org>; Tue, 19 Nov 2024 06:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731999436; cv=none; b=NvL79extfn0mVfz3DPZYZrvRnbJCwdGdQmFR5O/uH1v26SPGnNFeX1kYI7l1rP64ea142P5/OpNA3eDqnQ1mNqMBR2j2CdJG9E7OU4QbQ6yC+LJgXTHFjDM3fl4jHI8lC/VVsLjHH3SVtPaOcWNjGC1v6IuEGlKH7ix7HEq4PS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731999436; c=relaxed/simple;
	bh=uVFNbu70ZIbfXVqYnziCQID5fH5Z7IdKB0u1VHYt4tw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFG5CeCD8MJqEVvmM3TQqyDIV8zE32fo3x3Ynk5H7yID2LnHDGe9kgjcLqDMIn8tDZswkHvHQnnhf24FFypkogW+4h64CZ+RTQTZxDxh9abIyRFY9XGbmw1sODFcrhHFC+BiWdjOjjvqyqSu63oBvoenAjNLBd/X0ZcdPcqgi0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZIJOIO57; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZIJOIO57"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7181c0730ddso230255a34.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 22:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731999433; x=1732604233; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jORhI6aguu99IcwwL1gOhu1swRKO+lZw7I6WWaQfhhM=;
        b=ZIJOIO57w7J4GWJj6a4XggHTr2MwXuH3gmwV16GTkljsfJ3nZAtUv/KlPi7vYWWpYV
         WGCzsDRJh3FGmRAJSziv79h2R0iraUJ7iX4k1gmM3tk7mHZt3WU6tGffsmjW53LLbcJ+
         j6yRjzR+VbmZTDGYrSUXIW44rI+XfJFz9eJx3AcJ5KqN6/OvSxEmZ9bDEBlSCWC1oNkC
         R8Q525waTRs9dJ/nEDwSwHTnLuynmQ8wqlPT9Bu5//b85HlGDCY2VaWZKvIR7gXq1vE9
         Ajt7c/ST0C6K38D8Q921HdvB3D5jz4+aAYlgsZ58fhwblGeADQk+QPY6CAYh32j0LqMU
         EIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731999433; x=1732604233;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jORhI6aguu99IcwwL1gOhu1swRKO+lZw7I6WWaQfhhM=;
        b=nierhngRH96WnF7YX3ajxRj1f/Puwy0d761nzEUUoKiVW90RgEqzj3FuSnxd12ENOO
         Cdp/hRbR6cse8BW8gzpOdiXrfy8cmMFiYv8OzDkvWRVTHcJ6J+Ce2Rm6gJC3hms7kNmL
         QQOk+2ahevVt1bNr23SaglmhVWUFcMZ2n6JZaXFksFTD3XLspi/RcDmVypiCXsB+vXrO
         gmNmddiqo/WncFbYT5vGR2LPNsuPXV6itgIqfgaoJhRQOkF9eeQ8TMljTVqrOrmARBR9
         BI01IwCW+TKSQgsUg0AY6YylY8O3znEobxEQEy/Nc+VFrLOttWAfLBnkSvf0z2n1GmB0
         YWVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAZ4EusYK6VN2ptIoMe5dC/22Q5ErvKjhO0BgXmrEy4NBRH2PtElpYwYkN4dELpJ46HL5LOav2U9ZC@vger.kernel.org
X-Gm-Message-State: AOJu0YyhmOxVKHYpAThGIJTuqVztrgi0KueLcC9LgGswvqc5a/+n/hkR
	XUIkBTIFTUtXbD82F9r+sV5Ks6zP+IiSC0YR0XpqeOOjDrqy4u+1vYUmNq9tiaQscOaSLwTe9dM
	Qmf2Bc5H5uvf9XaHtGN637O29F9I=
X-Google-Smtp-Source: AGHT+IHCw1ieXPdiDNZ/SA5j2t1M0hRaYn/ueCJOh9BWbuZ9kqTTZCKXILyluiJjw9mCDnWh58N4JjLEkkbFOpSZT0Q=
X-Received: by 2002:a05:6830:611a:b0:710:e61c:7a4c with SMTP id
 46e09a7af769-71a77a567f2mr13553820a34.29.1731999433480; Mon, 18 Nov 2024
 22:57:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119060758.273090-1-budhirajaritviksmb@gmail.com> <CA+EPQ67KD_b+9piJer=LQKO5i+bkBcLpBde7DYujtom7iKq5Kw@mail.gmail.com>
In-Reply-To: <CA+EPQ67KD_b+9piJer=LQKO5i+bkBcLpBde7DYujtom7iKq5Kw@mail.gmail.com>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Tue, 19 Nov 2024 16:57:01 +1000
Message-ID: <CAN05THRvZ8UV1iy8hBgPg5XpJ37rMoQnbsoUrjY60hqO7QxiKw@mail.gmail.com>
Subject: Re: [PATCH] CIFS.upcall to accomodate new namespace mount opt
To: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Cc: pc@manguebit.com, dhowells@redhat.com, jlayton@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, linux-cifs@vger.kernel.org, 
	nspmangalore@gmail.com, bharathsm.hsk@gmail.com, 
	Ritvik Budhiraja <rbudhiraja@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Hi Ritvik,

LGTM

Reviewed-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>

On Tue, 19 Nov 2024 at 16:26, Ritvik Budhiraja
<budhirajaritviksmb@gmail.com> wrote:
>
> Attaching the previously sent patch (on which the current is dependent)
> adding +ronniesahlberg@gmail.com
>
> ------------------------
>
> [PATCH] CIFS: New mount option for cifs.upcall namespace resolution
> From: Ritvik Budhiraja <rbudhiraja@microsoft.com>
>
> In the current implementation, the SMB filesystem on a mount point can
> trigger upcalls from the kernel to the userspace to enable certain
> functionalities like spnego, dns_resolution, amongst others. These upcalls
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
> Having this new mount option allows the mount command to specify where the
> upcall should happen: 'mount' for resolving the upcall to the host
> namespace, and 'app' for resolving the upcall to the ns of the calling
> thread. This will enable both the scenarios where the Kerberos credentials
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
> @@ -82,6 +82,9 @@ struct key_type cifs_spnego_key_type = {
>  /* strlen of ";pid=0x" */
>  #define PID_KEY_LEN            7
>
> +/* strlen of ";upcall_target=" */
> +#define UPCALL_TARGET_KEY_LEN  15
> +
>  /* get a key struct with a SPNEGO security blob, suitable for session setup */
>  struct key *
>  cifs_get_spnego_key(struct cifs_ses *sesInfo,
> @@ -108,6 +111,11 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
>         if (sesInfo->user_name)
>                 desc_len += USER_KEY_LEN + strlen(sesInfo->user_name);
>
> +       if (sesInfo->upcall_target == UPTARGET_MOUNT)
> +               desc_len += UPCALL_TARGET_KEY_LEN + 5; // strlen("mount")
> +       else
> +               desc_len += UPCALL_TARGET_KEY_LEN + 3; // strlen("app")
> +
>         spnego_key = ERR_PTR(-ENOMEM);
>         description = kzalloc(desc_len, GFP_KERNEL);
>         if (description == NULL)
> @@ -156,6 +164,14 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
>         dp = description + strlen(description);
>         sprintf(dp, ";pid=0x%x", current->pid);
>
> +       if (sesInfo->upcall_target == UPTARGET_MOUNT) {
> +               dp = description + strlen(description);
> +               sprintf(dp, ";upcall_target=mount");
> +       } else {
> +               dp = description + strlen(description);
> +               sprintf(dp, ";upcall_target=app");
> +       }
> +
>         cifs_dbg(FYI, "key description = %s\n", description);
>         saved_cred = override_creds(spnego_cred);
>         spnego_key = request_key(&cifs_spnego_key_type, description, "");
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 2a2523c93..ac89bd199 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -535,6 +535,30 @@ static int cifs_show_devname(struct seq_file *m, struct dentry *root)
>         return 0;
>  }
>
> +static void
> +cifs_show_upcall_target(struct seq_file *s, struct cifs_sb_info *cifs_sb)
> +{
> +       if (cifs_sb->ctx->upcall_target == UPTARGET_UNSPECIFIED) {
> +               seq_puts(s, ",upcall_target=app");
> +               return;
> +       }
> +
> +       seq_puts(s, ",upcall_target=");
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
> @@ -551,6 +575,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>         seq_show_option(s, "vers", tcon->ses->server->vals->version_string);
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
> +       UPTARGET_APP, /* upcall to the application namespace which did the mount */
> +};
> +
>  enum cifs_reparse_type {
>         CIFS_REPARSE_TYPE_NFS,
>         CIFS_REPARSE_TYPE_WSL,
> @@ -1083,6 +1089,7 @@ struct cifs_ses {
>         struct session_key auth_key;
>         struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
>         enum securityEnum sectype; /* what security flavor was specified? */
> +       enum upcall_target_enum upcall_target; /* what upcall target was specified? */
>         bool sign;              /* is signing required? */
>         bool domainAuto:1;
>         bool expired_pwd;  /* track if access denied or expired pwd so can know if need to update */
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 5375b0c1d..57766bca0 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -2352,6 +2352,26 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
>
>         ses->sectype = ctx->sectype;
>         ses->sign = ctx->sign;
> +
> +       /*
> +        *Explicitly marking upcall_target mount option for easier handling
> +        * by cifs_spnego.c and eventually cifs.upcall.c
> +        */
> +
> +       switch (ctx->upcall_target) {
> +       case UPTARGET_UNSPECIFIED: /* default to app */
> +       case UPTARGET_APP:
> +               ses->upcall_target = UPTARGET_APP;
> +               break;
> +       case UPTARGET_MOUNT:
> +               ses->upcall_target = UPTARGET_MOUNT;
> +               break;
> +       default:
> +               // should never happen
> +               ses->upcall_target = UPTARGET_APP;
> +               break;
> +       }
> +
>         ses->local_nls = load_nls(ctx->local_nls->charset);
>
>         /* add server as first channel */
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index bc926ab25..2bae49507 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -67,6 +67,12 @@ static const match_table_t cifs_secflavor_tokens = {
>         { Opt_sec_err, NULL }
>  };
>
> +static const match_table_t cifs_upcall_target = {
> +       { Opt_upcall_target_mount, "mount" },
> +       { Opt_upcall_target_application, "app" },
> +       { Opt_upcall_target_err, NULL }
> +};
> +
>  const struct fs_parameter_spec smb3_fs_parameters[] = {
>         /* Mount options that take no arguments */
>         fsparam_flag_no("user_xattr", Opt_user_xattr),
> @@ -178,6 +184,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
>         fsparam_string("sec", Opt_sec),
>         fsparam_string("cache", Opt_cache),
>         fsparam_string("reparse", Opt_reparse),
> +       fsparam_string("upcall_target", Opt_upcalltarget),
>
>         /* Arguments that should be ignored */
>         fsparam_flag("guest", Opt_ignore),
> @@ -248,6 +255,29 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
>         return 0;
>  }
>
> +static int
> +cifs_parse_upcall_target(struct fs_context *fc, char *value, struct smb3_fs_context *ctx)
> +{
> +       substring_t args[MAX_OPT_ARGS];
> +
> +       ctx->upcall_target = UPTARGET_UNSPECIFIED;
> +
> +       switch (match_token(value, cifs_upcall_target, args)) {
> +       case Opt_upcall_target_mount:
> +               ctx->upcall_target = UPTARGET_MOUNT;
> +               break;
> +       case Opt_upcall_target_application:
> +               ctx->upcall_target = UPTARGET_APP;
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
>  static const match_table_t cifs_cacheflavor_tokens = {
>         { Opt_cache_loose, "loose" },
>         { Opt_cache_strict, "strict" },
> @@ -1440,6 +1470,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>                 if (cifs_parse_security_flavors(fc, param->string, ctx) != 0)
>                         goto cifs_parse_mount_err;
>                 break;
> +       case Opt_upcalltarget:
> +               if (cifs_parse_upcall_target(fc, param->string, ctx) != 0)
> +                       goto cifs_parse_mount_err;
> +               break;
>         case Opt_cache:
>                 if (cifs_parse_cache_flavor(fc, param->string, ctx) != 0)
>                         goto cifs_parse_mount_err;
> @@ -1617,6 +1651,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>         }
>         /* case Opt_ignore: - is ignored as expected ... */
>
> +       if (ctx->multiuser && ctx->upcall_target == UPTARGET_MOUNT) {
> +               cifs_errorf(fc, "multiuser mount option not supported with upcalltarget set as 'mount'\n");
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
> +       enum upcall_target_enum upcall_target; /* where to upcall for mount */
>         bool sign; /* was signing requested via mnt opts? */
>         bool ignore_signature:1;
>         bool retry:1;
> --
> 2.43.0
>
> On Mon, 18 Nov 2024 at 22:08, <budhirajaritviksmb@gmail.com> wrote:
>>
>> From: Ritvik Budhiraja <rbudhiraja@microsoft.com>
>>
>> NOTE: This patch is dependent on one of the previously sent patches:
>> [PATCH] CIFS: New mount option for cifs.upcall namespace resolution
>> which introduces a new mount option called upcall_target, to
>> customise the upcall behaviour.
>>
>> Building upon the above patch, the following patch adds functionality
>> to handle upcall_target as a mount option in cifs.upcall. It can have 2 values -
>> mount, app.
>> Having this new mount option allows the mount command to specify where the
>> upcall should happen: 'mount' for resolving the upcall to the host
>> namespace, and 'app' for resolving the upcall to the ns of the calling
>> thread. This will enable both the scenarios where the Kerberos credentials
>> can be found on the application namespace or the host namespace to which
>> just the mount operation is "delegated".
>> This aids use cases like Kubernetes where the mount
>> happens on behalf of the application in another container altogether.
>>
>> Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
>> ---
>>  cifs.upcall.c | 55 +++++++++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 47 insertions(+), 8 deletions(-)
>>
>> diff --git a/cifs.upcall.c b/cifs.upcall.c
>> index ff6f2bd..a790aca 100644
>> --- a/cifs.upcall.c
>> +++ b/cifs.upcall.c
>> @@ -954,6 +954,13 @@ struct decoded_args {
>>  #define MAX_USERNAME_SIZE 256
>>         char username[MAX_USERNAME_SIZE + 1];
>>
>> +#define MAX_UPCALL_STRING_LEN 6 /* "mount\0" */
>> +       enum upcall_target_enum {
>> +               UPTARGET_UNSPECIFIED, /* not specified, defaults to app */
>> +               UPTARGET_MOUNT, /* upcall to the mount namespace */
>> +               UPTARGET_APP, /* upcall to the application namespace which did the mount */
>> +       } upcall_target;
>> +
>>         uid_t uid;
>>         uid_t creduid;
>>         pid_t pid;
>> @@ -970,6 +977,7 @@ struct decoded_args {
>>  #define DKD_HAVE_PID           0x20
>>  #define DKD_HAVE_CREDUID       0x40
>>  #define DKD_HAVE_USERNAME      0x80
>> +#define DKD_HAVE_UPCALL_TARGET 0x100
>>  #define DKD_MUSTHAVE_SET (DKD_HAVE_HOSTNAME|DKD_HAVE_VERSION|DKD_HAVE_SEC)
>>         int have;
>>  };
>> @@ -980,6 +988,7 @@ __decode_key_description(const char *desc, struct decoded_args *arg)
>>         size_t len;
>>         char *pos;
>>         const char *tkn = desc;
>> +       arg->upcall_target = UPTARGET_UNSPECIFIED;
>>
>>         do {
>>                 pos = index(tkn, ';');
>> @@ -1078,6 +1087,31 @@ __decode_key_description(const char *desc, struct decoded_args *arg)
>>                         }
>>                         arg->have |= DKD_HAVE_VERSION;
>>                         syslog(LOG_DEBUG, "ver=%d", arg->ver);
>> +               } else if (strncmp(tkn, "upcall_target=", 14) == 0) {
>> +                       if (pos == NULL)
>> +                               len = strlen(tkn);
>> +                       else
>> +                               len = pos - tkn;
>> +
>> +                       len -= 14;
>> +                       if (len > MAX_UPCALL_STRING_LEN) {
>> +                               syslog(LOG_ERR, "upcall_target= value too long for buffer");
>> +                               return 1;
>> +                       }
>> +                       if (strncmp(tkn + 14, "mount", 5) == 0) {
>> +                               arg->upcall_target = UPTARGET_MOUNT;
>> +                               syslog(LOG_DEBUG, "upcall_target=mount");
>> +                       } else if (strncmp(tkn + 14, "app", 3) == 0) {
>> +                               arg->upcall_target = UPTARGET_APP;
>> +                               syslog(LOG_DEBUG, "upcall_target=app");
>> +                       } else {
>> +                               // Should never happen
>> +                               syslog(LOG_ERR, "Invalid upcall_target value: %s, defaulting to app",
>> +                                      tkn + 14);
>> +                               arg->upcall_target = UPTARGET_APP;
>> +                               syslog(LOG_DEBUG, "upcall_target=app");
>> +                       }
>> +                       arg->have |= DKD_HAVE_UPCALL_TARGET;
>>                 }
>>                 if (pos == NULL)
>>                         break;
>> @@ -1441,15 +1475,20 @@ int main(const int argc, char *const argv[])
>>          * acceptably in containers, because we'll be looking at the correct
>>          * filesystem and have the correct network configuration.
>>          */
>> -       rc = switch_to_process_ns(arg->pid);
>> -       if (rc == -1) {
>> -               syslog(LOG_ERR, "unable to switch to process namespace: %s", strerror(errno));
>> -               rc = 1;
>> -               goto out;
>> +       if (arg->upcall_target == UPTARGET_APP || arg->upcall_target == UPTARGET_UNSPECIFIED) {
>> +               syslog(LOG_INFO, "upcall_target=app, switching namespaces to application thread");
>> +               rc = switch_to_process_ns(arg->pid);
>> +               if (rc == -1) {
>> +                       syslog(LOG_ERR, "unable to switch to process namespace: %s", strerror(errno));
>> +                       rc = 1;
>> +                       goto out;
>> +               }
>> +               if (trim_capabilities(env_probe))
>> +                       goto out;
>> +       } else {
>> +               syslog(LOG_INFO, "upcall_target=mount, not switching namespaces to application thread");
>>         }
>>
>> -       if (trim_capabilities(env_probe))
>> -               goto out;
>>
>>         /*
>>          * The kernel doesn't pass down the gid, so we resort here to scraping
>> @@ -1496,7 +1535,7 @@ int main(const int argc, char *const argv[])
>>          * look at the environ file.
>>          */
>>         env_cachename =
>> -               get_cachename_from_process_env(env_probe ? arg->pid : 0);
>> +               get_cachename_from_process_env((env_probe && (arg->upcall_target == UPTARGET_APP)) ? arg->pid : 0);
>>
>>         rc = setuid(uid);
>>         if (rc == -1) {
>> --
>> 2.43.0
>>
