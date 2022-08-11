Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B19C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 13:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbiHKNDP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiHKNDM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 09:03:12 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBAE53D37
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 06:03:12 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 383218026A;
        Thu, 11 Aug 2022 13:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660222990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EFIgLrsMJqec/UxDmqkXSThVMCQl094m9fwEW9y4ifU=;
        b=tzQFhTZ2XxaLigbOUIqK/PyUR59M9xIF1/39moXu5TmMxm3ic9Kh4pcjNSJhdGz2W2/wzQ
        CAlJtO2xVMvkumH3NKZvuGMaVQUtsHdlzRmaIoOOaRMGBFLExK6E1PnNbKLYuNVRYtbbY+
        MF+KsahyEiuHgsMQkpibydkQ258gFIKRcNQxH5X1uIz8yJ1Fg8QpsW9QLevCZ7kxWrTska
        710oqQZG2wJ/X0oUkdYohC6hBF9wAr1SmIkBICH+Sx5Oi0jS0uzOaKjMl3fmvAppvWu8Ab
        eeOvOxiQAKgxrzTKkTGLSegd6qZdNAtXKInrmx8SikuCh2OVPQF1NIZKyBa6nw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH 1/9] cifs: Move cached-dir functions into a separate file
In-Reply-To: <20220809021156.3086869-2-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
 <20220809021156.3086869-2-lsahlber@redhat.com>
Date:   Thu, 11 Aug 2022 10:03:21 -0300
Message-ID: <87wnbfszja.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Also rename crfid to cfid to have consistent naming for this variable.
>
> This commit does not change any logic.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/Makefile     |   2 +-
>  fs/cifs/cached_dir.c | 363 +++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cached_dir.h |  26 ++++
>  fs/cifs/cifsfs.c     |  20 +--
>  fs/cifs/cifsglob.h   |   2 +-
>  fs/cifs/cifsproto.h  |   1 -
>  fs/cifs/cifssmb.c    |   8 +-
>  fs/cifs/inode.c      |   1 +
>  fs/cifs/misc.c       |  12 +-
>  fs/cifs/readdir.c    |   1 +
>  fs/cifs/smb2inode.c  |   5 +-
>  fs/cifs/smb2misc.c   |  13 +-
>  fs/cifs/smb2ops.c    | 297 +----------------------------------
>  fs/cifs/smb2pdu.c    |   3 +-
>  fs/cifs/smb2proto.h  |  10 --
>  15 files changed, 412 insertions(+), 352 deletions(-)
>  create mode 100644 fs/cifs/cached_dir.c
>  create mode 100644 fs/cifs/cached_dir.h

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
