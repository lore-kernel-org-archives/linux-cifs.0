Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F1BEB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 16:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjF1QYd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 12:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjF1QY2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jun 2023 12:24:28 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251222123
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 09:24:26 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b6a084a34cso57983561fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 09:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687969464; x=1690561464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjHgAgSlCI8AuQqB1i9sUyDexoQnwiHc4RSE3BiiwTs=;
        b=GMD9FhhIx8xIIlqzbXVG+PS0QfhOEe3gIoUQEHARM06aFsImQ1WAiT8YBVgw8YsBUZ
         OHStKdFUPFMSQLFfXDj6PNT4rIZ2AOZsEzMjCBV/nkRQuZsQwBIeBPF884QjLoacms0g
         CbP/ILbG27yk+tkglggktuLtMlnDKPuZs2eqvSKzh5XYLxtUc9c0H7FIGK6/Z8KAgoWc
         0sBQ4FYVU/56V3Nen8a+VSr2CLkUUqPJJL34L69b5TQNNTqXTf+Wy2UfkTC513bUOMq+
         SHg7VN8+webNfy5iD3ppAXeq+QYrjZ6SHkvrIl+IghGW5coS6GcN/cIzebHmP+zunT+G
         nPIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687969464; x=1690561464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WjHgAgSlCI8AuQqB1i9sUyDexoQnwiHc4RSE3BiiwTs=;
        b=F0yKxA25JXtsq4/ogj8lvS+4mW3/swKs0eiaYtmJPH3zIrb0KBTJGh8yXVaI2x6T9/
         EOOYRt79eeGy6ODbfCGLUokcMJxel7Z1mU25aMlu3Y0EscsDMyy9/7cad/lbDJf9eFSG
         dPX2jrpQd7BOPYdcHuHnVpaD3sG0k3gVrx3kljlCkUXVQxZbugwZO4FPYlWyTCARLfNv
         EUrZUViVnykn27MeTUjC/j2klpzCXWONunma1B6FEm19kzFxWqkqVpRqZalQ/CU2J1CX
         E1IUqN+rTo2pn/HLhR5B02kgpzemzJOEXuyphX7JBbaOB3my9r66AnUDXeIO4TWTbj1l
         XIZw==
X-Gm-Message-State: AC+VfDyVoYZbibbCmJT9ziL2PnLXY0+wzkbfdNS1YbVkeiDxmI1hr2xy
        MrnuOUyQcllbXffZaY21/GeYLWoNWfVLWnD4PNs=
X-Google-Smtp-Source: ACHHUZ7xgoDvswKLcq2JLZLVtNj+Gk/8HveXKGeEPwcEjdAZIayRENnBqK2qbh4RM5LxMCkW8cehyWHWdcW9EaxT+p8=
X-Received: by 2002:a2e:b3c9:0:b0:2b5:9d78:2143 with SMTP id
 j9-20020a2eb3c9000000b002b59d782143mr9563679lje.28.1687969464004; Wed, 28 Jun
 2023 09:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com> <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
 <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com> <CANT5p=pW-O7UQgfRKR6XpFnnFka9PVQQ0y1YtOz+DcaQt9yH3Q@mail.gmail.com>
 <CANT5p=qdS6FFj9ay3bDiP+mWnU1b-NJp2TLb0YdAFyvkqZcKFw@mail.gmail.com> <12279206-25f3-0d1c-2db9-1010b3526d12@talpey.com>
In-Reply-To: <12279206-25f3-0d1c-2db9-1010b3526d12@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Jun 2023 11:24:12 -0500
Message-ID: <CAH2r5msUPLkjabo0DZCRqHQjhr=c6uGH0TuAh4-N3P-hQabJaQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Would you like a how-to recipe for setting up software RDMA between
two Linux machines? It's quite easy,

Yes!  And we need to update our buildbot and local automation scripts as we=
ll.

On Wed, Jun 28, 2023 at 8:39=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/28/2023 6:20 AM, Shyam Prasad N wrote:
> > Here's a version of the patch with changes for RDMA as well.
> > But I don't know how to test this, as I do not have a setup with RDMA.
> > @Tom Talpey Can you please review and test out this patch?
>
> I'm happy to test but it will take me a day to find the time.
>
> Would you like a how-to recipe for setting up software RDMA between
> two Linux machines? It's quite easy, and can be done over RoCEv1 (rxe)
> and/or softiWARP (siw).
>
> Tom.



--=20
Thanks,

Steve
