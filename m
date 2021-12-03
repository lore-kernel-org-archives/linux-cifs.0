Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C98FC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 16:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbhLCQXC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhLCQXC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 11:23:02 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C6CC061751
        for <linux-cifs@vger.kernel.org>; Fri,  3 Dec 2021 08:19:37 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id l7so7208816lja.2
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 08:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZBhD/1U/k25w1mixqg4bXBvZ3V6TEwVf0Cf0EbBWxU=;
        b=jQvQQpTdHDNLfc62zVuo/aaobxhVXmyhlBZN2fVawCVGUUu4nhBnp7NH9oyeukGmU4
         fxHw1wyJ8QZooq/Mva2Kzls4GmB1bmUmb7cn267fPTf7acZq8zolQ3Pn2yOVYlri448u
         BrwwKuNuzNZ0XRaClRE4V47Zzo5tYFClSeomDQEsHc4TmhJ1bBJD4Zz4O3CYwnKGlaGz
         zFaj07yiOxbTqmD2wysWGx8TywoWPvHf8ovt8EXGmeEcgdgjp7UA5SHcoo6aQ7i/e6fm
         A4dy3uz2Ic4m0Ks+v0mHiXX0dQSBp0zzkBWpHryjwwFvUR70K1d1KCvm60x2qRYY70B/
         0/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZBhD/1U/k25w1mixqg4bXBvZ3V6TEwVf0Cf0EbBWxU=;
        b=x81obrd7sQB6wTJ0GkHzOAM+WHvl+YNGIjLN+jx87HLFBzQCxss6DvChKqQWnEQDmS
         fo+p5Ojm1940lbnlImAfC3GTzoKjHjjIc3Nuh1HRSZoSGFufuZv0nFpeuSYEpooYCAKs
         nDQQP/8hgBk+jPZClQN4eQxk0nw/YDJtDcddzw2aNVHmeoDTJaYQiFYrL/Zpos3WJljf
         BM30r8flX61fM4674YfXzQ4POTNmJqGPSItRkM04OBwHt7lVbJY9EueGAKN9eRuIPLri
         BFXUM6lzDgtVozei7PzDIF3eZOEdtD5lHPG3aNNEc15ey3rZpVmXqfp4jQ0LwZuQ+nCa
         XrBA==
X-Gm-Message-State: AOAM5332aW+4nhipRoQq3uLEu+bfgENc3vlizpfVk1hTXBSX1HwK81AN
        /xSekP6rwbmVQCdwE3kBQ4gWp4d6gI7lhn9u0m+ezB8/
X-Google-Smtp-Source: ABdhPJx/+q1WN0YPvV4t5n3oriiZhKM+OfRv0p5r15h2dYZbHXy62GjR3YT3yy3FCI363Xvw2ghyhGMGm94EqMtkLoQ=
X-Received: by 2002:a2e:7114:: with SMTP id m20mr19031761ljc.229.1638548375824;
 Fri, 03 Dec 2021 08:19:35 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
In-Reply-To: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 3 Dec 2021 10:19:24 -0600
Message-ID: <CAH2r5mtShLhuST2jdpw-W9p9KbK5BXQpQwF4tycbnNKQTZ5Aww@mail.gmail.com>
Subject: Re: [PATCH] cifs: wait for tcon resource_id before getting fscache super
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        linux-cachefs@redhat.com
Content-Type: multipart/mixed; boundary="000000000000e4443105d2404537"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e4443105d2404537
Content-Type: text/plain; charset="UTF-8"

These are what I had downloaded and tentatively merged into
cifs-2.6.git for-next

On Fri, Dec 3, 2021 at 3:23 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> The logic for initializing tcon->resource_id is done inside
> cifs_root_iget. fscache super cookie relies on this for aux
> data. So we need to push the fscache initialization to this
> later point during mount.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/connect.c | 6 ------
>  fs/cifs/fscache.c | 2 +-
>  fs/cifs/inode.c   | 7 +++++++
>  3 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6b705026da1a3..eee994b0925ff 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3046,12 +3046,6 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
>   cifs_dbg(VFS, "read only mount of RW share\n");
>   /* no need to log a RW mount of a typical RW share */
>   }
> - /*
> - * The cookie is initialized from volume info returned above.
> - * Inside cifs_fscache_get_super_cookie it checks
> - * that we do not get super cookie twice.
> - */
> - cifs_fscache_get_super_cookie(tcon);
>   }
>
>   /*
> diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
> index 7e409a38a2d7c..f4da693760c11 100644
> --- a/fs/cifs/fscache.c
> +++ b/fs/cifs/fscache.c
> @@ -92,7 +92,7 @@ void cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
>   * In the future, as we integrate with newer fscache features,
>   * we may want to instead add a check if cookie has changed
>   */
> - if (tcon->fscache == NULL)
> + if (tcon->fscache)
>   return;
>
>   sharename = extract_sharename(tcon->treeName);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 82848412ad852..96d083db17372 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1376,6 +1376,13 @@ struct inode *cifs_root_iget(struct super_block *sb)
>   inode = ERR_PTR(rc);
>   }
>
> + /*
> + * The cookie is initialized from volume info returned above.
> + * Inside cifs_fscache_get_super_cookie it checks
> + * that we do not get super cookie twice.
> + */
> + cifs_fscache_get_super_cookie(tcon);
> +
>  out:
>   kfree(path);
>   free_xid(xid);



-- 
Thanks,

Steve

--000000000000e4443105d2404537
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="1shyam-d70e50047c7daa3de17c7c41a0c4ef4f9e4443c9.patch"
Content-Disposition: attachment; 
	filename="1shyam-d70e50047c7daa3de17c7c41a0c4ef4f9e4443c9.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kwqldfuh0>
X-Attachment-Id: f_kwqldfuh0

RnJvbSBkNzBlNTAwNDdjN2RhYTNkZTE3YzdjNDFhMGM0ZWY0ZjllNDQ0M2M5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDIgRGVjIDIwMjEgMDc6MTQ6NDIgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiB3YWl0IGZvciB0Y29uIHJlc291cmNlX2lkIGJlZm9yZSBnZXR0aW5nIGZzY2FjaGUgc3Vw
ZXIKClRoZSBsb2dpYyBmb3IgaW5pdGlhbGl6aW5nIHRjb24tPnJlc291cmNlX2lkIGlzIGRvbmUg
aW5zaWRlCmNpZnNfcm9vdF9pZ2V0LiBmc2NhY2hlIHN1cGVyIGNvb2tpZSByZWxpZXMgb24gdGhp
cyBmb3IgYXV4CmRhdGEuIFNvIHdlIG5lZWQgdG8gcHVzaCB0aGUgZnNjYWNoZSBpbml0aWFsaXph
dGlvbiB0byB0aGlzCmxhdGVyIHBvaW50IGR1cmluZyBtb3VudC4KClNpZ25lZC1vZmYtYnk6IFNo
eWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0
LmMgfCA2IC0tLS0tLQogZnMvY2lmcy9mc2NhY2hlLmMgfCAyICstCiBmcy9jaWZzL2lub2RlLmMg
ICB8IDcgKysrKysrKwogMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDcgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3Qu
YwppbmRleCA2YjcwNTAyNmRhMWEzLi5lZWU5OTRiMDkyNWZmIDEwMDY0NAotLS0gYS9mcy9jaWZz
L2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMzA0NiwxMiArMzA0Niw2IEBA
IHN0YXRpYyBpbnQgbW91bnRfZ2V0X2Nvbm5zKHN0cnVjdCBtb3VudF9jdHggKm1udF9jdHgpCiAJ
CQkJY2lmc19kYmcoVkZTLCAicmVhZCBvbmx5IG1vdW50IG9mIFJXIHNoYXJlXG4iKTsKIAkJCS8q
IG5vIG5lZWQgdG8gbG9nIGEgUlcgbW91bnQgb2YgYSB0eXBpY2FsIFJXIHNoYXJlICovCiAJCX0K
LQkJLyoKLQkJICogVGhlIGNvb2tpZSBpcyBpbml0aWFsaXplZCBmcm9tIHZvbHVtZSBpbmZvIHJl
dHVybmVkIGFib3ZlLgotCQkgKiBJbnNpZGUgY2lmc19mc2NhY2hlX2dldF9zdXBlcl9jb29raWUg
aXQgY2hlY2tzCi0JCSAqIHRoYXQgd2UgZG8gbm90IGdldCBzdXBlciBjb29raWUgdHdpY2UuCi0J
CSAqLwotCQljaWZzX2ZzY2FjaGVfZ2V0X3N1cGVyX2Nvb2tpZSh0Y29uKTsKIAl9CiAKIAkvKgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9mc2NhY2hlLmMgYi9mcy9jaWZzL2ZzY2FjaGUuYwppbmRleCA3
ZTQwOWEzOGEyZDdjLi5mNGRhNjkzNzYwYzExIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzY2FjaGUu
YworKysgYi9mcy9jaWZzL2ZzY2FjaGUuYwpAQCAtOTIsNyArOTIsNyBAQCB2b2lkIGNpZnNfZnNj
YWNoZV9nZXRfc3VwZXJfY29va2llKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiAJICogSW4gdGhl
IGZ1dHVyZSwgYXMgd2UgaW50ZWdyYXRlIHdpdGggbmV3ZXIgZnNjYWNoZSBmZWF0dXJlcywKIAkg
KiB3ZSBtYXkgd2FudCB0byBpbnN0ZWFkIGFkZCBhIGNoZWNrIGlmIGNvb2tpZSBoYXMgY2hhbmdl
ZAogCSAqLwotCWlmICh0Y29uLT5mc2NhY2hlID09IE5VTEwpCisJaWYgKHRjb24tPmZzY2FjaGUp
CiAJCXJldHVybjsKIAogCXNoYXJlbmFtZSA9IGV4dHJhY3Rfc2hhcmVuYW1lKHRjb24tPnRyZWVO
YW1lKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRl
eCA4Mjg0ODQxMmFkODUyLi45NmQwODNkYjE3MzcyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2lub2Rl
LmMKKysrIGIvZnMvY2lmcy9pbm9kZS5jCkBAIC0xMzc2LDYgKzEzNzYsMTMgQEAgc3RydWN0IGlu
b2RlICpjaWZzX3Jvb3RfaWdldChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCQlpbm9kZSA9IEVS
Ul9QVFIocmMpOwogCX0KIAorCS8qCisJICogVGhlIGNvb2tpZSBpcyBpbml0aWFsaXplZCBmcm9t
IHZvbHVtZSBpbmZvIHJldHVybmVkIGFib3ZlLgorCSAqIEluc2lkZSBjaWZzX2ZzY2FjaGVfZ2V0
X3N1cGVyX2Nvb2tpZSBpdCBjaGVja3MKKwkgKiB0aGF0IHdlIGRvIG5vdCBnZXQgc3VwZXIgY29v
a2llIHR3aWNlLgorCSAqLworCWNpZnNfZnNjYWNoZV9nZXRfc3VwZXJfY29va2llKHRjb24pOwor
CiBvdXQ6CiAJa2ZyZWUocGF0aCk7CiAJZnJlZV94aWQoeGlkKTsK
--000000000000e4443105d2404537
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="2shyam-089dd629653b857b6096966e9d2df301653a36ea.patch"
Content-Disposition: attachment; 
	filename="2shyam-089dd629653b857b6096966e9d2df301653a36ea.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kwqldfuy1>
X-Attachment-Id: f_kwqldfuy1

RnJvbSAwODlkZDYyOTY1M2I4NTdiNjA5Njk2NmU5ZDJkZjMwMTY1M2EzNmVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDIgRGVjIDIwMjEgMDc6MzA6MDAgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhZGQgc2VydmVyIGNvbm5faWQgdG8gZnNjYWNoZSBjbGllbnQgY29va2llCgpUaGUgZnNj
YWNoZSBjbGllbnQgY29va2llIHVzZXMgdGhlIHNlcnZlciBhZGRyZXNzCihhbmQgcG9ydCkgYXMg
dGhlIGNvb2tpZSBrZXkuIFRoaXMgaXMgYSBwcm9ibGVtIHdoZW4Kbm9zaGFyZXNvY2sgaXMgdXNl
ZC4gVHdvIGRpZmZlcmVudCBjb25uZWN0aW9ucyB3aWxsCnVzZSBkdXBsaWNhdGUgY29va2llcy4g
QXZvaWQgdGhpcyBieSBhZGRpbmcKc2VydmVyLT5jb25uX2lkIHRvIHRoZSBrZXksIHNvIHRoYXQg
aXQncyBndWFyYW50ZWVkCnRoYXQgY29va2llIHdpbGwgbm90IGJlIGR1cGxpY2F0ZWQuCgpBbHNv
LCBmb3Igc2Vjb25kYXJ5IGNoYW5uZWxzIG9mIGEgc2Vzc2lvbiwgY29weSB0aGUKZnNjYWNoZSBw
b2ludGVyIGZyb20gdGhlIHByaW1hcnkgY2hhbm5lbC4gVGhlIHByaW1hcnkKY2hhbm5lbCBpcyBn
dWFyYW50ZWVkIG5vdCB0byBnbyBhd2F5IGFzIGxvbmcgYXMgc2Vjb25kYXJ5CmNoYW5uZWxzIGFy
ZSBpbiB1c2UuCgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgIDIgKysKIGZzL2NpZnMvZnNjYWNoZS5j
IHwgMTAgKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspCgpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBlZWU5
OTRiMDkyNWYuLmQ4ODIyZTgzNWNjNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysr
IGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTE1NjIsNiArMTU2Miw4IEBAIGNpZnNfZ2V0X3RjcF9z
ZXNzaW9uKHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCwKIAkvKiBmc2NhY2hlIHNlcnZlciBj
b29raWVzIGFyZSBiYXNlZCBvbiBwcmltYXJ5IGNoYW5uZWwgb25seSAqLwogCWlmICghQ0lGU19T
RVJWRVJfSVNfQ0hBTih0Y3Bfc2VzKSkKIAkJY2lmc19mc2NhY2hlX2dldF9jbGllbnRfY29va2ll
KHRjcF9zZXMpOworCWVsc2UKKwkJdGNwX3Nlcy0+ZnNjYWNoZSA9IHRjcF9zZXMtPnByaW1hcnlf
c2VydmVyLT5mc2NhY2hlOwogCiAJLyogcXVldWUgZWNobyByZXF1ZXN0IGRlbGF5ZWQgd29yayAq
LwogCXF1ZXVlX2RlbGF5ZWRfd29yayhjaWZzaW9kX3dxLCAmdGNwX3Nlcy0+ZWNobywgdGNwX3Nl
cy0+ZWNob19pbnRlcnZhbCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzY2FjaGUuYyBiL2ZzL2Np
ZnMvZnNjYWNoZS5jCmluZGV4IGY0ZGE2OTM3NjBjMS4uMWRiMzQzN2YzYjdkIDEwMDY0NAotLS0g
YS9mcy9jaWZzL2ZzY2FjaGUuYworKysgYi9mcy9jaWZzL2ZzY2FjaGUuYwpAQCAtMjQsNiArMjQs
NyBAQCBzdHJ1Y3QgY2lmc19zZXJ2ZXJfa2V5IHsKIAkJc3RydWN0IGluX2FkZHIJaXB2NF9hZGRy
OwogCQlzdHJ1Y3QgaW42X2FkZHIJaXB2Nl9hZGRyOwogCX07CisJX191NjQgY29ubl9pZDsKIH0g
X19wYWNrZWQ7CiAKIC8qCkBAIC0zNyw2ICszOCwxNCBAQCB2b2lkIGNpZnNfZnNjYWNoZV9nZXRf
Y2xpZW50X2Nvb2tpZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJc3RydWN0IGNp
ZnNfc2VydmVyX2tleSBrZXk7CiAJdWludDE2X3Qga2V5X2xlbiA9IHNpemVvZihrZXkuaGRyKTsK
IAorCS8qCisJICogQ2hlY2sgaWYgY29va2llIHdhcyBhbHJlYWR5IGluaXRpYWxpemVkIHNvIGRv
bid0IHJlaW5pdGlhbGl6ZSBpdC4KKwkgKiBJbiB0aGUgZnV0dXJlLCBhcyB3ZSBpbnRlZ3JhdGUg
d2l0aCBuZXdlciBmc2NhY2hlIGZlYXR1cmVzLAorCSAqIHdlIG1heSB3YW50IHRvIGluc3RlYWQg
YWRkIGEgY2hlY2sgaWYgY29va2llIGhhcyBjaGFuZ2VkCisJICovCisJaWYgKHNlcnZlci0+ZnNj
YWNoZSkKKwkJcmV0dXJuOworCiAJbWVtc2V0KCZrZXksIDAsIHNpemVvZihrZXkpKTsKIAogCS8q
CkBAIC02Miw2ICs3MSw3IEBAIHZvaWQgY2lmc19mc2NhY2hlX2dldF9jbGllbnRfY29va2llKHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAkJc2VydmVyLT5mc2NhY2hlID0gTlVMTDsK
IAkJcmV0dXJuOwogCX0KKwlrZXkuY29ubl9pZCA9IHNlcnZlci0+Y29ubl9pZDsKIAogCXNlcnZl
ci0+ZnNjYWNoZSA9CiAJCWZzY2FjaGVfYWNxdWlyZV9jb29raWUoY2lmc19mc2NhY2hlX25ldGZz
LnByaW1hcnlfaW5kZXgsCg==
--000000000000e4443105d2404537
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="3shyam-a9a62cdfe26c782dadd0b94ab529b883426d0acd.patch"
Content-Disposition: attachment; 
	filename="3shyam-a9a62cdfe26c782dadd0b94ab529b883426d0acd.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kwqldfuz2>
X-Attachment-Id: f_kwqldfuz2

RnJvbSBhOWE2MmNkZmUyNmM3ODJkYWRkMGI5NGFiNTI5Yjg4MzQyNmQwYWNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDIgRGVjIDIwMjEgMDc6NDY6NTQgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhdm9pZCB1c2Ugb2YgZHN0YWRkciBhcyBrZXkgZm9yIGZzY2FjaGUgY2xpZW50IGNvb2tp
ZQoKc2VydmVyLT5kc3RhZGRyIGNhbiBjaGFuZ2Ugd2hlbiB0aGUgRE5TIG1hcHBpbmcgZm9yIHRo
ZQpzZXJ2ZXIgaG9zdG5hbWUgY2hhbmdlcy4gQnV0IGNvbm5faWQgaXMgYSB1NjQgY291bnRlcgp0
aGF0IGlzIGluY3JlbWVudGVkIGVhY2ggdGltZSBhIG5ldyBUQ1AgY29ubmVjdGlvbgppcyBzZXR1
cC4gU28gdXNlIG9ubHkgdGhhdCBhcyBhIGtleS4KClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNh
ZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9mc2NhY2hlLmMgfCAzOCAr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCAzNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzY2Fj
aGUuYyBiL2ZzL2NpZnMvZnNjYWNoZS5jCmluZGV4IDFkYjM0MzdmM2I3ZC4uMDAzYzVmMWY0ZGZi
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzY2FjaGUuYworKysgYi9mcy9jaWZzL2ZzY2FjaGUuYwpA
QCAtMTYsMTQgKzE2LDYgQEAKICAqIEtleSBsYXlvdXQgb2YgQ0lGUyBzZXJ2ZXIgY2FjaGUgaW5k
ZXggb2JqZWN0CiAgKi8KIHN0cnVjdCBjaWZzX3NlcnZlcl9rZXkgewotCXN0cnVjdCB7Ci0JCXVp
bnQxNl90CWZhbWlseTsJCS8qIGFkZHJlc3MgZmFtaWx5ICovCi0JCV9fYmUxNgkJcG9ydDsJCS8q
IElQIHBvcnQgKi8KLQl9IGhkcjsKLQl1bmlvbiB7Ci0JCXN0cnVjdCBpbl9hZGRyCWlwdjRfYWRk
cjsKLQkJc3RydWN0IGluNl9hZGRyCWlwdjZfYWRkcjsKLQl9OwogCV9fdTY0IGNvbm5faWQ7CiB9
IF9fcGFja2VkOwogCkBAIC0zMiwxMSArMjQsNyBAQCBzdHJ1Y3QgY2lmc19zZXJ2ZXJfa2V5IHsK
ICAqLwogdm9pZCBjaWZzX2ZzY2FjaGVfZ2V0X2NsaWVudF9jb29raWUoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyKQogewotCWNvbnN0IHN0cnVjdCBzb2NrYWRkciAqc2EgPSAoc3RydWN0
IHNvY2thZGRyICopICZzZXJ2ZXItPmRzdGFkZHI7Ci0JY29uc3Qgc3RydWN0IHNvY2thZGRyX2lu
ICphZGRyID0gKHN0cnVjdCBzb2NrYWRkcl9pbiAqKSBzYTsKLQljb25zdCBzdHJ1Y3Qgc29ja2Fk
ZHJfaW42ICphZGRyNiA9IChzdHJ1Y3Qgc29ja2FkZHJfaW42ICopIHNhOwogCXN0cnVjdCBjaWZz
X3NlcnZlcl9rZXkga2V5OwotCXVpbnQxNl90IGtleV9sZW4gPSBzaXplb2Yoa2V5Lmhkcik7CiAK
IAkvKgogCSAqIENoZWNrIGlmIGNvb2tpZSB3YXMgYWxyZWFkeSBpbml0aWFsaXplZCBzbyBkb24n
dCByZWluaXRpYWxpemUgaXQuCkBAIC00NywzNiArMzUsMTIgQEAgdm9pZCBjaWZzX2ZzY2FjaGVf
Z2V0X2NsaWVudF9jb29raWUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQlyZXR1
cm47CiAKIAltZW1zZXQoJmtleSwgMCwgc2l6ZW9mKGtleSkpOwotCi0JLyoKLQkgKiBTaG91bGQg
bm90IGJlIGEgcHJvYmxlbSBhcyBzaW5fZmFtaWx5L3NpbjZfZmFtaWx5IG92ZXJsYXlzCi0JICog
c2FfZmFtaWx5IGZpZWxkCi0JICovCi0Ja2V5Lmhkci5mYW1pbHkgPSBzYS0+c2FfZmFtaWx5Owot
CXN3aXRjaCAoc2EtPnNhX2ZhbWlseSkgewotCWNhc2UgQUZfSU5FVDoKLQkJa2V5Lmhkci5wb3J0
ID0gYWRkci0+c2luX3BvcnQ7Ci0JCWtleS5pcHY0X2FkZHIgPSBhZGRyLT5zaW5fYWRkcjsKLQkJ
a2V5X2xlbiArPSBzaXplb2Yoa2V5LmlwdjRfYWRkcik7Ci0JCWJyZWFrOwotCi0JY2FzZSBBRl9J
TkVUNjoKLQkJa2V5Lmhkci5wb3J0ID0gYWRkcjYtPnNpbjZfcG9ydDsKLQkJa2V5LmlwdjZfYWRk
ciA9IGFkZHI2LT5zaW42X2FkZHI7Ci0JCWtleV9sZW4gKz0gc2l6ZW9mKGtleS5pcHY2X2FkZHIp
OwotCQlicmVhazsKLQotCWRlZmF1bHQ6Ci0JCWNpZnNfZGJnKFZGUywgIlVua25vd24gbmV0d29y
ayBmYW1pbHkgJyVkJ1xuIiwgc2EtPnNhX2ZhbWlseSk7Ci0JCXNlcnZlci0+ZnNjYWNoZSA9IE5V
TEw7Ci0JCXJldHVybjsKLQl9CiAJa2V5LmNvbm5faWQgPSBzZXJ2ZXItPmNvbm5faWQ7CiAKIAlz
ZXJ2ZXItPmZzY2FjaGUgPQogCQlmc2NhY2hlX2FjcXVpcmVfY29va2llKGNpZnNfZnNjYWNoZV9u
ZXRmcy5wcmltYXJ5X2luZGV4LAogCQkJCSAgICAgICAmY2lmc19mc2NhY2hlX3NlcnZlcl9pbmRl
eF9kZWYsCi0JCQkJICAgICAgICZrZXksIGtleV9sZW4sCisJCQkJICAgICAgICZrZXksIHNpemVv
ZihrZXkpLAogCQkJCSAgICAgICBOVUxMLCAwLAogCQkJCSAgICAgICBzZXJ2ZXIsIDAsIHRydWUp
OwogCWNpZnNfZGJnKEZZSSwgIiVzOiAoMHglcC8weCVwKVxuIiwK
--000000000000e4443105d2404537--
