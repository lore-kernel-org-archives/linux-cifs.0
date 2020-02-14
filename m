Return-Path: <SRS0=N0Uh=4C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C7BC35242
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 06:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D38222C4
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 06:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sW+d3C7p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgBNGOO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Feb 2020 01:14:14 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:47064 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgBNGOO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Feb 2020 01:14:14 -0500
Received: by mail-il1-f193.google.com with SMTP id t17so7096691ilm.13
        for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2020 22:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AgNVsRbGPnQclUoA+g+S7cH7BE7QTuFrRGAnOVnFP8E=;
        b=sW+d3C7pacM4snHsbKW0Ncpt937en8saN0ffonuElY7Q+Sbtipm5PEsWiTTeWIuDvI
         W5qdg+FKmvbPrcRiQ2/wJYwbNL1633c4dgcN1AgI4hgevxpWIoy5WDF/28FV7GvcWdD+
         NQi22kooxzv1zcbFdlgApWxzWxX0HU4mXVqhQ5MEvE87Q0zy1iGWtBYDTNyVlbhHxAYF
         ha1ZkrVmfGaqSK6Yy0UU00EADtVRLURrWpqIOHaSL1/Udv9R9Er3O6q5Qd/IRwLSbQcx
         7RhM/0/iL0EywESzyG9BAd7CKzAGC8NTF//a4JgD39/x2tpW4L8g1OXoyYe65FxboxbM
         c23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AgNVsRbGPnQclUoA+g+S7cH7BE7QTuFrRGAnOVnFP8E=;
        b=YiLVPVSjti73FYEqjWiXTB4JhMwjDwy63d5HEEv1sV7/+KOfsLcf4s/1YReStJ2RQa
         gOYl06MVcmqWXHJNRWJTjroVHRkZGrqMQFTY+GvNqpdgYeZdol6ZthH7hJ1gZIGHFqq3
         aA7VI6Sppy9D6+scx196TXn2VsCAVx5X8v2GZiLXstj/KVGgqodnR534LfLgrbzg7H1B
         5tZatPkwqih9Nt2DwwxRE8i7GOqv6fUrSbbTgS4+/KzzgFxzn0+0aN8Ol7rfjS++0+7V
         TFMghrRHJKvpE5Dyov0C8hTecq3GJ+3plQJOzUGPvJBPx9U0Tcrqyq+M87l+Js6ZwcUl
         V3Mg==
X-Gm-Message-State: APjAAAWBIQN8OPmQl+J18hyFFRk+Ao2/HbwhHcdTGmMtb/2R34P7rq6t
        pMHT7u8uEU0d2+4x7Mmyv9q4i7ycS8z3STdHhxoGbIA7SiA=
X-Google-Smtp-Source: APXvYqyXy/rEjcDcvaQrCADLJmD4/8qA7sd2XNl4e2Twqyd4NbXQVbx6d83Xm5dyatbykkfGOO1bSWvrf2lRwRT9BJo=
X-Received: by 2002:a92:9a90:: with SMTP id c16mr1502919ill.3.1581660852623;
 Thu, 13 Feb 2020 22:14:12 -0800 (PST)
MIME-Version: 1.0
References: <20200213021447.24819-1-lsahlber@redhat.com>
In-Reply-To: <20200213021447.24819-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Feb 2020 00:14:01 -0600
Message-ID: <CAH2r5ms0Bz6gVS1guJS6_=3fwQSbdd2yOh7PKJCkrvqFeyUgnQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: make sure we do not overflow the max EA buffer size
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We should be allowing these to be larger than ~16000 bytes

Should be XATTR_SIZE_MAX 65536

but that can be done with different patch

On Wed, Feb 12, 2020 at 8:15 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1752437
>
> Before we add a new EA we should check that this will not overflow
> the maximum buffer we have available to read the EAs back.
> Otherwise we can get into a situation where the EAs are so big that
> we can not read them back to the client and thus we can not list EAs
> anymore or delete them.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index baa825f4cec0..3c76f69f4ca7 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1116,7 +1116,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
>         void *data[1];
>         struct smb2_file_full_ea_info *ea = NULL;
>         struct kvec close_iov[1];
> -       int rc;
> +       struct smb2_query_info_rsp *rsp;
> +       int rc, used_len = 0;
>
>         if (smb3_encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
> @@ -1139,6 +1140,38 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
>                                                              cifs_sb);
>                         if (rc == -ENODATA)
>                                 goto sea_exit;
> +               } else {
> +                       /* If we are adding a attribute we should first check
> +                        * if there will be enough space available to store
> +                        * the new EA. If not we should not add it since we
> +                        * would not be able to even read the EAs back.
> +                        */
> +                       rc = smb2_query_info_compound(xid, tcon, utf16_path,
> +                                     FILE_READ_EA,
> +                                     FILE_FULL_EA_INFORMATION,
> +                                     SMB2_O_INFO_FILE,
> +                                     CIFSMaxBufSize -
> +                                     MAX_SMB2_CREATE_RESPONSE_SIZE -
> +                                     MAX_SMB2_CLOSE_RESPONSE_SIZE,
> +                                     &rsp_iov[1], &resp_buftype[1], cifs_sb);
> +                       if (rc == 0) {
> +                               rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> +                               used_len = rsp->OutputBufferLength;
> +                       }
> +                       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> +                       resp_buftype[1] = CIFS_NO_BUFFER;
> +                       memset(&rsp_iov[1], 0, sizeof(rsp_iov[1]));
> +                       rc = 0;
> +
> +                       /* Use a fudge factor of 256 bytes in case we collide
> +                        * with a different set_EAs command.
> +                        */
> +                       if(CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
> +                          MAX_SMB2_CLOSE_RESPONSE_SIZE - 256 <
> +                          used_len + ea_name_len + ea_value_len + 1) {
> +                               rc = -ENOSPC;
> +                               goto sea_exit;
> +                       }
>                 }
>         }
>
> --
> 2.13.6
>


-- 
Thanks,

Steve
