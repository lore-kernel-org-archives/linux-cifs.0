Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FADBC433DB
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Jan 2021 04:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA4620449
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Jan 2021 04:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhAFE1m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jan 2021 23:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAFE1m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jan 2021 23:27:42 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF637C06134C;
        Tue,  5 Jan 2021 20:27:01 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m25so3649686lfc.11;
        Tue, 05 Jan 2021 20:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zTK2J54FnZffWvRbx4mbZpAaWIjHl2sQ8iSg0f7XF+o=;
        b=Thrp8TYeerkOhatWx2pTbUQWDkB+b/OayEfDfd4RqZVjKKA8MsPe00P8b3GTFp2tLB
         UToj/RwSlhESyXzhvIf/kuXdSg21I4gUlatImkBV4t0ttr9b4LyoMi3d2tTYOeTdD1lo
         jnIzgNjI41LO5fumdhphLqlSqYQ6p3kgDlEoxWzLBlvYUUemsehtBxuJWL6u7SLdpdxZ
         Zt0fRiv6nmIiK9z6XqCWCkZsJZJgT0ihS61ca36HpGKxE0lRbyJSP5zl8SCq0BdNoj0c
         ydc6TLSVC0U4PtftTpptTf8vdz9W6JqkyM3DmBocGx+QRHY90WpB0fuvAvXRC1D3gTkP
         jqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zTK2J54FnZffWvRbx4mbZpAaWIjHl2sQ8iSg0f7XF+o=;
        b=gwC+L+RuhB93nJC3hS92w7gUfs9Oovn4EnPpERlNsMXVAxlJkNH3BXGT9/fXRLVHa9
         JPP88aQtGhfELqjUwgxZ4aLQYO/71C3bVDzOcbq7ESfnmiM12KFBY9gqkAnAaDQhldxG
         KFOmJDfBifqijAbdWZjUOyRs6AQAwjzlSLPx5C+KZnSa7EdrlRhQn8sMVFRpso32CQPz
         jyVzpIVaviOTWVV1AfFdlOaQjczduxA2LRQjWG8cmTi/ZQ1nHWR0ivy0vKUS2mvj5JLd
         UPRgWzgeugSa0qYfoXqOsmrMFFNXffRfss+TJS3FOWrZ3i4Gtoc1TYSy897j36QN3wlS
         7WXw==
X-Gm-Message-State: AOAM533h3DUXVv3QaKFXGaBlVYWO71ywosQgD0jI4qw/6gRwbchjbQFm
        9/U+gGuI148Re6fLsfJiY8NPZVWP3zuiIvjPwqg=
X-Google-Smtp-Source: ABdhPJzfvnJd83idri3vFQ6Tjs+H8EGFErJQg39O8UJZkp2i/xMks3zwAmzoVR0cjlGEXvT7Kkf+9qF8a8133eWm7eY=
X-Received: by 2002:a19:6a11:: with SMTP id u17mr1107677lfu.184.1609907220071;
 Tue, 05 Jan 2021 20:27:00 -0800 (PST)
MIME-Version: 1.0
References: <1607591258-13865-1-git-send-email-yejune.deng@gmail.com>
In-Reply-To: <1607591258-13865-1-git-send-email-yejune.deng@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Jan 2021 22:26:47 -0600
Message-ID: <CAH2r5mvgjFWwEcqt8nfiU_1GJQUU7jN=eNT-t6SBEK8jke0Msg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix msleep() is imprecise
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch seems reasonable at first glance, but I was a little
concerned that we don't see many users yet of fsleep.  Has there been
pushback on converting "yield" situations from using msleep to fsleep?

On Thu, Dec 10, 2020 at 3:09 AM Yejune Deng <yejune.deng@gmail.com> wrote:
>
> See Documentation/timers/timers-howto.rst, msleep() is not
> for (1ms - 20ms), There is a more advanced API is used.
>
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  fs/cifs/cifsfs.c    |  4 ++--
>  fs/cifs/connect.c   | 14 +++++++-------
>  fs/cifs/file.c      |  6 +++---
>  fs/cifs/smbdirect.c |  2 +-
>  4 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 472cb77..d35ce52 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -664,10 +664,10 @@ static void cifs_umount_begin(struct super_block *sb)
>                 cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
>                 wake_up_all(&tcon->ses->server->request_q);
>                 wake_up_all(&tcon->ses->server->response_q);
> -               msleep(1); /* yield */
> +               fsleep(1000); /* yield */
>                 /* we have to kick the requests once more */
>                 wake_up_all(&tcon->ses->server->response_q);
> -               msleep(1);
> +               fsleep(1000);
>         }
>
>         return;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 44f9cce..62a9c64 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -538,7 +538,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
>                 if (rc) {
>                         cifs_dbg(FYI, "reconnect error %d\n", rc);
>                         mutex_unlock(&server->srv_mutex);
> -                       msleep(3000);
> +                       ssleep(3);
>                 } else {
>                         atomic_inc(&tcpSesReconnectCount);
>                         set_credits(server, 1);
> @@ -621,7 +621,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
>                 server->bigbuf = (char *)cifs_buf_get();
>                 if (!server->bigbuf) {
>                         cifs_server_dbg(VFS, "No memory for large SMB response\n");
> -                       msleep(3000);
> +                       ssleep(3);
>                         /* retry will check if exiting */
>                         return false;
>                 }
> @@ -634,7 +634,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
>                 server->smallbuf = (char *)cifs_small_buf_get();
>                 if (!server->smallbuf) {
>                         cifs_server_dbg(VFS, "No memory for SMB response\n");
> -                       msleep(1000);
> +                       ssleep(1);
>                         /* retry will check if exiting */
>                         return false;
>                 }
> @@ -729,7 +729,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
>                          * to clear and app threads to set tcpStatus
>                          * CifsNeedReconnect if server hung.
>                          */
> -                       usleep_range(1000, 2000);
> +                       fsleep(1000);
>                         length = 0;
>                         continue;
>                 }
> @@ -790,7 +790,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
>                  */
>                 cifs_dbg(FYI, "RFC 1002 negative session response\n");
>                 /* give server a second to clean up */
> -               msleep(1000);
> +               ssleep(1);
>                 /*
>                  * Always try 445 first on reconnect since we get NACK
>                  * on some if we ever connected to port 139 (the NACK
> @@ -944,7 +944,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>                  * response and going ahead and killing cifsd.
>                  */
>                 cifs_dbg(FYI, "Wait for exit from demultiplex thread\n");
> -               msleep(46000);
> +               ssleep(46);
>                 /*
>                  * If threads still have not exited they are probably never
>                  * coming home not much else we can do but free the memory.
> @@ -3655,7 +3655,7 @@ static void rfc1002mangle(char *target, char *source, unsigned int length)
>                  * significant slowing down on mount
>                  * for everyone else
>                  */
> -               usleep_range(1000, 2000);
> +               fsleep(1000);
>         }
>         /*
>          * else the negprot may still work without this
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index be46fab..75538a8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -283,7 +283,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
>  cifs_down_write(struct rw_semaphore *sem)
>  {
>         while (!down_write_trylock(sem))
> -               msleep(10);
> +               fsleep(10000);
>  }
>
>  static void cifsFileInfo_put_work(struct work_struct *work);
> @@ -2828,7 +2828,7 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
>
>                         if (wsize < wdata->bytes) {
>                                 add_credits_and_wake_if(server, &credits, 0);
> -                               msleep(1000);
> +                               ssleep(1);
>                         }
>                 } while (wsize < wdata->bytes);
>                 wdata->credits = credits;
> @@ -3563,7 +3563,7 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
>
>                         if (rsize < rdata->bytes) {
>                                 add_credits_and_wake_if(server, &credits, 0);
> -                               msleep(1000);
> +                               ssleep(1);
>                         }
>                 } while (rsize < rdata->bytes);
>                 rdata->credits = credits;
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index b029ed3..84f97f8 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1372,7 +1372,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
>         wake_up_interruptible_all(&info->wait_mr);
>         while (atomic_read(&info->mr_used_count)) {
>                 mutex_unlock(&server->srv_mutex);
> -               msleep(1000);
> +               ssleep(1);
>                 mutex_lock(&server->srv_mutex);
>         }
>         destroy_mr_list(info);
> --
> 1.9.1
>


-- 
Thanks,

Steve
