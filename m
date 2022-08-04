Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEDDC19F2A
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 15:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiHDPnm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Aug 2022 11:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbiHDPnl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Aug 2022 11:43:41 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62C426119
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 08:43:38 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id 129so21498003vsq.8
        for <linux-cifs@vger.kernel.org>; Thu, 04 Aug 2022 08:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OvdNUhOOPbILr6C5fNY57TbihqekypTpqn2mG9RnyjE=;
        b=MlkgURjPdBKxdLv0JHI/GNojUzGdw5Cy1rGKxhtKHKiPd2WHPjoYUfdyCe8LE1JZx+
         fbQMvBJWCbVYq7B7m1jJwUw0ZlMpsIlbkK/nvIcyKx31NQzpBwci4owvylnrJ2SPN5Gv
         0Gp9qYTlEQpIyyGoIQlE3LJdkSjs8kLqqR+m5fHoHXpHeV5F5HGoeUS7W+/iOPfbuwPa
         bFlUxkfb/R1oZrlQKh3G3hpMVRUCDTwIVePxLxlXhgo587XE97/KIs/95r57hYntaEJU
         XJXO1lthUqrAQklp/Gx7jb2GFywxdaGRUDuqXKW5a2YgCrhsw7YXJJGSBhfpsHnQ7Pkd
         9qqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OvdNUhOOPbILr6C5fNY57TbihqekypTpqn2mG9RnyjE=;
        b=lf3hY9po5jJNjvI42aCKIv8MC9sVNLJfva/V0nspzgRUJ3EhaaYv8vWKJVVXoDMSwv
         ObdHnO5a/PxS2YdsMgUuPYjPJlxQKEikupl5Uoc6H8VyVmeG3JH3gs02yXaRgei7Oh6O
         4cJ+v3jcN0Kwil6wx0/SrqF4bj7C3pojIHyzXayCO9ybVRpEEKuE3+93ReDrD+lGmINe
         J/Ys7cUafKKlLvS6aiXhl733Agt7e15/R66l5lq2qb6z3JB3EHRK/S0P5Gylq9JcYI55
         l0o7BOQcM99umJCTG4MpQ+UsMysWS6b9oqczost/tM7o7GE32sVSed0MKGnuZOm5x/0a
         sJYQ==
X-Gm-Message-State: ACgBeo17w8eqlbJt3NbJUc1JlbrT4cco5Qi1T8bV/bWHHjHx8swb72gC
        dgVdof+xL8SzQWoLSfGQCfHzyt5L1JAoU4+Xiyo=
X-Google-Smtp-Source: AA6agR7GzPE2RRbA8X94J0kf3MkyaCev6v69ENA2HmabyJIGl/P1xKhueyhYl2ZCZFTTedq9LfqdLxW70gdnuB86tZ4=
X-Received: by 2002:a67:ce90:0:b0:388:4905:1533 with SMTP id
 c16-20020a67ce90000000b0038849051533mr1262792vse.17.1659627817657; Thu, 04
 Aug 2022 08:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220802211124.4014-1-ematsumiya@suse.de>
In-Reply-To: <20220802211124.4014-1-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Aug 2022 10:43:26 -0500
Message-ID: <CAH2r5mtMrSyNUbcFRyOOwq38mvp2WY6LsYAT28Lsz2JWeNx3Fw@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove useless DeleteMidQEntry()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

How about simple change to this to remove "cifs" (since not smb1
specific) and call it something like:
  "release_mid_q_entry" or "mid_q_entry_release" ?

could also change AllocMidQEntry to something similar in the same
patch (it is trivial,
only used in 3 places) to be more consistent, easier to read:
   "alloc_mid_q_entry" (or "mid_q_entry_alloc")

On Tue, Aug 2, 2022 at 4:11 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> DeleteMidQEntry() was just a proxy for cifs_mid_q_entry_release().
>
> Remove DeleteMidQEntry(), rename cifs_mid_q_entry_release() to
> cifs_release_mid().
>
> Also rename the kref_put() callback _cifs_mid_q_entry_release to
> __cifs_release_mid.
>
> Update callers to cifs_mid_q_entry_release and DeleteMidQEntry to use
> cifs_release_mid.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifsproto.h     |  3 +--
>  fs/cifs/cifssmb.c       |  6 +++---
>  fs/cifs/connect.c       |  8 ++++----
>  fs/cifs/smb2ops.c       |  2 +-
>  fs/cifs/smb2pdu.c       |  6 +++---
>  fs/cifs/smb2transport.c |  2 +-
>  fs/cifs/transport.c     | 25 ++++++++++---------------
>  7 files changed, 23 insertions(+), 29 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index de167e3af015..853ea4c8d88e 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -81,9 +81,8 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
>  /* extern void renew_parental_timestamps(struct dentry *direntry);*/
>  extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
>                                         struct TCP_Server_Info *server);
> -extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
>  extern void cifs_delete_mid(struct mid_q_entry *mid);
> -extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
> +extern void cifs_release_mid(struct mid_q_entry *mid);
>  extern void cifs_wake_up_task(struct mid_q_entry *mid);
>  extern int cifs_handle_standard(struct TCP_Server_Info *server,
>                                 struct mid_q_entry *mid);
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 26b9d2438228..f0d72575e3c0 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -591,7 +591,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
>         struct TCP_Server_Info *server = mid->callback_data;
>         struct cifs_credits credits = { .value = 1, .instance = 0 };
>
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>         add_credits(server, &credits, CIFS_ECHO_OP);
>  }
>
> @@ -1336,7 +1336,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>         }
>
>         queue_work(cifsiod_wq, &rdata->work);
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>         add_credits(server, &credits, 0);
>  }
>
> @@ -1684,7 +1684,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
>         }
>
>         queue_work(cifsiod_wq, &wdata->work);
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>         add_credits(tcon->ses->server, &credits, 0);
>  }
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index abb65dd7471f..eb7e75deb9d2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -334,7 +334,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
>         list_for_each_entry_safe(mid, nmid, &retry_list, qhead) {
>                 list_del_init(&mid->qhead);
>                 mid->callback(mid);
> -               cifs_mid_q_entry_release(mid);
> +               cifs_release_mid(mid);
>         }
>
>         if (cifs_rdma_enabled(server)) {
> @@ -1007,7 +1007,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>                         cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
>                         list_del_init(&mid_entry->qhead);
>                         mid_entry->callback(mid_entry);
> -                       cifs_mid_q_entry_release(mid_entry);
> +                       cifs_release_mid(mid_entry);
>                 }
>                 /* 1/8th of sec is more than enough time for them to exit */
>                 msleep(125);
> @@ -1246,7 +1246,7 @@ cifs_demultiplex_thread(void *p)
>                 if (length < 0) {
>                         for (i = 0; i < num_mids; i++)
>                                 if (mids[i])
> -                                       cifs_mid_q_entry_release(mids[i]);
> +                                       cifs_release_mid(mids[i]);
>                         continue;
>                 }
>
> @@ -1273,7 +1273,7 @@ cifs_demultiplex_thread(void *p)
>                                 if (!mids[i]->multiRsp || mids[i]->multiEnd)
>                                         mids[i]->callback(mids[i]);
>
> -                               cifs_mid_q_entry_release(mids[i]);
> +                               cifs_release_mid(mids[i]);
>                         } else if (server->ops->is_oplock_break &&
>                                    server->ops->is_oplock_break(bufs[i],
>                                                                 server)) {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 82dd2e973753..ad3b13283717 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -5099,7 +5099,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
>                                 spin_unlock(&dw->server->srv_lock);
>                         }
>                 }
> -               cifs_mid_q_entry_release(mid);
> +               cifs_release_mid(mid);
>         }
>
>  free_pages:
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 131bec79d6fd..a24e05586d5c 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3776,7 +3776,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
>                 credits.instance = server->reconnect_instance;
>         }
>
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>         add_credits(server, &credits, CIFS_ECHO_OP);
>  }
>
> @@ -4201,7 +4201,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
>                                      rdata->offset, rdata->got_bytes);
>
>         queue_work(cifsiod_wq, &rdata->work);
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>         add_credits(server, &credits, 0);
>  }
>
> @@ -4440,7 +4440,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
>                                       wdata->offset, wdata->bytes);
>
>         queue_work(cifsiod_wq, &wdata->work);
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>         add_credits(server, &credits, 0);
>  }
>
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index f64922f340b3..f3068786a199 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -890,7 +890,7 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
>         rc = smb2_sign_rqst(rqst, server);
>         if (rc) {
>                 revert_current_mid_from_hdr(server, shdr);
> -               DeleteMidQEntry(mid);
> +               cifs_release_mid(mid);
>                 return ERR_PTR(rc);
>         }
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 914a7aaf9fa7..24caf1fb7213 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -74,7 +74,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
>         return temp;
>  }
>
> -static void _cifs_mid_q_entry_release(struct kref *refcount)
> +static void __cifs_release_mid(struct kref *refcount)
>  {
>         struct mid_q_entry *midEntry =
>                         container_of(refcount, struct mid_q_entry, refcount);
> @@ -153,20 +153,15 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
>         mempool_free(midEntry, cifs_mid_poolp);
>  }
>
> -void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
> +void cifs_release_mid(struct mid_q_entry *mid)
>  {
> -       struct TCP_Server_Info *server = midEntry->server;
> +       struct TCP_Server_Info *server = mid->server;
>
>         spin_lock(&server->mid_lock);
> -       kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
> +       kref_put(&mid->refcount, __cifs_release_mid);
>         spin_unlock(&server->mid_lock);
>  }
>
> -void DeleteMidQEntry(struct mid_q_entry *midEntry)
> -{
> -       cifs_mid_q_entry_release(midEntry);
> -}
> -
>  void
>  cifs_delete_mid(struct mid_q_entry *mid)
>  {
> @@ -177,7 +172,7 @@ cifs_delete_mid(struct mid_q_entry *mid)
>         }
>         spin_unlock(&mid->server->mid_lock);
>
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>  }
>
>  /*
> @@ -791,7 +786,7 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
>
>         rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
>         if (rc) {
> -               DeleteMidQEntry(mid);
> +               cifs_release_mid(mid);
>                 return ERR_PTR(rc);
>         }
>
> @@ -940,7 +935,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
>         }
>         spin_unlock(&server->mid_lock);
>
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>         return rc;
>  }
>
> @@ -1029,7 +1024,7 @@ static void
>  cifs_cancelled_callback(struct mid_q_entry *mid)
>  {
>         cifs_compound_callback(mid);
> -       DeleteMidQEntry(mid);
> +       cifs_release_mid(mid);
>  }
>
>  /*
> @@ -1425,7 +1420,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
>                 spin_lock(&server->mid_lock);
>                 if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
>                         /* no longer considered to be "in-flight" */
> -                       midQ->callback = DeleteMidQEntry;
> +                       midQ->callback = cifs_release_mid;
>                         spin_unlock(&server->mid_lock);
>                         add_credits(server, &credits, 0);
>                         return rc;
> @@ -1606,7 +1601,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
>                         spin_lock(&server->mid_lock);
>                         if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
>                                 /* no longer considered to be "in-flight" */
> -                               midQ->callback = DeleteMidQEntry;
> +                               midQ->callback = cifs_release_mid;
>                                 spin_unlock(&server->mid_lock);
>                                 return rc;
>                         }
> --
> 2.35.3
>


-- 
Thanks,

Steve
