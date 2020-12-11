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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B75C4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Dec 2020 20:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C8723EF5
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Dec 2020 20:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405936AbgLKSie (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Dec 2020 13:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406076AbgLKSiF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Dec 2020 13:38:05 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA2C0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 10:37:24 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id jx16so13668731ejb.10
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 10:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rTPAw/K/xuEH3iDNwap1GJAbH9fiPkVXZWzyqk9MEOY=;
        b=RG8F79VEoDq7TC3TaaADY4VM1JocrKwne9CUuGlLmj5X4FWxDQLuFQzf2a8XKGsfYI
         hz8Sx3aPVoRpNM6OrzKCzwiiyoy7RmpGeq21VYaKhawD0L69ozx64ecWR3pmPp/DaD5J
         vrenKCM8JWG0ZbNC4xYXagJdm0E6i7wBndPtTfpp778ksC4kOOiXfHbdW7Ge9gWDHFbL
         eZb8Kl7r7qb7FqoSR7sWhbXRYZfz90O8H9P7BcJtjNdI7HOs6riIXBuEksSK7+qRK6nS
         /WHoyKZVWXE8Uuo4/aD/qEWaGA0ZVO4fjDpeVIxLmfhVECL8jloVTU+8Qt76XmuBOSNs
         2X3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rTPAw/K/xuEH3iDNwap1GJAbH9fiPkVXZWzyqk9MEOY=;
        b=hF/rLCIJ2Fk3Res8Wy+lNbGEwbNuPL1U2MckkIzZ1iShwn+x01rl3F6VVgFeubm4qF
         3pvLLiwiOkxip2wkfIyMwGaBBo3G5moXg9UFOw8CdxkHRV26HaOiiFqW0z1FPGU40dcw
         et4u1xzWrJfjcwxPZ1F+IJ/EbNe8GqIjp3zWSd7pvcDvucXUNhCORIxmDdMfEREEJzau
         DuanSE4SxpL2zpz9KKuB+ky7Uv6AGnHzCk+GWd5tu4HPQIOxSYCnN2CyEWrJjCBn5Phj
         EZKnd/0IIqgkED3gRolaAIhUHSiB5QxPknK5M2h7xZvQjSAMHzE4NguZ26p0FR7e9Z0s
         c0Vg==
X-Gm-Message-State: AOAM531hs0SwDx4njVw1U49/zceEtZBChbGdMqOXspjoYlThTA1HY8mP
        I+4Byts+s1ijYUsnqP7kY98D/1eaLNrpc8DWjw==
X-Google-Smtp-Source: ABdhPJxQcnzMvTvE3eu2Z+vPd++dMp+YL98DzowFfmFhdUESvXOWV4jpk5gZ+jUiPlwuWZm4Y4Y0D0g9tYc90ZpGi9I=
X-Received: by 2002:a17:906:c20f:: with SMTP id d15mr12165029ejz.341.1607711843598;
 Fri, 11 Dec 2020 10:37:23 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
 <CAKywueTTZkpnYDba_S4yRJ6UheU6f7fefA3XMoicG7RvmtfzOw@mail.gmail.com>
In-Reply-To: <CAKywueTTZkpnYDba_S4yRJ6UheU6f7fefA3XMoicG7RvmtfzOw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 11 Dec 2020 10:37:12 -0800
Message-ID: <CAKywueTjoTYLvswymsNNdaezFtGP0+Zqj3GNJV=Sz+pYfytjGA@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO
 info on negprot rsp
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 10 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 09:45, Pavel Shilo=
vsky <piastryyy@gmail.com>:
>
> =D0=B2=D1=82, 8 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 23:23, Steve Fren=
ch <smfrench@gmail.com>:
> >
> > Azure does not send an SPNEGO blob in the negotiate protocol response,
> > so we shouldn't assume that it is there when validating the location
> > of the first negotiate context.  This avoids the potential confusing
> > mount warning:
> >
> >    CIFS: Invalid negotiate context offset
> >
> > CC: Stable <stable@vger.kernel.org>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/smb2misc.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> > index d88e2683626e..513507e4c4ad 100644
> > --- a/fs/cifs/smb2misc.c
> > +++ b/fs/cifs/smb2misc.c
> > @@ -109,11 +109,14 @@ static __u32 get_neg_ctxt_len(struct
> > smb2_sync_hdr *hdr, __u32 len,
> >
> >   /* Make sure that negotiate contexts start after gss security blob */
> >   nc_offset =3D le32_to_cpu(pneg_rsp->NegotiateContextOffset);
> > - if (nc_offset < non_ctxlen) {
> > - pr_warn_once("Invalid negotiate context offset\n");
> > + if (nc_offset + 1 < non_ctxlen) {
> > + pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
> >   return 0;
> > - }
> > - size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> > + } else if (nc_offset + 1 =3D=3D non_ctxlen) {
> > + cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
> > + size_of_pad_before_neg_ctxts =3D 0;
> > + } else
> > + size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> >
>
> This seems missing "+1" in the line above (non_ctxlen is 1 byte bigger
> than the fix-sized area of the packet):
> size_of_pad_before_neg_ctxts =3D nc_offset + 1 - non_ctxlen;
>

It seems that +1 would be needed if there is no SPNEGO security blob
but negotiate context offset is padded for other reasons. In this case
non_ctxlen will account for 1 byte from the padding. The only way here
would be to do something like:

 size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen + (non_ctxlen
=3D=3D 65 ? 1 : 0);

--
Best regards,
Pavel Shilovsky
