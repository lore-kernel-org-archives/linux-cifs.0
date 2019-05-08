Return-Path: <SRS0=nxME=TI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D0DC04A6B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 04:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C555320850
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 04:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IF2VzOsh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbfEHEDu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 May 2019 00:03:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45600 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfEHEDu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 May 2019 00:03:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id e24so9756924pfi.12;
        Tue, 07 May 2019 21:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VV5ttZcA8PPMoqdsDu8S8FqERUAQMws2O/5c+Z9C4Oo=;
        b=IF2VzOshMCe+T1/mAoWq1vjhfcJtTKG0Dbj1VTDJ2hNMGZ2M6E1mqZxHGNKBIPcmET
         1yZpz/D4XsCgEhP13+A2ZGET4SU3hvj/2a7fFihaiIJKPxl5oD/uNHm6bHUHY2dHtg+j
         frpGNO7bd0NveT9uVQZQURA5uh/UL2ekZ1n1zuPoR6dkGeIoUD5Ad1o1fkOQ3eofwMgX
         N5GCpJjspewycyG0wGWHy3UJfHW6cLmHe/CMiIYorLVwvfbHomOmsG0Hs8e4dms8t9uZ
         7YZM1XY8AUaI25bmBhF1jCIMfL8AUQitBJzt6bCDHwK6aOJ85KKGfHdWGQZ2QjfyCH8n
         uNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VV5ttZcA8PPMoqdsDu8S8FqERUAQMws2O/5c+Z9C4Oo=;
        b=tSdz49+uTnbhKR9rN4NYzmQIVJiiIr37L96457ye9PFRwmlrgwQMuQqfyZqkWf1y9x
         dJ0bMHMdJKdRdJyiQAozBBMCETlHsupz5ZqeKimeeuXVWqcurOjbvnoBf3Osj5KEmbTC
         n0brEAVJq1xPbL3FBU29wFLDc6fXZhvBDFuM3VAOL77Lww7TgFE9vnl1KP3JOGjKTGA4
         0jnzAylhn1Uz0N70KPfzoGComdBLFGloMCkDOEt9J0N0lSqBi8k0Er+qk7MipBIyARuE
         PMkmiZnZ/xV4e6wSsBZiES9jQjwgpKLzsFOxyN+0tleVhRscACfVxMJ/EPPEV82iLzx4
         gKZA==
X-Gm-Message-State: APjAAAVDrXSlSbr/hypC3zBU4NsSCIoUEnOQPEGHw/f74iHEkthryh1j
        OZPGJ7sbHPU5avMecQ2NSbyxNHJS59VO0xF8DtsbFA==
X-Google-Smtp-Source: APXvYqy3flc75JP6iGTiWubGXtQOSUVa+aGpsoomBc+LO942nAfjs7QSFZpoD6x5Q23G53S+pdeBLIY110etCZTVZUM=
X-Received: by 2002:a62:528b:: with SMTP id g133mr45970862pfb.246.1557288229500;
 Tue, 07 May 2019 21:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190508073238.6a5f4cd7@canb.auug.org.au>
In-Reply-To: <20190508073238.6a5f4cd7@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 7 May 2019 23:03:38 -0500
Message-ID: <CAH2r5mtrZ9K9H_d6PV1_zx1gvnWbq5J=gJ0EY_XbKBRA+kLyqQ@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Probst <kernel@probst.it>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed

On Tue, May 7, 2019 at 4:32 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   b00c40f57bd5 ("cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()")
>
> is missing a Signed-off-by from its author.
>
> Actually it looks like you were just tripped up by the mailing list's
> DMARC workaround.  :-(
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
