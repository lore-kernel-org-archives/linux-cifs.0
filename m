Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49883C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E6323741
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgLQLmu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:42:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:46322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQLmu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Dec 2020 06:42:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32568B73C;
        Thu, 17 Dec 2020 11:42:09 +0000 (UTC)
Message-ID: <c49a149e01ada5b6e842190de6da4b70e9d7f0a3.camel@suse.de>
Subject: Re: [PATCH 2/2] cifs: Unlock on errors in cifs_swn_reconnect()
From:   Samuel Cabrero <scabrero@suse.de>
Reply-To: scabrero@suse.com
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <sfrench@samba.org>
Cc:     Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Date:   Thu, 17 Dec 2020 12:42:08 +0100
In-Reply-To: <X9s6xZZISL/SRoZm@mwanda>
References: <X9s6xZZISL/SRoZm@mwanda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 2020-12-17 at 14:02 +0300, Dan Carpenter wrote:
> There are three error paths which need to unlock before returning.

Thanks.

Reviewed-by: Samuel Cabrero <scabrero@suse.de>

-- 
Samuel Cabrero / SUSE Labs Samba Team
GPG: D7D6 E259 F91C F0B3 2E61 1239 3655 6EC9 7051 0856
scabrero@suse.com
scabrero@suse.de

