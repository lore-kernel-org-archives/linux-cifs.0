Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A70C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 23:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJQXwf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 19:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJQXwe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 19:52:34 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688F57AC35
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 16:52:33 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id 63so13142668vse.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 16:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zcu6y4j1/zQoEFZPUIbVqyEU3wTMIQlOVTJxJcVuVUs=;
        b=GYhA/FRFsJYEBGCWsblrm+eeUxihRD+Ou6dv9PxxpJdD7e9xR5IVQ/TVh06G7QzwmL
         3M+87p0znpwoo+c3l3JiTEvVWj3CGsMPX5akCyyDnGYQTwVU76hV6Im8WNYkzCmwgZIt
         WfDLr0Ca51YU72PKN3uCy7CYNLy6igtN4DHKh+NWeDdt79q4BezeYy5tcRMjU28ryEWb
         bY+Rn6gEQrN2Z6GAacsKED37ryasHZP9y/AqTYPpnmK5g0zuh06uil2j+MNCbzbdpXhl
         qFVl6KsOBdjnNjWmA2gpAqJv3mROiIPUr/ZUXIRXCCyJgrZW/uyeMb+2h+j/Gw4GO0Bx
         LP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zcu6y4j1/zQoEFZPUIbVqyEU3wTMIQlOVTJxJcVuVUs=;
        b=I7HkIrGa3eTHGL+0NA71rXEOTCidP7lRG/T8+ZOp8gKdR7Y0QkORAKPULSGvSaydgS
         N0kAxAbVbsuLakypCnDpnkzGGu7uWNarLHkrcRITxDV87DwDMwmA0B5CXsrZlpeQffRr
         0CB9/gE6l0mnuPXi7TZimpWHvcILCdnrFKFWDSkMSLJBczuigpRXMihhZdIEFEe9oeBK
         3pXu2SHdqphf8DpPworRorRVo5t0Zqr/EXzQLj3E/HUeZlVH4u7NnjQlm4BYeHjeERcC
         uTVymtT/MhUMi1+52/TRu/ZlHZd912i/bphFpMHBt2kc48VRgtmpD5Ab3/Q8JrIdIowK
         xdJw==
X-Gm-Message-State: ACrzQf2YI3lz0iRlC9YYUCKWFPLwwI7ZvjdasYxlz1iHL30AJBH6cX5P
        3rKGQ6icf4yLKDexy8yTYmCwruPVOjoOxL2hIkI=
X-Google-Smtp-Source: AMsMyM5Cyx/o84fRkt/oSJhSTi1VIMsNm+ajt262eo0jtQdftff7+oI/ntPlMwH2DbVPEdmhGaXsRrVSrtUnLy550sU=
X-Received: by 2002:a05:6102:22d6:b0:3a7:c599:e02c with SMTP id
 a22-20020a05610222d600b003a7c599e02cmr73098vsh.61.1666050752357; Mon, 17 Oct
 2022 16:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221017233201.1716316-1-lsahlber@redhat.com> <20221017233201.1716316-2-lsahlber@redhat.com>
In-Reply-To: <20221017233201.1716316-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Oct 2022 18:52:21 -0500
Message-ID: <CAH2r5mtzftoAm147vbe80n7hWA403cT=HbfrTqa3ButyGH-Bag@mail.gmail.com>
Subject: Re: [PATCH] cifs: set rc to -ENOENT if we can not get a dentry for
 the cached dir
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Dan carpenter <dan.carpenter@oracle.com>,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Content-Type: multipart/mixed; boundary="00000000000045be8105eb43ab1a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000045be8105eb43ab1a
Content-Type: text/plain; charset="UTF-8"

Lightly updated to deal with merge conflict with "cifs: use
LIST_HEAD() and list_move() to simplify code" and merged into
cifs-2.6.git for-next pending review and testing

See attached update patch.

On Mon, Oct 17, 2022 at 6:32 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> We already set rc to this return code further down in the function but
> we can set it earlier in order to suppress a smash warning.
>
> Also fix a false positive for Coverity. The reason this is a false positive is
> that this happens during umount after all files and directories have been closed
> but mosetting on ->on_list to suppress the warning.
>
> Reported-by: Dan carpenter <dan.carpenter@oracle.com>
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1525256 ("Concurrent data access violations")
> Fixes: a350d6e73f5e ("cifs: enable caching of directories for which a lease is held")
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index fe88b67c863f..ffc924296e59 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -253,8 +253,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>                 dentry = dget(cifs_sb->root);
>         else {
>                 dentry = path_to_dentry(cifs_sb, path);
> -               if (IS_ERR(dentry))
> +               if (IS_ERR(dentry)) {
> +                       rc = -ENOENT;
>                         goto oshr_free;
> +               }
>         }
>         cfid->dentry = dentry;
>         cfid->tcon = tcon;
> @@ -387,13 +389,13 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
>                 list_add(&cfid->entry, &entry);
>                 cfids->num_entries--;
>                 cfid->is_open = false;
> +               cfid->on_list = false;
>                 /* To prevent race with smb2_cached_lease_break() */
>                 kref_get(&cfid->refcount);
>         }
>         spin_unlock(&cfids->cfid_list_lock);
>
>         list_for_each_entry_safe(cfid, q, &entry, entry) {
> -               cfid->on_list = false;
>                 list_del(&cfid->entry);
>                 cancel_work_sync(&cfid->lease_break);
>                 if (cfid->has_lease) {
> --
> 2.35.3
>


-- 
Thanks,

Steve

--00000000000045be8105eb43ab1a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-set-rc-to-ENOENT-if-we-can-not-get-a-dentry-for.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-set-rc-to-ENOENT-if-we-can-not-get-a-dentry-for.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9dfkvba0>
X-Attachment-Id: f_l9dfkvba0

RnJvbSAxYjAyODY4MjUyOGNhODY1NTljYWQ1MzExZWI1MmI1NzMzM2NlY2YwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IE1vbiwgMTcgT2N0IDIwMjIgMTg6NDg6MjYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBzZXQgcmMgdG8gLUVOT0VOVCBpZiB3ZSBjYW4gbm90IGdldCBhIGRlbnRyeSBmb3IgdGhl
CiBjYWNoZWQgZGlyCgpXZSBhbHJlYWR5IHNldCByYyB0byB0aGlzIHJldHVybiBjb2RlIGZ1cnRo
ZXIgZG93biBpbiB0aGUgZnVuY3Rpb24gYnV0CndlIGNhbiBzZXQgaXQgZWFybGllciBpbiBvcmRl
ciB0byBzdXBwcmVzcyBhIHNtYXNoIHdhcm5pbmcuCgpBbHNvIGZpeCBhIGZhbHNlIHBvc2l0aXZl
IGZvciBDb3Zlcml0eS4gVGhlIHJlYXNvbiB0aGlzIGlzIGEgZmFsc2UgcG9zaXRpdmUgaXMKdGhh
dCB0aGlzIGhhcHBlbnMgZHVyaW5nIHVtb3VudCBhZnRlciBhbGwgZmlsZXMgYW5kIGRpcmVjdG9y
aWVzIGhhdmUgYmVlbiBjbG9zZWQKYnV0IG1vc2V0dGluZyBvbiAtPm9uX2xpc3QgdG8gc3VwcHJl
c3MgdGhlIHdhcm5pbmcuCgpSZXBvcnRlZC1ieTogRGFuIGNhcnBlbnRlciA8ZGFuLmNhcnBlbnRl
ckBvcmFjbGUuY29tPgpSZXBvcnRlZC1ieTogY292ZXJpdHktYm90IDxrZWVzY29vaytjb3Zlcml0
eS1ib3RAY2hyb21pdW0ub3JnPgpBZGRyZXNzZXMtQ292ZXJpdHktSUQ6IDE1MjUyNTYgKCJDb25j
dXJyZW50IGRhdGEgYWNjZXNzIHZpb2xhdGlvbnMiKQpGaXhlczogYTM1MGQ2ZTczZjVlICgiY2lm
czogZW5hYmxlIGNhY2hpbmcgb2YgZGlyZWN0b3JpZXMgZm9yIHdoaWNoIGEgbGVhc2UgaXMgaGVs
ZCIpClNpZ25lZC1vZmYtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4K
LS0tCiBmcy9jaWZzL2NhY2hlZF9kaXIuYyB8IDYgKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2FjaGVk
X2Rpci5jIGIvZnMvY2lmcy9jYWNoZWRfZGlyLmMKaW5kZXggOGNhZDUyOGE4NzIyLi4yMGVmYzll
MjI3NjEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2FjaGVkX2Rpci5jCisrKyBiL2ZzL2NpZnMvY2Fj
aGVkX2Rpci5jCkBAIC0yNTMsOCArMjUzLDEwIEBAIGludCBvcGVuX2NhY2hlZF9kaXIodW5zaWdu
ZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJZGVudHJ5ID0gZGdldChjaWZz
X3NiLT5yb290KTsKIAllbHNlIHsKIAkJZGVudHJ5ID0gcGF0aF90b19kZW50cnkoY2lmc19zYiwg
cGF0aCk7Ci0JCWlmIChJU19FUlIoZGVudHJ5KSkKKwkJaWYgKElTX0VSUihkZW50cnkpKSB7CisJ
CQlyYyA9IC1FTk9FTlQ7CiAJCQlnb3RvIG9zaHJfZnJlZTsKKwkJfQogCX0KIAljZmlkLT5kZW50
cnkgPSBkZW50cnk7CiAJY2ZpZC0+dGNvbiA9IHRjb247CkBAIC0zODUsMTMgKzM4NywxMyBAQCB2
b2lkIGludmFsaWRhdGVfYWxsX2NhY2hlZF9kaXJzKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiAJ
CWxpc3RfbW92ZSgmY2ZpZC0+ZW50cnksICZlbnRyeSk7CiAJCWNmaWRzLT5udW1fZW50cmllcy0t
OwogCQljZmlkLT5pc19vcGVuID0gZmFsc2U7CisJCWNmaWQtPm9uX2xpc3QgPSBmYWxzZTsKIAkJ
LyogVG8gcHJldmVudCByYWNlIHdpdGggc21iMl9jYWNoZWRfbGVhc2VfYnJlYWsoKSAqLwogCQlr
cmVmX2dldCgmY2ZpZC0+cmVmY291bnQpOwogCX0KIAlzcGluX3VubG9jaygmY2ZpZHMtPmNmaWRf
bGlzdF9sb2NrKTsKIAogCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShjZmlkLCBxLCAmZW50cnks
IGVudHJ5KSB7Ci0JCWNmaWQtPm9uX2xpc3QgPSBmYWxzZTsKIAkJbGlzdF9kZWwoJmNmaWQtPmVu
dHJ5KTsKIAkJY2FuY2VsX3dvcmtfc3luYygmY2ZpZC0+bGVhc2VfYnJlYWspOwogCQlpZiAoY2Zp
ZC0+aGFzX2xlYXNlKSB7Ci0tIAoyLjM0LjEKCg==
--00000000000045be8105eb43ab1a--
