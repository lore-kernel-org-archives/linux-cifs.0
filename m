Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C275DC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 10:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97BE62085A
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 10:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfCSKje convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:39:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:38142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbfCSKje (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:39:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D4C9B06B;
        Tue, 19 Mar 2019 10:39:33 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Murphy Zhou <jencce.kernel@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [5.1-rc1 CIFS regression] detected buffer overflow in strcat in smb21_set_oplock_level (xfstests generic/446)
In-Reply-To: <CAN05THRDtr1WQqSwqNG7azy+Qst5H1+8XGrZNGNocr_O_jf7LA@mail.gmail.com>
References: <CADJHv_sGr3Oz7zTW5KQMgg93+Fgkaw1NVrEMEKmnCTCcHPHveg@mail.gmail.com> <CAN05THRDtr1WQqSwqNG7azy+Qst5H1+8XGrZNGNocr_O_jf7LA@mail.gmail.com>
Date:   Tue, 19 Mar 2019 11:39:31 +0100
Message-ID: <87va0f5esc.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ronnie sahlberg <ronniesahlberg@gmail.com> writes:
> I tested generic/446 on both my machine as well as our buildbot using
> Steves current for-next branch and it passes without crashing.
> I have added this test to our buildbot so we will continue to run it
> for every patch moving forward.
>
> Can you test if you still get crashes if you use Steve's for-next branch ?

Do you have KASAN enabled in the kernel config?

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
