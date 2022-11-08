Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF95C4332F
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 11:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiKHLnQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Nov 2022 06:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiKHLnP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Nov 2022 06:43:15 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD41526AC6
        for <linux-cifs@vger.kernel.org>; Tue,  8 Nov 2022 03:43:13 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id c1so19201108lfi.7
        for <linux-cifs@vger.kernel.org>; Tue, 08 Nov 2022 03:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gwN+NBWjgTlGG5IrJRm+nUWJ1cf4TtFYW2YC+eKS5Ho=;
        b=EA9LZlKRfLHe1dzj/L/iRQ8LqqYR3IeBUMqEqvAULx1ym3CqINg1HDD5H8ISNralRA
         6JQHXKcS6llbHTAQzSco1DX4FY0DSlytaquoJ9PRHpxcvFJXCVmm3MpYpua5u2qqO02q
         Tw4KJcs383aS+GEWUuqqESYvrzkBRftT7rh3yub0k2R9u/Z/xn4mzTnexVha18HSIMvc
         laECU89WbSMdF5ttZkN15DfKZlAgCZy0R242T7bzwQIGdvLI8icjGlci6Ji8mDCEMcPx
         XGzH25y4p1GL3hbO3ZDvIZ4IWuII+vPy+CCIU0qGFXhkqUCEXb7Uo6gxurktF1TQyaHP
         NJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gwN+NBWjgTlGG5IrJRm+nUWJ1cf4TtFYW2YC+eKS5Ho=;
        b=CW670Fpkj0JSmxqWtlGbCQCzyE28Rl2Ix70Jso7772SHw+jD1ilxvZWGYBU8woc1ZV
         4zqleRbkhkCUAJEkpbTA4LCGRM8SBF3ASev/NdjlslUsbfwpuf6lAvyjt6zxNZBIAUFc
         EsafxQmiv7edEv7ZMqzIsDmCE3LxcA7MsMNfqqUoGz3+gsLzTZdCSBZYsRxmU3WX4/zz
         YcnpkzFeqzpt9OS0hvL0mj4zmgpM8twHPwb8DpsGFHdbxOOTtlzViVu2553QwO+aBkTS
         XRJY/6GWImBN4swQYh5iECBJSwtyiMYapS8RJ4PxL21GtmHYqIUGQ0bt6l1GDtxU0fZX
         744A==
X-Gm-Message-State: ACrzQf0LCcZ7WapuFvrE5WhpFvsMXanONySQs5Gq+piVXCib1eL//BFX
        mkRcwKoNduKt2InXjiAlNwGkMb5MHSuXj5SBYps=
X-Google-Smtp-Source: AMsMyM5IVjknTHBiGYcbYqBIUk8ILU2YQ/KuqjK9VAZzeVTz/CDYxCeKisNH5JVarXDrsKhwOomUheWdEv47g880MRE=
X-Received: by 2002:a19:f71a:0:b0:4a2:4fdb:5037 with SMTP id
 z26-20020a19f71a000000b004a24fdb5037mr20984364lfe.535.1667907791912; Tue, 08
 Nov 2022 03:43:11 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 8 Nov 2022 17:13:00 +0530
Message-ID: <CANT5p=oz_aG9OZ0SKiPDa5WeEkN06WhuCyXPiDehDGdGaazP3Q@mail.gmail.com>
Subject: Network namespace for dns_resolver upcall
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

We have a user who's complaining about cifs.ko not querying the DNS in
the right network namespace. I could see that we pass the network
namespace in the call to dns_query.

Wondering if key.dns_resolver also needs to switch to the right
network namespace before executing?

-- 
Regards,
Shyam
