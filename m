Return-Path: <SRS0=7CLT=4Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE78C3F2D1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Feb 2020 11:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC072469C
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Feb 2020 11:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgB1Ljz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Feb 2020 06:39:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:56142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgB1Ljz (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 28 Feb 2020 06:39:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4A61B1E4;
        Fri, 28 Feb 2020 11:39:53 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Subject: Re: [SMB311][PATCHES] parse posix create context in order to handle
 getattr
In-Reply-To: <CAH2r5mvW_cpUhg-JA7pFd=rcYSSvT43rT2z9RGbkUpdR1fiLsg@mail.gmail.com>
References: <CAH2r5mvW_cpUhg-JA7pFd=rcYSSvT43rT2z9RGbkUpdR1fiLsg@mail.gmail.com>
Date:   Fri, 28 Feb 2020 12:39:51 +0100
Message-ID: <871rqfaqk8.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> First 1/2 of changes needed to support SMB3.1.1 POSIX Extensions
> support for getattr (stat) - the main remaining item left for the
> Linux kernel client support of the SMB3.1.1 POSIX Extensions.
>
> The patch from Aurelien allows SMB2_open() callers to pass down a
> POSIX data buffer that will trigger requesting POSIX create context
> and parsing the response into the provided buffer, and the second
> patch fixes some minor problems with the first patch.

I know we want progress on this but this patch is part of a WIP series I
shared with Steve not meant to be sent here yet (cf all XXX which I use
in dev/debug). Thanks for spotting the errors and typos but please don't
merge this yet. I will send an updated version if you really want to
have it.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
