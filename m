Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B7EC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  2 May 2022 06:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352385AbiEBGTc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 May 2022 02:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350711AbiEBGS6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 May 2022 02:18:58 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5B8FE6
        for <linux-cifs@vger.kernel.org>; Sun,  1 May 2022 23:15:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a1so15502538edt.3
        for <linux-cifs@vger.kernel.org>; Sun, 01 May 2022 23:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=dsQ4DasZ97TstD6CH9mKsRhMeBG8jkCR4NZRMMq7n6s=;
        b=NsPlSV5lRnIbehriSItLPTGssHu4s5b0E7vn2bFwZDJDLC2Agw70Qpz8XMOiy+1FNz
         HYKGF5IddGdSzA1WDP8pJe2scXfMwW8O2dRn6dsBe8zMGABWCR2F+dKxNY3PBjAo7drQ
         ziIGeouNBtQ0zVSkN/8RKK5Zelc/nwGqKE3kO1NwJQmGsO5wQjD77mPt0OMfdTfJxTCq
         jeoEOkG0/chrZ8+z9aJ3Y/Ew5AWpP8ia5vuH9bf6rIrSUyMa3HpQgUD53URxl376sLty
         HVV6wxSr+O3bfw71jtCeTDPeiTnN4qE2i5TsoMZiahlG8WHraLOUgQlAfcQBwoL4URi1
         gGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dsQ4DasZ97TstD6CH9mKsRhMeBG8jkCR4NZRMMq7n6s=;
        b=ZNMfNZ+n2BpHwNsy5WyVX+tGSit9AimCYOIxNyvQtWd/XjFWqQ8SPe9t6A8xpnox4w
         VDOYQI5nt6QWzxz4Ojjm22ZvSX2GCyi65h6tewSwbhVtV5DUetk7HK7LdNf6P1qvMCfv
         +0JKHc506HlmknMNChfbJcl0KKyhWFFa0uN7Zjst0hKxpzZJtnZIrk5uJny7dFmLTKij
         HdxK3+doUNZTW2e6OKLskMl5NM6BlrNuejc3Jc087avFaE1SgNVLuUK/S8951gF98ard
         NlD0uf4ZaMSqqcpseJqtHT57P8UyJqZSitvXANhA640B5Qii4nY3c8lKZuQua88x1URJ
         kHLA==
X-Gm-Message-State: AOAM530BHKelTlTd1R1AKkjBxjYs19tDwbf8p8RtI3HGYKK2Mstkfn0E
        2NCJ2JnW+lMRCpPnbBHNC8BUP/6e0ylMSbFKCwo=
X-Google-Smtp-Source: ABdhPJzhIxVGaEGaAebxSs2TnwUBi4XbRclKHmFRg2h1v47vaa/7ik74OjsNq5JcPPa6tji/hEkO1hOS38+ARvcsGuw=
X-Received: by 2002:a05:6402:1e8d:b0:426:9:6ec with SMTP id
 f13-20020a0564021e8d00b00426000906ecmr12106983edf.55.1651472126099; Sun, 01
 May 2022 23:15:26 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 2 May 2022 11:45:15 +0530
Message-ID: <CANT5p=orC=ZqQe9kAidenzdQGB9gPSmmWP_1j0wk765EKeThNQ@mail.gmail.com>
Subject: identifying key_type_dns_resolver
To:     David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

While checking on something else, I noticed that key_type_dns_resolver
keyring is flagged with KEY_FLAG_ROOT_CAN_CLEAR, and the individual
lookup keys are flagged as KEY_FLAG_ROOT_CAN_INVAL. From what I
understand, that means that the root user can clear the keyring from
the userspace, and can also revoke individual keys.

My question now is, how do I identify the serial num for the
key_type_dns_resolver keyring?
From the code, I see that we kdebug this during the instantiation of
this keyring. But I guess this would only be at kernel bootup (since
by default the dns resolver is configured to be part of the kernel,
and not a .ko).

Is there any other easy way to identify this keyring on a system that
has an uptime of several weeks/months?

-- 
Regards,
Shyam
