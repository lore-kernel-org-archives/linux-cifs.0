Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213FEC4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Aug 2021 04:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011BC60E78
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Aug 2021 04:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhHLEGD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Aug 2021 00:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhHLEGD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Aug 2021 00:06:03 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938A8C061765
        for <linux-cifs@vger.kernel.org>; Wed, 11 Aug 2021 21:05:38 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t9so10777979lfc.6
        for <linux-cifs@vger.kernel.org>; Wed, 11 Aug 2021 21:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cAET4TZE/sNsd+RqPa0qiiND1SAaWRYrcLHXIsejTNw=;
        b=G/x6/fCq6+sRveail7Ac+TqNTstAQROghBigCr3h5nl72EloyrqFOQfZm1J/gq7gHQ
         bmeUz3LXidJ6zaEpo0NmF4u/VbbW0h0U79WYQbaz8aRu3QJx4DU1E3CA3WtZSVZXUH2d
         T7xHamNajQ1etXB5puwPglFuSuzKscMmEhZc1i5KEviJbzqZkWJ8R+AoIrseKSKCR9bX
         JrH7EvxXbxEoTPs88D0zqXflCeTeonxVF2XmtKYAJNr/tFpoK/ehjgOH52zC7RpWLLEr
         oWybGtoRkvG7fK5jCK85JFFA/VGdmrsYC2rvMwLWGwwIPXA5WK4eCNUz9uUAX1Mg/Y1J
         xFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cAET4TZE/sNsd+RqPa0qiiND1SAaWRYrcLHXIsejTNw=;
        b=kLlSy1cGXk+TOX6fWL0ZWKl9LSNpFMl7y90N7oIC450WHhy6q3HKmx83nj2CnSajpZ
         qGs/yCxvVpsQWJNFp19poAk1tJZqX5jLE9Ingn+AZTEPUSAi1WAigj04aSwAgiH8fnkv
         DFD1/ct7adsuIBG5LQsUnIwA6z7m1IdKBjKznUbAeqF4lXZw7WiVWkVy+Yr+Ub4l7A1N
         fiFvR6WUc5Liia7iVWfzLKGkZnVLMd4thqTwHTneirNZXhlbLLcQ/QN6qMSvTLHjmUio
         6fwopPrQZBZw5qwTH5HS5F1u/G+WFPq1rFIAC6L4Jg2w5+wP40/HJhbs1S8X74vYSsq2
         gC3g==
X-Gm-Message-State: AOAM533oGEAFbAdlssMPBmFtDCbBsBIVUa98tuahBBrq4UJRAPzcg5dT
        CQ4M7Nn/3PAUE0JwHb4JDSgmYbEdaisdJLFbOOE=
X-Google-Smtp-Source: ABdhPJzFK/6hJ9+pKSVpVsmEEPp7VuIU3iIY1ZxFF9aAc+N1YcE+y8EFx2IHOXdtf/KZgucSjXvzO0X9/rVNu32ogVk=
X-Received: by 2002:ac2:4ed3:: with SMTP id p19mr1069171lfr.307.1628741136865;
 Wed, 11 Aug 2021 21:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mswfhBnBxkPm=e-RnrWnYiLL=6BavH92krQ+D-XqvrEhA@mail.gmail.com>
In-Reply-To: <CAH2r5mswfhBnBxkPm=e-RnrWnYiLL=6BavH92krQ+D-XqvrEhA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 11 Aug 2021 23:05:25 -0500
Message-ID: <CAH2r5mu=SvFhHQMoB4yJ87GAn532yaxF-xisCV-jYjdJGzx9LQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix signed integer overflow when fl_end is OFFSET_MAX
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e5031705c954d87b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e5031705c954d87b
Content-Type: text/plain; charset="UTF-8"

Added one more minor change to this patch to fix the similar signed
integer overflow error in unlock_range

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index c9d8a50062b8..7932354bf90c 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -111,7 +111,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile,
struct file_lock *flock,
        struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
        struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
        struct cifsLockInfo *li, *tmp;
-       __u64 length = 1 + flock->fl_end - flock->fl_start;
+       __u64 length = cifs_flock_len(flock);
        struct list_head tmp_llist;

        INIT_LIST_HEAD(&tmp_llist);

also fixed the missing space after the colon in the newly added inline function

+static inline u64 cifs_flock_len(struct file_lock *fl)
+{
+       return fl->fl_end == OFFSET_MAX ? fl->fl_end - fl->fl_start :
fl->fl_end - fl->fl_start + 1;
+}
+

On Tue, Aug 10, 2021 at 6:10 PM Steve French <smfrench@gmail.com> wrote:
>
> How about the following minor change to the recent patch from Paulo -
> handling the case where we are doing a whole file lock (BSD lock,
> flock) - in which case the original patch would send length of 0 (but
> we went to send a byte range lock of the whole file)?
>
> +static inline u64 cifs_flock_len(struct file_lock *fl)
> +{
> + return fl->fl_end == OFFSET_MAX ? fl->fl_end - fl->fl_start:
> fl->fl_end - fl->fl_start + 1;
> +}
>
> instead of Paulo's original patch
>
> +static inline u64 cifs_flock_len(struct file_lock *fl)
> +{
> + return fl->fl_end == OFFSET_MAX ? 0: fl->fl_end - fl->fl_start + 1;
> +}
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000e5031705c954d87b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-signed-integer-overflow-when-fl_end-is-OFFS.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-signed-integer-overflow-when-fl_end-is-OFFS.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ks8ee3g40>
X-Attachment-Id: f_ks8ee3g40

RnJvbSBkMTBkMzgzNzI5N2IyOGNlMWQyNDI2NTBjYjAwYmJjMTg1ZjBhYmViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQGNqci5uej4KRGF0ZTogVHVl
LCAxMCBBdWcgMjAyMSAxMzoxMDo0NCAtMDMwMApTdWJqZWN0OiBbUEFUQ0ggMS8zXSBjaWZzOiBm
aXggc2lnbmVkIGludGVnZXIgb3ZlcmZsb3cgd2hlbiBmbF9lbmQgaXMKIE9GRlNFVF9NQVgKClRo
aXMgZml4ZXMgdGhlIGZvbGxvd2luZyB3aGVuIHJ1bm5pbmcgeGZzdGVzdHMgZ2VuZXJpYy81MDQ6
CgpbICAxMzQuMzk0Njk4XSBDSUZTOiBBdHRlbXB0aW5nIHRvIG1vdW50IFxcd2luMTYudm0udGVz
dFxTaGFyZQpbICAxMzQuNDIwOTA1XSBDSUZTOiBWRlM6IGdlbmVyYXRlX3NtYjNzaWduaW5na2V5
OiBkdW1waW5nIGdlbmVyYXRlZApBRVMgc2Vzc2lvbiBrZXlzClsgIDEzNC40MjA5MTFdIENJRlM6
IFZGUzogU2Vzc2lvbiBJZCAgICAwNSAwMCAwMCAwMCAwMCBjNCAwMCAwMApbICAxMzQuNDIwOTE0
XSBDSUZTOiBWRlM6IENpcGhlciB0eXBlICAgMQpbICAxMzQuNDIwOTE3XSBDSUZTOiBWRlM6IFNl
c3Npb24gS2V5ICAgZWEgMGIgZDkgMjIgMmUgYWYgMDEgNjkgMzAgMWIKMTUgNzQgYmYgODcgNDEg
MTEKWyAgMTM0LjQyMDkyMF0gQ0lGUzogVkZTOiBTaWduaW5nIEtleSAgIDU5IDI4IDQzIDVjIGYw
IGI2IGIxIDZmIGY1IDdiCjY1IGYyIDlmIDllIDU4IDdkClsgIDEzNC40MjA5MjNdIENJRlM6IFZG
UzogU2VydmVySW4gS2V5ICBlYiBhYSA1OCBjOCA5NSAwMSA5YSBmNyA5MSA5OAplNCBmYSBiYyBk
OCA3NCBmMQpbICAxMzQuNDIwOTI2XSBDSUZTOiBWRlM6IFNlcnZlck91dCBLZXkgMDggNWIgMjEg
ZTUgMmUgNGUgODYgZjYgMDUgYzIKNTggZTAgYWYgNTMgODMgZTcKWyAgMTM0Ljc3MTk0Nl0KPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KWyAgMTM0Ljc3MTk1M10gVUJTQU46IHNpZ25lZC1pbnRlZ2Vy
LW92ZXJmbG93IGluIGZzL2NpZnMvZmlsZS5jOjE3MDY6MTkKWyAgMTM0Ljc3MTk1N10gOTIyMzM3
MjAzNjg1NDc3NTgwNyArIDEgY2Fubm90IGJlIHJlcHJlc2VudGVkIGluIHR5cGUKJ2xvbmcgbG9u
ZyBpbnQnClsgIDEzNC43NzE5NjBdIENQVTogNCBQSUQ6IDI3NzMgQ29tbTogZmxvY2sgTm90IHRh
aW50ZWQgNS4xMS4yMiAjMQpbICAxMzQuNzcxOTY0XSBIYXJkd2FyZSBuYW1lOiBSZWQgSGF0IEtW
TSwgQklPUyAwLjUuMSAwMS8wMS8yMDExClsgIDEzNC43NzE5NjZdIENhbGwgVHJhY2U6ClsgIDEz
NC43NzE5NzBdICBkdW1wX3N0YWNrKzB4OGQvMHhiNQpbICAxMzQuNzcxOTgxXSAgdWJzYW5fZXBp
bG9ndWUrMHg1LzB4NTAKWyAgMTM0Ljc3MTk4OF0gIGhhbmRsZV9vdmVyZmxvdysweGEzLzB4YjAK
WyAgMTM0Ljc3MTk5N10gID8gbG9ja2RlcF9oYXJkaXJxc19vbl9wcmVwYXJlKzB4ZTgvMHgxYjAK
WyAgMTM0Ljc3MjAwNl0gIGNpZnNfc2V0bGsrMHg2M2MvMHg2ODAgW2NpZnNdClsgIDEzNC43NzIw
ODVdICA/IF9nZXRfeGlkKzB4NWYvMHhhMCBbY2lmc10KWyAgMTM0Ljc3MjA4NV0gIGNpZnNfZmxv
Y2srMHgxMzEvMHg0MDAgW2NpZnNdClsgIDEzNC43NzIwODVdICBfX3g2NF9zeXNfZmxvY2srMHhm
Yy8weDEyMApbICAxMzQuNzcyMDg1XSAgZG9fc3lzY2FsbF82NCsweDMzLzB4NDAKWyAgMTM0Ljc3
MjA4NV0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkKWyAgMTM0Ljc3
MjA4NV0gUklQOiAwMDMzOjB4N2ZlYTRmODNiM2ZiClsgIDEzNC43NzIwODVdIENvZGU6IGZmIDQ4
IDhiIDE1IDhmIDFhIDBkIDAwIGY3IGQ4IDY0IDg5IDAyIGI4IGZmIGZmCmZmIGZmIGViIGRhIGU4
IDE2IDBiIDAyIDAwIDY2IDBmIDFmIDQ0IDAwIDAwIGYzIDBmIDFlIGZhIGI4IDQ5IDAwIDAwCjAw
IDBmIDA1IDw0OD4gM2QgMDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgNWQgMWEgMGQgMDAg
ZjcgZDggNjQgODkKMDEgNDgKCkFuZCBmaXhlcyBhIHNpbWlsYXIgbG9mZl90IG92ZXJmbG93IHBy
b2JsZW0gaW4gc21iMl91bmxvY2tfcmFuZ2UKClNpZ25lZC1vZmYtYnk6IFBhdWxvIEFsY2FudGFy
YSAoU1VTRSkgPHBjQGNqci5uej4KUmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxi
ZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2dsb2IuaCB8IDUgKysrKysKIGZzL2NpZnMvY2lm
c3NtYi5jICB8IDMgKystCiBmcy9jaWZzL2ZpbGUuYyAgICAgfCA4ICsrKystLS0tCiBmcy9jaWZz
L3NtYjJmaWxlLmMgfCAyICstCiA0IGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDYg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9j
aWZzZ2xvYi5oCmluZGV4IGMwYmZjMmYwMTAzMC4uYzVlYTA5NjQ3ZGNiIDEwMDY0NAotLS0gYS9m
cy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCkBAIC0xOTY0LDQgKzE5
NjQsOSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgaXNfdGNvbl9kZnMoc3RydWN0IGNpZnNfdGNvbiAq
dGNvbikKIAkJdGNvbi0+c2hhcmVfZmxhZ3MgJiAoU0hJMTAwNV9GTEFHU19ERlMgfCBTSEkxMDA1
X0ZMQUdTX0RGU19ST09UKTsKIH0KIAorc3RhdGljIGlubGluZSB1NjQgY2lmc19mbG9ja19sZW4o
c3RydWN0IGZpbGVfbG9jayAqZmwpCit7CisJcmV0dXJuIGZsLT5mbF9lbmQgPT0gT0ZGU0VUX01B
WCA/IGZsLT5mbF9lbmQgLSBmbC0+Zmxfc3RhcnQgOiBmbC0+ZmxfZW5kIC0gZmwtPmZsX3N0YXJ0
ICsgMTsKK30KKwogI2VuZGlmCS8qIF9DSUZTX0dMT0JfSCAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9jaWZzc21iLmMgYi9mcy9jaWZzL2NpZnNzbWIuYwppbmRleCA2NWQxYTY1YmZjMzcuLjZhYjZj
ZjY2OTQzOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzc21iLmMKKysrIGIvZnMvY2lmcy9jaWZz
c21iLmMKQEAgLTI2MDcsNyArMjYwNyw4IEBAIENJRlNTTUJQb3NpeExvY2soY29uc3QgdW5zaWdu
ZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAogCQkJcExvY2tEYXRhLT5mbF9z
dGFydCA9IGxlNjRfdG9fY3B1KHBhcm1fZGF0YS0+c3RhcnQpOwogCQkJcExvY2tEYXRhLT5mbF9l
bmQgPSBwTG9ja0RhdGEtPmZsX3N0YXJ0ICsKLQkJCQkJbGU2NF90b19jcHUocGFybV9kYXRhLT5s
ZW5ndGgpIC0gMTsKKwkJCQkobGU2NF90b19jcHUocGFybV9kYXRhLT5sZW5ndGgpID8KKwkJCQkg
bGU2NF90b19jcHUocGFybV9kYXRhLT5sZW5ndGgpIC0gMSA6IDApOwogCQkJcExvY2tEYXRhLT5m
bF9waWQgPSAtbGUzMl90b19jcHUocGFybV9kYXRhLT5waWQpOwogCQl9CiAJfQpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCAwYTcyODQwYTg4ZjEuLmUx
Y2ZkNTA5OTZhMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxl
LmMKQEAgLTEzODUsNyArMTM4NSw3IEBAIGNpZnNfcHVzaF9wb3NpeF9sb2NrcyhzdHJ1Y3QgY2lm
c0ZpbGVJbmZvICpjZmlsZSkKIAkJCWNpZnNfZGJnKFZGUywgIkNhbid0IHB1c2ggYWxsIGJybG9j
a3MhXG4iKTsKIAkJCWJyZWFrOwogCQl9Ci0JCWxlbmd0aCA9IDEgKyBmbG9jay0+ZmxfZW5kIC0g
ZmxvY2stPmZsX3N0YXJ0OworCQlsZW5ndGggPSBjaWZzX2Zsb2NrX2xlbihmbG9jayk7CiAJCWlm
IChmbG9jay0+ZmxfdHlwZSA9PSBGX1JETENLIHx8IGZsb2NrLT5mbF90eXBlID09IEZfU0hMQ0sp
CiAJCQl0eXBlID0gQ0lGU19SRExDSzsKIAkJZWxzZQpAQCAtMTUwMSw3ICsxNTAxLDcgQEAgY2lm
c19nZXRsayhzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGZpbGVfbG9jayAqZmxvY2ssIF9fdTMy
IHR5cGUsCiAJICAgYm9vbCB3YWl0X2ZsYWcsIGJvb2wgcG9zaXhfbGNrLCB1bnNpZ25lZCBpbnQg
eGlkKQogewogCWludCByYyA9IDA7Ci0JX191NjQgbGVuZ3RoID0gMSArIGZsb2NrLT5mbF9lbmQg
LSBmbG9jay0+Zmxfc3RhcnQ7CisJX191NjQgbGVuZ3RoID0gY2lmc19mbG9ja19sZW4oZmxvY2sp
OwogCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlID0gKHN0cnVjdCBjaWZzRmlsZUluZm8gKilm
aWxlLT5wcml2YXRlX2RhdGE7CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbiA9IHRsaW5rX3Rjb24o
Y2ZpbGUtPnRsaW5rKTsKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSB0Y29uLT5z
ZXMtPnNlcnZlcjsKQEAgLTE1OTksNyArMTU5OSw3IEBAIGNpZnNfdW5sb2NrX3JhbmdlKHN0cnVj
dCBjaWZzRmlsZUluZm8gKmNmaWxlLCBzdHJ1Y3QgZmlsZV9sb2NrICpmbG9jaywKIAlzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uID0gdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspOwogCXN0cnVjdCBjaWZz
SW5vZGVJbmZvICpjaW5vZGUgPSBDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSk7CiAJc3Ry
dWN0IGNpZnNMb2NrSW5mbyAqbGksICp0bXA7Ci0JX191NjQgbGVuZ3RoID0gMSArIGZsb2NrLT5m
bF9lbmQgLSBmbG9jay0+Zmxfc3RhcnQ7CisJX191NjQgbGVuZ3RoID0gY2lmc19mbG9ja19sZW4o
ZmxvY2spOwogCXN0cnVjdCBsaXN0X2hlYWQgdG1wX2xsaXN0OwogCiAJSU5JVF9MSVNUX0hFQUQo
JnRtcF9sbGlzdCk7CkBAIC0xNzAzLDcgKzE3MDMsNyBAQCBjaWZzX3NldGxrKHN0cnVjdCBmaWxl
ICpmaWxlLCBzdHJ1Y3QgZmlsZV9sb2NrICpmbG9jaywgX191MzIgdHlwZSwKIAkgICB1bnNpZ25l
ZCBpbnQgeGlkKQogewogCWludCByYyA9IDA7Ci0JX191NjQgbGVuZ3RoID0gMSArIGZsb2NrLT5m
bF9lbmQgLSBmbG9jay0+Zmxfc3RhcnQ7CisJX191NjQgbGVuZ3RoID0gY2lmc19mbG9ja19sZW4o
ZmxvY2spOwogCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlID0gKHN0cnVjdCBjaWZzRmlsZUlu
Zm8gKilmaWxlLT5wcml2YXRlX2RhdGE7CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbiA9IHRsaW5r
X3Rjb24oY2ZpbGUtPnRsaW5rKTsKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSB0
Y29uLT5zZXMtPnNlcnZlcjsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMmZpbGUuYyBiL2ZzL2Np
ZnMvc21iMmZpbGUuYwppbmRleCBjOWQ4YTUwMDYyYjguLjc5MzIzNTRiZjkwYyAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWIyZmlsZS5jCisrKyBiL2ZzL2NpZnMvc21iMmZpbGUuYwpAQCAtMTExLDcg
KzExMSw3IEBAIHNtYjJfdW5sb2NrX3JhbmdlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlLCBz
dHJ1Y3QgZmlsZV9sb2NrICpmbG9jaywKIAlzdHJ1Y3QgY2lmc190Y29uICp0Y29uID0gdGxpbmtf
dGNvbihjZmlsZS0+dGxpbmspOwogCXN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaW5vZGUgPSBDSUZT
X0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSk7CiAJc3RydWN0IGNpZnNMb2NrSW5mbyAqbGksICp0
bXA7Ci0JX191NjQgbGVuZ3RoID0gMSArIGZsb2NrLT5mbF9lbmQgLSBmbG9jay0+Zmxfc3RhcnQ7
CisJX191NjQgbGVuZ3RoID0gY2lmc19mbG9ja19sZW4oZmxvY2spOwogCXN0cnVjdCBsaXN0X2hl
YWQgdG1wX2xsaXN0OwogCiAJSU5JVF9MSVNUX0hFQUQoJnRtcF9sbGlzdCk7Ci0tIAoyLjMwLjIK
Cg==
--000000000000e5031705c954d87b--
