Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326D2C433C1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 16:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0776193C
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 16:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCZQLd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 12:11:33 -0400
Received: from mx.cjr.nz ([51.158.111.142]:16520 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230080AbhCZQLB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Mar 2021 12:11:01 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 274087FD53;
        Fri, 26 Mar 2021 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1616775060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nJBUEP+3wKnuu4vHPTqV290re8sqt6YSUE9Cona93Y=;
        b=dhEfZ6ixLvROGvkzd3Nr61BkPBI8naI9q6OVcq+KZZJn/pSBx1dQOJF1Mi4IDu0Gc2MLFA
        z6byjMfJTx/U2PvXqXZewXw9MtEbVNzNaYvLFoL10Ul71gCmvHtLD/3Jc3JdPjfMySoR57
        7O2Xg0TAAvi6zuLQRn99CNPuzTShzb8cHuQCNUv9r4C4BxnAAx2nqNSEvI3032/a8Jvlrr
        QMNvZtFlays6IzPObbzwajm8i/PzTOA1NuixnDgo72TnETRlXoDvK5J4qAt48dT66CATi6
        rBRBGOTLRq1EArqA7gWmwTaIfH09O/Lgl1A4VpnOI5/fJzi+Yb2JjSfDS1gCcw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: cifs: Fix chmod with modefromsid when an older ACE already exists.
In-Reply-To: <87a6qprk06.fsf@suse.com>
References: <CANT5p=rr-rDZ1Jo_rzM0_63-pHOKPcRSnML0ucOVkSBVWrSc4A@mail.gmail.com>
 <87a6qprk06.fsf@suse.com>
Date:   Fri, 26 Mar 2021 13:10:54 -0300
Message-ID: <875z1devzl.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:

> Shyam Prasad N <nspmangalore@gmail.com> writes:
>> Found a regression in modefromsid with my last fix in cifsacl.
>> Tested against mode check tests for both cifsacl and modefromsid this ti=
me.
>
> Can you put a Fixes tag?

Agreed.  With that,

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
