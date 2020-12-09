Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C8BC4361B
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 22:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D9C23A22
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 22:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388238AbgLIWuw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388233AbgLIWuw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 17:50:52 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71654C0613D6
        for <linux-cifs@vger.kernel.org>; Wed,  9 Dec 2020 14:50:11 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a8so5425288lfb.3
        for <linux-cifs@vger.kernel.org>; Wed, 09 Dec 2020 14:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ptSptYftueuCeae7YWaWLt5Oq6bMz8GGDFxbXoZ804Q=;
        b=ZmlBzSAEyJwVfvGdA5RCBupW9stFgCdh2FSHlXyHXXl9t8OY4VrxS5i9UoUJofmMwU
         yCHII/s/eHx77dy1rNH9LV3ty77SkqZ2S0tmaFMcE6EkEUgCAofkr8NXX0bwGgRJKehh
         TMwRDIq/Nne61Y7RUpp0cTfFTsD6cc0QtYkqUdwoFD4f2fLMQ2S07ARbQApXrB8rVYoU
         2bf9dTuv6dFgFaue1VUIucs8fBZpcHjEsKM+cWPhFdPM+m2FUHgky0KD8pKyNqIjNGHj
         KMmBZ3DgO2kCVtqBiSbgZClaD4pjB4uD0lTxrjkuAUkzGc+KbBfYDIsj1jBbkcucavCP
         ER4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ptSptYftueuCeae7YWaWLt5Oq6bMz8GGDFxbXoZ804Q=;
        b=UZp+B1dyPwKWumLp3A0nA7eWukLo684JWlQ8avckQK8TUr+FXJzjbQcZ86C1ks7NAF
         JLbnpjC9LNVwzL5+JJcuU5n9GkM1hFtFQWH4CJQ6w+Aes8AqFZ27SUZ/fK1gK88Gx/Z2
         jBBSCRXCFpoOkFLi9Hd09SahFXGMVw2i7aluAwvoshTXPNcNtb4bbnlcsHyyD4NAasgY
         efOseaZqz3qSNz9aysPrhzhWYSok6L6l1uZ6FNy9QYGq0TZXfQqLa3+19s2XQsM90fFe
         5pj574HCopHzF2XR6qIdEIxfwx1VlHjMvfrXbli8WGg0uIDd2EnAYBPmA6cmRI8ud7Kw
         x0Jw==
X-Gm-Message-State: AOAM532Epr80Hgb+FfSM3IU+CTfCZ3/Plhm7U31VhLVxmPlDmGPq4xT4
        gB5F71VDsf9rWWBBimgLh8m1WRMTaTkZzW/uDfw=
X-Google-Smtp-Source: ABdhPJxECoaoChY/uAjuTfJ51//KiNmy38PxQMdK5jVZAF/AGv/bUl/hlAVsDm9wASyTCiJD5+E1GfN66EmFu0zdva0=
X-Received: by 2002:a19:6f01:: with SMTP id k1mr1044382lfc.184.1607554209893;
 Wed, 09 Dec 2020 14:50:09 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
 <CAKywueRMTMy7shp_qT3Cu6E1EZ0AwdSvjsWF=MU4KQWkw+YL-A@mail.gmail.com> <c885d7a2-4f41-d2c0-51ae-43e8ef9cc2d6@talpey.com>
In-Reply-To: <c885d7a2-4f41-d2c0-51ae-43e8ef9cc2d6@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 9 Dec 2020 16:49:58 -0600
Message-ID: <CAH2r5mtfAzgh4ojq3XxgmVwbU4YnD42O9=G+FqB9r=AqA=qihQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO
 info on negprot rsp
To:     Tom Talpey <tom@talpey.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Changed the comment in followon to:

-       /* Make sure that negotiate contexts start after gss security blob =
*/
+       /*
+        * if SPNEGO blob present (ie the RFC2478 GSS info which indicates
+        * wnich security mechanisms the server supports) make sure that
+        * the negotiate contexts start after it
+        */

On Wed, Dec 9, 2020 at 3:26 PM Tom Talpey <tom@talpey.com> wrote:
>
> The protocol allows omitting the SPNEGO blob altogether, btw. That
> leads to the client deciding how to authenticate, although the Windows
> server doesn't offer that.
>
> So I'd suggest removing the comment, too:
>
>  >> /* Make sure that negotiate contexts start after gss security blob */
>
>
> On 12/9/2020 12:39 PM, Pavel Shilovsky wrote:
> > Looks good.
> >
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=B2=D1=82, 8 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 23:23, Steve Fr=
ench <smfrench@gmail.com>:
> >>
> >> Azure does not send an SPNEGO blob in the negotiate protocol response,
> >> so we shouldn't assume that it is there when validating the location
> >> of the first negotiate context.  This avoids the potential confusing
> >> mount warning:
> >>
> >>     CIFS: Invalid negotiate context offset
> >>
> >> CC: Stable <stable@vger.kernel.org>
> >> Signed-off-by: Steve French <stfrench@microsoft.com>
> >> ---
> >>   fs/cifs/smb2misc.c | 11 +++++++----
> >>   1 file changed, 7 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> >> index d88e2683626e..513507e4c4ad 100644
> >> --- a/fs/cifs/smb2misc.c
> >> +++ b/fs/cifs/smb2misc.c
> >> @@ -109,11 +109,14 @@ static __u32 get_neg_ctxt_len(struct
> >> smb2_sync_hdr *hdr, __u32 len,
> >>
> >>    /* Make sure that negotiate contexts start after gss security blob =
*/
> >>    nc_offset =3D le32_to_cpu(pneg_rsp->NegotiateContextOffset);
> >> - if (nc_offset < non_ctxlen) {
> >> - pr_warn_once("Invalid negotiate context offset\n");
> >> + if (nc_offset + 1 < non_ctxlen) {
> >> + pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
> >>    return 0;
> >> - }
> >> - size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> >> + } else if (nc_offset + 1 =3D=3D non_ctxlen) {
> >> + cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
> >> + size_of_pad_before_neg_ctxts =3D 0;
> >> + } else
> >> + size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> >>
> >>    /* Verify that at least minimal negotiate contexts fit within frame=
 */
> >>    if (len < nc_offset + (neg_count * sizeof(struct smb2_neg_context))=
) {
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >



--=20
Thanks,

Steve
