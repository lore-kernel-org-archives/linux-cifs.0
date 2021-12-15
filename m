Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E39C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 22:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhLOWfT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhLOWfS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 17:35:18 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D6EC061574
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 14:35:18 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id w23so43711437uao.5
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 14:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lQjtxor3rlf/wgvvFRBR4BLwhTfScP5EpBQqTkXMIOo=;
        b=Km+31grjx2xo9PbwpH8Sf1hxjRkEI83BwJKNkgRr5+F1YP70YKJj5EIvA7eNkSahPP
         eZW46CPkOH18h3/ecmfHZ2m/tWzhM+sCy4QMkOTmxwOYSlfqET6jJOIgNH5mVay+m1w3
         lhe0eMPWH1q85AyGRmcsUYPGiGUYvlMWJIZ3eUIzY1juJZmcIwGd/MrF/RlFEbXSZCIN
         IUUpN1ANltWj6UAwe2LG4VyoV3SJyOpN2KZoedy/c6JPTQdrYCDuYZ5rqBKYpakgWnmv
         wxa/DFdrXjUvnxtn74QpCL+bR6S1jhe2Aes9ixpCbAsZc4p/k6tY11ptzH63T1kF7dPq
         RBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lQjtxor3rlf/wgvvFRBR4BLwhTfScP5EpBQqTkXMIOo=;
        b=7WBUFTafs3twpYEusjZ09QA1rluhHDSNnvRPlsHiamwURGornuG2SNw7tnlhMc6C0r
         akFRLR7TSRRJvHIL9l4vO6pSmar6J0NHhZtqu7eXrdfYEs9BkPjgUpmSAElKbuxoA/Jl
         bmX7o49eDlp74BEk4E/Y1ZsYYwobb6vr0z6hSga5xl8E2ttA3QJhTnbWVZ6R2Ye8DZAE
         FhPd1CicKt5HeFze1/SBhEyWjj0pe/zPHo8BhK9OOZNsptTiLeoNcuCRgxKogI8XAGCt
         vnvhN/Is6aIOvyX1ydr/QPC/b0hbRuY+WyhYl8R56GxAsfRbwfMgHomqkV7by1IBCitB
         wUJA==
X-Gm-Message-State: AOAM533f+rBmCAfygrB8W1V9Umq58JAocfCc5LDBPpEBtrt4XlqTRFTh
        I3wetQ0n2OvYXFLrvJtNCtWI5S4SP183jiz4QO5YptqpW/U=
X-Google-Smtp-Source: ABdhPJwgMY++vb0R0rDmJdOA1sH8QmmcxndMaWVc5DontGuWoORe270hktwYgPNdxbv3RbjOrhlZJMEAeNzx08dBgxI=
X-Received: by 2002:a05:6102:2922:: with SMTP id cz34mr4567991vsb.56.1639607717693;
 Wed, 15 Dec 2021 14:35:17 -0800 (PST)
MIME-Version: 1.0
References: <20211215060206.8048-1-linkinjeon@kernel.org> <20211215060206.8048-3-linkinjeon@kernel.org>
In-Reply-To: <20211215060206.8048-3-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 16 Dec 2021 07:35:06 +0900
Message-ID: <CANFS6bZEf5FBQLoF_JgfGy3cVxMaMSA1tUxRo__6-_r12KF5ow@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd: fix multi session connection failure
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ziwei Xie <zw.xie@high-flyer.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 12=EC=9B=94 16=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 4:46, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> When RSS mode is enable, windows client do simultaneously send several
> session requests to server. There is racy issue using
> sess->ntlmssp.cryptkey on N connection : 1 session. So authetication
> failed using wrong cryptkey on some session. This patch move cryptkey
> to ksmbd_conn structure to use each cryptkey on connection.
>
> Tested-by: Ziwei Xie <zw.xie@high-flyer.cn>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/auth.c              | 27 ++++++++++++++-------------
>  fs/ksmbd/auth.h              | 10 +++++-----
>  fs/ksmbd/connection.h        |  7 +------
>  fs/ksmbd/mgmt/user_session.h |  1 -
>  fs/ksmbd/smb2pdu.c           |  8 ++++----
>  5 files changed, 24 insertions(+), 29 deletions(-)
>
> diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
> index 3503b1c48cb4..dc3d061edda9 100644
> --- a/fs/ksmbd/auth.c
> +++ b/fs/ksmbd/auth.c
> @@ -215,7 +215,7 @@ static int calc_ntlmv2_hash(struct ksmbd_session *ses=
s, char *ntlmv2_hash,
>   * Return:     0 on success, error number on error
>   */
>  int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *nt=
lmv2,
> -                     int blen, char *domain_name)
> +                     int blen, char *domain_name, char *cryptkey)
>  {
>         char ntlmv2_hash[CIFS_ENCPWD_SIZE];
>         char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
> @@ -256,7 +256,7 @@ int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, str=
uct ntlmv2_resp *ntlmv2,
>                 goto out;
>         }
>
> -       memcpy(construct, sess->ntlmssp.cryptkey, CIFS_CRYPTO_KEY_SIZE);
> +       memcpy(construct, cryptkey, CIFS_CRYPTO_KEY_SIZE);
>         memcpy(construct + CIFS_CRYPTO_KEY_SIZE, &ntlmv2->blob_signature,=
 blen);
>
>         rc =3D crypto_shash_update(CRYPTO_HMACMD5(ctx), construct, len);
> @@ -295,7 +295,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, str=
uct ntlmv2_resp *ntlmv2,
>   * Return:     0 on success, error number on error
>   */
>  int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob=
,
> -                                  int blob_len, struct ksmbd_session *se=
ss)
> +                                  int blob_len, struct ksmbd_conn *conn,
> +                                  struct ksmbd_session *sess)
>  {
>         char *domain_name;
>         unsigned int nt_off, dn_off;
> @@ -324,7 +325,7 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticat=
e_message *authblob,
>
>         /* TODO : use domain name that imported from configuration file *=
/
>         domain_name =3D smb_strndup_from_utf16((const char *)authblob + d=
n_off,
> -                                            dn_len, true, sess->conn->lo=
cal_nls);
> +                                            dn_len, true, conn->local_nl=
s);
>         if (IS_ERR(domain_name))
>                 return PTR_ERR(domain_name);
>
> @@ -333,7 +334,7 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticat=
e_message *authblob,
>                     domain_name);
>         ret =3D ksmbd_auth_ntlmv2(sess, (struct ntlmv2_resp *)((char *)au=
thblob + nt_off),
>                                 nt_len - CIFS_ENCPWD_SIZE,
> -                               domain_name);
> +                               domain_name, conn->ntlmssp.cryptkey);
>         kfree(domain_name);
>         return ret;
>  }
> @@ -347,7 +348,7 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticat=
e_message *authblob,
>   *
>   */
>  int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
> -                                 int blob_len, struct ksmbd_session *ses=
s)
> +                                 int blob_len, struct ksmbd_conn *conn)
>  {
>         if (blob_len < sizeof(struct negotiate_message)) {
>                 ksmbd_debug(AUTH, "negotiate blob len %d too small\n",
> @@ -361,7 +362,7 @@ int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_me=
ssage *negblob,
>                 return -EINVAL;
>         }
>
> -       sess->ntlmssp.client_flags =3D le32_to_cpu(negblob->NegotiateFlag=
s);
> +       conn->ntlmssp.client_flags =3D le32_to_cpu(negblob->NegotiateFlag=
s);
>         return 0;
>  }
>
> @@ -375,14 +376,14 @@ int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_=
message *negblob,
>   */
>  unsigned int
>  ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
> -                                  struct ksmbd_session *sess)
> +                                  struct ksmbd_conn *conn)
>  {
>         struct target_info *tinfo;
>         wchar_t *name;
>         __u8 *target_name;
>         unsigned int flags, blob_off, blob_len, type, target_info_len =3D=
 0;
>         int len, uni_len, conv_len;
> -       int cflags =3D sess->ntlmssp.client_flags;
> +       int cflags =3D conn->ntlmssp.client_flags;
>
>         memcpy(chgblob->Signature, NTLMSSP_SIGNATURE, 8);
>         chgblob->MessageType =3D NtLmChallenge;
> @@ -403,7 +404,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_m=
essage *chgblob,
>         if (cflags & NTLMSSP_REQUEST_TARGET)
>                 flags |=3D NTLMSSP_REQUEST_TARGET;
>
> -       if (sess->conn->use_spnego &&
> +       if (conn->use_spnego &&
>             (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
>                 flags |=3D NTLMSSP_NEGOTIATE_EXTENDED_SEC;
>
> @@ -414,7 +415,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_m=
essage *chgblob,
>                 return -ENOMEM;
>
>         conv_len =3D smb_strtoUTF16((__le16 *)name, ksmbd_netbios_name(),=
 len,
> -                                 sess->conn->local_nls);
> +                                 conn->local_nls);
>         if (conv_len < 0 || conv_len > len) {
>                 kfree(name);
>                 return -EINVAL;
> @@ -430,8 +431,8 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_m=
essage *chgblob,
>         chgblob->TargetName.BufferOffset =3D cpu_to_le32(blob_off);
>
>         /* Initialize random conn challenge */
> -       get_random_bytes(sess->ntlmssp.cryptkey, sizeof(__u64));
> -       memcpy(chgblob->Challenge, sess->ntlmssp.cryptkey,
> +       get_random_bytes(conn->ntlmssp.cryptkey, sizeof(__u64));
> +       memcpy(chgblob->Challenge, conn->ntlmssp.cryptkey,
>                CIFS_CRYPTO_KEY_SIZE);
>
>         /* Add Target Information to security buffer */
> diff --git a/fs/ksmbd/auth.h b/fs/ksmbd/auth.h
> index 9c2d4badd05d..95629651cf26 100644
> --- a/fs/ksmbd/auth.h
> +++ b/fs/ksmbd/auth.h
> @@ -38,16 +38,16 @@ struct kvec;
>  int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
>                         unsigned int nvec, int enc);
>  void ksmbd_copy_gss_neg_header(void *buf);
> -int ksmbd_auth_ntlm(struct ksmbd_session *sess, char *pw_buf);
>  int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *nt=
lmv2,
> -                     int blen, char *domain_name);
> +                     int blen, char *domain_name, char *cryptkey);
>  int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob=
,
> -                                  int blob_len, struct ksmbd_session *se=
ss);
> +                                  int blob_len, struct ksmbd_conn *conn,
> +                                  struct ksmbd_session *sess);
>  int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
> -                                 int blob_len, struct ksmbd_session *ses=
s);
> +                                 int blob_len, struct ksmbd_conn *conn);
>  unsigned int
>  ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
> -                                  struct ksmbd_session *sess);
> +                                  struct ksmbd_conn *conn);
>  int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
>                             int in_len, char *out_blob, int *out_len);
>  int ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec =
*iov,
> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> index e5403c587a58..72dfd155b5bf 100644
> --- a/fs/ksmbd/connection.h
> +++ b/fs/ksmbd/connection.h
> @@ -72,12 +72,7 @@ struct ksmbd_conn {
>         int                             connection_type;
>         struct ksmbd_stats              stats;
>         char                            ClientGUID[SMB2_CLIENT_GUID_SIZE]=
;
> -       union {
> -               /* pending trans request table */
> -               struct trans_state      *recent_trans;
> -               /* Used by ntlmssp */
> -               char                    *ntlmssp_cryptkey;
> -       };
> +       struct ntlmssp_auth             ntlmssp;
>
>         spinlock_t                      llist_lock;
>         struct list_head                lock_list;
> diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
> index 82289c3cbd2b..e241f16a3851 100644
> --- a/fs/ksmbd/mgmt/user_session.h
> +++ b/fs/ksmbd/mgmt/user_session.h
> @@ -45,7 +45,6 @@ struct ksmbd_session {
>         int                             state;
>         __u8                            *Preauth_HashValue;
>
> -       struct ntlmssp_auth             ntlmssp;
>         char                            sess_key[CIFS_KEY_SIZE];
>
>         struct hlist_node               hlist;
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 4f938f038a65..68e5773b5b19 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1282,7 +1282,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
>         int sz, rc;
>
>         ksmbd_debug(SMB, "negotiate phase\n");
> -       rc =3D ksmbd_decode_ntlmssp_neg_blob(negblob, negblob_len, work->=
sess);
> +       rc =3D ksmbd_decode_ntlmssp_neg_blob(negblob, negblob_len, work->=
conn);
>         if (rc)
>                 return rc;
>
> @@ -1292,7 +1292,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
>         memset(chgblob, 0, sizeof(struct challenge_message));
>
>         if (!work->conn->use_spnego) {
> -               sz =3D ksmbd_build_ntlmssp_challenge_blob(chgblob, work->=
sess);
> +               sz =3D ksmbd_build_ntlmssp_challenge_blob(chgblob, work->=
conn);
>                 if (sz < 0)
>                         return -ENOMEM;
>
> @@ -1308,7 +1308,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
>                 return -ENOMEM;
>
>         chgblob =3D (struct challenge_message *)neg_blob;
> -       sz =3D ksmbd_build_ntlmssp_challenge_blob(chgblob, work->sess);
> +       sz =3D ksmbd_build_ntlmssp_challenge_blob(chgblob, work->conn);
>         if (sz < 0) {
>                 rc =3D -ENOMEM;
>                 goto out;
> @@ -1450,7 +1450,7 @@ static int ntlm_authenticate(struct ksmbd_work *wor=
k)
>
>                 authblob =3D user_authblob(conn, req);
>                 sz =3D le16_to_cpu(req->SecurityBufferLength);
> -               rc =3D ksmbd_decode_ntlmssp_auth_blob(authblob, sz, sess)=
;
> +               rc =3D ksmbd_decode_ntlmssp_auth_blob(authblob, sz, conn,=
 sess);
>                 if (rc) {
>                         set_user_flag(sess->user, KSMBD_USER_FLAG_BAD_PAS=
SWORD);
>                         ksmbd_debug(SMB, "authentication failed\n");
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
