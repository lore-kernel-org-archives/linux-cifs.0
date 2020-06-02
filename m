Return-Path: <SRS0=2Ot7=7P=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6F7C433E1
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jun 2020 09:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5D0520734
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Jun 2020 09:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgFBJGv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Jun 2020 05:06:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:40932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgFBJGv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 2 Jun 2020 05:06:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73C06AF62;
        Tue,  2 Jun 2020 09:06:52 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][CIFS] fix minor typos in comments and log messages
In-Reply-To: <CAH2r5mvFSWgEgoyaEH5W7x55Nc1HP3udqDrrid_BdOyWm66RKQ@mail.gmail.com>
References: <CAH2r5mvFSWgEgoyaEH5W7x55Nc1HP3udqDrrid_BdOyWm66RKQ@mail.gmail.com>
Date:   Tue, 02 Jun 2020 11:06:48 +0200
Message-ID: <87img9kf9z.fsf@suse.com>
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
