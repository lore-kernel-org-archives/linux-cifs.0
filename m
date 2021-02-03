Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820CBC433E6
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 04:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59D4C64F68
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 04:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhBCEry (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 23:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhBCEry (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 23:47:54 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7752C061573
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 20:47:13 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id f19so26795665ljn.5
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 20:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3J63keXfr9LZO1hJwDvknldoqsmfc7t5D/MRBTVB2ts=;
        b=ojx3+BWDd1zTJb8zUTuhTHHCAw3fMD/x/qnAC8U1sRJ1ZKHz3QBt4enfKfWtzWfhMV
         YiKbRUPE+6JFB2AclZ7cBX4PNjhYTy1tUo+oD5L/aQaO07gTVuug1WPBPGZvnp8lXwbj
         5G3XMpEqhUFiWSJsHpBH/nq0gkceEh8C0QayRZo9CNPTaMJ7r4VcpdJa41A1QnaMVCdZ
         Ae2/y2+oONGIIxVwV/T1gA6lN8YlZp9morXBpOr9qPjRWv/Z05iwwaZ53x0zuHO6MRpl
         z7yFUWlj5I3F65nJTbajW6OUervQG8jQr2/rX+QxHsUWAhg8ZQwKKhUjzY8r9rsEejGN
         iTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3J63keXfr9LZO1hJwDvknldoqsmfc7t5D/MRBTVB2ts=;
        b=hQ9egpZnPsLGj1CCE+7+Pi+DB+gxdIr2DMaUewOJRfRy15U7Z+uDIyUnWiy+L00n9e
         nlPljHPLEBxrUlQ5ZoYS6QJVJSnHoikOs6y48E13BZn8pbK+FhfCzH7g7DvuE7RYVapQ
         mBBWR/liCZ39xfvB4mySAcgj8yoyCHpOQssPIpiasfaZA7gHzI6XWbfC7sMhSXkIXPMR
         s/k2MTY/WQb4fipnB2NO1ZzVZWZ1ES5dL2ATc9NqqSyQFvU4DqVCzPfqlSzkmFZp6JMH
         sF8v2GW7gYOYHukSCSjGjebLeh7TULzMolxLBl4y+GOmApWN+9JklzA1PXgaIgwun1gy
         kj8w==
X-Gm-Message-State: AOAM531EGShEIy3YCSJ2fMDV8t6/AkF4sB40LXvnkTkLy2KeHhGfSKPR
        qkJgx+M5yn9t/Ie+q3x/gu1t1XGzqU3XDTnyePA=
X-Google-Smtp-Source: ABdhPJxDK6ZGHGEG0C8kNQYgRf8NFn0U2tVV2WA3HGIfCSiAPVnyTo2vsuFMT0BGTFE+tFnBjQqKS7BxAcvaOMZ/iNE=
X-Received: by 2002:a2e:8007:: with SMTP id j7mr679136ljg.406.1612327631900;
 Tue, 02 Feb 2021 20:47:11 -0800 (PST)
MIME-Version: 1.0
References: <20210202195538.243256-1-pshilov@microsoft.com> <a435fcf3-2b6c-1697-5efa-78b3617729a4@talpey.com>
In-Reply-To: <a435fcf3-2b6c-1697-5efa-78b3617729a4@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Feb 2021 22:47:00 -0600
Message-ID: <CAH2r5mvM+vAHphxv4zL4Ubk57YqBo7GoPpPw2=nN9qMFOYwPRQ@mail.gmail.com>
Subject: Re: [PATCH v2] CIFS: Wait for credits if at least one request is in flight
To:     Tom Talpey <tom@talpey.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated patch (had minor merge conflict) and added the two reviewed-by
and tentatively merged into cifs-2.6.git

On Tue, Feb 2, 2021 at 3:37 PM Tom Talpey <tom@talpey.com> wrote:
>
> Updated comment looks good!
>
> Reviewed-By: Tom Talpey <tom@talpey.com>
>
> On 2/2/2021 2:55 PM, Pavel Shilovsky wrote:
> > Currently we try to guess if a compound request is going to succeed
> > waiting for credits or not based on the number of requests in flight.
> > This approach doesn't work correctly all the time because there may
> > be only one request in flight which is going to bring multiple credits
> > satisfying the compound request.
> >
> > Change the behavior to fail a request only if there are no requests
> > in flight at all and proceed waiting for credits otherwise.
> >
> > Cc: <stable@vger.kernel.org> # 5.1+
> > Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> > ---
> >   fs/cifs/transport.c | 18 +++++++++++++++---
> >   1 file changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 4ffbf8f965814..eab7940bfebef 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -659,10 +659,22 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
> >       spin_lock(&server->req_lock);
> >       if (*credits < num) {
> >               /*
> > -              * Return immediately if not too many requests in flight since
> > -              * we will likely be stuck on waiting for credits.
> > +              * If the server is tight on resources or just gives us less
> > +              * credits for other reasons (e.g. requests are coming out of
> > +              * order and the server delays granting more credits until it
> > +              * processes a missing mid) and we exhausted most available
> > +              * credits there may be situations when we try to send
> > +              * a compound request but we don't have enough credits. At this
> > +              * point the client needs to decide if it should wait for
> > +              * additional credits or fail the request. If at least one
> > +              * request is in flight there is a high probability that the
> > +              * server will return enough credits to satisfy this compound
> > +              * request.
> > +              *
> > +              * Return immediately if no requests in flight since we will be
> > +              * stuck on waiting for credits.
> >                */
> > -             if (server->in_flight < num - *credits) {
> > +             if (server->in_flight == 0) {
> >                       spin_unlock(&server->req_lock);
> >                       return -ENOTSUPP;
> >               }
> >



-- 
Thanks,

Steve
