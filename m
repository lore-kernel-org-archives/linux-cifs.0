Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE724C43460
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A610C61105
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhDJALZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbhDJALZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 20:11:25 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438DFC061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 17:11:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x13so2159400lfr.2
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 17:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KGmT3mi3s2kPoxo89C4RFPSeOQPowdWSQERqoI7fpE0=;
        b=KENraB54tKneyZOWydAq9trjxzUYw31cXvlxKQcycYUxfqYGX4/xyz0tCulTS61seH
         Vm85/u/shHzhuLikoCMbTNwrB6bG1KDejTEz+unn7aBUcYGW4Hnu1CKJgRVow8pOwCc9
         P5IRhqyov6eAzrBS1iA53krOe5v6soHcBVXiaikVFAFKLcRrqPycLe9CbqAVmxCymjHW
         02m2XShLCcyys+xWaE/WzMbAFHsEU6pH+67i8489KKYyIEhD5UGOZDjgr/o/IcDtawi9
         BUxf0SVfV0XtE/XF3MfuQg7XYerdFuCVjwjii0jzUX2fVwKXHOwsPBa6VuUtENOYysY+
         Q28g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KGmT3mi3s2kPoxo89C4RFPSeOQPowdWSQERqoI7fpE0=;
        b=Mc5uUReSuLUHXLm0k7IbWpBF0sADUweMIe/WMHlkHGBLAtbCwVbvq8LBpo8gWM7vHc
         pc+PffWpFrxa1Cc4hj0ALcPwajx65D9YAvhS9ti4yLGIYKzjqHiKDPyoH4Gt644vLqS8
         tco+fZfUetZOzE9+sfc9xvBUOBPLHsiW8G5MXQAd0MhCG0GdChlhXEK5sl2DK+1CvWOL
         VkcVsDeczi848MAfZA0MQ8GPNWquw6PD3Elb5E3qcBjcQZ7g780NI8zEJ6dYMliCQYo2
         ViW69WvlpbiHSFtQ82lJcJHT7pFSKT5E9Eeqt1UvYg5H1Mei5bJDnaXELjVG0vBtEGuk
         dwtQ==
X-Gm-Message-State: AOAM531TfIObRtOdPycX+AJ2EJh9ayImU53d1XrNy+lL8jnUTYnqqzga
        Klugp5qLQIBSf/TRnlbzFX1K02ro/D8E3E9NEqs=
X-Google-Smtp-Source: ABdhPJwfy1VoAcrcZ8yt+DVM5GR8CQu0+5wmIGpyeXM7VJeFNPgp8vHV0Q4StYc92u/0lysLrSKKDuYOhwrFH9JNXao=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr11786300lfd.175.1618013469503;
 Fri, 09 Apr 2021 17:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210308230735.337-1-lsahlber@redhat.com> <20210308230735.337-4-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-4-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 19:10:58 -0500
Message-ID: <CAH2r5msidKKffTAGwoeSDQeh3s3ar_9OGpWSyuPqqgFEP0fg_Q@mail.gmail.com>
Subject: Re: [PATCH 3/9] cifs: rename the *_shroot* functions to *_cached_dir*
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

these renames look fine.

On Mon, Mar 8, 2021 at 5:07 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> These functions will eventually be used to cache any directory, not just the root
> so change the names.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifssmb.c   |  2 +-
>  fs/cifs/smb2inode.c |  4 ++--
>  fs/cifs/smb2ops.c   | 19 ++++++++++---------
>  fs/cifs/smb2pdu.c   |  2 +-
>  fs/cifs/smb2proto.h | 14 +++++++-------
>  5 files changed, 21 insertions(+), 20 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 0496934feecb..3419289b7663 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -114,7 +114,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
>         mutex_lock(&tcon->crfid.fid_mutex);
>         tcon->crfid.is_valid = false;
>         /* cached handle is not valid, so SMB2_CLOSE won't be sent below */
> -       close_shroot_lease_locked(&tcon->crfid);
> +       close_cached_dir_lease_locked(&tcon->crfid);
>         memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
>         mutex_unlock(&tcon->crfid.fid_mutex);
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 67f80c9561fc..0d0bc0b878be 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -523,7 +523,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         /* If it is a root and its handle is cached then use it */
> -       rc = open_shroot(xid, tcon, full_path, cifs_sb, &cfid);
> +       rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
>         if (!rc) {
>                 if (tcon->crfid.file_all_info_is_valid) {
>                         move_smb2_info_to_cifs(data,
> @@ -535,7 +535,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                         if (!rc)
>                                 move_smb2_info_to_cifs(data, smb2_data);
>                 }
> -               close_shroot(cfid);
> +               close_cached_dir(cfid);
>                 goto out;
>         }
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 96ff946674e6..d2858c25ff17 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -693,14 +693,14 @@ smb2_close_cached_fid(struct kref *ref)
>         }
>  }
>
> -void close_shroot(struct cached_fid *cfid)
> +void close_cached_dir(struct cached_fid *cfid)
>  {
>         mutex_lock(&cfid->fid_mutex);
>         kref_put(&cfid->refcount, smb2_close_cached_fid);
>         mutex_unlock(&cfid->fid_mutex);
>  }
>
> -void close_shroot_lease_locked(struct cached_fid *cfid)
> +void close_cached_dir_lease_locked(struct cached_fid *cfid)
>  {
>         if (cfid->has_lease) {
>                 cfid->has_lease = false;
> @@ -708,10 +708,10 @@ void close_shroot_lease_locked(struct cached_fid *cfid)
>         }
>  }
>
> -void close_shroot_lease(struct cached_fid *cfid)
> +void close_cached_dir_lease(struct cached_fid *cfid)
>  {
>         mutex_lock(&cfid->fid_mutex);
> -       close_shroot_lease_locked(cfid);
> +       close_cached_dir_lease_locked(cfid);
>         mutex_unlock(&cfid->fid_mutex);
>  }
>
> @@ -721,13 +721,14 @@ smb2_cached_lease_break(struct work_struct *work)
>         struct cached_fid *cfid = container_of(work,
>                                 struct cached_fid, lease_break);
>
> -       close_shroot_lease(cfid);
> +       close_cached_dir_lease(cfid);
>  }
>
>  /*
> - * Open the directory at the root of a share
> + * Open the and cache a directory handle.
> + * Only supported for the root handle.
>   */
> -int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
> +int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>                 const char *path,
>                 struct cifs_sb_info *cifs_sb,
>                 struct cached_fid **cfid)
> @@ -930,7 +931,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>         oparms.fid = &fid;
>         oparms.reconnect = false;
>
> -       rc = open_shroot(xid, tcon, "", cifs_sb, &cfid);
> +       rc = open_cached_dir(xid, tcon, "", cifs_sb, &cfid);
>         if (rc == 0)
>                 memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
>         else
> @@ -952,7 +953,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>         if (cfid == NULL)
>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
>         else
> -               close_shroot(cfid);
> +               close_cached_dir(cfid);
>  }
>
>  static void
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 4bbb6126b14d..0a03f8d88173 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1857,7 +1857,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
>         if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
>                 return 0;
>
> -       close_shroot_lease(&tcon->crfid);
> +       close_cached_dir_lease(&tcon->crfid);
>
>         rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, ses->server,
>                                  (void **) &req,
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 7e4fc69c8b01..ddbdf9923625 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -69,13 +69,13 @@ extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
>  extern int smb3_handle_read_data(struct TCP_Server_Info *server,
>                                  struct mid_q_entry *mid);
>
> -extern int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
> -                      const char *path,
> -                      struct cifs_sb_info *cifs_sb,
> -                      struct cached_fid **cfid);
> -extern void close_shroot(struct cached_fid *cfid);
> -extern void close_shroot_lease(struct cached_fid *cfid);
> -extern void close_shroot_lease_locked(struct cached_fid *cfid);
> +extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> +                          const char *path,
> +                          struct cifs_sb_info *cifs_sb,
> +                          struct cached_fid **cfid);
> +extern void close_cached_dir(struct cached_fid *cfid);
> +extern void close_cached_dir_lease(struct cached_fid *cfid);
> +extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
>  extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
>                                    struct smb2_file_all_info *src);
>  extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
> --
> 2.13.6
>


-- 
Thanks,

Steve
