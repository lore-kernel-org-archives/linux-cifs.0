Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96D2C3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA4FC20828
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfH1KyM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 06:54:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:44872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfH1KyM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 28 Aug 2019 06:54:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59BC2AD1E;
        Wed, 28 Aug 2019 10:54:10 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [RFC][SMB3][PATCH] Allow share to be mounted with "cache=ro" if immutable share
In-Reply-To: <CAN05THSPmp3GtZifXK-mLtVntgQR0uwaYY-c5LS9Dhf_P78grA@mail.gmail.com>
References: <CAH2r5mu_koRUCV9snYu_A6at8r+kJ85DgFszG4=seEEn+qb0LQ@mail.gmail.com> <87k1axlhf8.fsf@suse.com> <CAN05THSPmp3GtZifXK-mLtVntgQR0uwaYY-c5LS9Dhf_P78grA@mail.gmail.com>
Date:   Wed, 28 Aug 2019 12:54:09 +0200
Message-ID: <87ef15lfvy.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"ronnie sahlberg" <ronniesahlberg@gmail.com> writes:
> You also have the magic happening in:
> -#define CIFS_CACHE_READ(cinode) (cinode->oplock & CIFS_CACHE_READ_FLG)
> +#define CIFS_CACHE_READ(cinode) ((cinode->oplock &
> CIFS_CACHE_READ_FLG) ||
> (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags &
> CIFS_MOUNT_RO_CACHE))

Ah thanks, I didn't notice that part.

> which makes things work. Still I would want this to be driven by
> whether the server returns "this share is WRITEABLE or  not" flag
> instead of a mount option.
> A mount option only invites people to "I use this because it makes
> thing faster"  then "why do my files look corrupted sometimes" ?

That's true but there are situations where it would be handy. Imagine
mounting //host/non_ro_share/sub/path/ro_folder i.e. mounting a folder
that you know won't change within a share that can change.

I guess this hints at a more granular cache mode.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
