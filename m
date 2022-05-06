Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A05C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  6 May 2022 05:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiEFFip (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 May 2022 01:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241516AbiEFFio (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 May 2022 01:38:44 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6463AA4B
        for <linux-cifs@vger.kernel.org>; Thu,  5 May 2022 22:35:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i27so12383329ejd.9
        for <linux-cifs@vger.kernel.org>; Thu, 05 May 2022 22:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cd9kPbTL9j8D2DT9jMe8S8r7on0aTJL06Yy5MBtXKIE=;
        b=inG7JIF4p7G/cPA6PGkgl5bPFuvBTvEZ729KcB3uAFvJnL5cMhn3YL4VGDkCYav3BW
         0KmMo6X4HRm3dmk/DeCAabAFkKbsAePyA8B8aULvL042O6wkoFw9lci/spWi7Y4ZFT6m
         67z0tsXG7lAOcbV5EucoDI7MV1amRvMzVXZaqvVfXVliHGrOGKBRZgzFVlbeHYGe2yVU
         cMecvUtO9ONhZx8+/iT+1SOXsUt+68uCY0+Kpo5bbA5es+YSNI/tsD3VUJC1tt93ifA/
         5s8iKtwvYsdgP2fLeAjgjSHyBKcLkJrBqC9nmnPfPK35QivYQTFme4WakfmAxA7JpjGS
         RJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cd9kPbTL9j8D2DT9jMe8S8r7on0aTJL06Yy5MBtXKIE=;
        b=8FeiS48mTb1us4bbdI9dqVqJqtzDPBYDUOIysK4fu4hdMvnIKMN9QYW5cvqi6/FH0G
         FO+je10V21/g6UdHfNlF4XfsfoZ/fq8xXs41hv3A9Nka3Pij5BNMa0yPF0U+2OOMW4or
         m5u6m1XCjYqAOHfl2YnMbI21EisfE3bZMADEoGvjbM/LgeQTOqr6f1VWeGpi5GeEyem7
         tLi6h70UftTVShDRwxx0lKvDkZY+Zolv7KegLHyef77lo1dyvb7Epx30rvF1PESCmdgz
         Ca3G1ONirGKo27YYedzkehBgdZFvpbnMYfhYZDxRVuDiuQdBQUTZaV8vGXLM0TQYF4l0
         Cd8Q==
X-Gm-Message-State: AOAM530rsQjM2cluKzfjlQ1c/AZBzYSSTOlSMiHx5HjV7mbY4/owpWKV
        vEUMhWOpb9DgS3Ap5ZN61ZUDSeTJNn421SUUjkNy3bDnxrKLzw==
X-Google-Smtp-Source: ABdhPJxJj8jwwOxsysdhoT+xQRNVWvftvuXbeKogSGKWCJ7QXedkjj9HLW07B2psZQD62neBFzpF9OLHAZUtp1WwgeM=
X-Received: by 2002:a17:907:3f19:b0:6f5:6b2:9615 with SMTP id
 hq25-20020a1709073f1900b006f506b29615mr1494978ejc.659.1651815300387; Thu, 05
 May 2022 22:35:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220504224640.2865787-1-mmakassikis@freebox.fr> <CANFS6baVjD13+DyWOve2ng=dKdySBWkZxDtywGECnQ5yNYQFdQ@mail.gmail.com>
In-Reply-To: <CANFS6baVjD13+DyWOve2ng=dKdySBWkZxDtywGECnQ5yNYQFdQ@mail.gmail.com>
From:   Marios Makassikis <mmakassikis@freebox.fr>
Date:   Fri, 6 May 2022 07:34:48 +0200
Message-ID: <CAF6XXKX17-1D3YMyr_mdCC5nt-zy3fsBpQduVrWPxnLWcdYxDg@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: validate length in smb2_write()
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, May 6, 2022 at 1:42 AM Hyunchul Lee <hyc.lee@gmail.com> wrote:
>
> Hello Marios,
>
> 2022=EB=85=84 5=EC=9B=94 5=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 4:00, =
Marios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> >
> > The SMB2 Write packet contains data that is to be written
> > to a file or to a pipe. Depending on the client, there may
> > be padding between the header and the data field.
> > Currently, the length is validated only in the case padding
> > is present.
> >
> > Since the DataOffset field always points to the beginning
> > of the data, there is no need to have a special case for
> > padding. By removing this, the length is validated in both
> > cases.
> >
> > Additionally, fix the length check: DataOffset and Length
> > fields are relative to the SMB header start, while the packet
> > length returned by get_rfc1002_len() includes 4 additional
> > bytes.
> >
>
> get_rfc1002_len doesn't include additional 4 bytes.
> Can you check it again?
>

Hello Hyunchul, Namjae,

You are both right, v3 is not necessary. My confusion came from
looking at earlier code (without the changes to smb2_hdr) rather
than the latest tree.

Thanks for checking it.

Marios
