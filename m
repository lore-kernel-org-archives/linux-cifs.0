Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02819C433E1
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 08:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC872073E
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 08:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgGFIaa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 04:30:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:37016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbgGFIaa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 04:30:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8E848AD79;
        Mon,  6 Jul 2020 08:30:29 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paul Aurich <paul@darkrain42.org>, linux-cifs@vger.kernel.org,
        sfrench@samba.org
Cc:     paul@darkrain42.org, Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH v3] cifs: Fix leak when handling lease break for cached
 root fid
In-Reply-To: <20200702164411.108672-1-paul@darkrain42.org>
References: <20200702164411.108672-1-paul@darkrain42.org>
Date:   Mon, 06 Jul 2020 10:30:27 +0200
Message-ID: <878sfx6o64.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paul Aurich <paul@darkrain42.org> writes:
> Changes since v2:
>    - address sparse lock warnings by inlining smb2_tcon_has_lease and
>      hardcoding some return values (seems to help sparse's analysis)

Ah, I think the issue is not the inlining but rather you need to
instruct sparse that smb2_tcon_hash_lease is expected to release the
lock.

https://www.kernel.org/doc/html/v4.12/dev-tools/sparse.html#using-sparse-for-lock-checking

Probably with __releases somewhere in the func prototype.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
