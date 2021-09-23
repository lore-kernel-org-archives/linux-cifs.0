Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF47CC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 00:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDDF461214
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 00:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbhIWA0v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234042AbhIWA0v (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 20:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B946461211
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632356720;
        bh=nAnyQHRhRh4T691ge1aUfks6DkrOzxf3KQo9lLhWNOY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=WojSgV3jox6fOgX5QDXEWN683yM10XMkWS8Kr/7zHyTxkK9tUPqXGWBwTcNBb4uih
         10l3AKLiaPzWlaP0K41eio1oeqwUfsDPVVvg8MZEt4xS1DumaEQ0SzWaTn5dG52aSR
         yx5sCoznT1C6XJUzzXauCiZdeFV+YUvYViV5CH2eiG9EekdiyTG7wvRK1zShGc35ho
         J5jwogmaFZ2q4ZxpHbfr4XHdYtAyfDhE0pKmDpQit2IjfFYAxpo2wbf6eUHJbYQN1n
         NHkO8KWbDZGVFUNP2x+B9Oq4Fr9m/h2sNGyiNedZWs0Wje5VMDJpRtIxyIxRO4ATHF
         9BsW67kRW0LpA==
Received: by mail-oi1-f175.google.com with SMTP id w206so7227370oiw.4
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 17:25:20 -0700 (PDT)
X-Gm-Message-State: AOAM532+kEYsnK+Gfo57pTRzL3f+nZXFG6pjbStSHWC06NkFy4mJF+LA
        q7g1w05sdr55DouPLgY3PcjkQyZeutsLBUGiC+c=
X-Google-Smtp-Source: ABdhPJw3D4EvZaUjkwhmMGrBAfJj49NYH9l/edTBWG+qbPOHn+HhrAdhJwwEF4zRnH1Sd72BesYU5IbnLcMZWlgNpog=
X-Received: by 2002:a54:4f03:: with SMTP id e3mr1603874oiy.32.1632356720160;
 Wed, 22 Sep 2021 17:25:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 22 Sep 2021 17:25:19
 -0700 (PDT)
In-Reply-To: <CAN05THQYNxfMh57R8c=f5syJ-4=LhZx81kO=jxX8x=3sm-6fwQ@mail.gmail.com>
References: <20210921225109.6388-1-linkinjeon@kernel.org> <20210921225109.6388-2-linkinjeon@kernel.org>
 <433e36b5-f07c-0105-fd30-c7bb4cb8957d@samba.org> <CAKYAXd-+jfKqonB8=At-znCUBpF-J8Z3NfK=vvUJOfcUMFemoQ@mail.gmail.com>
 <CAN05THQYNxfMh57R8c=f5syJ-4=LhZx81kO=jxX8x=3sm-6fwQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Sep 2021 09:25:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9aeH8=HA7Bcei2zmwN5Y5PCFPyD_FGotsBEdaYbYGR2w@mail.gmail.com>
Message-ID: <CAKYAXd9aeH8=HA7Bcei2zmwN5Y5PCFPyD_FGotsBEdaYbYGR2w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ksmbd: add validation in smb2 negotiate
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ralph Boehme <slow@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-23 9:12 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> On Thu, Sep 23, 2021 at 9:13 AM Namjae Jeon <linkinjeon@kernel.org> wrote=
:
>>
>> 2021-09-22 23:17 GMT+09:00, Ralph Boehme <slow@samba.org>:
>> > Hi Namjae
>> >
>> > patch looks great! Few nitpicks below.
>> >
>> > Am 22.09.21 um 00:51 schrieb Namjae Jeon:
>> >> This patch add validation to check request buffer check in smb2
>> >> negotiate.
>> >>
>> >> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> >> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> >> Cc: Steve French <smfrench@gmail.com>
>> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> >> ---
>> >>   fs/ksmbd/smb2pdu.c    | 41 ++++++++++++++++++++++++++++++++++++++++=
-
>> >>   fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
>> >>   2 files changed, 60 insertions(+), 3 deletions(-)
>> >>
>> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> >> index baf7ce31d557..1fe37ad4e5bc 100644
>> >> --- a/fs/ksmbd/smb2pdu.c
>> >> +++ b/fs/ksmbd/smb2pdu.c
>> >> @@ -1071,7 +1071,7 @@ int smb2_handle_negotiate(struct ksmbd_work
>> >> *work)
>> >>      struct ksmbd_conn *conn =3D work->conn;
>> >>      struct smb2_negotiate_req *req =3D work->request_buf;
>> >>      struct smb2_negotiate_rsp *rsp =3D work->response_buf;
>> >> -    int rc =3D 0;
>> >> +    int rc =3D 0, smb2_buf_len, smb2_neg_size;
>> >
>> > I guess all len variables should use unsigned types to facilitate well
>> > defined overflow checks.
>> As Ronnie pointed out, if checking max stream size, will be no problem.
>> I'll fix it though.
>
> You should add a check to ksmbd_conn_handler_loop() that the length is
> < 0x01000000 too.
Right, I will! Thanks!
>
>> >> >>      __le32 status;
>> >>
>> >>      ksmbd_debug(SMB, "Received negotiate request\n");
>> >> @@ -1089,6 +1089,45 @@ int smb2_handle_negotiate(struct ksmbd_work
>> >> *work)
>> >>              goto err_out;
>> >>      }
>> >>
>> >> +    smb2_buf_len =3D get_rfc1002_len(work->request_buf);
>> >> +    smb2_neg_size =3D offsetof(struct smb2_negotiate_req, Dialects) =
-
>> >> 4;
>> >> +    if (conn->dialect =3D=3D SMB311_PROT_ID) {
>> >> +            int nego_ctxt_off =3D
>> >> le32_to_cpu(req->NegotiateContextOffset);
>> >> +            int nego_ctxt_count =3D
>> >> le16_to_cpu(req->NegotiateContextCount);
>> >> +
>> >> +            if (smb2_buf_len < nego_ctxt_off + nego_ctxt_count) {
>> >
>> > overflow check needed for 32 bit arch?
>> Okay, will fix it on v3.
>> Thanks!
>> >
>> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> >> +                    rc =3D -EINVAL;
>> >> +                    goto err_out;
>> >> +            }
>> >> +
>> >> +            if (smb2_neg_size > nego_ctxt_off) {
>> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> >> +                    rc =3D -EINVAL;
>> >> +                    goto err_out;
>> >> +            }
>> >> +
>> >> +            if (smb2_neg_size + le16_to_cpu(req->DialectCount) *
>> >> sizeof(__le16) >
>> >> +                nego_ctxt_off) {
>> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> >> +                    rc =3D -EINVAL;
>> >> +                    goto err_out;
>> >> +            }
>> >> +    } else {
>> >> +            if (smb2_neg_size > smb2_buf_len) {
>> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> >> +                    rc =3D -EINVAL;
>> >> +                    goto err_out;
>> >> +            }
>> >> +
>> >> +            if (smb2_neg_size + le16_to_cpu(req->DialectCount) *
>> >> sizeof(__le16) >
>> >> +                smb2_buf_len) {
>> >> +                    rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>> >> +                    rc =3D -EINVAL;
>> >> +                    goto err_out;
>> >> +            }
>> >> +    }
>> >> +
>> >>      conn->cli_cap =3D le32_to_cpu(req->Capabilities);
>> >>      switch (conn->dialect) {
>> >>      case SMB311_PROT_ID:
>> >> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
>> >> index 1da67217698d..da17b21ac685 100644
>> >> --- a/fs/ksmbd/smb_common.c
>> >> +++ b/fs/ksmbd/smb_common.c
>> >> @@ -229,13 +229,22 @@ int ksmbd_lookup_dialect_by_id(__le16
>> >> *cli_dialects,
>> >> __le16 dialects_count)
>> >>
>> >>   static int ksmbd_negotiate_smb_dialect(void *buf)
>> >>   {
>> >> -    __le32 proto;
>> >> +    int smb_buf_length =3D get_rfc1002_len(buf);
>> >
>> > unsigned
>> >
>> > Thanks!
>> > -slow
>> >
>> > --
>> > Ralph Boehme, Samba Team                 https://samba.org/
>> > SerNet Samba Team Lead      https://sernet.de/en/team-samba
>> >
>> >
>
