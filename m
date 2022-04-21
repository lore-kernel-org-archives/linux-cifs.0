Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA941C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Apr 2022 03:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiDUD73 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Apr 2022 23:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiDUD71 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Apr 2022 23:59:27 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C87BE0F
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 20:56:38 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id d6so6430768lfv.9
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 20:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rRx4L2CHsz86TEbv0uwOKd+BU3ps3DZSrOFXOx4XLZg=;
        b=dVaVEHpmNbiPrInpPHsq4lRTUrF9XLm9G08WuEbdCLGJqHdmxFk2/fBLCzDQjq/IUU
         8How7ikDTJ09WXkq8XBUbylEZVtb6pOa7qBSoWioJHr03dHDzseXSQLAS/ksWh8EYQmy
         SBtwZjpc+PxfskBqWGJaJvAr5Ig7Mw+QuxTDLAWItbElmVEcElq1FtqveYUPC2ns39Eo
         DonFbUY0Nl/o5yyCDUTClAq7bE02AQFTfe/I8YgNrfM3+sR5YWqm+mICOtIkWLgsaUhD
         Uj7uFCv+D5u/Rq0BGyhEJevK1CeI5QbiziLj0CZyyALGh/Sx89JTBCyyhdDjSUj1gySu
         8PFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rRx4L2CHsz86TEbv0uwOKd+BU3ps3DZSrOFXOx4XLZg=;
        b=cCQjWnPV3EFyPSmsiTlM0SQCDssAvvuAw0voHj3e2n6vaaS2hPNKjTkbvZMJJJQXhy
         v5nuvicJ3jySqcOPSsRPZtXk9DkYdY2d3i4XTr77e0AmMxnyxc2k1jw8oAPook0vvCgB
         OWpkxy+xn2U7SdkCgd77GnIoZpWJ6oratvt9C0K/dzbHy8DuNVHyDPpM/j9CbiXBHA8v
         ySORTXajGK1C4iwMxjPNLU9CQS6N6qYOucSSIVQKnqwYUVYKb+n5udYPw47Sd7P9nbev
         5U1XfuvzDZqNexDRQSRWyeCeROQjRm7rD+DmqTJfxctmeBO0IAp1qUf+OMLGYvzRR7Fy
         vu1A==
X-Gm-Message-State: AOAM5300dNpckQ6pjNYYVA0ymg1zQVGTuBNAhQA53KNEu1OOB5yySxa9
        NnZ3n0a/kMnu4EEZlg4v7XUMWylmam/5OGQBKKlxwzURLJM=
X-Google-Smtp-Source: ABdhPJycFfJ/ZS7ZftdFdeXRgTQ9dlZ8uZCsUwam4kh5uASOmE3LncsvxVCmulRKe2MkkJy1nHIjC4Vksg6uRioWcwc=
X-Received: by 2002:a05:6512:1389:b0:471:a7fa:d5d3 with SMTP id
 p9-20020a056512138900b00471a7fad5d3mr7844072lfa.667.1650513396994; Wed, 20
 Apr 2022 20:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220421000546.5129-1-pc@cjr.nz> <20220421000546.5129-2-pc@cjr.nz>
 <CAGvGhF7R4dyohbTg1+zVNiLpHp2x_oe3E+uFQZSr8fK0cspagA@mail.gmail.com>
In-Reply-To: <CAGvGhF7R4dyohbTg1+zVNiLpHp2x_oe3E+uFQZSr8fK0cspagA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Apr 2022 22:56:25 -0500
Message-ID: <CAH2r5mtuWAozjD16ZQyV6Xi9Th9HpAQBvafkxygj57A=AqzCaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: use correct lock type in cifs_reconnect()
To:     Leif Sahlberg <lsahlber@redhat.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added CC:Stable and Reviewed-by and pushed to cifs-2.6.git for-next
pending testing

On Wed, Apr 20, 2022 at 9:39 PM Leif Sahlberg <lsahlber@redhat.com> wrote:
>
> looks good to me.
> Reviewed-by me
>
> On Thu, Apr 21, 2022 at 10:06 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > TCP_Server_Info::origin_fullpath and TCP_Server_Info::leaf_fullpath
> > are protected by refpath_lock mutex and not cifs_tcp_ses_lock
> > spinlock.
> >
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > ---
> >  fs/cifs/connect.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 2c24d433061a..42e14f408856 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -534,12 +534,19 @@ int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
> >  {
> >         /* If tcp session is not an dfs connection, then reconnect to last target server */
> >         spin_lock(&cifs_tcp_ses_lock);
> > -       if (!server->is_dfs_conn || !server->origin_fullpath || !server->leaf_fullpath) {
> > +       if (!server->is_dfs_conn) {
> >                 spin_unlock(&cifs_tcp_ses_lock);
> >                 return __cifs_reconnect(server, mark_smb_session);
> >         }
> >         spin_unlock(&cifs_tcp_ses_lock);
> >
> > +       mutex_lock(&server->refpath_lock);
> > +       if (!server->origin_fullpath || !server->leaf_fullpath) {
> > +               mutex_unlock(&server->refpath_lock);
> > +               return __cifs_reconnect(server, mark_smb_session);
> > +       }
> > +       mutex_unlock(&server->refpath_lock);
> > +
> >         return reconnect_dfs_server(server);
> >  }
> >  #else
> > --
> > 2.35.3
> >
>


-- 
Thanks,

Steve
