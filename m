Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC505ECAAD3
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Sep 2022 15:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiIJPUM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Sep 2022 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIJPUL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Sep 2022 11:20:11 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6A731221
        for <linux-cifs@vger.kernel.org>; Sat, 10 Sep 2022 08:20:10 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id i129so2150050vke.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 Sep 2022 08:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=NbRgJKCRWGQd/c19xH6FT1xuMFjXTuQq8SsfdtMUBb8=;
        b=MVd1vmT8Ukpy4zxs0uRhiC606T1OrWOkhSAisZG49KH8YMNzf4WvaobUss0GhJ/O0V
         83NOQ59oK7BfLuJb1VPWDq5mzKEy5QIAzyKoSMfTSy6DJtcaqNwa7R4KvOtY1E0HvJ/k
         Qn90ZSKYFIRVzRDblq9X95Zgq7MeTbhBT08jZvDeV8y4N2gHaGPMQqES9iGSNTy61L/w
         3v4bBZd4gR9D3s3w0bsTJVwytBnyyB/bxIjzC12CgA0PRvSANH5OsK64AEBRfYm3D0fZ
         AbXQRmNOCJIkTMXVJE4MYeHs+zjpKjLoXjupok40sk9NgTye4CwuoOM9Y1CjpuIASO32
         2Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NbRgJKCRWGQd/c19xH6FT1xuMFjXTuQq8SsfdtMUBb8=;
        b=Ju31zATn1TluPMcBXSC4I0h6VKDF3Y9MPhweu6TBSwVlk6a3WB18ocmz9AqjCoajrj
         M0lFpoDKSCUj1Mz32wJllykR69ThpHmMLnDEXEHbNgpYoQnqtV/YXhS+OvgAKSzr5mW7
         iMsxm21nqFkWKwSyiNv5m0PMW832Idwa2dCJs7FiuSFTzJWM3kj1o6dcVRpY8BMDJhFz
         Yo/i6m8DDUmNCixlMMdc6IYwPIRQHyKvxdcnIuWbFasIdu3rhhDeGffTIceJd++DWdze
         ZmUUNttbhuxxI72fNG65EP7wRa2hOBjwmLsqYfkikDisDVw1w8M35UzJ8+gB8KcBZbKH
         XBnQ==
X-Gm-Message-State: ACgBeo1LHaBeXT2AX0LqQglI7d7n7XLir74PT/i0l3gu+V6dxZXRIvzc
        q1FIFCNKX2alsYP7crfjTxb3bfdAwcX45TgcQJb9os4k
X-Google-Smtp-Source: AA6agR6SAjfyGc7iDix0+g1c9fsHRO1WMKtQ20cpGMLfcwYr+oJIirZrA0bupHX+6Ilz+HhD9lKAovRfCkudYhoU4OU=
X-Received: by 2002:ac5:cb0a:0:b0:3a2:2fa3:87d8 with SMTP id
 r10-20020ac5cb0a000000b003a22fa387d8mr113439vkl.3.1662823209208; Sat, 10 Sep
 2022 08:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220906054240.4148159-1-lsahlber@redhat.com>
In-Reply-To: <20220906054240.4148159-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Sep 2022 10:19:58 -0500
Message-ID: <CAH2r5mu2sKKcf3H0wNYVUJgpVYLRSEPdu+PPiWZHJfNnV=aTNA@mail.gmail.com>
Subject: Re: CIFS: attempt to fix kernel bugzilla 215375
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Davyd McColl <davydm@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any thoughts about setting up VMs for Win98 to try this?  Any luck
trying to test with the fix?

On Tue, Sep 6, 2022 at 12:42 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve,
> Here is an attempt to fix kernel bz 215375.
> I can not test it, since I don't have access to servers this old but the change
> should be safe for modern users as it only affects the password field for
> "share mode" security, which we do not support anyway.
>
> It is only tested for regressions with user mode security on win98 and later systems, using ntlmssp
> authentication.
>
>
>


-- 
Thanks,

Steve
