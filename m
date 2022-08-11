Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A3FC25B0C
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 13:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiHKNPB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbiHKNPA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 09:15:00 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED3D6D565
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 06:14:58 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 724F58026A;
        Thu, 11 Aug 2022 13:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660223697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSxVsJIPa5b2P/pUL25wdazEoOT5i721VvTlHSgN1RU=;
        b=ZXlmFB8Fo1jA/MaB/s1tcwSQogi2T0+fPRVN3C7d8YxSthfTi/0A+x3cmO6gcTvE/Ov+sw
        nMIQr9wEOgK/VY3JqQPV6OdUVAEX6JM5RrqiQVJ2S1QlkpGRNhPpe2InquAUI+EdoJMvID
        lgHS/9OdLL9CZ4L7J5sog22Z23bA9VMdfQcpSR+G2SOI1eCmHqU4UYIu079HV5MWZ+QpCv
        YtORAlypr2Zkx3MHWoyJB8UcmXS8JX20R+LA0j+62NEtyCj2coTSTTpNz9dxfj0/xiwoHb
        lxfPDKb1lR5YrFQULS/0PoAa0ytHdumw9GvbFEZxy+EpwX8vci2L1qkF7vBfBQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH 3/9] cifs: Add constructor/destructors for tcon->cfid
In-Reply-To: <20220809021156.3086869-4-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
 <20220809021156.3086869-4-lsahlber@redhat.com>
Date:   Thu, 11 Aug 2022 10:15:08 -0300
Message-ID: <87r11mudk3.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> and move the structure definitions into cached_dir.h
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 114 ++++++++++++++++++++++++++-----------------
>  fs/cifs/cached_dir.h |  38 +++++++++++++++
>  fs/cifs/cifsglob.h   |  38 +--------------
>  fs/cifs/misc.c       |  20 ++++----
>  fs/cifs/smb2inode.c  |   4 +-
>  fs/cifs/smb2ops.c    |   8 +--
>  6 files changed, 123 insertions(+), 99 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
