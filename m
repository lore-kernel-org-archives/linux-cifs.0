Return-Path: <SRS0=YqT1=5L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B32C43331
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Mar 2020 09:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E546E20714
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Mar 2020 09:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgCZJ42 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Mar 2020 05:56:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:57842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgCZJ42 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 26 Mar 2020 05:56:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 982FBAC8F;
        Thu, 26 Mar 2020 09:56:26 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     longli@linuxonhyperv.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: Re: [PATCH] cifs: Remove locking in smb2_verify_signature() when
 calculating SMB2/SMB3 signature on receiving packets
In-Reply-To: <1585159997-115196-1-git-send-email-longli@linuxonhyperv.com>
References: <1585159997-115196-1-git-send-email-longli@linuxonhyperv.com>
Date:   Thu, 26 Mar 2020 10:56:25 +0100
Message-ID: <87d08zzbg6.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

longli@linuxonhyperv.com writes:
> On the sending and receiving paths, CIFS uses the same cypto data structures
> to calculate SMB2/SMB3 packet signatures. A lock on the receiving path is
> necessary to control shared access to crypto data structures. This lock
> degrades performance because it races with the sending path.
>
> Define separate crypto data structures for sending and receiving paths and
> remove this lock.

Something I've often wondered: why do we keep crypto state in the server
structure instead of creating it as needed in the caller stack (thus
avoiding the need for locks). AFAIK there's no state that need to be
kept between signing/encrypting calls beside the access to keys. Is it that
expensive to create/release?

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
