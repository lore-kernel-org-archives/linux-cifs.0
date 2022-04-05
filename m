Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF551C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Apr 2022 23:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiDEXTl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Apr 2022 19:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457507AbiDEQDT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Apr 2022 12:03:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F0106246
        for <linux-cifs@vger.kernel.org>; Tue,  5 Apr 2022 08:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649174112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oUGf2ZzFBlqLs6dPsgowfYrL5l+4T7WVAGTyEQhZU7k=;
        b=Mippb1DQpVfNlQC3G7Pisaa1D9SY+vrIq2RfEyLCOlUNiSR+GhajOp7hWYZ/o9vqpJV1bu
        oH4gY8kGadQ9/sotSmN1TSrVWFJmPdM2qtQ23CR0H9KY5f0Gv5dKImXjw88biovnn6n8Xh
        qgfiHFipBuMlX3LoczMwz6KiSdpgKak=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-pdA3NW1gNHe4F2BrIDnxow-1; Tue, 05 Apr 2022 11:55:11 -0400
X-MC-Unique: pdA3NW1gNHe4F2BrIDnxow-1
Received: by mail-ej1-f70.google.com with SMTP id qb5-20020a1709077e8500b006e7f59d3cc0so3128124ejc.15
        for <linux-cifs@vger.kernel.org>; Tue, 05 Apr 2022 08:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oUGf2ZzFBlqLs6dPsgowfYrL5l+4T7WVAGTyEQhZU7k=;
        b=T+EnGVzgrMxQiyKJ1DIASTAXbtbQ0Bd3vPZoWNYFROb7BbR1QMSyeHxT0H5oBTCmNs
         Oitx2vzglfgn6ZsVnOPqoFXhJg4CqQEL+q3HEKUJwKtytGD6T2c/O1BYFdcytECqbOi1
         pUGPbjAFmqUYTZgl2s4oJsXB55ARsicXIMOifyZMl7ZFZWZ3v1fWfQfe8mWZbTHKLQDI
         byGRZVYcC+RqxdSu1KqxaPyStVKFEVTSktf3TvKeW4vk2h8xATU1fRHUMvx/odo35bMP
         9UxxG4EwThurX7ggjYqnercKlUOs5F5idyaJ1Eo/68ec5UH6mNKCTOtmQ/8efgAeRe5p
         7yaQ==
X-Gm-Message-State: AOAM530puHVWrU9w1BFzQs/Ibi9Q7eAS0KKtM0oyl+r0PYEfCbPydDgf
        ZV4moLmj1Nk95VZH4HDkNuWbZxv2qh9vIneqEULveWJE5txvp3oKq9e1c8GS0SCe0uqJzzq8FIz
        5dF3vi1czUCtn/Z6N4v6r09kjfESOSK5NJ3O/0Q==
X-Received: by 2002:a50:e79b:0:b0:41c:dd2c:3e19 with SMTP id b27-20020a50e79b000000b0041cdd2c3e19mr4308735edn.291.1649174110114;
        Tue, 05 Apr 2022 08:55:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUUvwBxFtq2BY8mzd78qIMjht5DdA2cwVsjyZufq034uibZpjtPkdQsNyuP+paR+kBgPKJIV7NxIo0lQMxQbE=
X-Received: by 2002:a50:e79b:0:b0:41c:dd2c:3e19 with SMTP id
 b27-20020a50e79b000000b0041cdd2c3e19mr4308718edn.291.1649174109970; Tue, 05
 Apr 2022 08:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220405134649.6579-1-dwysocha@redhat.com> <1788451.1649168050@warthog.procyon.org.uk>
 <CALF+zOn+JEB7F30wMEcs3Zm=2HFMXS+8vfiQP9HW26OtwXUHGg@mail.gmail.com>
In-Reply-To: <CALF+zOn+JEB7F30wMEcs3Zm=2HFMXS+8vfiQP9HW26OtwXUHGg@mail.gmail.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 5 Apr 2022 11:54:33 -0400
Message-ID: <CALF+zOksePcvCzY4kTrkZeEJOxxNkxu2f=PTM_3SSoYtYo_1PA@mail.gmail.com>
Subject: Re: [PATCH] cachefiles: Fix KASAN slab-out-of-bounds in cachefiles_set_volume_xattr
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs <linux-cachefs@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Apr 5, 2022 at 10:24 AM David Wysochanski <dwysocha@redhat.com> wrote:
>
> On Tue, Apr 5, 2022 at 10:14 AM David Howells <dhowells@redhat.com> wrote:
> >
> > Dave Wysochanski <dwysocha@redhat.com> wrote:
> >
> > > @@ -203,7 +203,7 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
> > >       if (!buf)
> > >               return false;
> > >       buf->reserved = cpu_to_be32(0);
> > > -     memcpy(buf->data, p, len);
> > > +     memcpy(buf->data, p, volume->vcookie->coherency_len);
> >
> > Good catch.  However, I think it's probably better to change things a bit
> > further up, eg.:
> >
> >         -       len += sizeof(*buf);
> >         -       buf = kmalloc(len, GFP_KERNEL);
> >         +       buf = kmalloc(sizeof(*buf) + len, GFP_KERNEL);
> >
> > David
> >
>
> Agree with the above.  I'll send a v2.  Thanks!

After I looked at this again I realized 'len' is used in
vfs_setxattr() and needs to be the size of the kmalloc'd memory.
So we need another adjustment there or the v1 patch.

    191 bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
    192 {
    193         struct cachefiles_vol_xattr *buf;
    194         unsigned int len = volume->vcookie->coherency_len;
    195         const void *p = volume->vcookie->coherency;
    196         struct dentry *dentry = volume->dentry;
    197         int ret;
    198
    199         _enter("%x,#%d", volume->vcookie->debug_id, len);
    200
    201         buf = kmalloc(sizeof(*buf) + len, GFP_KERNEL);
    202         if (!buf)
    203                 return false;
    204         buf->reserved = cpu_to_be32(0);
    205         memcpy(buf->data, p, len);
    206
    207         ret = cachefiles_inject_write_error();
    208         if (ret == 0)
    209                 ret = vfs_setxattr(&init_user_ns, dentry,
cachefiles_xattr_cache,
    210                                    buf, len, 0);

