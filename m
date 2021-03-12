Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F6DC433E6
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Mar 2021 07:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D90C64F80
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Mar 2021 07:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhCLHVg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhCLHVS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Mar 2021 02:21:18 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41092C061574
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 23:21:18 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id z8so5481721ljm.12
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 23:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=cpUoI+OYnumiPSweeagOBR2ad8cYqHknwPhflh8VZbY=;
        b=rZn2eLQwhkVWJFq5cjOk+Upwl7s+uFm/w27kdPWJOWl3LVxTb67ogFk1phGBsFuMuY
         1KaWJSnFU25NC7X3w4/uywqGUcFZhuu8H0UpR3S5nJ8BI6lXD5CI6FZ3RfVR1utSGdn3
         hyym5u6vs+jy3m+kyzmesiq/Tdn4UE6mU40gWBebQ2JKT0QlSnp9slxvY8FO/DinROXj
         Fvwo2PpswsTG9UtkHvtW1L9I2tjqgk7GF/sPg/x0eHeUhP7+NdZs+llz5EUUc0jaVAaX
         2y3O1e6SbUvbbJ/mmh/nFfqM6iuvLjZkQ1/ukCqtgoDHy7hyaB1s1r5b5gmUqJYyhlVq
         XEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=cpUoI+OYnumiPSweeagOBR2ad8cYqHknwPhflh8VZbY=;
        b=NnA0/asSKGqBimsdr7kJFrcdoAGqUZFsYgTEtGPl2YLrkJAXONe0TIZxCYF3Nioum1
         zd8wuhinpDGJEzTWfth55T6RVnBFH6UWGTG/w78wlHOi27jnYUo4D5zTjf42JtvTAkfM
         WJhKUHPaeo+J372QtxsM53PSaUSpzcMeMirKHm+e2vpeOd8m/Hu0bxN/rTOiLI8k7qkP
         aBlKAR4itY579KHjWut0xB87g/+TSucrUhC+UToVHwwFt8M6AqR+/ayGOuspHEaKLfp+
         MGfglTDrsvLdhs5P4UjcolMJ3KsWBUAGqThSjW22qsNumY4dx+z2ndf08JPD8RwCUgNv
         ww/g==
X-Gm-Message-State: AOAM531+55XkEX59v4CES1Xgn7m52w53fJPHlRARfXt17w0qEo6McmBq
        jmrh8bdu5Tdu2yhdomwbDqYsgK31EbThCr7EWb4=
X-Google-Smtp-Source: ABdhPJww0RnUiKlgdfK2/M8H4H1k9zccOABgyxws15X4PsTtNDU7JZ8cbBN+LqiR65RH5l4ulpdbr/3Qyyn/0hDblpk=
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr1559915ljp.406.1615533676749;
 Thu, 11 Mar 2021 23:21:16 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mv4nqpw2PoCsX_oJ=gJg-cbS9a3LtSyzv5Wq3obFOaTfQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv4nqpw2PoCsX_oJ=gJg-cbS9a3LtSyzv5Wq3obFOaTfQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Mar 2021 01:21:05 -0600
Message-ID: <CAH2r5mu318U6EQWyGdA1du_mP8jpL7pziC_jicFci_b8eZ3iiw@mail.gmail.com>
Subject: Re: Testing to current ksmbd from cifs.ko
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Turned out to be an obvious problem but with a confusing return code.

The shares being exported (specified in /etc/ksmbd/smb.conf) pointed
to directories in /mnt ... but that mount parm had been reset and was
empty.   I recreated /mnt/test and /mnt/scratch and it works now.
False alarm (other than the return code is confusing)

On Fri, Mar 12, 2021 at 12:54 AM Steve French <smfrench@gmail.com> wrote:
>
> I see a "STATUS_INVALID_PARAMETER" returned on tree connect from
> cifs.ko mounts (current 5.12-rc2 equivalent of cifs.ko running on
> 5.11) to current ksmbd (on 5.12).  Here is the relevant dynamic trace
> entries:
>
>       mount.cifs-20747   [002] .... 40007.155508: smb3_cmd_enter:
>  sid=3D0x2 tid=3D0x0 cmd=3D3 mid=3D4
>            cifsd-20754   [001] .... 40007.156752: smb3_add_credits:
> conn_id=3D0xf server=3D10.0.0.0 {xN_FS_FREh\Nuse_dela=D8=BE\~ current_mid=
=3D5
> credits=3D127 credit_change=3D33 in_flight=3D0
>       mount.cifs-20747   [002] .... 40007.156969: smb3_cmd_err:
>  sid=3D0x2 tid=3D0x0 cmd=3D3 mid=3D4 status=3D0xc000000d rc=3D-22
>
> The wireshark trace shows very similar tree connects.  The first to
> IPC$ which succeeds and the second which fails to the test share.
>
> Ideas?
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
