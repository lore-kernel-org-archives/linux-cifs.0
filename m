Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA524C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 15:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiHKP2D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 11:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiHKP2C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 11:28:02 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581D45041
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 08:28:01 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id s129so18580872vsb.11
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 08:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ilywJhTYf/dadLVHSO+f7RSY7OP4kxNg/tHVML94Wxs=;
        b=g1epdX/ssUDizYBovGEhIMooMsJ8JpET/GTfkG64gX21jDIzExMgocNdXSiDdbwCQ1
         UbohhRi9hGh2aoSfifyBjzoVgEpGq9WEtO09z351UhvrVePiJy5DROyfgaJP1Krhef/2
         DTVybVCSvGRjAf2PFit/gUq2+wDUX0RWbPCyeDBXOs2dHBFUV3SbyAUBjfMVe+nkjh81
         wGVo8Dgmh62kbZbaEpOlFieMHjnez6N4gVG8ath4r8VmqqIGCe4miFqFz0FwYlerWWEO
         SLycQMtZtl/dm/PvF8Z+stQpBTUvqa5mlyuQ2R5DrA0jhKXmFW+xtqA18cIvSI55pty5
         /Y7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ilywJhTYf/dadLVHSO+f7RSY7OP4kxNg/tHVML94Wxs=;
        b=gHJma3+Y/kFady7jm3Iq6k1RROFqRS65T8rWwRHnicB3Yk7c7hpEUtUWCG54nBRyXb
         uroEKP1/S0SzwHxqUteDcn3h55jUACxlI1105X2N24lbdCpQDX9hhEfkRZFkgb64TE/O
         O80ZCBm9BfPIg5jO+YjvrvBMFXNwK3FSv7kCoIxGmxsiOquf1RbP5bFNeAZlDOTLdcr2
         xLkNZhFiC90FtnBh16LNyHRzyan59AVZngs5ezPZG+53lS6Jid9tqYnl/VaNmDtJ6RpT
         4HjZBpROP3M53C1BdeQGk+SceXXyYTOvpFghD465EdrX2IGRSaAoh9vs0Xhq9CQBiVNv
         Aq7Q==
X-Gm-Message-State: ACgBeo1ieJl6Rdkb4uyGLilIdKsyVL9apavRDmYULszabiZaLdC3aMFT
        2QqX2gcI2FDXYdqC306psrKFRaFabaKVGcsj07KmgV4x7/E=
X-Google-Smtp-Source: AA6agR4AQe+RGe+ayOo1U71lhlglHrJm3fkv1YgT8EmC6G7t50B9HPHG5EUI8UZK0lECljGHP/Phgu4QftrQmV2BiZo=
X-Received: by 2002:a67:b24b:0:b0:357:31a6:1767 with SMTP id
 s11-20020a67b24b000000b0035731a61767mr13765765vsh.29.1660231680570; Thu, 11
 Aug 2022 08:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-9-lsahlber@redhat.com>
 <87bksquchu.fsf@cjr.nz>
In-Reply-To: <87bksquchu.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 10:27:48 -0500
Message-ID: <CAH2r5mtwniWdW8Q1xVb6wBwVdgKstoO7DL=o_CKpyhn=hKDDyQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] cifs: don't unlock cifs_tcp_ses_lock in cached_dir_lease_break()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - I have merged this patch into patch1 to make it clearer

On Thu, Aug 11, 2022 at 8:37 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > Unlock it from the caller, which is also where the lock is taken.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cached_dir.c | 1 -
> >  fs/cifs/smb2misc.c   | 4 +++-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
