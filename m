Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A813510A1C
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dSS+TDUA"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50e7b51b0ceso3492032e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703848796; x=1704453596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRHD7+eveERIT8vkmKrl70k+OujOJSAeP5ggkjr4fBw=;
        b=dSS+TDUAghKjyO702N/+eW3EINuWyu/hWbBQ3r9bLM6CiQu+kth2LpXPU8Gk7QoRqg
         FFQch4YNtIRquMmHMl7oKdgr4ZzytS4CgO/1B6tDZderkK9i7h1ql1dxHLYJ5GJDjc/I
         lQYTyFfMMSkAsfq9QrNLXcUx9UToLs+pgHUojFB893MPmnOhsS5qRFay8HBFNf5DQYZc
         uyZuccRWJJptuFeX24MJMMED6JR42xOMH//hm2XWDMpdxldp7uURBF96gFFklUdG6y2F
         wONyG8eecYN9zvU8lodkx8QHMnJLmVNXVbsL9AtEfXFZ8zdWHHO1ngB7LSMCsjUlkBa4
         DDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703848796; x=1704453596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRHD7+eveERIT8vkmKrl70k+OujOJSAeP5ggkjr4fBw=;
        b=v3iEQlwX+veLpzRmHigdw04U7Yia5Cu01JqOY+Y3NmQucXUyLyaw+ssaI+qiqA2EMz
         VHncW60K7OyIGtyTr+BBFygAn7UdWAKNX3XI8hT0xaKwC/VPau9vBpD2cO7tM7f+4gSG
         V1EBqqswSGY3qWLWkDudf4PmtDISjx/Qkhm7TdoIayT7I/CDJNStwAqG3wtt1kMmVSE7
         EJpQpzAklSctg9Fp5k0ZesnXIX5E3WVWYGAtwrXpm301iSNmJ3G9qDjCmEQ2YgFiVLSo
         Wq5Wn/CbaQLxlTWyIwGizv5A44HZOW0x//Z+uqlIXG//f4Nx2CLVHp/uOPNkhsRUTwNF
         gSgA==
X-Gm-Message-State: AOJu0YzmK/mZ4p4DGB3fvA1MiIy0uOX0l+0tH30BGD3X2VcstL8pDASj
	QaYBvfz2UDmL8huEB8tkZSW8KJV5oIF/xqC/+I4=
X-Google-Smtp-Source: AGHT+IGSHxZlT4xWDYPAjT+lolFKkhxEpjj45TRqRb0XZLylzZA3NwkzD2qTnSFYcPX+VyOKBO0uT+wDm3+B2GHlU3g=
X-Received: by 2002:ac2:4da4:0:b0:50e:7bbf:f365 with SMTP id
 h4-20020ac24da4000000b0050e7bbff365mr3629411lfe.31.1703848796008; Fri, 29 Dec
 2023 03:19:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229111618.38887-1-sprasad@microsoft.com> <20231229111618.38887-2-sprasad@microsoft.com>
In-Reply-To: <20231229111618.38887-2-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 29 Dec 2023 16:49:44 +0530
Message-ID: <CANT5p=rjbLTmPz73PnF4FNMTJ6+KAJ9yodLy5PjTuOZ+ueOxyg@mail.gmail.com>
Subject: Re: [PATCH 2/4] cifs: do not depend on release_iface for maintaining iface_list
To: smfrench@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2023 at 4:46=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> parse_server_interfaces should be in complete charge of maintaining
> the iface_list linked list. Today, iface entries are removed
> from the list only when the last refcount is dropped.
> i.e. in release_iface. However, this can result in undercounting
> of refcount if the server stops advertising interfaces (which
> Azure SMB server does).
>
> This change puts parse_server_interfaces in full charge of
> maintaining the iface_list. So if an empty list is returned
> by the server, the entries in the list will immediately be
> removed. This way, a following call to the same function will
> not find entries in the list.
>
> Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked=
 list")
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h |  1 -
>  fs/smb/client/smb2ops.c  | 27 +++++++++++++++++----------
>  2 files changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index ba80c854c9ca..f840756e0169 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1014,7 +1014,6 @@ release_iface(struct kref *ref)
>         struct cifs_server_iface *iface =3D container_of(ref,
>                                                        struct cifs_server=
_iface,
>                                                        refcount);
> -       list_del_init(&iface->iface_head);
>         kfree(iface);
>  }
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 104c58df0368..b813485c0e86 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -595,16 +595,12 @@ parse_server_interfaces(struct network_interface_in=
fo_ioctl_rsp *buf,
>         }
>
>         /*
> -        * Go through iface_list and do kref_put to remove
> -        * any unused ifaces. ifaces in use will be removed
> -        * when the last user calls a kref_put on it
> +        * Go through iface_list and mark them as inactive
>          */
>         list_for_each_entry_safe(iface, niface, &ses->iface_list,
> -                                iface_head) {
> +                                iface_head)
>                 iface->is_active =3D 0;
> -               kref_put(&iface->refcount, release_iface);
> -               ses->iface_count--;
> -       }
> +
>         spin_unlock(&ses->iface_lock);
>
>         /*
> @@ -678,10 +674,7 @@ parse_server_interfaces(struct network_interface_inf=
o_ioctl_rsp *buf,
>                                          iface_head) {
>                         ret =3D iface_cmp(iface, &tmp_iface);
>                         if (!ret) {
> -                               /* just get a ref so that it doesn't get =
picked/freed */
>                                 iface->is_active =3D 1;
> -                               kref_get(&iface->refcount);
> -                               ses->iface_count++;
>                                 spin_unlock(&ses->iface_lock);
>                                 goto next_iface;
>                         } else if (ret < 0) {
> @@ -748,6 +741,20 @@ parse_server_interfaces(struct network_interface_inf=
o_ioctl_rsp *buf,
>         }
>
>  out:
> +       /*
> +        * Go through the list again and put the inactive entries
> +        */
> +       spin_lock(&ses->iface_lock);
> +       list_for_each_entry_safe(iface, niface, &ses->iface_list,
> +                                iface_head) {
> +               if (!iface->is_active) {
> +                       list_del(&iface->iface_head);
> +                       kref_put(&iface->refcount, release_iface);
> +                       ses->iface_count--;
> +               }
> +       }
> +       spin_unlock(&ses->iface_lock);
> +
>         return rc;
>  }
>
> --
> 2.34.1
>
Hi Steve..
This one should also be marked for stable. I missed tagging it before I sen=
t.

--=20
Regards,
Shyam
