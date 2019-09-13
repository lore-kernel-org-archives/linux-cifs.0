Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEB4C4CEC7
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 14:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D5D22084F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 14:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbfIMOg6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 10:36:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:53074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728890AbfIMOg6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 13 Sep 2019 10:36:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF60BADDA;
        Fri, 13 Sep 2019 14:36:56 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] smb3: fix unmount hang in open_shroot
In-Reply-To: <875zlwig4t.fsf@suse.com>
References: <CAH2r5mtpx88bvKPDZs24ipxH+pm_82ug_w2QPKpB+9Z0xjAYiA@mail.gmail.com>
 <875zlwig4t.fsf@suse.com>
Date:   Fri, 13 Sep 2019 16:36:55 +0200
Message-ID: <8736h0i7p4.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurélien Aptel  <aaptel@suse.com> writes:
> Good catch. Since the compounding changes it is SMB2_open_init() that is
> triggering the reconnect -> mark_open_files_invalid() code path so it
> looks good to me. Might be worth updating the comment to
> s/SMB2_open/SMB2_open_init/ before you commit.

Ah it seems you also need to make SMB2_open_init exit via the oshr_free
label otherwise you the mutex gets unlocked twice (see Dan Carpenter
automatic test email). This smatch tool is pretty nice...

Cheers
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
