Return-Path: <SRS0=ivIE=UH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7F1C28CC5
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Jun 2019 08:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996A8212F5
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Jun 2019 08:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bLlrBu86"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfFHIip (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Jun 2019 04:38:45 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:45537 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfFHIip (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 Jun 2019 04:38:45 -0400
Received: by mail-pg1-f181.google.com with SMTP id w34so2368139pga.12
        for <linux-cifs@vger.kernel.org>; Sat, 08 Jun 2019 01:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z+mJlA42Dth++7CIkmE9uZDf5ym1tFnPSv8yNiVBmuo=;
        b=bLlrBu86Yew8btIs8ORMa3bf3BLAEwpWPsnFrIpcm8+m2hijLFdVI5v6Y0pzVMReVY
         FEPi4HjQL2wLs4/+/SicNW/azbc6HCTJKMRkFXkWVaq+UJvZ+sBj88skntJ2zNHBJ5G6
         Bx3aJYKwWjrvv8Wu4Rfs+jQlRdqeTdzaZphcQv8PhqWEt3+UTNUwSt4PuHDs6doZ4DWl
         9Ay6UFgLtk3FNeU0fShlIQPldMwlKAyfTRkA/w71rSOBtq9JXpmFq8MdQeHLYUWgJ/It
         xqC16MK4hbgEatFby6en5h7JLBnuusXtvgwnK2Qm+Yliahvhivv1iYCXps0hDNFWV7b2
         sWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z+mJlA42Dth++7CIkmE9uZDf5ym1tFnPSv8yNiVBmuo=;
        b=uTajvawaMNhpLr+OZF5eJuwEtiRh39febLTYuW3DEo5UBdxWx1rKXrGcec7mEHWJQB
         vE7WAYiZ3jKbnpTeEVi8sKjoswjDili+pPFopkzCbAP1cPVmppg1vrPqa61WLKCpGSQI
         ZDpZsBKCQV/MMXIsxfdO1fxZKvp/KcH8GWCcf3F29uPGiqxSuUsdxdbWIbTbd95FJCWk
         7/mS+Kpj9+Sv2DNeqBHHoYZvA42gzTiNrsp+nf/axZE/hr0iPsC9u1FhqYa3U8mrDdby
         1G7kIcGUEw0S7gdzReDEEfljcn6mOlulhQxkYuihsnBX/i1yXhxuj+td95bnXUk6D6oJ
         TFEA==
X-Gm-Message-State: APjAAAXXw44y2Lm4q7V6PxN1ZAGczRO2n5AI0i3mRT3ZEwdC3cpRwWkV
        vUXg3SW8FZfDaoSgzbRVVrp/KjiSOxivxodk5Xw=
X-Google-Smtp-Source: APXvYqw5iF+3OI+efxaBYjbWvG8YqtW3YetT+zsO1K3IrmSl47Lkab4mzpc7cD5IczFJ/z+FF8kJN9NJej1/QQWeLUs=
X-Received: by 2002:a63:d4c:: with SMTP id 12mr6843387pgn.30.1559983124137;
 Sat, 08 Jun 2019 01:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
 <CAN05THT93RGGqECaQjpBJzo7cQWyxfsSNh-3nX+WqagjeZN8wQ@mail.gmail.com>
In-Reply-To: <CAN05THT93RGGqECaQjpBJzo7cQWyxfsSNh-3nX+WqagjeZN8wQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 8 Jun 2019 03:38:33 -0500
Message-ID: <CAH2r5muoekqamNPRGZO52PZb+fDuKp1-MYxhGgBjKNv--AqkkA@mail.gmail.com>
Subject: Re: [SMB3.1.1] Faster crypto (GCM) for Linux kernel SMB3.1.1 mounts
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated and repushed to cifs-2.6.git for-next

On Fri, Jun 7, 2019 at 4:24 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> First patch, fix the comment :
> + pneg_ctxt->DataLength = cpu_to_le16(6); /* Cipher Count + le16 cipher */
> to
> + pneg_ctxt->DataLength = cpu_to_le16(6); /* Cipher Count + 2 * le16 cipher */
>
> You can add a Reviewed-by me.
> Very nice!
>
> On Sat, Jun 8, 2019 at 6:24 AM Steve French via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > I am seeing more than double the performance of copy to Samba on
> > encrypted mount with this two patch set, and 80%+ faster on copy from
> > Samba server (when running Ralph's GCM capable experimental branch of
> > Samba)
> >
> > Patches to update the kernel client (cifs.ko) attached:
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
