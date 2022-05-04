Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AD8C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 22:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbiEDWQt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 18:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359585AbiEDWQr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 18:16:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36BB952E58
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 15:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651702389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wmk+IWKOr3sB3bZxqGmacDmLpFMcf2lWHYZ2sTPIxdU=;
        b=KjalpjvPqSjHPNAxn8yHTKoPctacDLvGJxIRmOWY/t40cT7TAafJSMCE5c8KaSSpsbwVIi
        TXIyqNCCGMZ4hnk1GPxAekj9CtBcKdwgeF9CGzzwQJDd73xPWR9/8vqLAqaIoTbhFRRv8W
        O01ncULTO6+GTL1xIUcaS5xFuCEm+fo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-3nuHH3yWPbq8paRZvOEWRw-1; Wed, 04 May 2022 18:13:08 -0400
X-MC-Unique: 3nuHH3yWPbq8paRZvOEWRw-1
Received: by mail-ej1-f72.google.com with SMTP id qw30-20020a1709066a1e00b006f45e7f44b0so1585861ejc.5
        for <linux-cifs@vger.kernel.org>; Wed, 04 May 2022 15:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wmk+IWKOr3sB3bZxqGmacDmLpFMcf2lWHYZ2sTPIxdU=;
        b=ARhA2YWs4iYtA6LZQ2IU0f4pA6dqZBpjqPEIAGws/J1povaM4Xv/ssfQImn1qs5V7E
         Gt7UimZt2tDbE1Vm+bfGiYEKlpbC7Ksk8HqmUOnwjTY9v6NDF2iDhPOsnB2AhR9veCRj
         RKwsHSvGzSOBA3Ke/UiOik4WLs24hlwnnelIgMJU1mXXLV8YIuex4jcw8EKBL3FySJha
         jZ7vemLc5fBtGkcvmgS+rA3SRiXb7YKa56obJW0qyUfyQfZRlECCbBUhLfrrMa9RcZi/
         7SsTNjNd+quslK1LSbG2xaJc3vMgQ3f49wfEbk90qDQTOfpqFiB9lhKn7XVZmZ0mNE7R
         93bA==
X-Gm-Message-State: AOAM5320mAecQGxgT36ic6d7fCrMzoND31EqW+IRdRy9zGmq9weQtcFW
        xiOh0EgwExIxodUSjLlimC+vQHEce1Mm4X5++UL1EOPwdrOPpchWkZOLqaHgpHWIebmxWxb6FZ+
        J88Lh7Evc0NSB8yIgvM8dM+IENdXhG28VeTn6/w==
X-Received: by 2002:a17:906:2294:b0:6f3:bd02:95a3 with SMTP id p20-20020a170906229400b006f3bd0295a3mr22204362eja.201.1651702386556;
        Wed, 04 May 2022 15:13:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxv2nuZgE6FpeBWPnr3tPzh7cADH1ejIUBKDonJ8YaKzMgmtDVpr4P7FHuriedaWhxdvSmM2QY9uWjowvHvbCE=
X-Received: by 2002:a17:906:2294:b0:6f3:bd02:95a3 with SMTP id
 p20-20020a170906229400b006f3bd0295a3mr22204352eja.201.1651702386416; Wed, 04
 May 2022 15:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220504014407.2301906-1-lsahlber@redhat.com> <20220504014407.2301906-2-lsahlber@redhat.com>
 <20220504182721.xywno7d3ihfxk5dr@cyberdelia>
In-Reply-To: <20220504182721.xywno7d3ihfxk5dr@cyberdelia>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Thu, 5 May 2022 08:12:55 +1000
Message-ID: <CAGvGhF5fDWbxb9i3TjXaBjg2qAbDnxDYAGqU5C1H472XZQayMw@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 5, 2022 at 4:27 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Just another nitpick
>
> On 05/04, Ronnie Sahlberg wrote:
> <snip>
> >@@ -776,7 +791,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >       struct cifs_fid *pfid;
> >       struct dentry *dentry;
> >
> >-      if (tcon->nohandlecache)
> >+      if (tcon == NULL || tcon->nohandlecache ||
> >+          is_smb1_server(tcon->ses->server))
> >               return -ENOTSUPP;
> >
> >       if (cifs_sb->root == NULL)
>
> This last hunk looks unrelated to the original topic. Could it be sent
> as a separate patch please? This helps tracking when doing
> backports/bisects.

Thanks. I will do that.
Steve, I will rework the patch and split it up a little. I will also
do some small minor changes so that it will be very easy to expand
readdir() to not just do this for hardcoded root of share
but so that we can do this for any dir.
So please leave it out from the for-next for now, or at least do not
include it in any push requests until I have re-worked it.

In testing, in my latest iteration, doing the second 'ls /mnt' results
in zero network traffic as long as the lease is kept.
Even IF we cache the directory like this, we still do a few commands
to the server for entries that are softlinks/reparse-points
but that might be possible to address too.


>
>
> Cheers,
>
> Enzo
>

