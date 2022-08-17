Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA76C32772
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Aug 2022 19:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbiHQTdF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241579AbiHQTch (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Aug 2022 15:32:37 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F6DA59A0
        for <linux-cifs@vger.kernel.org>; Wed, 17 Aug 2022 12:31:50 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id 67so14157886vsv.2
        for <linux-cifs@vger.kernel.org>; Wed, 17 Aug 2022 12:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aVRH2fPH0vzaAO/Gh7suh8W+U70pmd1XAjtLFnBaX7o=;
        b=W0earXwqL3shmLph+ygU63vtk1RwiNmrp8yX5PGBtYuONpJfMfkOuvuG4vUIvESzLM
         fdvPFllAlNwv1YbKkC0BHYoAsh4Q82NQ2r5UZCWd5Birv8ybdKuvhBaU4jU7gTHi55pP
         pmzWEBzVVPu682HIHDvaqeHJr6gdGnT5hKCfjDnJsRWV98By7ShK6/3ymMTbch8pAdXs
         CSicyB+U1PQaMRH8FhsyQPvsRIpsIR5Mgtj1MxPdUASDtrxwyZL5Q5cd+S2eogQWPJ7a
         Qak/vGRKb2fUENampYDgQXwsOn0AhHJOezAD8A8HOQgqCBZ3DodeJtbk2Ratxt9DLLRL
         WP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aVRH2fPH0vzaAO/Gh7suh8W+U70pmd1XAjtLFnBaX7o=;
        b=Z+dwpEEnEIEKCiq0dODr2iUrYbPYJOe6ILfI2We9HJHU7HCi38K3UXXUNEq/sAVdQa
         yGAYRfZEYu36xWBbP3GwECXI6DDTdFKiN2j//K4bKQuYqCl72Lsftd4tcIVR9YR8YJNC
         ryp/U+9sIqPIqMbHXRBvuD4i6PWJzv6E8/ALgzTt1trkUyMybEuRouWY8wILQtixCzzh
         L+MuOhJXiXqqO1wbSZ6XWb8SoAYZrbRSHDarqK5C35/QUBFG0A0nKN2sX4Lz/jLK6qPN
         gRVP0XMG7ewo1oPj9YDfTkhSsMh/5pNlA//03Rjs+GF/Z0XSQHxyLdlRNBwwJ2l19NPn
         rx7g==
X-Gm-Message-State: ACgBeo3hLy/dUjCoZOwzYJ89u8H/fscuq7Vhmo49a8Cz8LC+xJe7jVy9
        ZneEH8+cmIC0qZkkdC82sK3y1WQEiOtapxWH8nDlFdDkRPI=
X-Google-Smtp-Source: AA6agR7ZXmOwtwgJU67e/VfVU17KZ30JpK8V3ljugF7jVEdjJGvjLPW2KgH0EysgrKeUgYOIb5o8p1JXpK4TZZLBQGM=
X-Received: by 2002:a67:ce90:0:b0:388:4905:1533 with SMTP id
 c16-20020a67ce90000000b0038849051533mr12037876vse.17.1660764700792; Wed, 17
 Aug 2022 12:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220817171402.7984-1-ematsumiya@suse.de> <87wnb67lcg.fsf@cjr.nz>
In-Reply-To: <87wnb67lcg.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 Aug 2022 14:31:29 -0500
Message-ID: <CAH2r5mt6QuADNGZffvdSzod7zd=4m2S2tsrjbPAB2YM+bdHi-w@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove unused server parameter from calc_smb_size()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated with RB tag and pushed to cifs-2.6.git for-next

On Wed, Aug 17, 2022 at 1:53 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Enzo Matsumiya <ematsumiya@suse.de> writes:
>
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/cifs/cifs_debug.c | 2 +-
> >  fs/cifs/cifsglob.h   | 2 +-
> >  fs/cifs/cifsproto.h  | 2 +-
> >  fs/cifs/misc.c       | 2 +-
> >  fs/cifs/netmisc.c    | 2 +-
> >  fs/cifs/readdir.c    | 6 ++----
> >  fs/cifs/smb2misc.c   | 4 ++--
> >  fs/cifs/smb2ops.c    | 2 +-
> >  fs/cifs/smb2proto.h  | 2 +-
> >  9 files changed, 11 insertions(+), 13 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
