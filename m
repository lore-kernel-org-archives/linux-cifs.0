Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A768FC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E34C2070D
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfCZQxS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:53:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:46298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbfCZQxS (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Mar 2019 12:53:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF86DB148;
        Tue, 26 Mar 2019 16:53:16 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH v1] CIFS: prevent refcount underflow
In-Reply-To: <20190326154654.GA2073@light.dominikbrodowski.net>
References: <20190326071819.GA10639@light.dominikbrodowski.net> <20190326123921.4116-1-aaptel@suse.com> <20190326154654.GA2073@light.dominikbrodowski.net>
Date:   Tue, 26 Mar 2019 17:53:15 +0100
Message-ID: <87h8bpy3us.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Dominik Brodowski <linux@dominikbrodowski.net> writes:
> Reported-and-tested-by: Dominik Brodowski <linux@dominikbrodowski.net>

Great, thanks Dominik.

I chose to keep a refcount_t instead of a simple int because it still checks
for overflows.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
