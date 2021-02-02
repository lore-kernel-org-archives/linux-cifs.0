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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA2DC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4933064F6A
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhBBSUf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238470AbhBBSSs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 13:18:48 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D13C0613ED
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 10:18:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g10so5729993eds.2
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 10:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T9gj7OIrcg4lBNUAaeh50TT0hOOC1PeFaOKk618aYA0=;
        b=XdKY9wg3RbeHs4QwexiuHUVySSkXEM+9HGt1ry8LylirKDSlwC1gWywqj4Hpv/ZYOc
         RbrepXaV9lxTAs57cZ/5G84XbevRh9YLrgydx7xWAYD/+iQ5SH2XhXDQm9Wa7bGUftDY
         gWoar2U1K5ohBoDYKWBlzGbyLfEoa5UyD0DUB3Eepb1q84lnb3yOm0CYeW67MHuqWvQn
         uREZPBTym5o7LykfjujQAvKb4GtHLBwi5v9cA+2XUs7flelce5ti7kNrZJDim25UjVCc
         9P2EgeOdfyPrlUfPRN5VsoH9fWJn1OU9UOXo9taux9Im29ETftjuNblp/58lPvOzHvJq
         nwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T9gj7OIrcg4lBNUAaeh50TT0hOOC1PeFaOKk618aYA0=;
        b=Z/VQzpHiHm1fiUzGMzQzdb2B7e5AtMPAF/tjuWhxqpPY+53NoUDwTVGAObxhvrYnUS
         2ka/8ZUXjU0WHKJR57IQe0Vk+/8ln7/sl8NO8tVXEYYATd7x4o1bwhFCWpjQ/WK1kC7m
         /SdSwOmKa8s+Elv4+mEDWY5o7OmQ3W0Y7k5zzrvFMCgOFnzTh+Vu9iahNhPfH/XhWpLB
         ljoG7vn1jL2Ob7dQvqsFw8nTzH8YFExST77L+CTyHmdrAyrEm0ovrffnYgwZ+6ZYTWCY
         ZwP79XIqXxA/9fpVVVakn2Uow/CLunV94d3ftt9ODJUrT201yei+0RT4q+ZU26oCOKSc
         dZQw==
X-Gm-Message-State: AOAM531/X6cUJVpHCpATPEQnY8p6BgMv8hSJZcMp6KzCjFGuEgCqt4f8
        JZ9qPlCsU4w0RGXmiUbzqmyEQW/11BTQaqUPPw==
X-Google-Smtp-Source: ABdhPJyCzPC5x/ea1IhmEPFQ6pgabpt+wsz+/oE4HzettxMPaFfoip1Uq1Ilo7nPVx7avbnk5vwkDZZ7IPDIk3yF4Ao=
X-Received: by 2002:a50:fd84:: with SMTP id o4mr219047edt.340.1612289886924;
 Tue, 02 Feb 2021 10:18:06 -0800 (PST)
MIME-Version: 1.0
References: <20210202010105.236700-1-pshilov@microsoft.com> <40f473ff-bdd5-059c-36f1-d181eaa71200@talpey.com>
In-Reply-To: <40f473ff-bdd5-059c-36f1-d181eaa71200@talpey.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 2 Feb 2021 10:17:55 -0800
Message-ID: <CAKywueRkvEjaZ+u4QhG+aVKFKUf-smWRqLmeeRC-2=4xU=zmDA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Wait for credits if at least one request is in flight
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I agree that the error code may not be ideal. Shyam has a WIPto
replace it with EBUSY but EDEADLK may be a good alternative too. For
this patch I would prefer not to change the error code and only fix
the bug to allow less ricky backporting.

Yes. If the server is tight on resources or just gives us less credits
for other reasons (e.g. requests are coming out of order and the
server delays granting more credits until it receives a missing mid)
and we exhausted most available credits there may be situations when
we try to send a compound request but we don't have enough credits. At
this point the client needs to decide if it should wait for credits or
fail a request. If at least one request is in flight there is a high
probability that the server returns enough credits to satisfy the
compound request (which are usually 3-4 credits long). So, we don't
want to fail the request in this case.

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 1 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 19:39, Tom Ta=
lpey <tom@talpey.com>:
>
> It's reasonable to fail a request that can never have sufficient
> credits to send, but EOPNOTSUPP is a really strange error to return.
> The operation might work if the payload were smaller, right? So,
> would a resource error such as EDEADLK be more meaningful, and allow
> the caller to recover, even?
>
> Also, can you elaborate on why this is only triggered when no
> requests at all are in flight? Or is this some kind of corner
> case for requests that need every credit the server currently
> is offering?
>
> Tom.
>
> On 2/1/2021 8:01 PM, Pavel Shilovsky wrote:
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
> >   fs/cifs/transport.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 4ffbf8f965814..84f33fdd1f4e0 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -659,10 +659,10 @@ wait_for_compound_request(struct TCP_Server_Info =
*server, int num,
> >       spin_lock(&server->req_lock);
> >       if (*credits < num) {
> >               /*
> > -              * Return immediately if not too many requests in flight =
since
> > -              * we will likely be stuck on waiting for credits.
> > +              * Return immediately if no requests in flight since
> > +              * we will be stuck on waiting for credits.
> >                */
> > -             if (server->in_flight < num - *credits) {
> > +             if (server->in_flight =3D=3D 0) {
> >                       spin_unlock(&server->req_lock);
> >                       return -ENOTSUPP;
> >               }
> >
