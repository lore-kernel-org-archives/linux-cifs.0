Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547B0C10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220FE20879
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 23:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YlKi89vN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfDHXKI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:10:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46503 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbfDHXKI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Apr 2019 19:10:08 -0400
Received: by mail-lf1-f66.google.com with SMTP id r25so2185991lfn.13
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2019 16:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Temt0GMLNNVWARfycz21xVwhjs25wZHwf3m+Q56D3V8=;
        b=YlKi89vNVWX0LUgg0NKhGlUt8adaTAUofs/O3dqO3hcuO+m7xBpqkO9CfnCAV56QE4
         YFgWdjtKwnKCNhyUt6BVHf2CCQ2Ok3iOq2hZS99al4083ubAD/v8JI+j1GRuoC8/Q04b
         rhdaV4p9Cujv0a8YxeJWhGf4A4sgMPOEYkrjxCGGPAyTB2wUkRg6WA1txDkkHnYnRFvx
         ZKLeA0r1HJqYorXvIZ35eAtS7NUWY0eeFaRqnQbBXUiZYQPrK0J9ewuLYNHRYXUReBMt
         kU1L8WkYFSKFr1SRDd1tvuHJv9c1wxoDJHAJzLIdDcdYG0E86hbxmgZEB1OqB6+0UQkd
         NQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Temt0GMLNNVWARfycz21xVwhjs25wZHwf3m+Q56D3V8=;
        b=ByarrwX7a4BFwNZmJpnFJYXuiF7dI3Q275yzPtjxbw+SGoa1wQCQby1Ml2CttPvwEj
         suRzHR1innxMKMFNKebGL5cl0u+CyznhABZqfRmnDfnjfdFchNnR2zHfccAd8N9MJawG
         Zg0MseaB78er6eQfpt7JUtsztxI7/cr/9Q67QmnUM9r8iBOk2ssIu5ZVO3wwhKtk/y+s
         Lb7wInZRY4xFBAAsx2TEyrjCQV+x2vX9p18+as1GMe9qJSxREsEmOXwJaN2h8BvsT6LX
         9g+DdpW+FFLe2sZO5006Wr/qPQuDKyJMoKDUyb+ylxDsYB9DpBsTe2eBXmyYPyl6gV15
         iR1A==
X-Gm-Message-State: APjAAAWAU3lzMjlSfIxq50SJkIQFkv33DYlawcD+SecrZbFV3p1iY5+e
        MUG0ScOE+QqOoeqFxaxy4l+ZxksIJk6QHWX9wUnLaPI=
X-Google-Smtp-Source: APXvYqxpPrXPwEb9DTmKZ2MQ7zBj8zxmB+1lgzyBVII0yC5qnJeRLncJKSj4DPo19pqUEcuR1wMcUlf3IUPehR0uM+o=
X-Received: by 2002:a05:6512:248:: with SMTP id b8mr16868102lfo.140.1554765006872;
 Mon, 08 Apr 2019 16:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <1554689950-30863-1-git-send-email-zhangxiaoxu5@huawei.com>
In-Reply-To: <1554689950-30863-1-git-send-email-zhangxiaoxu5@huawei.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 8 Apr 2019 16:09:55 -0700
Message-ID: <CAKywueRqc9s5Np8XdDxHsb8Yz-3ytbzpY8NkJGQPeW_kbXAo9w@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: Fix lease buffer length error
To:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=81, 7 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:15, ZhangXiaoxu =
<zhangxiaoxu5@huawei.com>:
>
> There is a KASAN slab-out-of-bounds:
> BUG: KASAN: slab-out-of-bounds in _copy_from_iter_full+0x783/0xaa0
> Read of size 80 at addr ffff88810c35e180 by task mount.cifs/539
>
> CPU: 1 PID: 539 Comm: mount.cifs Not tainted 4.19 #10
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>             rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  dump_stack+0xdd/0x12a
>  print_address_description+0xa7/0x540
>  kasan_report+0x1ff/0x550
>  check_memory_region+0x2f1/0x310
>  memcpy+0x2f/0x80
>  _copy_from_iter_full+0x783/0xaa0
>  tcp_sendmsg_locked+0x1840/0x4140
>  tcp_sendmsg+0x37/0x60
>  inet_sendmsg+0x18c/0x490
>  sock_sendmsg+0xae/0x130
>  smb_send_kvec+0x29c/0x520
>  __smb_send_rqst+0x3ef/0xc60
>  smb_send_rqst+0x25a/0x2e0
>  compound_send_recv+0x9e8/0x2af0
>  cifs_send_recv+0x24/0x30
>  SMB2_open+0x35e/0x1620
>  open_shroot+0x27b/0x490
>  smb2_open_op_close+0x4e1/0x590
>  smb2_query_path_info+0x2ac/0x650
>  cifs_get_inode_info+0x1058/0x28f0
>  cifs_root_iget+0x3bb/0xf80
>  cifs_smb3_do_mount+0xe00/0x14c0
>  cifs_do_mount+0x15/0x20
>  mount_fs+0x5e/0x290
>  vfs_kern_mount+0x88/0x460
>  do_mount+0x398/0x31e0
>  ksys_mount+0xc6/0x150
>  __x64_sys_mount+0xea/0x190
>  do_syscall_64+0x122/0x590
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> It can be reproduced by the following step:
>   1. samba configured with: server max protocol =3D SMB2_10
>   2. mount -o vers=3Ddefault
>
> When parse the mount version parameter, the 'ops' and 'vals'
> was setted to smb30,  if negotiate result is smb21, just
> update the 'ops' to smb21, but the 'vals' is still smb30.
> When add lease context, the iov_base is allocated with smb21
> ops, but the iov_len is initiallited with the smb30. Because
> the iov_len is longer than iov_base, when send the message,
> copy array out of bounds.
>
> we need to keep the 'ops' and 'vals' consistent.
>
> Fixes: 9764c02fcbad(SMB3: Add support for multidialect negotiate (SMB2.1 =
and later))
> Fixes: d5c7076b772a(smb3: add smb3.1.1 to default dialect list)
>
> cc: stable@vger.kernel.org (v4.14+)
> Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 21ad01d..0f14471 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -832,8 +832,11 @@ SMB2_negotiate(const unsigned int xid, struct cifs_s=
es *ses)
>                 } else if (rsp->DialectRevision =3D=3D cpu_to_le16(SMB21_=
PROT_ID)) {
>                         /* ops set to 3.0 by default for default so updat=
e */
>                         ses->server->ops =3D &smb21_operations;
> -               } else if (rsp->DialectRevision =3D=3D cpu_to_le16(SMB311=
_PROT_ID))
> +                       ses->server->vals =3D &smb21_values;
> +               } else if (rsp->DialectRevision =3D=3D cpu_to_le16(SMB311=
_PROT_ID)) {
>                         ses->server->ops =3D &smb311_operations;
> +                       ses->server->vals =3D &smb311_values;
> +               }
>         } else if (le16_to_cpu(rsp->DialectRevision) !=3D
>                                 ses->server->vals->protocol_id) {
>                 /* if requested single dialect ensure returned dialect ma=
tched */
> --
> 2.7.4
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
