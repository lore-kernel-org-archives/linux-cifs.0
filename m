Return-Path: <SRS0=t+Ft=AK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FBFC433E4
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAD52206E2
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730864AbgF2TLY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:11:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:53592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731053AbgF2TLY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 29 Jun 2020 15:11:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AF1EFAC9F;
        Mon, 29 Jun 2020 09:59:11 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paul Aurich <paul@darkrain42.org>, linux-cifs@vger.kernel.org,
        sfrench@samba.org
Cc:     paul@darkrain42.org, Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH] cifs: Fix leak when handling lease break for cached
 root fid
In-Reply-To: <20200626200248.431426-1-paul@darkrain42.org>
References: <20200626200248.431426-1-paul@darkrain42.org>
Date:   Mon, 29 Jun 2020 11:59:10 +0200
Message-ID: <87wo3qgpld.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Good catch! Change looks good to me but I think we should move lw
allocation inside smb2_tcon_has_lease() so that we don't have to track
it across multiple functions as it is only used there. Could you send a
v2 doing that?

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
