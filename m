Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BF2C433C1
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Mar 2021 08:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55937619E5
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Mar 2021 08:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhCXI5u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Mar 2021 04:57:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:52160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234263AbhCXI53 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Mar 2021 04:57:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0CC32AC16;
        Wed, 24 Mar 2021 08:57:28 +0000 (UTC)
Message-ID: <a07bc171d986e75f7edb9cf0fe842fa8c8e44892.camel@suse.de>
Subject: Re: [PATCH v1] cifs: simplify SWN code with dummy funcs instead of
 ifdefs
From:   Samuel Cabrero <scabrero@suse.de>
Reply-To: scabrero@suse.com
To:     =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, scabrero@suse.com
Date:   Wed, 24 Mar 2021 09:57:27 +0100
In-Reply-To: <20210318175531.30565-1-aaptel@suse.com>
References: <20210318175531.30565-1-aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 2021-03-18 at 18:55 +0100, Aurélien Aptel wrote:
> From: Aurelien Aptel <aaptel@suse.com>
> 
> This commit doesn't change the logic of SWN.
> 
> Add dummy implementation of SWN functions when SWN is disabled instead
> of using ifdef sections.
> 
> The dummy functions get optimized out, this leads to clearer code and
> compile time type-checking regardless of config options with no
> runtime penalty.
> 
> Leave the simple ifdefs section as-is.
> 
> A single bitfield (bool foo:1) on its own will use up one int. Move
> tcon->use_witness out of ifdefs with the other tcon bitfields.
> 
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>

Thanks Aurelien, it LGTM.

Reviewed-by: Samuel Cabrero <scabrero@suse.de>

-- 
Samuel Cabrero / SUSE Labs Samba Team
GPG: D7D6 E259 F91C F0B3 2E61 1239 3655 6EC9 7051 0856
scabrero@suse.com
scabrero@suse.de

