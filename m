Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB22BC433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 17:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D01F613AE
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 17:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhDTRCq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbhDTRCq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Apr 2021 13:02:46 -0400
Received: from mail.tuxed.org (mail.tuxed.org [IPv6:2a01:4f8:c2c:58f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBB9C06174A
        for <linux-cifs@vger.kernel.org>; Tue, 20 Apr 2021 10:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alexanderkoch.net;
        s=2019; t=1618938133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UeHOEOQG/cbqaVtcmDocaExLD0ZqjQmo53IGer9RWk=;
        b=N3S3Zc6h5DOVWryKjcSE2zW2V9apIhjKDCT7/+ix+fG4s778P7U6jKxlll4Qfm92gKZjFS
        gVJDuLLUlMXtVrwq/z7HuVXMTzMutyj06vMAryxDDKAR7ycPmrcTQbs3++mevmT6RD4fmn
        K9SQDlO6Ko/Pp1mmYhvCYxRbCuu+Uz2olJGapX9JG8MJgi8w9tAirsTLRpksdBLBq0NbdJ
        lIeuTRSv1hlFUR9H6QvLDEeWGuXSjjTbmDQW/+EwF8cfTNl4WFIhR0JM3GHN9LqfPvPOY9
        HSVYhJdsuAke2mQAE/kgGuUxT6bD4HbKJQZny2EvOrPflsNFFZMzfLLx0Xuc0Q==
MIME-Version: 1.0
Date:   Tue, 20 Apr 2021 19:02:10 +0200
From:   Alexander Koch <mail@alexanderkoch.net>
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: cifs.upcall broken with cifs-utils 6.13
In-Reply-To: <87h7k0zz6r.fsf@suse.com>
References: <a01d5d22-5990-c00d-bc2a-582d2585ea69@alexanderkoch.net>
 <87h7k0zz6r.fsf@suse.com>
Message-ID: <956dd84c4e27fd02541ca4fabb7b1776@alexanderkoch.net>
X-Sender: mail@alexanderkoch.net
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alexanderkoch.net; s=2019; t=1618938133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UeHOEOQG/cbqaVtcmDocaExLD0ZqjQmo53IGer9RWk=;
        b=TyQg6F78cJczPnGWXMZUEXRZBhetseKhjt8YSWlmJ7tiRk25uZHBiwTxhdHt7RipdCTX9i
        g4osDDYDpr7NGqhzZNZHu9IuBjlNVwmKwGL4KCX4V09wf6h45Yr37mZC790lW3LrWB/8Aq
        uB7UuvRiyI9ro3AYBnSxRFV8THpoeesuVXBj5ADzURL630PFs8kIf8OKUJGEw2woimG80b
        eTGL3Z1FlEI7GLTvIVh41OvM2aitC9BD5YZujUyjJYXPpiiF8gnMnKW1zPIy2B+8R48cFz
        rNg6QLGEYOgZdCZR9anr434EHPNvr8zpWJbAeLX4E2ur2CNWCLfNeZ7xXoxZMg==
ARC-Seal: i=1; s=2019; d=alexanderkoch.net; t=1618938133; a=rsa-sha256;
        cv=none;
        b=j0L52b9FXfEKZBF03tumRlNnxik54kNAqbKHbDbHHlPqLM2t96Qv/aUn6s/eS4BBUoDg1/
        XDcf1kcAuIc6MNppeHHO9pZsuZQ9Xk+bSqL9s86uiN38YftNAMOjnI77//TYnS018qRVGT
        FPQWgtZfnCqo7qTvDWOJeR9zh6lbGuMtsoYoEnMvOMwf212sWI07JiY1Rsbx9Xysz0diuj
        JDahBmXkUR4xiPUILBdA5H1HZuc6aNrbC1eQts9SqjyfoToYCjgVvERLWQUImjmVZCwS1G
        MuBGKDJ72TseR9s0j+WQuiWNE5gb8n+LdkpB1W2jrUej+ndOdTBdF+KHWyFYRw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=mail@alexanderkoch.net smtp.mailfrom=mail@alexanderkoch.net
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=mail@alexanderkoch.net smtp.mailfrom=mail@alexanderkoch.net
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aurélien,

>> The recent release of cifs-utils 6.13, more precisely e461afd8cf 
>> (which,
>> to my understanding, is a fix for CVE-2021-20208) makes attempts of
>> mounting CIFS shares with krb5 fail for me:
>> 
>> Can anyone tell me if this is a packaging/configuration issue (Arch in
>> my case) or a bug?
> 
> It's unfortunately a regression in the CVE fix. We are trying to come 
> up
> with a proper fix.
> 
> In the meantime, as a workaround:
> 
> * you can build cifs-utils --with-libcap=yes (libcap instead of
> libcapng). This will skip
>   capability dropping in cifs.upcall.c.
> * Alternatively you can comment out the call to trim_capabilities() in
>   cifs.upcall.c.

Thanks a million for the clarification. For me, downgrading the package 
to
6.12 works as an intermediate solution.

I'll open a task on the Arch bugtracker and let the package maintainer
decide what to do with the package until a proper fix is done.


Cheers,

Alex
