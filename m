Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB666C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Mar 2022 02:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiC0Cax (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Mar 2022 22:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiC0Caw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Mar 2022 22:30:52 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5392625C
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 19:29:14 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h7so19440411lfl.2
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 19:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pextcZ4/BlfUYfAyFwBYLpk6qeSrkmT6uLuHJ/P0N3U=;
        b=cn+fX47zRMlWtoiuxXenU6FbZ4WPLFn1l1cbNjhcZEFUFO6EC/50T/b2wxoI72nqnP
         meMhs76e1ES7mvn5YoWnwTNkSZM2hbOtLcaFayJvRhR019dIOXURLr/KETH8JQ7nP3Qv
         MHlCnxWsLffhKxIufLk4ZSS7943c3JmV/9z0Lzt61q9Rc35BonT5T/M36zCc6/VqoicS
         d5ELfA413NVXA5GgIIZhfIxVzChCwyQqUH4r6b55eBP94Yg2cyVSZsu8vFXDObWNZTyh
         pQtg6PikFaFi0IzkT1AROxi54bWvpMpiFaE34O8vyLF9PJWXPAbe2oLmYW0R7kQyLkS5
         4IWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pextcZ4/BlfUYfAyFwBYLpk6qeSrkmT6uLuHJ/P0N3U=;
        b=W7hbmlF58lcMzHA40RXV1XR9uXw9U5L3As52n2uQRboQ7G6y1twrqhNO6MHWSBtAyj
         7FiawIV83NqLYsEo0SOcID7Zs2IkLVqFXhCWKU6QRObnP4Lc6jLG8i1WU4XIe39bDOi5
         L8QVO+U4CCt0P6GjPcHN5/rN0cs+qYvZmITQ0/epIrSd5DAdbbCbaptEZcsRxgD6AoiI
         XGXl+O6shRWLdIDFUodg+rb05YkxhYs8sqPIE8d6hrZjCrg+8ASUJx2v9tilO/+oS2TQ
         bLcm39TzLKW8PTox17ZqoBbap1KDz0SthAzZCBOnFxH34smoNYpvJjU/P+TG6ziXHNCC
         qN9A==
X-Gm-Message-State: AOAM530DMXGJnWfK9oHUhs5ykdboRNyVxCPbXi4YDsqBuvgz41z5/aXz
        NmR1l8WQXj9n1pD+f8TtqYxMZ3MAJyjhl40SGWaD4sQ4
X-Google-Smtp-Source: ABdhPJx1XjvuKkDAHjeSoK3FQOLVLQhB930938E4ryM6sSSLtnu6iRgkAuNP5KvRYj2lE4XkYTqWtSCh/6WRfdnG8XM=
X-Received: by 2002:a05:6512:3a83:b0:44a:b79:6988 with SMTP id
 q3-20020a0565123a8300b0044a0b796988mr13442459lfu.595.1648348152425; Sat, 26
 Mar 2022 19:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muFUWGfK8LTrZA6wFD+XbG51RRM3dNyqEvA4B3mLiAkmA@mail.gmail.com>
 <CAH2r5mt0ZHuFoUcFKEgX6tejJ+xT9Y4zpYSEwYKSdGiROT6pZA@mail.gmail.com> <CAKYAXd_PEF7-_pf+AjoA-igO5e9nPaGgOepdeDTNHLsnz6413w@mail.gmail.com>
In-Reply-To: <CAKYAXd_PEF7-_pf+AjoA-igO5e9nPaGgOepdeDTNHLsnz6413w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 26 Mar 2022 21:29:01 -0500
Message-ID: <CAH2r5mtZxxnDYTZfoQ1Y+hwn77-zJuFytBxzVAyMKZBQwN+rEw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] move more protocol header definitions to fs/smbfs_common
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think this was removed in the next patch (I don't see the warning,
but presumably it is the blank line before the #endif at the end of
the file?)

On Sat, Mar 26, 2022 at 7:52 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2022-03-27 2:59 GMT+09:00, Steve French <smfrench@gmail.com>:
> > Updated the patch slightly to replace define that had Buffer[0] with
> > Buffer[]
> Minor nit, We can remove multiple blank lines in the patch.
>
> CHECK: Please don't use multiple blank lines
> #390: FILE: fs/smbfs_common/smb2pdu.h:1124:
> +
> +
>
> Otherwise, Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
>
> Thanks!
> >
> > On Sat, Mar 26, 2022 at 12:55 PM Steve French <smfrench@gmail.com> wrote:
> >>
> >> Move defines for ioctl protocol header and various size to smbfs_common
> >>
> >> The definitions for the ioctl SMB3 request and response as well
> >> as length of various fields defined in the protocol documentation
> >> were duplicated in fs/ksmbd and fs/cifs.  Move these to the common
> >> code in fs/smbfs_common/smb2pdu.h
> >>
> >> See attached
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >



-- 
Thanks,

Steve
