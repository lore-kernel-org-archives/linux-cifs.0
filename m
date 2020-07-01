Return-Path: <SRS0=ODO6=AM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC62C433DF
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Jul 2020 13:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F371C20772
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Jul 2020 13:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgGANOr convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jul 2020 09:14:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:49102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbgGANOr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 1 Jul 2020 09:14:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8711AAE17;
        Wed,  1 Jul 2020 13:14:46 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, piastryyy@gmail.com
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH] cifs: Fix the target file was deleted when rename failed.
In-Reply-To: <20200629010638.3418176-1-zhangxiaoxu5@huawei.com>
References: <20200629010638.3418176-1-zhangxiaoxu5@huawei.com>
Date:   Wed, 01 Jul 2020 15:14:45 +0200
Message-ID: <87wo3nxtq2.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
