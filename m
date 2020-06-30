Return-Path: <SRS0=S3IA=AL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69808C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Jun 2020 02:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 427E620760
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Jun 2020 02:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgF3CnP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Jun 2020 22:43:15 -0400
Received: from o-chul.darkrain42.org ([74.207.241.14]:46956 "EHLO
        mail.darkrain42.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgF3CnP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Jun 2020 22:43:15 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature ED25519)
        (Client CN "otters", Issuer "otters" (not verified))
        by o-chul.darkrain42.org (Postfix) with ESMTPS id 59E888106;
        Mon, 29 Jun 2020 19:43:15 -0700 (PDT)
Received: by haley.home.arpa (Postfix, from userid 1000)
        id C43EA35AFA; Mon, 29 Jun 2020 19:43:14 -0700 (PDT)
Date:   Mon, 29 Jun 2020 19:43:14 -0700
From:   Paul Aurich <paul@darkrain42.org>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Various fixes for multiuser SMB mounts
Message-ID: <20200630024314.GA1595606@haley.home.arpa>
Mail-Followup-To: =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <20200626195809.429507-1-paul@darkrain42.org>
 <CAH2r5mtLgvE=0R_d3oUPTvcB_O0e-j3WX91O8QrvMTGSN+bmFQ@mail.gmail.com>
 <87zh8mgqix.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zh8mgqix.fsf@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2020-06-29 11:39:02 +0200, Aurélien Aptel wrote:
>Thanks Paul!
>
>All changes looks good to me and I think could be squashed into 1
>commit: they are all adjusting the volume info used to mount from the master
>tcon, all in the same func.

I kept them separate just because they may have different applicability to 
stable branches. As I wrote that, though, I realized I didn't test/check if 
they'd apply or not (because of ordering).

I don't mind if they're squashed.  (I can do that and resend if needed.)

>Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
>Steve French <smfrench@gmail.com> writes:
>> these and the two others (one from one) recently posted tentatively
>> merged into cifs-2.6.git for-next pending review and testing
>
>I don't think we have any multiuser tests, sadly :(
>
>Cheers,
>-- 
>Aurélien Aptel / SUSE Labs Samba Team
>GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
>GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
>

~Paul

