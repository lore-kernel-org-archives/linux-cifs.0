Return-Path: <SRS0=t+Ft=AK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965F4C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F29C214F1
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbgF2VXV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:23:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:44618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbgF2SvY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 29 Jun 2020 14:51:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A5372AC40;
        Mon, 29 Jun 2020 09:39:03 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        Paul Aurich <paul@darkrain42.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Various fixes for multiuser SMB mounts
In-Reply-To: <CAH2r5mtLgvE=0R_d3oUPTvcB_O0e-j3WX91O8QrvMTGSN+bmFQ@mail.gmail.com>
References: <20200626195809.429507-1-paul@darkrain42.org>
 <CAH2r5mtLgvE=0R_d3oUPTvcB_O0e-j3WX91O8QrvMTGSN+bmFQ@mail.gmail.com>
Date:   Mon, 29 Jun 2020 11:39:02 +0200
Message-ID: <87zh8mgqix.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Paul!

All changes looks good to me and I think could be squashed into 1
commit: they are all adjusting the volume info used to mount from the master
tcon, all in the same func.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Steve French <smfrench@gmail.com> writes:
> these and the two others (one from one) recently posted tentatively
> merged into cifs-2.6.git for-next pending review and testing

I don't think we have any multiuser tests, sadly :(

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
