Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A1FC4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Nov 2022 22:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiKWWxv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Nov 2022 17:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiKWWxS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Nov 2022 17:53:18 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0627FC75BB
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 14:53:17 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id s4so152408qtx.6
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 14:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kZnCvaEQ344vGtn47RMsQAQkT919w64rZm3gu+vPQMY=;
        b=ZO8KT8PP+ynCgfpAsn0gLSY6SzCQhijyPIHusMskwtf9T1rrauFK8Ru8L7xDqiT98Q
         whp7Qv/cl82o4vi2+YEdK/JvvoG6oPw59CunYWdS4vec2yu+4W+UTQwMrh5IPxj3UHlB
         r/ebpwM/LCmalYllI981sk89ihQ71VnQhIaAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZnCvaEQ344vGtn47RMsQAQkT919w64rZm3gu+vPQMY=;
        b=Btq9C/4r7QKyunMGSOcv6q4aak+Swyj9OIgt/STAE+6JahY6mdebyEkDssPKb5JrT5
         S9z/TQzvtGWYJ4bzzS0dixR0IGWWMqUmybV9glbBICOING++9VkGnSOR6ZHYIKEtxqQx
         6ecVFMonORqz9fyQHgA7Els3l6G8VGlwwZ7fwnLYQQ+9DHXS1CQRTQgsYvxHC/oyOEOV
         r7ueQAmH5uWDk5sNgmum4iW/zzAx19EQrqjIxxtFXc/4jsYTH8t15KsqQk6j+EbrLsMg
         9TjrbAdcLi08rFSWdUD99UOCPpBdWeJm6ao1dPTJbc3kMDyngwSsakNwYhaETCIo0YMZ
         TyHA==
X-Gm-Message-State: ANoB5pl+tYii26PtUBpSdPd2aqIl8giaMnMC+GPBUrTD9lWQAOcJwR1S
        4gwz0/ZR6oElJVY1yvhluq3GKwCqunAqbQ==
X-Google-Smtp-Source: AA0mqf5DcMFG0RceXSoJYFEnO/XnQ/pMgHFlz6dBPLCpmkCbGeaAeVWfYr/G1GoltENuCSoPrdR1Yw==
X-Received: by 2002:a05:622a:4d0f:b0:3a5:25d4:2f2c with SMTP id fd15-20020a05622a4d0f00b003a525d42f2cmr12214091qtb.112.1669243995594;
        Wed, 23 Nov 2022 14:53:15 -0800 (PST)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com. [209.85.160.178])
        by smtp.gmail.com with ESMTPSA id x22-20020a05620a259600b006fb9bfc6103sm13221828qko.123.2022.11.23.14.53.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 14:53:14 -0800 (PST)
Received: by mail-qt1-f178.google.com with SMTP id h16so165488qtu.2
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 14:53:14 -0800 (PST)
X-Received: by 2002:ac8:44b9:0:b0:3a5:81ec:c4bf with SMTP id
 a25-20020ac844b9000000b003a581ecc4bfmr16610980qto.180.1669243994092; Wed, 23
 Nov 2022 14:53:14 -0800 (PST)
MIME-Version: 1.0
References: <166924370539.1772793.13730698360771821317.stgit@warthog.procyon.org.uk>
In-Reply-To: <166924370539.1772793.13730698360771821317.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Nov 2022 14:52:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjq7gRdVUrwpQvEN1+um+hTkW8dZZATtfFS-fp9nNssRw@mail.gmail.com>
Message-ID: <CAHk-=wjq7gRdVUrwpQvEN1+um+hTkW8dZZATtfFS-fp9nNssRw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm, netfs, fscache: Stop read optimisation when
 folio removed from pagecache
To:     David Howells <dhowells@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        linux-mm@kvack.org, Rohith Surabattula <rohiths.msft@gmail.com>,
        v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        Matthew Wilcox <willy@infradead.org>,
        Steve French <sfrench@samba.org>,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 23, 2022 at 2:48 PM David Howells <dhowells@redhat.com> wrote:
>
>   I've also got rid of the bit clearances
> from the network filesystem evict_inode functions as they doesn't seem to
> be necessary.

Well, the patches look superficially cleaner to me, at least. That
"doesn't seem to be necessary" makes me a bit worried, and I'd have
liked to see a more clear-cut "clearing it isn't necessary because X",
but I _assume_ it's not necessary simply because the 'struct
address_space" is released and never re-used.

But making the lifetime of that bit explicit might just be a good idea.

             Linus
