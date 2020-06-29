Return-Path: <SRS0=t+Ft=AK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552C0C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 01:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 292BD20760
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 01:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZyWSNBWT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgF2Boe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Jun 2020 21:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgF2Boe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 Jun 2020 21:44:34 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C666C03E979
        for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2020 18:44:34 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id d13so7643609ybk.8
        for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2020 18:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zxVLG+5Sy4XBijldAAhiNFBSBENhbng8ggVK2VWnpok=;
        b=ZyWSNBWT/dBruZ7toT2nnzD44iG1UrBIKckZjngw1y8pQct06z+dzk6PI05VEJg5GY
         miTwF9DKMVbTl/fwRlDSN4hbUBb73OXTkZOPN9E3D966JGQM0a4WMrD20MiTh/yzLQcA
         Qn8xx4GxShgwbYuMpOs/NgEsPmGcfxoB7QzFLNsk4OVIMgcrvwTN/SMIRquMpLZQP45x
         zZngOeb6pscpwxGznm6aUcuKZEZnBjyCdGPIAK7AFDRDcqxMCYCo3+rtmraYpDYs3mqb
         rW5fkWfNaOzVEARyMWHewUunoedCN7C8sM/umSgbPwW5xDYs0evgeERkf5W2yA+MXOUP
         OqEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zxVLG+5Sy4XBijldAAhiNFBSBENhbng8ggVK2VWnpok=;
        b=oO+MU5T3E3Inw+1FfeFXy982QLDasbD+en/86eiy2UdDuzcXhkFIS/R8vFq/RBnBR+
         RUhuAuOsmILjhHySRxlPs7eA9L+VQj3fmxsO+7LXWg0Y51QIYP8Ptk3Trk+nwuEl+a8R
         GUA/JGA25JhdtaKsB7sXBGsVWPA0kKdiExlhk86s1d9vg4CyfMNU22q7ufTZiysOJfzu
         ArZQKcBMX/FTXG0plpDOQh4LNNDKTCOYiE6EB9NgduqAAzxOZw662VUKBUN//MdOmxEa
         wK9lEqTyKubCvbVw4l1F1QSX73ulnWky5jW7Kdx3rk5r7OV1GE0WobqU9Zc351UGZMM9
         2tsg==
X-Gm-Message-State: AOAM532eEe8W5xl+vpYHKBC+Q62qWYhucJcTg3ZdfzPQ1SNqaNCRIDRP
        rUWxLPK9RelAlNZE6af5QyIPypNQLYjodUKD/5htGLjwvk8=
X-Google-Smtp-Source: ABdhPJwVbD5//cBk/paDOkDGYaBqcX2VqnGvNznf7BqjtGKOBiO/PL3XICV25Rk72C4UA9eafg1Kyc3JoHp2Z5zA1UU=
X-Received: by 2002:a25:e41:: with SMTP id 62mr23520629ybo.91.1593395073613;
 Sun, 28 Jun 2020 18:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200626195809.429507-1-paul@darkrain42.org>
In-Reply-To: <20200626195809.429507-1-paul@darkrain42.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 28 Jun 2020 20:44:23 -0500
Message-ID: <CAH2r5mtLgvE=0R_d3oUPTvcB_O0e-j3WX91O8QrvMTGSN+bmFQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] Various fixes for multiuser SMB mounts
To:     Paul Aurich <paul@darkrain42.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

these and the two others (one from one) recently posted tentatively
merged into cifs-2.6.git for-next pending review and testing

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/5/builds/73

On Fri, Jun 26, 2020 at 3:07 PM Paul Aurich <paul@darkrain42.org> wrote:
>
> Ensure several mount parameters work properly on multiuser mounts for non-root
> users, and add the user ID / credentials user ID to the session output in
> DebugData.
>
> Note that the 'posix' fix is speculative, as I don't currently have a server
> instance that supports SMB2 posix extensions.
>
> Regards,
> ~Paul
>
>


-- 
Thanks,

Steve
