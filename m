Return-Path: <SRS0=yfkL=4J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2498CC35647
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 13:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0AA9208C4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 13:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgBUNoY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:44:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:43462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgBUNoY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 Feb 2020 08:44:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F892B137;
        Fri, 21 Feb 2020 13:44:23 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Joe Perches <joe@perches.com>, Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] cifs: Use #define in cifs_dbg
In-Reply-To: <862518f826b35cd010a2e46f64f6f4cfa0d44582.camel@perches.com>
References: <862518f826b35cd010a2e46f64f6f4cfa0d44582.camel@perches.com>
Date:   Fri, 21 Feb 2020 14:44:21 +0100
Message-ID: <87eeuo5a2y.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> +			cifs_dbg(VFS, "bogus file nlink value %u\n",
> +				 fattr->cf_nlink);

Good catch :)
I realize that 1 is VFS but this should probably be FYI.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
