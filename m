Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E540C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 04:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4580660EDF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 04:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhIUEse (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 00:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhIUEse (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 00:48:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CEFA61100
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 04:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632199626;
        bh=t68agCg100NBjeR/VnAJCHadMXdP6+AbcWPin8dd0XM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=t1ErGrQqy3Fl/tURzejl7irv8nXcqf1u4pK9M4iUpECVbuK69XYHbhXVhxfCTLRMW
         cNtBOmh3R4ypzF9R3CJ+B81MgkFqqun5oQ+64SpqCdTmjMdvDSYsj8SzDZ1NvwPSy+
         MUxY3mc0LTg1Vp8uZxabuXWMxPt/WHclsN7i7WGhhFKebSWD5NhjmWkuaJhnAg2D24
         4VuY5b3ToohE7+WzV3NF7sEPU+MYWXVHutk/WUelVOmEGlceaOKaI73O7CrtOzWDMU
         OMBIXtpTM7OR4qJvwhEhW1cENRZso0fj1qqT/xofq54DfUwKvGRzcT7ICR9QtzHG8+
         T69nZHDYOOYRg==
Received: by mail-ot1-f45.google.com with SMTP id 77-20020a9d0ed3000000b00546e10e6699so15583621otj.2
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 21:47:06 -0700 (PDT)
X-Gm-Message-State: AOAM530BM+oUfD91BAc7ecss7tJXr2ui01jPmQhO5+HB0jrwwnRACuv8
        1OS3t6OkNYslyj2n0LuXJvz8f8BP90b47dvr/wc=
X-Google-Smtp-Source: ABdhPJyHJo0JenrAsHnUelU6Ru0Aq8Q6zdyL4KxZxad9EhUx7raeCdb0tMq0P+JK2cnpDv1ouwjO7OtGr/Gr5UHiCn0=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr7302357otf.237.1632199625729;
 Mon, 20 Sep 2021 21:47:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 20 Sep 2021 21:47:05
 -0700 (PDT)
In-Reply-To: <CAN05THTGgqcDQJAqf_PVNz=Wj_fH297ATEfmx3bzN3oyTLJqkw@mail.gmail.com>
References: <CAN05THTGgqcDQJAqf_PVNz=Wj_fH297ATEfmx3bzN3oyTLJqkw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 13:47:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8uEpkPCcGM-kxD4JSP9g73E+nLF8bLFDmTG37rWFgK9A@mail.gmail.com>
Message-ID: <CAKYAXd8uEpkPCcGM-kxD4JSP9g73E+nLF8bLFDmTG37rWFgK9A@mail.gmail.com>
Subject: Re: ksmbd_smb_request can be removed
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 12:49 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> In smb_common.c you have this function :   ksmbd_smb_request() which
> is called from connection.c once you have read the initial 4 bytes for
> the next length+smb2 blob.
>
> It checks the first byte of this 4 byte preamble for valid values,
> i.e. a NETBIOSoverTCP SESSION_MESSAGE or a SESSION_KEEP_ALIVE.
>
> We don't need to check this for ksmbd since it only implements SMB2
> over TCP port 445.
> The netbios stuff was only used in very old servers when SMB ran over
> TCP port 139.
> Now that we run over TCP port 445, this is actually not a NB header anymore
> and you can just treat it as a 4 byte length field that must be less
> than 16Mbyte.
>
> I.e. you can change it to just be :
> bool ksmbd_smb_request(struct ksmbd_conn *conn)
> {
>     return conn->request_buf[0] == 0;
> }
>
> and remove the references to the RFC1002 constants that no longer applies.
>
> (See MS-SMB2 2.1)
Okay, Thanks for your review, I will fix it.
Thanks!
>
