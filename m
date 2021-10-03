Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F6EC433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 23:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB94D60FC3
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 23:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhJCXjv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Oct 2021 19:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhJCXjv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Oct 2021 19:39:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568F9C0613EC
        for <linux-cifs@vger.kernel.org>; Sun,  3 Oct 2021 16:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=gdtqmiy5EVTruSZGOMg9GPwiahSeithDSvFBEsQLsmg=; b=TCR0mtMrBZnTNlFm1vZKQ876Hq
        tN/SQQr+0q/4/3aT05SKpTfKVk0kzaWOz3dzM7Iufy4znHox/u6TwU0mvm2yQhtg/NeHBXdXwSOsX
        6AB03f9jt03/40OdKlmn9PjkcUU7lOaVNMOtCgR9NJ2cpCofHU0XqhBp2xTz/hAkU9oF2Jamrl0yi
        l5URQBp5dJkR4B6eGwi9y5z38UEP06Ecu/84UXL9ryynIVGoUq5cMgNfbbjkQ5gsA3iOYxj+g32Cg
        00bJHWVwARWEFuQMiy22wTzuv4HtutzBGeXTVzy+PoxeWBpnresMKtRcudlWr/gGdJCyirGcBicmF
        enOyQCP5rsPV/2xtm6j6/QGHw/yI26Fkyu3hu74EKtxWlMHEDcZNPnpz9iBs+C0lMJiaMdv8eimvv
        3FKt/2nWvIRWX1Mr/YD0sXW1VO1cc9sYLVPKzlSIwE4CEjI13OAIi5idFA/f+8TSDLDJuEi82jFGm
        Ngy2s8JnZypcLFC18Bmfqnmc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXB3O-001N8c-Cy; Sun, 03 Oct 2021 23:37:58 +0000
Date:   Sun, 3 Oct 2021 16:37:54 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Ralph Boehme <slow@samba.org>, linux-cifs@vger.kernel.org,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: Re: [PATCH v5 13/20] ksmbd: remove ksmbd_verify_smb_message()
Message-ID: <YVo+0tjUiVPySJ1H@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-14-slow@samba.org>
 <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Oct 02, 2021 at 02:46:16PM +0900, Namjae Jeon wrote:

>smb1 negotiate is needed for windows connection. Have you tested with
>windows client ?

Isn't this only needed for Win7 upgrading a connection from
SMB1 -> SMB2 on initial connect. I don't think Win8 and above
need this.

Is this as far back as we want to support ?
