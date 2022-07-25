Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5230C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 00:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGYA4z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 20:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGYA4z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 20:56:55 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE92FDF2C
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:56:52 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g2so5833116wru.3
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=idSNzVygtVMxiUuN4bcWrhvmn56mz0LwNJfsW6xyknE=;
        b=bInmPFP4gqpfI2Ybo6kegfOWqMc7wAGBO4Y/Le12bnBEfGu9epCy/Qw6VYsan8iPDE
         5FwlncCGtA9zjAEfvTJiceLETBAPEArE6DPqAJPIdpDCLlR8XzUX5LNY6OycGeDbYCtu
         RkANQR7vv8N8jV33XIDpZdnyWIDP4KZB36iO0Z5YZnttafNQfkzYmZOHtz3VfWMG8n4i
         /YS0Vcj8jv7cxxmnP2Q7NX7KBX3Bxnw2OXta8wKt8+J1gnBxYCpFcx9z6m4i60JNwxq+
         P8M9azJwjPXrgzi7UuOJRKj+gPcRq9uJoayPV2kyBko+/9b9zw3IdmBK7E8cSM7Hn3if
         ryuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=idSNzVygtVMxiUuN4bcWrhvmn56mz0LwNJfsW6xyknE=;
        b=nBgiGMXV62+bjHTUtdMhT1DbfGb2mTKVlC7meby3sSuUk0VHxT/FvbctsJ86y2wPSD
         /qlvnRBYb7a4moYwPkcAYEfT6lqpW04derSY3R3qxLjZ12ugtM+JT2DZYUXyZMUKFQy3
         XznzmsPhQV2THlYpo+BwBIDih+aIiZ7beguwHDoNN0KCXx97XtoOAwHvRvH1ytnR7/CU
         uJ/j90IvjptEijuszO33/PlsHaaTxaQpcp7j7BShtrBdvV+NIgcGJH0/IYU2dVvPkFri
         L24mCtLwyvEW1Oyj04AGH0YdCbrfRBlDOhcYgeUlzd7He1ZBBa8HYtuGot1/3atHw4oB
         VfQQ==
X-Gm-Message-State: AJIora9EPxrCsoZOW7YgUgAfghE6hlPpdUmv5DcHS+7pW+5LlLdrq2e9
        N1fMqrutyOoG5Mun66BEPyBDdfkGWn2uIM472hA=
X-Google-Smtp-Source: AGRyM1vse26XHyFdkyg3AH1SwLqJPsH0ws5uKfqbX/vtsilgiYhxqO4mAkWlh3S4gox+DlRYSh6C8em5A1Gme/y6GBU=
X-Received: by 2002:a05:6000:1f0d:b0:21e:927e:d440 with SMTP id
 bv13-20020a0560001f0d00b0021e927ed440mr82748wrb.621.1658710611014; Sun, 24
 Jul 2022 17:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220722030346.28534-1-linkinjeon@kernel.org> <20220722030346.28534-5-linkinjeon@kernel.org>
In-Reply-To: <20220722030346.28534-5-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Jul 2022 09:56:39 +0900
Message-ID: <CANFS6bZw3x5xD61gB=ztg1PmN+C97aZUG0Se4-ZNKzLxG3H4oA@mail.gmail.com>
Subject: Re: [PATCH 5/5] ksmbd: fix racy issue while destroying session on multichannel
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 7=EC=9B=94 22=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:04, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> After multi-channel connection with windows, Several channels of
> session are connected. Among them, if there is a problem in one channel,
> Windows connects again after disconnecting the channel. In this process,
> the session is released and a kernel oop can occurs while processing
> requests to other channels. When the channel is disconnected, if other
> channels still exist in the session after deleting the channel from
> the channel list in the session, the session should not be released.
> Finally, the session will be released after all channels are disconnected=
.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/auth.c              | 56 ++++++++++++++++-------------
>  fs/ksmbd/auth.h              | 11 +++---
>  fs/ksmbd/connection.h        |  7 ----
>  fs/ksmbd/mgmt/tree_connect.c |  5 +--
>  fs/ksmbd/mgmt/tree_connect.h |  4 ++-
>  fs/ksmbd/mgmt/user_session.c | 68 ++++++++++++++++++++++++------------
>  fs/ksmbd/mgmt/user_session.h |  7 ++--
>  fs/ksmbd/oplock.c            | 11 +++---
>  fs/ksmbd/smb2pdu.c           | 21 +++++------
>  fs/ksmbd/smb_common.h        |  2 +-
>  fs/ksmbd/vfs.c               |  3 +-
>  fs/ksmbd/vfs_cache.c         |  2 +-
>  12 files changed, 111 insertions(+), 86 deletions(-)
>
> diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
> index 911444d21267..c5a5c7b90d72 100644
> --- a/fs/ksmbd/auth.c
> +++ b/fs/ksmbd/auth.c
> @@ -121,8 +121,8 @@ static int ksmbd_gen_sess_key(struct ksmbd_session *s=
ess, char *hash,
>         return rc;
>  }
>
> -static int calc_ntlmv2_hash(struct ksmbd_session *sess, char *ntlmv2_has=
h,
> -                           char *dname)
> +static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_sessio=
n *sess,
> +                           char *ntlmv2_hash, char *dname)
>  {
>         int ret, len, conv_len;
>         wchar_t *domain =3D NULL;
> @@ -158,7 +158,7 @@ static int calc_ntlmv2_hash(struct ksmbd_session *ses=
s, char *ntlmv2_hash,
>         }
>
>         conv_len =3D smb_strtoUTF16(uniname, user_name(sess->user), len,
> -                                 sess->conn->local_nls);
> +                                 conn->local_nls);
>         if (conv_len < 0 || conv_len > len) {
>                 ret =3D -EINVAL;
>                 goto out;
> @@ -182,7 +182,7 @@ static int calc_ntlmv2_hash(struct ksmbd_session *ses=
s, char *ntlmv2_hash,
>         }
>
>         conv_len =3D smb_strtoUTF16((__le16 *)domain, dname, len,
> -                                 sess->conn->local_nls);
> +                                 conn->local_nls);
>         if (conv_len < 0 || conv_len > len) {
>                 ret =3D -EINVAL;
>                 goto out;
> @@ -215,8 +215,9 @@ static int calc_ntlmv2_hash(struct ksmbd_session *ses=
s, char *ntlmv2_hash,
>   *
>   * Return:     0 on success, error number on error
>   */
> -int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *nt=
lmv2,
> -                     int blen, char *domain_name, char *cryptkey)
> +int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *ses=
s,
> +                     struct ntlmv2_resp *ntlmv2, int blen, char *domain_=
name,
> +                     char *cryptkey)
>  {
>         char ntlmv2_hash[CIFS_ENCPWD_SIZE];
>         char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
> @@ -230,7 +231,7 @@ int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, str=
uct ntlmv2_resp *ntlmv2,
>                 return -ENOMEM;
>         }
>
> -       rc =3D calc_ntlmv2_hash(sess, ntlmv2_hash, domain_name);
> +       rc =3D calc_ntlmv2_hash(conn, sess, ntlmv2_hash, domain_name);
>         if (rc) {
>                 ksmbd_debug(AUTH, "could not get v2 hash rc %d\n", rc);
>                 goto out;
> @@ -333,7 +334,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticat=
e_message *authblob,
>         /* process NTLMv2 authentication */
>         ksmbd_debug(AUTH, "decode_ntlmssp_authenticate_blob dname%s\n",
>                     domain_name);
> -       ret =3D ksmbd_auth_ntlmv2(sess, (struct ntlmv2_resp *)((char *)au=
thblob + nt_off),
> +       ret =3D ksmbd_auth_ntlmv2(conn, sess,
> +                               (struct ntlmv2_resp *)((char *)authblob +=
 nt_off),
>                                 nt_len - CIFS_ENCPWD_SIZE,
>                                 domain_name, conn->ntlmssp.cryptkey);
>         kfree(domain_name);
> @@ -659,8 +661,9 @@ struct derivation {
>         bool binding;
>  };
>
> -static int generate_key(struct ksmbd_session *sess, struct kvec label,
> -                       struct kvec context, __u8 *key, unsigned int key_=
size)
> +static int generate_key(struct ksmbd_conn *conn, struct ksmbd_session *s=
ess,
> +                       struct kvec label, struct kvec context, __u8 *key=
,
> +                       unsigned int key_size)
>  {
>         unsigned char zero =3D 0x0;
>         __u8 i[4] =3D {0, 0, 0, 1};
> @@ -720,8 +723,8 @@ static int generate_key(struct ksmbd_session *sess, s=
truct kvec label,
>                 goto smb3signkey_ret;
>         }
>
> -       if (sess->conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM ||
> -           sess->conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM)
> +       if (conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM ||
> +           conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM)
>                 rc =3D crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, =
4);
>         else
>                 rc =3D crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, =
4);
> @@ -756,17 +759,17 @@ static int generate_smb3signingkey(struct ksmbd_ses=
sion *sess,
>         if (!chann)
>                 return 0;
>
> -       if (sess->conn->dialect >=3D SMB30_PROT_ID && signing->binding)
> +       if (conn->dialect >=3D SMB30_PROT_ID && signing->binding)
>                 key =3D chann->smb3signingkey;
>         else
>                 key =3D sess->smb3signingkey;
>
> -       rc =3D generate_key(sess, signing->label, signing->context, key,
> +       rc =3D generate_key(conn, sess, signing->label, signing->context,=
 key,
>                           SMB3_SIGN_KEY_SIZE);
>         if (rc)
>                 return rc;
>
> -       if (!(sess->conn->dialect >=3D SMB30_PROT_ID && signing->binding)=
)
> +       if (!(conn->dialect >=3D SMB30_PROT_ID && signing->binding))
>                 memcpy(chann->smb3signingkey, key, SMB3_SIGN_KEY_SIZE);
>
>         ksmbd_debug(AUTH, "dumping generated AES signing keys\n");
> @@ -820,30 +823,31 @@ struct derivation_twin {
>         struct derivation decryption;
>  };
>
> -static int generate_smb3encryptionkey(struct ksmbd_session *sess,
> +static int generate_smb3encryptionkey(struct ksmbd_conn *conn,
> +                                     struct ksmbd_session *sess,
>                                       const struct derivation_twin *ptwin=
)
>  {
>         int rc;
>
> -       rc =3D generate_key(sess, ptwin->encryption.label,
> +       rc =3D generate_key(conn, sess, ptwin->encryption.label,
>                           ptwin->encryption.context, sess->smb3encryption=
key,
>                           SMB3_ENC_DEC_KEY_SIZE);
>         if (rc)
>                 return rc;
>
> -       rc =3D generate_key(sess, ptwin->decryption.label,
> +       rc =3D generate_key(conn, sess, ptwin->decryption.label,
>                           ptwin->decryption.context,
>                           sess->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE)=
;
>         if (rc)
>                 return rc;
>
>         ksmbd_debug(AUTH, "dumping generated AES encryption keys\n");
> -       ksmbd_debug(AUTH, "Cipher type   %d\n", sess->conn->cipher_type);
> +       ksmbd_debug(AUTH, "Cipher type   %d\n", conn->cipher_type);
>         ksmbd_debug(AUTH, "Session Id    %llu\n", sess->id);
>         ksmbd_debug(AUTH, "Session Key   %*ph\n",
>                     SMB2_NTLMV2_SESSKEY_SIZE, sess->sess_key);
> -       if (sess->conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM ||
> -           sess->conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM) {
> +       if (conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM ||
> +           conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM) {
>                 ksmbd_debug(AUTH, "ServerIn Key  %*ph\n",
>                             SMB3_GCM256_CRYPTKEY_SIZE, sess->smb3encrypti=
onkey);
>                 ksmbd_debug(AUTH, "ServerOut Key %*ph\n",
> @@ -857,7 +861,8 @@ static int generate_smb3encryptionkey(struct ksmbd_se=
ssion *sess,
>         return 0;
>  }
>
> -int ksmbd_gen_smb30_encryptionkey(struct ksmbd_session *sess)
> +int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
> +                                 struct ksmbd_session *sess)
>  {
>         struct derivation_twin twin;
>         struct derivation *d;
> @@ -874,10 +879,11 @@ int ksmbd_gen_smb30_encryptionkey(struct ksmbd_sess=
ion *sess)
>         d->context.iov_base =3D "ServerIn ";
>         d->context.iov_len =3D 10;
>
> -       return generate_smb3encryptionkey(sess, &twin);
> +       return generate_smb3encryptionkey(conn, sess, &twin);
>  }
>
> -int ksmbd_gen_smb311_encryptionkey(struct ksmbd_session *sess)
> +int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
> +                                  struct ksmbd_session *sess)
>  {
>         struct derivation_twin twin;
>         struct derivation *d;
> @@ -894,7 +900,7 @@ int ksmbd_gen_smb311_encryptionkey(struct ksmbd_sessi=
on *sess)
>         d->context.iov_base =3D sess->Preauth_HashValue;
>         d->context.iov_len =3D 64;
>
> -       return generate_smb3encryptionkey(sess, &twin);
> +       return generate_smb3encryptionkey(conn, sess, &twin);
>  }
>
>  int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
> diff --git a/fs/ksmbd/auth.h b/fs/ksmbd/auth.h
> index 95629651cf26..25b772653de0 100644
> --- a/fs/ksmbd/auth.h
> +++ b/fs/ksmbd/auth.h
> @@ -38,8 +38,9 @@ struct kvec;
>  int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
>                         unsigned int nvec, int enc);
>  void ksmbd_copy_gss_neg_header(void *buf);
> -int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *nt=
lmv2,
> -                     int blen, char *domain_name, char *cryptkey);
> +int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *ses=
s,
> +                     struct ntlmv2_resp *ntlmv2, int blen, char *domain_=
name,
> +                     char *cryptkey);
>  int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob=
,
>                                    int blob_len, struct ksmbd_conn *conn,
>                                    struct ksmbd_session *sess);
> @@ -58,8 +59,10 @@ int ksmbd_gen_smb30_signingkey(struct ksmbd_session *s=
ess,
>                                struct ksmbd_conn *conn);
>  int ksmbd_gen_smb311_signingkey(struct ksmbd_session *sess,
>                                 struct ksmbd_conn *conn);
> -int ksmbd_gen_smb30_encryptionkey(struct ksmbd_session *sess);
> -int ksmbd_gen_smb311_encryptionkey(struct ksmbd_session *sess);
> +int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
> +                                 struct ksmbd_session *sess);
> +int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
> +                                  struct ksmbd_session *sess);
>  int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
>                                      __u8 *pi_hash);
>  int ksmbd_gen_sd_hash(struct ksmbd_conn *conn, char *sd_buf, int len,
> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> index 2e4730457c92..e7f7d5707951 100644
> --- a/fs/ksmbd/connection.h
> +++ b/fs/ksmbd/connection.h
> @@ -20,13 +20,6 @@
>
>  #define KSMBD_SOCKET_BACKLOG           16
>
> -/*
> - * WARNING
> - *
> - * This is nothing but a HACK. Session status should move to channel
> - * or to session. As of now we have 1 tcp_conn : 1 ksmbd_session, but
> - * we need to change it to 1 tcp_conn : N ksmbd_sessions.
> - */
>  enum {
>         KSMBD_SESS_NEW =3D 0,
>         KSMBD_SESS_GOOD,
> diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
> index 0d28e723a28c..b35ea6a6abc5 100644
> --- a/fs/ksmbd/mgmt/tree_connect.c
> +++ b/fs/ksmbd/mgmt/tree_connect.c
> @@ -16,7 +16,8 @@
>  #include "user_session.h"
>
>  struct ksmbd_tree_conn_status
> -ksmbd_tree_conn_connect(struct ksmbd_session *sess, char *share_name)
> +ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *s=
ess,
> +                       char *share_name)
>  {
>         struct ksmbd_tree_conn_status status =3D {-EINVAL, NULL};
>         struct ksmbd_tree_connect_response *resp =3D NULL;
> @@ -41,7 +42,7 @@ ksmbd_tree_conn_connect(struct ksmbd_session *sess, cha=
r *share_name)
>                 goto out_error;
>         }
>
> -       peer_addr =3D KSMBD_TCP_PEER_SOCKADDR(sess->conn);
> +       peer_addr =3D KSMBD_TCP_PEER_SOCKADDR(conn);
>         resp =3D ksmbd_ipc_tree_connect_request(sess,
>                                               sc,
>                                               tree_conn,
> diff --git a/fs/ksmbd/mgmt/tree_connect.h b/fs/ksmbd/mgmt/tree_connect.h
> index 18e2a996e0aa..71e50271dccf 100644
> --- a/fs/ksmbd/mgmt/tree_connect.h
> +++ b/fs/ksmbd/mgmt/tree_connect.h
> @@ -12,6 +12,7 @@
>
>  struct ksmbd_share_config;
>  struct ksmbd_user;
> +struct ksmbd_conn;
>
>  struct ksmbd_tree_connect {
>         int                             id;
> @@ -40,7 +41,8 @@ static inline int test_tree_conn_flag(struct ksmbd_tree=
_connect *tree_conn,
>  struct ksmbd_session;
>
>  struct ksmbd_tree_conn_status
> -ksmbd_tree_conn_connect(struct ksmbd_session *sess, char *share_name);
> +ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *s=
ess,
> +                       char *share_name);
>
>  int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
>                                struct ksmbd_tree_connect *tree_conn);
> diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
> index b9acb6770b03..ce32fdd66807 100644
> --- a/fs/ksmbd/mgmt/user_session.c
> +++ b/fs/ksmbd/mgmt/user_session.c
> @@ -151,9 +151,6 @@ void ksmbd_session_destroy(struct ksmbd_session *sess=
)
>         if (!sess)
>                 return;
>
> -       if (!atomic_dec_and_test(&sess->refcnt))
> -               return;
> -
>         down_write(&sessions_table_lock);
>         hash_del(&sess->hlist);
>         up_write(&sessions_table_lock);
> @@ -184,16 +181,59 @@ static struct ksmbd_session *__session_lookup(unsig=
ned long long id)
>  int ksmbd_session_register(struct ksmbd_conn *conn,
>                            struct ksmbd_session *sess)
>  {
> -       sess->conn =3D conn;
> +       sess->dialect =3D conn->dialect;
> +       memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)=
;
>         return xa_err(xa_store(&conn->sessions, sess->id, sess, GFP_KERNE=
L));
>  }
>
> +static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session=
 *sess)
> +{
> +       struct channel *chann, *tmp;
> +
> +       write_lock(&sess->chann_lock);
> +       list_for_each_entry_safe(chann, tmp, &sess->ksmbd_chann_list,
> +                                chann_list) {
> +               if (chann->conn =3D=3D conn) {
> +                       list_del(&chann->chann_list);
> +                       kfree(chann);
> +                       write_unlock(&sess->chann_lock);
> +                       return 0;
> +               }
> +       }
> +       write_unlock(&sess->chann_lock);
> +
> +       return -ENOENT;
> +}
> +

Can we delete free_channel_list() because ksmbd_sessions_deregister()
frees all channels by this function.

>  void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
>  {
>         struct ksmbd_session *sess;
> -       unsigned long id;
>
> -       xa_for_each(&conn->sessions, id, sess) {
> +       if (conn->binding) {
> +               struct hlist_node *tmp;
> +               int bkt;
> +
> +               down_write(&sessions_table_lock);
> +               hash_for_each_safe(sessions_table, bkt, tmp, sess, hlist)=
 {

I think hash_for_each is enough instead of hash_for_each_safe.

> +                       if (!ksmbd_chann_del(conn, sess)) {
> +                               up_write(&sessions_table_lock);
> +                               goto sess_destroy;
> +                       }
> +               }
> +               up_write(&sessions_table_lock);
> +       } else {
> +               unsigned long id;
> +
> +               xa_for_each(&conn->sessions, id, sess) {
> +                       if (!ksmbd_chann_del(conn, sess))
> +                               goto sess_destroy;
> +               }
> +       }
> +
> +       return;
> +
> +sess_destroy:
> +       if (list_empty(&sess->ksmbd_chann_list)) {
>                 xa_erase(&conn->sessions, sess->id);
>                 ksmbd_session_destroy(sess);
>         }
> @@ -205,27 +245,12 @@ struct ksmbd_session *ksmbd_session_lookup(struct k=
smbd_conn *conn,
>         return xa_load(&conn->sessions, id);
>  }
>
> -int get_session(struct ksmbd_session *sess)
> -{
> -       return atomic_inc_not_zero(&sess->refcnt);
> -}
> -
> -void put_session(struct ksmbd_session *sess)
> -{
> -       if (atomic_dec_and_test(&sess->refcnt))
> -               pr_err("get/%s seems to be mismatched.", __func__);
> -}
> -
>  struct ksmbd_session *ksmbd_session_lookup_slowpath(unsigned long long i=
d)
>  {
>         struct ksmbd_session *sess;
>
>         down_read(&sessions_table_lock);
>         sess =3D __session_lookup(id);
> -       if (sess) {
> -               if (!get_session(sess))
> -                       sess =3D NULL;
> -       }
>         up_read(&sessions_table_lock);
>
>         return sess;
> @@ -306,7 +331,6 @@ static struct ksmbd_session *__session_create(int pro=
tocol)
>         INIT_LIST_HEAD(&sess->ksmbd_chann_list);
>         INIT_LIST_HEAD(&sess->rpc_handle_list);
>         sess->sequence_number =3D 1;
> -       atomic_set(&sess->refcnt, 1);
>         rwlock_init(&sess->chann_lock);
>
>         switch (protocol) {
> diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
> index 1ec659f0151b..8934b8ee275b 100644
> --- a/fs/ksmbd/mgmt/user_session.h
> +++ b/fs/ksmbd/mgmt/user_session.h
> @@ -33,8 +33,10 @@ struct preauth_session {
>  struct ksmbd_session {
>         u64                             id;
>
> +       __u16                           dialect;
> +       char                            ClientGUID[SMB2_CLIENT_GUID_SIZE]=
;
> +
>         struct ksmbd_user               *user;
> -       struct ksmbd_conn               *conn;
>         unsigned int                    sequence_number;
>         unsigned int                    flags;
>
> @@ -59,7 +61,6 @@ struct ksmbd_session {
>         __u8                            smb3signingkey[SMB3_SIGN_KEY_SIZE=
];
>
>         struct ksmbd_file_table         file_table;
> -       atomic_t                        refcnt;
>  };
>
>  static inline int test_session_flag(struct ksmbd_session *sess, int bit)
> @@ -100,6 +101,4 @@ void ksmbd_release_tree_conn_id(struct ksmbd_session =
*sess, int id);
>  int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name);
>  void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id);
>  int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id);
> -int get_session(struct ksmbd_session *sess);
> -void put_session(struct ksmbd_session *sess);
>  #endif /* __USER_SESSION_MANAGEMENT_H__ */
> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> index 9bb4fb8b80de..ce4c15c3554d 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -30,6 +30,7 @@ static DEFINE_RWLOCK(lease_list_lock);
>  static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
>                                         u64 id, __u16 Tid)
>  {
> +       struct ksmbd_conn *conn =3D work->conn;
>         struct ksmbd_session *sess =3D work->sess;
>         struct oplock_info *opinfo;
>
> @@ -38,7 +39,7 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_wo=
rk *work,
>                 return NULL;
>
>         opinfo->sess =3D sess;
> -       opinfo->conn =3D sess->conn;
> +       opinfo->conn =3D conn;
>         opinfo->level =3D SMB2_OPLOCK_LEVEL_NONE;
>         opinfo->op_state =3D OPLOCK_STATE_NONE;
>         opinfo->pending_break =3D 0;
> @@ -971,7 +972,7 @@ int find_same_lease_key(struct ksmbd_session *sess, s=
truct ksmbd_inode *ci,
>         }
>
>         list_for_each_entry(lb, &lease_table_list, l_entry) {
> -               if (!memcmp(lb->client_guid, sess->conn->ClientGUID,
> +               if (!memcmp(lb->client_guid, sess->ClientGUID,
>                             SMB2_CLIENT_GUID_SIZE))
>                         goto found;
>         }
> @@ -987,7 +988,7 @@ int find_same_lease_key(struct ksmbd_session *sess, s=
truct ksmbd_inode *ci,
>                 rcu_read_unlock();
>                 if (opinfo->o_fp->f_ci =3D=3D ci)
>                         goto op_next;
> -               err =3D compare_guid_key(opinfo, sess->conn->ClientGUID,
> +               err =3D compare_guid_key(opinfo, sess->ClientGUID,
>                                        lctx->lease_key);
>                 if (err) {
>                         err =3D -EINVAL;
> @@ -1121,7 +1122,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int r=
eq_op_level, u64 pid,
>                 struct oplock_info *m_opinfo;
>
>                 /* is lease already granted ? */
> -               m_opinfo =3D same_client_has_lease(ci, sess->conn->Client=
GUID,
> +               m_opinfo =3D same_client_has_lease(ci, sess->ClientGUID,
>                                                  lctx);
>                 if (m_opinfo) {
>                         copy_lease(m_opinfo, opinfo);
> @@ -1239,7 +1240,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *=
work, struct ksmbd_file *fp,
>  {
>         struct oplock_info *op, *brk_op;
>         struct ksmbd_inode *ci;
> -       struct ksmbd_conn *conn =3D work->sess->conn;
> +       struct ksmbd_conn *conn =3D work->conn;
>
>         if (!test_share_config_flag(work->tcon->share_conf,
>                                     KSMBD_SHARE_FLAG_OPLOCKS))
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index ae5677a66cb2..1f4f2d5217a6 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -603,12 +603,9 @@ static void destroy_previous_session(struct ksmbd_co=
nn *conn,
>         if (!prev_user ||
>             strcmp(user->name, prev_user->name) ||
>             user->passkey_sz !=3D prev_user->passkey_sz ||
> -           memcmp(user->passkey, prev_user->passkey, user->passkey_sz)) =
{
> -               put_session(prev_sess);
> +           memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
>                 return;
> -       }
>
> -       put_session(prev_sess);
>         prev_sess->state =3D SMB2_SESSION_EXPIRED;
>         write_lock(&prev_sess->chann_lock);
>         list_for_each_entry(chann, &prev_sess->ksmbd_chann_list, chann_li=
st)
> @@ -1499,7 +1496,7 @@ static int ntlm_authenticate(struct ksmbd_work *wor=
k)
>
>         if (smb3_encryption_negotiated(conn) &&
>                         !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
> -               rc =3D conn->ops->generate_encryptionkey(sess);
> +               rc =3D conn->ops->generate_encryptionkey(conn, sess);
>                 if (rc) {
>                         ksmbd_debug(SMB,
>                                         "SMB3 encryption key generation f=
ailed\n");
> @@ -1590,7 +1587,7 @@ static int krb5_authenticate(struct ksmbd_work *wor=
k)
>                 sess->sign =3D true;
>
>         if (smb3_encryption_negotiated(conn)) {
> -               retval =3D conn->ops->generate_encryptionkey(sess);
> +               retval =3D conn->ops->generate_encryptionkey(conn, sess);
>                 if (retval) {
>                         ksmbd_debug(SMB,
>                                     "SMB3 encryption key generation faile=
d\n");
> @@ -1678,7 +1675,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>                         goto out_err;
>                 }
>
> -               if (conn->dialect !=3D sess->conn->dialect) {
> +               if (conn->dialect !=3D sess->dialect) {
>                         rc =3D -EINVAL;
>                         goto out_err;
>                 }
> @@ -1688,7 +1685,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>                         goto out_err;
>                 }
>
> -               if (strncmp(conn->ClientGUID, sess->conn->ClientGUID,
> +               if (strncmp(conn->ClientGUID, sess->ClientGUID,
>                             SMB2_CLIENT_GUID_SIZE)) {
>                         rc =3D -ENOENT;
>                         goto out_err;
> @@ -1890,7 +1887,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
>         ksmbd_debug(SMB, "tree connect request for tree %s treename %s\n"=
,
>                     name, treename);
>
> -       status =3D ksmbd_tree_conn_connect(sess, name);
> +       status =3D ksmbd_tree_conn_connect(conn, sess, name);
>         if (status.ret =3D=3D KSMBD_TREE_CONN_STATUS_OK)
>                 rsp->hdr.Id.SyncId.TreeId =3D cpu_to_le32(status.tree_con=
n->id);
>         else
> @@ -4875,7 +4872,7 @@ static int smb2_get_info_filesystem(struct ksmbd_wo=
rk *work,
>                                     struct smb2_query_info_rsp *rsp)
>  {
>         struct ksmbd_session *sess =3D work->sess;
> -       struct ksmbd_conn *conn =3D sess->conn;
> +       struct ksmbd_conn *conn =3D work->conn;
>         struct ksmbd_share_config *share =3D work->tcon->share_conf;
>         int fsinfoclass =3D 0;
>         struct kstatfs stfs;
> @@ -5793,7 +5790,7 @@ static int set_rename_info(struct ksmbd_work *work,=
 struct ksmbd_file *fp,
>         }
>  next:
>         return smb2_rename(work, fp, user_ns, rename_info,
> -                          work->sess->conn->local_nls);
> +                          work->conn->local_nls);
>  }
>
>  static int set_file_disposition_info(struct ksmbd_file *fp,
> @@ -5925,7 +5922,7 @@ static int smb2_set_info_file(struct ksmbd_work *wo=
rk, struct ksmbd_file *fp,
>                 return smb2_create_link(work, work->tcon->share_conf,
>                                         (struct smb2_file_link_info *)req=
->Buffer,
>                                         buf_len, fp->filp,
> -                                       work->sess->conn->local_nls);
> +                                       work->conn->local_nls);
>         }
>         case FILE_DISPOSITION_INFORMATION:
>         {
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index e1369b4345a9..318c16fa81da 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -421,7 +421,7 @@ struct smb_version_ops {
>         int (*check_sign_req)(struct ksmbd_work *work);
>         void (*set_sign_rsp)(struct ksmbd_work *work);
>         int (*generate_signingkey)(struct ksmbd_session *sess, struct ksm=
bd_conn *conn);
> -       int (*generate_encryptionkey)(struct ksmbd_session *sess);
> +       int (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksm=
bd_session *sess);
>         bool (*is_transform_hdr)(void *buf);
>         int (*decrypt_req)(struct ksmbd_work *work);
>         int (*encrypt_resp)(struct ksmbd_work *work);
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index 5d185564aef6..4f75b1436eab 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -481,12 +481,11 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct=
 ksmbd_file *fp,
>                     char *buf, size_t count, loff_t *pos, bool sync,
>                     ssize_t *written)
>  {
> -       struct ksmbd_session *sess =3D work->sess;
>         struct file *filp;
>         loff_t  offset =3D *pos;
>         int err =3D 0;
>
> -       if (sess->conn->connection_type) {
> +       if (work->conn->connection_type) {
>                 if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
>                         pr_err("no right to write(%pd)\n",
>                                fp->filp->f_path.dentry);
> diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
> index c4d59d2735f0..da9163b00350 100644
> --- a/fs/ksmbd/vfs_cache.c
> +++ b/fs/ksmbd/vfs_cache.c
> @@ -569,7 +569,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *w=
ork, struct file *filp)
>         atomic_set(&fp->refcount, 1);
>
>         fp->filp                =3D filp;
> -       fp->conn                =3D work->sess->conn;
> +       fp->conn                =3D work->conn;
>         fp->tcon                =3D work->tcon;
>         fp->volatile_id         =3D KSMBD_NO_FID;
>         fp->persistent_id       =3D KSMBD_NO_FID;
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
