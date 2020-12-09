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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C931C433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 17:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EA4C20684
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 17:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgLIRkM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732900AbgLIRkL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 12:40:11 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9ACC0613CF
        for <linux-cifs@vger.kernel.org>; Wed,  9 Dec 2020 09:39:30 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id n26so3331420eju.6
        for <linux-cifs@vger.kernel.org>; Wed, 09 Dec 2020 09:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q7Ha7Ai0GtbIXjarA/YCW+GRsgsN4GzMTN/f+D1Jbb4=;
        b=cbaDQlBIJfgZ7zYpQen6a/qzOQqT+HAaebd5mz4j4T8TxXKRDN/BMafkhvnLHXxvTl
         Aq3DHLbCbn9vQU+L30EN7oQPrlD5OPvHHE3O7wzbasrmkgpq2KYVeuts+Qle/iSeNOxs
         Y0iluqmlkXAJWP8TwFYtmNDTprMFCDCsb79GO9KNZB7M0iBi0tROfuZJ3LiPZ3czgdLU
         iu9nDZvMNCeQeTLN0cZoQ0HLzMpNIjUZQz4JLuCEHVZ2UpQ2Viw8YCIdjrmDiVXAsteC
         expi35eosCBOrPk5QOXq+IMAJvWS8TKNnU4lMylxjQoMe/iqaiyZ/Kh3jxygCndJUCQv
         gtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q7Ha7Ai0GtbIXjarA/YCW+GRsgsN4GzMTN/f+D1Jbb4=;
        b=BLtyf+J4PjQF5FD1XhFPMnlZxq0uyuaFXbHAoHBRXlZjwYiFyAg1xi+HiIgOuxph1H
         Sgg+mVRBZWiGTkgnVxZ1dItg+Q8TMRNdQaPVuJUQ2YrT9v4NGLUQJFjPf+/KYvxL2fBe
         wClEv+rPMPmPltHxJVQFNuvi9mTXASQvJ8U9W2Mzjxpvfnx6CaQJieuNF1z2IM6PByUr
         cCJA+D39h0uQbD2yzY3FyFXaubAK65vys5Q5ZvuH4WJe/a9Uaki4TvwIfEsq6iTOyvQC
         skFCzpDm6jf/1MtCeyxQ8brUIRf10hPxnLj5quP7HhfHbsUuack10sJ+0AyRvtavwbYU
         +Aww==
X-Gm-Message-State: AOAM531I4KJJabKVSJt6B2xN0leVp2pH8ZREZ1yW2X9itKkBOM1E8YMS
        mO6QB+O1dCF1wTHsGkAQA3s/E2xY5f8PbLjn9pnkKFcIxw==
X-Google-Smtp-Source: ABdhPJxEJMb286Cln4oahqqUKORezMXe2lLLBn0IsNJTM3Aq58e/FQdXUO9Gx8iUSpQ7018JhGNkrrx9roR6hdORFdQ=
X-Received: by 2002:a17:906:604e:: with SMTP id p14mr3096157ejj.515.1607535569694;
 Wed, 09 Dec 2020 09:39:29 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
In-Reply-To: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 9 Dec 2020 09:39:18 -0800
Message-ID: <CAKywueRMTMy7shp_qT3Cu6E1EZ0AwdSvjsWF=MU4KQWkw+YL-A@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO
 info on negprot rsp
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

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
>   /* Verify that at least minimal negotiate contexts fit within frame */
>   if (len < nc_offset + (neg_count * sizeof(struct smb2_neg_context))) {
>
> --
> Thanks,
>
> Steve
