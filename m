Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4251CC77B73
	for <linux-cifs@archiver.kernel.org>; Sun, 21 May 2023 06:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjEUGHj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 May 2023 02:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjEUGHi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 May 2023 02:07:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF2510D
        for <linux-cifs@vger.kernel.org>; Sat, 20 May 2023 23:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E488861638
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 06:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FEDC4339C
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 06:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684649255;
        bh=4z0T63SfPPpt8C/uzQo1hHhnjjxjlf+i115pikALVRI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=GyuMdI0gTqXYAjGcyEYowkM7Ctffown8EaXcr6G4cu1pgyhOghBuHARXhdIg+W8bI
         eOyR3ifofy9T4szChI60B6aQI4IurTGex3P+hzv2tbvhfarqewZO7BQJ2RT4yGXyFR
         HT8+yT51DEK9wtp0A28g+qtl2bh8nXWukZArXFuJnYbNtF2GlH6jkhu1s9sYYsk8to
         U0NO7LgWvssUUHvoWLwL1Bx3wogSO8MkSBg34dMeTRRVIIyniCg+8gFnOci2DlQBoV
         OY+m1one/n+cdE2yuNBassu9ObRFx0nHfwUzuTsYZ1dZVow/WDGbYEhUr779RuGVOt
         a/uOgJH1QMiAA==
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-38ea3f8e413so2670852b6e.2
        for <linux-cifs@vger.kernel.org>; Sat, 20 May 2023 23:07:35 -0700 (PDT)
X-Gm-Message-State: AC+VfDzUIGmQldip01CbsYiHrEUkkExwhlXGckpQ3IyinchzqsxOt91t
        YFa0Fhm2NJrGncc1RF2Y+hSZLWuOValS1nl4ttc=
X-Google-Smtp-Source: ACHHUZ6ZbWp1GOkhIxX97DLbJjGskdOogZnnkVHwOKO5DHYkI+rK7Kt/lJFVCS8MhZhaXjhfSldtZNWAWtrAri2J8/Q=
X-Received: by 2002:a05:6808:2812:b0:396:3cae:d4d7 with SMTP id
 et18-20020a056808281200b003963caed4d7mr3870419oib.10.1684649254344; Sat, 20
 May 2023 23:07:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6415:0:b0:4da:311c:525d with HTTP; Sat, 20 May 2023
 23:07:33 -0700 (PDT)
In-Reply-To: <CAAn9K_tKYrMx4oZw8vR571ABUYLMGTfmBOmKCOx1vPLLi9qSvw@mail.gmail.com>
References: <CAAn9K_sJBAEcz=EM1O+sJOmtp=Yq3nW6g_Z+mYJLnCmj1ZANSw@mail.gmail.com>
 <CAKYAXd9_jm_4y2NvkyjYZaDLQMLiaBaOy4d860F9uzrvKrTbMQ@mail.gmail.com> <CAAn9K_tKYrMx4oZw8vR571ABUYLMGTfmBOmKCOx1vPLLi9qSvw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 21 May 2023 15:07:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8E3f8ksunGmZ3yj_m5G1OznXV2pLnGqPyaYgsBBzcv+w@mail.gmail.com>
Message-ID: <CAKYAXd8E3f8ksunGmZ3yj_m5G1OznXV2pLnGqPyaYgsBBzcv+w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: check the validation of pdu_size in ksmbd_conn_handler_loop
To:     =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-21 12:32 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>=
:
> Ok, I will update my patch and resend it to you.
>
> One more thing I want to check it with you, if ksmbd needs to check the
> protocol id, does it need to
> receive first 4 bytes of smb2_hdr first to check the ProtocolID? Or how c=
an
> I properly check that ProtocolID is SMB2?

Yes, We need to check it after reading. we can check pdu size is
smaller than smb1 header before reading and check smb2 header after
reading. Let me know if there is more good way.

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 4882a812ea86..b61d1ac94146 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -294,6 +294,9 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
        return true;
 }

+#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
+#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
+
 /**
  * ksmbd_conn_handler_loop() - session thread to listen on new smb request=
s
  * @p:         connection instance
@@ -353,6 +356,10 @@ int ksmbd_conn_handler_loop(void *p)
                /* 4 for rfc1002 length field */
                /* 1 for implied bcc[0] */
                size =3D pdu_size + 4 + 1;
+
+               if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
+                       break;
+
                conn->request_buf =3D kvmalloc(size, GFP_KERNEL);
                if (!conn->request_buf)
                        break;
@@ -377,6 +384,12 @@ int ksmbd_conn_handler_loop(void *p)
                        continue;
                }

+               if (((struct smb2_hdr
*)smb2_get_msg(conn->request_buf))->ProtocolId =3D=3D
+                   SMB2_PROTO_NUMBER) {
+                       if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
+                               break;
+               }
+
                if (!default_conn_ops.process_fn) {
                        pr_err("No connection request callback\n");
                        break;

>
> Thanks.
>
> Namjae Jeon <linkinjeon@kernel.org> =E6=96=BC 2023=E5=B9=B45=E6=9C=8821=
=E6=97=A5 =E9=80=B1=E6=97=A5 =E4=B8=8A=E5=8D=889:22=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
>> 2023-05-21 2:25 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.co=
m>:
>> > From ec0d45674df77bd3344717de3eae68de70210829 Mon Sep 17 00:00:00 2001
>> > From: Pumpkin <cc85nod@gmail.com>
>> > Date: Sun, 21 May 2023 01:04:41 +0800
>> > Subject: [PATCH] ksmbd: check the validation of pdu_size in
>> >  ksmbd_conn_handler_loop
>> >
>> > The length field of netbios header must be greater than the SMB header
>> > size, otherwise the packet is an invalid SMB packet.
>> >
>> > If `pdu_size` is 0, ksmbd allocates a 4 bytes chunk to
>> `conn->request_buf`.
>> > In the function `get_smb2_cmd_val` ksmbd will read cmd from
>> > `rcv_hdr->Command`,
>> > which is `conn->request_buf + 12`, causing the KASAN detector to print
>> the
>> > following error message:
>> >
>> > [    7.205018] BUG: KASAN: slab-out-of-bounds in
>> get_smb2_cmd_val+0x45/0x60
>> > [    7.205423] Read of size 2 at addr ffff8880062d8b50 by task
>> > ksmbd:42632/248
>> > ...
>> > [    7.207125]  <TASK>
>> > [    7.209191]  get_smb2_cmd_val+0x45/0x60
>> > [    7.209426]  ksmbd_conn_enqueue_request+0x3a/0x100
>> > [    7.209712]  ksmbd_server_process_request+0x72/0x160
>> > [    7.210295]  ksmbd_conn_handler_loop+0x30c/0x550
>> > [    7.212280]  kthread+0x160/0x190
>> > [    7.212762]  ret_from_fork+0x1f/0x30
>> > [    7.212981]  </TASK>
>> >
>> > Signed-off-by: Pumpkin <cc85nod@gmail.com>
>> Real name? please change your gitconfig.
>> > ---
>> >  fs/ksmbd/connection.c | 5 +++++
>> >  1 file changed, 5 insertions(+)
>> >
>> > diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
>> > index 4ed379f9b..2a7748694 100644
>> > --- a/fs/ksmbd/connection.c
>> > +++ b/fs/ksmbd/connection.c
>> > @@ -343,6 +343,11 @@ int ksmbd_conn_handler_loop(void *p)
>> >   READ_ONCE(conn->status));
>> >   break;
>> >   }
>> > +
>> > + if (pdu_size < sizeof(struct smb2_hdr)) {
>> > + pr_err("PDU length(%u) is less than SMB header size\n", size);
>> > + break;
>> > + }
>> OK. It will block smb1 negotiate request, We need to allow only smb1
>> negotiate in smb1 commands for auto negotiation. It will cause windows
>> client connection failure. So We need to check if protocol id is smb2
>> for this check. and +4 is needed for rfc1002 length If you want
>> pdu_size to be greater than or equal to the smb2 header size. i.e.
>> declare the macro like the following.
>>
>> #define KSMBD_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
>>
>> Thanks for your work!
>> >
>> >   /*
>> >   * Check maximum pdu size(0x00FFFFFF).
>> > --
>> > 2.39.2 (Apple Git-143)
>> >
>>
>
