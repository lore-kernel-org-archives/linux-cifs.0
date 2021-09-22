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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76098C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 22:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DFCC61100
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 22:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhIVWZ4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 18:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbhIVWZz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 18:25:55 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D743C061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 15:24:25 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b20so18238026lfv.3
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 15:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UN65BtvKlOu33U43G8Ts4qwFvrRO8AL1x20WR4u2wz8=;
        b=OlG75jz6FL2hYPEe680EIf8r3U/qo2RRIHgV6Y4grdqySVDEiFfoTPA14VRLDxWHLk
         fOfpdWmq7l5dizGWvm5JikQD0eB7UOG8kmePllsHQGpSzUwcigJSp61IA8YbtfVhrtCH
         CiQbzf6JofgFph0GdGDsFj7r6cc9dOihlambnUvDH7iqcWVzkp1iqHG4HJK835maH+8b
         Yl1KnwiJ0mozTJINlzrUj7Xe8SgyHeKnrInRuUPmXsHEcEYrIlwWYHdlFgykWMS7/tzn
         dhpqWzhKB3F5Ya+m5KMruRFazcIymkoo3gDHW1VEGJBg68KPhQJ/uxqFBTz8Bt5OwA3m
         TEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UN65BtvKlOu33U43G8Ts4qwFvrRO8AL1x20WR4u2wz8=;
        b=tSQHuS7uqBhlXUXQeBoqkkYhwkDtM8tc3v2o5ltYabDkMM91V/wjQPs2MYQAHod82K
         Lu3k/AhsK9QMUYYot1ZHmKeR7En0ixEriYaN5BfFLtyN240zGC6a+ijsm6v+iWHw8GMR
         lSAcaATBNV7oMQIPKo7Kw91mhieq3Rbhfvj4P6aqmfBSirUwiJe/JcxrZgjFSayYTeiV
         XQpfcF/X6XJLGZa2ctCIqFnOzipNsf4D7rWMG+j4EDdszxQGkvuxwNgpMsZZJyBBbTJA
         1hFbn6LgFJI8h+dCBMvCr4TEqWtchlbcCl6Zhd6OsxRDWqPRbrkji+2IqmAe4fsaVrtL
         k3rQ==
X-Gm-Message-State: AOAM532znqTGGVY9EBE7cXeFt6bJNkkCnLVMwxAQtnTy/L4LTEqHbjCu
        7kjWasYn6/cFWYJHT7HfKLw/mg3Y2fQDCsn545M=
X-Google-Smtp-Source: ABdhPJy2/Z8do57x2HQvjYtCqnhzoomNTfI5OeWkB3x41HIwKEi6FEdm3U1VHVTEv5pjZcg9v0FHTF6VPd2TFwTkSFQ=
X-Received: by 2002:ac2:5467:: with SMTP id e7mr1127444lfn.537.1632349463314;
 Wed, 22 Sep 2021 15:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210922120057.45789-1-linkinjeon@kernel.org> <CAN05THQVgu33LmFx5u3xm7MjdJZMYe81-bJEvAVJLPrMkjYYZg@mail.gmail.com>
In-Reply-To: <CAN05THQVgu33LmFx5u3xm7MjdJZMYe81-bJEvAVJLPrMkjYYZg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 22 Sep 2021 17:24:12 -0500
Message-ID: <CAH2r5mvaDzXeuooUq+_GkR_F5EeSPrt-yUGjPsfR=MVbv6joMw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: check protocol id in ksmbd_verify_smb_message()
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added the R-Bs and merged into cifsd-for-next  (current content is
below, although looks like we could update the "buffer invalidation in
smb2_set_info" patch)

e6201b4a0bac (HEAD -> cifsd-for-next, origin/cifsd-for-next) ksmbd:
add request buffer validation in smb2_set_info
743d886affeb ksmbd: remove follow symlinks support
3bee78ad0062 ksmbd: fix invalid request buffer access in compound request
18a015bccf9e ksmbd: check protocol id in ksmbd_verify_smb_message()
9f6323311c70 ksmbd: add default data stream name in FILE_STREAM_INFORMATION
e44fd5081c50 ksmbd: log that server is experimental at module load

On Wed, Sep 22, 2021 at 4:33 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> reviewed by me
>
> On Wed, Sep 22, 2021 at 10:01 PM Namjae Jeon <linkinjeon@kernel.org> wrot=
e:
> >
> > When second smb2 pdu has invalid protocol id, ksmbd doesn't detect it
> > and allow to process smb2 request. This patch add the check it in
> > ksmbd_verify_smb_message() and don't use protocol id of smb2 request as
> > protocol id of response.
> >
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Ralph B=C3=B6hme <slow@samba.org>
> > Cc: Steve French <smfrench@gmail.com>
> > Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >  fs/ksmbd/smb2pdu.c    |  2 +-
> >  fs/ksmbd/smb_common.c | 13 +++++++++----
> >  fs/ksmbd/smb_common.h |  1 +
> >  3 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index 3d250e2539e6..3be1493cb18d 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -433,7 +433,7 @@ static void init_chained_smb2_rsp(struct ksmbd_work=
 *work)
> >                 work->compound_pfid =3D KSMBD_NO_FID;
> >         }
> >         memset((char *)rsp_hdr + 4, 0, sizeof(struct smb2_hdr) + 2);
> > -       rsp_hdr->ProtocolId =3D rcv_hdr->ProtocolId;
> > +       rsp_hdr->ProtocolId =3D SMB2_PROTO_NUMBER;
> >         rsp_hdr->StructureSize =3D SMB2_HEADER_STRUCTURE_SIZE;
> >         rsp_hdr->Command =3D rcv_hdr->Command;
> >
> > diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> > index da17b21ac685..ace8a1b02c81 100644
> > --- a/fs/ksmbd/smb_common.c
> > +++ b/fs/ksmbd/smb_common.c
> > @@ -129,16 +129,22 @@ int ksmbd_lookup_protocol_idx(char *str)
> >   *
> >   * check for valid smb signature and packet direction(request/response=
)
> >   *
> > - * Return:      0 on success, otherwise 1
> > + * Return:      0 on success, otherwise -EINVAL
> >   */
> >  int ksmbd_verify_smb_message(struct ksmbd_work *work)
> >  {
> > -       struct smb2_hdr *smb2_hdr =3D work->request_buf;
> > +       struct smb2_hdr *smb2_hdr =3D work->request_buf + work->next_sm=
b2_rcv_hdr_off;
> > +       struct smb_hdr *hdr;
> >
> >         if (smb2_hdr->ProtocolId =3D=3D SMB2_PROTO_NUMBER)
> >                 return ksmbd_smb2_check_message(work);
> >
> > -       return 0;
> > +       hdr =3D work->request_buf;
> > +       if (*(__le32 *)hdr->Protocol =3D=3D SMB1_PROTO_NUMBER &&
> > +           hdr->Command =3D=3D SMB_COM_NEGOTIATE)
> > +               return 0;
> > +
> > +       return -EINVAL;
> >  }
> >
> >  /**
> > @@ -270,7 +276,6 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
> >         return BAD_PROT_ID;
> >  }
> >
> > -#define SMB_COM_NEGOTIATE      0x72
> >  int ksmbd_init_smb_server(struct ksmbd_work *work)
> >  {
> >         struct ksmbd_conn *conn =3D work->conn;
> > diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> > index d7df19c97c4c..994abede27e9 100644
> > --- a/fs/ksmbd/smb_common.h
> > +++ b/fs/ksmbd/smb_common.h
> > @@ -202,6 +202,7 @@
> >                 FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
> >
> >  #define SMB1_PROTO_NUMBER              cpu_to_le32(0x424d53ff)
> > +#define SMB_COM_NEGOTIATE              0x72
> >
> >  #define SMB1_CLIENT_GUID_SIZE          (16)
> >  struct smb_hdr {
> > --
> > 2.25.1
> >



--=20
Thanks,

Steve
