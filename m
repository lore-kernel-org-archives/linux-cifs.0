Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3679EEE4993
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Aug 2023 18:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjHUS6h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjHUS6g (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Aug 2023 14:58:36 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141B135A6
        for <linux-cifs@vger.kernel.org>; Mon, 21 Aug 2023 11:58:03 -0700 (PDT)
Message-ID: <47448feef25a3826acaa72381e92fb09.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692644256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tsfmYBEn65KNj7Z7538A9Y+d4URgPcEEoa14skFFGPA=;
        b=mO8KUYghQ2KWlSXSLwgIlez+3Es1Fr8D/sA2dscvtOxAYvaC4p9U/XjZfIACtuMfNs358j
        Lo2VM7aKHA3Fepop5L0DsxY/uvQBwPLxWPw+w7EXA0cMYWKp3NVGPG9TbglBcrXt9wPk4C
        1CcF0b+7AguS5eAuBZbfrdqCRB52Bs1NanqIoanK2vRITWP5MYRIRr7pCDEIktN8S0bINW
        US9FtMnbqTOHynyGZi/OjLsnXiCpT/v/g7ChORJuRhV+4NYiF1n/lvVbhDHqEyQXsZW/mu
        Jt56TTq383tK9bUgBMhbtbKccGjg3ZrB4J71cuqrQ/WUiVjLSoThpcyV5PIwqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692644256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tsfmYBEn65KNj7Z7538A9Y+d4URgPcEEoa14skFFGPA=;
        b=C8czGobX1FzrDXImQJuN1zn8xwbVMcT2AyP/Xze81X5reM16VQrb7tpCQlMKhWYDji4ddp
        rueEpmg8z8dAMwdMtBExYUoNR0sYm5v96hXyBaYXcqCiyg4ZSsmGfbRZyphGeLQUrXV9cf
        P/QrowieXimB08Xq9va7qma981AJ65WTF6YTJjZ5zloVvlq04srMoYfZ8mBySge9lLKaiJ
        GfBfSRcbpA+DiVJF+uQcyHIlzibAXASYtqfZsbXTMy5hvqV6xwho5ejCfGE9gGu0lJFAIR
        efS/ZAcuwx6R6VS8p0fNdYshK0ZhwAIK4ajTjAIeVh095ywD/ctWGJvnB7//7g==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692644256; a=rsa-sha256;
        cv=none;
        b=hCb2NsDGCDqv6TN32mXa1sFqPXbpaVTe3OqodSPLGYhrlLBS/UBjcuf/HMNabvmJvkdmYy
        Eu8LhYgmSJkcAv52sLX3cO+xjQBnl+jEcuWz0x/kd8XwqRTDAT0+jRRwLOOJUwOTrt8kfg
        hWU4vAdC9wDO5gDBzQ+y0skQt9nfnH9Sw/14uEoV5zofpyeuyjy58E31OP0e1y3EFrPtdK
        4gY6fz9Bc6l1EXD3nfhAvPdiOa0X7Q7bw+QwLs2JP9hoeSp7/KTYLUjjWX+wHjh+IJCQ7R
        D7XOn7Wwf/V2QuOCeEyr+VhUyRaAqBu6kuTLtpSB29DlWpbxWsdD+T9V/Sh0Zw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Andrew Walker <awalker@ixsystems.com>, linux-cifs@vger.kernel.org
Subject: Re: Nested NTFS volumes within Windows SMB share may result in
 inode collisions in linux client
In-Reply-To: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
Date:   Mon, 21 Aug 2023 15:57:32 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Andrew Walker <awalker@ixsystems.com> writes:

> On my Windows server I mounted multiple NTFS volumes within the same
> share and played around until I was able to create directories with
> the same fileid number.

Could you try

      https://git.samba.org/sfrench/cifs-2.6.git for-next

and see if you can still reproduce duplicate fileids?

Thanks.
