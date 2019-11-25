Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D10C43215
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 11:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ADFB2075C
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 11:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfKYLya convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 06:54:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:39066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727110AbfKYLya (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 06:54:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88ED8AD95;
        Mon, 25 Nov 2019 11:54:28 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>
Subject: Re: [PATCH 4/7] cifs: Clean up DFS referral cache
In-Reply-To: <20191122153057.6608-5-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz> <20191122153057.6608-5-pc@cjr.nz>
Date:   Mon, 25 Nov 2019 12:54:27 +0100
Message-ID: <87d0dgw4r0.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:
> This patch does a couple of things:
>
>   - Do some renaming in static code (cosmetic)
>   - Use rwlock for cache list
>   - Use spinlock for volume list
>   - Avoid lock contention in some places

There is too much going on here for a proper review but nothing major
caught my eye (cosmetic should have been separate imo).


> -	ce = find_cache_entry(path, &h);
> -	if (IS_ERR(ce)) {
> -		cifs_dbg(FYI, "%s: cache miss\n", __func__);
> -		/*
> -		 * If @noreq is set, no requests will be sent to the server for
> -		 * either updating or getting a new DFS referral.
> -		 */
> -		if (noreq)
> -			return ce;
> -		/*
> -		 * No cache entry was found, so check for valid parameters that
> -		 * will be required to get a new DFS referral and then create a
> -		 * new cache entry.
> -		 */

I think we should keep comments.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
