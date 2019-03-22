Return-Path: <SRS0=7c9k=RZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D2CC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Mar 2019 16:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E6921900
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Mar 2019 16:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rmKBBqeA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfCVQCD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:02:03 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36467 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfCVQCD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Mar 2019 12:02:03 -0400
Received: by mail-pg1-f177.google.com with SMTP id r124so1826158pgr.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 Mar 2019 09:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uMV8HCRuvuU1IWsmgNujLYmlBVfqSK+3fZTwwKdtQ/g=;
        b=rmKBBqeAGpRioXo1LR/4OG38toxXZHHB0SUrQNjzoLfj3s0xDz5ugOQUCbAHrg/dO0
         8Hy6PmgGO2WqqZASGsmITB7MrGyfKwOhyuaZMfyDmVzWXuryoAywrwmbzrEVxyf7ac5d
         tfh9IpR2O+pOS6NSCfOedEmyStSpQLlJHNI+H5ztTLU0PvWSL51VhhAdf1DJikYLuO14
         P2p+Jlu5oalRUulG4hIvEz4u+lVg6tvO9RvMqhn/6TmTcl4G5WaeuKKm3Cwx+3OBBtNJ
         3QPjVaJd4rU4weNztPVVsXq9SInIgEgdH7Iu+AH/EsiiR+Lx1otZ9DqZ/bZRygz5RVX6
         m7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uMV8HCRuvuU1IWsmgNujLYmlBVfqSK+3fZTwwKdtQ/g=;
        b=TNwu4MDvq3/Ed0WDTHmheptroYt/yetHty83oZKUNUoSbya3QC8mN9TufUGI3oifm1
         nse1SSwwazX+gq6K0Gx3bmptDJR3ST+ht2aY5NXhrJQ4IecpNrd/QUoZiZLQ3QxyZK3N
         dovD01SVahuouFUdq8/wRbziWHqY0D5fLrHCEbKoJgYbYl17TaRzAlVEnxsF0utoiUSl
         9XyaZZfqqx3n72sj84tO+jPSOGRQ6ThJxQJrCjH2GkG1bKwj7mEMqKw8t142bDtHcrbP
         3u+OPX4iK1z/X4559682qGIfMkvkrs+PMyTBSpom7Rr3n66XvYLnM53WybkzAnNUl7By
         yOyg==
X-Gm-Message-State: APjAAAUWh8sxlSeGvScyDouv2AXzeD0b9Jk/P48/4VybLmIAimDxFppS
        3O+7iVKCbNv7QFnlr6z7TwLDOLFmDpxdrm1+Wky4UQ==
X-Google-Smtp-Source: APXvYqxHoT612BpRUlr4tCPJYGbNRuY2D7j+Hu6gbO0IqVP8CcLYhcHTcrXcmCxeeGQxaPLMBUU0uKIXuPFgwUf8eMQ=
X-Received: by 2002:a63:570d:: with SMTP id l13mr1913412pgb.55.1553270522073;
 Fri, 22 Mar 2019 09:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <599904512.8051095.1553257291511.JavaMail.zimbra@redhat.com> <280287391.8052131.1553257423805.JavaMail.zimbra@redhat.com>
In-Reply-To: <280287391.8052131.1553257423805.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 22 Mar 2019 11:01:50 -0500
Message-ID: <CAH2r5mvSnV-e+iFQf_FXNNBaX3ti3gAaiP5VB-0Lq3KCkYqyqw@mail.gmail.com>
Subject: Re: CIFS support preallocate partially
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

No preallocate is actually sent on the wire (other than creating the
file) in the example you tried.   Some servers do not support
preallocate - do you know the expected behavior on a local file system
that does not support preallocate whether it should 1) fail to create
the file and return an error or 2) succeed in creating the file (even
though couldn't preallocate the size).

Looking at the code I am surprised it is not returning an error
message though it looks like smb3_simple_falloc would return an
EOPNOTSUPP error (at least if allocating more than a few pages beyond
end of file)

On Fri, Mar 22, 2019 at 7:26 AM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hello,
>
> Use xfs_io to test preallocate. It returns successfuly. But it's a empty =
file. And doesn't allocate space.
>
> # mount //localhost/cifs  ~/cifs
> # xfs_io -f -c "resvsp 4 4" cifs/file
> # du -h cifs/file
> 0       cifs/file
>
>
> Test on xfs:
> # rm -rf file
> # xfs_io -f -c "resvsp 4 4" file
> # du -h file
> 4.0K    file
>
> Is it expected for cifs? I think the size should be a block size(1M for c=
ifs).
>
> Thanks.
>
> --
> Best regards!
> XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
>
> Red Hat Software (Beijing) Co.,Ltd
> filesystem-qe Team
> IRC:xifeng=EF=BC=8C#channel: fs-qe
> Tel:+86-10-8388112
> 9/F, Raycom



--=20
Thanks,

Steve
