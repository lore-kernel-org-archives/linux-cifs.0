Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3EEC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 14:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbiFIOxe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 10:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245414AbiFIOxW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 10:53:22 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F79221683
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 07:53:20 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4DE137FD43;
        Thu,  9 Jun 2022 14:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1654786398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6mviqEnZceIWFuo51bPCOSyoQlT9irELa5Fd5VUb5o8=;
        b=wSURTSnE4ZUddwn1U4UNJ2bYAwAcSNnBZgGYIUSZEV2xavyB4TPYXaVvtsrgJd1mBg8pQF
        JJCn4rTfDred3xNCKsZt2kD2JuY0msYT3TTTQhAkI8ueUZf95n9JJUBA6dkaHlaOyqw3bJ
        OesDM0w6EK1v880tiQIhVZvikQLiGj7fNgiDRJBy5bumX+NwgnjN2HgCM2WqbORnarE7eV
        S53gw7k77whsqhXF92mWDnvr+1AhczFLjr1FmRi16OrEl5i9YB7ytwhKTYuBZmi2kNCQRg
        bGRruweIobNBOvUcRj+6gQObTyrXFsH2N8NmMiLlkNXkPuiMFgQ44VG8E1qiuA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
In-Reply-To: <20220608215444.1216-1-ematsumiya@suse.de>
References: <20220608215444.1216-1-ematsumiya@suse.de>
Date:   Thu, 09 Jun 2022 11:53:13 -0300
Message-ID: <87czfhx50m.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

Enzo Matsumiya <ematsumiya@suse.de> writes:

> These 2 patches are a simple way to fix the DNS issue that
> currently exists in cifs, where the upcall to key.dns_resolver will
> always return 0 for the record TTL, hence, making the resolve worker
> always use the default value SMB_DNS_RESOLVE_INTERVAL_DEFAULT
> (currently 600 seconds).
>
> This also makes the new setting `dns_interval' user-configurable via
> procfs (/proc/fs/cifs/dns_interval).

How is the user supposed to know which TTL value will be used?  If the
expire time is set by either key.dns_resolver or any other program used
for dns_resolver key, the above setting would no longer work and users
might get confused.
