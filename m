Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7680C6FA82
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 05:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiIWFHQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 01:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiIWFHP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 01:07:15 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5D6124766
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 22:07:14 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id 63so11268757vse.2
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 22:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=HiW3TdjVmVwW8GNu/4McOJOrXzbq3k0W3H5yXBYirxQ=;
        b=AYZr/JFcESQLtx9OJMCRSbhX4GciuvazCI8VGRPHoq/8GbqegiwixOe5tpQP9Nir/T
         fcnZ0jvVuq2G4z4fTw0ClxeUEdqmm4PEOXQTKZU5wW3lp2M3iDEzQozpPwWiBWRLRAUA
         dcgkCzKhd9w+i9VunC5TxxCkZruqTcRSo1tDxTR3utLHZI35U4CKAbVOJggrf2JgEkBg
         s4I/q+H6Y4c+Dj6jbZGGtmXZAhdGZjJk2Bj8h5C1mAHeiZRAVHx92dNgcbCSIOXQeztN
         3fj1J2ir1kw5lSsgUDOFEAOYzFurBoUr+XSnqy8TsN5XJKSaoYeBRJAyHM5EY6085VQe
         NdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=HiW3TdjVmVwW8GNu/4McOJOrXzbq3k0W3H5yXBYirxQ=;
        b=ZuBPeq2sW1XCpjQO/g649+7zKdqG+/hazWwEobRBhmG8Ao6APNKJz40IZegtmtQhpK
         lfaGhvwiA/CDtpZnzKCi+UgnkDmKlkDuUppFlyRW0vG8e1i/qNsgyn3ei07wV1AQVx0n
         nlVP2YdrM6G/hd+B/23zbiQdB1J4uHtEJqE/2Gk5G3YzT/kBdfZAJWtTh8DOG9AvKE71
         MFVeELBLZ+NZf/dT17TuD1/2dQf2gjAP7ZYaMEKq+7wz/3gWCPmdVbJpWm5ZoOnfEU0Q
         TFMC4LxSQqm44BeufKBvA6C+loaBQS0TJXFrBt1dCeObK6IiINaSw2Hexxq7PQcMoiLg
         iRQg==
X-Gm-Message-State: ACrzQf15ndKF1qHYUuyQ6A2i/jiHlhULrq223Cm2egJLTjjmJ0CMQ8Z3
        LoPAk/BryufhDV5cSpitU9m82oPAuBwGWJSQQiY=
X-Google-Smtp-Source: AMsMyM6R5K1MeKb1f69OKyy6vhyoJJe5Ds8nSlfQzNGc6j63k2m+3x/Ll0/2ohf2Ho/ltKkvC1+H4epYw+FyDw83hPs=
X-Received: by 2002:a67:1d87:0:b0:398:6d94:dbf4 with SMTP id
 d129-20020a671d87000000b003986d94dbf4mr2542103vsd.6.1663909633064; Thu, 22
 Sep 2022 22:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220923005636.626014-1-lsahlber@redhat.com> <20220923005636.626014-3-lsahlber@redhat.com>
In-Reply-To: <20220923005636.626014-3-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Sep 2022 00:07:02 -0500
Message-ID: <CAH2r5mvi7rJM3uhEgbmEW5V7bGyjtcAapOaMSDn=kwfh=KUDDw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: Add a laundromat thread that will timeout any
 directory leases we have
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixing minor whitespace error and tentatively pushed to cifs-2.6.git
for-next pending testing

On Thu, Sep 22, 2022 at 7:56 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> after a timeout of 5 seconds. Later we will add instrumentation to tweak this value.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cached_dir.h |  1 +
>  2 files changed, 71 insertions(+)
>
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index e2f2052dbabf..ffe0dea08b17 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -95,6 +95,7 @@ path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
>                 dput(dentry);
>                 dentry = child;
>         } while (!IS_ERR(dentry));
> +
>         return dentry;
>  }
>
> @@ -498,6 +499,55 @@ static void free_cached_dir(struct cached_fid *cfid)
>         kfree(cfid);
>  }
>
> +
> +
> +static int
> +cifs_cfids_laundromat_thread(void *p)
> +{
> +       struct cached_fids *cfids = p;
> +       struct cached_fid *cfid, *q;
> +       struct list_head entry;
> +
> +       while (!kthread_should_stop()) {
> +               ssleep(1);
> +               INIT_LIST_HEAD(&entry);
> +               if (kthread_should_stop())
> +                       return 0;
> +               spin_lock(&cfids->cfid_list_lock);
> +               list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> +                       if (time_after(jiffies, cfid->time + HZ * 5)) {
> +                               list_del(&cfid->entry);
> +                               list_add(&cfid->entry, &entry);
> +                               cfids->num_entries--;
> +                       }
> +               }
> +               spin_unlock(&cfids->cfid_list_lock);
> +
> +               list_for_each_entry_safe(cfid, q, &entry, entry) {
> +                       cfid->on_list = false;
> +                       list_del(&cfid->entry);
> +                       /*
> +                        * Cancel, and wait for the work to finish in
> +                        * case we are racing with it.
> +                        */
> +                       cancel_work_sync(&cfid->lease_break);
> +                       if (cfid->has_lease) {
> +                               /*
> +                                * We lease has not yet been cancelled from
> +                                * the server so we need to drop the reference.
> +                                */
> +                               spin_lock(&cfids->cfid_list_lock);
> +                               cfid->has_lease = false;
> +                               spin_unlock(&cfids->cfid_list_lock);
> +                               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +                       }
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +
>  struct cached_fids *init_cached_dirs(void)
>  {
>         struct cached_fids *cfids;
> @@ -507,6 +557,20 @@ struct cached_fids *init_cached_dirs(void)
>                 return NULL;
>         spin_lock_init(&cfids->cfid_list_lock);
>         INIT_LIST_HEAD(&cfids->entries);
> +
> +       /*
> +        * since we're in a cifs function already, we know that
> +        * this will succeed. No need for try_module_get().
> +        */
> +       __module_get(THIS_MODULE);
> +       cfids->laundromat = kthread_run(cifs_cfids_laundromat_thread,
> +                                 cfids, "cifsd-cfid-laundromat");
> +       if (IS_ERR(cfids->laundromat)) {
> +               cifs_dbg(VFS, "Failed to start cfids laundromat thread.\n");
> +               kfree(cfids);
> +               module_put(THIS_MODULE);
> +               return NULL;
> +       }
>         return cfids;
>  }
>
> @@ -519,6 +583,12 @@ void free_cached_dirs(struct cached_fids *cfids)
>         struct cached_fid *cfid, *q;
>         struct list_head entry;
>
> +       if (cfids->laundromat) {
> +               kthread_stop(cfids->laundromat);
> +               cfids->laundromat = NULL;
> +               module_put(THIS_MODULE);
> +       }
> +
>         INIT_LIST_HEAD(&entry);
>         spin_lock(&cfids->cfid_list_lock);
>         list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> index e536304ca2ce..4ab9b10cd098 100644
> --- a/fs/cifs/cached_dir.h
> +++ b/fs/cifs/cached_dir.h
> @@ -57,6 +57,7 @@ struct cached_fids {
>         spinlock_t cfid_list_lock;
>         int num_entries;
>         struct list_head entries;
> +       struct task_struct *laundromat;
>  };
>
>  extern struct cached_fids *init_cached_dirs(void);
> --
> 2.35.3
>


-- 
Thanks,

Steve
