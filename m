Return-Path: <SRS0=b7Yi=ZS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CBEC432C0
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 16:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1B202080F
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 16:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfKZQyW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 11:54:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:44512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728302AbfKZQyW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 11:54:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC76EB336;
        Tue, 26 Nov 2019 16:54:20 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Tom Talpey <ttalpey@microsoft.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: RE: [EXTERNAL] Re: [PATCH v4 1/6] cifs: sort interface list by speed
In-Reply-To: <DM6PR21MB1433DA86898BCD2C9687956EA0450@DM6PR21MB1433.namprd21.prod.outlook.com>
References: <20191103012112.12212-1-aaptel@suse.com>
 <20191103012112.12212-2-aaptel@suse.com>
 <CAKywueS3DpPkpeNprSUwrXw=ErZZsn3vRF6uVE646oCWC_8-4w@mail.gmail.com>
 <DM6PR21MB1433DA86898BCD2C9687956EA0450@DM6PR21MB1433.namprd21.prod.outlook.com>
Date:   Tue, 26 Nov 2019 17:54:19 +0100
Message-ID: <87lfs2varo.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Tom Talpey <ttalpey@microsoft.com> writes:
> Sorting by speed is definitely appropriate, but sorting the other
> multichannel attributes is just as important. For example, if the
> RDMA attribute is set, the address should actually be excluded
> for non-RDMA connections (a second, non-RDMA entry is included,
> if the interface supports both). And, the RSS attribute indicates a
> "better" destination than non-RSS for a given speed, because it is
> more efficient at local traffic management.

Note that the way the list is used has been altered in a later patch
here:

https://lore.kernel.org/linux-cifs/20191120161559.30295-2-aaptel@suse.com/T/#u

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
