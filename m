Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A6DC38BE7
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 19:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E09D12080D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 19:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3bTx6Qj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgBXTpi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:45:38 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36683 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgBXTpi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Feb 2020 14:45:38 -0500
Received: by mail-lf1-f67.google.com with SMTP id f24so7696959lfh.3
        for <linux-cifs@vger.kernel.org>; Mon, 24 Feb 2020 11:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/9TL0IZOOljPUR42ALsKGMe5U6z+8SrTkhiZx0eZKeM=;
        b=Z3bTx6QjGIUqlqyGjF0LMqMZUHeNwhB4m+aGhVxdQNmBGoWwKLvjEM2CrH44D8x2TU
         RnTyEeoJGHsULeKNpp1YC1bECjOuJxdGXypi4ORizaxNMdn6iS97gFHrSd7VAcqV3rmv
         ed7g+cskt1msrf/ZkI1Kpav4bo1DMMU8nAvzDqETK2eGduuw1JFg1q1BKNFLygk05SiW
         Gw8H5pltbzMXJE/gl8ljTtgouDg8I8O6KyYdmwe+LOlEZHNqKWQGV1IR5PcsAEH7Ek5I
         mf9hPZ/S7msvJ2fkFtmjlx35Cy+HG/SUUlBPrsXrQB1Z7sxdn7BQAAFNQfPU/RepK5fN
         eLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/9TL0IZOOljPUR42ALsKGMe5U6z+8SrTkhiZx0eZKeM=;
        b=g96IATIP4XjaQ7HvBHXWqSNDGWhh3/yOPrvOVMXL2IhVMff+mFgD9HN6N1gPxxT9kZ
         P07JqCRP4FJLubrU+BTL/R4uxhadssc2PrdLM3KiviTzS2MVdRo3X05oUd6n1TfOIn12
         kCfCnLwZwSMf7QpgicWCdSnGWpdMCGS8WDugxk3RnxKyBMChmtTYSdKRuUIEqJSDz5Cb
         bc8qoBIckYi0ffIajYAYVa2IRGLMrlH0hg2VJhLfnr8XZIY6qvlrKYCjPID81SIUPH4W
         gjiBcm7uHhftUpfA98pOKGbipAzqxGaQFeV7PicxVV9jNob52wtTQfJxkhfswGTsWz9+
         LdrA==
X-Gm-Message-State: APjAAAWpR0owdGMJyp6e6TTm4Svkz9MB8lbho4GgaWgOD31jbm6l/36V
        dzQRW3PkFJ8Nb+8b82Kf2zNcLAowxs5v0dlQtfTl0CY=
X-Google-Smtp-Source: APXvYqyc1+HC4cPZenAQoDfmOB9an0TSs3qfUCYM0+/OuPamOw6kvegrzIZoaXquzVs7A/mbTJOiWan8dShA1j6B0NI=
X-Received: by 2002:ac2:434f:: with SMTP id o15mr10882084lfl.86.1582573534612;
 Mon, 24 Feb 2020 11:45:34 -0800 (PST)
MIME-Version: 1.0
References: <20200221101906.24023-1-aaptel@suse.com> <878sks5fv7.fsf@suse.com> <CAH2r5muBesAGGsraDLsnt9Kq1pqLqRg_kbRMEQCPj3HcsiT79A@mail.gmail.com>
In-Reply-To: <CAH2r5muBesAGGsraDLsnt9Kq1pqLqRg_kbRMEQCPj3HcsiT79A@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 24 Feb 2020 11:45:23 -0800
Message-ID: <CAKywueQQXd8EWD_5FE+VkerFdrC=sWXFtod3CMn6mCDtEYNr5Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix rename() by ensuring source handle opened with
 DELETE bit
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 24 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 09:25, Steve=
 French <smfrench@gmail.com>:
>
> merged into cifs-2.6.git for-next
>
> added cc:stable and fixed the commit id for the "Fixes"
>
> On Mon, Feb 24, 2020 at 6:28 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > Steve,
> >
> > Can you add this fixes tag if/when you merge this:
> >
> > Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle =
by path name")
> >

Looks good!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
