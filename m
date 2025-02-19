Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F561C28E;
	Wed, 19 Feb 2025 03:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739935051; cv=none; b=abSCSUEP82AebRxX97WaSel4eujPljIN1GD1523c+ov9T8UEpQ8ZIkA0osZPbwcfATZzdqHxVvUamP/i3IG8V7JOHl7kCAPrXwEfWIAYDK29A/TzCevc4e0q/7uARJqqSB5595zNze8n0mTSU8tjPR2s7Rhbalb+8BpXV6WsoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739935051; c=relaxed/simple;
	bh=kRstVrCBGadJFHvcL2lUoAiH6OZkdZ4S3h4M6Zip3d0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EnhbtipDMULd8iTMH3uaFwiEHtSfaJgNe7tCk51nJXamsiM3qnf+USf5CYgnn6GADZJk1uOQqo3EH1NFkd6t3iATQp7obsbQ4lM5YXNjtJ8Kn5ncpbt8kILMh74EOZcup1VXdsyBm7Yh/Gk3LNSikt8NCjWV/WiQhl6asi/wuSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxTWzQV8; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxTWzQV8"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-546237cd3cbso2877914e87.0;
        Tue, 18 Feb 2025 19:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739935047; x=1740539847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jc4SK/ypNCa99TVOhf7iBOOIGMc5Da5lSQe8phr48Xs=;
        b=BxTWzQV81p3RfNxnYLe0/UfDPJh5qp5sutLs7OVqFe2vjLLzoXuy+6jVHjVVj7Kvgj
         1mix6viRpAAXkKSv+xL6FkD1Moo3UmjVbq2Bxg79P56yo7stacmwnC8TjNfFx020BhBg
         XF1q+3P6EjDHEKNd/JWny0FAHshKbnUE4rxAe+orZxzvYHhvIOvhNHFSd5isqiYjsSs8
         9aw5MSKXEe+D5cilQh6wf7+t3QU3t0ekYsLp3m6dErds+1ig5rt0JqkGpQSopV3zFuaP
         tBDpDTL4DAfZR2wHu39nQLev8CnxX+HiiDQQbx27tjfWHRwsOo2U8GH1ZSnKYJqarwdV
         0jtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739935047; x=1740539847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jc4SK/ypNCa99TVOhf7iBOOIGMc5Da5lSQe8phr48Xs=;
        b=XgHEyqInP9XuSVagNpAO/xPTXiquz/j0rk24l04YQ8n8cqlK7CftrcJm1S+diAkRr8
         zL7PmWPYzslAIhBNSmRla6acvCtWIqhsLBLgdHWqfr9P0P7PsV411Rtvm8b+EEMoqJNs
         xxwkX47sOgYM8crHds/lu3HDCK0ASu8prHKbXcRK6j+yOmETcdkXfrR4sQAZBGcLTNTR
         WXRrOmXoVS7cIuxrr9KyZZYN7hB9wJN3JUgBXuvEVdZrHzoEoFy9BLlHTi2tJarbg83D
         GadObM6Sp+UwaTHOwwn9nucB75DsgkgQPR3kxEOZiaVG0z/rMLWx915YYuvp/OmdBPw/
         M2sg==
X-Forwarded-Encrypted: i=1; AJvYcCU0X+N3BO7xWAlnIh/krcwjBXeQSwVXb6WUPHi9yVUfYbVa69p07FH8mz4ub1Jwa29Z6TKX5GUFZqDIIRJF@vger.kernel.org, AJvYcCWmkirloqf+yqzj4vEo3krvJSX29omVOspmJGtqSRYxMw7wlJSfe8naT65ySA2jBTY4+aBMaCMTwzWf@vger.kernel.org
X-Gm-Message-State: AOJu0YyLR3Q3I715NMbMTbZzjbIJ49Ty6zLonFvEKOgZu22Klbk4H67W
	4FXPN4ggWrMp6KTyl7QjVrIKqc1Vs3PjthRqhpvonmxysG8JHa0XPa3lp/gt7+qxrR+oCj+V0+L
	RmeE3L/fE4C5RSW5KJ17NaOFOibQ=
X-Gm-Gg: ASbGncvA7EJMZV1fqMwzmu/TKOpM1E/LmvgxcfOM7drTVrg59pw9MI7NOEcVqk+XEX5
	/R8nJ6XFdIRpxFlEZW+/c/ogm4FFvSonwpHBSJPoP4H3pvRIlSli9/o/kaNs4kTHKc6abzZtC
X-Google-Smtp-Source: AGHT+IFxJKGoclyOJjJQxX5v3qAXVEZ4JcKs4mqMuZtRGmhXeYroTfnfqhFdOjjnfblR/oqQiOeSRw5To3nWTm10HdU=
X-Received: by 2002:a05:6512:3990:b0:545:1d04:5dfc with SMTP id
 2adb3069b0e04-5452fe90435mr4628863e87.38.1739935047105; Tue, 18 Feb 2025
 19:17:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
In-Reply-To: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 18 Feb 2025 21:17:15 -0600
X-Gm-Features: AWEUYZmHf1Ug11Hrb9rbPCwDczurfuOKWwK8qHukZXVFHorFtEfwStWz1SD7sbE
Message-ID: <CAH2r5muqxgPy=n4Aks_k-2goEZmmD10Dx3u3jgOk-LZ=-CHU9Q@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix netns refcount imbalance causing leaks
 and use-after-free
To: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: sfrench@samba.org, tom@talpey.com, kuniyu@amazon.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more review and testi=
ng

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
