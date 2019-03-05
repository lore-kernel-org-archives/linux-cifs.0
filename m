Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636E5C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 15:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B5C205C9
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 15:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfCEPBC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:01:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:37738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728148AbfCEPBC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 10:01:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A61C8AED4;
        Tue,  5 Mar 2019 15:01:01 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] CIFS: fix FSCTL_SET_REPARSE_POINT SMB2_ioctl() call
In-Reply-To: <87woldmtjx.fsf@suse.com>
References: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com> <87woldmtjx.fsf@suse.com>
Date:   Tue, 05 Mar 2019 16:00:59 +0100
Message-ID: <87r2blmklw.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurélien Aptel <aaptel@suse.com> writes:
> So it seems to me only possible explanation is the first, i.e.
> MaxOutputResponse > Connection.MaxTransactSize, somehow.

So I've dumped a few fields:

Connection.MaxTransactSize is set by the server in NEGPROT response.

Against my WS2016, MaxTransactSize = 8388608

But we do this:

	server->maxBuf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
			       SMB2_MAX_BUFFER_SIZE);

Since SMB2_MAX_BUFFER_SIZE = 65536, maxBuf is effectively SMB2_MAX_BUFFER_SIZE

And finally, the value used for ioctl MaxOutputResponse is
CIFSMaxBufSize, which is 16384.

I've tried setting MaxOutputResponse to server->maxBuf or
Connection.MaxTransactSize but it always fails the same way... so I
don't know. I guess it must say somewhere that ioctl() with no output
should set MaxOutputResponse to zero?

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
