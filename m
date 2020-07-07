Return-Path: <SRS0=GU4v=AS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C112AC433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 20:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A007820738
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 20:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgGGUeE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jul 2020 16:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGGUeE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jul 2020 16:34:04 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2228BC061755
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2020 13:34:04 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature ED25519)
        (Client CN "otters", Issuer "otters" (not verified))
        by o-chul.darkrain42.org (Postfix) with ESMTPS id 9850D80F3;
        Tue,  7 Jul 2020 13:34:02 -0700 (PDT)
Received: by haley.home.arpa (Postfix, from userid 1000)
        id 0816F35B26; Tue,  7 Jul 2020 13:34:01 -0700 (PDT)
Date:   Tue, 7 Jul 2020 13:34:01 -0700
From:   Paul Aurich <paul@darkrain42.org>
To:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org, linux-sparse@vger.kernel.org,
        sfrench@samba.org, Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: lock checking issues (was: Re: [PATCH v3] cifs: Fix leak when
 handling lease break for cached root fid)
Message-ID: <20200707203401.GA409312@haley.home.arpa>
Mail-Followup-To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org, linux-sparse@vger.kernel.org,
        sfrench@samba.org, Ronnie Sahlberg <lsahlber@redhat.com>
References: <20200702164411.108672-1-paul@darkrain42.org>
 <878sfx6o64.fsf@suse.com>
 <20200706192642.GA110607@haley.home.arpa>
 <87tuyj6c3u.fsf@suse.com>
 <20200707130509.om7rgkm75baszqye@ltop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200707130509.om7rgkm75baszqye@ltop.local>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2020-07-07 15:05:09 +0200, Luc Van Oostenryck wrote:
>> To be honnest I'm not sure, these seem counterproductive. If you are
>> indicating you are acquiring X but lock Y the next line it feels like we
>> are fighting the tool instead of letting it help us.
>
>__acquire() & __release() should only be used by locking primitives.

Alright, thanks! (I did see several other locations in the kernel that seemed 
to be doing this, though I agree with Aurélien that it didn't feel right to be 
fighting sparse, and it's possible my attempt was more egregious.)

I will try to find a better way to organize the functionality that satisfies 
both the functionality and sparse.

Thanks,
~Paul

