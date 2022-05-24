Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A2FC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 17:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbiEXRt4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 13:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiEXRtz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 13:49:55 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4277C5D5E5
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 10:49:55 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a10so675652uaj.12
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 10:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=geliEfhQ64liZDEyBiXPrNqOMWm6w4dQoEdfa7x6XQw=;
        b=ZrbEb2OAEDbgui51cz2+iNSz+Qb7PlsBAAqv3D97deK70H3WdFdgUctV1dLlenY0rO
         VZIeY+YIgqsQsESR7qPdnyYJcumsFulmlOg8kiW9Oo6Wur4ogkF4yaOYMU4eTkZDR7ZV
         tXojPyaeio/Tx09eX/WcO+L0WzMv4yqT+qP1j8utuPPkfZlsw3PzZzHx7vxMhYu9MPXx
         wniZW1sTXLG7ivu1bdVdmV/04GCOWYMHjAHv1uV69+LiaOGK3TkExdFzMkjers/7A1Rd
         NZyHLImJHStl853pVQY/JXta1YoT7iIOfKWzbIZOrhku40Ijbktc9EwDCfH260g54tWH
         LtYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=geliEfhQ64liZDEyBiXPrNqOMWm6w4dQoEdfa7x6XQw=;
        b=HG8JTrbAqUVtroUVjSmgA5FA0odv9pUTJZp+aQMFlaCDU/ym3KXHWHtrXCbwiTARnu
         h+2aMpS1/wSV3XVeDthUA1KuR2zEM3PEVmwBaPx1/c4VyIFOkAAr+rt7zlzLH4IT5Fe3
         l/u1IBkYdoLNxRSr6EEd62GX7hBwNGAdim3B7daqcItov7eDnvMgxjtQKowdHPLStZcM
         vCgzIsRbnjIkxcjdyUT8Azl1OskSg/6ZchytyJMEbbQQNzpm6Svl+vGv2AmOKzROqw6t
         fDx+LWO8QXUvhT8570oiJymuRa8t/Fbcf0zB3AZFqDIhY4g9n2Ktt0Nn1iR8j53Y6H4Y
         WHIg==
X-Gm-Message-State: AOAM5316du2QE5Ksr1hKkEFQQUCZ8sO8cxS/NO/FrXFBWHQNrdZubcg2
        IrZMZ623M5BF2WHrt1nrsWdQ6SMtQGevKOse8Xq3DVOG
X-Google-Smtp-Source: ABdhPJxLZeecQpaNL8aS/APPGAMvu7uQLXYAk0R8smddzJulxgsy0cz5tqZa4PH2mp6hdz0TQITWawQHWBnjMwUXYU0=
X-Received: by 2002:ab0:375b:0:b0:355:c2b3:f6c with SMTP id
 i27-20020ab0375b000000b00355c2b30f6cmr9322687uat.84.1653414594181; Tue, 24
 May 2022 10:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com> <1502011.1653383785@warthog.procyon.org.uk>
In-Reply-To: <1502011.1653383785@warthog.procyon.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 May 2022 12:49:44 -0500
Message-ID: <CAH2r5mt83Hxj_bT=y0G5XieEka6bATvt7Z0jKhcFDEuA-2u+hQ@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     David Howells <dhowells@redhat.com>
Cc:     Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Or alternatively - the "query network interfaces" ioctl - wonder if
additional flags that could be added (beyond what is defined in
MS-SMB2 2.2.32.5

On Tue, May 24, 2022 at 4:16 AM David Howells <dhowells@redhat.com> wrote:
>
> Is there some way for cifs to ask the RDMA layer what it supports?
>
> David
>


-- 
Thanks,

Steve
