Return-Path: <SRS0=Q1a1=5W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87CEC2BA19
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Apr 2020 10:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC4412063A
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Apr 2020 10:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgDFKBm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Apr 2020 06:01:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:36756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgDFKBm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Apr 2020 06:01:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9DEE3AC11;
        Mon,  6 Apr 2020 10:01:40 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v2] cifs: ignore cached share root handle closing errors
In-Reply-To: <CAKywueSjjN+w6v76BSNLW4EFmSi4WAma4XTL2H2xQYhnes63+g@mail.gmail.com>
References: <20200401125026.4899-1-aaptel@suse.com>
 <CAKywueSjjN+w6v76BSNLW4EFmSi4WAma4XTL2H2xQYhnes63+g@mail.gmail.com>
Date:   Mon, 06 Apr 2020 12:01:39 +0200
Message-ID: <87lfn9lypo.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

Thanks for the review, will send v3 :)

I thought this one would be of interest to you as it's related to your
patch in the Fixes tag.

I've noticed the shared root handle is causing us lots of issues
lately. Paulo is working on a DFS bug related to it too (when switching
servers the handle becomes invalid).

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
