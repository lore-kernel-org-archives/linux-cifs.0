Return-Path: <SRS0=3qap=V4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3592BC32751
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 15:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 142D6206A3
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 15:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfGaPem convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Jul 2019 11:34:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:45316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725209AbfGaPem (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 31 Jul 2019 11:34:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC5D1AC68;
        Wed, 31 Jul 2019 15:34:40 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Colin King <colin.king@canonical.com>,
        samba-technical@lists.samba.org, Steve French <sfrench@samba.org>,
        kernel-janitors@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: remove redundant assignment to variable rc
In-Reply-To: <20190731122841.GA1974@kadam>
References: <20190731090526.27245-1-colin.king@canonical.com> <87r266seg4.fsf@suse.com> <20190731122841.GA1974@kadam>
Date:   Wed, 31 Jul 2019 17:34:39 +0200
Message-ID: <87lfwerze8.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Dan Carpenter" <dan.carpenter@oracle.com> writes:
> You're just turning off GCC's static analysis (and introducing false
> positives) when you do that.  We have seen bugs caused by this and never
> seen any bugs prevented by this style.

You've never seen bugs prevented by initializing uninitialized
variables? Code can change overtime and I don't think coverity is
checked as often as it could be, meaning the var could end up being used
while uninitialized in the future.

Anyway I won't die on this hill, merge this if you prefer.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
