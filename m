Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8CFC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 17 May 2022 08:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbiEQIHD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 04:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiEQIHC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 04:07:02 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314ED3B549
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 01:07:01 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u3so23612569wrg.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 01:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xwYln97QAXyLTgIVcpN1MWLVQkFQQYKXmrJ+gQgOUG4=;
        b=LAd8bvmUObzfmQLwB/W0C3TfEspsvsWy7J78gdv0AN3SitF0E4w/iiP5i2lfTWIRes
         JNxN+MwDVhX3GUKdZ6B7ug/pUCmT9nivmwc/kQD1YA+oIg1Zjbak36CXRyro1P28l2VQ
         so9X/DFrKnK9zU6YGRT+UE0VRlHOLeadRoQBjnGFutA9V0qCvPCoBZdlg1xxx+kW0mJN
         JVV/92E3BBQil/BXyGX5eOs7XDA/eCf1v4vB2AiKvsCDuzw6ahWaq5ja4uKnzlbyerby
         IjW31sA0RvcUdHTq6asoYFZKayF7KvL3ITpwyYAJQAvC65DrCHuq6eLqxpRh8K6slHEB
         3jrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xwYln97QAXyLTgIVcpN1MWLVQkFQQYKXmrJ+gQgOUG4=;
        b=S2tmwHYCMLviM23wDdrwiKVSUHfyUhXwoOMfWHckkKFFXFit3ZNSy8kWf7b2mCAsBV
         RQXOegw49TAtPE53sHhTmxeyhXPUFCy5wKfXwnuGz/WjCNCqJeFOTsL51UesT0z8CEX3
         IPTA9BxZxfeDgxyiwnCc7lu9iSQgD+U51cT4rURtnwe4cxo/e380qYZ7QUO11Oy9tqdn
         eYE5IEJnJThAkn7Myb3jo1+QL+ZgocEKYFdrkIPXKVMQdonFFbFVcG85gEKil7gKxnBB
         7nUIViCMduStu6QmW3dyNkMxBvY1916V3vSNN+nTufaYGQ8rXeFs/IMY87IiO24Ts9Wb
         XIEg==
X-Gm-Message-State: AOAM530xu8lqYA8pSg5jUWGHcVbwDl9ECXaNAWFA/tGoDijyP4WqTNNs
        /ztCTEhsKzX58hTuD2tfsyT6aExsVd42GderaHA=
X-Google-Smtp-Source: ABdhPJz+YHHJaL3OARcIQxBKCWQd34BlJ1uSTMPA8Gl67hE1G4bhA09ctf+j+eo5YdrGXN/GwW2s7KGSOazJn4Y9nCA=
X-Received: by 2002:a5d:6f16:0:b0:20c:60f8:c17 with SMTP id
 ay22-20020a5d6f16000000b0020c60f80c17mr18013819wrb.322.1652774819623; Tue, 17
 May 2022 01:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220516074140.28522-1-linkinjeon@kernel.org> <20220516074140.28522-2-linkinjeon@kernel.org>
In-Reply-To: <20220516074140.28522-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 17 May 2022 17:06:48 +0900
Message-ID: <CANFS6bapdwPQCaSciVQT4pScYA1wMk3QchNEfpc_PcbfpWhH1w@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: add smbd max io size parameter
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 5=EC=9B=94 16=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 4:42, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Add 'smbd max io size' parameter to adjust smbd-direct max read/write
> size.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/ksmbd_netlink.h  | 3 ++-
>  fs/ksmbd/transport_ipc.c  | 3 +++
>  fs/ksmbd/transport_rdma.c | 8 +++++++-
>  fs/ksmbd/transport_rdma.h | 6 ++++++
>  4 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
> index ebe6ca08467a..52aa0adeb951 100644
> --- a/fs/ksmbd/ksmbd_netlink.h
> +++ b/fs/ksmbd/ksmbd_netlink.h
> @@ -104,7 +104,8 @@ struct ksmbd_startup_request {
>                                          */
>         __u32   sub_auth[3];            /* Subauth value for Security ID =
*/
>         __u32   smb2_max_credits;       /* MAX credits */
> -       __u32   reserved[128];          /* Reserved room */
> +       __u32   smbd_max_io_size;       /* smbd read write size */
> +       __u32   reserved[127];          /* Reserved room */
>         __u32   ifc_list_sz;            /* interfaces list size */
>         __s8    ____payload[];
>  };
> diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
> index 3ad6881e0f7e..7cb0eeb07c80 100644
> --- a/fs/ksmbd/transport_ipc.c
> +++ b/fs/ksmbd/transport_ipc.c
> @@ -26,6 +26,7 @@
>  #include "mgmt/ksmbd_ida.h"
>  #include "connection.h"
>  #include "transport_tcp.h"
> +#include "transport_rdma.h"
>
>  #define IPC_WAIT_TIMEOUT       (2 * HZ)
>
> @@ -303,6 +304,8 @@ static int ipc_server_config_on_startup(struct ksmbd_=
startup_request *req)
>                 init_smb2_max_trans_size(req->smb2_max_trans);
>         if (req->smb2_max_credits)
>                 init_smb2_max_credits(req->smb2_max_credits);
> +       if (req->smbd_max_io_size)
> +               init_smbd_max_io_size(req->smbd_max_io_size);
>
>         ret =3D ksmbd_set_netbios_name(req->netbios_name);
>         ret |=3D ksmbd_set_server_string(req->server_string);
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 19a605fd46ff..6d652ff38b82 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size =3D 1024=
 * 1024;
>  /*  The maximum single-message size which can be received */
>  static int smb_direct_max_receive_size =3D 8192;
>
> -static int smb_direct_max_read_write_size =3D 8 * 1024 * 1024;
> +static int smb_direct_max_read_write_size =3D SMBD_DEFAULT_IOSIZE;
>
>  static LIST_HEAD(smb_direct_device_list);
>  static DEFINE_RWLOCK(smb_direct_device_lock);
> @@ -214,6 +214,12 @@ struct smb_direct_rdma_rw_msg {
>         struct scatterlist      sg_list[];
>  };
>
> +void init_smbd_max_io_size(unsigned int sz)
> +{
> +       sz =3D clamp_val(sz, SMBD_MIN_IOSIZE, SMBD_MAX_IOSIZE);
> +       smb_direct_max_read_write_size =3D sz;
> +}
> +
>  static inline int get_buf_page_count(void *buf, int size)
>  {
>         return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
> diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
> index 5567d93a6f96..e7b4e6790fab 100644
> --- a/fs/ksmbd/transport_rdma.h
> +++ b/fs/ksmbd/transport_rdma.h
> @@ -7,6 +7,10 @@
>  #ifndef __KSMBD_TRANSPORT_RDMA_H__
>  #define __KSMBD_TRANSPORT_RDMA_H__
>
> +#define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
> +#define SMBD_MIN_IOSIZE (512 * 1024)
> +#define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
> +
>  /* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
>  struct smb_direct_negotiate_req {
>         __le16 min_version;
> @@ -52,10 +56,12 @@ struct smb_direct_data_transfer {
>  int ksmbd_rdma_init(void);
>  void ksmbd_rdma_destroy(void);
>  bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
> +void init_smbd_max_io_size(unsigned int sz);
>  #else
>  static inline int ksmbd_rdma_init(void) { return 0; }
>  static inline int ksmbd_rdma_destroy(void) { return 0; }
>  static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) =
{ return false; }
> +static inline void init_smbd_max_io_size(unsigned int sz) { }
>  #endif
>
>  #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
