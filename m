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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2F3C4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1FE22D06
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgLLFI1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgLLFI0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 00:08:26 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6815AC0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:07:46 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id y19so16740531lfa.13
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZTWkTLs+Jag806W4N/+dceURww/5Fa6gg1bYaAbtMY=;
        b=Ek0QJr7lPnE2uC0KRCalkT3cl4OInK0d/A3YpzNNwrJFhlUekxGs6eIZZSS012pwzG
         018u2dqpsEvrrNPAcVescxgW3o2Yv4TdI+nPyHUGXXOEj6Eqn+vi1uMAczeYZ6+pNyid
         DWQx0CKPGs7r/w+W/3tbozX8jRmcAMX2/+cZVwWYU7diguVJHj6Lzr+OXKreJWADxK3u
         tAzoXGrKUUXQxQY3z9caN57tPPoBGDWsKeDIy1ZDY7OcSHLNvK793Zo22YSe5Qk9XAbh
         c02QRVHpW6grMtLiEeNdAbSm3v78987gL5Im9zyBYif2MIgzb4HncP0HIF6QJspm0eoi
         2d6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZTWkTLs+Jag806W4N/+dceURww/5Fa6gg1bYaAbtMY=;
        b=CavxIiK0DnJ7YmUpEdzRHJa2ctSDB9Z5Ft3+a/jAotcDb1mWqVcGKwrk7YnzBmQzph
         iVAWKUScbKbjuSckCT0ps8s4yd947RSppR56YsC7J0zVPAcbWGQ8dvQ/k5K7ilYYVbQu
         QLsmBEVPsg9zfoFIiT62izltluQaUh0EZ9GcjtUAEVy4Xk8t6tSn4X4BmpqAGaAQnTPI
         SLxpaa18vzbB4fd0mLUZt7Yyu6A1cL3TXDEaUVaS9AmPkmah3OdD7fR+5H34hB/A23sh
         9CF9ziUggSImAqYYwGZlWr171jkMJbmPgde/4r+RvPcjoDbNmTauan2bT6nbLVQiG5sc
         Ai/g==
X-Gm-Message-State: AOAM533V+76HlHFQGmckO/ShEEELORp9d1T0OO/NZT/uhpvDLx85Mof1
        w3MAp7V2zdh98ZofLrjdCFflAUvfULeiUzPtR3g=
X-Google-Smtp-Source: ABdhPJwOUEFWDQQjKgIeC0pX0xesa3L/V5+p4Z4PO8Thy4u6IaO2clTB/z5g4FAOvTTBdqRoy6X8AHQQLVpbpHPwWnQ=
X-Received: by 2002:ac2:5689:: with SMTP id 9mr6088355lfr.175.1607749664611;
 Fri, 11 Dec 2020 21:07:44 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-5-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-5-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 23:07:33 -0600
Message-ID: <CAH2r5msxuo8-v7p4DuG9iBY5Qdg8r4Vd2HXeCwOvsdmNwxLbHg@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] cifs: add witness mount option and data structs
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a5b67105b63d6365"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a5b67105b63d6365
Content-Type: text/plain; charset="UTF-8"

Updated to support new mount API (rebased on Ronnie's patch series).
Let me know if you see any problems.


On Mon, Nov 30, 2020 at 12:04 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> Add 'witness' mount option to register for witness notifications.
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/cifsfs.c   |  5 +++++
>  fs/cifs/cifsglob.h |  4 ++++
>  fs/cifs/connect.c  | 35 ++++++++++++++++++++++++++++++++++-
>  3 files changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8111d0109a2e..c2bbc444b463 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -637,6 +637,11 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>                 seq_printf(s, ",multichannel,max_channels=%zu",
>                            tcon->ses->chan_max);
>
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       if (tcon->use_witness)
> +               seq_puts(s, ",witness");
> +#endif
> +
>         return 0;
>  }
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 484ec2d8c5c9..f45b7c0fbceb 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -619,6 +619,7 @@ struct smb_vol {
>         unsigned int max_channels;
>         __u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
>         bool rootfs:1; /* if it's a SMB root file system */
> +       bool witness:1; /* use witness protocol */
>  };
>
>  /**
> @@ -1177,6 +1178,9 @@ struct cifs_tcon {
>         int remap:2;
>         struct list_head ulist; /* cache update list */
>  #endif
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       bool use_witness:1; /* use witness protocol */
> +#endif
>  };
>
>  /*
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a938371af6ef..22d46c8acc7f 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -102,7 +102,7 @@ enum {
>         Opt_resilient, Opt_noresilient,
>         Opt_domainauto, Opt_rdma, Opt_modesid, Opt_rootfs,
>         Opt_multichannel, Opt_nomultichannel,
> -       Opt_compress,
> +       Opt_compress, Opt_witness,
>
>         /* Mount options which take numeric value */
>         Opt_backupuid, Opt_backupgid, Opt_uid,
> @@ -276,6 +276,7 @@ static const match_table_t cifs_mount_option_tokens = {
>         { Opt_ignore, "relatime" },
>         { Opt_ignore, "_netdev" },
>         { Opt_rootfs, "rootfs" },
> +       { Opt_witness, "witness" },
>
>         { Opt_err, NULL }
>  };
> @@ -1540,6 +1541,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         vol->rootfs = true;
>  #endif
>                         break;
> +               case Opt_witness:
> +#ifndef CONFIG_CIFS_SWN_UPCALL
> +                       cifs_dbg(VFS, "Witness support needs CONFIG_CIFS_SWN_UPCALL kernel config option set\n");
> +                       goto cifs_parse_mount_err;
> +#endif
> +                       vol->witness = true;
> +                       break;
>                 case Opt_posixpaths:
>                         vol->posix_paths = 1;
>                         break;
> @@ -3160,6 +3168,8 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>                 return;
>         }
>
> +       /* TODO witness unregister */
> +
>         list_del_init(&tcon->tcon_list);
>         spin_unlock(&cifs_tcp_ses_lock);
>
> @@ -3321,6 +3331,26 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
>                 tcon->use_resilient = true;
>         }
>
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       tcon->use_witness = false;
> +       if (volume_info->witness) {
> +               if (ses->server->vals->protocol_id >= SMB30_PROT_ID) {
> +                       if (tcon->capabilities & SMB2_SHARE_CAP_CLUSTER) {
> +                               /* TODO witness register */
> +                               tcon->use_witness = true;
> +                       } else {
> +                               cifs_dbg(VFS, "witness requested on mount but no CLUSTER capability on share\n");
> +                               rc = -EOPNOTSUPP;
> +                               goto out_fail;
> +                       }
> +               } else {
> +                       cifs_dbg(VFS, "SMB3 or later required for witness option\n");
> +                       rc = -EOPNOTSUPP;
> +                       goto out_fail;
> +               }
> +       }
> +#endif
> +
>         /* If the user really knows what they are doing they can override */
>         if (tcon->share_flags & SMB2_SHAREFLAG_NO_CACHING) {
>                 if (volume_info->cache_ro)
> @@ -5072,6 +5102,9 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
>         vol_info->sectype = master_tcon->ses->sectype;
>         vol_info->sign = master_tcon->ses->sign;
>         vol_info->seal = master_tcon->seal;
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       vol_info->witness = master_tcon->use_witness;
> +#endif
>
>         rc = cifs_set_vol_auth(vol_info, master_tcon->ses);
>         if (rc) {
> --
> 2.29.2
>


-- 
Thanks,

Steve

--000000000000a5b67105b63d6365
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-add-witness-mount-option-and-data-structs.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-witness-mount-option-and-data-structs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kil8mcaj0>
X-Attachment-Id: f_kil8mcaj0

RnJvbSAxMWRlOGQ1ZGMwNTIxZDdlNjc4MmZhYzg2MDViYjc2NDZkNjZkN2UzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW11ZWwgQ2FicmVybyA8c2NhYnJlcm9Ac3VzZS5kZT4KRGF0
ZTogRnJpLCAxMSBEZWMgMjAyMCAyMjo1OToyOSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIGNpZnM6
IGFkZCB3aXRuZXNzIG1vdW50IG9wdGlvbiBhbmQgZGF0YSBzdHJ1Y3RzCgpBZGQgJ3dpdG5lc3Mn
IG1vdW50IG9wdGlvbiB0byByZWdpc3RlciBmb3Igd2l0bmVzcyBub3RpZmljYXRpb25zLgoKU2ln
bmVkLW9mZi1ieTogU2FtdWVsIENhYnJlcm8gPHNjYWJyZXJvQHN1c2UuZGU+ClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Np
ZnNmcy5jICAgICB8ICA1ICsrKysrCiBmcy9jaWZzL2NpZnNnbG9iLmggICB8ICAzICsrKwogZnMv
Y2lmcy9jb25uZWN0LmMgICAgfCAyNSArKysrKysrKysrKysrKysrKysrKysrKysrCiBmcy9jaWZz
L2ZzX2NvbnRleHQuYyB8ICA4ICsrKysrKysrCiBmcy9jaWZzL2ZzX2NvbnRleHQuaCB8ICAyICsr
CiA1IGZpbGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZz
L2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCA1ZDMyNTYxYWUyZWQuLmY4MTBiMjVk
ZmViOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5j
CkBAIC02MzgsNiArNjM4LDExIEBAIGNpZnNfc2hvd19vcHRpb25zKHN0cnVjdCBzZXFfZmlsZSAq
cywgc3RydWN0IGRlbnRyeSAqcm9vdCkKIAkJc2VxX3ByaW50ZihzLCAiLG11bHRpY2hhbm5lbCxt
YXhfY2hhbm5lbHM9JXp1IiwKIAkJCSAgIHRjb24tPnNlcy0+Y2hhbl9tYXgpOwogCisjaWZkZWYg
Q09ORklHX0NJRlNfU1dOX1VQQ0FMTAorCWlmICh0Y29uLT51c2Vfd2l0bmVzcykKKwkJc2VxX3B1
dHMocywgIix3aXRuZXNzIik7CisjZW5kaWYKKwogCXJldHVybiAwOwogfQogCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggYjQ2ODA5MjYw
ZTc5Li43ODQzODEwMmYwOTEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9m
cy9jaWZzL2NpZnNnbG9iLmgKQEAgLTEwODYsNiArMTA4Niw5IEBAIHN0cnVjdCBjaWZzX3Rjb24g
ewogCWludCByZW1hcDoyOwogCXN0cnVjdCBsaXN0X2hlYWQgdWxpc3Q7IC8qIGNhY2hlIHVwZGF0
ZSBsaXN0ICovCiAjZW5kaWYKKyNpZmRlZiBDT05GSUdfQ0lGU19TV05fVVBDQUxMCisJYm9vbCB1
c2Vfd2l0bmVzczoxOyAvKiB1c2Ugd2l0bmVzcyBwcm90b2NvbCAqLworI2VuZGlmCiB9OwogCiAv
KgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRl
eCBlYzgwYjZjM2UyMGYuLjQ2ZDRmNTQ2OTY4OCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0
LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTE5NDQsNiArMTk0NCw4IEBAIGNpZnNfcHV0
X3Rjb24oc3RydWN0IGNpZnNfdGNvbiAqdGNvbikKIAkJcmV0dXJuOwogCX0KIAorCS8qIFRPRE8g
d2l0bmVzcyB1bnJlZ2lzdGVyICovCisKIAlsaXN0X2RlbF9pbml0KCZ0Y29uLT50Y29uX2xpc3Qp
OwogCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CiAKQEAgLTIxMDQsNiArMjEwNiwy
NiBAQCBjaWZzX2dldF90Y29uKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBzdHJ1Y3Qgc21iM19mc19j
b250ZXh0ICpjdHgpCiAJCX0KIAkJdGNvbi0+dXNlX3Jlc2lsaWVudCA9IHRydWU7CiAJfQorI2lm
ZGVmIENPTkZJR19DSUZTX1NXTl9VUENBTEwKKwl0Y29uLT51c2Vfd2l0bmVzcyA9IGZhbHNlOwor
CWlmIChjdHgtPndpdG5lc3MpIHsKKwkJaWYgKHNlcy0+c2VydmVyLT52YWxzLT5wcm90b2NvbF9p
ZCA+PSBTTUIzMF9QUk9UX0lEKSB7CisJCQlpZiAodGNvbi0+Y2FwYWJpbGl0aWVzICYgU01CMl9T
SEFSRV9DQVBfQ0xVU1RFUikgeworCQkJCS8qIFRPRE8gd2l0bmVzcyByZWdpc3RlciAqLworCQkJ
CXRjb24tPnVzZV93aXRuZXNzID0gdHJ1ZTsKKwkJCX0gZWxzZSB7CisJCQkJLyogVE9ETzogdHJ5
IHRvIGV4dGVuZCBmb3Igbm9uLWNsdXN0ZXIgdXNlcyAoZWcgbXVsdGljaGFubmVsKSAqLworCQkJ
CWNpZnNfZGJnKFZGUywgIndpdG5lc3MgcmVxdWVzdGVkIG9uIG1vdW50IGJ1dCBubyBDTFVTVEVS
IGNhcGFiaWxpdHkgb24gc2hhcmVcbiIpOworCQkJCXJjID0gLUVPUE5PVFNVUFA7CisJCQkJZ290
byBvdXRfZmFpbDsKKwkJCX0KKwkJfSBlbHNlIHsKKwkJCWNpZnNfZGJnKFZGUywgIlNNQjMgb3Ig
bGF0ZXIgcmVxdWlyZWQgZm9yIHdpdG5lc3Mgb3B0aW9uXG4iKTsKKwkJCXJjID0gLUVPUE5PVFNV
UFA7CisJCQlnb3RvIG91dF9mYWlsOworCQl9CisJfQorI2VuZGlmCiAKIAkvKiBJZiB0aGUgdXNl
ciByZWFsbHkga25vd3Mgd2hhdCB0aGV5IGFyZSBkb2luZyB0aGV5IGNhbiBvdmVycmlkZSAqLwog
CWlmICh0Y29uLT5zaGFyZV9mbGFncyAmIFNNQjJfU0hBUkVGTEFHX05PX0NBQ0hJTkcpIHsKQEAg
LTM4NTYsNiArMzg3OCw5IEBAIGNpZnNfY29uc3RydWN0X3Rjb24oc3RydWN0IGNpZnNfc2JfaW5m
byAqY2lmc19zYiwga3VpZF90IGZzdWlkKQogCWN0eC0+c2VjdHlwZSA9IG1hc3Rlcl90Y29uLT5z
ZXMtPnNlY3R5cGU7CiAJY3R4LT5zaWduID0gbWFzdGVyX3Rjb24tPnNlcy0+c2lnbjsKIAljdHgt
PnNlYWwgPSBtYXN0ZXJfdGNvbi0+c2VhbDsKKyNpZmRlZiBDT05GSUdfQ0lGU19TV05fVVBDQUxM
CisJY3R4LT53aXRuZXNzID0gbWFzdGVyX3Rjb24tPnVzZV93aXRuZXNzOworI2VuZGlmCiAKIAly
YyA9IGNpZnNfc2V0X3ZvbF9hdXRoKGN0eCwgbWFzdGVyX3Rjb24tPnNlcyk7CiAJaWYgKHJjKSB7
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5j
CmluZGV4IDkxMjBkMTQ4YzVmMS4uZmU1Y2M2MGY0MzkzIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Zz
X2NvbnRleHQuYworKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwpAQCAtMTE5LDYgKzExOSw3IEBA
IGNvbnN0IHN0cnVjdCBmc19wYXJhbWV0ZXJfc3BlYyBzbWIzX2ZzX3BhcmFtZXRlcnNbXSA9IHsK
IAlmc3BhcmFtX2ZsYWcoIm1vZGVzaWQiLCBPcHRfbW9kZXNpZCksCiAJZnNwYXJhbV9mbGFnKCJy
b290ZnMiLCBPcHRfcm9vdGZzKSwKIAlmc3BhcmFtX2ZsYWcoImNvbXByZXNzIiwgT3B0X2NvbXBy
ZXNzKSwKKwlmc3BhcmFtX2ZsYWcoIndpdG5lc3MiLCBPcHRfd2l0bmVzcyksCiAKIAkvKiBNb3Vu
dCBvcHRpb25zIHdoaWNoIHRha2UgbnVtZXJpYyB2YWx1ZSAqLwogCWZzcGFyYW1fdTMyKCJiYWNr
dXB1aWQiLCBPcHRfYmFja3VwdWlkKSwKQEAgLTEwMDQsNiArMTAwNSwxMyBAQCBzdGF0aWMgaW50
IHNtYjNfZnNfY29udGV4dF9wYXJzZV9wYXJhbShzdHJ1Y3QgZnNfY29udGV4dCAqZmMsCiAJCWlm
IChjaWZzX3BhcnNlX2NhY2hlX2ZsYXZvcihwYXJhbS0+c3RyaW5nLCBjdHgpICE9IDApCiAJCQln
b3RvIGNpZnNfcGFyc2VfbW91bnRfZXJyOwogCQlicmVhazsKKwljYXNlIE9wdF93aXRuZXNzOgor
I2lmbmRlZiBDT05GSUdfQ0lGU19TV05fVVBDQUxMCisJCWNpZnNfZGJnKFZGUywgIldpdG5lc3Mg
c3VwcG9ydCBuZWVkcyBDT05GSUdfQ0lGU19TV05fVVBDQUxMIGNvbmZpZyBvcHRpb25cbiIpOwor
CQkJZ290byBjaWZzX3BhcnNlX21vdW50X2VycjsKKyNlbmRpZgorCQljdHgtPndpdG5lc3MgPSB0
cnVlOworCQlicmVhazsKIAljYXNlIE9wdF9yb290ZnM6CiAjaWZkZWYgQ09ORklHX0NJRlNfUk9P
VAogCQljdHgtPnJvb3RmcyA9IHRydWU7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQu
aCBiL2ZzL2NpZnMvZnNfY29udGV4dC5oCmluZGV4IGQ0YTkwNWE4MDg4My4uYWFlYzhhODE5ZDM0
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQuaAorKysgYi9mcy9jaWZzL2ZzX2NvbnRl
eHQuaApAQCAtMTAyLDYgKzEwMiw3IEBAIGVudW0gY2lmc19wYXJhbSB7CiAJT3B0X3Jvb3RmcywK
IAlPcHRfbXVsdGljaGFubmVsLAogCU9wdF9jb21wcmVzcywKKwlPcHRfd2l0bmVzcywKIAogCS8q
IE1vdW50IG9wdGlvbnMgd2hpY2ggdGFrZSBudW1lcmljIHZhbHVlICovCiAJT3B0X2JhY2t1cHVp
ZCwKQEAgLTI0MSw2ICsyNDIsNyBAQCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0IHsKIAl1bnNpZ25l
ZCBpbnQgbWF4X2NoYW5uZWxzOwogCV9fdTE2IGNvbXByZXNzaW9uOyAvKiBjb21wcmVzc2lvbiBh
bGdvcml0aG0gMHhGRkZGIGRlZmF1bHQgMD1kaXNhYmxlZCAqLwogCWJvb2wgcm9vdGZzOjE7IC8q
IGlmIGl0J3MgYSBTTUIgcm9vdCBmaWxlIHN5c3RlbSAqLworCWJvb2wgd2l0bmVzczoxOyAvKiB1
c2Ugd2l0bmVzcyBwcm90b2NvbCAqLwogCiAJY2hhciAqbW91bnRfb3B0aW9uczsKIH07Ci0tIAoy
LjI3LjAKCg==
--000000000000a5b67105b63d6365--
