Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC8BC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 10:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81AF220857
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 10:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCSKzD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:55:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:41000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726717AbfCSKzD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:55:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4249EAC94;
        Tue, 19 Mar 2019 10:55:02 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, mkoeppe@gmx.de
Subject: Re: FIFOs in "Services for Unix" format in Windows
In-Reply-To: <CAH2r5mvrw8X-t4ojH-3LsQfrwJpFfUB8QgVWPrT2hGtwMjCTTQ@mail.gmail.com>
References: <CAH2r5mvrw8X-t4ojH-3LsQfrwJpFfUB8QgVWPrT2hGtwMjCTTQ@mail.gmail.com>
Date:   Tue, 19 Mar 2019 11:55:00 +0100
Message-ID: <87sgvj5e2j.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> 1. FIFOs:
> If a file has 0 bytes and has the System attribute set,
> Interix considers it as a FIFO special file.
> <snip>
>
> Wonder why we implemented the other parts of this (in cifs.ko) but not FIFOs?

I feel like those files aren't that uncommon on windows, which would
lead to misinterpretting them as FIFOs.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
