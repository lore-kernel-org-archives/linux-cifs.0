Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130F8C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Mar 2022 18:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiCZSBw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Mar 2022 14:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCZSBv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Mar 2022 14:01:51 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED6111C7EE
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 11:00:10 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h11so14088596ljb.2
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 11:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=pS+36Cu4jd/9uUxTm20cvIJJAtWsRZjQ9jknmPUejIQ=;
        b=pFJEWU1tiAOwCXQIBLojjKyNZR5OmAh+Rer0AwIo5cka3T+pX95F5gNEyofmoy0uVP
         VgYfoIigzvGTnyQdNh7fmsSk3EQ2JLIBtgn4QJnVxrInB1caDz5mk0c78bQSem/blm+9
         UbqqQDnR0mk0nKfjLdJEh6pRSxm2ZLkk8dIHQU89ILtcZyFS8t0aCuooKgFgJxokGld2
         blVh4l5UaYmd8g7GvUDanpS5AEGqqAldxVshGRq3aBLnJOw6R7qxSVtUM8yOWenrCqxb
         XDk+Xvxf1X88tzfJ4YsnHlRaAH2G0ktjoN2Wz0gQ5UpOfFUtJwRvgaeJERkwutOBNYZW
         arKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=pS+36Cu4jd/9uUxTm20cvIJJAtWsRZjQ9jknmPUejIQ=;
        b=CC7YuFOHhfDUQHabRuzCAdhi7hPTKjdhw512H2meztiyqN+AaACsTmbDdvCAZKzRB/
         iBWp0J3ZxdIvPy5FUwFzt4Nrlj+0wHbDE9UFSgLfZmxjdqgwHrAwsDJ5lZNuIVgsdB3v
         G/pgtz1HqnQlUkVDOPiohOGhVIfGFwQO1KSA3gnJVqL6YTy3fRStMHqfgXgZ29LJrbsx
         KOnnuQfxbUNNMHoL+mahRxcxSnPd6wC/Mj8II0dPMygtQG3n6ga9+7VQhgsYyCZ7MGQN
         unA+uPkWH4p8qx/iCNycreWP5O1buPoDlzHjZhel452YuCQZrNPnjH2LQDRHHx2oagv/
         NNgg==
X-Gm-Message-State: AOAM531RG3axoc0EUxkjxvBpSg1kByrB/7DJo/75FYYxGgGLhHtp4jpV
        3qmrH4FMNf4HhvEW72qCvAMBxz+dOBknFZfMabc=
X-Google-Smtp-Source: ABdhPJwJ18SIYw+tbn9Ai5iCscobUA/lSugtN3zCqwjQfAEddyQPREvOTjADj1iXO83F1vZbFTLQSChjpbnBXB1fzzY=
X-Received: by 2002:a2e:9919:0:b0:24a:c41a:a3f0 with SMTP id
 v25-20020a2e9919000000b0024ac41aa3f0mr3242434lji.23.1648317608705; Sat, 26
 Mar 2022 11:00:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muFUWGfK8LTrZA6wFD+XbG51RRM3dNyqEvA4B3mLiAkmA@mail.gmail.com>
In-Reply-To: <CAH2r5muFUWGfK8LTrZA6wFD+XbG51RRM3dNyqEvA4B3mLiAkmA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 26 Mar 2022 12:59:57 -0500
Message-ID: <CAH2r5mt0ZHuFoUcFKEgX6tejJ+xT9Y4zpYSEwYKSdGiROT6pZA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] move more protocol header definitions to fs/smbfs_common
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Updated the patch slightly to replace define that had Buffer[0] with Buffer[]

On Sat, Mar 26, 2022 at 12:55 PM Steve French <smfrench@gmail.com> wrote:
>
> Move defines for ioctl protocol header and various size to smbfs_common
>
> The definitions for the ioctl SMB3 request and response as well
> as length of various fields defined in the protocol documentation
> were duplicated in fs/ksmbd and fs/cifs.  Move these to the common
> code in fs/smbfs_common/smb2pdu.h
>
> See attached
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
