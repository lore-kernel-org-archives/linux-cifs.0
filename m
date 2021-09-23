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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E35C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 00:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D960A60F70
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 00:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhIWAOh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhIWAOh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 20:14:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F9CC061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 17:13:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ee50so16648955edb.13
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 17:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=viseoEGEIYosOTl7hCQT7mJy3poHrmYGnoOZUqgH5jI=;
        b=dk0T65xdSrk9YopbSuRshC7l+dXHD9+C4wqWiVcWUQsyzji04PintcpVnCi2LnSqq7
         KAlbmvjjeuYZfkUdDo+ul64EXU6W6a5hCfVjRZZBtmVvKsksPDSMo6MI6sir/ONgQyQP
         wzocLxam6/jG5TsRGBj45Sr9JkEj/ir1TgklNJZ/Z2NLqYc5wlWawJEY3ExqfLdHP8Zv
         gsqAcRhhFOpmkCatinpuG0L1ahzC7CZptZVEg7qogy+2Joq+XOFnbZrUH+7nJW7xVAp5
         UHd2suiqqb8iywpxirMtiLNyW/YmjuFXls/gF+H16uAbb9VI/GecHg0L4547N5IIyFY7
         Sk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=viseoEGEIYosOTl7hCQT7mJy3poHrmYGnoOZUqgH5jI=;
        b=cmUi+vPQJLQCP2gmQrgrZLMFTd7LzjHtjVZFftyXm7DSIVaLSGmOyCFrUDnCf3M1ZZ
         IueX1A4k/GV18tacc6x80MukI7OJkf1TaaLyFASDEDg10QXwzPZCPrm/S2N/8U/iXay9
         /D14/iVSkN77du4K1i9XcMWojJnhb9x5zCokkCV2LELJjk+u3CTdNdwFXQAqzmsPlE9I
         c6B0CH1h79JuGt7oihiYP/wP8RRYiO+fTz/m88VVVs9owyW78ttb9TVHaMjt5oatOTmn
         +Oj5gn+c1BaPvHimVQke9C5uZYdtPobrDUXdqqs/OBuEKyRXexWNG5kPbXznSXdn9FmI
         REUA==
X-Gm-Message-State: AOAM533nzKt92C4PWpX0A+y/6OWqFs8o8pI30qrm4BX38FqaKkmlAgWm
        O3cNYEIh7/eBQpfbtyK0ZLMyReFK7rlp8mf1rM8=
X-Google-Smtp-Source: ABdhPJzKzSF7ZJ2bET/sI92K9HJUDEPBPWM/XcPOf1YttwvKoE+yzmYybE8IOQN815J0pPw6jdefvrnYdgUnG18SzCQ=
X-Received: by 2002:a50:8163:: with SMTP id 90mr2394184edc.198.1632355985259;
 Wed, 22 Sep 2021 17:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210921225109.6388-1-linkinjeon@kernel.org> <20210921225109.6388-2-linkinjeon@kernel.org>
 <433e36b5-f07c-0105-fd30-c7bb4cb8957d@samba.org> <CAKYAXd-+jfKqonB8=At-znCUBpF-J8Z3NfK=vvUJOfcUMFemoQ@mail.gmail.com>
In-Reply-To: <CAKYAXd-+jfKqonB8=At-znCUBpF-J8Z3NfK=vvUJOfcUMFemoQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 23 Sep 2021 10:12:53 +1000
Message-ID: <CAN05THQYNxfMh57R8c=f5syJ-4=LhZx81kO=jxX8x=3sm-6fwQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ksmbd: add validation in smb2 negotiate
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Ralph Boehme <slow@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 23, 2021 at 9:13 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-09-22 23:17 GMT+09:00, Ralph Boehme <slow@samba.org>:
> > Hi Namjae
> >
> > patch looks great! Few nitpicks below.
> >
> > Am 22.09.21 um 00:51 schrieb Namjae Jeon:
> >> This patch add validation to check request buffer check in smb2
> >> negotiate.
> >>
> >> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> >> Cc: Ralph B=C3=B6hme <slow@samba.org>
> >> Cc: Steve French <smfrench@gmail.com>
> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >> ---
> >>   fs/ksmbd/smb2pdu.c    | 41 ++++++++++++++++++++++++++++++++++++++++-
> >>   fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
> >>   2 files changed, 60 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> index baf7ce31d557..1fe37ad4e5bc 100644
> >> --- a/fs/ksmbd/smb2pdu.c
> >> +++ b/fs/ksmbd/smb2pdu.c
> >> @@ -1071,7 +1071,7 @@ int smb2_handle_negotiate(struct ksmbd_work *wor=
k)
> >>      struct ksmbd_conn *conn =3D work->conn;
> >>      struct smb2_negotiate_req *req =3D work->request_buf;
> >>      struct smb2_negotiate_rsp *rsp =3D work->response_buf;
> >> -    int rc =3D 0;
> >> +    int rc =3D 0, smb2_buf_len, smb2_neg_size;
> >
> > I guess all len variables should use unsigned types to facilitate well
> > defined overflow checks.
> As Ronnie pointed out, if checking max stream size, will be no problem.
> I'll fix it though.

You should add a check to ksmbd_conn_handler_loop() that the length is
< 0x01000000 too.

> >> >>      __le32 status;
> >>
> >>      ksmbd_debug(SMB, "Received negotiate request\n");
> >> @@ -1089,6 +1089,45 @@ int smb2_handle_negotiate(struct ksmbd_work *wo=
rk)
> >>              goto err_out;
> >>      }
> >>
> >> +    smb2_buf_len =3D get_rfc1002_len(work->request_buf);
> >> +    smb2_neg_size =3D offsetof(struct smb2_negotiate_req, Dialects) -=
 4;
> >> +    if (conn->dialect =3D=3D SMB311_PROT_ID) {
> >> +            int nego_ctxt_off =3D le32_to_cpu(req->NegotiateContextOf=
fset);
> >> +            int nego_ctxt_count =3D le16_to_cpu(req->NegotiateContext=
Count);
> >> +
> >> +            if (smb2_buf_len < nego_ctxt_off + nego_ctxt_count) {
> >
> > overflow check needed for 32 bit arch?
> Okay, will fix it on v3.
> Thanks!
> >
> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> >> +                    rc =3D -EINVAL;
> >> +                    goto err_out;
> >> +            }
> >> +
> >> +            if (smb2_neg_size > nego_ctxt_off) {
> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> >> +                    rc =3D -EINVAL;
> >> +                    goto err_out;
> >> +            }
> >> +
> >> +            if (smb2_neg_size + le16_to_cpu(req->DialectCount) * size=
of(__le16) >
> >> +                nego_ctxt_off) {
> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> >> +                    rc =3D -EINVAL;
> >> +                    goto err_out;
> >> +            }
> >> +    } else {
> >> +            if (smb2_neg_size > smb2_buf_len) {
> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> >> +                    rc =3D -EINVAL;
> >> +                    goto err_out;
> >> +            }
> >> +
> >> +            if (smb2_neg_size + le16_to_cpu(req->DialectCount) * size=
of(__le16) >
> >> +                smb2_buf_len) {
> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> >> +                    rc =3D -EINVAL;
> >> +                    goto err_out;
> >> +            }
> >> +    }
> >> +
> >>      conn->cli_cap =3D le32_to_cpu(req->Capabilities);
> >>      switch (conn->dialect) {
> >>      case SMB311_PROT_ID:
> >> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> >> index 1da67217698d..da17b21ac685 100644
> >> --- a/fs/ksmbd/smb_common.c
> >> +++ b/fs/ksmbd/smb_common.c
> >> @@ -229,13 +229,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_diale=
cts,
> >> __le16 dialects_count)
> >>
> >>   static int ksmbd_negotiate_smb_dialect(void *buf)
> >>   {
> >> -    __le32 proto;
> >> +    int smb_buf_length =3D get_rfc1002_len(buf);
> >
> > unsigned
> >
> > Thanks!
> > -slow
> >
> > --
> > Ralph Boehme, Samba Team                 https://samba.org/
> > SerNet Samba Team Lead      https://sernet.de/en/team-samba
> >
> >
