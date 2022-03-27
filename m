Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93004C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Mar 2022 00:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiC0Ax6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Mar 2022 20:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiC0Ax4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Mar 2022 20:53:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DBA673C9
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 17:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 771ADB8037A
        for <linux-cifs@vger.kernel.org>; Sun, 27 Mar 2022 00:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38300C340E8
        for <linux-cifs@vger.kernel.org>; Sun, 27 Mar 2022 00:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648342336;
        bh=5xo+mVaErFSczEF3Ep1uwonyO0XerUHyCr1ecssfSh8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=uiCp9jcmh55/kwVqtdzAlO/cka/EffsTeYBlICoTOJMwf5+Lxw937z0omAbhxtL1D
         bTt0POKBA8JIk7oFmiodv47Y7HwVgGl0GUYSI8cTCMDzVdZMkUUr3oDk/1+OY9kwOE
         n4jXKvypNR1+Kz9DSKvI1JXrHtlAE23UoMBxQ1HGWSHacMpKL/EQ0y96enYa4I4INl
         +EILveA5t/T9FMY3M8S8vU77yba+CPXMUgD84pDFuVANd0uVG+zwenQg1k6vDQJ6fD
         kEWGUZYJ0cIGDquIONfQ2rUosU0nTD0g3k6NqcnqkK4tE99HuWjb9syyEikHEyOKzT
         QWLGzedrdVtrA==
Received: by mail-wr1-f45.google.com with SMTP id w21so10959881wra.2
        for <linux-cifs@vger.kernel.org>; Sat, 26 Mar 2022 17:52:16 -0700 (PDT)
X-Gm-Message-State: AOAM5316ebI22iIb5ibJ/vCSjqDGm++jTiFtXIL6a8zCfcoja4AXkkun
        ZKPZOLkpI2jzi3PZG1tQobuGBijAa/cvIll/p3Q=
X-Google-Smtp-Source: ABdhPJzK9x+H8MsEbTPOZ8Va5fGiS7QZx5rGaiPMIWrjXptrht/6LoWsHDAffKs8HCDfD6slf44Xqljd837LyRaTwK8=
X-Received: by 2002:a05:6000:1184:b0:203:ff46:1d72 with SMTP id
 g4-20020a056000118400b00203ff461d72mr15575178wrx.165.1648342334447; Sat, 26
 Mar 2022 17:52:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Sat, 26 Mar 2022 17:52:13
 -0700 (PDT)
In-Reply-To: <CAH2r5mt0ZHuFoUcFKEgX6tejJ+xT9Y4zpYSEwYKSdGiROT6pZA@mail.gmail.com>
References: <CAH2r5muFUWGfK8LTrZA6wFD+XbG51RRM3dNyqEvA4B3mLiAkmA@mail.gmail.com>
 <CAH2r5mt0ZHuFoUcFKEgX6tejJ+xT9Y4zpYSEwYKSdGiROT6pZA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 27 Mar 2022 09:52:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_PEF7-_pf+AjoA-igO5e9nPaGgOepdeDTNHLsnz6413w@mail.gmail.com>
Message-ID: <CAKYAXd_PEF7-_pf+AjoA-igO5e9nPaGgOepdeDTNHLsnz6413w@mail.gmail.com>
Subject: Re: [PATCH][SMB3] move more protocol header definitions to fs/smbfs_common
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-27 2:59 GMT+09:00, Steve French <smfrench@gmail.com>:
> Updated the patch slightly to replace define that had Buffer[0] with
> Buffer[]
Minor nit, We can remove multiple blank lines in the patch.

CHECK: Please don't use multiple blank lines
#390: FILE: fs/smbfs_common/smb2pdu.h:1124:
+
+

Otherwise, Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
>
> On Sat, Mar 26, 2022 at 12:55 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Move defines for ioctl protocol header and various size to smbfs_common
>>
>> The definitions for the ioctl SMB3 request and response as well
>> as length of various fields defined in the protocol documentation
>> were duplicated in fs/ksmbd and fs/cifs.  Move these to the common
>> code in fs/smbfs_common/smb2pdu.h
>>
>> See attached
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Thanks,
>
> Steve
>
