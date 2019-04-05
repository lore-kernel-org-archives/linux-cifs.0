Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47341C4360F
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 09:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AC7421738
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 09:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfDEJjV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 05:39:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:43508 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729833AbfDEJjV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Apr 2019 05:39:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1B6C1AC38;
        Fri,  5 Apr 2019 09:39:20 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: Add smb3 mount helper
In-Reply-To: <CAH2r5mstkeagNZzxMZQdritnU53jsVOWW2kMN8bcfN2fL7CCOA@mail.gmail.com>
References: <CAH2r5mstkeagNZzxMZQdritnU53jsVOWW2kMN8bcfN2fL7CCOA@mail.gmail.com>
Date:   Fri, 05 Apr 2019 11:39:18 +0200
Message-ID: <87sguwsse1.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
>     We want to encourage use of more secure SMB3, and don't want
>     people using cifs and this new helper makes it less confusing:
>          "mount -t smb3"
>     rather than
>          "mount -t cifs"
>     Users can still mount the old way, but if they use smb3 mount
>     helper (mount.smb3 or "mount -t smb3") it will be less confusing
>     and less likely to use older insecure dialects.

I don't think duplicating the source is a good idea. Could we just make
a symlink or hardlink at installation? Alternatively move the common
code to a separate file.


Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
