Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612ABC43217
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 19:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJDTI5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 15:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJDTI4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 15:08:56 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF845A2FD;
        Tue,  4 Oct 2022 12:08:55 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 6487080B8A;
        Tue,  4 Oct 2022 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664910050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cvV5XO3ylK5FK1gANSWSwikc0pVYpXVdsUgPuT78aGo=;
        b=a3q3LfgY8Yo+sVRT9GjdQDSTwwwPwiqdHpRUvYQ6jJp9vJEnReR++sGUTQye6hXBl37ezf
        PinXzTjZ5dYJN1Q1Q8H6gEPDwukEZIK0+XE7wUtV1Ao0h7dpL1iNBjmbXffkMOuTMk2tiL
        wDc5sHGkNLPBrPBO2THnYC6Eq7W5rlmOeJKylEQAPIJSs3eHoE+4QfkJ1oEkVAPd3c+0J9
        qMtErMk3G4nU+a7KdlrWeM+q/h4eeTZswV0i3jLu+ySRK1T6f+M0gIyTNSPsOrxdBM0oNQ
        53zVaJ6M/3RykpuPh2NKb39YpMGbQe+AYG8e2YvfyevJ6q7DfkOwVgbqiFkbhQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, kernel-janitors@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: check returned value for error
In-Reply-To: <20221004062333.416225-2-usama.anjum@collabora.com>
References: <20221004062333.416225-1-usama.anjum@collabora.com>
 <20221004062333.416225-2-usama.anjum@collabora.com>
Date:   Tue, 04 Oct 2022 16:01:40 -0300
Message-ID: <87lepv4dm3.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Muhammad Usama Anjum <usama.anjum@collabora.com> writes:

> smb311_decode_neg_context() can return error. Its return value should be
> checked for errors.
>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  fs/cifs/smb2pdu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2bf43c892ae6..c6e37352dbe1 100644

This patch doesn't apply in Steve's for-next branch[1].  If it still
makes sense, please rebase and resend.

[1] git://git.samba.org/sfrench/cifs-2.6.git
