Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6613CC77B75
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 04:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjEVEdf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 00:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjEVEdf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 00:33:35 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB28499
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 21:33:33 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96fd3a658eeso116450566b.1
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 21:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684730012; x=1687322012;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NfEjapVm/XiaT5JlpMM0Qmx8SWMflzWyhL2TfVTNWzA=;
        b=ppK1asf8CGo2Crk+79+eT4JRxCwqAB+0euq5YNyX/KzkgVxOuEyaTi+gWNO9Ptxfkl
         mt69uKKX4+n4n9wEw9UG42UN+FOwHw8wIDa9fd47wlIYAKX7MU5pfEvUPEA2OCfwVype
         gXUwA0fuZLwRZLwq5rqDD6wl70LesqvhomW48rCmu9I/sAdRE7fORnl0tDpBrj5uNw9R
         oDx47wNZcU5gYlHZjezf/mvzE1clXpVIPMa8sDhEWr4f0yGpEjLOtwRJbxB+y67p8Afg
         IYWBhUiWRDzGCGVd9WJT4ph/rDKdc3aS+v1PkBJVmR3Gz2IXuBCyWUyEwLrAAktG0u35
         Jb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684730012; x=1687322012;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NfEjapVm/XiaT5JlpMM0Qmx8SWMflzWyhL2TfVTNWzA=;
        b=blIIXoKkwnOlznF47BfHBz9XNLq12dajvmGoBwYO5re0FsJgtbk4hURx9hq6GuE3+W
         hGzTtB9r97TSkk2eJjdCzIcIV9xOE5Z0O4uTL6kgdoA2O9N1vAtfjQZua+aR3PWIwCTc
         WYgWCnvhATLNabwunKcbMIkBSG9rIqH6ifQUn+RRCGn3VdE6zUX+n0u8I50tKgcxUfmk
         Tb9l3eB0MpPwg2S5/kyCiPC3UcL9jms3xR7kco6muEK+5MdekakPKhG1NRlAYa5Lf8Gg
         0srsdfSMdckFifIhLE6GjL6DmsWE5EmrK5aNVi+onB308r6xbDtfmKIECZsxaImaUqGw
         GAPA==
X-Gm-Message-State: AC+VfDw/lg9Oyp1IGNOUXA0Eo9qxT4BFEHWph2gxU8LM44/BsZ33ALNd
        zFZc+s7FjPz8F94pYORwX3ZAfENwJptDuqsthuKO6RBCOsw=
X-Google-Smtp-Source: ACHHUZ6J+hQ+ajoWrs/8/kteyvtzZ4ipek8fzQUGoqc32NMx4/6ahFrv8mA/+eloDcxg7QUk4fC8Yos0L8gNqGsoCSw=
X-Received: by 2002:a17:906:b044:b0:96f:4927:7a96 with SMTP id
 bj4-20020a170906b04400b0096f49277a96mr7750096ejb.70.1684730012165; Sun, 21
 May 2023 21:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 22 May 2023 14:33:19 +1000
Message-ID: <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A problem  we have with xattrs today is that we use EAs and these are
case insensitive.
Even worse I think windows may also convert the names to uppercase :-(
And there is no way to change it in the registry :-(

On Mon, 22 May 2023 at 12:09, Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Looking through code today (in fs/cifs/xattr.c) I noticed an old
> reference to returning alternate data streams as pseudo-xattrs.
> Although it is possible to list streams via "smbinfo filestreaminfo"
> presumably it is not common (opening streams on remote files from
> Linux is probably not done as commonly as it should be as well).
>
> Any thoughts about returning alternate data streams via pseudo-xattrs?
> Macs apparently allow this (see e.g.
> https://www.jankyrobotsecurity.com/2018/07/24/accessing-alternate-data-streams-from-a-mac/)
>
>
>
>
>
> --
> Thanks,
>
> Steve
>
