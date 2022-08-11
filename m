Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FCBC19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 13:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiHKNUm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbiHKNUl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 09:20:41 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457F11BE90
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 06:20:40 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CBBFC8026A;
        Thu, 11 Aug 2022 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660224038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tMPFe8JfQtp6Ip8IphiuquM5wWGut7ihUWn+H28mCvc=;
        b=09foNt/hqBRfOlgHuQlt9JowbMthXzUTQ1WxtKABIjJUkDQ4GeAneNVdSBwVGVDxx+d2vz
        tWTed1G2OQY9XDVB0BEDvEGK0tyNAlP/hLzIJ0DZbBXcudjHRupvufwQfRyMzYOZZyfcBz
        2wD2sd09BixW5/9gSeNCB+WUiEg7V1TSqseaMFvkeTs5smTGTvp7tqfCeq1UClacn2WdmB
        uXPsC0c7SImFM19BkiWPAg8GjtJykUgIHXbSEMlHEKHIzvLzdv0w3jjMvhgg8qMoXM8WC5
        m6cYZIrZXPLmcsmVZJO4MagILrRGXesmu+NsNTlxuPJ89tY9UyXrMubrJ58Naw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH 5/9] cifs: Do not access tcon->cfids->cfid directly from
 is_path_accessible
In-Reply-To: <20220809021156.3086869-6-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
 <20220809021156.3086869-6-lsahlber@redhat.com>
Date:   Thu, 11 Aug 2022 10:20:50 -0300
Message-ID: <87leruudal.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> cfids will soon keep a list of cached fids so we should not access this
> directly from outside of cached_dir.c
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 10 ++++++----
>  fs/cifs/cached_dir.h |  2 +-
>  fs/cifs/readdir.c    |  4 ++--
>  fs/cifs/smb2inode.c  |  2 +-
>  fs/cifs/smb2ops.c    | 18 ++++++++++++++----
>  5 files changed, 24 insertions(+), 12 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
