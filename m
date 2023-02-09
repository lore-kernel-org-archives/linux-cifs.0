Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63E9C636D3
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Feb 2023 19:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBITnz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 14:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjBITny (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 14:43:54 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B56465EF2
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 11:43:47 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id m10so3369584ljp.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Feb 2023 11:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xaRXzQ9Qn2NgokMojNMzNnouRiKMQmOV8PPZD0vvcjU=;
        b=GUOa31p+XSshRvbCVSNFUEOvYo9HoNU9QG8ooa8I4IoASktRoLvPAy8BM+S+RE9GIM
         5hTAYve0KXge8/51LrDUbpUL7nFsFi0duhfDKcG7jqUk8YN+JccSW6zYrCXlp65ct8SZ
         tGXOHvsXzTV8ymb2XAupQtHL+KH+P1YJc41xah7RcBDVMKoY/umBPvY5DXcNyDT2QsRU
         PkDlJ+XB0vjs29DbCOql9nHA6u3Flu7oVmer9u9O7JVc75svIHiwwiAfs0iCNfDGJrbQ
         tyVEpbrjsYqFkFGwkd6Zgdo+LYG8Xf70kusgXc4VMN3NanFzI+CY5+B5efa6P/4PWA0B
         jL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xaRXzQ9Qn2NgokMojNMzNnouRiKMQmOV8PPZD0vvcjU=;
        b=hKUWTmPaRPr5yreIBH70AFO7CI/urgEzUg/wg6ox2UKUO/BX+16XC200Hd2JYqEJ+m
         qvymXBieZEsROCcMZb4hD3yg59byoKtOEBLNfVYFWa0i7NP5c6+8VgwI0gAWUWaUnQcn
         xpLDZ1s0sgV52a+3BKwwfzuJBT4vqOiVm1byTX2VPr/pR4MZJm+cftlqZg6eXlASoKOQ
         DEobVxlGfCzKpwrpPSXgc5IUwNOkwxoV6US9yCpLcQRQ1aUQOrj6mYgPv+Ez5tp1Qhp0
         4GUorIxrGMz/+/9ZIP3XU0LGSU9ZDApfckQh/jh6i2+DXQ9obJQh80MQhmbNVoZlRUNJ
         TGhA==
X-Gm-Message-State: AO0yUKXIJOHyFz/9JDcJ2s7ZcRsc4mccQUG/1k8597eqScT41nppcG8H
        XfUnm7rFrhaZ4098O6QR1cXbqCroknoOjaIqwe3Pxdw6
X-Google-Smtp-Source: AK7set+rReMRkPbMxDOKLH7ULMMJDJI+4OgyBJhGpc8UImVxWQj0mJt17jADShIIHoRKKzc+hPiWpmx94cYTqYzH4Vs=
X-Received: by 2002:a2e:b0f2:0:b0:293:2cca:109b with SMTP id
 h18-20020a2eb0f2000000b002932cca109bmr918865ljl.60.1675971825752; Thu, 09 Feb
 2023 11:43:45 -0800 (PST)
MIME-Version: 1.0
References: <Y+UrrjvGrOT6Bcmy@sernet.de> <87lel6enq6.fsf@cjr.nz>
In-Reply-To: <87lel6enq6.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Feb 2023 13:43:34 -0600
Message-ID: <CAH2r5mvGWJVjPJo1Guyd7W0eiHyRD9Wd7F0ndKLaGCj6VyHUwA@mail.gmail.com>
Subject: Re: Fix an uninitialized read in smb3_qfs_tcon()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Volker.Lendecke@sernet.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Feb 9, 2023 at 11:55 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Volker,
>
> Volker Lendecke <Volker.Lendecke@sernet.de> writes:
>
> > Attached find a patch that fixes another case where oparms.mode is
> > uninitialized. This patch fixes it with a struct assignment, relying
> > on the implicit initialization of unmentioned fields. Please note that
> > the assignment does not explicitly mention "reconnect" anymore,
> > relying on the implicit "false" value.
>
> OK - thanks.
>
> > Is this kernel-style? Shall we just go through all of the oparms
> > initializations, there are quite a few other cases that might have the
> > mode uninitialized.
>
> Please go through all of them.
>
> Perhaps initialise those structures as below
>
>         struct cifs_open_parms oparms = {};
>
> and then avoid any uninitialised data to be sent.
>
> Patch looks good.



-- 
Thanks,

Steve
