Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CBEC00140
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 13:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiHHNGR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 09:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiHHNGQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 09:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C5BD53
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 06:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 892DC611D6
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 13:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBBEC433C1
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 13:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659963972;
        bh=Xq/d93F2ilyEBBgxwWoGIscKk73En2ZMLPjFYCOwBtc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=M0OTpqa9H8eUeGXZFu5N9tRo0GGhGWt06HXY9kKnaQ9s9R7gbqXR8yeAzoqyeckE4
         qBNZmoITbCGkh0hJRTleqbXVdKC+Q9GPvZJ6h6smBmaAC3K4Z9Qb0tLfxDlFG7ynUT
         1QkNToGglm3hFx5cKnBoG6U//dYdq6fB4rgy8iT9WTj73wh/rBxE77kWyYvD3iErAx
         6jkhgleq3txMqNQ0+slhmnEH6D6FpQT99j73LROqwh3qD5oqU5QEla/2UuBRvb9K15
         a3Vt+cqhteROZ3dkDeJ7DcxvG2+Q4iEpdbJONJzZt+DG26OWQDMPFND+Z69Wrf7UjI
         b3pA/enxN13Rw==
Received: by mail-ot1-f42.google.com with SMTP id a14-20020a0568300b8e00b0061c4e3eb52aso6437210otv.3
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 06:06:11 -0700 (PDT)
X-Gm-Message-State: ACgBeo0lUQWpm9ppOwCcp+OPBV+o0e2sxeZ49Kr7o7AnqvLrDQAy6R2Q
        JapDu5Gv23sW7B6D5B0rsIJ39NjiLV/TyUdrsJY=
X-Google-Smtp-Source: AA6agR5NMUIoG9FILO6bZ+44Y1nWXxrbwGJEsGrpB9GCSbnzO0ONY/VgyiuKfqHHggKNflmRd7J4AcpqrUoe3PJF0Rw=
X-Received: by 2002:a9d:7519:0:b0:636:d935:ee8e with SMTP id
 r25-20020a9d7519000000b00636d935ee8emr2690799otk.339.1659963970958; Mon, 08
 Aug 2022 06:06:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 8 Aug 2022 06:06:10
 -0700 (PDT)
In-Reply-To: <CANFS6bZMD-E-7C4Bjkkpnxzb-32oB7d2AHEySDOau9Yomz_RgQ@mail.gmail.com>
References: <20220808024341.63913-1-atteh.mailbox@gmail.com> <CANFS6bZMD-E-7C4Bjkkpnxzb-32oB7d2AHEySDOau9Yomz_RgQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 8 Aug 2022 22:06:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd81Dh2ypXAEdqZ-veteWJUk-Fe6CECu9U=3T0-r5iM+yw@mail.gmail.com>
Message-ID: <CAKYAXd81Dh2ypXAEdqZ-veteWJUk-Fe6CECu9U=3T0-r5iM+yw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: request update to stale share config
To:     Hyunchul Lee <hyc.lee@gmail.com>, atheik <atteh.mailbox@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-08 13:57 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Hello atheik,
>
> 2022=EB=85=84 8=EC=9B=94 8=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 11:47,=
 atheik <atteh.mailbox@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> ksmbd_share_config_get() retrieves the cached share config as long
>> as there is at least one connection to the share. This is an issue when
>> the user space utilities are used to update share configs. In that case
>> there is a need to inform ksmbd that it should not use the cached share
>> config for a new connection to the share. With these changes the tree
>> connection flag KSMBD_TREE_CONN_FLAG_UPDATE indicates this. When this
>> flag is set, ksmbd removes the share config from the shares hash table
>> meaning that ksmbd_share_config_get() ends up requesting a share config
>> from user space.
>>
>> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
>> ---
>>  ksmbd_netlink.h     |  2 ++
>>  mgmt/share_config.c |  6 +++++-
>>  mgmt/share_config.h |  1 +
>>  mgmt/tree_connect.c | 14 ++++++++++++++
>>  4 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/ksmbd_netlink.h b/ksmbd_netlink.h
>> index 192cb13..5d77b72 100644
>> --- a/ksmbd_netlink.h
>> +++ b/ksmbd_netlink.h
>> @@ -349,6 +349,7 @@ enum KSMBD_TREE_CONN_STATUS {
>>  #define KSMBD_SHARE_FLAG_STREAMS               BIT(11)
>>  #define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS       BIT(12)
>>  #define KSMBD_SHARE_FLAG_ACL_XATTR             BIT(13)
>> +#define KSMBD_SHARE_FLAG_UPDATE                BIT(14)
>>
>>  /*
>>   * Tree connect request flags.
>> @@ -364,6 +365,7 @@ enum KSMBD_TREE_CONN_STATUS {
>>  #define KSMBD_TREE_CONN_FLAG_READ_ONLY         BIT(1)
>>  #define KSMBD_TREE_CONN_FLAG_WRITABLE          BIT(2)
>>  #define KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT     BIT(3)
>> +#define KSMBD_TREE_CONN_FLAG_UPDATE            BIT(4)
>>
>>  /*
>>   * RPC over IPC.
>> diff --git a/mgmt/share_config.c b/mgmt/share_config.c
>> index 70655af..c9bca1c 100644
>> --- a/mgmt/share_config.c
>> +++ b/mgmt/share_config.c
>> @@ -51,12 +51,16 @@ static void kill_share(struct ksmbd_share_config
>> *share)
>>         kfree(share);
>>  }
>>
>> -void __ksmbd_share_config_put(struct ksmbd_share_config *share)
>> +void ksmbd_share_config_del(struct ksmbd_share_config *share)
>>  {
>>         down_write(&shares_table_lock);
>>         hash_del(&share->hlist);
>>         up_write(&shares_table_lock);
>> +}
>>
>> +void __ksmbd_share_config_put(struct ksmbd_share_config *share)
>> +{
>> +       ksmbd_share_config_del(share);
>>         kill_share(share);
>>  }
>>
>> diff --git a/mgmt/share_config.h b/mgmt/share_config.h
>> index 28bf351..902f2cb 100644
>> --- a/mgmt/share_config.h
>> +++ b/mgmt/share_config.h
>> @@ -64,6 +64,7 @@ static inline int test_share_config_flag(struct
>> ksmbd_share_config *share,
>>         return share->flags & flag;
>>  }
>>
>> +void ksmbd_share_config_del(struct ksmbd_share_config *share);
>>  void __ksmbd_share_config_put(struct ksmbd_share_config *share);
>>
>>  static inline void ksmbd_share_config_put(struct ksmbd_share_config
>> *share)
>> diff --git a/mgmt/tree_connect.c b/mgmt/tree_connect.c
>> index 7d467e1..0cf6265 100644
>> --- a/mgmt/tree_connect.c
>> +++ b/mgmt/tree_connect.c
>> @@ -65,6 +65,20 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, stru=
ct
>> ksmbd_session *sess,
>>         }
>>
>>         tree_conn->flags =3D resp->connection_flags;
>> +       if (test_tree_conn_flag(tree_conn, KSMBD_TREE_CONN_FLAG_UPDATE))
>> {
>> +               struct ksmbd_share_config *new_sc;
>> +
>> +               ksmbd_share_config_del(sc);
>> +               new_sc =3D ksmbd_share_config_get(share_name);
>> +               if (!new_sc) {
>> +                       pr_err("Failed to update stale share config\n");
>> +                       status.ret =3D -ESTALE;
>
> We need to set proper rsp->hdr.Status for ESTALE in smb2_tree_connect,
> otherwise
> ksmbd will send a response with STATUS_ACCESS_DENIED for this error.
We can return STATUS_BAD_NETWORK_NAME instead of STATUS_ACCESS_DENIED.

atheik, you can update the below change to your patch. and you need to
create the patch on the latest linux kernel source, not out of tree
ksmbd.

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index d478c3ea4215..233069a37500 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1944,6 +1944,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
                rsp->hdr.Status =3D STATUS_SUCCESS;
                rc =3D 0;
                break;
+       case -ESTALE:
        case -ENOENT:
        case KSMBD_TREE_CONN_STATUS_NO_SHARE:
                rsp->hdr.Status =3D STATUS_BAD_NETWORK_NAME;

>
>> +                       goto out_error;
>> +               }
>> +               ksmbd_share_config_put(sc);
>> +               sc =3D new_sc;
>> +       }
>> +
>>         tree_conn->user =3D sess->user;
>>         tree_conn->share_conf =3D sc;
>>         status.tree_conn =3D tree_conn;
>> --
>> 2.37.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
