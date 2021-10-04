Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAD5C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 11:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A659E611C8
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 11:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhJDLQ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Oct 2021 07:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhJDLQ4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Oct 2021 07:16:56 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287E3C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 04:15:08 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id g10so1530167vsb.8
        for <linux-cifs@vger.kernel.org>; Mon, 04 Oct 2021 04:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=giplS4+yR37vyU9AHMzmVYF/6ycF4zJXD9khbabZ2/A=;
        b=GIeMIC0aChWZJs+r2SOdyv36CTvhCS05XjBQUr6KqUCJ+f22AbVql2HkT9Pt2AO9+K
         KmU+hwh0N0Ztxccn3WCdFl9SfzcmLTwVdmCPOkgmT28++SzMu77tE9INAhSj0lk/wxzL
         rl7mgYgj2d5v1n1APv5o5PQHXPlyo9B3uSaC8Gy5+c6zko0iAgDgo6y71Z4ALEqxM7em
         uHE0eWyRYIFii0f8oVZPiiXkpN1JaZkodjg3Rk15XMURdI+kGRIVkcxVXOXnN8C/j9FO
         xmehQkhefO35qOgq84kyhToOX+VcQxsu2BD8aYL+lYa9EOfOO6e3h68WomvcH7xOna9P
         PpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=giplS4+yR37vyU9AHMzmVYF/6ycF4zJXD9khbabZ2/A=;
        b=Z9Dxvy8lWdhqTJ5l0LCKTMwOdpgypHm0evMM8CgY/gg7o5KgikfTZAWkwV7ek+x96Y
         SSuqL4BtmFA77HBkkeWGmy9FVFGXQe/RcbG02q22hYEcdYY80SX7M1n/saQdKX5cKlD4
         E9btFLIW78zPf79YW42br/KD8XGcTQLg7cviaVJn+bDdGblzjYT52rbcAmxzIiiozGt8
         4WPPXDkpWzNrniW4NXxUDk+idTloIb8P1VtfRi0oVY2XCtY0FWrIcP2spmFcEcJl5IrV
         24dUpMnDSi1N/GJBrKMjiUO8VMVCh1quIkyWptIL+lL7vY2blnTd7ddekYxVzlvuNT3U
         9VkA==
X-Gm-Message-State: AOAM530mJid96qk6rucLpToR+n37cxyvqvnBFOWqMo1ei46tmbc8wK6o
        XLgogM+katNqgUayePyf7BAcLAvGTJZJbrmdNHw=
X-Google-Smtp-Source: ABdhPJzU8O6nfwOuDWIf7Mr/5bbszCVpYrRvQ1SDZbNp9jnzS2ZTreTC53hvbKB/j7JovLpKH8y0Dbx4vNXmxQ8AeGE=
X-Received: by 2002:a05:6102:e55:: with SMTP id p21mr11275109vst.18.1633346107320;
 Mon, 04 Oct 2021 04:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211003043105.10453-1-linkinjeon@kernel.org> <CANFS6bb+hqid_YvkkSnMajwsQeOF_6NFke5ffuRVnPVoiHdKug@mail.gmail.com>
 <CAKYAXd-Cyv2qXgGmuGKQn1jr8SQu4kF4wyMrDxeAt_8Ao4pudg@mail.gmail.com>
In-Reply-To: <CAKYAXd-Cyv2qXgGmuGKQn1jr8SQu4kF4wyMrDxeAt_8Ao4pudg@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 4 Oct 2021 20:14:56 +0900
Message-ID: <CANFS6bbnBK6uqyimrK_7AhMw=dB1oeYMb7jQa9w3xrOfM1TWTQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: use buf_data_size instead of recalculation in smb3_decrypt_req()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 4=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 5:58, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:

>
> 2021-10-04 17:38 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2021=EB=85=84 10=EC=9B=94 3=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 1:3=
1, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1=
:
> >>
> >> Tom suggested to use buf_data_size that is already calculated, to veri=
fy
> >> these offsets.
> >>
> >> Cc: Tom Talpey <tom@talpey.com>
> >> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> >> Cc: Ralph B=C3=B6hme <slow@samba.org>
> >> Cc: Steve French <smfrench@gmail.com>
> >> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> >> Suggested-by: Tom Talpey <tom@talpey.com>
> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >> ---
> >>  fs/ksmbd/smb2pdu.c | 6 ++----
> >>  1 file changed, 2 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> index b06361313889..4d1be224dd8e 100644
> >> --- a/fs/ksmbd/smb2pdu.c
> >> +++ b/fs/ksmbd/smb2pdu.c
> >> @@ -8457,15 +8457,13 @@ int smb3_decrypt_req(struct ksmbd_work *work)
> >>         struct smb2_transform_hdr *tr_hdr =3D (struct smb2_transform_h=
dr
> >> *)buf;
> >>         int rc =3D 0;
> >>
> >> -       if (pdu_length + 4 <
> >> -           sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr=
))
> >> {
> >> +       if (buf_data_size < sizeof(struct smb2_hdr)) {
> >
> > Could integer overflow occur when buf_data_size is initialized?
> > buf_data_size is initialized with "pdu_length + 4 -
> > sizeof(struct smb2_transform_hdr)".
> overflow does not occur. See the comments below.
> >

Ah, I am worried that pdu_length + 4 is less than
sizeof(struct smb2_transform_hdr). And I can't find the check
that pdu size is enough before this function is called.


> > There was the check that the pdu size is greater than at least
> > __SMB2_HEADER_STRUCTURE_SIZE at ksmbd_conn_handler_loop(),
> > But I can't find this check in the latest patch set.
> Please check "ksmbd: add the check to vaildate if stream protocol
> length exceeds maximum value". pdu_length will never exceed
> MAX_STREAM_PROT_LEN(0x00FFFFFF).
>
> Thanks!
> >
> >
> >>                 pr_err("Transform message is too small (%u)\n",
> >>                        pdu_length);
> >>                 return -ECONNABORTED;
> >>         }
> >>
> >> -       if (pdu_length + 4 <
> >> -           le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct
> >> smb2_transform_hdr)) {
> >> +       if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) =
{
> >>                 pr_err("Transform message is broken\n");
> >>                 return -ECONNABORTED;
> >>         }
> >> --
> >> 2.25.1
> >>
> >
> >
> > --
> > Thanks,
> > Hyunchul
> >



--
Thanks,
Hyunchul
