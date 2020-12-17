Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4890CC4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFA0D238E3
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgLQLpq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:45:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:48158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgLQLpq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Dec 2020 06:45:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CA3C9ACF9;
        Thu, 17 Dec 2020 11:45:04 +0000 (UTC)
Message-ID: <87908cc2e3c1f5ce084e9097f1513b4cb1734dd7.camel@suse.de>
Subject: Re: [PATCH 3/3] cifs: Re-indent cifs_swn_reconnect()
From:   Samuel Cabrero <scabrero@suse.de>
Reply-To: scabrero@suse.com
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Date:   Thu, 17 Dec 2020 12:45:03 +0100
In-Reply-To: <X9s7By4IDIcG4D+w@mwanda>
References: <X9s7By4IDIcG4D+w@mwanda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 2020-12-17 at 14:03 +0300, Dan Carpenter wrote:
> This code is slightly nicer if we flip the cifs_sockaddr_equal()
> around and pull all the code in one tab.
> 

I Agree.

Reviewed-by: Samuel Cabrero <scabrero@suse.de>

-- 
Samuel Cabrero / SUSE Labs Samba Team
GPG: D7D6 E259 F91C F0B3 2E61 1239 3655 6EC9 7051 0856
scabrero@suse.com
scabrero@suse.de

