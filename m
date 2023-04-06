Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F4EC76196
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Apr 2023 23:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjDFXo5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Apr 2023 19:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjDFXoZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Apr 2023 19:44:25 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E95EB75D;
        Thu,  6 Apr 2023 16:43:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id lj25so5014223ejb.11;
        Thu, 06 Apr 2023 16:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680824619; x=1683416619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sa4w2wBUhh2LraZYWTmyiXr2wBMjNJ8awyrNTkWw7lc=;
        b=UtP1mBlhsggmxLoOvfJLtVEopzWRqIyYL8Ug49LHqTYjMM7HdUpcBqf2AbZxCkkB8A
         jvND/qZdS+6SSw8zpJttAncyQ4bcQx9LgIaJUaAmEx8yQdzNrw3Y33t/j8nWL/dA5MIZ
         opy45DYM/dPuGE433N4lBeMwH3kJX7HlpMjXxto94ocz4FwlRATpuKhYLn+gboUoJf6w
         SUzOtHPzY3IxbBwa2Hx+89RhEZnfFk48t/sfSXsyOv8yQwxTecB63aII7hhy4/a01Ycj
         9nAyMMDKfx/OfsrrZYtxwGwSBMoElAQ3d0E2N3XyENbPjoP3nevtwrUVxbzdRq0ycd98
         Jhhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680824619; x=1683416619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sa4w2wBUhh2LraZYWTmyiXr2wBMjNJ8awyrNTkWw7lc=;
        b=0ck3Ev1WAqHE9TVMkytziDeQ60OiaC8PPYVyr6yCv4mVxCpFPBv9Kh2HiichVX8oML
         P2XHumqeDHOXx7nI/BSBFCLMhn0Y3DZ7Nd/z5J66v1H5GKkamvGUwdvduWSewH5VjbTo
         aiRjY9bhVFow8YJdcwvYhtHLg60dfoW98y6tf4JDYicmAh+J1BpiXWnGvSsddiypDxKN
         2YQ8XCmYr6EJ9x1edqr2wEQ9EBTkMv6QziQACYezKjsK+Hb+T+u43SCYQ1emKPbJIoqz
         aiRWgD8WN8MnVJvssTHiVU/aSF06rDmKLR9Kb6azELi8JzN6/5a15K1N0RJ9WtqiakE8
         vaSA==
X-Gm-Message-State: AAQBX9fM2QPb0fY7K8ziEhACzLefq+NqzKsNWupv/kLaAjUSP64KWRgD
        pXx3oVGDJjYtsrnpU3VY38y7l8O5yvLvcDFknng=
X-Google-Smtp-Source: AKy350aBEkf5TgGsv2J/0hdQg7fObnxz4RgvnMs2l7oi3Q8is/NrmWVmaPsJCNU+iGHcckbbHivvQg0JaDbaRmw6XcI=
X-Received: by 2002:a17:907:6d99:b0:8d8:4578:18e0 with SMTP id
 sb25-20020a1709076d9900b008d8457818e0mr253918ejc.10.1680824619045; Thu, 06
 Apr 2023 16:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <ZC6JEx4dvWUvgcwW@kili> <8219c3dd87179df545fb6de4b89b2bbc.pc@manguebit.com>
In-Reply-To: <8219c3dd87179df545fb6de4b89b2bbc.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 Apr 2023 18:43:27 -0500
Message-ID: <CAH2r5muJwda_HxHvBR_riAjq65XHjs4Pbvc07i7ZQ76rU9GUNg@mail.gmail.com>
Subject: Re: [PATCH] cifs: double lock in cifs_reconnect_tcon()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Dan Carpenter <error27@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added to cifs-2.6.git for-next

On Thu, Apr 6, 2023 at 7:10=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Dan Carpenter <error27@gmail.com> writes:
>
> > This lock was supposed to be an unlock.
> >
> > Fixes: 6cc041e90c17 ("cifs: avoid races in parallel reconnects in smb1"=
)
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> >  fs/cifs/cifssmb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>



--=20
Thanks,

Steve
