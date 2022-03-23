Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB81EC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Mar 2022 17:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbiCWROW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Mar 2022 13:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbiCWROV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Mar 2022 13:14:21 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704D67892B
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 10:12:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id r22so4154108ejs.11
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 10:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ybO+7jKaWQ2q5Tv4hGub6AuE0+2NNErvZkabb1Tma7Q=;
        b=DNm6UvN6csfjwtIFfMWp3ooSDba8acDQyPRpgiiIPln8fHEs2OGfA8XTRKqpYZQs9G
         L8Z8M+trOaolRMGhVwCQzIXqGlYnnYmiuZxaFQ8cMiFufqqQmnYj2QBXc4d6cw4iP9rK
         W6+r0fb362gXQ5isyy/JhsmOCPNzac1rjzlwOhtehMitA/sl0g6cUgKIQecmVeB/h8RX
         W1fQZNzPYEUe8Gkm790nF8owPf0LZXpQN+Qk/tMqqn0u6NM0wP8Uql0pPRwpu4SVMzU8
         /UHcQzsEUfK9BBoajlgVbIct+CUfJWcXQPmYM4rs7i1mkHMgRGurIaWBrkwcehpkEmHE
         6fLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ybO+7jKaWQ2q5Tv4hGub6AuE0+2NNErvZkabb1Tma7Q=;
        b=4cj85VgDxBVekvy7NudWEkZyQF94Oy2jDO+Fq9s16oGqBqJhbozBcn0QqQP7oID+mY
         7ZRquCaH/DmPLgAWfV8/y/Q7QBk234sW5Hj7xtqseGXn1MsEWQE3FI5SrOxUnVLZo2p/
         4R+KfLSnOTwHPEBu1MqLbUuw1NIFm2c/dtIWANWSbbVPr5rHJ/QQ2vqLoo5tsZOF2dWo
         RyCTnDPymxFXvg7bwLFoRBsF5BkW7CLnZdX9tTed09/M2rstWVXPEqYj+nYfXGutOsLa
         C0zSvBP2Y0o/bF3EkuonbMZ2Sl+9daMoPm5/xzvX6WL8NH32zWTfWuqR2KeThKMloV2r
         HzkA==
X-Gm-Message-State: AOAM530TtFpfnMDwiGLc6pGH9lnkkJkAmJqfDElL9fJaxcVyvUu+kFIO
        OtAmg1QmUw0paWcmCRUKfShztP7YprXY8uzMHnc=
X-Google-Smtp-Source: ABdhPJzRArYfYhTXqNanqT44CqvVGfPL8hEFpztE6iYCg8kw5arkRVhu6JaYvF9coWDs607CA4PCVr+RQruufNKtmDc=
X-Received: by 2002:a17:906:d1c4:b0:6d5:83bb:f58a with SMTP id
 bs4-20020a170906d1c400b006d583bbf58amr1157647ejb.672.1648055568843; Wed, 23
 Mar 2022 10:12:48 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 23 Mar 2022 22:42:37 +0530
Message-ID: <CANT5p=oU3E6v639bXKQd4ssEvWmAWEDD0qUOixcwONzJyLYgOg@mail.gmail.com>
Subject: Regarding EKEYEXPIRED error during dns_query
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

I was recently working on validating the recent fixes in cifs.ko and
key.dns_resolver.
However, I've stumbled on a different issue now.

The call to dns_query from cifs initially upcalls into userspace and
key.dns_resolver seems to resolve the name to IPv4 address. This comes
back with an expiry value of 5 sec; so the key is set a timeout of 5s.

However, at some later point, the IPv4 address changes for this DNS
name. The resolution in userspace happens just fine, and I get the new
IP address. However, I can see that the dns_query call from cifs is
not upcalling to userspace anymore. And the dns_query calls are
returning -127 (EKEYEXPIRED).

I also tried to "keyctl describe KEY", and it also says "Key has expired".

1. How can I debug this further?
2. Is this a known issue? If so, what's the issue?
3. I see that afs.ko calls dns_query with invalidate passed in as
true. What was the reason for not using the dns cache in the kernel
keyring? Was it once used and later changed? If so, can you please
explain why? cifs.ko does not set invalidate=true during dns_query
calls today. I'd like to understand if there are any risks associated
with this?

-- 
Regards,
Shyam
