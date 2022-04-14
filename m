Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C79C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Apr 2022 14:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiDNOQc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Apr 2022 10:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345078AbiDNNpE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Apr 2022 09:45:04 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC126AD1
        for <linux-cifs@vger.kernel.org>; Thu, 14 Apr 2022 06:41:35 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2eafabbc80aso55263767b3.11
        for <linux-cifs@vger.kernel.org>; Thu, 14 Apr 2022 06:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=luXXILNq2DhmHEepTzCXJzrk1cu7M7vrlYAPl7mYh6I=;
        b=Ij2kQLulHRA4R73Np3G/DRWEmMapR8Wm2kcizD8Nod3BkYBtRqij1BFcpiBJI2sQeK
         SLJthNJUIxbEWJPMYFs4Xm9FTJVDDhrj6c//7KPZuNKKZjSathzJGFiJ2cGA94V5CTT0
         nXs290M56PkBJclP8CwCYONdOB1c+SIzG33g+a4U0owdnGFfVI0BwUuGrJhSo4WCF+fX
         +8SFAPvNYq5LEAvN+3D58mRtxGYLobEUQurPInLHl8cBbDd7NmR+5ltgXdkCwVq1W1UV
         bvnFDJZ8Us+0zBnHrgAonJycDdUW6GW3oOiMIepW+c4hrFEZ4W+KR/+tDVq5s6X7fzvg
         01fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=luXXILNq2DhmHEepTzCXJzrk1cu7M7vrlYAPl7mYh6I=;
        b=bS0zojRcoyGIDheRSsj6FTo1ityOgviYZnun2PHT9taEV2XCxmrE0zqYYfGqgUoC9H
         SamFjhWEZTXYOFi6Pbkl262/FS3QZ036jx92FsVhd1p0WNq8V5aF3aoW47ukCcPqlF11
         KzZhy3sBI8XeC6xM1Flz7Kmas9802v7xJLJ7+w4bbssNTHM5fndeFFsrrY4LHyxImA8x
         ZdDTrMMPMvzPVUK+gteuf0t8HJinaKfkhrAZZMQSvgj1EMoEk/mp9bE9p1o1/kkUk8HN
         69dtArbyYmW79qAiSld9iqxvtWBfk1cFIrGy4YEOEpYLrRv4WDvnJgF6P81xgJ7qWQwE
         qp7A==
X-Gm-Message-State: AOAM530DtyeR/9D5nih9c5lrXxtl8kmA74uIVMNYfzl3eLwmueSgOoOM
        XXfMMf+UZ/BmwkiAHw2fsrZ2oVNBQpLnIgIsr9rilYVu
X-Google-Smtp-Source: ABdhPJxnOZapDCczrDdOaiR6TTb1Y9yAv03oeWcRHvETKTNBQEZqWbXYLyEYZXsmbwUuoE7nErSbTCLqjwQvs/f5s8o=
X-Received: by 2002:a81:616:0:b0:2eb:e63e:1541 with SMTP id
 22-20020a810616000000b002ebe63e1541mr2002954ywg.127.1649943694742; Thu, 14
 Apr 2022 06:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220413000217.1609615-1-lsahlber@redhat.com> <CANT5p=qNPjYNjBjOk-QHJxhLNRKgHJOXnVqqUTQZK3+Od8RBTw@mail.gmail.com>
In-Reply-To: <CANT5p=qNPjYNjBjOk-QHJxhLNRKgHJOXnVqqUTQZK3+Od8RBTw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 14 Apr 2022 23:41:23 +1000
Message-ID: <CAN05THSk=mj5j4+XvirYSPnR9Te1vWQ4=DqfehX5rN+8V95KYA@mail.gmail.com>
Subject: Re: [PATCH] cifs: verify that tcon is valid before dereference in cifs_kill_sb
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 14, 2022 at 11:33 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Wed, Apr 13, 2022 at 7:06 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > On umount, cifs_sb->tlink_tree might contain entries that do not represent
> > a valid tcon.
> > Check the tcon for error before we dereference it.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index aba0783a8f09..25719b70564a 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -266,10 +266,11 @@ static void cifs_kill_sb(struct super_block *sb)
> >          * before we kill the sb.
> >          */
> >         if (cifs_sb->root) {
> > -               node = rb_first(root);
> > -               while (node != NULL) {
> > +               for(node = rb_first(root); node; node = rb_next(node)) {
> >                         tlink = rb_entry(node, struct tcon_link, tl_rbnode);
> >                         tcon = tlink_tcon(tlink);
> > +                       if (IS_ERR(tcon))
> > +                               continue;
> >                         cfid = &tcon->crfid;
> >                         mutex_lock(&cfid->fid_mutex);
> >                         if (cfid->dentry) {
> > @@ -277,7 +278,6 @@ static void cifs_kill_sb(struct super_block *sb)
> >                                 cfid->dentry = NULL;
> >                         }
> >                         mutex_unlock(&cfid->fid_mutex);
> > -                       node = rb_next(node);
> >                 }
> >
> >                 /* finally release root dentry */
> > --
> > 2.30.2
> >
>
> The changes look good to me.
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>
> Does this cover all the mount failure scenarios, Ronnie?

It should. It should also fix similar issues at umount if an idle tcon
has been reaped, or say a tcon failed to initialize during multiuser.
For example, mount multiuser, then try to access the share with a
different user without credentials. That second tcon will fail
and then when we umount we would oops.

>
> --
> Regards,
> Shyam
