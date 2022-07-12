Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1225DC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jul 2022 07:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiGLHEo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiGLHEn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Jul 2022 03:04:43 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E332BB0B
        for <linux-cifs@vger.kernel.org>; Tue, 12 Jul 2022 00:04:42 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id q13so429013qkc.9
        for <linux-cifs@vger.kernel.org>; Tue, 12 Jul 2022 00:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SR11JOlqS86kYB77tLwSQhTs+CSI9KEYKU5NjcFe5k=;
        b=TOWZ+dbZrdVAcKgbyHn+DOS5qzJPrQvvQaB6622RvJO+urOcAS6Y7AnMOElWOP+TED
         aj2m58Os8og+ZBQy9G1o6nQdmea9sxJOm6GOHsVABGPawRr+ufUZNXstYCIgc54C2kj5
         NQ8feYlzBnLK8JVhgLbtDOP8lgwpYtuk5SFYZ5LHGpPt3/fv/J2xI/K1ngiNiDJVJmGr
         pnGBRfA8+zIr5H3g92bthjrNeIgZOTgMT+s/PRMTJOH1jrq7fOb0MLcd2wFEazrC9a9B
         yVEgXTdWm2Nxn6stGJ++P1+5uDvGKSrYt0SnuMMynOt3QBIoKDJbI+HLNH3E7EudCJze
         AAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SR11JOlqS86kYB77tLwSQhTs+CSI9KEYKU5NjcFe5k=;
        b=2tBuYY22WdfHTe8f+BbPVjDc8ssL1t0l3Py4WSm6zHJuPDm6WVIFqLzWS3jgZJx7k0
         tNTipw6Fpc4uL4VJeUdHS2kM5hXVhollhhag2OmDL5m6jeGN1JFRULz85XQIXGMKtAln
         l/BKCjpaklIki+PBeuYLy6CMbXpoGteBPk+BSCojb/tGgGKxmubCG339i80XN99mEJCn
         jcCPtTgx/84DJMU6362ZKSok9iNiVLhBZcSZ01Fk9qULYtW9ua43vnKznT9dRGGtIB+h
         12RcWgQxPBrs/jA8JOY/UVYUzy2pj+3QXLtD69Adno9E4oMKLTX0KAvSvO3RbOO+SteZ
         oHmA==
X-Gm-Message-State: AJIora/pqtNv0wi/fLE0tOUxKC6WLhkF2PFXgN1aVoSnBgOELCTbYYmu
        e2Vt9Clq6PtFsfP7fIfYzbJlJiMkRNKPT9g4cUYbaEJNSqT8ng==
X-Google-Smtp-Source: AGRyM1t42UeQuuXca2u1hT62pefv/Zz8qnm+InhzVAcdPcHBASnoVTryiA53z10tikXE/RMTK1DKrkce6y8Oaf6+n1Y=
X-Received: by 2002:a05:620a:46a2:b0:6b5:5998:17a1 with SMTP id
 bq34-20020a05620a46a200b006b5599817a1mr13455387qkb.208.1657609481439; Tue, 12
 Jul 2022 00:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtuN-yswT5VTbNPzj02fwiHYOCe2eR8mcgRgRE8Qpkjgw@mail.gmail.com>
In-Reply-To: <CAH2r5mtuN-yswT5VTbNPzj02fwiHYOCe2eR8mcgRgRE8Qpkjgw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 12 Jul 2022 12:34:30 +0530
Message-ID: <CANT5p=p-hCPd-faCs=MsBaVAkS07AFexeUjujysZ=ukQSAnMxg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] workaround negprot bug in some Samba servers by
 changing order of negcontexts sent by Linux kernel client
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Paulo Alcantara <pc@cjr.nz>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Julian Sikorski <belegdol@gmail.com>,
        Brian Caine <brian.d.caine@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jul 12, 2022 at 11:04 AM Steve French <smfrench@gmail.com> wrote:
>
> Starting with 5.18.8 (and 5.19-rc4) mount can now fail to older Samba
> servers due to a server bug handling padding at the end of the last
> negotiate context (negotiate contexts typically round up to 8 byte
> lengths by adding padding if needed). This server bug can be avoided
> by switching the order of negotiate contexts, placing a negotiate
> context at the end that does not require padding (prior to the recent
> netname context fix this was the case on the client).
>
> Fixes: 73130a7b1ac9 ("smb3: fix empty netname context on secondary channels")
>
> See attached fix to cifs.ko
> --
> Thanks,
>
> Steve

Looks good to me.

-- 
Regards,
Shyam
