Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F266C05027
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 05:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBQFlL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 00:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQFlL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 00:41:11 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345C710D
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 21:41:08 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id z18so540410lfd.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 21:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J1b7h4RkJp87XrNdijHedMGL1criQvQoXeV3V8B5Oqs=;
        b=HTKDQozAZdhc5nGP4dx9aMRdUmB4Fw+Kiktg0hZx2QFJGacCiDE/2jrc9kT2ZfcOQ/
         O7vKtv5Aa0QGC/08tCM/v5aI2BOc/JViEZlt7xWyZaNBOL/mjH9++6ERVs/aqwF4g3FF
         uN0H8axdoe2Eey17qyWqMH0BNHZ+hlQNq3j4gK4Vlv+/FzaGNj8OR+eyX2+UPBIYBXy0
         YD7vOOCUacbRJ4yEjWgDut+posTc3Duxrv7G6eWNk33PkYC+hsaxejsCib9rc+hmMGlO
         2s02KChJORNV9JjDirKeeFYOsGEkUoSB7stiDA+jvqVK5qTTmUiy/M25EBKIqpcs8o+n
         3X0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J1b7h4RkJp87XrNdijHedMGL1criQvQoXeV3V8B5Oqs=;
        b=oURx+aHmDMvPE85kiBPE3HV+QfWVi72WGQP0IsshUuKQeuKrmVl39gJZr++4qJPjQO
         goChqCCG7t1Q6VwAKZWsGXO0kC9GEFdBXO5dqx/q3Ez5sTo191f4/YG4jBGqFhlfHggh
         vxdnJAmbujvhInYnojCvZWIc0uzp6z2h2K4eVYxA6cFEeVfn9dbvzN5C5p8u5DW1YvmP
         fZBoBUhCn7SVETNheA8o0rdJjvtCyw4pWQtHz6veSU3hrmNm5oQGSF09jASbXuaKA3T0
         hexjD/s/WJC622ne6uBa6u7N2MwPL/rOG9kzvIyfIA1Z2C6NpRjXvQNJ3Odz4qs24eCb
         krKA==
X-Gm-Message-State: AO0yUKVMqLJwLzRU6b+YO+jtq1PrBaMrWWo3N7aIXjDltY8Lm4LMAjgc
        Pv/XoHIoGHMSvEolCSxTsuoojqrk94X7dLXxCNk=
X-Google-Smtp-Source: AK7set+FDyoRbf1tOJPYXKyvrdYwkSTGkhAU4r2vOOof5B91AuNG2mQHshzOXR3CLB/RZ48S8Gr1+4yIvktVHU61zKc=
X-Received: by 2002:a05:6512:239a:b0:4db:1809:29a1 with SMTP id
 c26-20020a056512239a00b004db180929a1mr2378339lfv.2.1676612466342; Thu, 16 Feb
 2023 21:41:06 -0800 (PST)
MIME-Version: 1.0
References: <20230217033501.2591185-1-lsahlber@redhat.com> <20230217033501.2591185-2-lsahlber@redhat.com>
In-Reply-To: <20230217033501.2591185-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 16 Feb 2023 23:40:55 -0600
Message-ID: <CAH2r5mv54i_ASAGPpfw2bC0wqUZ=P47vRmK2NWt=t5b69KJA+A@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: return a single-use cfid if we did not get a lease
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added Reviewed-by Bharath and merged into cifs-2.6.git for-next

On Thu, Feb 16, 2023 at 9:35 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> If we did not get a lease we can still return a single use cfid to the caller.
> The cfid will not have has_lease set and will thus not be shared with any
> other concurrent users and will be freed immediately when the caller
> drops the handle.
>
> This avoids extra roundtrips for servers that do not support directory leases
> where they would first fail to get a cfid with a lease and then fallback
> to try a normal SMB2_open()
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index 6672f1a0acd7..27ae908e4903 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -14,6 +14,7 @@
>
>  static struct cached_fid *init_cached_dir(const char *path);
>  static void free_cached_dir(struct cached_fid *cfid);
> +static void smb2_close_cached_fid(struct kref *ref);
>
>  static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
>                                                     const char *path,
> @@ -220,6 +221,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>                 }
>                 goto oshr_free;
>         }
> +       cfid->tcon = tcon;
>         cfid->is_open = true;
>
>         o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> @@ -232,7 +234,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>         if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
>                 goto oshr_free;
>
> -
>         smb2_parse_contexts(server, o_rsp,
>                             &oparms.fid->epoch,
>                             oparms.fid->lease_key, &oplock,
> @@ -259,7 +260,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>                 }
>         }
>         cfid->dentry = dentry;
> -       cfid->tcon = tcon;
>         cfid->time = jiffies;
>         cfid->has_lease = true;
>
> @@ -270,7 +270,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
>         free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>         spin_lock(&cfids->cfid_list_lock);
> -       if (!cfid->has_lease) {
> +       if (rc && !cfid->has_lease) {
>                 if (cfid->on_list) {
>                         list_del(&cfid->entry);
>                         cfid->on_list = false;
> @@ -279,6 +279,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>                 rc = -ENOENT;
>         }
>         spin_unlock(&cfids->cfid_list_lock);
> +       if (!rc && !cfid->has_lease) {
> +               /*
> +                * We are guaranteed to have two references at this point.
> +                * One for the caller and one for a potential lease.
> +                * Release the Lease-ref so that the directory will be closed
> +                * when the caller closes the cached handle.
> +                */
> +               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       }
>         if (rc) {
>                 if (cfid->is_open)
>                         SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
> @@ -339,6 +348,7 @@ smb2_close_cached_fid(struct kref *ref)
>         if (cfid->is_open) {
>                 SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
>                            cfid->fid.volatile_fid);
> +               atomic_dec(&cfid->tcon->num_remote_opens);
>         }
>
>         free_cached_dir(cfid);
> --
> 2.35.3
>


-- 
Thanks,

Steve
