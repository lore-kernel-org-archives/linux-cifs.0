Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB7FC38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 06:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJ1Gv0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 02:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJ1GvH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 02:51:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AC3311
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 23:48:59 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k2so10821630ejr.2
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 23:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+8ARi2+LX6G6+XaZ70/KDk0kszqeePg7SQfaQ1kVMHA=;
        b=H8W6rLucnvRn9f7iNFB/CMMQ72GbNDQN76kUMiBAcC5N8IkeU8Jw93F/qrvmaGxo4Z
         BUHYJXqpuFusEPBp7IYubmFW9Y1QSthjqmrbPka2ASz/o8QhYKiIqoJPKnC4Me+hhZKK
         lih1mTmK9xraFzSIN+lMDitVQGTqgXJ3d7gS3xfxr9PewHmUhG5tEpbWSmhs/oKNibTk
         lAXvDm2hYTNCTZ2IcTFRMB90Ig+sf2mbvlh5j0VbveJtVlDkegr3UxEfsX7mrPS76PRt
         1HmXT4Gp2cEVu97lRcb/JB0/ZYpMcb+kSrovUheXkPd/Mw9dgpbw4G8qoGXJx4aPf0zX
         inGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+8ARi2+LX6G6+XaZ70/KDk0kszqeePg7SQfaQ1kVMHA=;
        b=wffh9MLqQxftLmkKtNsGeRyo5QezFwb3ite3q2XKXy3Ym53+8/xqLl1S6OeRLW+Ni2
         GZ+uV+uOUaY4uMYaxn3trFB/izPgYFOp6ZT2xx2B5BFDVc6WdIjEMfOFDcjkqmdIC7dE
         eBmf8n6P7qVVTCFHXE+nA8bvKBlxyV0B85QXPwHctPb3Jo6g/FVLc3PquHxfWm6mkFfb
         +veIfh5NAukZWQr1c+Xoj4nkLTMiaIwCt4dQwuYDoalmln91/XxF13F5ydqEbKQlvvuQ
         YR1tPwQOzLtHxPbp1vzLayJLQkWDzyD/dcV2z+MYcJHZ7dS6fxnUfW6ADRQGL1DFzJ+T
         2vEg==
X-Gm-Message-State: ACrzQf26xtTMtduRZkTnrAK0kBi/R4JNesq26io/MU2cNpxkNRMWFq8E
        u0MXLe7ty+7TyJH26uPWtVPDqhorLEPOjgN8nxtNP3t2
X-Google-Smtp-Source: AMsMyM41HDTUuPRYsqDSv/+LQVLi+LQ3PI81gV31n3Ipb7J3tlYNHgO6cvU8e6Vhn7+hT+Y7lsMC3CqQAxJ0dPih9hc=
X-Received: by 2002:a17:907:1de6:b0:7a5:ea4b:ddbb with SMTP id
 og38-20020a1709071de600b007a5ea4bddbbmr24600009ejc.757.1666939738067; Thu, 27
 Oct 2022 23:48:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
In-Reply-To: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 28 Oct 2022 16:48:45 +1000
Message-ID: <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
>
> If a mount to a server is using multichannel, an oplock break arriving
> on a secondary channel won't find the open file (since it won't find the
> tcon for it), and this will cause each oplock break on secondary channels
> to time out, slowing performance drastically.
>
> Fix smb2_is_valid_oplock_break so that if it is a secondary channel and
> an oplock break was not found, check for tcons (and the files hanging
> off the tcons) on the primary channel.

Does this also happen against windows or is is only against ksmbd this triggers?
What does MS-SMB2.pdf say about channels and oplocks?

>
> Fixes xfstest generic/013 to ksmbd
>
> Cc: <stable@vger.kernel.org>
>
>
> --
> Thanks,
>
> Steve
