Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA729C4332F
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Nov 2022 18:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiKDStv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Nov 2022 14:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiKDStt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Nov 2022 14:49:49 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108A15F70
        for <linux-cifs@vger.kernel.org>; Fri,  4 Nov 2022 11:49:49 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id j6so3770623qvn.12
        for <linux-cifs@vger.kernel.org>; Fri, 04 Nov 2022 11:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l9rtjuYQHEdZGFnPi4RO+GW6VHNzPLGvueZ1wnAoh2k=;
        b=OWDsUW0TRqhugSuTXEHAIWTiEORqtx5V3rm6QXXdvdb/+4LTjk8HA1gynX6RS2YvPr
         YwGT0Vmshp0VTPKxfY0x2OPAMJFWxvc63VjG76cOTNECBxWVbm3bFDDUyd4lObbZV3C/
         15holUc1uUmi0znm1aMGfpgmqvl14sVRYOGAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9rtjuYQHEdZGFnPi4RO+GW6VHNzPLGvueZ1wnAoh2k=;
        b=gdR5F5C0rXITDu6EmxCohZZ/wjvHa/tB1AQ/8gROhUQ1Fks6//yKhAaewVuHvOkxJ6
         46fj5rdsVl9xBhDA1eF8qAoR5vsXNsJLILedC/Nwf2S1YUdzL5i4j8e7kPCkTCI9VFXZ
         PC4yvF5dusjjc4As1z+NRc76mTeFDWvG6886Pbz0LjZ0LhJJzBeIsBF+b36RHK/9FGrB
         lDcpujl8iZcHwOngo1lOzSN9pNuSrm8DRx8Ta3IMT4eX1xtBetbZC2fzHV64uCXqjk01
         IckpFq/54qW8sYvwsk0uyXvr5J1FD8RrJ0H51f/8a9lfetKil+Yriuusvhv5RWuyFsys
         RZ/w==
X-Gm-Message-State: ACrzQf3N4JJsGhlRcPjSMq+4cwrCFc00Dsd78hVe8a6BUd66HPUJTCCW
        VRwN+7uLp/5fzA2TN6+zbiXqRaV1diJyUQ==
X-Google-Smtp-Source: AMsMyM4AYc1AZVUKafnxBwYL0ahCw4NuQvto3lE5hfACa9elIG9D2/fQ23NGvF4I9xtJbTwiLphqFQ==
X-Received: by 2002:ad4:5f4c:0:b0:4b8:ec94:68e with SMTP id p12-20020ad45f4c000000b004b8ec94068emr32956066qvg.38.1667587787934;
        Fri, 04 Nov 2022 11:49:47 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id 145-20020a370b97000000b006eeb3165565sm3342636qkl.80.2022.11.04.11.49.45
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 11:49:45 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-36ad4cf9132so51583577b3.6
        for <linux-cifs@vger.kernel.org>; Fri, 04 Nov 2022 11:49:45 -0700 (PDT)
X-Received: by 2002:a81:8241:0:b0:370:5fad:47f0 with SMTP id
 s62-20020a818241000000b003705fad47f0mr27860255ywf.441.1667587785316; Fri, 04
 Nov 2022 11:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <1010626.1667584040@warthog.procyon.org.uk>
In-Reply-To: <1010626.1667584040@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 4 Nov 2022 11:49:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjKwjX-hNV81sDy8J3vi9_x5m7iCEOFTR1ijiPGfQdz9w@mail.gmail.com>
Message-ID: <CAHk-=wjKwjX-hNV81sDy8J3vi9_x5m7iCEOFTR1ijiPGfQdz9w@mail.gmail.com>
Subject: Re: [PATCH] iov_iter: Declare new iterator direction symbols
To:     David Howells <dhowells@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, willy@infradead.org,
        dchinner@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Nov 4, 2022 at 10:47 AM David Howells <dhowells@redhat.com> wrote:
>
> If we're going to go with Al's changes to switch to using ITER_SOURCE and
> ITER_DEST instead of READ/WRITE, can we put just the new symbols into mainline
> now, even if we leave the rest for the next merge window?

No, I really don't want to have mixed-used stuff in the kernel.

Continue to use the old names until/if the conversion happens, at
which point it's the conversion code that does it.

No "one branch uses new names, another uses old names" mess.

               Linus
