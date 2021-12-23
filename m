Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336B8C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Dec 2021 05:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhLWFCv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Dec 2021 00:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhLWFCv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Dec 2021 00:02:51 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF45C061401
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 21:02:50 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z29so16754334edl.7
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 21:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eIiKG0dE2roVXQZ2X/8BkBWHNbOXW9ib6YfgyxXX0WU=;
        b=dJ+4nVzBTFnl4985tGphq0tX4Z5STxYOpIQWQQEBOz9qHZPAzUhbGgi09f8+gDDzlh
         zWZaviVqeLDaPnSI+M+Py8ojdnBPrNYXsu8NYRACiy8E81P6ITqqPX5RY9C4yl+RKqOl
         uTDjSop5kKnxTy6xWI8FwIdfiudj9ye5Rk/bs+QJB+pr4EWkOcF8YYpVpwZFlz3b/2Oh
         aWE8/rIj3huYhZOgBmuVoMKa/DSKo3SZNQARIeNez8lCj/jDrXW9Nnp2a4lJytsUfVSx
         UCWe+2ePtX2qB3qj+xer7dNvIOopBRKgHBtIjAOgAD3sA3Aag3Rg/+/G97yEOyG+EUy5
         n5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eIiKG0dE2roVXQZ2X/8BkBWHNbOXW9ib6YfgyxXX0WU=;
        b=I0Ev/d5F5+494pORCTCt0HHMp42hGKiIodgi1mqqiBbE/rSTVOvqtYAmOdv+AWWwXv
         f4swSJYQNDeEGWWga47i/29ZOprYuAMT867TbKGWKo7QTGBQtJd89aATSS2lvM0adktU
         99tV9C4ClFUFLVZupBiYPvqRbjbmcECz3Lfm8i/djg128qiUOZGXHhg8sbFdftKEDHng
         SaQ0+Vi9kCahCePTyZes3ZT2U2IthpQ3QShyY4z1OhTbifBDylmJORh9PlsaPRv/aTwR
         h8rt1zRxF3GjkcwJ3szCWy6r2dJ6S5Tvkxp3nyONSuSRN9KMxq+q04ajhLZqu7RBv5HR
         2qMQ==
X-Gm-Message-State: AOAM532u2dIF755bCB6QDFs+0wUZe+6MJPvYbjXm7j4nZROE81DLHOyY
        orXjV9pq42ooI2fKWudV7ExqKWV6gCc4waZWi3V+agg8wZ0=
X-Google-Smtp-Source: ABdhPJzAb+r5o9Cv3IcshXXqAi9X3ctYnQ9+eVvL27eTteK/6MxsliSYR2Wxwn08eXHTAg8hsC/+ePm7qlEOzFoeKsI=
X-Received: by 2002:a17:906:517:: with SMTP id j23mr614983eja.453.1640235768684;
 Wed, 22 Dec 2021 21:02:48 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com>
 <20211219222214.zetr4d26qqumqgub@cyberdelia>
In-Reply-To: <20211219222214.zetr4d26qqumqgub@cyberdelia>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 23 Dec 2021 10:32:37 +0530
Message-ID: <CANT5p=rE+Yr_xybEQ7T+guZXTt4Ddyx0ekhd-t2r89R5Ob5QNA@mail.gmail.com>
Subject: Re: [PATCH] cifs: invalidate dns resolver keys after use
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Dec 20, 2021 at 3:55 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Hi Shyam,
>
> On 12/18, Shyam Prasad N wrote:
> >Hi Steve/Paulo/David,
> >
> >Please review the attached patch.
> >
> >I noticed that DNS resolution did not always upcall to userspace when
> >the IP address changed. This addresses the fix for it.
> >
> >I would even recommend CC:stable for this one.
>
> (I'm pasting the patch here so I can comment inline)
>
> > From 604ab4c350c2552daa8e77f861a54032b49bc706 Mon Sep 17 00:00:00 2001
> > From: Shyam Prasad N <sprasad@microsoft.com>
> > Date: Sat, 18 Dec 2021 17:28:10 +0000
> > Subject: [PATCH] cifs: invalidate dns resolver keys after use
> >
> > We rely on dns resolver module to upcall to userspace
> > using request_key and get us the DNS mapping.
> > However, the invalidate arg for dns_query was set
> > to false, which meant that the key created during the
> > first call for a hostname would continue to be cached
> > till it expires. This expiration period depends on
> > how the dns_resolver is configured.
>
> Ok.
>
> >
> > Fixing this by setting invalidate=true during dns_query.
> > This means that the key will be cleaned up by dns_resolver
> > soon after it returns the data. This also means that
> > the dns_resolver subsystem will not cache the key for
> > an interval indicated by the DNS records TTL.
>
> This is ok too, which is an approach that I did try before, but
> didn't work (see below).
>
> > But this is
> > okay since we use the TTL value returned to schedule the
> > next lookup.
>
> This is an incorrect assumption. keyutils' key.dns_resolve uses
> getaddrinfo() for A/AAAA queries, which doesn't contain DNS TTL
> information.
>
> Meaning that the TTL returned to dns_resolve_server_name_to_ip() is
> actually either key.dns_resolve.conf's default_ttl value, or the default
> key_expiry value (5).
>
> I have a patch ready (working, but still testing) for keyutils that implements
> a "common" DNS interface, and the caller only specifies the query type,
> which is then resolved via res_nquery(). This way, all returned records
> have generic their metadata (TTL included), along with type-specific
> metadata (e.g. AFSDB or SRV specifics) as well.
>

Hi Enzo,
This would actually be very useful, if you can get it to work.

> Another option/suggestion would be to:
> 1. decrease SMB_DNS_RESOLVE_INTERVAL_DEFAULT
> 2. and/or make it user-configurable via sysfs
> 3. call dns_query() with expiry=NULL and invalidate=true
>
> So we'd use keyutils exclusively for kernel-userspace communication, and
> handle the expiration checking/configuration on cifs side.

Having such an option is useful. Although, getting the right TTL is
important. Especially for Azure workloads.

>
> >
> > Cc: David Howells <dhowells@redhat.com>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/cifs/dns_resolve.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
> > index 0458d28d71aa..8890af1537ef 100644
> > --- a/fs/cifs/dns_resolve.c
> > +++ b/fs/cifs/dns_resolve.c
> > @@ -66,7 +66,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr, time64_t *expiry)
> >
> >       /* Perform the upcall */
> >       rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
> > -                    NULL, ip_addr, expiry, false);
> > +                    NULL, ip_addr, expiry, true);
> >       if (rc < 0)
> >               cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
> >                        __func__, len, len, hostname);
>
>
> Cheers,
>
> Enzo



-- 
Regards,
Shyam
