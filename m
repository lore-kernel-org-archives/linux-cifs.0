Return-Path: <SRS0=xrBw=D2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015F5C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 18:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76AFD2231B
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 18:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oj3bRW61"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgJSSQq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Oct 2020 14:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgJSSQp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Oct 2020 14:16:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EBFC0613CE
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 11:16:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p13so283105edi.7
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 11:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vHulYPg/748rjFMKTYFSBGdGv8ZOUnWHFNkXy9mqTOk=;
        b=oj3bRW61tFG3TliTOSYqJm8UHpOGH9r743Pb3YfQg+q+cYCkEtdl61HmDU9do0Uf88
         +pUpDFTIqRmJrLspUZa6C4WQrugajfNkbJL7IfkmPO5R6t1PPc8/+1GgPNDM2NqsLMeh
         V+IJPA6MCiMWhlCkw0r2TYMbhLvCVSlArOQHbZgoAlJqtpL93xTUY6u/BjB/CzLd2+8O
         ulzl63/Wo7I5725mYHQjJ9e/4/8Lzdon5QL/hNflzZrRkBg/4QjLuofP9VXYDY948PUP
         so160lqty2cKYn2O/UpreZ3UA1Dhw+xZfdiEWw28nBxvmw8bo7/PopfqFJRvNCOx9eMP
         jB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vHulYPg/748rjFMKTYFSBGdGv8ZOUnWHFNkXy9mqTOk=;
        b=Axf6TY22yPkGgdfhtUjDkRXD9jWMtUELkGyE9rA1bMPzYg/L6AVxiIHcYBtJwCxY3/
         XcIh4HQeZ6o9katrGk5YiN9Euyp9Xg+e16wL6erdsSpnxHkB7GPcyJYxPZkwODSHfVv9
         NfzRPw3LXLPes7L18PQpU651vwn6aVN/5jjDuuSKO9KL0SLNSHsaEqCR7wqugFdqDH2I
         rRNRkM/bj2eOEaD0oUOtNBXxMw0aViylJ5N0XyLSEpglM9J04kPTLBXklhSDOeriKl1i
         r5pw/6UE/v+eFErFwzUQrNbEQ2KaYeLLVc0an5jNd2hLtzDQviqw8/zQqQRURDC6UXpO
         eSOg==
X-Gm-Message-State: AOAM5320xbC2RVY6q83LuQLFecqhhuPo/Y6/PCB4r/OOQSrFojBeHhQK
        r91fX03FRbdmtr7XcwrRega8j3U1V6d488wD+g==
X-Google-Smtp-Source: ABdhPJxFVVPOKyr4ibSDhmgrzqzNwNIU3kL6eiRw+4Pan5n7dfgF1aW9p1/JfhMN1J8oZVODQYjKTuqkvpmqhawmvDg=
X-Received: by 2002:aa7:c68b:: with SMTP id n11mr1069635edq.340.1603131403876;
 Mon, 19 Oct 2020 11:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv_0rLQF=npjc4CVJBDhsc8Eu_sJtY6xUDbBXs7aYhSzA@mail.gmail.com>
In-Reply-To: <CAH2r5mv_0rLQF=npjc4CVJBDhsc8Eu_sJtY6xUDbBXs7aYhSzA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 19 Oct 2020 11:16:32 -0700
Message-ID: <CAKywueStnU8uL-6oVV_QE=yBpHxfW7vUVsCfazQAQm0-H8ci0w@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] do not fail if no encryption required when
 server doesn't support encryption
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for fixing this!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky

=D1=81=D0=B1, 17 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 02:03, Steve Frenc=
h <smfrench@gmail.com>:
>
>     There are cases where the server can return a cipher type of 0 and
>     it not be an error. For example, if server only supported AES256_CCM
>     (very unlikely) or server supported no encryption types or
>     had all disabled. In those cases encryption would not be supported,
>     but that can be ok if the client did not require encryption on mount.
>
>     In the case in which mount requested encryption ("seal" on mount)
>     then checks later on during tree connection will return the proper
>     rc, but if seal was not requested by client, since server is allowed
>     to return 0 to indicate no supported cipher, we should not fail mount=
.
>
>     Reported-by: Pavel Shilovsky <pshilov@microsoft.com>
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
>
> --
> Thanks,
>
> Steve
