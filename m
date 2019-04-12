Return-Path: <SRS0=lstS=SO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C322C10F13
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 00:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF872184B
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 00:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwKh2Y9H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfDLAKY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Apr 2019 20:10:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46399 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfDLAKY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Apr 2019 20:10:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id y6so4160869pll.13
        for <linux-cifs@vger.kernel.org>; Thu, 11 Apr 2019 17:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wIGTAjL9DheaIkwecQW8tPEQqHSsq1FAqdmHIlz95CE=;
        b=PwKh2Y9HV7TURPZile2kp+pg72PZkfv8+a3vepzUU37rUGo1+F171qOimeADDETCXa
         W14AmCNUiCsUPcTg4X+qp1UZilOA7Qn4U+rFVFfPQsqdFc6L2P2HLQA07L81nC8sM8xF
         0bC6ALRvallzCPMDsUWN+ciDWXki8T25p9eKPbFzfutu/a8tCV6AcqgDQjWMuzJxOhWi
         40rAS1RioAvmSflaYlfHhphkvkj7ccC6wkB2mofg24VQ6VHEQnh2W3YaCsQM4awC46bM
         sqheELf2N8853T5PIHGQk64C5ZRbVVCtm0RRyTHAxBx8K1DTd4s7wKiSJPcC0lhwap+J
         dlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wIGTAjL9DheaIkwecQW8tPEQqHSsq1FAqdmHIlz95CE=;
        b=HjzGPLU0SbqbQXLQJfOoVMXXBJPJ25FwKovdlV56+xS1qG2LN1bUazKg7xyjP9Buxd
         U+T/YL9dcKBiPF1XEwRkwEp1eBVG5NCY+1SGJUuJN9Fn8H+gKFJFkI7vCftzHmDm5Q3M
         Mxllq58BQSUge7fNE/5u/4lsCUkiPU0U9njyj2E1UftUih955Ngc2wTEuzW+FyJYT+Pm
         e38UtjdcJH7JmEQBtAtBRAXOLOOuSIDmRMeq8KJUcSSxD+Ap1K4UK82pc57NHSCggdhV
         C0vYkrIjTyXwpn9VuFQHbn5I7MBWGEwvK5ZxbBdrMKUaPdwIqNVrDuRzxrC/HVtm/QL/
         osfQ==
X-Gm-Message-State: APjAAAU9+/3lMBOgrjP8pFMLgXQHYZTUyIwSjWrAWsloZaTndMcvfbd8
        wJWy/YwSNaDsMtb5j1H7l8PGCbZZ2U26L9ZxFIw=
X-Google-Smtp-Source: APXvYqz7lRGWOo+f+J1zt7SSRq3bumQFTpdrAjDFCTZkBIls3KeG6tMfhACfmBxKVX8Mz3Zpbcc9/eh/lmRNpzcbgQc=
X-Received: by 2002:a17:902:70cc:: with SMTP id l12mr53323424plt.10.1555027823465;
 Thu, 11 Apr 2019 17:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190411235623.26659-1-lsahlber@redhat.com>
In-Reply-To: <20190411235623.26659-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Apr 2019 19:10:11 -0500
Message-ID: <CAH2r5msY3JT59S3uuMUJ18CAqXcuvx25LTnrSKAkNOo1dHEgHQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: zero-range does not require the file is sparse
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I verified it fixed 5 xfstests (033, 149, 155, 180, 349)

On Thu, Apr 11, 2019 at 6:56 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Remove the conditional to fail zero-range if the file is not flagged as sparse.
> You can still zero out a range in SMB2 even for non-sparse files.
>
> Tested with stock windows16 server.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index ca952dc3ec75..56e85f46cd82 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2664,18 +2664,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>                         return rc;
>                 }
>
> -       /*
> -        * Must check if file sparse since fallocate -z (zero range) assumes
> -        * non-sparse allocation
> -        */
> -       if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)) {
> -               rc = -EOPNOTSUPP;
> -               trace_smb3_zero_err(xid, cfile->fid.persistent_fid, tcon->tid,
> -                             ses->Suid, offset, len, rc);
> -               free_xid(xid);
> -               return rc;
> -       }
> -
>         cifs_dbg(FYI, "offset %lld len %lld", offset, len);
>
>         fsctl_buf.FileOffset = cpu_to_le64(offset);
> --
> 2.13.6
>


-- 
Thanks,

Steve
