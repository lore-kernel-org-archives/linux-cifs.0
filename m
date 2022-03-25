Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B45C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Mar 2022 05:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345780AbiCYFtv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Mar 2022 01:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiCYFtt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Mar 2022 01:49:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD83115F
        for <linux-cifs@vger.kernel.org>; Thu, 24 Mar 2022 22:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 531C2B827D9
        for <linux-cifs@vger.kernel.org>; Fri, 25 Mar 2022 05:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A2DC340EE
        for <linux-cifs@vger.kernel.org>; Fri, 25 Mar 2022 05:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648187291;
        bh=q8Sm+cIiQRf2Va0NH64WDs9kj+p2mjlFAIMs+HkYNT0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jbnYSDjIfbc4Dzn/LqXh8uAQL9DZaW3nMB7IMSQ/Omp1WeCUof/m88HZ39ySkgKCV
         bH6RXwluWUwqwRuZMO2fJnKm2OpHjge4XplL1u0SYJWuDRY0NtvQLqMnLhw6//l5f9
         F+0VBSlwoZbidk8QBeJPKRHB7NvIA7uAioyekmYdtFeK66YXncFFreiwlLaZsSjiWw
         KA/4GDdfxGHqazXHIHmr0GraeR/sWdNdvhw6ugnlwHR5uUTj86vVjT8hawponygJR8
         +uVG1Drhwd8ZsLxT0wUqWQ+TAXNHGFp6HajlBhocNit8t85uPudv402ryY2OG4yNr1
         +j/LKhRHPq9+Q==
Received: by mail-wr1-f42.google.com with SMTP id w21so4844922wra.2
        for <linux-cifs@vger.kernel.org>; Thu, 24 Mar 2022 22:48:10 -0700 (PDT)
X-Gm-Message-State: AOAM531XURKT26xbB0/eIaCYWDDZsTljTkrvqDwEdCPENUp3JreHrWhQ
        xnOZdIpuY+5jClP54tARq3xQJhwuro7mkVTAbmk=
X-Google-Smtp-Source: ABdhPJyEjJsJ0mCDsNkyKEEAPtLI+GIqW5cYMh+Z1MIzkobGeGpzjlOFIK94T6/9P8AJrdJyDQ7DG+LDyF40vXFMpUA=
X-Received: by 2002:a05:6000:1184:b0:203:ff46:1d72 with SMTP id
 g4-20020a056000118400b00203ff461d72mr7599147wrx.165.1648187289236; Thu, 24
 Mar 2022 22:48:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Thu, 24 Mar 2022 22:48:08
 -0700 (PDT)
In-Reply-To: <CAH2r5msDEuUecVkm-Wikp19mbK7hyix0oRn+HJMOvKNsEhkDwQ@mail.gmail.com>
References: <CAH2r5msDEuUecVkm-Wikp19mbK7hyix0oRn+HJMOvKNsEhkDwQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 25 Mar 2022 14:48:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-wnuG+2wfqQD3SZ97=pabb2ZDcy3rn6yWku1OG1TYW0w@mail.gmail.com>
Message-ID: <CAKYAXd-wnuG+2wfqQD3SZ97=pabb2ZDcy3rn6yWku1OG1TYW0w@mail.gmail.com>
Subject: Re: [PATCH][smbfs_common] move various duplicated protocol header
 structures to smbfs_common
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-25 12:16 GMT+09:00, Steve French <smfrench@gmail.com>:
>     We have duplicated definitions for various SMB3 PDUs in
>     fs/ksmbd/smb2pdu.h and fs/cifs/smbpdu.h.  Some had already
>     been moved to fs/smbfs_common/smb2pdu.h but there are more
>     to move.
>
>     Move SMB3 definitions for
>     - error response
>     - query info request and response and various related protocol flags
>     - various lease handling flags and the create lease context
>
>     to smbfs_common/smb2pdu.h to reduce code duplication
>
> (see attached patch)
Looks good to me!

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
>
> --
> Thanks,
>
> Steve
>
