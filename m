Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292BFC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 22:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345242AbiFIWGI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345239AbiFIWGH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 18:06:07 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22941DBD73
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 15:06:06 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id x62so32922523ede.10
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jun 2022 15:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6UoMg7XAdZhjLF3+TuyFXMPmzf7hGCGFPyI+PbeCZf8=;
        b=bg+vgE40WdCztmrYjVSM/YJF9ZXtLor8NrvacxWrs8tmReVOyatbyF3+bwL2eQ+QeM
         h+OM4NPlRuZy2i1/Ro6kdbLrzQGd7SZNUFH7OSOKsX6tGe3TeNeXQa/eGc0tnjd1Yy2D
         IwGPT6SLiwVu0vhgUhkqA+ubHnvIUAQpO7X4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6UoMg7XAdZhjLF3+TuyFXMPmzf7hGCGFPyI+PbeCZf8=;
        b=p7Trhsa6/3NIrJReaakuZ64hTugmX5wyc5W5Gy5ft2BYRJjypnrwldHs5LPKYhIw92
         mYP/FlWRLwNbKnFNXkOh1By0QyyJ01AE4MLRMpypA2EXsJr+hRNR56EYqasnmX5CgcS7
         uN3+ZiWjrupawq4AmSh9svOJXgnSFjGm7WEKTnDiwjYgBfYAuSOVrDudOUqmcn2XROse
         UUk97xjeAlV0pwVS/HGw4JOpoe2qcjTcdzIQsyVOzBrT40nVA5a4o4fYYP8oKbtSzWFI
         tmtnEghuVcVkhAFQpR0KygfLEXIkhtGurE4yCeS3tk29IGx/JXX61yUIv38NZ9VWRMAI
         0AcA==
X-Gm-Message-State: AOAM532zGeRqkK75fifDwGfLIZ2+DJrvyZ1lRgjTFRtNQp5duuVLe3nO
        JckGfXfLonqAqVNISathWmR6NDPzj8GdprHshBI=
X-Google-Smtp-Source: ABdhPJyx8/Op7Y6JU/jvHlGnvySc1nLRBVkmPBokm/kxkyta8v3TFkbnuwRm4v8O4J/X0CThJAli1w==
X-Received: by 2002:a05:6402:6cc:b0:42d:bd2d:9f82 with SMTP id n12-20020a05640206cc00b0042dbd2d9f82mr48042547edy.59.1654812364824;
        Thu, 09 Jun 2022 15:06:04 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id e1-20020a1709062c0100b0070bdc059ab2sm9823664ejh.138.2022.06.09.15.06.03
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 15:06:03 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id i205-20020a1c3bd6000000b0039c6fd897b4so248876wma.4
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jun 2022 15:06:03 -0700 (PDT)
X-Received: by 2002:a05:600c:42c6:b0:39c:4bfd:a4a9 with SMTP id
 j6-20020a05600c42c600b0039c4bfda4a9mr5442248wme.8.1654812362760; Thu, 09 Jun
 2022 15:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <40676.1654807564@warthog.procyon.org.uk> <CAHk-=wgkwKyNmNdKpQkqZ6DnmUL-x9hp0YBnUGjaPFEAdxDTbw@mail.gmail.com>
In-Reply-To: <CAHk-=wgkwKyNmNdKpQkqZ6DnmUL-x9hp0YBnUGjaPFEAdxDTbw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Jun 2022 15:05:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=whGrrF20LshkNGJ41UmNN13MU6x0_npwaJQi9cr626GQQ@mail.gmail.com>
Message-ID: <CAHk-=whGrrF20LshkNGJ41UmNN13MU6x0_npwaJQi9cr626GQQ@mail.gmail.com>
Subject: Re: [PATCH] netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <smfrench@gmail.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical@lists.samba.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-hardening@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 9, 2022 at 3:04 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> IOW, I think you really should do something like the attached on top
> of this all.

Just to clarify: I did apply your patch. It's an improvement on what
used to go on.

I just think it wasn't as much of an improvement that it should have
been, and that largely untested patch I attached is I think another
step in a better direction.

                      Linus
