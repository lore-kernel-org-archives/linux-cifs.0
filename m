Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BF8C77B7A
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Jun 2023 09:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbjFFJBC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjFFJBB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Jun 2023 05:01:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0F2100
        for <linux-cifs@vger.kernel.org>; Tue,  6 Jun 2023 02:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686042009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nE77/PGW00ePiumkpu3hzk+sXBS9GQxpADNCUK4kjrY=;
        b=ayTAmfhEKnYT/PJj5Z01tP/dT/+kImLkhc/W6Dk+VUJ2C/2WoeFnOfYN9yc7Y3y7CpgMa4
        /GcB8fBn1fA+5IABmJjXjAQDbXjIoA+tniRnXj1wUZkM6/L3VTEIbDtb4D4IBJEG5XsY+m
        43IosA+YJ5hHIcAT7QK1DWXG8LCl2Lc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-QpMAMa7MNjams66bxahydw-1; Tue, 06 Jun 2023 05:00:06 -0400
X-MC-Unique: QpMAMa7MNjams66bxahydw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f7e79c69d5so2267225e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 06 Jun 2023 02:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042005; x=1688634005;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nE77/PGW00ePiumkpu3hzk+sXBS9GQxpADNCUK4kjrY=;
        b=LG90AuPMizpHr8UqtlBD0TIUpGRy+OXczqZ5ygdphF7rsoSwqMzFXxg80cv/J1Pox9
         HVx31F5sS8Y8zl+leL157MRZZwgpfzvSDwCCtFTJ8nPa/v7MFZBqcPbQKGHyClTd+DIe
         wfwI5/w0rbVUtrLMz9s/z8rHFNNJQAO/D6HjHxVqF5NImXs4sXSJxwBj/hwYjJhgAxpP
         7cyTqFrOxRr/ilreGez8lQaQFASjb+Dd72eEv1VA4bmVgcK0gwvansLvPSHwrep/duLu
         ZGW9UKSAXlC4YxLStTGfnyaQSULfNG1/VN771ugCwduie7Ba9nU8HVY0J9A/iwU6c041
         8OdQ==
X-Gm-Message-State: AC+VfDx1I04Q6cjf0bMjy6H57eI1Qh+Mxfgzk1YPzjvu7VLn/CgnOZlO
        +YpqWmeQFdKKHxtx5XnLG5fuFJR7iAo7v0B54kKMEYX190x5CWc+KBzFSvQ2sqzw/7Rsb/6hyXp
        mfEHhFs/xqOlscbj/6SBjug==
X-Received: by 2002:a05:600c:1c26:b0:3f7:3a2f:35ec with SMTP id j38-20020a05600c1c2600b003f73a2f35ecmr2121566wms.2.1686042005099;
        Tue, 06 Jun 2023 02:00:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4nMW2ZxYmp2BjKFt0zgPi8AR01qUkYolCtDK0fOgYD9ytZTIMSa1sHbzT24zAhoWWsDDQWaw==
X-Received: by 2002:a05:600c:1c26:b0:3f7:3a2f:35ec with SMTP id j38-20020a05600c1c2600b003f73a2f35ecmr2121536wms.2.1686042004812;
        Tue, 06 Jun 2023 02:00:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id f18-20020a1cc912000000b003f4e3ed98ffsm13282106wmb.35.2023.06.06.02.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 02:00:04 -0700 (PDT)
Message-ID: <9eb5ab9385ba4af322f5bb9e8c9112414ab7027b.camel@redhat.com>
Subject: Re: [PATCH net-next v2 01/10] Drop the netfs_ prefix from
 netfs_extract_iter_to_sg()
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date:   Tue, 06 Jun 2023 11:00:02 +0200
In-Reply-To: <20230530141635.136968-2-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
         <20230530141635.136968-2-dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 2023-05-30 at 15:16 +0100, David Howells wrote:
> Rename netfs_extract_iter_to_sg() and its auxiliary functions to drop the
> netfs_ prefix.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: Steve French <sfrench@samba.org>
> cc: Shyam Prasad N <nspmangalore@gmail.com>
> cc: Rohith Surabattula <rohiths.msft@gmail.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: linux-crypto@vger.kernel.org
> cc: linux-cachefs@redhat.com
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>=20
> Notes:
>     ver #2:
>      - Put the "netfs_" prefix removal first to shorten lines and avoid
>        checkpatch 80-char warnings.
>=20
>  fs/cifs/smb2ops.c     |  4 +--
>  fs/cifs/smbdirect.c   |  2 +-

This patch does not apply anymore to net-next as the cifs contents have
been moved into fs/smb/client.

You need at least to rebase the series on top of commit
38c8a9a52082579090e34c033d439ed2cd1a462d.

Thanks!

Paolo

