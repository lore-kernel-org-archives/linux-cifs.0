Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A454C433E6
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 11:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C63723333
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 11:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbhAGLJd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 06:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbhAGLJa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 06:09:30 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBE0C0612F5;
        Thu,  7 Jan 2021 03:09:10 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id p5so2569983qvs.7;
        Thu, 07 Jan 2021 03:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QiltxrUYrf0bVMIP9HbxN9GwYp1fqxWzzhDW62N0l4g=;
        b=bgGA8ztjwm3ylYzmfMPM6NzTYvXhpm7nBg4TwZqz7KzmyjG31owyDiHTLUiFH33jx/
         hinW2w0KkZ7EFqEo8WAzze6E3RspiV6KNvVioAh8tKwRNkQBGdA66UPPhpq0aZhKuKjf
         IZfxbgQ32y1gf7by80iesraxDgI1DESKe+jPAw97cqLZPSbEy59NfMlZp+GQDB0NAPbc
         bJ85Av/txRKjz4zwP4t1oilqoR+3tirxqlUFmQWBn+VUmVQBNY73VOmua0etFoeUMWJV
         5krh/7zjBul9cxqkPHkMFljRWsdSfBdculZY2hHRfVHnYBbNN1BdZ2z5xrnnedA3cbyJ
         AZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QiltxrUYrf0bVMIP9HbxN9GwYp1fqxWzzhDW62N0l4g=;
        b=PsqfnHLkdwy49iMpjyvU0XGm/lcHY8gIVeXBsDDE9h8joB3A13yU6PNYspyGSfHouh
         ScKw991lYJGCy1cLSYFBotTpiyNC1n810nZEjobFDD04N6UNobytvn/VceXIiy87L8qH
         jmuJFtbHiDIBpv5D943FQR2zYzIcxF9j/hz2UFvu/bPcGlOdtqkB8xIzWIWVxBPZlZMk
         psp5nc50yTQC5Y8gpqS21gLKxIFxK2j5mabrWTpoBjPQDgMHvTQlymbURs6tPPoIB5vv
         go/erLYaM3SROHy1iniLtfyS1+ogqxcD6WGrwDDrfAZPpc3CoPmgtT6ZYraDgHmHKaNI
         9Nrw==
X-Gm-Message-State: AOAM530ks/Hu/PpFLbv1VC0ATzAQbIUcB/Qsd2pIF3XVuzk4ffj1V9Pl
        xRxB3ELuAMmddpYrLIr9tH9aR2+eRcVN+Vyuz1PFJm5tw4uFUg==
X-Google-Smtp-Source: ABdhPJyUjXJKjT4naI60958bxVTPxbguSzBomuXj5zZv+dhfjxE/I7o/wzGKuPPtAqpxuEJPi3dxK8S7Zt3guWXXZLs=
X-Received: by 2002:a0c:f1ce:: with SMTP id u14mr1393819qvl.24.1610017749417;
 Thu, 07 Jan 2021 03:09:09 -0800 (PST)
MIME-Version: 1.0
References: <1607591258-13865-1-git-send-email-yejune.deng@gmail.com> <CAH2r5mvgjFWwEcqt8nfiU_1GJQUU7jN=eNT-t6SBEK8jke0Msg@mail.gmail.com>
In-Reply-To: <CAH2r5mvgjFWwEcqt8nfiU_1GJQUU7jN=eNT-t6SBEK8jke0Msg@mail.gmail.com>
From:   Yejune Deng <yejune.deng@gmail.com>
Date:   Thu, 7 Jan 2021 19:08:58 +0800
Message-ID: <CABWKuGUj41Qa-y_cApNNvLfTQPLJi2adr+ZKN6RpwFoemskoKg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix msleep() is imprecise
To:     Steve French <smfrench@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

No=E3=80=82I just see Documentation/timers/timers-howto.rst and don't
recommend using msleep() for (1ms - 20ms). It recommends using
usleep_range(). And fsleep() is flexible sleeping.


On Wed, Jan 6, 2021 at 12:27 PM Steve French <smfrench@gmail.com> wrote:
>
> This patch seems reasonable at first glance, but I was a little
> concerned that we don't see many users yet of fsleep.  Has there been
> pushback on converting "yield" situations from using msleep to fsleep?
>
> On Thu, Dec 10, 2020 at 3:09 AM Yejune Deng <yejune.deng@gmail.com> wrote=
:
> >
> > See Documentation/timers/timers-howto.rst, msleep() is not
> > for (1ms - 20ms), There is a more advanced API is used.
> >
> > Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> > ---
> >  fs/cifs/cifsfs.c    |  4 ++--
> >  fs/cifs/connect.c   | 14 +++++++-------
> >  fs/cifs/file.c      |  6 +++---
> >  fs/cifs/smbdirect.c |  2 +-
> >  4 files changed, 13 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 472cb77..d35ce52 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -664,10 +664,10 @@ static void cifs_umount_begin(struct super_block =
*sb)
> >                 cifs_dbg(FYI, "wake up tasks now - umount begin not com=
plete\n");
> >                 wake_up_all(&tcon->ses->server->request_q);
> >                 wake_up_all(&tcon->ses->server->response_q);
> > -               msleep(1); /* yield */
> > +               fsleep(1000); /* yield */
> >                 /* we have to kick the requests once more */
> >                 wake_up_all(&tcon->ses->server->response_q);
> > -               msleep(1);
> > +               fsleep(1000);
> >         }
> >
> >         return;
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 44f9cce..62a9c64 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -538,7 +538,7 @@ static inline int reconn_setup_dfs_targets(struct c=
ifs_sb_info *cifs_sb,
> >                 if (rc) {
> >                         cifs_dbg(FYI, "reconnect error %d\n", rc);
> >                         mutex_unlock(&server->srv_mutex);
> > -                       msleep(3000);
> > +                       ssleep(3);
> >                 } else {
> >                         atomic_inc(&tcpSesReconnectCount);
> >                         set_credits(server, 1);
> > @@ -621,7 +621,7 @@ static inline int reconn_setup_dfs_targets(struct c=
ifs_sb_info *cifs_sb,
> >                 server->bigbuf =3D (char *)cifs_buf_get();
> >                 if (!server->bigbuf) {
> >                         cifs_server_dbg(VFS, "No memory for large SMB r=
esponse\n");
> > -                       msleep(3000);
> > +                       ssleep(3);
> >                         /* retry will check if exiting */
> >                         return false;
> >                 }
> > @@ -634,7 +634,7 @@ static inline int reconn_setup_dfs_targets(struct c=
ifs_sb_info *cifs_sb,
> >                 server->smallbuf =3D (char *)cifs_small_buf_get();
> >                 if (!server->smallbuf) {
> >                         cifs_server_dbg(VFS, "No memory for SMB respons=
e\n");
> > -                       msleep(1000);
> > +                       ssleep(1);
> >                         /* retry will check if exiting */
> >                         return false;
> >                 }
> > @@ -729,7 +729,7 @@ static inline int reconn_setup_dfs_targets(struct c=
ifs_sb_info *cifs_sb,
> >                          * to clear and app threads to set tcpStatus
> >                          * CifsNeedReconnect if server hung.
> >                          */
> > -                       usleep_range(1000, 2000);
> > +                       fsleep(1000);
> >                         length =3D 0;
> >                         continue;
> >                 }
> > @@ -790,7 +790,7 @@ static inline int reconn_setup_dfs_targets(struct c=
ifs_sb_info *cifs_sb,
> >                  */
> >                 cifs_dbg(FYI, "RFC 1002 negative session response\n");
> >                 /* give server a second to clean up */
> > -               msleep(1000);
> > +               ssleep(1);
> >                 /*
> >                  * Always try 445 first on reconnect since we get NACK
> >                  * on some if we ever connected to port 139 (the NACK
> > @@ -944,7 +944,7 @@ static void clean_demultiplex_info(struct TCP_Serve=
r_Info *server)
> >                  * response and going ahead and killing cifsd.
> >                  */
> >                 cifs_dbg(FYI, "Wait for exit from demultiplex thread\n"=
);
> > -               msleep(46000);
> > +               ssleep(46);
> >                 /*
> >                  * If threads still have not exited they are probably n=
ever
> >                  * coming home not much else we can do but free the mem=
ory.
> > @@ -3655,7 +3655,7 @@ static void rfc1002mangle(char *target, char *sou=
rce, unsigned int length)
> >                  * significant slowing down on mount
> >                  * for everyone else
> >                  */
> > -               usleep_range(1000, 2000);
> > +               fsleep(1000);
> >         }
> >         /*
> >          * else the negprot may still work without this
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index be46fab..75538a8 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -283,7 +283,7 @@ int cifs_posix_open(char *full_path, struct inode *=
*pinode,
> >  cifs_down_write(struct rw_semaphore *sem)
> >  {
> >         while (!down_write_trylock(sem))
> > -               msleep(10);
> > +               fsleep(10000);
> >  }
> >
> >  static void cifsFileInfo_put_work(struct work_struct *work);
> > @@ -2828,7 +2828,7 @@ size_t get_numpages(const size_t wsize, const siz=
e_t len, size_t *cur_len)
> >
> >                         if (wsize < wdata->bytes) {
> >                                 add_credits_and_wake_if(server, &credit=
s, 0);
> > -                               msleep(1000);
> > +                               ssleep(1);
> >                         }
> >                 } while (wsize < wdata->bytes);
> >                 wdata->credits =3D credits;
> > @@ -3563,7 +3563,7 @@ static int cifs_resend_rdata(struct cifs_readdata=
 *rdata,
> >
> >                         if (rsize < rdata->bytes) {
> >                                 add_credits_and_wake_if(server, &credit=
s, 0);
> > -                               msleep(1000);
> > +                               ssleep(1);
> >                         }
> >                 } while (rsize < rdata->bytes);
> >                 rdata->credits =3D credits;
> > diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> > index b029ed3..84f97f8 100644
> > --- a/fs/cifs/smbdirect.c
> > +++ b/fs/cifs/smbdirect.c
> > @@ -1372,7 +1372,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
> >         wake_up_interruptible_all(&info->wait_mr);
> >         while (atomic_read(&info->mr_used_count)) {
> >                 mutex_unlock(&server->srv_mutex);
> > -               msleep(1000);
> > +               ssleep(1);
> >                 mutex_lock(&server->srv_mutex);
> >         }
> >         destroy_mr_list(info);
> > --
> > 1.9.1
> >
>
>
> --
> Thanks,
>
> Steve
