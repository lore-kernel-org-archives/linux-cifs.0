Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D825EC433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Nov 2022 18:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbiKPS35 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Nov 2022 13:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiKPS3z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Nov 2022 13:29:55 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33162554CC
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 10:29:54 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z24so22963197ljn.4
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 10:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=77XAxebAqAyYMRUyAGlAPFj2TGmxkp7bESfvwt/Tuuw=;
        b=Ja6dYWT5y6u1fweLisiUvKCbgo3mSLr0bX/aGUpQ7jZ0SfWUytQ2wrGSltAXq+pF95
         +tNLir/3Szkp/vj+K+v/gAlzhjjikWjn5YOgQc+p/SX7zFvMIQMhEZLW2yRMMW3BO0bt
         1UuNHTkRbha9S5zZ4Zieh4qC8JvSmOJKZoJyh6fYa01EXp9LagEL1HhnjFpafz8MP0bO
         mFGjglR1hKlh44IiaOlb4luJ6iHLd2+wy1vR74UyfE7ebbemTpb0EDZXG224uNlVwiwm
         iwsX43XtucD8RbhEeUhdZ2MOnaGlDEfdgRrv1MumVxNgq22ErI6BZEJVbhueBmIfw3Md
         DpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=77XAxebAqAyYMRUyAGlAPFj2TGmxkp7bESfvwt/Tuuw=;
        b=FoNI84+8WUBf3T/O5U02miYXScKXYfgzYAFLhHbNvqByCFAbKPV7uO2ptNCY3QyyG4
         eIMrvnO/d+n2zQXK5aX29FiaebIrEnnZbQJ8Q81tC0dY1PHbgztoh1BhwwWUwqeXHtot
         gEC0R10MSYtfJCWAmNvL9x6TgD3Yg7W77wXN8tuknXBLsXCqM0rrsOqrkTOx73hxu9bv
         ECyqV3W+BVxFKaPFsMlSy3/YDALstu5oSSOKBjzGglxxyLQ2aT1ipqhwvCjfibBxDyNV
         qOi5gPL8eq/Z4qbttqGZGvfDJTW1xfuEeAsb5OuOHV1L6z5rYs3pLk4DlZiCFEDn3OHv
         0Scg==
X-Gm-Message-State: ANoB5pkaKxsUoVL0upEjyn+VGjGS3r58SJj3n2XcaRPSyBil2NwEDAKp
        CwcInJAqnlKAngCSRGmSmUJHcsnmupVU+qViL/U=
X-Google-Smtp-Source: AA0mqf75A6ArBLdkF4AmDh9po4MnZp8rDpfDM0un7FEUw3DM8zMVDcDpWZ8h3i6d0tBgWOYykunVZ5ke/DslnGiqdtU=
X-Received: by 2002:a2e:9853:0:b0:277:9e5:6cc4 with SMTP id
 e19-20020a2e9853000000b0027709e56cc4mr8817737ljj.137.1668623392463; Wed, 16
 Nov 2022 10:29:52 -0800 (PST)
MIME-Version: 1.0
References: <20221116131835.2192188-1-hch@lst.de>
In-Reply-To: <20221116131835.2192188-1-hch@lst.de>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Nov 2022 12:29:41 -0600
Message-ID: <CAH2r5msoMJ6jNFDtHigKOqq9EwxEb9buxGVi8duW8EMz6wwgBg@mail.gmail.com>
Subject: Re: RFC: remove cifs_writepage
To:     Christoph Hellwig <hch@lst.de>
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I can run some tests on this later this week.

On Wed, Nov 16, 2022 at 7:29 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Steve,
>
> this series tries to remove the ->writepage method from cifs, as there
> is no good reason for the method to exist anymore and we're trying to
> remove it entirely.
>
> The series is entirely untested as I don't have a CIFS setup at the
> moment, and patch 2 is a bit crude and there might be much better
> ways to handle the small wsize case.



-- 
Thanks,

Steve
