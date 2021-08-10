Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CCCC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 14:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A53760EB5
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 14:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbhHJOpD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 10:45:03 -0400
Received: from mx.cjr.nz ([51.158.111.142]:48996 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241557AbhHJOpC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 10 Aug 2021 10:45:02 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 888317FCFE;
        Tue, 10 Aug 2021 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1628606679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QXS4vZ7Woje/Yq9Tz2fz3Wqicc2dQsyEQC/1R0hUpCQ=;
        b=NPGkzQ04gnStFJ3heGrmlLzNAHIzphWBnWDSQwuTvyB+B3GeEaBjmh5McN1ABswPxAAVaY
        /8nNWFZTuJz0kUu3J1/dQDVsoH8pEGpUwFkZD7vlAuQkQDV1COBY9YsFcx+UwIkyUfj8hK
        4T6EfE+SGR1PqNofv/fvEdHKe+zvMmG8npxJEQCTZhWTitU4sQ5TMEBitGoAECAEUNA7j2
        zSOOSKOGlsL+rKD0JzP/BtEN+O53ckAW+gcXblwZHIp2/QQZT7VgoGu49Iv17LwTk1HPbQ
        xgBhgysL+P8GN58sgEJex35c1yL0CZX8Jj8D6ctRBZLxxIR9VW1jKW9r3yE/XQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: use the correct max-length for dentry_path_raw()
In-Reply-To: <20210810063355.721945-1-lsahlber@redhat.com>
References: <20210810063355.721945-1-lsahlber@redhat.com>
Date:   Tue, 10 Aug 2021 11:44:34 -0300
Message-ID: <87zgtpmka5.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> RHBZ: 1972502
>
> PATH_MAX is 4096 but PAGE_SIZE can be >4096 on some architectures
> such as ppc and would thus write beyond the end of the actual object.
>
> CC: Stable <stable@vger.kernel.org>
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Suggested-by: Brian foster <bfoster@redhat.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
