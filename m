Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C32C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 19:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiJDTOp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 15:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJDTOl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 15:14:41 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F086F2196
        for <linux-cifs@vger.kernel.org>; Tue,  4 Oct 2022 12:14:36 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 7478E8112E;
        Tue,  4 Oct 2022 19:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664910874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pEkkr+bF8FqyShd+dAmUpUHPkDGnyRlBPJzgjNiESws=;
        b=nFJi4kHfQVaB9VbfTI5oerpx38oxVAkatBNeNjAk8SOzTjxRTHWaHQMjYjfFK508n+8MZi
        27c+Lph8ufxzBi61JLmB+RXDqt1fbYYYjEuRQSrSLdB98BOk1JHFgCDFMN/44sW6pZB4yM
        Tjm2Ri6PBUBQ6knZQhtJUwJ79NrcV0o99ip/QwKdmYLs2CSmoookcf+i+QOxhFc3CjaMZM
        re4MA/jSNTbwPatX8z7BNe0UtH8+vhdAgsUBxqPIEy+S+EHja2faDA3atPuN/vezxja2IX
        zGRkrRFJ1BSRWIzpjm9CrhDrQ+jnIeJX35tKPsHGcnGPqJY+jRHV/jFC9kdvUQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        tom@talpey.com, linkinjeon@kernel.org, hyc.lee@gmail.com
Subject: Re: [PATCH v8 0/3] Fix some bug in FSCTL_VALIDATE_NEGOTIATE_INFO
 handler
In-Reply-To: <20220926033631.926637-1-zhangxiaoxu5@huawei.com>
References: <20220926033631.926637-1-zhangxiaoxu5@huawei.com>
Date:   Tue, 04 Oct 2022 16:15:23 -0300
Message-ID: <87fsg34cz8.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

> v7->v8: update the commit message and smb2_ioctl just ensure the
> 	DialectCount in the payload.
> v6->v7: squash 2 and 3; use helper function to get the dialect count
> v5->v6: use 'static' for 'smbx_neg_dialects'
> v4->v5: reorder the patch;
> 	add check in smb2_ioctl() to ensure no oob read to DialectCount
> v3->v4: Fix the wrong sizeof validate_negotiate_info_req in ksmbd
> v2->v3: refactor the dialects in struct validate_negotiate_info_req to
> 	variable array
> v1->v2: fix some bug in ksmbd when handle FSCTL_VALIDATE_NEGOTIATE_INFO
> 	message
>
> Zhang Xiaoxu (3):
>   cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
>   ksmbd: Fix wrong return value and message length check in smb2_ioctl()
>   cifs: Refactor dialects in validate_negotiate_info_req to variable
>     array
>
>  fs/cifs/smb2pdu.c         | 94 ++++++++++++++++++---------------------
>  fs/ksmbd/smb2pdu.c        | 13 ++++--
>  fs/smbfs_common/smb2pdu.h |  3 +-
>  3 files changed, 54 insertions(+), 56 deletions(-)

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
