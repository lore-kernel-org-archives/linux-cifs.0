Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE9EC433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Dec 2020 06:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D52412253D
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Dec 2020 06:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgLDGKD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Dec 2020 01:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLDGKD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Dec 2020 01:10:03 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DEFC061A4F
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 22:09:22 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z1so5300589ljn.4
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 22:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KVSzsMbArERj8LGcw+ICTzID9z2Hx61JRxAlLoV1fl0=;
        b=SjrLxlKc2Y0YvFk9q+SSROqRxpF/hOLWKNN09KC1betedWH8fpzxhAufHEO9r6W29Z
         Fc6Fn4TuAFVhdCajF65j9QNDkQWO/ZY2300Ksy43GZ0L9lzX7Isue6Yymk/6N2zKfeKE
         0crvqsOPqGloVfnp/DqXBBYf4tsZBTUWwFdH3Mn9LFzFKirS4B51gMH0NtDd4zWObvYx
         8eL+ve2s5JYPduvTm7VPEGtWSKsQlsmiOQGOlM0H3oaE/gQpgzdELBhzt72MbJ6u75t/
         ZX5bqLpuRZFIH0H5PdGzYoF/9SUloVS5EE4jHn5FbpyKFNCR44sF2w4Vkt2TlVCMsB6Y
         cSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KVSzsMbArERj8LGcw+ICTzID9z2Hx61JRxAlLoV1fl0=;
        b=e6DPMmX9ydMzdZ0lLkfjHx/DwsW6lBmmayWZ1SEOODF7pKqyzugpnGK+yTlxs6BM0u
         NliUFabop/uE7+w7ZboA05IMwR1+CwgW/kIxbvg6C1avUii3t1tpUbnXiZHz2HptUc9f
         Jpyg+rZzBXWRCA3sBxj0Puq0jlF+uUt9L6brVIEyL0aJDqrjHB03oPPwYS89y5HFhcAE
         VSDlo/OoLXr86O0AP3HKuAJ+FH8VdacQ4q9lGUJPZUNEx/JpGqcmepHKu6f5M1Uoa5Me
         Z53Ca9CqMrAyc9SVu688WVLev7SxlhWvY3pguYT9IYGUzxBG9Q+OfHzUYvXpao3RFftA
         GisQ==
X-Gm-Message-State: AOAM532VrAZLTC3gw2j/p6ey0C6YPRcYbWHYwdLvOoeLZKt6pw9OvVrx
        wtz0jPds6HgdjHUtLKAvGbwRIgZMnay1aGGhJ+Y=
X-Google-Smtp-Source: ABdhPJyRI0iDVoOBXHyrmVgzOCJHJtomwvciqP9JHfK2WYGRwcFsvFxYY8VwYA1g8M476k5N9o0dfoTbS6HbwtFgnZA=
X-Received: by 2002:a2e:b0c8:: with SMTP id g8mr2760688ljl.331.1607062160850;
 Thu, 03 Dec 2020 22:09:20 -0800 (PST)
MIME-Version: 1.0
References: <CALe0_76k-ZTbQLMBNzKg+ZB8a2NxQ_Kf+Q9b5fovOv2svY8KjA@mail.gmail.com>
In-Reply-To: <CALe0_76k-ZTbQLMBNzKg+ZB8a2NxQ_Kf+Q9b5fovOv2svY8KjA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 4 Dec 2020 00:09:09 -0600
Message-ID: <CAH2r5mucjWpHmeuQ36F7QoeDugrw48dvVrZQgSbesfT4SAqpLQ@mail.gmail.com>
Subject: Re: cifs.ko and gssproxy
To:     Jacob Shivers <jshivers@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I see a brief mention of gssproxy by Jeff Layton more than three years
ago, but don't remember any follow up on that.   What would be your
goal in doing this?

Presumably we could improve cifs.ko's ability to automatically
autonegotiate new SMB sessions for incoming VFS requests from uids
that have associated kerberos tickets.  Fortunately here is little
dependency on SPNEGO in cifs.ko (so it could be fairly easy to add
other upcalls for SPNEGO), just during SMB3 session setup (and also in
parsing the SMB3 negotiate response).   My bigger worry with handling
SPNEGO (RFC2478) in the longer term, is adding support for the various
other mechanisms (other than Kerberos and NTLMSSP) that servers can
negotiate (PKU2U for example, and also the 'peer to peer kerberos'
that Macs can apparently negotiate with SMB3 and SPNEGO).
Authentication is mostly opaque to the SMB3 protocol, so if additional
mechanisms can be negotiated  (transparently, with little impact on
other parts of the kernel code) with SPNEGO in the future that would
be of value

On Thu, Dec 3, 2020 at 4:08 PM Jacob Shivers <jshivers@redhat.com> wrote:
>
> Hello all,
>
> Is anyone working on modifying cifs.ko to work with gssproxy directly?
>
> There were comments a few years ago about such an endeavor, but I have
> not seen any further discussion in recent years.
>
> Thanks for any information,
> Jacob
>


-- 
Thanks,

Steve
