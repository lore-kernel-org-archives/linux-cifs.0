Return-Path: <SRS0=a8IY=5M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EB3C43331
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 11:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E45206F1
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 11:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgC0LF0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Mar 2020 07:05:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:59720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgC0LF0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 27 Mar 2020 07:05:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 78030ADFE;
        Fri, 27 Mar 2020 11:05:24 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Long Li <longli@microsoft.com>,
        "longli\@linuxonhyperv.com" <longli@linuxonhyperv.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical\@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] cifs: Remove locking in smb2_verify_signature() when
 calculating SMB2/SMB3 signature on receiving packets
In-Reply-To: <BN8PR21MB1155DCB17C62EDCE529922ABCECC0@BN8PR21MB1155.namprd21.prod.outlook.com>
References: <1585159997-115196-1-git-send-email-longli@linuxonhyperv.com>
 <87d08zzbg6.fsf@suse.com>
 <BN8PR21MB1155DCB17C62EDCE529922ABCECC0@BN8PR21MB1155.namprd21.prod.outlook.com>
Date:   Fri, 27 Mar 2020 12:05:23 +0100
Message-ID: <877dz6njm4.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Long Li <longli@microsoft.com> writes:
>>need for locks). AFAIK there's no state that need to be kept between
>>signing/encrypting calls beside the access to keys. Is it that expensive to
>>create/release?
>
> My guess is that crypto_alloc_shash() is a heavy call?

AFAIK there's no IO, just some memory allocation. Could be faster than
locking. Something to look into, maybe...

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
