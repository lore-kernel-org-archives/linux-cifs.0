Return-Path: <SRS0=e1Ds=BJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92124C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jul 2020 12:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8DF2074B
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jul 2020 12:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgG3MQX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jul 2020 08:16:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:44834 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgG3MQW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Jul 2020 08:16:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32C8FAF52;
        Thu, 30 Jul 2020 12:16:34 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH v3 0/7] DFS fixes
In-Reply-To: <20200721123644.14728-1-pc@cjr.nz>
References: <20200721123644.14728-1-pc@cjr.nz>
Date:   Thu, 30 Jul 2020 14:16:20 +0200
Message-ID: <87zh7h9p0r.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I'm not sure I fully understand what is going on in patch 6 & 7 but we
have tested this locally and seems to work properly. These changes make
edge cases DFS link targets work, fixes reconnection/failover where
there are mixups between netbios/fqdn host from mount call or link
targets, and other things (null ptr deref?).

So AFAIC you can merge with

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
