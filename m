Return-Path: <SRS0=N3pp=6E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548D4C3815B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Apr 2020 11:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F2520735
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Apr 2020 11:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgDTLEZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Apr 2020 07:04:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:33846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgDTLEZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Apr 2020 07:04:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AF0D3AED2;
        Mon, 20 Apr 2020 11:04:23 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     =?utf-8?B?5Lq/5LiA?= <teroincn@gmail.com>, sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [BUG] fs: cifs : does there exist a memleak in function
 cifs_writev_requeue
In-Reply-To: <CANTwqXDyh0Vvc=bgCMafGFLtheDtn31=ffDkg++2qn+RWq=vMQ@mail.gmail.com>
References: <CANTwqXDyh0Vvc=bgCMafGFLtheDtn31=ffDkg++2qn+RWq=vMQ@mail.gmail.com>
Date:   Mon, 20 Apr 2020 13:04:23 +0200
Message-ID: <87lfmq2zbc.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

亿一 <teroincn@gmail.com> writes:
> Hi all:
>  When reviewing the code of function cifs_writev_requeue, wdata2
> allocated in while loop.
> however,  if wdata2->cfile is NULL, the loop break without release
> wdata2, there exists a memleak of wdata2?

Yes, good catch. It was fixed last year by the following commit:

commit 165df9a080b6
Author: Pavel Shilovsky <pshilov@microsoft.com>
Date:   Tue Jan 29 16:40:28 2019 -0800

    CIFS: Fix leaking locked VFS cache pages in writeback retry
    
    If we don't find a writable file handle when retrying writepages
    we break of the loop and do not unlock and put pages neither from
    wdata2 nor from the original wdata. Fix this by walking through
    all the remaining pages and cleanup them properly.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
