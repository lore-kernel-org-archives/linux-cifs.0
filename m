Return-Path: <SRS0=oOOd=W6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1E6C3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 10:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E9A222CF8
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 10:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfICKii convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 06:38:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:49422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728576AbfICKii (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 3 Sep 2019 06:38:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7425AE6D;
        Tue,  3 Sep 2019 10:38:36 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     James Wettenhall <james.wettenhall@monash.edu>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Frequent reconnections / session startups?
In-Reply-To: <CAE78Er8KYhRts+zKNsP6_11ZVA0kaTrtjvZPhdLAkHqDXhKOWA@mail.gmail.com>
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com> <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com> <CAE78Er8KYhRts+zKNsP6_11ZVA0kaTrtjvZPhdLAkHqDXhKOWA@mail.gmail.com>
Date:   Tue, 03 Sep 2019 12:38:33 +0200
Message-ID: <87pnkh7jh2.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"James Wettenhall" <james.wettenhall@monash.edu> writes:
> The only negative we are experiencing since the upgrade is that our
> VMs sometimes become unresponsive - appearing to require a reboot -
> with kernel messages like this:

Are the VMs completely unresponsive or can you run commands in a
separate shell (assuming you're not touching the cifs mount in that shell)?

Does dmesg include a stacktrace you would be wiling to share?

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
