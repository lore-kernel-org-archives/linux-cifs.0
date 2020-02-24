Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2C7C35671
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 12:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8E7820732
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 12:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgBXM2b convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 07:28:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:37232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgBXM2b (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 07:28:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3F6BCADAA;
        Mon, 24 Feb 2020 12:28:30 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com
Subject: Re: [PATCH] cifs: fix rename() by ensuring source handle opened
 with DELETE bit
In-Reply-To: <20200221101906.24023-1-aaptel@suse.com>
References: <20200221101906.24023-1-aaptel@suse.com>
Date:   Mon, 24 Feb 2020 13:28:28 +0100
Message-ID: <878sks5fv7.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

Can you add this fixes tag if/when you merge this:

Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")

Thanks
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
