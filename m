Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE2CC433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 05:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E6723A5E
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 05:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgLHFHE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Dec 2020 00:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgLHFHE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Dec 2020 00:07:04 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1843C061749
        for <linux-cifs@vger.kernel.org>; Mon,  7 Dec 2020 21:06:23 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id e7so7402866ljg.10
        for <linux-cifs@vger.kernel.org>; Mon, 07 Dec 2020 21:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhbI3YSVbGqM+N3HMsMJjXfsY8EoduA9XkxNSCKTWWE=;
        b=ChpJHhgpL6N/9R8zcu7FzngljCW1/NSISydl2cHHkUqmUHRcYDQ7fLS/v2DQh6lw+l
         sgHozD/bQ0bb5vuPKDBCsQFTK+8dvn6dj4cjj5yjbl6yiim7JAoUg4m+11u7ng4uSDua
         MeZQIoKEQuSQGL5pdxVgVkHzfLUkYeOpNiy5NDr0Xah2TL33lI/PbbqN2aZIR1yu35XI
         7Y6HPJlbZ4IYrZT8dR5vzwv3xE7Ukakj3mxJMafJISWA4Ge5fSZtZg+nwrw5qLXwF9EC
         adPFMrvmJIYPUZHS1lghipbQLhn1BVJS2VTncuqaI45UtrTj1PqN6gTM5dMNMNJRjuFw
         vL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhbI3YSVbGqM+N3HMsMJjXfsY8EoduA9XkxNSCKTWWE=;
        b=mn00OUvV7PUYIWpdPsyDpXtjsxCuF/YphsSGAa0JSP39o1Alie4NWH+sl0JcwQzywf
         6I3R1s+/mgP8P+hv9wHhf2kbyr0qTwReMFxFHje8lXvA43BnO+a8jVMtZ/Xr8MnEKBIX
         q5l0BPDRPQCLwle4/n7AZRoWijH72yaVjvxKg0G3P4b40aFattYo/Ln4L73wDqQB3rO5
         k/tR68Qr70sA4g/oKneFqUlK8QYe1nOBr5MitoSyauAw/4t0qc7Nu/BCEmA9BDoz6ICJ
         g8JDOn7PXKuY6B2NqGtEQ/q7ZwauxA3PolOBBGEZg6w8kdUbRys/lFHCG6NjUbATgckX
         xeNQ==
X-Gm-Message-State: AOAM531v1ReNXVTbn427NQI9otkq6ZObFYA/0xMgNucQmecy1mAq8c6v
        AWPqy6xGYzMdbncNdPlWDrF+Dn3829D2O4Cp5AFPu8XlRHMKgA==
X-Google-Smtp-Source: ABdhPJxV9M83k4It+pUodFNmv5CJqCTk2w95I+d1fBYv9ErLwKBxXX4czPbTwrdka8pVvJHim5GpYjf9Dr0/wOqCX84=
X-Received: by 2002:a2e:8096:: with SMTP id i22mr5632107ljg.403.1607403982284;
 Mon, 07 Dec 2020 21:06:22 -0800 (PST)
MIME-Version: 1.0
References: <20201207233646.29823-1-lsahlber@redhat.com> <20201207233646.29823-14-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-14-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 7 Dec 2020 23:06:08 -0600
Message-ID: <CAH2r5mu_AGjT6T-gNOn5Z7eb7zXgm44Br+AES_=FVUdi6WnPSQ@mail.gmail.com>
Subject: Re: [PATCH 14/21] cifs: we do not allow changing username/password/unc/...
 during remount
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Minor nits pointed out by checkpatch:

0015-cifs-we-do-not-allow-changing-username-password-unc-.patch
---------------------------------------------------------------
WARNING: Missing commit description - Add an appropriate one

WARNING: kfree(NULL) is safe and this check is probably not required
#76: FILE: fs/cifs/fs_context.c:673:
+ if (ctx->field) { \
+ kfree(ctx->field);

On Mon, Dec 7, 2020 at 5:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c     |  2 +-
>  fs/cifs/fs_context.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/cifs/fs_context.h |  2 +-
>  3 files changed, 54 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 80117e9d35f9..13d7f4a3c836 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -490,7 +490,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>
>         if (tcon->no_lease)
>                 seq_puts(s, ",nolease");
> -       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
> +       if (cifs_sb->ctx->multiuser)
>                 seq_puts(s, ",multiuser");
>         else if (tcon->ses->user_name)
>                 seq_show_option(s, "username", tcon->ses->user_name);
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index edfdea129fcc..542fa75b74aa 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -629,10 +629,53 @@ static int smb3_verify_reconfigure_ctx(struct smb3_fs_context *new_ctx,
>                 cifs_dbg(VFS, "can not change sec during remount\n");
>                 return -EINVAL;
>         }
> +       if (new_ctx->multiuser != old_ctx->multiuser) {
> +               cifs_dbg(VFS, "can not change multiuser during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->UNC &&
> +           (!old_ctx->UNC || strcmp(new_ctx->UNC, old_ctx->UNC))) {
> +               cifs_dbg(VFS, "can not change UNC during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->username &&
> +           (!old_ctx->username || strcmp(new_ctx->username, old_ctx->username))) {
> +               cifs_dbg(VFS, "can not change username during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->password &&
> +           (!old_ctx->password || strcmp(new_ctx->password, old_ctx->password))) {
> +               cifs_dbg(VFS, "can not change password during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->domainname &&
> +           (!old_ctx->domainname || strcmp(new_ctx->domainname, old_ctx->domainname))) {
> +               cifs_dbg(VFS, "can not change domainname during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->nodename &&
> +           (!old_ctx->nodename || strcmp(new_ctx->nodename, old_ctx->nodename))) {
> +               cifs_dbg(VFS, "can not change nodename during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->iocharset &&
> +           (!old_ctx->iocharset || strcmp(new_ctx->iocharset, old_ctx->iocharset))) {
> +               cifs_dbg(VFS, "can not change iocharset during remount\n");
> +               return -EINVAL;
> +       }
>
>         return 0;
>  }
>
> +#define STEAL_STRING(cifs_sb, ctx, field)                              \
> +do {                                                                   \
> +       if (ctx->field) {                                               \
> +               kfree(ctx->field);                                      \
> +               ctx->field = cifs_sb->ctx->field;                       \
> +               cifs_sb->ctx->field = NULL;                             \
> +       }                                                               \
> +} while (0)
> +
>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>         struct smb3_fs_context *ctx = smb3_fc2context(fc);
> @@ -645,10 +688,16 @@ static int smb3_reconfigure(struct fs_context *fc)
>                 return rc;
>
>         /*
> -        * Steal the UNC from the old and to be destroyed context.
> +        * We can not change UNC/username/password/domainname/nodename/iocharset
> +        * during reconnect so ignore what we have in the new context and
> +        * just use what we already have in cifs_sb->ctx.
>          */
> -       ctx->UNC = cifs_sb->ctx->UNC;
> -       cifs_sb->ctx->UNC = NULL;
> +       STEAL_STRING(cifs_sb, ctx, UNC);
> +       STEAL_STRING(cifs_sb, ctx, username);
> +       STEAL_STRING(cifs_sb, ctx, password);
> +       STEAL_STRING(cifs_sb, ctx, domainname);
> +       STEAL_STRING(cifs_sb, ctx, nodename);
> +       STEAL_STRING(cifs_sb, ctx, iocharset);
>
>         smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>         rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
> diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> index aa1d952fd5ce..62f5a8d98df6 100644
> --- a/fs/cifs/fs_context.h
> +++ b/fs/cifs/fs_context.h
> @@ -148,7 +148,6 @@ struct smb3_fs_context {
>         bool uid_specified;
>         bool gid_specified;
>         bool sloppy;
> -       char *nodename;
>         bool got_ip;
>         bool got_version;
>         bool got_rsize;
> @@ -160,6 +159,7 @@ struct smb3_fs_context {
>         char *password;
>         char *domainname;
>         char *UNC;
> +       char *nodename;
>         char *iocharset;  /* local code page for mapping to and from Unicode */
>         char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
>         char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
> --
> 2.13.6
>


-- 
Thanks,

Steve
