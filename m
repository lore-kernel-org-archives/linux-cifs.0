Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B1DC77B73
	for <linux-cifs@archiver.kernel.org>; Tue,  2 May 2023 05:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjEBF4J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 May 2023 01:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBF4I (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 May 2023 01:56:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037464206
        for <linux-cifs@vger.kernel.org>; Mon,  1 May 2023 22:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E3886188A
        for <linux-cifs@vger.kernel.org>; Tue,  2 May 2023 05:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3834C4339B
        for <linux-cifs@vger.kernel.org>; Tue,  2 May 2023 05:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683006966;
        bh=f6Fl2Ulp68fTeYXWhgX22P1f6deucPhQ1pDjoHJSGzw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=WH9C/ViNwXbidTdJPEj8UAHu6lmrZCFMgSJ8HtJlL3ruBasH4m8IFDsR/o41lWhpa
         UAPwdG7uioj8lMx2/IakyNs03GrQVaXE2JvPG1XidZFRcixhQRlox6D4p+2yDd4vLD
         Pum80l0iJti300cpqSkEYFG3XpiUQ08QVo8AjanJ6/cfcwNcBVRb+ac2l/pI7XFaTv
         Co3dJlYNnWw4LbgLvyrGckYICjJXpdQ6rUcKcv9jPzqdbGvmsc9Q2iBudSN75gKOoO
         qV9NfCoKibk6MYGxY+zZWPpqfECzEMl4mCtj6BJHab1Noa69bJUahPe226BdUHU+zn
         UeQSubOlOcI5Q==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-549f0b4606cso2513949eaf.2
        for <linux-cifs@vger.kernel.org>; Mon, 01 May 2023 22:56:05 -0700 (PDT)
X-Gm-Message-State: AC+VfDyhSngR4k7F/3KK+Clf5+OtdMr0uTyODsUOA/xLkTm9bHnEap66
        bYVEx5TTK2N4gbyk/pI/7jiGs+g/zKaYgVeu4xE=
X-Google-Smtp-Source: ACHHUZ5/bpbZ4Z8XoI0A/j81DWHIECIYiqyXxdKq043gIUtCyh+j53qTQc0MZqigQuqFVuB7R7bwIMsXP6AUIzo/g6M=
X-Received: by 2002:a4a:ea8f:0:b0:524:a1a9:f2b3 with SMTP id
 r15-20020a4aea8f000000b00524a1a9f2b3mr7413827ooh.8.1683006965202; Mon, 01 May
 2023 22:56:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1086:0:b0:4d3:d9bf:b562 with HTTP; Mon, 1 May 2023
 22:56:04 -0700 (PDT)
In-Reply-To: <CAH2r5msNirMEVz=B8fmZ83r7AwsMcM6hd+vSFcsVSB_=mHWHsA@mail.gmail.com>
References: <CAH2r5msNirMEVz=B8fmZ83r7AwsMcM6hd+vSFcsVSB_=mHWHsA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 2 May 2023 14:56:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_n5F25rhVRFo0zFe0pZ2JYPqYHombDKhPASG7dMxW7Ww@mail.gmail.com>
Message-ID: <CAKYAXd_n5F25rhVRFo0zFe0pZ2JYPqYHombDKhPASG7dMxW7Ww@mail.gmail.com>
Subject: Re: [PATCH][SMB3] correct definitions for app instance open contexts
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-01 12:26 GMT+09:00, Steve French <smfrench@gmail.com>:
> The name length was wrong for the structs:
>
>          SMB2_CREATE_APP_INSTANCE_ID
>          SMB2_CREATE_APP_INSTANCE_VERSION
>
> See attached.  Also moves these definitions to common code
> (fs/smbfs_common)
Looks good to me!
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
>
> --
> Thanks,
>
> Steve
>
