Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB8CC433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Apr 2022 23:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbiDEXMm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Apr 2022 19:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448078AbiDEPrh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Apr 2022 11:47:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44706167F89
        for <linux-cifs@vger.kernel.org>; Tue,  5 Apr 2022 07:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649168729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lXEk4r5B+cka/wL2y/xk5o9ZYEMsta/GUz68S3KhUi0=;
        b=BVsgJPvgkvZjJ9j6o5cidkGc24k78x1TwmNnXWwPSznnSi/Xrm/4nNLNHB0o7MXQAwPVs8
        GNHsHBHyexGNpp28Os0yLzDdyATGS5VIsAfiDR0SHWDrRy5lS0a7Uudi4LVIWHBvLCgnff
        g1vw3p3l8HPFXwG3owMmUuLT25TaCQQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-BxHDYp6wND642uvPbDLhJQ-1; Tue, 05 Apr 2022 10:25:27 -0400
X-MC-Unique: BxHDYp6wND642uvPbDLhJQ-1
Received: by mail-ej1-f71.google.com with SMTP id jg2-20020a170907970200b006e7eebce76cso3176379ejc.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Apr 2022 07:25:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXEk4r5B+cka/wL2y/xk5o9ZYEMsta/GUz68S3KhUi0=;
        b=GQKJJXe09KWFA7wnHUf+99WTpK1ofoyx2UBsCU4PZ18ctUEXE51wYJ3Kak/7/9QJj4
         JfY0DvQ3ix0chcvb8Nj9p2tD2soSiCTox5pwxfIm4E7nHlr8lCQMAymwb5wzX85TVmGj
         VQNXCSs/8FZ4bUzuYn1bITC05ZkjK0zeh3u0INXbmLBUbR6ALxIREhJcUxTDolatO3KZ
         ASdPCkiu1hr0RorsRUZAG+FeYYQ9zrS99y9pe6AQJ3tjeWeBp+2qDJKgtQ48t4p+EOy8
         h0ob0O6+UVLEB/9BsrLNY/YeFEFwBPxS8LdUr9u4q8z8U29dsmrhgLZhjIrczh9nG3Xn
         1OQw==
X-Gm-Message-State: AOAM531UEufuZ5TMJ0K7M4wg0f6dohYN6b8BzwIk5F8XuVt6OQ12eykp
        FUIrAjd9e+MaMwVLy6kpNmb0VxQq6dfS15eWaK/IBJK8gx4MUzNTT/LQkhEqCCsomhQfpfFT5Rq
        7J21ZZV09+EYT1bKhwQjS84jyecenBgCRJSoICA==
X-Received: by 2002:a17:906:730e:b0:6e0:2ad8:12c8 with SMTP id di14-20020a170906730e00b006e02ad812c8mr3746285ejc.623.1649168726709;
        Tue, 05 Apr 2022 07:25:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz68uG1mxG0zhvCsWepmJDyuPxO7TopiduJMPOjqh2x+Ha7oAKYaIKPvrRT/trlUlFs3Vw8MNMJ0xIMK077r28=
X-Received: by 2002:a17:906:730e:b0:6e0:2ad8:12c8 with SMTP id
 di14-20020a170906730e00b006e02ad812c8mr3746254ejc.623.1649168726397; Tue, 05
 Apr 2022 07:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220405134649.6579-1-dwysocha@redhat.com> <1788451.1649168050@warthog.procyon.org.uk>
In-Reply-To: <1788451.1649168050@warthog.procyon.org.uk>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 5 Apr 2022 10:24:50 -0400
Message-ID: <CALF+zOn+JEB7F30wMEcs3Zm=2HFMXS+8vfiQP9HW26OtwXUHGg@mail.gmail.com>
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

On Tue, Apr 5, 2022 at 10:14 AM David Howells <dhowells@redhat.com> wrote:
>
> Dave Wysochanski <dwysocha@redhat.com> wrote:
>
> > @@ -203,7 +203,7 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
> >       if (!buf)
> >               return false;
> >       buf->reserved = cpu_to_be32(0);
> > -     memcpy(buf->data, p, len);
> > +     memcpy(buf->data, p, volume->vcookie->coherency_len);
>
> Good catch.  However, I think it's probably better to change things a bit
> further up, eg.:
>
>         -       len += sizeof(*buf);
>         -       buf = kmalloc(len, GFP_KERNEL);
>         +       buf = kmalloc(sizeof(*buf) + len, GFP_KERNEL);
>
> David
>

Agree with the above.  I'll send a v2.  Thanks!

