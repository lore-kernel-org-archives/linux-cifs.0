Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628F8C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 11:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B55E206DD
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 11:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfCELru convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 06:47:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:33484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfCELru (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 06:47:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7192CAF33;
        Tue,  5 Mar 2019 11:47:49 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] CIFS: fix FSCTL_SET_REPARSE_POINT SMB2_ioctl() call
In-Reply-To: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com>
References: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com>
Date:   Tue, 05 Mar 2019 12:47:46 +0100
Message-ID: <87woldmtjx.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> Without this change the ioctl() fails with INVALID_PARAMETER.
> Since SET_REPARSE_POINT has no output, set the max output response
> size to zero.

Note that this is more of a work around, I didn't intend to send this
yet. I haven't tried to figure out which cases we were violating and
where was the underlying issue.

> If either InputCount, MaxInputResponse, or MaxOutputResponse is
> greater than Connection.MaxTransactSize, the server SHOULD<306> fail
> the request with STATUS_INVALID_PARAMETER.

possible

> The server MUST fail the request with STATUS_INVALID_PARAMETER in the following cases:
>
> * If InputOffset is greater than zero but less than (size of SMB2
>   header + size of the SMB2 IOCTL request not including Buffer) or
>   if InputOffset is greater than (size of SMB2 header + size of the
>   SMB2 IOCTL request).

input related, nope

> * If OutputOffset is greater than zero but less than (size of SMB2
>   header + size of the SMB2 IOCTL request not including Buffer) or if
>   OutputOffset is greater than (size of SMB2 header + size of the SMB2
>   IOCTL request).

doesn't involve MaxOutputResponse, nope

> * If (InputOffset + InputCount) is greater than (size of SMB2 header +
>   size of the SMB2 IOCTL request).

input related, nope

> * If (OutputOffset + OutputCount) is greater than (size of SMB2 header
>   + size of the SMB2 IOCTL request).

doesn't involve MaxOutputResponse, nope

> * If OutputCount is greater than zero and OutputOffset is less
>   than (InputOffset + InputCount).

doesn't involve MaxOutputResponse, nope

So it seems to me only possible explanation is the first, i.e.
MaxOutputResponse > Connection.MaxTransactSize, somehow.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
