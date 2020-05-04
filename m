Return-Path: <SRS0=lljd=6S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB3EC3A5A9
	for <linux-cifs@archiver.kernel.org>; Mon,  4 May 2020 10:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C202071C
	for <linux-cifs@archiver.kernel.org>; Mon,  4 May 2020 10:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgEDKLO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 May 2020 06:11:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:44662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgEDKLN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 4 May 2020 06:11:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 849B1ABEC;
        Mon,  4 May 2020 10:11:14 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Scott M. Lewandowski" <vgerkernel@scottl.com>,
        "linux-cifs\@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
In-Reply-To: <52e802d7dde642c29662e9e05019c323@wynstonegroup.com>
References: <52e802d7dde642c29662e9e05019c323@wynstonegroup.com>
Date:   Mon, 04 May 2020 12:11:11 +0200
Message-ID: <877dxsovr4.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Scott,

If you can reproduce this, could you try making a capture of
mounting + waiting for the bug?

https://wiki.samba.org/index.php/Bug_Reporting#cifs.ko

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
