Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C6CC432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 13:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 233B42068E
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 13:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfK0Ncn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Nov 2019 08:32:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:50114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbfK0Ncn (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Nov 2019 08:32:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 015EFBB2C;
        Wed, 27 Nov 2019 13:32:41 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>
Subject: Re: [PATCH v3 09/11] cifs: Avoid doing network I/O while holding
 cache lock
In-Reply-To: <20191127003634.14072-10-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
 <20191127003634.14072-10-pc@cjr.nz>
Date:   Wed, 27 Nov 2019 14:32:40 +0100
Message-ID: <87sgm9tpfr.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:
> When creating or updating a cache entry, we need to get an DFS
> referral (get_dfs_referral), so avoid holding any locks during such
> network operation.
>
> Also, do some rework in the cache API and make it use a rwsem.
>

Commit msg should mention what is done in the patch to avoid locking:

* change cache hashtable sync method from RCU sync to a read/write lock
* use GFP_ATOMIC in memory allocations

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
