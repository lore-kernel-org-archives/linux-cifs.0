Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5511C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 10:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A434161207
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 10:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhKJK3y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 05:29:54 -0500
Received: from mx.cjr.nz ([51.158.111.142]:37852 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhKJK3w (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Nov 2021 05:29:52 -0500
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2021 05:29:51 EST
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D59BD7FC02;
        Wed, 10 Nov 2021 10:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1636539500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFN1oe9EaSgwRFoyIyaMNRliGqCLt7YMoBJz0iVSODs=;
        b=bHSzBcCHWHYy1SoaQ96IIf4lnQIm/uhs+rywXta5Iv4fmPSFgdO7GsFK0OQ3MuCol4x8pe
        xqIfCublKL1reTOWn4rPuHpskBX67ZpyKTja79YCIc7D2erusez8vTvJdnxl2oDMEOGtes
        C2Xsve18yZCe+msRBWny9bK5gYk4onrw/j/x5KQC9+re6y36Y3DGe4KyRaoOTZ2LDe1y+R
        W8ao6wz8pNFfih3PTjzZrLZYlCyHOAvpzah6mqwPViYA7yn9u+cBABwgo2TplM4+Ejcx+n
        VibqnR6TBscAtuUt5CTELphtlib+RM3IedCyY/DT34uBrPqVK160xFDc5Pvq3g==
Date:   Wed, 10 Nov 2021 07:18:11 -0300
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: patch to removing minor DFS compile warnings
In-Reply-To: <CAH2r5mtcGWchWxk8S7MCJa6zsuJZy6bxuwX7SeGm5K7MTT59cw@mail.gmail.com>
References: <CAH2r5mtcGWchWxk8S7MCJa6zsuJZy6bxuwX7SeGm5K7MTT59cw@mail.gmail.com>
Message-ID: <1587EE2B-06AA-4DD5-918E-127A9FAA70D0@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On November 10, 2021 6:14:24 AM GMT-03:00, Steve French <smfrench@gmail=2Ec=
om> wrote:
>  CHECK   /home/smfrench/cifs-2=2E6/fs/cifs/connect=2Ec
>/home/smfrench/cifs-2=2E6/fs/cifs/connect=2Ec:4137:5: warning: symbol
>'__tree_connect_dfs_target' was not declared=2E Should it be static?
>/home/smfrench/cifs-2=2E6/fs/cifs/connect=2Ec:4236:5: warning: symbol
>'tree_connect_dfs_target' was not declared=2E Should it be static?
>
>
>--
>Thanks,
>
>Steve

looks good=2E  thx=2E
