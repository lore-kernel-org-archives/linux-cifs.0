Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943C2C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 06:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6353561A7B
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 06:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhJBGHK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 02:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhJBGHK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 02:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E3161A7B
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633154725;
        bh=ucbJHt+s8dRYh3XhPp+ipTZASRp6gb//rTfv9dm/6Xk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Zh3FtLfW2oxaFRMMYesehBvgOzvfFNnvq9vUziQFYiyMgapWWh866gR155cE5lkKt
         MuPe2fF/bSRLHthRpcGike1y7+RuiGhfQLRYiuyaIvIcgzGsZsoE5PG2Aqlb66zR/M
         6XzwVfEGi5QGg3dNwNTL9cn8MfhxCGJQp0nz/IGSpSjH6zgiWUAmtCf66zhR1iy4rd
         WYmj4rmYQfACGMkoWMahHB1d8kXRkcnqG68PNDQCN7+/hD1SKnD9Zs8brbXRK9sZyz
         26t46TRfA6n8sWathGborIr33GG63j9GTWT78moHHH3XXUcZD/eIYdWh+kOOiudwws
         biYCVMNcSFeDw==
Received: by mail-ot1-f53.google.com with SMTP id 77-20020a9d0ed3000000b00546e10e6699so14253937otj.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 Oct 2021 23:05:25 -0700 (PDT)
X-Gm-Message-State: AOAM532HshZgJwGRGdew2J3RZN0IcPwQ7DhM6+glTZX+Aqr6abjO4p41
        TYEE6c8NjedTSU58MDW9fSFktIzuPlxgW5VzH7g=
X-Google-Smtp-Source: ABdhPJzVH+D+dokk+u5KNelYlOK4DkM2jyiQw3d3MGqxaL+Z+kJ4XpOyWViWik9p/+N/7Ia3RGK3+5SOYcM/SL56R34=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr1451608otf.237.1633154724476;
 Fri, 01 Oct 2021 23:05:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 1 Oct 2021 23:05:24 -0700 (PDT)
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 2 Oct 2021 15:05:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_5LS3_Wptb3SULciOyKYzmijrFRn2+7MuNmemmyQoD7Q@mail.gmail.com>
Message-ID: <CAKYAXd_5LS3_Wptb3SULciOyKYzmijrFRn2+7MuNmemmyQoD7Q@mail.gmail.com>
Subject: Re: [PATCH v5 00/20] Buffer validation patches
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-01 21:04 GMT+09:00, Ralph Boehme <slow@samba.org>:
> v2:
>   - update comments of smb2_get_data_area_len().
>   - fix wrong buffer size check in fsctl_query_iface_info_ioctl().
>   - fix 32bit overflow in smb2_set_info.
>
> v3:
>   - add buffer check for ByteCount of smb negotiate request.
>   - Moved buffer check of to the top of loop to avoid unneeded behavior
> when
>     out_buf_len is smaller than network_interface_info_ioctl_rsp.
>   - get correct out_buf_len which doesn't exceed max stream protocol
> length.
>   - subtract single smb2_lock_element for correct buffer size check in
>     ksmbd_smb2_check_message().
>
> v4:
>   - use work->response_sz for out_buf_len calculation in smb2_ioctl.
>   - move smb2_neg size check to above to validate NegotiateContextOffset
>     field.
>   - remove unneeded dialect checks in smb2_sess_setup() and
>     smb2_handle_negotiate().
>   - split smb2_set_info patch into two patches(declaring
>     smb2_file_basic_info and buffer check)
>
> v5:
>   - remove PDU size validation from ksmbd_conn_handler_loop()
>   - add PDU size validation to ksmbd_smb2_check_message()
>   - fix compound non-related request handling
Hi Ralph,

Have you tested this patch-set ? When I tried to run xfstests test,
kernel oops happen.
Can you run xfstests and check kernel oops  ?

These are my xfstests command and tests.

sudo ./check cifs/001 generic/001 generic/002 generic/005 generic/006
generic/007 generic/008 generic/011 generic/013 generic/014
generic/020 generic/023 generic/024 generic/028 generic/029
generic/030 generic/032 generic/033 generic/036 generic/037
generic/069 generic/070 generic/071 generic/074 generic/080
generic/084 generic/086 generic/095 generic/098 generic/100
generic/103 generic/109 generic/113 generic/117 generic/124
generic/125 generic/129 generic/130 generic/132 generic/133
generic/135 generic/141 generic/169 generic/198 generic/207
generic/208 generic/210 generic/211 generic/212 generic/214
generic/215 generic/221 generic/225 generic/228 generic/236
generic/239 generic/241 generic/245 generic/246 generic/247
generic/248 generic/249 generic/257 generic/258 generic/286
generic/308 generic/309 generic/310 generic/313 generic/315
generic/316 generic/337 generic/339 generic/340 generic/344
generic/345 generic/346 generic/349 generic/350 generic/354
generic/360 generic/377 generic/391 generic/393 generic/394
generic/406 generic/412 generic/420 generic/422 generic/432
generic/433 generic/436 generic/437 generic/438 generic/439
generic/443 generic/445 generic/446 generic/448 generic/451
generic/452 generic/454 generic/460 generic/464 generic/465
generic/490 generic/504 generic/523 generic/524 generic/533
generic/539 generic/567 generic/568 generic/590 generic/591

Thanks!
>
> Hyunchul Lee (1):
>   ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
>
> Namjae Jeon (9):
>   ksmbd: add the check to vaildate if stream protocol length exceeds
>     maximum value
>   ksmbd: add validation in smb2_ioctl
>   ksmbd: use correct basic info level in set_file_basic_info()
>   ksmbd: add request buffer validation in smb2_set_info
>   ksmbd: check strictly data area in ksmbd_smb2_check_message()
>   ksmbd: add validation in smb2 negotiate
>   ksmbd: remove the leftover of smb2.0 dialect support
>   ksmbd: remove NTLMv1 authentication
>   ksmbd: fix transform header validation
>
> Ralph Boehme (10):
>   ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
>   ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
>   ksmbd: remove ksmbd_verify_smb_message()
>   ksmbd: add ksmbd_smb2_cur_pdu_buflen()
>   ksmbd: use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
>   ksmbd: check PDU len is at least header plus body size in
>     ksmbd_smb2_check_message()
>   ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
>   ksmdb: make smb2_get_ksmbd_tcon() callable with chained PDUs
>   ksmbd: make smb2_check_user_session() callabe for compound PDUs
>   ksmdb: move session and tcon validation to ksmbd_smb2_check_message()
>
>  fs/ksmbd/auth.c       | 205 ---------------------
>  fs/ksmbd/connection.c |   9 +-
>  fs/ksmbd/crypto_ctx.c |  16 --
>  fs/ksmbd/crypto_ctx.h |   8 -
>  fs/ksmbd/ksmbd_work.h |   1 +
>  fs/ksmbd/oplock.c     |  41 ++++-
>  fs/ksmbd/server.c     |  19 +-
>  fs/ksmbd/smb2misc.c   | 164 ++++++++++-------
>  fs/ksmbd/smb2ops.c    |   5 -
>  fs/ksmbd/smb2pdu.c    | 411 ++++++++++++++++++++++++++++++------------
>  fs/ksmbd/smb2pdu.h    |  11 +-
>  fs/ksmbd/smb_common.c |  68 +++----
>  fs/ksmbd/smb_common.h |   5 +-
>  fs/ksmbd/smbacl.c     |  21 ++-
>  fs/ksmbd/vfs.c        |   2 +-
>  fs/ksmbd/vfs.h        |   2 +-
>  16 files changed, 496 insertions(+), 492 deletions(-)
>
> --
> 2.31.1
>
>
