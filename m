Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF94C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Aug 2021 05:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9CC6054F
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Aug 2021 05:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhHQFvv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbhHQFvv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Aug 2021 01:51:51 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228F1C061764
        for <linux-cifs@vger.kernel.org>; Mon, 16 Aug 2021 22:51:18 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id y34so39183128lfa.8
        for <linux-cifs@vger.kernel.org>; Mon, 16 Aug 2021 22:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6pvY9YqZfR7beSuNej51UDAy68HhHutKM2/Yp0mM7o=;
        b=WZCt/TKpUEomuHwRPSPI9MEibAaKXmDy9i/RBZulMyyofRvKcnu2JPKQbYiZqpcCv6
         GRUj9V6wHMb/fX+rdcVT7i5XHzrrgvr+U+sM2To3WABhIJlP7oqEjYKjTUcLPnsC7SkC
         dRkaDavLCtIyRJt1CCKt7R3zcELJAftVee8d/juEl6z72idg1pDPtISmKnwq8S0wg2hn
         G7xyy2XiAx1nUjcslijBA8OcALuPR7GTtvQ3EssvBOZVCNuIGPHE3qXW9YiCkNub203A
         EOWwBFZsDB6xzh5VTrItYOb6N0fXK4DiJGrnHbH8uMW6YUgzsOsmMpDLVV82uePT6UbN
         awXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6pvY9YqZfR7beSuNej51UDAy68HhHutKM2/Yp0mM7o=;
        b=f9Bh2JAa4cyYNPXBrLq0RY97aNJzcjcMAMbPdjASseo6J3fHJeIQpauLEY0KC3pOsE
         n+2isBQTi+RbqTrvyFaw1UXPqpKhvN9g3u4+R1Qzu65kKcBvxThixrHxjJO1CNfQrqv2
         yKDl8xcgplh9rqYuu4hB9h4qjZJr6cr9R1n7HoRQBqNBPG7QDh1xm8QCefioc9oKdjZG
         ssDTsCOt9maTizCAxjsaP/uy9q0ju7QJgsTN/+86xIC+p177/VVW2B1N0ogoEjxmDIRs
         fjgqmEKjfn3bnXaBydlMg8zYrYSE/qB2mZoQlDGtCDrfJ+xP6vArGFEWhM565rUJ6ZJz
         kN5w==
X-Gm-Message-State: AOAM532oTvUWSczRXrN9ZafAfjIEetq9tFcbPLwJOlnJ9upbtWHHElir
        EnPNlSgJgePAGViW8eLRMMPdbUArYEi0obwWQO8=
X-Google-Smtp-Source: ABdhPJwkofm08AHnZMWklVJBqcC4TEcmun1+dEb4vAwZgyDM5oqRBjo2s+AiDHsX3qHDBpcmeYu+5IsqhPK93PCOsqs=
X-Received: by 2002:a05:6512:3884:: with SMTP id n4mr1139635lft.313.1629179476183;
 Mon, 16 Aug 2021 22:51:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210817052436.1158186-1-lsahlber@redhat.com> <20210817052436.1158186-3-lsahlber@redhat.com>
In-Reply-To: <20210817052436.1158186-3-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 17 Aug 2021 00:51:05 -0500
Message-ID: <CAH2r5msKHO5iZs+XVj=MnM_QLyjsur_od7tG_TWRXizJzdVNiw@mail.gmail.com>
Subject: Re: [PATCH 3/3] cifs: move functions that depend on DES to smp1ops.c
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixed minor typo in patch 1 (<ctype.h>) and tentatively pushed all 3
to cifs-2.6.git for-next pending more testing and review

On Tue, Aug 17, 2021 at 12:25 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Move all dependencies of DES into smb1ops.c
> Make SMB1 support depend on CONFIG_LIB_DES
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/Kconfig       |   3 +-
>  fs/cifs/cifsencrypt.c |  39 ------
>  fs/cifs/cifsproto.h   |   9 --
>  fs/cifs/connect.c     | 162 ---------------------
>  fs/cifs/ntlmssp.h     |   1 +
>  fs/cifs/sess.c        |   5 +
>  fs/cifs/smb1ops.c     | 319 ++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smbencrypt.c  | 114 ---------------
>  8 files changed, 326 insertions(+), 326 deletions(-)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 7364950a9ef4..c01464476ba9 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -16,7 +16,6 @@ config CIFS
>         select CRYPTO_GCM
>         select CRYPTO_ECB
>         select CRYPTO_AES
> -       select CRYPTO_LIB_DES
>         select KEYS
>         select DNS_RESOLVER
>         select ASN1
> @@ -72,7 +71,7 @@ config CIFS_STATS2
>
>  config CIFS_ALLOW_INSECURE_LEGACY
>         bool "Support legacy servers which use less secure dialects"
> -       depends on CIFS
> +       depends on CIFS && CRYPTO_LIB_DES
>         default y
>         help
>           Modern dialects, SMB2.1 and later (including SMB3 and 3.1.1), have
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 79572d18ad7a..7680e0a9bea3 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -250,45 +250,6 @@ int cifs_verify_signature(struct smb_rqst *rqst,
>
>  }
>
> -/* first calculate 24 bytes ntlm response and then 16 byte session key */
> -int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
> -{
> -       int rc = 0;
> -       unsigned int temp_len = CIFS_SESS_KEY_SIZE + CIFS_AUTH_RESP_SIZE;
> -       char temp_key[CIFS_SESS_KEY_SIZE];
> -
> -       if (!ses)
> -               return -EINVAL;
> -
> -       ses->auth_key.response = kmalloc(temp_len, GFP_KERNEL);
> -       if (!ses->auth_key.response)
> -               return -ENOMEM;
> -
> -       ses->auth_key.len = temp_len;
> -
> -       rc = SMBNTencrypt(ses->password, ses->server->cryptkey,
> -                       ses->auth_key.response + CIFS_SESS_KEY_SIZE, nls_cp);
> -       if (rc) {
> -               cifs_dbg(FYI, "%s Can't generate NTLM response, error: %d\n",
> -                        __func__, rc);
> -               return rc;
> -       }
> -
> -       rc = E_md4hash(ses->password, temp_key, nls_cp);
> -       if (rc) {
> -               cifs_dbg(FYI, "%s Can't generate NT hash, error: %d\n",
> -                        __func__, rc);
> -               return rc;
> -       }
> -
> -       rc = mdfour(ses->auth_key.response, temp_key, CIFS_SESS_KEY_SIZE);
> -       if (rc)
> -               cifs_dbg(FYI, "%s Can't generate NTLM session key, error: %d\n",
> -                        __func__, rc);
> -
> -       return rc;
> -}
> -
>  /* Build a proper attribute value/target info pairs blob.
>   * Fill in netbios and dns domain name and workstation name
>   * and client time (total five av pairs and + one end of fields indicator.
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e0def0f0714b..4a686048f1fa 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -296,10 +296,6 @@ extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>  extern int cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required);
>  extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
>
> -extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> -                   const char *tree, struct cifs_tcon *tcon,
> -                   const struct nls_table *);
> -
>  extern int CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
>                 const char *searchName, struct cifs_sb_info *cifs_sb,
>                 __u16 *searchHandle, __u16 search_flags,
> @@ -498,9 +494,6 @@ extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
>  extern int cifs_verify_signature(struct smb_rqst *rqst,
>                                  struct TCP_Server_Info *server,
>                                 __u32 expected_sequence_number);
> -extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *,
> -                       const struct nls_table *);
> -extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
>  extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
>  extern void cifs_crypto_secmech_release(struct TCP_Server_Info *server);
>  extern int calc_seckey(struct cifs_ses *);
> @@ -550,8 +543,6 @@ extern int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>  extern int mdfour(unsigned char *, unsigned char *, int);
>  extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
>                         const struct nls_table *codepage);
> -extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
> -                       unsigned char *p24);
>
>  extern int
>  cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 3781eee9360a..7dba7b59dd51 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3642,168 +3642,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>  }
>  #endif
>
> -/*
> - * Issue a TREE_CONNECT request.
> - */
> -int
> -CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> -        const char *tree, struct cifs_tcon *tcon,
> -        const struct nls_table *nls_codepage)
> -{
> -       struct smb_hdr *smb_buffer;
> -       struct smb_hdr *smb_buffer_response;
> -       TCONX_REQ *pSMB;
> -       TCONX_RSP *pSMBr;
> -       unsigned char *bcc_ptr;
> -       int rc = 0;
> -       int length;
> -       __u16 bytes_left, count;
> -
> -       if (ses == NULL)
> -               return -EIO;
> -
> -       smb_buffer = cifs_buf_get();
> -       if (smb_buffer == NULL)
> -               return -ENOMEM;
> -
> -       smb_buffer_response = smb_buffer;
> -
> -       header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
> -                       NULL /*no tid */ , 4 /*wct */ );
> -
> -       smb_buffer->Mid = get_next_mid(ses->server);
> -       smb_buffer->Uid = ses->Suid;
> -       pSMB = (TCONX_REQ *) smb_buffer;
> -       pSMBr = (TCONX_RSP *) smb_buffer_response;
> -
> -       pSMB->AndXCommand = 0xFF;
> -       pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
> -       bcc_ptr = &pSMB->Password[0];
> -       if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
> -               pSMB->PasswordLength = cpu_to_le16(1);  /* minimum */
> -               *bcc_ptr = 0; /* password is null byte */
> -               bcc_ptr++;              /* skip password */
> -               /* already aligned so no need to do it below */
> -       } else {
> -               pSMB->PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
> -               /* BB FIXME add code to fail this if NTLMv2 or Kerberos
> -                  specified as required (when that support is added to
> -                  the vfs in the future) as only NTLM or the much
> -                  weaker LANMAN (which we do not send by default) is accepted
> -                  by Samba (not sure whether other servers allow
> -                  NTLMv2 password here) */
> -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> -               if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
> -                   (ses->sectype == LANMAN))
> -                       calc_lanman_hash(tcon->password, ses->server->cryptkey,
> -                                        ses->server->sec_mode &
> -                                           SECMODE_PW_ENCRYPT ? true : false,
> -                                        bcc_ptr);
> -               else
> -#endif /* CIFS_WEAK_PW_HASH */
> -               rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
> -                                       bcc_ptr, nls_codepage);
> -               if (rc) {
> -                       cifs_dbg(FYI, "%s Can't generate NTLM rsp. Error: %d\n",
> -                                __func__, rc);
> -                       cifs_buf_release(smb_buffer);
> -                       return rc;
> -               }
> -
> -               bcc_ptr += CIFS_AUTH_RESP_SIZE;
> -               if (ses->capabilities & CAP_UNICODE) {
> -                       /* must align unicode strings */
> -                       *bcc_ptr = 0; /* null byte password */
> -                       bcc_ptr++;
> -               }
> -       }
> -
> -       if (ses->server->sign)
> -               smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
> -
> -       if (ses->capabilities & CAP_STATUS32) {
> -               smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
> -       }
> -       if (ses->capabilities & CAP_DFS) {
> -               smb_buffer->Flags2 |= SMBFLG2_DFS;
> -       }
> -       if (ses->capabilities & CAP_UNICODE) {
> -               smb_buffer->Flags2 |= SMBFLG2_UNICODE;
> -               length =
> -                   cifs_strtoUTF16((__le16 *) bcc_ptr, tree,
> -                       6 /* max utf8 char length in bytes */ *
> -                       (/* server len*/ + 256 /* share len */), nls_codepage);
> -               bcc_ptr += 2 * length;  /* convert num 16 bit words to bytes */
> -               bcc_ptr += 2;   /* skip trailing null */
> -       } else {                /* ASCII */
> -               strcpy(bcc_ptr, tree);
> -               bcc_ptr += strlen(tree) + 1;
> -       }
> -       strcpy(bcc_ptr, "?????");
> -       bcc_ptr += strlen("?????");
> -       bcc_ptr += 1;
> -       count = bcc_ptr - &pSMB->Password[0];
> -       be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
> -       pSMB->ByteCount = cpu_to_le16(count);
> -
> -       rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
> -                        0);
> -
> -       /* above now done in SendReceive */
> -       if (rc == 0) {
> -               bool is_unicode;
> -
> -               tcon->tidStatus = CifsGood;
> -               tcon->need_reconnect = false;
> -               tcon->tid = smb_buffer_response->Tid;
> -               bcc_ptr = pByteArea(smb_buffer_response);
> -               bytes_left = get_bcc(smb_buffer_response);
> -               length = strnlen(bcc_ptr, bytes_left - 2);
> -               if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
> -                       is_unicode = true;
> -               else
> -                       is_unicode = false;
> -
> -
> -               /* skip service field (NB: this field is always ASCII) */
> -               if (length == 3) {
> -                       if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
> -                           (bcc_ptr[2] == 'C')) {
> -                               cifs_dbg(FYI, "IPC connection\n");
> -                               tcon->ipc = true;
> -                               tcon->pipe = true;
> -                       }
> -               } else if (length == 2) {
> -                       if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
> -                               /* the most common case */
> -                               cifs_dbg(FYI, "disk share connection\n");
> -                       }
> -               }
> -               bcc_ptr += length + 1;
> -               bytes_left -= (length + 1);
> -               strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
> -
> -               /* mostly informational -- no need to fail on error here */
> -               kfree(tcon->nativeFileSystem);
> -               tcon->nativeFileSystem = cifs_strndup_from_utf16(bcc_ptr,
> -                                                     bytes_left, is_unicode,
> -                                                     nls_codepage);
> -
> -               cifs_dbg(FYI, "nativeFileSystem=%s\n", tcon->nativeFileSystem);
> -
> -               if ((smb_buffer_response->WordCount == 3) ||
> -                        (smb_buffer_response->WordCount == 7))
> -                       /* field is in same location */
> -                       tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
> -               else
> -                       tcon->Flags = 0;
> -               cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
> -       }
> -
> -       cifs_buf_release(smb_buffer);
> -       return rc;
> -}
> -
>  static void delayed_free(struct rcu_head *p)
>  {
>         struct cifs_sb_info *cifs_sb = container_of(p, struct cifs_sb_info, rcu);
> diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
> index 378133ce8869..54f740c75be6 100644
> --- a/fs/cifs/ntlmssp.h
> +++ b/fs/cifs/ntlmssp.h
> @@ -124,3 +124,4 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer, struct cifs_ses *ses);
>  int build_ntlmssp_auth_blob(unsigned char **pbuffer, u16 *buflen,
>                         struct cifs_ses *ses,
>                         const struct nls_table *nls_cp);
> +int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp);
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index c5785fd3f52e..34a990e1ae44 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -1061,6 +1061,8 @@ sess_auth_lanman(struct sess_data *sess_data)
>
>  #endif
>
> +
> +#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>  static void
>  sess_auth_ntlm(struct sess_data *sess_data)
>  {
> @@ -1170,6 +1172,7 @@ sess_auth_ntlm(struct sess_data *sess_data)
>         kfree(ses->auth_key.response);
>         ses->auth_key.response = NULL;
>  }
> +#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>
>  static void
>  sess_auth_ntlmv2(struct sess_data *sess_data)
> @@ -1687,9 +1690,11 @@ static int select_sec(struct cifs_ses *ses, struct sess_data *sess_data)
>  #else
>                 return -EOPNOTSUPP;
>  #endif
> +#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>         case NTLM:
>                 sess_data->func = sess_auth_ntlm;
>                 break;
> +#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>         case NTLMv2:
>                 sess_data->func = sess_auth_ntlmv2;
>                 break;
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 5444cbc42043..c79d5bb2440d 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -6,6 +6,7 @@
>   */
>
>  #include <ctype.h>
> +#include <linux/fips.h>
>  #include <linux/pagemap.h>
>  #include <linux/vfs.h>
>  #include "cifsglob.h"
> @@ -14,8 +15,103 @@
>  #include "cifspdu.h"
>  #include "cifs_unicode.h"
>  #include "fs_context.h"
> +#include "ntlmssp.h"
> +
> +#include <crypto/des.h>
> +
> +static void
> +str_to_key(unsigned char *str, unsigned char *key)
> +{
> +       int i;
> +
> +       key[0] = str[0] >> 1;
> +       key[1] = ((str[0] & 0x01) << 6) | (str[1] >> 2);
> +       key[2] = ((str[1] & 0x03) << 5) | (str[2] >> 3);
> +       key[3] = ((str[2] & 0x07) << 4) | (str[3] >> 4);
> +       key[4] = ((str[3] & 0x0F) << 3) | (str[4] >> 5);
> +       key[5] = ((str[4] & 0x1F) << 2) | (str[5] >> 6);
> +       key[6] = ((str[5] & 0x3F) << 1) | (str[6] >> 7);
> +       key[7] = str[6] & 0x7F;
> +       for (i = 0; i < 8; i++)
> +               key[i] = (key[i] << 1);
> +}
> +
> +static int
> +smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
> +{
> +       unsigned char key2[8];
> +       struct des_ctx ctx;
> +
> +       str_to_key(key, key2);
> +
> +       if (fips_enabled) {
> +               cifs_dbg(VFS, "FIPS compliance enabled: DES not permitted\n");
> +               return -ENOENT;
> +       }
> +
> +       des_expand_key(&ctx, key2, DES_KEY_SIZE);
> +       des_encrypt(&ctx, out, in);
> +       memzero_explicit(&ctx, sizeof(ctx));
> +
> +       return 0;
> +}
> +
> +static int
> +E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p24)
> +{
> +       int rc;
> +
> +       rc = smbhash(p24, c8, p21);
> +       if (rc)
> +               return rc;
> +       rc = smbhash(p24 + 8, c8, p21 + 7);
> +       if (rc)
> +               return rc;
> +       rc = smbhash(p24 + 16, c8, p21 + 14);
> +       return rc;
> +}
>
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
> +static int
> +E_P16(unsigned char *p14, unsigned char *p16)
> +{
> +       int rc;
> +       unsigned char sp8[8] =
> +           { 0x4b, 0x47, 0x53, 0x21, 0x40, 0x23, 0x24, 0x25 };
> +
> +       rc = smbhash(p16, sp8, p14);
> +       if (rc)
> +               return rc;
> +       rc = smbhash(p16 + 8, sp8, p14 + 7);
> +       return rc;
> +}
> +
> +/*
> +   This implements the X/Open SMB password encryption
> +   It takes a password, a 8 byte "crypt key" and puts 24 bytes of
> +   encrypted password into p24 */
> +/* Note that password must be uppercased and null terminated */
> +static int
> +SMBencrypt(unsigned char *passwd, const unsigned char *c8, unsigned char *p24)
> +{
> +       int rc;
> +       unsigned char p14[14], p16[16], p21[21];
> +
> +       memset(p14, '\0', 14);
> +       memset(p16, '\0', 16);
> +       memset(p21, '\0', 21);
> +
> +       memcpy(p14, passwd, 14);
> +       rc = E_P16(p14, p16);
> +       if (rc)
> +               return rc;
> +
> +       memcpy(p21, p16, 16);
> +       rc = E_P24(p21, c8, p24);
> +
> +       return rc;
> +}
> +
>  int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>                         char *lnm_session_key)
>  {
> @@ -57,6 +153,229 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>  }
>  #endif /* CIFS_WEAK_PW_HASH */
>
> +/* Does the NT MD4 hash then des encryption. */
> +static int
> +SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24,
> +               const struct nls_table *codepage)
> +{
> +       int rc;
> +       unsigned char p16[16], p21[21];
> +
> +       memset(p16, '\0', 16);
> +       memset(p21, '\0', 21);
> +
> +       rc = E_md4hash(passwd, p16, codepage);
> +       if (rc) {
> +               cifs_dbg(FYI, "%s Can't generate NT hash, error: %d\n",
> +                        __func__, rc);
> +               return rc;
> +       }
> +       memcpy(p21, p16, 16);
> +       rc = E_P24(p21, c8, p24);
> +       return rc;
> +}
> +
> +/*
> + * Issue a TREE_CONNECT request.
> + */
> +static int
> +CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> +        const char *tree, struct cifs_tcon *tcon,
> +        const struct nls_table *nls_codepage)
> +{
> +       struct smb_hdr *smb_buffer;
> +       struct smb_hdr *smb_buffer_response;
> +       TCONX_REQ *pSMB;
> +       TCONX_RSP *pSMBr;
> +       unsigned char *bcc_ptr;
> +       int rc = 0;
> +       int length;
> +       __u16 bytes_left, count;
> +
> +       if (ses == NULL)
> +               return -EIO;
> +
> +       smb_buffer = cifs_buf_get();
> +       if (smb_buffer == NULL)
> +               return -ENOMEM;
> +
> +       smb_buffer_response = smb_buffer;
> +
> +       header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
> +                       NULL /*no tid */ , 4 /*wct */ );
> +
> +       smb_buffer->Mid = get_next_mid(ses->server);
> +       smb_buffer->Uid = ses->Suid;
> +       pSMB = (TCONX_REQ *) smb_buffer;
> +       pSMBr = (TCONX_RSP *) smb_buffer_response;
> +
> +       pSMB->AndXCommand = 0xFF;
> +       pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
> +       bcc_ptr = &pSMB->Password[0];
> +       if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
> +               pSMB->PasswordLength = cpu_to_le16(1);  /* minimum */
> +               *bcc_ptr = 0; /* password is null byte */
> +               bcc_ptr++;              /* skip password */
> +               /* already aligned so no need to do it below */
> +       } else {
> +               pSMB->PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
> +               /* BB FIXME add code to fail this if NTLMv2 or Kerberos
> +                  specified as required (when that support is added to
> +                  the vfs in the future) as only NTLM or the much
> +                  weaker LANMAN (which we do not send by default) is accepted
> +                  by Samba (not sure whether other servers allow
> +                  NTLMv2 password here) */
> +#ifdef CONFIG_CIFS_WEAK_PW_HASH
> +               if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
> +                   (ses->sectype == LANMAN))
> +                       calc_lanman_hash(tcon->password, ses->server->cryptkey,
> +                                        ses->server->sec_mode &
> +                                           SECMODE_PW_ENCRYPT ? true : false,
> +                                        bcc_ptr);
> +               else
> +#endif /* CIFS_WEAK_PW_HASH */
> +               rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
> +                                       bcc_ptr, nls_codepage);
> +               if (rc) {
> +                       cifs_dbg(FYI, "%s Can't generate NTLM rsp. Error: %d\n",
> +                                __func__, rc);
> +                       cifs_buf_release(smb_buffer);
> +                       return rc;
> +               }
> +
> +               bcc_ptr += CIFS_AUTH_RESP_SIZE;
> +               if (ses->capabilities & CAP_UNICODE) {
> +                       /* must align unicode strings */
> +                       *bcc_ptr = 0; /* null byte password */
> +                       bcc_ptr++;
> +               }
> +       }
> +
> +       if (ses->server->sign)
> +               smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
> +
> +       if (ses->capabilities & CAP_STATUS32) {
> +               smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
> +       }
> +       if (ses->capabilities & CAP_DFS) {
> +               smb_buffer->Flags2 |= SMBFLG2_DFS;
> +       }
> +       if (ses->capabilities & CAP_UNICODE) {
> +               smb_buffer->Flags2 |= SMBFLG2_UNICODE;
> +               length =
> +                   cifs_strtoUTF16((__le16 *) bcc_ptr, tree,
> +                       6 /* max utf8 char length in bytes */ *
> +                       (/* server len*/ + 256 /* share len */), nls_codepage);
> +               bcc_ptr += 2 * length;  /* convert num 16 bit words to bytes */
> +               bcc_ptr += 2;   /* skip trailing null */
> +       } else {                /* ASCII */
> +               strcpy(bcc_ptr, tree);
> +               bcc_ptr += strlen(tree) + 1;
> +       }
> +       strcpy(bcc_ptr, "?????");
> +       bcc_ptr += strlen("?????");
> +       bcc_ptr += 1;
> +       count = bcc_ptr - &pSMB->Password[0];
> +       be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
> +       pSMB->ByteCount = cpu_to_le16(count);
> +
> +       rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
> +                        0);
> +
> +       /* above now done in SendReceive */
> +       if (rc == 0) {
> +               bool is_unicode;
> +
> +               tcon->tidStatus = CifsGood;
> +               tcon->need_reconnect = false;
> +               tcon->tid = smb_buffer_response->Tid;
> +               bcc_ptr = pByteArea(smb_buffer_response);
> +               bytes_left = get_bcc(smb_buffer_response);
> +               length = strnlen(bcc_ptr, bytes_left - 2);
> +               if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
> +                       is_unicode = true;
> +               else
> +                       is_unicode = false;
> +
> +
> +               /* skip service field (NB: this field is always ASCII) */
> +               if (length == 3) {
> +                       if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
> +                           (bcc_ptr[2] == 'C')) {
> +                               cifs_dbg(FYI, "IPC connection\n");
> +                               tcon->ipc = true;
> +                               tcon->pipe = true;
> +                       }
> +               } else if (length == 2) {
> +                       if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
> +                               /* the most common case */
> +                               cifs_dbg(FYI, "disk share connection\n");
> +                       }
> +               }
> +               bcc_ptr += length + 1;
> +               bytes_left -= (length + 1);
> +               strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
> +
> +               /* mostly informational -- no need to fail on error here */
> +               kfree(tcon->nativeFileSystem);
> +               tcon->nativeFileSystem = cifs_strndup_from_utf16(bcc_ptr,
> +                                                     bytes_left, is_unicode,
> +                                                     nls_codepage);
> +
> +               cifs_dbg(FYI, "nativeFileSystem=%s\n", tcon->nativeFileSystem);
> +
> +               if ((smb_buffer_response->WordCount == 3) ||
> +                        (smb_buffer_response->WordCount == 7))
> +                       /* field is in same location */
> +                       tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
> +               else
> +                       tcon->Flags = 0;
> +               cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
> +       }
> +
> +       cifs_buf_release(smb_buffer);
> +       return rc;
> +}
> +
> +/* first calculate 24 bytes ntlm response and then 16 byte session key */
> +int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
> +{
> +       int rc = 0;
> +       unsigned int temp_len = CIFS_SESS_KEY_SIZE + CIFS_AUTH_RESP_SIZE;
> +       char temp_key[CIFS_SESS_KEY_SIZE];
> +
> +       if (!ses)
> +               return -EINVAL;
> +
> +       ses->auth_key.response = kmalloc(temp_len, GFP_KERNEL);
> +       if (!ses->auth_key.response)
> +               return -ENOMEM;
> +
> +       ses->auth_key.len = temp_len;
> +
> +       rc = SMBNTencrypt(ses->password, ses->server->cryptkey,
> +                       ses->auth_key.response + CIFS_SESS_KEY_SIZE, nls_cp);
> +       if (rc) {
> +               cifs_dbg(FYI, "%s Can't generate NTLM response, error: %d\n",
> +                        __func__, rc);
> +               return rc;
> +       }
> +
> +       rc = E_md4hash(ses->password, temp_key, nls_cp);
> +       if (rc) {
> +               cifs_dbg(FYI, "%s Can't generate NT hash, error: %d\n",
> +                        __func__, rc);
> +               return rc;
> +       }
> +
> +       rc = mdfour(ses->auth_key.response, temp_key, CIFS_SESS_KEY_SIZE);
> +       if (rc)
> +               cifs_dbg(FYI, "%s Can't generate NTLM session key, error: %d\n",
> +                        __func__, rc);
> +
> +       return rc;
> +}
> +
>  /*
>   * An NT cancel request header looks just like the original request except:
>   *
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 39a938443e3e..0c5617427be9 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -18,7 +18,6 @@
>  #include <linux/string.h>
>  #include <linux/kernel.h>
>  #include <linux/random.h>
> -#include <crypto/des.h>
>  #include "cifs_fs_sb.h"
>  #include "cifs_unicode.h"
>  #include "cifspdu.h"
> @@ -38,72 +37,6 @@
>  #define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
>  #define SSVAL(buf,pos,val) SSVALX((buf),(pos),((__u16)(val)))
>
> -static void
> -str_to_key(unsigned char *str, unsigned char *key)
> -{
> -       int i;
> -
> -       key[0] = str[0] >> 1;
> -       key[1] = ((str[0] & 0x01) << 6) | (str[1] >> 2);
> -       key[2] = ((str[1] & 0x03) << 5) | (str[2] >> 3);
> -       key[3] = ((str[2] & 0x07) << 4) | (str[3] >> 4);
> -       key[4] = ((str[3] & 0x0F) << 3) | (str[4] >> 5);
> -       key[5] = ((str[4] & 0x1F) << 2) | (str[5] >> 6);
> -       key[6] = ((str[5] & 0x3F) << 1) | (str[6] >> 7);
> -       key[7] = str[6] & 0x7F;
> -       for (i = 0; i < 8; i++)
> -               key[i] = (key[i] << 1);
> -}
> -
> -static int
> -smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
> -{
> -       unsigned char key2[8];
> -       struct des_ctx ctx;
> -
> -       str_to_key(key, key2);
> -
> -       if (fips_enabled) {
> -               cifs_dbg(VFS, "FIPS compliance enabled: DES not permitted\n");
> -               return -ENOENT;
> -       }
> -
> -       des_expand_key(&ctx, key2, DES_KEY_SIZE);
> -       des_encrypt(&ctx, out, in);
> -       memzero_explicit(&ctx, sizeof(ctx));
> -
> -       return 0;
> -}
> -
> -static int
> -E_P16(unsigned char *p14, unsigned char *p16)
> -{
> -       int rc;
> -       unsigned char sp8[8] =
> -           { 0x4b, 0x47, 0x53, 0x21, 0x40, 0x23, 0x24, 0x25 };
> -
> -       rc = smbhash(p16, sp8, p14);
> -       if (rc)
> -               return rc;
> -       rc = smbhash(p16 + 8, sp8, p14 + 7);
> -       return rc;
> -}
> -
> -static int
> -E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p24)
> -{
> -       int rc;
> -
> -       rc = smbhash(p24, c8, p21);
> -       if (rc)
> -               return rc;
> -       rc = smbhash(p24 + 8, c8, p21 + 7);
> -       if (rc)
> -               return rc;
> -       rc = smbhash(p24 + 16, c8, p21 + 14);
> -       return rc;
> -}
> -
>  /* produce a md4 message digest from data of length n bytes */
>  int
>  mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
> @@ -135,32 +68,6 @@ mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
>         return rc;
>  }
>
> -/*
> -   This implements the X/Open SMB password encryption
> -   It takes a password, a 8 byte "crypt key" and puts 24 bytes of
> -   encrypted password into p24 */
> -/* Note that password must be uppercased and null terminated */
> -int
> -SMBencrypt(unsigned char *passwd, const unsigned char *c8, unsigned char *p24)
> -{
> -       int rc;
> -       unsigned char p14[14], p16[16], p21[21];
> -
> -       memset(p14, '\0', 14);
> -       memset(p16, '\0', 16);
> -       memset(p21, '\0', 21);
> -
> -       memcpy(p14, passwd, 14);
> -       rc = E_P16(p14, p16);
> -       if (rc)
> -               return rc;
> -
> -       memcpy(p21, p16, 16);
> -       rc = E_P24(p21, c8, p24);
> -
> -       return rc;
> -}
> -
>  /*
>   * Creates the MD4 Hash of the users password in NT UNICODE.
>   */
> @@ -187,24 +94,3 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
>         return rc;
>  }
>
> -/* Does the NT MD4 hash then des encryption. */
> -int
> -SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24,
> -               const struct nls_table *codepage)
> -{
> -       int rc;
> -       unsigned char p16[16], p21[21];
> -
> -       memset(p16, '\0', 16);
> -       memset(p21, '\0', 21);
> -
> -       rc = E_md4hash(passwd, p16, codepage);
> -       if (rc) {
> -               cifs_dbg(FYI, "%s Can't generate NT hash, error: %d\n",
> -                        __func__, rc);
> -               return rc;
> -       }
> -       memcpy(p21, p16, 16);
> -       rc = E_P24(p21, c8, p24);
> -       return rc;
> -}
> --
> 2.30.2
>


-- 
Thanks,

Steve
