Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1D6C4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B575C2313B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgLLFvp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgLLFvY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 00:51:24 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255F3C0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:50:44 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id r24so16910392lfm.8
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TOQBxEL8r7ee7dBkhtK74Rn5CNQ1s+sTQ++IrGzESfU=;
        b=WlR7+iVuP4LgGY00FWkh1TSy655GtZ/kcYkctrdIl5fepN73MC8g4TbP5eXz5ouizV
         IbCHxDogxW6ZAqcdnSFHa2mz7oje3G4+/COlAg0eg4wqw4A19G2/WmlOPO7R4HTuIvek
         ZBUqS97mYPJ3YIuxvgSudql0jRG4l0iRzHoWTUIcY6z6AWA7JpUV6SCESdZt4C8LcQBm
         1I8mtAhxTAlMk7mSDpH8iPWQhyNNoL3McRV5BgpZ+zPra2hRnXRXx4qi4BYFgGeNrm9X
         CmhUx71SmtIg4mvgEFPH9ArKtKkoBrV0U3xIWB4mlLQA80E/c8YRodxZd1Ps6s8bi1uj
         I+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TOQBxEL8r7ee7dBkhtK74Rn5CNQ1s+sTQ++IrGzESfU=;
        b=dhdWJGF/SSLqHex5OaYizO0S5NUPbderrwiSj4WcIKwI5/W2qRY08GKQ9i8yQadZcA
         wcRAdd4L36LG1pGFdSSyj6h41lO/jxf+pAN29tdrOAmk0q4iPX+F1cceF1tnVyTF3Rno
         G16v9zp1/BibGXeq4gt94PRK4STT/QXlj3vQgBem/AJSpu2A5Z0RazVr+s0B0FhFXieE
         yUs+u8JqDT5MLDLVowZJymg7egFUjG11gREAqFgSrknHeLyI1kZ28ItTvHYrsiuCpI4W
         cmw675M6y5/cliNGgi9i7eTsAlQaQz7zxrgKNCcG4ipfqb0QSagTBSaao+QoV/Ag9hJZ
         u6mg==
X-Gm-Message-State: AOAM530OIsOaEgLDVhqKzx/qzwL9SoJLf5KH/DUv36n+N9ibG/Zz49SP
        TWKndv+E9rINgGu0fa0nelV55sx6XTHh7IJ1bhs=
X-Google-Smtp-Source: ABdhPJz8ZuIBf9j+T1LAsUVp2sRB0GTJF6XAcPFOdHlrrsdgjKl39nT6mnyc6blRBncDy76BUDmUDT0l12ew0Jm/6PY=
X-Received: by 2002:a2e:88c8:: with SMTP id a8mr6278647ljk.148.1607752242557;
 Fri, 11 Dec 2020 21:50:42 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-3-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-3-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 23:50:31 -0600
Message-ID: <CAH2r5mv5daRXYqGcXJTJh1QfmT-PjtY3TRHG7HDqMRZWgzQSvg@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] cifs: Make extract_sharename function public
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004e0bca05b63dfd0e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004e0bca05b63dfd0e
Content-Type: text/plain; charset="UTF-8"

updated version of the patch attached (rebased on current for-next).
Tenatively merged into cifs-2.6.git for-next

On Mon, Nov 30, 2020 at 12:05 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> Move the function to misc.c
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/cache.c     | 24 ------------------------
>  fs/cifs/cifsproto.h |  1 +
>  fs/cifs/fscache.c   |  1 +
>  fs/cifs/fscache.h   |  1 -
>  fs/cifs/misc.c      | 24 ++++++++++++++++++++++++
>  5 files changed, 26 insertions(+), 25 deletions(-)
>
> diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
> index 0f2adecb94f2..488fe0ffc1ef 100644
> --- a/fs/cifs/cache.c
> +++ b/fs/cifs/cache.c
> @@ -53,30 +53,6 @@ const struct fscache_cookie_def cifs_fscache_server_index_def = {
>         .type = FSCACHE_COOKIE_TYPE_INDEX,
>  };
>
> -char *extract_sharename(const char *treename)
> -{
> -       const char *src;
> -       char *delim, *dst;
> -       int len;
> -
> -       /* skip double chars at the beginning */
> -       src = treename + 2;
> -
> -       /* share name is always preceded by '\\' now */
> -       delim = strchr(src, '\\');
> -       if (!delim)
> -               return ERR_PTR(-EINVAL);
> -       delim++;
> -       len = strlen(delim);
> -
> -       /* caller has to free the memory */
> -       dst = kstrndup(delim, len, GFP_KERNEL);
> -       if (!dst)
> -               return ERR_PTR(-ENOMEM);
> -
> -       return dst;
> -}
> -
>  static enum
>  fscache_checkaux cifs_fscache_super_check_aux(void *cookie_netfs_data,
>                                               const void *data,
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index d716e81d86fa..5f997a01fb45 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -621,6 +621,7 @@ struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
>  void cifs_put_tcp_super(struct super_block *sb);
>  int update_super_prepath(struct cifs_tcon *tcon, char *prefix);
>  char *extract_hostname(const char *unc);
> +char *extract_sharename(const char *unc);
>
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
> diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
> index da688185403c..20d24af33ee2 100644
> --- a/fs/cifs/fscache.c
> +++ b/fs/cifs/fscache.c
> @@ -22,6 +22,7 @@
>  #include "cifsglob.h"
>  #include "cifs_debug.h"
>  #include "cifs_fs_sb.h"
> +#include "cifsproto.h"
>
>  /*
>   * Key layout of CIFS server cache index object
> diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
> index 1091633d2adb..e811f2dd7619 100644
> --- a/fs/cifs/fscache.h
> +++ b/fs/cifs/fscache.h
> @@ -57,7 +57,6 @@ extern const struct fscache_cookie_def cifs_fscache_inode_object_def;
>
>  extern int cifs_fscache_register(void);
>  extern void cifs_fscache_unregister(void);
> -extern char *extract_sharename(const char *);
>
>  /*
>   * fscache.c
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 3d5cc25c167f..f0a1c24751b2 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -1227,3 +1227,27 @@ char *extract_hostname(const char *unc)
>
>         return dst;
>  }
> +
> +char *extract_sharename(const char *unc)
> +{
> +       const char *src;
> +       char *delim, *dst;
> +       int len;
> +
> +       /* skip double chars at the beginning */
> +       src = unc + 2;
> +
> +       /* share name is always preceded by '\\' now */
> +       delim = strchr(src, '\\');
> +       if (!delim)
> +               return ERR_PTR(-EINVAL);
> +       delim++;
> +       len = strlen(delim);
> +
> +       /* caller has to free the memory */
> +       dst = kstrndup(delim, len, GFP_KERNEL);
> +       if (!dst)
> +               return ERR_PTR(-ENOMEM);
> +
> +       return dst;
> +}
> --
> 2.29.2
>


-- 
Thanks,

Steve

--0000000000004e0bca05b63dfd0e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-cifs-Make-extract_sharename-function-public.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-Make-extract_sharename-function-public.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kila5yfs0>
X-Attachment-Id: f_kila5yfs0

RnJvbSA3NDk3NjVlMjYwNzIwZDMzMmViOGYwM2MzYmUyODU1N2I4Y2ViOTU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW11ZWwgQ2FicmVybyA8c2NhYnJlcm9Ac3VzZS5kZT4KRGF0
ZTogTW9uLCAzMCBOb3YgMjAyMCAxOTowMjo0OCArMDEwMApTdWJqZWN0OiBbUEFUQ0ggMi84XSBj
aWZzOiBNYWtlIGV4dHJhY3Rfc2hhcmVuYW1lIGZ1bmN0aW9uIHB1YmxpYwoKTW92ZSB0aGUgZnVu
Y3Rpb24gdG8gbWlzYy5jCgpTaWduZWQtb2ZmLWJ5OiBTYW11ZWwgQ2FicmVybyA8c2NhYnJlcm9A
c3VzZS5kZT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvY2FjaGUuYyAgICAgfCAyNCAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAgMSArCiBmcy9jaWZzL2ZzY2FjaGUuYyAgIHwgIDEg
KwogZnMvY2lmcy9mc2NhY2hlLmggICB8ICAxIC0KIGZzL2NpZnMvbWlzYy5jICAgICAgfCAyNCAr
KysrKysrKysrKysrKysrKysrKysrKysKIDUgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygr
KSwgMjUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jYWNoZS5jIGIvZnMvY2lm
cy9jYWNoZS5jCmluZGV4IDBmMmFkZWNiOTRmMi4uNDg4ZmUwZmZjMWVmIDEwMDY0NAotLS0gYS9m
cy9jaWZzL2NhY2hlLmMKKysrIGIvZnMvY2lmcy9jYWNoZS5jCkBAIC01MywzMCArNTMsNiBAQCBj
b25zdCBzdHJ1Y3QgZnNjYWNoZV9jb29raWVfZGVmIGNpZnNfZnNjYWNoZV9zZXJ2ZXJfaW5kZXhf
ZGVmID0gewogCS50eXBlID0gRlNDQUNIRV9DT09LSUVfVFlQRV9JTkRFWCwKIH07CiAKLWNoYXIg
KmV4dHJhY3Rfc2hhcmVuYW1lKGNvbnN0IGNoYXIgKnRyZWVuYW1lKQotewotCWNvbnN0IGNoYXIg
KnNyYzsKLQljaGFyICpkZWxpbSwgKmRzdDsKLQlpbnQgbGVuOwotCi0JLyogc2tpcCBkb3VibGUg
Y2hhcnMgYXQgdGhlIGJlZ2lubmluZyAqLwotCXNyYyA9IHRyZWVuYW1lICsgMjsKLQotCS8qIHNo
YXJlIG5hbWUgaXMgYWx3YXlzIHByZWNlZGVkIGJ5ICdcXCcgbm93ICovCi0JZGVsaW0gPSBzdHJj
aHIoc3JjLCAnXFwnKTsKLQlpZiAoIWRlbGltKQotCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsK
LQlkZWxpbSsrOwotCWxlbiA9IHN0cmxlbihkZWxpbSk7Ci0KLQkvKiBjYWxsZXIgaGFzIHRvIGZy
ZWUgdGhlIG1lbW9yeSAqLwotCWRzdCA9IGtzdHJuZHVwKGRlbGltLCBsZW4sIEdGUF9LRVJORUwp
OwotCWlmICghZHN0KQotCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsKLQotCXJldHVybiBkc3Q7
Ci19Ci0KIHN0YXRpYyBlbnVtCiBmc2NhY2hlX2NoZWNrYXV4IGNpZnNfZnNjYWNoZV9zdXBlcl9j
aGVja19hdXgodm9pZCAqY29va2llX25ldGZzX2RhdGEsCiAJCQkJCSAgICAgIGNvbnN0IHZvaWQg
KmRhdGEsCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNwcm90by5oIGIvZnMvY2lmcy9jaWZzcHJv
dG8uaAppbmRleCAzZmUwYzRhMGQzNmQuLmI4MGI1N2E2NjgwNCAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9jaWZzcHJvdG8uaAorKysgYi9mcy9jaWZzL2NpZnNwcm90by5oCkBAIC02MTgsNiArNjE4LDcg
QEAgc3RydWN0IHN1cGVyX2Jsb2NrICpjaWZzX2dldF90Y3Bfc3VwZXIoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyKTsKIHZvaWQgY2lmc19wdXRfdGNwX3N1cGVyKHN0cnVjdCBzdXBlcl9i
bG9jayAqc2IpOwogaW50IHVwZGF0ZV9zdXBlcl9wcmVwYXRoKHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24sIGNoYXIgKnByZWZpeCk7CiBjaGFyICpleHRyYWN0X2hvc3RuYW1lKGNvbnN0IGNoYXIgKnVu
Yyk7CitjaGFyICpleHRyYWN0X3NoYXJlbmFtZShjb25zdCBjaGFyICp1bmMpOwogCiAjaWZkZWYg
Q09ORklHX0NJRlNfREZTX1VQQ0FMTAogc3RhdGljIGlubGluZSBpbnQgZ2V0X2Rmc19wYXRoKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLApkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9mc2NhY2hlLmMgYi9mcy9jaWZzL2ZzY2FjaGUuYwppbmRleCBkYTY4ODE4NTQwM2Mu
LjIwZDI0YWYzM2VlMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9mc2NhY2hlLmMKKysrIGIvZnMvY2lm
cy9mc2NhY2hlLmMKQEAgLTIyLDYgKzIyLDcgQEAKICNpbmNsdWRlICJjaWZzZ2xvYi5oIgogI2lu
Y2x1ZGUgImNpZnNfZGVidWcuaCIKICNpbmNsdWRlICJjaWZzX2ZzX3NiLmgiCisjaW5jbHVkZSAi
Y2lmc3Byb3RvLmgiCiAKIC8qCiAgKiBLZXkgbGF5b3V0IG9mIENJRlMgc2VydmVyIGNhY2hlIGlu
ZGV4IG9iamVjdApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9mc2NhY2hlLmggYi9mcy9jaWZzL2ZzY2Fj
aGUuaAppbmRleCAxMDkxNjMzZDJhZGIuLmU4MTFmMmRkNzYxOSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9mc2NhY2hlLmgKKysrIGIvZnMvY2lmcy9mc2NhY2hlLmgKQEAgLTU3LDcgKzU3LDYgQEAgZXh0
ZXJuIGNvbnN0IHN0cnVjdCBmc2NhY2hlX2Nvb2tpZV9kZWYgY2lmc19mc2NhY2hlX2lub2RlX29i
amVjdF9kZWY7CiAKIGV4dGVybiBpbnQgY2lmc19mc2NhY2hlX3JlZ2lzdGVyKHZvaWQpOwogZXh0
ZXJuIHZvaWQgY2lmc19mc2NhY2hlX3VucmVnaXN0ZXIodm9pZCk7Ci1leHRlcm4gY2hhciAqZXh0
cmFjdF9zaGFyZW5hbWUoY29uc3QgY2hhciAqKTsKIAogLyoKICAqIGZzY2FjaGUuYwpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9taXNjLmMgYi9mcy9jaWZzL21pc2MuYwppbmRleCAzZDVjYzI1YzE2N2Yu
LmYwYTFjMjQ3NTFiMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9taXNjLmMKKysrIGIvZnMvY2lmcy9t
aXNjLmMKQEAgLTEyMjcsMyArMTIyNywyNyBAQCBjaGFyICpleHRyYWN0X2hvc3RuYW1lKGNvbnN0
IGNoYXIgKnVuYykKIAogCXJldHVybiBkc3Q7CiB9CisKK2NoYXIgKmV4dHJhY3Rfc2hhcmVuYW1l
KGNvbnN0IGNoYXIgKnVuYykKK3sKKwljb25zdCBjaGFyICpzcmM7CisJY2hhciAqZGVsaW0sICpk
c3Q7CisJaW50IGxlbjsKKworCS8qIHNraXAgZG91YmxlIGNoYXJzIGF0IHRoZSBiZWdpbm5pbmcg
Ki8KKwlzcmMgPSB1bmMgKyAyOworCisJLyogc2hhcmUgbmFtZSBpcyBhbHdheXMgcHJlY2VkZWQg
YnkgJ1xcJyBub3cgKi8KKwlkZWxpbSA9IHN0cmNocihzcmMsICdcXCcpOworCWlmICghZGVsaW0p
CisJCXJldHVybiBFUlJfUFRSKC1FSU5WQUwpOworCWRlbGltKys7CisJbGVuID0gc3RybGVuKGRl
bGltKTsKKworCS8qIGNhbGxlciBoYXMgdG8gZnJlZSB0aGUgbWVtb3J5ICovCisJZHN0ID0ga3N0
cm5kdXAoZGVsaW0sIGxlbiwgR0ZQX0tFUk5FTCk7CisJaWYgKCFkc3QpCisJCXJldHVybiBFUlJf
UFRSKC1FTk9NRU0pOworCisJcmV0dXJuIGRzdDsKK30KLS0gCjIuMjcuMAoK
--0000000000004e0bca05b63dfd0e--
