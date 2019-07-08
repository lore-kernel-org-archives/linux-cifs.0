Return-Path: <SRS0=ZzOu=VF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427AAC606AF
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Jul 2019 11:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DACB2086D
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Jul 2019 11:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfGHLG4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Jul 2019 07:06:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:49668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726501AbfGHLG4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Jul 2019 07:06:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7998AFA9;
        Mon,  8 Jul 2019 11:06:55 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: Many processes end up in uninterruptible sleep accessing cifs mounts
In-Reply-To: <49b1529a-6d0e-99cc-112c-fa226ddcab1a@prodrive-technologies.com>
References: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com> <875zojx70t.fsf@suse.com> <1fc4f6d0-6cdc-69a5-4359-23484d6bdfc9@prodrive-technologies.com> <8736jmxcwi.fsf@suse.com> <5d4fd393-9c6c-c407-462e-441cd46bbdd8@prodrive-technologies.com> <CAKywueTpgXyFMxveRj6Hm-=vuCC6xh1z0W9bqAFcpCiREe6Vwg@mail.gmail.com> <325128ce-6ef7-9a18-a626-ee3505037c2c@prodrive-technologies.com> <CAH2r5mtXc+K5AMFFRmvPwyAx1kc2eciDKsHF_Sx2p+sjtYrtCw@mail.gmail.com> <49b1529a-6d0e-99cc-112c-fa226ddcab1a@prodrive-technologies.com>
Date:   Mon, 08 Jul 2019 13:06:52 +0200
Message-ID: <875zocwzsj.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Martijn, can you give a try to the PATCH (v2) I sent?

I wrote it on top of the 4.20 stable tree. I understand the process to
apply compile and install is not the easiest one but it would be
extremely helpful since you can reproduce the issue.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
