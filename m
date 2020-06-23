Return-Path: <SRS0=n4et=AE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658ECC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 17:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBBA20780
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 17:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnQikyWS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbgFWRSC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Jun 2020 13:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732408AbgFWRSB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Jun 2020 13:18:01 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793E6C061573
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2020 10:18:01 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id d13so11245879ybk.8
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2020 10:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RFemzp4UW/aKjM+dbZN9+4MV1kFdlggi5yxdzMoMTao=;
        b=CnQikyWSl4ZZw8Sk5AKkhJAUS8xzII2aqx5/RoKtU6sVIxXPJZ3x1bN2ySXX21ekpK
         i9BEFeHZAvS/ck7DGSlALBaUrVHn+1dFEV1rX20FmkriLV1GMS2IR4UvoPMcReza0mox
         FnrE0B6j5l4IzezfWp8IBr0rmj18MNoXQKrtSrc8JhaqCr8Q4HFgf0cyGqlG7GWadHsQ
         49OmmfmsrjAjgnfPoT7Fa67S1/1lomY1q0RLfdyzHHxSI9mkBXRBIyLqnrPgvEs4bJBs
         qVCj+sXk1ohg03cqBxhhw0/6pWRjIXOsOuTXkZhpkoNAKjiYOE/z8uNlvHt1wwqOS8q/
         gCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RFemzp4UW/aKjM+dbZN9+4MV1kFdlggi5yxdzMoMTao=;
        b=CrGezyctmMxrPLDbghj5nkLRN6ZEaCRdn40rlFpHOGnWiyx+dJhZyIgOsr+fitwPOs
         VNMm52wDAEQiFJZiKGCamZrSAcePEfo/lcFB2FEzc3WHGBLe+f6b3tpZcIqLkG35lbjC
         hDKTBeLWyH7scYT80rUEfeTz/qjuf85GpE5auLv9eJIloFUuo+Y/iPIgmJCQzVRDqEvC
         WwFaG8WJR7fc1RHDE5/1IZ4MxHdtxBdKS+K3LVV9yp3dL4dDaUnWTUVAon8yab/OMnDm
         vZjwNNgnY3LlwEfGH3GPGUX048mmqdIrzSTDREaZ0W8PRdRcw5kC1SitA1t7Y5Rt9KWY
         E+qw==
X-Gm-Message-State: AOAM532ie8FY7SgeQ4J9txXmlDQevqtm4KtPMgw81G4nudVvVtCkjhPg
        2VG2tEfgfsVBkrLdKJ8xq3MD+yjUoKCARNXi89c=
X-Google-Smtp-Source: ABdhPJwz6yJgYNUMtZ017iy1zR2rcW/mdvME2h0s49B7GDdfYDN563cOyAMWZlaIBkt8IAj3cono42aURQuQSyh6XP4=
X-Received: by 2002:a25:3bd8:: with SMTP id i207mr36253402yba.167.1592932680276;
 Tue, 23 Jun 2020 10:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200623113154.2629513-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20200623113154.2629513-1-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Jun 2020 12:17:49 -0500
Message-ID: <CAH2r5muBJqRjkYcWsSH1c-BE2kHiTxPDcMdmNwEoVPmXxWmhEA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] cifs: Fix data insonsistent when fallocate
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged the four patches into cifs-2.6.git for-next and running tests now

FYI - the git commit ids referenced in the patch descriptions
(although they appear correct) are not in a form that checkpatch
recognizes.  I ignored that warning since the ids are correct.
Probably not worth changing but FYI for future patches.

Thx - these look helpful.   I will try to update the xfstesting
cifs.ko wiki page on Samba.org with the results ... there are probably
another 10+ xfstests we can add to the buildbot beyond these
(especially with modefromsid/idsfromsid and with swap over smb3 mounts
etc.).  There are also additional tests that could be enabled with
changesets to allow more fallocate options to be supported

On Tue, Jun 23, 2020 at 6:33 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> *** BLURB HERE ***
> v1->v2:
>   1. add fixes and cc:stable
>   2. punch hole fix address xfstests generic/316 failed
>
> Zhang Xiaoxu (2):
>   cifs/smb3: Fix data inconsistent when punch hole
>   cifs/smb3: Fix data inconsistent when zero file range
>
>  fs/cifs/smb2ops.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> --
> 2.25.4
>


-- 
Thanks,

Steve
