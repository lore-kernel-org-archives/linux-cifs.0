Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D496C433E0
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 01:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC83207AA
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 01:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbhACBZ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Jan 2021 20:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbhACBZ5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Jan 2021 20:25:57 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1213C061573
        for <linux-cifs@vger.kernel.org>; Sat,  2 Jan 2021 17:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:To:From:Date:CC;
        bh=IYoMenPQ75c9f3stiFW+Wo0tHXzrNB9ehkeehzlmNOs=; b=fw994qPbX1hEQsFBq3eOeHFyos
        tZnUm8UhfwGgN07DXben1oG7G/MXfmGKGD2I0BBDEECf/jgikoK40+HnT2g5W2aQuAqJUjd95/7+L
        YgpziV1lSdZTbl6nU9338eHuNnzAtyJCX8OU6fJVZ4NKYeXa76unAm47WIlDYNpIoI94E0s2fKK/e
        3iCQ3Z0yVj3LgVWHbs6exWV1DDZqfEgFnyCIP5DwpJu9Mg6e0aZod1n4nKD3VLwUejHoFaikFxK3s
        DOYyOKnHBx4cXpRv07KJs/JBqMPvVG46npqck0P2annqZXRlY09jHVrXMzUYhbvY1Pxn+vNwCEno3
        DXw+SVXUVZwLuOH3h7gUHvGj6B9kEvFqAE9/7a04AK3dLoGDhT5QD0j//igx+jdwazE3HW3baG3mE
        R4UsgLj65NcQ8WcsslYM3G0H66Zzgg7TbB9Lm8zCOi84uSvYk2CLw8iRtb/ZUJgapp7dh5YSQw9PO
        lrqd4Zw1a56HCO8FDuCPS954;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kvs8w-00055d-1J; Sun, 03 Jan 2021 01:25:14 +0000
Date:   Sat, 2 Jan 2021 17:25:11 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>, Xiaoli Feng <xifeng@redhat.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file
 name
Message-ID: <20210103012511.GC117067@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
 <20210101060050.GA1892237@jeremy-acer>
 <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
 <20210101195821.GA41555@jeremy-acer>
 <CAH2r5mvt_cHDbT0xaeLNQn=5cQ0T2-wPgpMkYEGQNdtDZ3kP=A@mail.gmail.com>
 <20210102025837.GA61433@jeremy-acer>
 <CAH2r5ms1V2KKb6T3ELQ-JsQ3fniOScTE2654_xLwnPruiekzEw@mail.gmail.com>
 <20210102052524.GA67422@jeremy-acer>
 <CAH2r5msZt0UZG5r5Z7=_jQf=-xgNz8zW7fZOnqncqeJHB=mOmA@mail.gmail.com>
 <20210103012116.GA117067@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210103012116.GA117067@jeremy-acer>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Jan 02, 2021 at 05:21:16PM -0800, Jeremy Allison via samba-technical wrote:
>On Sat, Jan 02, 2021 at 06:19:39PM -0600, Steve French wrote:
>>I agree with the idea of being safe (in the smbclient in this case),
>>and not returning potentially dangerous file names (even if a very
>>remote danger to the tool, smbclient in this case), but I am not
>>convinced that the "user friendly" behavior is to reject the names
>>with the rather confusing message - especially as it would mean that
>>inserting a single file with an odd name into a server could make the
>>whole share unusable for smbclient (e.g. in a backup scenario).  I

FYI, as I pointed out this only happens if you *explicitly*
set a server parameter that is only expected to be set on
a share with "clean" (no non-Windows) names.

So just creating a file containing : \ etc. doesn't do
this - you have to misconfigure the server FIRST.
