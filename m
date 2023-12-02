Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEsvvC1m"
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB57FD48
	for <linux-cifs@vger.kernel.org>; Fri,  1 Dec 2023 18:28:42 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-50be24167efso709642e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 Dec 2023 18:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701484121; x=1702088921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ep+z8MXUOZgf9MSfl1BQtOPu2WCwWLG/N6q6YM4PoR4=;
        b=BEsvvC1mdYuxEg57M2loYLtQZO4LSW29OvmqAu58qKRxehyeNf2eB8p4msRcD6W8LU
         SjwAOWNtkXv8wjq63kO5VUiVWLXRtYhk2oAz6p6RoJQNdAZKSwRDBoCp5Hk3rmrLtRzP
         XlTC0fmVzbb/lYZk0tyOVD2wjAVcTziXFB9ti+OjNvi8WmdNS/onFe5WLwOQZ98EFH9R
         vQdGVJ4VmKuJd02sc7q287bD/KedBZ5vzaqdzTcADIPEaBgaKT8Nd1GUxhhhSJJD+l7d
         3pqH9ITMuXTatV3jIjrGE84qMiTkKO5hHczIfXOUS99Y5dLa8ijQL0eWBD8+khyEM2nD
         U5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701484121; x=1702088921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ep+z8MXUOZgf9MSfl1BQtOPu2WCwWLG/N6q6YM4PoR4=;
        b=Bnknt8FxYK57858hQVV4+bwF5yEo5KMQibW4sNVS9vNQoYWYuV5GPQ5NHLl0my5xSt
         QtkZN4V20C5gJjPfhnU+FDh5NeFNFD+JpFkmiLJlXJr03OV0nTuwupuHmDzARBOQ/SZi
         bxJVNeJWPPLyL1U/qfmGf/fGsSrOMJ8w0HLzmb2bRZwZhe1k4rzV7FTBOM+beHjDnIUE
         pHARMR32fehYeQxK0FOxbV+QAwCDxv/WaCdg7Ok8KMIqnDlJHuPnElK5pdV2gJjBv5Sb
         9z58y+DcZw2ezu9+EdgSSlAGMceIkE5f8IPLYJZCSXCVrEPefTsGpYitE75NkV46T62h
         KXyw==
X-Gm-Message-State: AOJu0YyQdiErQjDn2J04fR/4b+4rP9cH+YjoQU/ulCkbAHUgo8fZEuzK
	EJz+gMQ2Nlh6csCBKb5wvzDLesCa481E9UMAUEA=
X-Google-Smtp-Source: AGHT+IGnqLPqXtArawFJaKC3MYbZB5QXxlc/VYfsPbdO9H3aWrc7YUXji6HpmQzYzCoYfOeI8AOF1RHVhtDzPotnbSc=
X-Received: by 2002:ac2:5975:0:b0:50b:bf07:5a84 with SMTP id
 h21-20020ac25975000000b0050bbf075a84mr732618lfp.56.1701484120801; Fri, 01 Dec
 2023 18:28:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
 <b8c930087bbe9f2a4771e9b5a007fd0208cd1b6c.1701060106.git.pierre.mariani@gmail.com>
In-Reply-To: <b8c930087bbe9f2a4771e9b5a007fd0208cd1b6c.1701060106.git.pierre.mariani@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 1 Dec 2023 20:28:29 -0600
Message-ID: <CAH2r5mvwhC=Yo6CXeG8VVS+RUb7siCyA6DL3Lo374iQjHJCjaA@mail.gmail.com>
Subject: Re: [PATCH 4/4] smb: client: Fix checkpatch whitespace errors and warnings
To: Pierre Mariani <pierre.mariani@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

patch looks fine other than a trivial checkpatch warning (I corrected).

Although trivial style changes - they look non-controversial and small

$ ./scripts/checkpatch.pl
0001-smb-client-Fix-checkpatch-whitespace-errors-and-warn.patch
WARNING: A patch subject line should describe the change not the tool
that found it
#4:
Subject: [PATCH] smb: client: Fix checkpatch whitespace errors and warnings

total: 0 errors, 1 warnings, 107 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplac=
e.

0001-smb-client-Fix-checkpatch-whitespace-errors-and-warn.patch has
style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

On Sun, Nov 26, 2023 at 10:52=E2=80=AFPM Pierre Mariani
<pierre.mariani@gmail.com> wrote:
>
> Fixes no-op checkpatch errors and warnings.
>
> Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> ---
>  fs/smb/client/connect.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index a381c4cdb8c4..59f95ea5105e 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -482,6 +482,7 @@ static int reconnect_target_unlocked(struct TCP_Serve=
r_Info *server, struct dfs_
>  static int reconnect_dfs_server(struct TCP_Server_Info *server)
>  {
>         struct dfs_cache_tgt_iterator *target_hint =3D NULL;
> +
>         DFS_CACHE_TGT_LIST(tl);
>         int num_targets =3D 0;
>         int rc =3D 0;
> @@ -750,6 +751,7 @@ cifs_read_from_socket(struct TCP_Server_Info *server,=
 char *buf,
>  {
>         struct msghdr smb_msg =3D {};
>         struct kvec iov =3D {.iov_base =3D buf, .iov_len =3D to_read};
> +
>         iov_iter_kvec(&smb_msg.msg_iter, ITER_DEST, &iov, 1, to_read);
>
>         return cifs_readv_from_socket(server, &smb_msg);
> @@ -1400,11 +1402,13 @@ cifs_match_ipaddr(struct sockaddr *srcaddr, struc=
t sockaddr *rhs)
>         case AF_INET: {
>                 struct sockaddr_in *saddr4 =3D (struct sockaddr_in *)srca=
ddr;
>                 struct sockaddr_in *vaddr4 =3D (struct sockaddr_in *)rhs;
> +
>                 return (saddr4->sin_addr.s_addr =3D=3D vaddr4->sin_addr.s=
_addr);
>         }
>         case AF_INET6: {
>                 struct sockaddr_in6 *saddr6 =3D (struct sockaddr_in6 *)sr=
caddr;
>                 struct sockaddr_in6 *vaddr6 =3D (struct sockaddr_in6 *)rh=
s;
> +
>                 return (ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6=
_addr)
>                         && saddr6->sin6_scope_id =3D=3D vaddr6->sin6_scop=
e_id);
>         }
> @@ -2605,8 +2609,8 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_=
context *ctx)
>                         rc =3D -EOPNOTSUPP;
>                         goto out_fail;
>                 } else {
> -                       cifs_dbg(VFS, "Check vers=3D mount option. SMB3.1=
1 "
> -                               "disabled but required for POSIX extensio=
ns\n");
> +                       cifs_dbg(VFS,
> +                               "Check vers=3D mount option. SMB3.11 disa=
bled but required for POSIX extensions\n");
>                         rc =3D -EOPNOTSUPP;
>                         goto out_fail;
>                 }
> @@ -2751,7 +2755,6 @@ cifs_put_tlink(struct tcon_link *tlink)
>         if (!IS_ERR(tlink_tcon(tlink)))
>                 cifs_put_tcon(tlink_tcon(tlink));
>         kfree(tlink);
> -       return;
>  }
>
>  static int
> @@ -2892,6 +2895,7 @@ static inline void
>  cifs_reclassify_socket4(struct socket *sock)
>  {
>         struct sock *sk =3D sock->sk;
> +
>         BUG_ON(!sock_allow_reclassification(sk));
>         sock_lock_init_class_and_name(sk, "slock-AF_INET-CIFS",
>                 &cifs_slock_key[0], "sk_lock-AF_INET-CIFS", &cifs_key[0])=
;
> @@ -2901,6 +2905,7 @@ static inline void
>  cifs_reclassify_socket6(struct socket *sock)
>  {
>         struct sock *sk =3D sock->sk;
> +
>         BUG_ON(!sock_allow_reclassification(sk));
>         sock_lock_init_class_and_name(sk, "slock-AF_INET6-CIFS",
>                 &cifs_slock_key[1], "sk_lock-AF_INET6-CIFS", &cifs_key[1]=
);
> @@ -2935,15 +2940,18 @@ static int
>  bind_socket(struct TCP_Server_Info *server)
>  {
>         int rc =3D 0;
> +
>         if (server->srcaddr.ss_family !=3D AF_UNSPEC) {
>                 /* Bind to the specified local IP address */
>                 struct socket *socket =3D server->ssocket;
> +
>                 rc =3D kernel_bind(socket,
>                                  (struct sockaddr *) &server->srcaddr,
>                                  sizeof(server->srcaddr));
>                 if (rc < 0) {
>                         struct sockaddr_in *saddr4;
>                         struct sockaddr_in6 *saddr6;
> +
>                         saddr4 =3D (struct sockaddr_in *)&server->srcaddr=
;
>                         saddr6 =3D (struct sockaddr_in6 *)&server->srcadd=
r;
>                         if (saddr6->sin6_family =3D=3D AF_INET6)
> @@ -3173,6 +3181,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct =
cifs_tcon *tcon,
>
>         if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
>                 __u64 cap =3D le64_to_cpu(tcon->fsUnixInfo.Capability);
> +
>                 cifs_dbg(FYI, "unix caps which server supports %lld\n", c=
ap);
>                 /*
>                  * check for reconnect case in which we do not
> @@ -3676,7 +3685,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *s=
es,
>         smb_buffer_response =3D smb_buffer;
>
>         header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
> -                       NULL /*no tid */ , 4 /*wct */ );
> +                       NULL /*no tid */, 4 /*wct */);
>
>         smb_buffer->Mid =3D get_next_mid(ses->server);
>         smb_buffer->Uid =3D ses->Suid;
> @@ -3695,12 +3704,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses =
*ses,
>         if (ses->server->sign)
>                 smb_buffer->Flags2 |=3D SMBFLG2_SECURITY_SIGNATURE;
>
> -       if (ses->capabilities & CAP_STATUS32) {
> +       if (ses->capabilities & CAP_STATUS32)
>                 smb_buffer->Flags2 |=3D SMBFLG2_ERR_STATUS;
> -       }
> -       if (ses->capabilities & CAP_DFS) {
> +
> +       if (ses->capabilities & CAP_DFS)
>                 smb_buffer->Flags2 |=3D SMBFLG2_DFS;
> -       }
> +
>         if (ses->capabilities & CAP_UNICODE) {
>                 smb_buffer->Flags2 |=3D SMBFLG2_UNICODE;
>                 length =3D
> --
> 2.39.2
>


--=20
Thanks,

Steve
