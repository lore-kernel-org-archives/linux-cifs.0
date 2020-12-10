Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4205CC433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 17:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF55F23E1D
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 17:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392917AbgLJRq5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Dec 2020 12:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392872AbgLJRqr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Dec 2020 12:46:47 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3E4C0613CF
        for <linux-cifs@vger.kernel.org>; Thu, 10 Dec 2020 09:46:05 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id a16so8532479ejj.5
        for <linux-cifs@vger.kernel.org>; Thu, 10 Dec 2020 09:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5vBmtobDEcskaRw6HxE2knT66tafarI9dXzIwy0s4Q4=;
        b=jPSkV6MhxpKhHBHrasTPckES6CorJBqbTUp4nvAjJO00XsB5BFv8ub9JD0ubjBFiUl
         6EWg2I5bPHl1454NyrE+tHy/4JYU7p4Gppkg0aZAJ15PYi/0d9Ufcg3DTRh3oJI0wwOt
         pyjkUIDSyBsmzVsFdUNe3wHblza3qWVbfxRK8VikvLZp71i/3McQUtSHmGrZ8+46aCFl
         aluoBPYpKYZmhSKZ4bpIxdCpUS2c91p2fg5LfSCR8EtLE8gSyHYZeF+XIkr0cDvphQWW
         w2JZAwg2T36dyZnG9R2DwOb8pnp9J8RGjvpcGmjO5wHKXaiqj0P5zPd2Z9beCTUsX4bB
         79TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5vBmtobDEcskaRw6HxE2knT66tafarI9dXzIwy0s4Q4=;
        b=gDnP38JjojL0Sfx1oWT4+3Ao0a3q3fe0JbVvtFkFR/EoPxakgLaNtr+K2JBmiiH6g+
         kh7ruqvSdmcSnRhdrtab7VV5eXKfwDGyESJQdoFe4A6qRJt+pxNpMX1VLRnpqooRwWoM
         J2jV7zQIZLgbtPn2dYSRSMiMfNLn1OE6UTmHEyVXiW0LHUyf4hpODEB9LjSRaNB7gx0l
         emjILrwu1rfFYZM/vbUZZXGKaN+zyq1lU6XozecPlE2cL5jmFo2/heQm9ziziSkjRND4
         PPsAfZ/htnGdvBEUZnxwePFoyiIJg6P44dXa92SZa9VTezbMouVCVI5c+NxN/97PFueL
         spXQ==
X-Gm-Message-State: AOAM530qLxLQ36obKXUaLiPjDofo1zrtKbaTLWaTL6xx2CvrgKlPXZtM
        V88aDyN4id4Kc0R1eEEMC0J6B9+CNoV70kYvUg==
X-Google-Smtp-Source: ABdhPJwVIfEwHZrSoA7BhUzQiU9yUJGEsOq6LLX7yXxJiaYVMHateN2bBEIh92n9tyDRbeKfQeoXVwKqURWSMPPTMYM=
X-Received: by 2002:a17:906:3381:: with SMTP id v1mr7539453eja.280.1607622363832;
 Thu, 10 Dec 2020 09:46:03 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
In-Reply-To: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 10 Dec 2020 09:45:52 -0800
Message-ID: <CAKywueTTZkpnYDba_S4yRJ6UheU6f7fefA3XMoicG7RvmtfzOw@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO
 info on negprot rsp
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 8 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 23:23, Steve French=
 <smfrench@gmail.com>:
>
> Azure does not send an SPNEGO blob in the negotiate protocol response,
> so we shouldn't assume that it is there when validating the location
> of the first negotiate context.  This avoids the potential confusing
> mount warning:
>
>    CIFS: Invalid negotiate context offset
>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/smb2misc.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index d88e2683626e..513507e4c4ad 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -109,11 +109,14 @@ static __u32 get_neg_ctxt_len(struct
> smb2_sync_hdr *hdr, __u32 len,
>
>   /* Make sure that negotiate contexts start after gss security blob */
>   nc_offset =3D le32_to_cpu(pneg_rsp->NegotiateContextOffset);
> - if (nc_offset < non_ctxlen) {
> - pr_warn_once("Invalid negotiate context offset\n");
> + if (nc_offset + 1 < non_ctxlen) {
> + pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
>   return 0;
> - }
> - size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> + } else if (nc_offset + 1 =3D=3D non_ctxlen) {
> + cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
> + size_of_pad_before_neg_ctxts =3D 0;
> + } else
> + size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
>

This seems missing "+1" in the line above (non_ctxlen is 1 byte bigger
than the fix-sized area of the packet):
size_of_pad_before_neg_ctxts =3D nc_offset + 1 - non_ctxlen;

--
Best regards,
Pavel Shilovsky
