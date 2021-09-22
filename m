Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054A9C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 05:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5DC611C9
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 05:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhIVFkj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhIVFki (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 01:40:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 879CC61131
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 05:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632289149;
        bh=80qJVUBlNKEVAFbP/73En/xzNCepNTn6T6vtRvY0u4U=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jqTT4Nzrho9828dN6m3iWolFPNpxrX+h9sbL7ZT4urdWOqB0zlVaB1ifF2GVWDBFn
         bIY/E7Mm0nfiZrXYe18n7M0OvHjb4jBVIs9C0hPSi7vH4odJAA0HFvWA2TbbBGP0CH
         Gm4PhnV5wblhDrJVRR4rrWG0pxCNmI5NWS+MwUlrUh6utaavrG1YiWP+m4vBEDrfoG
         n8Ln5/6tycILzy9aVGhPItMzBFZjScJ5xhEyp2+h7cPW/FRI03iGLTbyYcjUNIeAiT
         FPIjZAkSO4+NWmLGhg9rZMaRWl9g5qHCuY+zho1rWFPu9/vFRYBDBwO9kEExRmZPNj
         zl92iGdej3/uA==
Received: by mail-oi1-f176.google.com with SMTP id r26so2843432oij.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 22:39:09 -0700 (PDT)
X-Gm-Message-State: AOAM531kxsz4yIj9hv9tWI/MlHCgWypMOYO3R5T80w74ogxiOABQtG7e
        /hLRYs7tPo2Rn6B0ndrEfzKSrq2KAqR0KTWArGA=
X-Google-Smtp-Source: ABdhPJx8EGB2OwoZjxFacKauSU606epggpLaSJL4583ACGQsrB30urmeh47kAUBaNlrOYlmv0X0B0Ofbf2FUYafEVe4=
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr1173671oib.138.1632289148950;
 Tue, 21 Sep 2021 22:39:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 22:39:08
 -0700 (PDT)
In-Reply-To: <CAGvGhF65fvZksvcLy8RWEizDwLVmKvM-0Mwe-xhWQk67-mExfQ@mail.gmail.com>
References: <CAGvGhF65fvZksvcLy8RWEizDwLVmKvM-0Mwe-xhWQk67-mExfQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 22 Sep 2021 14:39:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-efF4s9NWA+KiP6yu7Gvt-j04NNd1M7NrAU_041BbUbA@mail.gmail.com>
Message-ID: <CAKYAXd-efF4s9NWA+KiP6yu7Gvt-j04NNd1M7NrAU_041BbUbA@mail.gmail.com>
Subject: Re: Only checks the signature for the first pdu in a compound.
To:     Leif Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-22 14:22 GMT+09:00, Leif Sahlberg <lsahlber@redhat.com>:
> Minor issue, as far as I can tell not exploitable, but looks funny.
>
>
> Apply this patch to libsmb2 and run this for a reproducer:
> diff --git a/lib/libsmb2.c b/lib/libsmb2.c
> index d17e72b..244cab6 100644
> --- a/lib/libsmb2.c
> +++ b/lib/libsmb2.c
> @@ -1985,6 +1985,7 @@ smb2_getinfo_async(struct smb2_context *smb2,
> const char *path,
>                  smb2_free_pdu(smb2, pdu);
>                  return -1;
>          }
> +        next_pdu->header.protocol_id[3] = 0xaa;
>          smb2_add_compound_pdu(smb2, pdu, next_pdu);
>
>          /* CLOSE command */
>
>
> ./examples/smb2-stat-sync smb://server/Share
>
>
> What it basically does it it corrupts the SMB2 signature for the
> second PDU in the
> Create/GetInfo/Close compound.
>
> Wireshark is fine with this and still decodes the PDU eventhough it
> has the signature 0xfe 'S 'M' 0xaa
>
>
> The bug is  that it only checks the signature for the first PDU:
>
> int ksmbd_verify_smb_message(struct ksmbd_work *work)
> {
> struct smb2_hdr *smb2_hdr = work->request_buf;
>
> if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
> return ksmbd_smb2_check_message(work);
>
> return 0;
> }
>
>
> Funny thing is that ksmbd responds with the same bogus signature in
> the second PDU in the compound.
Oops, I will fix it, Thanks for your check!
>
>
