Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C34D23DE;
	Sat,  1 Mar 2025 23:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740872803; cv=none; b=tEkCoBCn6VBEsbiW7WCmvYURQX+QvqDB2bcfnzuzv43x7ULsyxfWIL9oTf78xUCNdeQ3yq7pLdTmTZ9NLLt3HJkofJRuONk7d7MuAeuEds5vi/HOzp8B5lqHxzqWsRuEGKgP8VAxAWz7zf82hVwodlTLfNXj1Ry3+nQH3WFJmcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740872803; c=relaxed/simple;
	bh=siOE6IpkHu8CmLrzsx0HF1NUPlP5KTEAkzZCk4d5hwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l1ci1hLqhoJ2ANumcVBc8v61fJsqfXNWCM7kzkLPN/1KuHTo5mmvhjY8Jv2qgylUebCQ94iCigToa+6LJ72j3bX02Pg6NFoW4OdU/xyZau8VttNR5ggdRs9RUAyRr7a8ytM1bvbMJWNx8g7su44vW8e20H6xgd92s8gj3Om0b/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O/Ph5Bxk; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/Ph5Bxk"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-30795988ebeso36201491fa.3;
        Sat, 01 Mar 2025 15:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740872800; x=1741477600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEt2k7989x5yE6ObIXJKt9GP7mYl/bSZRL2jBwszNcI=;
        b=O/Ph5BxkdGLxKdievpvIzxKmgdfnT8iAwUj7m/G2icv0hnQcX//HRxO23ySCbf2L4O
         ZmKFXF8uDzD4WjKSSA4LEtlnW3tymLmtgZowc1Trnx9O1D9xFECSPTcDSI7P29wb7TR8
         YqBdpAlGfyzZQ5l3dycABmYIPPPMStEss2Owi1xYNZTyct6oVtdztupddZcBY/xVVh0H
         G3yDKD7qW4R81bxnQ8eOXrFX48+m940cdRCg++CB3O79enMkfxg02KcomGda7jpu96QM
         ITjD4DQzCX5QmNy25sssyyC0Tsol6mJfRsWCuq9cZzvp6ZST7/L6W76C1biDthV9WwLG
         K94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740872800; x=1741477600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEt2k7989x5yE6ObIXJKt9GP7mYl/bSZRL2jBwszNcI=;
        b=VQju9YB0G0Wbq2DusdjDIDHl5CsP9nTzMN67/RuWhhjo65ZrSgB8LxiR61np3qLkmT
         qPnT3RREVSAG0m7Wt8C7jnah5mIqFpl0vLn6pzISw6ekl66GkJfQLZAsdbSZJpNPm91W
         kS87r31H6ncdvfiykWS4RNfcQ5RBySjUxvmSPpyAv/omX7vGOKs6qtlUedXahp7BpGou
         t2FYsBCifl4k5LryM43wBPHgQhcTbyOw9jLHqUZi3FMm/IwHL2SqpbwAWKfQGAC8iCmk
         dFSNyrx2IC4MR5I/Vj86mvSo/AITu2x/wNfmyhHeW18JTN2PhXFcOUBkKjWBbg8pt3I5
         uB1g==
X-Forwarded-Encrypted: i=1; AJvYcCU1XgrjVZlCkqlsEGhxkF5qy8OvwktMsYNMv3W/fSn7249fdLyIrfFYy6VGcrtPrxlUf9M6CxfQsxRX@vger.kernel.org, AJvYcCW2VzmD3JFXI1pVk7m6g70kl055QYsp8KH+w1tPeDyzRKVkY5tzQDEoXDwXntX9zRVrxnN0WJp/fzXttdSF@vger.kernel.org
X-Gm-Message-State: AOJu0Yx18oys+P+b5enqd+ZmcAgZ4yd9zDWOeS6aCxDIliW8V5W869kY
	i+LJp5GJWqVowco9M4QzkIVHJUg8mIvj4cZ1IUCKyLQby/9mQCqv1FB+g1dWoAAKx8UW8ySJbUE
	TC2kFPKPlXh5EnyUg8vmWhxtJCI8=
X-Gm-Gg: ASbGncu1zlHe6Nsqvxpkrf3iCBCRh6Si327iDY6cR1i+BMnQkiEMXPHQMIElWMF8f7v
	ymPmdFiXP921Ma7GdGtodhPZKRA8TTjHIbNYXn/Y/4zDy4QYfe+IUHp/pUeXZtnDXSBC5IaOVRB
	xVS7xppJvqtqNMd6qk4J5NKtchmuk7uSDkiIexIWQjM9NkB4ItGkH3mPgO3StI
X-Google-Smtp-Source: AGHT+IH6zu7Liq6af25Lvda/e90+Z+oabnotgxoE4Iy77QomhdmjoGpy4haMQrKCrdKzihm2Rn2Ftpv8gaB8oIu5WK0=
X-Received: by 2002:a05:6512:3b0c:b0:549:39ca:13fc with SMTP id
 2adb3069b0e04-5494c39011amr3475943e87.49.1740872799297; Sat, 01 Mar 2025
 15:46:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
In-Reply-To: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 1 Mar 2025 17:46:27 -0600
X-Gm-Features: AQ5f1Jo-TcMpCDd1mt5gInAtB8m-Aq_V5ESxjl_nKowzPsnPgKcByHT332S7fgM
Message-ID: <CAH2r5mstBkj5-aHcXLpb8YzrDHS+nWhW+i_Kf8eJK15sFmJx8A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix netns refcount imbalance causing leaks
 and use-after-free
To: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: tom@talpey.com, kuniyu@amazon.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I was looking at this patch in more detail, and it does look important
but I wanted to clarify a few things.  In your detailed description
you mention that the retry on port 139 is missing a call put_net(0

>         ip_connect
>           generic_ip_connect /* Try port 445 */
>             get_net()
>             ->connect() /* Failed */
>             put_net()
>           generic_ip_connect /* Try port 139 */
>             get_net() /* Missing matching put_net() for this get_net().*/

but I found this confusing because generic_ip_connect() doesn't seem
to treat the port 445 vs. port 139 differently (there are only two
places the function does put_net() and the latter on line 3421 looks
like the only one that matters for your example).  Here is the snippet
from generic_ip_connect().  Could you explain why the retry on port
139 example is different here?

        rc =3D kernel_connect(socket, saddr, slen,
                            server->noblockcnt ? O_NONBLOCK : 0);
        /*
         * When mounting SMB root file systems, we do not want to block in
         * connect. Otherwise bail out and then let cifs_reconnect() perfor=
m
         * reconnect failover - if possible.
         */
        if (server->noblockcnt && rc =3D=3D -EINPROGRESS)
                rc =3D 0;
        if (rc < 0) {
                cifs_dbg(FYI, "Error %d connecting to server\n", rc);
                trace_smb3_connect_err(server->hostname,
server->conn_id, &server->dstaddr, rc);
                put_net(cifs_net_ns(server));
                sock_release(socket);
                server->ssocket =3D NULL;
                return rc;
        }




On Tue, Feb 18, 2025 at 8:34=E2=80=AFAM Wang Zhaolong <wangzhaolong1@huawei=
.com> wrote:
>
> Commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
> namespace.") attempted to fix a netns use-after-free issue by manually
> adjusting reference counts via sk->sk_net_refcnt and sock_inuse_add().
>
> However, a later commit e9f2517a3e18 ("smb: client: fix TCP timers deadlo=
ck
> after rmmod") pointed out that the approach of manually setting
> sk->sk_net_refcnt in the first commit was technically incorrect, as
> sk->sk_net_refcnt should only be set for user sockets. It led to issues
> like TCP timers not being cleared properly on close. The second commit
> moved to a model of just holding an extra netns reference for
> server->ssocket using get_net(), and dropping it when the server is torn
> down.
>
> But there remain some gaps in the get_net()/put_net() balancing added by
> these commits. The incomplete reference handling in these fixes results
> in two issues:
>
> 1. Netns refcount leaks[1]
>
> The problem process is as follows:
>
> ```
> mount.cifs                        cifsd
>
> cifs_do_mount
>   cifs_mount
>     cifs_mount_get_session
>       cifs_get_tcp_session
>         get_net()  /* First get net. */
>         ip_connect
>           generic_ip_connect /* Try port 445 */
>             get_net()
>             ->connect() /* Failed */
>             put_net()
>           generic_ip_connect /* Try port 139 */
>             get_net() /* Missing matching put_net() for this get_net().*/
>       cifs_get_smb_ses
>         cifs_negotiate_protocol
>           smb2_negotiate
>             SMB2_negotiate
>               cifs_send_recv
>                 wait_for_response
>                                  cifs_demultiplex_thread
>                                    cifs_read_from_socket
>                                      cifs_readv_from_socket
>                                        cifs_reconnect
>                                          cifs_abort_connection
>                                            sock_release();
>                                            server->ssocket =3D NULL;
>                                            /* Missing put_net() here. */
>                                            generic_ip_connect
>                                              get_net()
>                                              ->connect() /* Failed */
>                                              put_net()
>                                              sock_release();
>                                              server->ssocket =3D NULL;
>           free_rsp_buf
>     ...
>                                    clean_demultiplex_info
>                                      /* It's only called once here. */
>                                      put_net()
> ```
>
> When cifs_reconnect() is triggered, the server->ssocket is released
> without a corresponding put_net() for the reference acquired in
> generic_ip_connect() before. it ends up calling generic_ip_connect()
> again to retry get_net(). After that, server->ssocket is set to NULL
> in the error path of generic_ip_connect(), and the net count cannot be
> released in the final clean_demultiplex_info() function.
>
> 2. Potential use-after-free
>
> The current refcounting scheme can lead to a potential use-after-free iss=
ue
> in the following scenario:
>
> ```
>  cifs_do_mount
>    cifs_mount
>      cifs_mount_get_session
>        cifs_get_tcp_session
>          get_net()  /* First get net */
>            ip_connect
>              generic_ip_connect
>                get_net()
>                bind_socket
>                  kernel_bind /* failed */
>                put_net()
>          /* after out_err_crypto_release label */
>          put_net()
>          /* after out_err label */
>          put_net()
> ```
>
> In the exception handling process where binding the socket fails, the
> get_net() and put_net() calls are unbalanced, which may cause the
> server->net reference count to drop to zero and be prematurely released.
>
> To address both issues, this patch ties the netns reference counting to
> the server->ssocket and server lifecycles. The extra reference is now
> acquired when the server or socket is created, and released when the
> socket is destroyed or the server is torn down.
>
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D219792
>
> Fixes: ef7134c7fc48 ("smb: client: Fix use-after-free of network namespac=
e.")
> Fixes: e9f2517a3e18 ("smb: client: fix TCP timers deadlock after rmmod")
> Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
> ---
>  fs/smb/client/connect.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index f917de020dd5..0d454149f3b4 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -300,6 +300,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
>                          server->ssocket->flags);
>                 sock_release(server->ssocket);
>                 server->ssocket =3D NULL;
> +               put_net(cifs_net_ns(server));
>         }
>         server->sequence_number =3D 0;
>         server->session_estab =3D false;
> @@ -3115,8 +3116,12 @@ generic_ip_connect(struct TCP_Server_Info *server)
>                 /*
>                  * Grab netns reference for the socket.
>                  *
> -                * It'll be released here, on error, or in clean_demultip=
lex_info() upon server
> -                * teardown.
> +                * This reference will be released in several situations:
> +                * - In the failure path before the cifsd thread is start=
ed.
> +                * - In the all place where server->socket is released, i=
t is
> +                *   also set to NULL.
> +                * - Ultimately in clean_demultiplex_info(), during the f=
inal
> +                *   teardown.
>                  */
>                 get_net(net);
>
> @@ -3132,10 +3137,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
>         }
>
>         rc =3D bind_socket(server);
> -       if (rc < 0) {
> -               put_net(cifs_net_ns(server));
> +       if (rc < 0)
>                 return rc;
> -       }
>
>         /*
>          * Eventually check for other socket options to change from
> @@ -3181,9 +3184,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
>         if (sport =3D=3D htons(RFC1001_PORT))
>                 rc =3D ip_rfc1001_connect(server);
>
> -       if (rc < 0)
> -               put_net(cifs_net_ns(server));
> -
>         return rc;
>  }
>
> --
> 2.34.3
>
>


--=20
Thanks,

Steve
