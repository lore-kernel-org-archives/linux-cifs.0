Return-Path: <SRS0=fxvP=RX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C69C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 10:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4980F2175B
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 10:20:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="gUvA4aep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfCTKU5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:20:57 -0400
Received: from hr2.samba.org ([144.76.82.148]:63464 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfCTKU5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Mar 2019 06:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Date:Cc:To:From;
        bh=B++CSC7VicWB5LPaHA588dorwvjzHkHWYkn9SvR1H2E=; b=gUvA4aepGtsHHznPZuDmZmSF+2
        1kmT9xtDpkSGrKK+6XL6QXYEBw7LUulHCmsoVw/JyknYJHX7KsQIPcVXLng6YDJCxezel45IJdCvP
        EsT2A4dnyG/ZlBc8yLm/FFOumA/Xh2A/9V4T/ssd/LnaoEXs5+6BELa2mNcGtv/xK1JI=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_AES_256_GCM_SHA384:256)
        (Exim)
        id 1h6YL9-0003WL-BU; Wed, 20 Mar 2019 10:20:55 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@samba.org>
To:     Stefan Metzmacher <metze@samba.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: Buildbot cifs/smb3 testing improvements
In-Reply-To: <3915ebdc-50d7-62d4-3433-47df38e78f94@samba.org>
References: <CAH2r5msUqScwN99iUnyEKBYOic4fMCpnjFmc=dfaJJax0XnxdA@mail.gmail.com> <CAN05THTHPoTiYOZN55rVaxDhy0U8SmfQ_UJX6CpoDLyjK9edkQ@mail.gmail.com> <3915ebdc-50d7-62d4-3433-47df38e78f94@samba.org>
Date:   Wed, 20 Mar 2019 11:20:53 +0100
Message-ID: <874l7x6e4a.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> writes:
> So far I wasn't able to use the upstream cifs.ko with smbdirect with any
> kind of RDMA driver at all against Windows.

I've managed to test it last year on actual hardware against
Windows. You should ask Long Li, he is still working on it.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)
