Return-Path: <SRS0=JAQl=BB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E28C433DF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jul 2020 05:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838F720771
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jul 2020 05:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEMpVKuF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgGVFIA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Jul 2020 01:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGVFIA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Jul 2020 01:08:00 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA409C061794
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2020 22:07:59 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d14so822583qke.13
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2020 22:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=70yCi0FEAOU3112o2JYk+gRGnM2935HzsnfIsc/CW2g=;
        b=VEMpVKuF+PUHyBSnTnBwmOnqeB4PdcJAfKaqMd4vephBU8n7/iKcpn7Pm99LWByLoo
         XxMS7Tgu6YAQFecaIItsID+lVkuC2B/qyrgD5o3lTegWkSqNdfe+6qUvB0r0C/hibHUz
         tTq8GMl/jz53Isyee4nx85iZ9g99EOF81H/WCUlgL+bjJtgtFpI2sT/ZyEbLQFN8w5TI
         F0BNo16pWxKzptEiHqSlnZMIOrEJfZU9FKd2XseW+o9lKDOzhCC0JsJAJCvT8/I0CXPx
         DrVG7zL1+okY4DgyZs+7mpAf6Lw9IwUNC/nNY8yTSNwtTDL8YeP0VOC3XPDawkDgF+9R
         CHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=70yCi0FEAOU3112o2JYk+gRGnM2935HzsnfIsc/CW2g=;
        b=W598QWcJFI54xGw5ch607uPPwJuLK/zguH+ev8wFhdMfOZ3uom9DRsr4238YwjnPBC
         S6GD67vkYOgNTPLGvJIhfT98lqRue4Rii7drbSAX2/0q/a0pZ+bKg2mxVqAaaXq7jbMn
         SW3jkbpGM+Uje0J8enHCBK4K8mYYkV1k0OBjRaomt/40QmV+ygVCRAskyd6xIFhOq8ND
         rTT82SoPh6EjESNTQb0pVKdgsw7paaPwllyQgzhmJulgnnCF5MdicixIyPSwDGVLqKpX
         c1MDUey2OhtNXi0ZtJdEyL8Xv9fdqHu667aELpESAfh4VQGKG5c0U+QlsuyelnDCAcUL
         qEsw==
X-Gm-Message-State: AOAM532wg4Zo8y5lZqwlBsVF29oxB1kJDyWSs7It/jKs/v2xdvxrMG50
        H2b4HzIxKSZ/wvEqcSdDsYUnxw8xVXKiIGwERaNUmBNP5aY=
X-Google-Smtp-Source: ABdhPJzMLTpHBB4E7yPvmVdYX7CNwpb/ef29ix+UdNlIXxTdw59iQviYgpfD7phZRf9/hbTIzo+R9XsfQAZtShXGFXk=
X-Received: by 2002:a37:458f:: with SMTP id s137mr22712420qka.129.1595394478825;
 Tue, 21 Jul 2020 22:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <b14432a4-bb8c-7a0f-4339-b7e6ddec9b4a@arrl.org>
 <CAH2r5msj3KMMonyhjDeyAweHEBezOHFkJwCUXpJ4Gv59Q=S9bQ@mail.gmail.com>
 <752d5d05-7b91-b119-b5a6-7fcdeb1f0ced@arrl.org> <CAH2r5muNtwm3V-0GpaRBXmrptGDO9w1vDSWN9Wrf_eebuevg6A@mail.gmail.com>
 <61450b64-ed70-6b8f-2beb-57267ddcb8c5@arrl.org> <CAH2r5mu-g-RrR9Q4ghmqjkd-mbXbfeJE=HgVSaEEosCyBNoO8Q@mail.gmail.com>
 <119a0298-4099-c65e-30db-746814e36cce@arrl.org>
In-Reply-To: <119a0298-4099-c65e-30db-746814e36cce@arrl.org>
From:   Isaac Boukris <iboukris@gmail.com>
Date:   Wed, 22 Jul 2020 07:07:47 +0200
Message-ID: <CAC-fF8TB7C2TOv9-mT68teA7hJJ0jY5YG0vW6A2OcnD_wmqTpQ@mail.gmail.com>
Subject: Re: issue -- cifs automounts stopped working
To:     "Michael Keane, K1MK" <mkeane@arrl.org>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Upstream Samba Technical Mailing list 
        <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 22, 2020 at 5:48 AM Michael Keane, K1MK <mkeane@arrl.org> wrote:
>
> Tried setting KRB5_CCNAME to KEYRING:persistent:1000 with no change
> (Also tried KRB5CCNAME  as well, as that's the environment variable

Indeed KRB5CCNAME is the right variable name, you can also run the
upcall with KRB5_TRACE=/logfile to get more insights what the krb5
libs are doing.
