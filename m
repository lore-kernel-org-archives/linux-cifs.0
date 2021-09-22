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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08213C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 00:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB21A61184
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 00:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhIVAlP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 20:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhIVAlO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 20:41:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D78C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 17:39:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dj4so3189144edb.5
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 17:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=loQj5b+GT85stdSpIsUXFNJ1fu0UKMVfsPC+RV9gXmU=;
        b=DDEPuOglFnCJs6bQxmSUK/N3I7rhbdg26XsI7UJ6rQ4lDPmlVWgbPMjcZ2fP66dVpM
         GizEznDcZK72+KZ87ZtyYUI6xeK19cX5SR+eUslF8w5SgJ6ONLTmtjx1tC8DzsUKsu8f
         L97Wff4xeGO6LJcpdXjfgMflCv11bfCMRvrdA4qifV+SvDjEuV0yKClssbY+XTwR5oKQ
         wvBaTV44f4ZseNgV6MaiQEk37voJwiYgdog6eUqUAAwBgBJFS0lxMdDl/nuLWovIEdOl
         pLjT+o84fuDEq+RTePWRcvCgab23BLVyItXzUptlDgYP48jvA8IsUyiZXd0AH9fYPNuv
         RoNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=loQj5b+GT85stdSpIsUXFNJ1fu0UKMVfsPC+RV9gXmU=;
        b=Kcvmuh3xwAA0eIn5xo56TUt1vgj18ej16ZBX/aoEZ2o6yyezwjM0oSBE+hHCvlHWzY
         woqTO2rlXn7GY2GEgTJKvjqAxXH9AdqFrVUShepHIDwC1/hKmq3alJef6UkduaObv2U8
         cAzDeAbVLLnXZCFLGlLbOJEQpsokL42L5nLdg2ZLbxF43wyVPdaSS6rOrZ0udosvxrKf
         AOrZ7wrojZI0iAUfbEXhjn/rzrpWuroC2urZFo2lolcIFo/X+VAaw4xEtiR+i4eD7Sw4
         8ueNIdAlCs22mxiqNUxSAwDr03FPndl1ANRucn+UjgAYOp4b3TmHDdxujXL2Qh3t2SRG
         +6fA==
X-Gm-Message-State: AOAM5332/h4q2poj3jzrRCOxB9K6MSrg7lUySeOmOsa5Pu7bvvQdwzNr
        4xlWkKdC0kLOEyADiSbUgC4s5zsQASA1YOkbmXw=
X-Google-Smtp-Source: ABdhPJyO97CMprzkufy9VQuT+xWtwdY7CdvQNtbLTbCWL9Yv+NjzNceb4SGS3ew5qj/jR4F9136V1Ojfa2juopdUdr0=
X-Received: by 2002:a17:906:680c:: with SMTP id k12mr38823364ejr.85.1632271184400;
 Tue, 21 Sep 2021 17:39:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210921225109.6388-1-linkinjeon@kernel.org> <20210921225109.6388-3-linkinjeon@kernel.org>
In-Reply-To: <20210921225109.6388-3-linkinjeon@kernel.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 22 Sep 2021 10:39:32 +1000
Message-ID: <CAN05THSRTAC4Na+_cMwTFEJ3WrmKQMUjq_0Tmn44RE2KHhVA3A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ksmbd: fix invalid request buffer access in
 compound request
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 22, 2021 at 8:51 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> Ronnie reported invalid request buffer access in chained command when
> inserting garbage value to NextCommand of compound request.
> This patch add validation check to avoid this issue.
>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  v2:
>   - fix integer overflow from work->next_smb2_rcv_hdr_off.
>
>  fs/ksmbd/smb2pdu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 1fe37ad4e5bc..cae796ea1148 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work *work=
)
>
>         hdr =3D ksmbd_req_buf_next(work);
>         if (le32_to_cpu(hdr->NextCommand) > 0) {
> +               if ((u64)work->next_smb2_rcv_hdr_off + le32_to_cpu(hdr->N=
extCommand) >
> +                   get_rfc1002_len(work->request_buf)) {
> +                       pr_err("next command(%u) offset exceeds smb msg s=
ize\n",
> +                              hdr->NextCommand);
> +                       return false;
> +               }
> +
>                 ksmbd_debug(SMB, "got SMB2 chained command\n");
>                 init_chained_smb2_rsp(work);
>                 return true;

Very good, reviewed by me.
The conditional though, since you know there will be at least a full
smb2 header there you could already check that change it to
> +               if ((u64)work->next_smb2_rcv_hdr_off + le32_to_cpu(hdr->N=
extCommand) >
> +                   get_rfc1002_len(work->request_buf) +  64) {


Which leads to another question.  Where do you check that the buffer
contains enough data to hold the smb2 header and the full fixed part
of the request?
There is a check that you have enough space for the smb2 header in
ksmbd_conn_handler_loop()
that there is enough space for the smb2 header
(ksmbd_pdu_size_has_room()) but that function assumes that the smb2
header always start at the head of the buffer.
So if you have a compound chain, this functrion only checks the first pdu.


I know that the buffer handling is copied from the cifs client.  It
used to also do these "just pass a buffer around and the first 4 bytes
is the size" (and still does for smb1)  and there was a lot of
terrible +4 or -4 to all sort of casts and conditionals.
I changed that in cifs.ko to remove the 4 byte length completely from
the buffer.
I also changed it as part of the compounding to pass an array of
requests (each containing an iovector) to the functions instead of
just one large byte array.
That made things a lot easier to manage since you could then assume
that the SMB2 header would always start at offset 0 in the
corresponding iovector, even for compounded commands since they all
had their own private vector.
And since an iovector contains both a pointer and a length there is no
need anymore to read the first 4 bytes/validate them/and covnert into
a length all the time.

I think that would help, but it would be a MAJOR amount of work, so
maybe that should wait until later.
That approach is very nice since it completely avoids keeping track of
offset-to-where-this-pdu-starts which makes all checks and
conditionals so much more complex.


regards
ronnie sahlberg


> --
> 2.25.1
>
