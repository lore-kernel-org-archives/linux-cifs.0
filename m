Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3397C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 17:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3AC2078D
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 17:56:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="V7BHS4AJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgHMR4B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 13:56:01 -0400
Received: from mx.cjr.nz ([51.158.111.142]:19124 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgHMR4A (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 13 Aug 2020 13:56:00 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E2E6A7FD27;
        Thu, 13 Aug 2020 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1597341358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUD8C4+Fo5usLbgC7EHtJOMbGA7JXM6175H4cbNJK0w=;
        b=V7BHS4AJYHXvH+P8rH/vkIEODkt710MvQgUIf1GbprltXC2mMR2xE8RzU0uGmvjORfze/d
        PmwS3Pv1JT5dByOUUsxykQ6/umZWShRDr9wo6/Dkten0lOnsdo01EALHV+OTgcRNLvCyY2
        5d0rQezG0KnJmTiFHEcOw97wK2LJUkCojMYeMjApavLARqczxCSbP5sjHs3RlB4qy7QXRu
        Fax5LfH4KAq2zFFcEEGjxMHkcRZ3SR+dTOdeLUmbCzwzSIfozwyEhPNZyzsIJaOUrX0hN7
        8K9n+aMd2a43j5BNNd2/3tORaQRIJB4C5e9s+XpX8L/kpA6aCb4CLUxV44B92Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3] Fix mkdir when idsfromsid configured on mount
In-Reply-To: <CAH2r5ms-cXJzTqbTuE8_095aUssB8RvaqBTkfY2gHROjg7GsAQ@mail.gmail.com>
References: <CAH2r5ms-cXJzTqbTuE8_095aUssB8RvaqBTkfY2gHROjg7GsAQ@mail.gmail.com>
Date:   Thu, 13 Aug 2020 14:55:53 -0300
Message-ID: <87blje5t1y.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> From c8e2d959ddac89ee44f170b2f2549e749581ec55 Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Thu, 13 Aug 2020 12:38:08 -0500
> Subject: [PATCH] SMB3: Fix mkdir when idsfromsid configured on mount
>
> mkdir uses a compounded create operation which was not setting
> the security descriptor on create of a directory. Fix so
> mkdir now sets the mode and owner info properly when idsfromsid
> and modefromsid are configured on the mount.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> CC: Stable <stable@vger.kernel.org> # v5.8
> ---
>  fs/cifs/smb2inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index b9db73687eaa..eba01d0908dd 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -115,6 +115,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>  	vars->oparms.fid = &fid;
>  	vars->oparms.reconnect = false;
>  	vars->oparms.mode = mode;
> +	vars->oparms.cifs_sb = cifs_sb;
>  
>  	rqst[num_rqst].rq_iov = &vars->open_iov[0];
>  	rqst[num_rqst].rq_nvec = SMB2_CREATE_IOV_SIZE;

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
