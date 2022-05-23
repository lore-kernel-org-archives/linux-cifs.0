Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0517C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 10:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiEWKOB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 06:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiEWKN7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 06:13:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DB221A9
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 03:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=mBuqr4Xysnbts/387iae8Z7cheTZBoyBd5m7Gq72ZU8=; b=N32MaajTAgBZ9DLrXoDHzrLT+V
        Mm4RiSqqAVC1aPSCUflg0URC8guVgNAx1jN3FPmO7MxdiCW8qgtehJY/MG/S3gDmU9b94BwUkBGa4
        VRWS2sYLiKz5oJo/rFY7DWUk2E2VYJ7Uc+Gy1sdSB9dQANYLkH8ID4GJNP+iNloCIuOk3NL05mO9R
        /mQbg7cAp/R0snv4Mg8rXQgMelf6pnrlkCBpJqhpeSEg8Sg4OV2dVciwrzANPbcHeg/d27Xj+h83S
        Gbdx03YHNFPyw+pjEYnH31KBOccBNa77RbqIwuebdJ4MdTQ7Ch2Q64MgnLlpqehnjfXjahjDj3GRt
        gcncL2i6/oXmenp5j0oZwBIwLh/VVpjqj1brem5EoEaMAYLG46EL2UhGJsHxYUDmLM/jeQ4uT/Kj6
        e57b2z3H6HtbnwLA8nTmTlw4+uuBdpiYqFR4txTm9BKXTqaayqCVXkNTM9alq+QUq3WqHXNCj4Gol
        Mvy6OJv9mg+ORWlB9+/EOwu4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nt54O-0027bs-DS; Mon, 23 May 2022 10:13:48 +0000
Date:   Mon, 23 May 2022 12:13:47 +0200
From:   David Disseldorp <ddiss@samba.org>
To:     Steve French via samba-technical <samba-technical@lists.samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] Add defines for various newer FSCTLs
Message-ID: <20220523121347.46d2b764@samba.org>
In-Reply-To: <CAH2r5mveWTtio_Aei3VEht6KaxU6quSgwgopvXbFfMtE40q0YQ@mail.gmail.com>
References: <CAH2r5muiMW76Xt2zRNJWTcQVuewEj3Qs3p4oc8tvEyw5f6528g@mail.gmail.com>
        <CAH2r5mveWTtio_Aei3VEht6KaxU6quSgwgopvXbFfMtE40q0YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Patch looks fine to me:
Reviewed-by: David Disseldorp <ddiss@suse.de>

On Sun, 22 May 2022 19:09:34 -0500, Steve French via samba-technical wrote:

>  #define FSCTL_DUPLICATE_EXTENTS_TO_FILE 0x00098344
> +#define FSCTL_DUPLICATE_EXTENTS_TO_FILE_EX 0x000983E8

This one looks interesting - I wonder what kind of client use it gets.
FICLONERANGE / BTRFS_IOC_CLONE_RANGE is atomic, so it should be possible
to extend Samba's current dup-extents support to handle the new flag
(DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC) without needing any lower
level changes.

Cheers, David
