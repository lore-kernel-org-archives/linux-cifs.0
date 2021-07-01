Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C56C11F67
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Jul 2021 22:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 951BA613FB
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Jul 2021 22:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhGAW7M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Jul 2021 18:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhGAW7L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Jul 2021 18:59:11 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D665CC061762
        for <linux-cifs@vger.kernel.org>; Thu,  1 Jul 2021 15:56:39 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i20so12754749ejw.4
        for <linux-cifs@vger.kernel.org>; Thu, 01 Jul 2021 15:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=74DSE3fOkPG5wg7qq/mL2JMMEQXkPi5bkvGVxYwa1+s=;
        b=XShotPd6AmJMu1avvolrubdP13kTGQzqb1vpvV0NQK+BHPndnHBqoBVjeQDEBqg6C+
         xCCJtYSbi7AKowTjGc4/LoqTDjxG/gMavXtz5JC0H2ICVFzLEpL/qzqswxfHiKuKSPHS
         At08Y5T6ED61UzpCyKs/krk8BGRw1z7Cm28oK/gCDc8j8FMt5b2Dz/EXCpb3AjfCwuqu
         cd4SmfZ8SH914uGnd+Z6v/ajFfSszZxZhsiYYCWJ3mTskswjN7sBxezeONE7t9m64sep
         29s82mudBN0Px9ByWs41lIFbHRNEVA/0zYxIrhMlSp0pDz6aicO2R5wWhWaOcNabEa36
         R9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=74DSE3fOkPG5wg7qq/mL2JMMEQXkPi5bkvGVxYwa1+s=;
        b=ZJIoPBt8cG3TSUNV/RfLLkHUU01beRxSFTKupdraJI4VQrn2QqrMiTK4trDS8EauIm
         YSUluXFuQlhi4GnyBBFR+KAYaU7niMGhpGsqlaxrbapg5tiGa+FJivDfOykdF/BCLBm/
         oavTf2S1bcGRPsTBJdbrhHAA5WIkPRKKYuO0yE30p7KsB0hcK+g/oLYpkADifM0IKbwr
         K4rPhdvUE63TjTyHvP4G9e0GLffkyDEUsH5FYRZFS3qgkiHLQYuV5p95aF/WwHHQnuab
         NkaTk7PlY+4RIM1p6VCs8ayAhZBxQaF68oXScsKYLhyeywSA7xdA5/bZRxQbwXLTBejQ
         /7vQ==
X-Gm-Message-State: AOAM532+/ohvFBmj6nKrAXsNTTmc65jXKFEB7WEVBKjMowKnRy+XBsqk
        XENOt4F53mMJeJsoaRvJPz5r3ioNhSHNHByxRH8=
X-Google-Smtp-Source: ABdhPJwcBPLtUuyBPpo3TVmsXR5STbelQ7oxeWOFhDfft3A9GsG3Bte8QNyASAn8ES4fIS9BD1k7hWZQ7P2g6Gw52ZA=
X-Received: by 2002:a17:907:3ea5:: with SMTP id hs37mr2192917ejc.473.1625180198554;
 Thu, 01 Jul 2021 15:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtHr8eQJo=L1of-PHHNa8iuGUQqWzAAFdpT0=14rvKSkQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtHr8eQJo=L1of-PHHNa8iuGUQqWzAAFdpT0=14rvKSkQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 2 Jul 2021 08:56:26 +1000
Message-ID: <CAN05THRg6Uo7GJPvP+sudRGAacZCHUivHx5x9483rG2d-QTNtg@mail.gmail.com>
Subject: Re: [PATCH] cifs: clarify SMB1 code for UnixCreateHardLink
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Fri, Jul 2, 2021 at 8:53 AM Steve French <smfrench@gmail.com> wrote:
>
> Coverity complains about the way we calculate the offset
> (starting from the address of a 4 byte array within the
> header structure rather than from the beginning of the struct
> plus 4 bytes).  This doesn't change the address but
> makes it slightly clearer.
>
> Addresses-Coverity: 711529 ("Out of bounds read")
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifspdu.h | 1 +
>  fs/cifs/cifssmb.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 0923f72d27e9..f6e235001358 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -1785,6 +1785,7 @@ struct smb_com_transaction2_sfi_req {
>   __u16 Fid;
>   __le16 InformationLevel;
>   __u16 Reserved4;
> + __u8  payload[];
>  } __attribute__((packed));
>
>  struct smb_com_transaction2_sfi_rsp {
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 58ebec4d4413..ea12fa6eacb6 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3009,7 +3009,8 @@ CIFSUnixCreateHardLink(const unsigned int xid,
> struct cifs_tcon *tcon,
>   InformationLevel) - 4;
>   offset = param_offset + params;
>
> - data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
> + /* SMB offsets are from the beginning of SMB which is 4 bytes in,
> after RFC1001 field */
> + data_offset = (char *)pSMB + offset + 4;
>   if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>   name_len_target =
>       cifsConvertToUTF16((__le16 *) data_offset, fromName,
>
> --
> Thanks,
>
> Steve
