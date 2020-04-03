Return-Path: <SRS0=FgSA=5T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8ADC2BA15
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Apr 2020 17:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4D5206F6
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Apr 2020 17:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1EHZ+cl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgDCRpv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Apr 2020 13:45:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32998 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404237AbgDCRpu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Apr 2020 13:45:50 -0400
Received: by mail-lj1-f193.google.com with SMTP id f20so7868905ljm.0;
        Fri, 03 Apr 2020 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3OG8lFAEpJ09PZ/amzynXTCfwlvvxyjDXOX5w5FKr+E=;
        b=c1EHZ+clPAWskLmSC3jpCk5UIX7b/XtexdwIcUD9HOrR8CtL/iTql9iWeBCfi256iD
         RllSfX0R8t+mX/Hw8j/25w3jsjKOdSerTOjRBQcUawF/q0GrY8h11x+Nt3d4xmAR34Rk
         0jReMQ0cq+XT0z5phNMO94+HLRB1kkH8ihdMCMSTGqBeEgAQ0TNbK4sObsaGMH04m8hq
         q5sU26F0NNBgpomrExzJGOF36nXHk479xi3z2mIuyA58AEB33efE7blAP7vIXx0KtZEx
         m+HYZ65UvXnzGg9JiauEUEgbDANbPvBvrQgJNgGtmwtHhv5P1nIWHSeW+drzSdOZT7Mp
         DI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3OG8lFAEpJ09PZ/amzynXTCfwlvvxyjDXOX5w5FKr+E=;
        b=H8/fNFOHDS9vWdQkI/+1KMJ92FBJdaD6jq53qZAvk7iKPgbPdDjolO55pibQlbFhvD
         A3hLDC0PzrJzv2ZQVsWEsm+9dHhYdh6jsV/IxxafnvM5B2b1v/ijrAg97UuCvyFaLttW
         bgj/DE3ZOve7B3ef2qecy3NoKglapTc2vvtQNBLh9mCQfnkmXPiwxBtroRrti/oZnGeb
         WyGSQtZoHZKJa9KeeU6PGUgRCa1chX7TUWxSr+XYLkSIH9+dZANILv6qHuBUqhNYD0s0
         53pkycCh24MXqDHI14jJFO8bl///srxW+tfK/z9ez5fYWVc9d0lVify68XecegkNyPbT
         Rqtg==
X-Gm-Message-State: AGi0PuZeH2sLpDXphET0KjZNwld96c8kQeR/ko1RFEZX4l/u9i4fRrUP
        1fzEYEQmg+B4/CCu4ZqRaVuqvgX8baFK0IA/SQ==
X-Google-Smtp-Source: APiQypKswfo9xNyj+/d6s59JkX9q1IJnDbYyFvHL6THRjzlPxz7q8rMYLs+JQ+FvfBscxHdQ7ZPTUdheclnNj16dBb0=
X-Received: by 2002:a2e:94cb:: with SMTP id r11mr5456019ljh.276.1585935946971;
 Fri, 03 Apr 2020 10:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <1585696903-96794-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1585696903-96794-1-git-send-email-longli@linuxonhyperv.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 3 Apr 2020 10:45:35 -0700
Message-ID: <CAKywueRg8kJ+0aOehM-QKGuRwbDSb2TA5vNje8eSCdMqBT+EdQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Allocate crypto structures on the fly for
 calculating signatures of incoming packets
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 31 =D0=BC=D0=B0=D1=80. 2020 =D0=B3. =D0=B2 16:22, <longli@lin=
uxonhyperv.com>:
>
> From: Long Li <longli@microsoft.com>
>
> CIFS uses pre-allocated crypto structures to calculate signatures for bot=
h
> incoming and outgoing packets. In this way it doesn't need to allocate cr=
ypto
> structures for every packet, but it requires a lock to prevent concurrent
> access to crypto structures.
>
> Remove the lock by allocating crypto structures on the fly for
> incoming packets. At the same time, we can still use pre-allocated crypto
> structures for outgoing packets, as they are already protected by transpo=
rt
> lock srv_mutex.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/cifsglob.h      |  3 +-
>  fs/cifs/smb2proto.h     |  6 ++-
>  fs/cifs/smb2transport.c | 87 +++++++++++++++++++++++++----------------
>  3 files changed, 60 insertions(+), 36 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 0d956360e984..7448e7202e7a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -426,7 +426,8 @@ struct smb_version_operations {
>         /* generate new lease key */
>         void (*new_lease_key)(struct cifs_fid *);
>         int (*generate_signingkey)(struct cifs_ses *);
> -       int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *=
);
> +       int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *=
,
> +                               bool allocate_crypto);
>         int (*set_integrity)(const unsigned int, struct cifs_tcon *tcon,
>                              struct cifsFileInfo *src_file);
>         int (*enum_snapshots)(const unsigned int xid, struct cifs_tcon *t=
con,
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 4d1ff7b66fdc..087d5f14320b 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -55,9 +55,11 @@ extern struct cifs_ses *smb2_find_smb_ses(struct TCP_S=
erver_Info *server,
>  extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *serv=
er,
>                                                 __u64 ses_id, __u32  tid)=
;
>  extern int smb2_calc_signature(struct smb_rqst *rqst,
> -                               struct TCP_Server_Info *server);
> +                               struct TCP_Server_Info *server,
> +                               bool allocate_crypto);
>  extern int smb3_calc_signature(struct smb_rqst *rqst,
> -                               struct TCP_Server_Info *server);
> +                               struct TCP_Server_Info *server,
> +                               bool allocate_crypto);
>  extern void smb2_echo_request(struct work_struct *work);
>  extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
>  extern bool smb2_is_valid_oplock_break(char *buffer,
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 08b703b7a15e..c01e19a3b112 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -40,14 +40,6 @@
>  #include "smb2status.h"
>  #include "smb2glob.h"
>
> -static int
> -smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
> -{
> -       return cifs_alloc_hash("hmac(sha256)",
> -                              &server->secmech.hmacsha256,
> -                              &server->secmech.sdeschmacsha256);
> -}
> -
>  static int
>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
>  {
> @@ -219,7 +211,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __=
u64 ses_id, __u32  tid)
>  }
>
>  int
> -smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r)
> +smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *serve=
r,
> +                       bool allocate_crypto)
>  {
>         int rc;
>         unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
> @@ -228,6 +221,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server)
>         struct smb2_sync_hdr *shdr =3D (struct smb2_sync_hdr *)iov[0].iov=
_base;
>         struct cifs_ses *ses;
>         struct shash_desc *shash;
> +       struct crypto_shash *hash;
> +       struct sdesc *sdesc =3D NULL;
>         struct smb_rqst drqst;
>
>         ses =3D smb2_find_smb_ses(server, shdr->SessionId);
> @@ -239,24 +234,32 @@ smb2_calc_signature(struct smb_rqst *rqst, struct T=
CP_Server_Info *server)
>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>         memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>
> -       rc =3D smb2_crypto_shash_allocate(server);
> -       if (rc) {
> -               cifs_server_dbg(VFS, "%s: sha256 alloc failed\n", __func_=
_);
> -               return rc;
> +       if (allocate_crypto) {
> +               rc =3D cifs_alloc_hash("hmac(sha256)", &hash, &sdesc);
> +               if (rc) {
> +                       cifs_server_dbg(VFS,
> +                                       "%s: sha256 alloc failed\n", __fu=
nc__);
> +                       return rc;
> +               }
> +               shash =3D &sdesc->shash;
> +       } else {
> +               hash =3D server->secmech.hmacsha256;
> +               shash =3D &server->secmech.sdeschmacsha256->shash;
>         }

smb2_crypto_shash_allocate() unconditionally allocated
server->secmech.hmacsha256 and server->secmech.sdeschmacsha256->shash.
Now the code doesn't allocate those variables at all. Unlike SMB3
where structures are allocated in during key generation, for SMB2 we
do it on demand in smb2_calc_signature(). So, the code above should be
changed to call smb2_crypto_shash_allocate() in "else" block.

--
Best regards,
Pavel Shilovsky
