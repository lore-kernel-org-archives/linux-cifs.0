Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B0FC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 14:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D31620781
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 14:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgHMO7X convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 10:59:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:53314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgHMO7W (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 13 Aug 2020 10:59:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 161E4ACCF;
        Thu, 13 Aug 2020 14:59:44 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>, Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: FS-Cache for cifs
In-Reply-To: <CAH2r5mt389QPfeZPSTun9qkc=88ehFC1NzayewCoKU=qv+Epaw@mail.gmail.com>
References: <1097808468.45751159.1597108422888.JavaMail.zimbra@redhat.com>
 <3704067.45751512.1597109127904.JavaMail.zimbra@redhat.com>
 <CAH2r5mt389QPfeZPSTun9qkc=88ehFC1NzayewCoKU=qv+Epaw@mail.gmail.com>
Date:   Thu, 13 Aug 2020 16:59:19 +0200
Message-ID: <87tux64mns.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Is there an overview document somewhere that describe what fscache does?
We are seeing some warnings about duplicated entries in some scenarios
but I'd like to understand better what it does before changing what goes
in the key.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
