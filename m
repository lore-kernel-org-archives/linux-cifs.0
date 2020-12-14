Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D9BC4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 19:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158B3223C8
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 19:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440560AbgLNT0A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 14:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438470AbgLNTZv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 14:25:51 -0500
X-Greylist: delayed 2205 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Dec 2020 11:25:10 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA53CC0613D3
        for <linux-cifs@vger.kernel.org>; Mon, 14 Dec 2020 11:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=frpW80Hpx5l6OmjqXebgV8JKMs05hfI6Ocqax9b855o=; b=mumy/bJUowl/pPwDy+RiATE8fH
        EPLxLI6bbd7iypsT9Dk+OnIzXigyUVoQezA+/bsmTM19hM3XY64tk+6n/R7oCG3WyOFf2MWx3h3gR
        MCdCQSc4h8zt5yHOfPAh9gQLJuOcp2URtoWhz/F1jPL55M1IM7VircFOU14MrqdB+V/5rRaJzXeoi
        +IH1Zdmf6OrmnPSEJlPdvG33BacEeBkq0R9vs4/DM4hdHCVn8nzzTUgA3ggNV+r9XoaVvMz+VIlqE
        N4mVU/1WvSKOuAyOxWLf6cvAKuOl00dMEivjm2xZwaZrnWkBrkjJLf1WLGK1aZ+fnLlDBAibshWDr
        n2bWuE5gAmrbb9SYYdFVJcAhoZGcC90CxScdQGSAIIHhZRsL04InrAVb5I8H6JZ+lKvGae8M2Mr+I
        tN8Q1DtrPvZdX151kFGS29wwRDuJFpixrh43G0d1goiyKJs9XuYd6Oaz/+0nDV0sqztEoY1o1uhXo
        77/Kh1FZaWNwQ8u8HuyifRfH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kostT-00027B-AJ; Mon, 14 Dec 2020 18:48:23 +0000
Date:   Mon, 14 Dec 2020 10:48:20 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: updated ksmbd (cifsd)
Message-ID: <20201214184820.GB56567@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
 <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Dec 14, 2020 at 06:45:51PM +0100, Stefan Metzmacher via samba-technical wrote:
>Am 14.12.20 um 02:20 schrieb Steve French via samba-technical:
>> I just rebased https://github.com/smfrench/smb3-kernel/tree/cifsd-for-next
>> ontop of 5.10 kernel. Let me know if you see any problems.   xfstest
>> results (and recent improvements) running Linux cifs.ko->ksmbd look
>> very promising.
>
>I just looked briefly, but I'm wondering about a few things:
>
>1. The xattr's to store additional meta data are not compatible with
>   Samba's way of storing things:
>   https://git.samba.org/?p=samba.git;a=blob;f=librpc/idl/xattr.idl
>
>   In order to make it possible to use the same filesystem with both servers
>   it would be great if the well established way used in Samba would be used
>   as well.

A thousand times this ! If cifs.ko->ksmbd adds a differnt way
of storing the extra meta-data that is incompatible with Samba
this would be a disaster for users.

Please fix this before proposing any merge.
