Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E212C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 15:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A53C20661
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 15:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfCEPlC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:41:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:53448 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728183AbfCEPlC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 10:41:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF66BAFFC;
        Tue,  5 Mar 2019 15:41:00 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] CIFS: fix FSCTL_SET_REPARSE_POINT SMB2_ioctl() call
In-Reply-To: <87r2blmklw.fsf@suse.com>
References: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com> <87woldmtjx.fsf@suse.com> <87r2blmklw.fsf@suse.com>
Date:   Tue, 05 Mar 2019 16:40:58 +0100
Message-ID: <87o96pmir9.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurélien Aptel <aaptel@suse.com> writes:
> I've tried setting MaxOutputResponse to server->maxBuf or
> Connection.MaxTransactSize but it always fails the same way... so I
> don't know. I guess it must say somewhere that ioctl() with no output
> should set MaxOutputResponse to zero?

I've just checked what Windows does and it seems to be that as
well. Creating a symlink (mklink link target) makes an
ioctl(SET_REPARSE_POINT) with MaxOutputResponse set to 0.

So I would keep this patch as is.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
