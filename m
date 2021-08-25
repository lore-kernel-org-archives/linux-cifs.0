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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628B0C432BE
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 21:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E8A760F11
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 21:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhHYVKr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Aug 2021 17:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhHYVKr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Aug 2021 17:10:47 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A00C061757
        for <linux-cifs@vger.kernel.org>; Wed, 25 Aug 2021 14:10:00 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x27so1767842lfu.5
        for <linux-cifs@vger.kernel.org>; Wed, 25 Aug 2021 14:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kthIjAnahfC1JXexjMxRwfPUXTEZcPOImtTp9qveKDw=;
        b=Dpwy1Vj2aisftuwVq57lO3bFu4aoHPQ4vpBuss7SX6NPgAM2YP2VJYT6dh8vc+hZJt
         QG75rb8SbvOo011ihHj9pZvqD0iTTrJan61OKh9LQIVCcwjfN5eCNlixpZS/saHSGpCi
         7xFeRTZuOI+jjW+stcN7Oj6586XF9FLNrI7aTQiaC14ML/TCoo65jAxRg/ZeFr5IdFCA
         aFdbBHMdseStikcpx4S99GTY2Bax0c6+lJNKruDHtwWkc6unsJF4kqjeZ11sIvbIwCj3
         Rs9B7Topqw0VTCrRkuqKYlcnH7kp3vule0UmS4UnbqylvAM0jqbY1wkTLVuGMDfAAcKZ
         L0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kthIjAnahfC1JXexjMxRwfPUXTEZcPOImtTp9qveKDw=;
        b=JfW4bY/ccdqQyOEj1cm8x4guBn9LTKkC/SQXJ8OFylgu/CWdJdSSfFL3V5D1wsNLPs
         GF7Vr19oIkGCf2H4PKMlY3DS1K/g+Im1Xy98xUH3i7FPTGrgRtVelP4fZAGY+ifIKU34
         Lh0/GOmaKHZRb/Q6Oh+R3pv4zx1C9fShH2FN6SUb68jrxa03aguua3LqjUG6XtWQrydA
         zJVUB/8w9d+FYzmXnyAR8lM7+73yBcgq5QZqlKMQAQF/1YZoO1veDDpNCC4dLDqiBP9i
         iX3/9Wphfu1nLND8rG/V82FS+oi+da9HqonvklZy/l/0OS/cHHQ39c4Jj13C1/pl5omf
         Vrag==
X-Gm-Message-State: AOAM531p0qjWIwruKispbsxIuVOC7V+DjrN72qzv5pN8j7VVWavhcn32
        XhiRjzfCpgq8nEWjlcQmSfNoFisCT8aMj+dy4X9yDx2E
X-Google-Smtp-Source: ABdhPJyspmToAJVrAfW6HmSbnu81+L5Sn0UwbHryiv9G4jBJ8yz/t4EkxKJO9Y5y+tXskZaNAzbQ/Mmg4kDwD3mr14g=
X-Received: by 2002:ac2:4d0d:: with SMTP id r13mr69708lfi.307.1629925798851;
 Wed, 25 Aug 2021 14:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210825111656.1635954-1-lsahlber@redhat.com> <20210825111656.1635954-2-lsahlber@redhat.com>
In-Reply-To: <20210825111656.1635954-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 25 Aug 2021 16:09:47 -0500
Message-ID: <CAH2r5ms2KzVf-7ei2+m_GbwcvZ7PHTCbv33bhNaH9dXXWcVO1w@mail.gmail.com>
Subject: Re: [PATCH] cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004051cb05ca68ac60"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004051cb05ca68ac60
Content-Type: text/plain; charset="UTF-8"

lightly updated to add short sleep before retry


On Wed, Aug 25, 2021 at 6:17 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1994393
>
> If we hit a STATUS_USER_SESSION_DELETED for the Create part in the
> Create/QueryDirectory compound that starts a directory scan
> we will leak EDEADLK back to userspace and surprise glibc and the application.
>
> Pick this up initiate_cifs_search() and retry a small number of tries before we
> return an error to userspace.
>
> Cc: stable@vger.kernel.org
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/readdir.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index bfee176b901d..4518e3ca64df 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -369,7 +369,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
>   */
>
>  static int
> -initiate_cifs_search(const unsigned int xid, struct file *file,
> +_initiate_cifs_search(const unsigned int xid, struct file *file,
>                      const char *full_path)
>  {
>         __u16 search_flags;
> @@ -451,6 +451,23 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
>         return rc;
>  }
>
> +static int
> +initiate_cifs_search(const unsigned int xid, struct file *file,
> +                    const char *full_path)
> +{
> +       int rc, retry_count = 0;
> +
> +       do {
> +               rc = _initiate_cifs_search(xid, file, full_path);
> +               /*
> +                * We don't have enough credits to start reading the
> +                * directory so just try again.
> +                */
> +       } while (rc == -EDEADLK && retry_count++ < 5);
> +
> +       return rc;
> +}
> +
>  /* return length of unicode string in bytes */
>  static int cifs_unicode_bytelen(const char *str)
>  {
> --
> 2.30.2
>


-- 
Thanks,

Steve

--0000000000004051cb05ca68ac60
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Do-not-leak-EDEADLK-to-dgetents64-for-STATUS_US.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Do-not-leak-EDEADLK-to-dgetents64-for-STATUS_US.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksrzq5aw0>
X-Attachment-Id: f_ksrzq5aw0

RnJvbSA1N2NlYTUwZmE1YTMwMDY4NzUyYTgxNTVlMWM3MjMwYzhjNTg1NDkzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFdlZCwgMjUgQXVnIDIwMjEgMjE6MTY6NTYgKzEwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBEbyBub3QgbGVhayBFREVBRExLIHRvIGRnZXRlbnRzNjQgZm9yCiBTVEFUVVNfVVNFUl9T
RVNTSU9OX0RFTEVURUQKClJIQlo6IDE5OTQzOTMKCklmIHdlIGhpdCBhIFNUQVRVU19VU0VSX1NF
U1NJT05fREVMRVRFRCBmb3IgdGhlIENyZWF0ZSBwYXJ0IGluIHRoZQpDcmVhdGUvUXVlcnlEaXJl
Y3RvcnkgY29tcG91bmQgdGhhdCBzdGFydHMgYSBkaXJlY3Rvcnkgc2Nhbgp3ZSB3aWxsIGxlYWsg
RURFQURMSyBiYWNrIHRvIHVzZXJzcGFjZSBhbmQgc3VycHJpc2UgZ2xpYmMgYW5kIHRoZSBhcHBs
aWNhdGlvbi4KClBpY2sgdGhpcyB1cCBpbml0aWF0ZV9jaWZzX3NlYXJjaCgpIGFuZCByZXRyeSBh
IHNtYWxsIG51bWJlciBvZiB0cmllcyBiZWZvcmUgd2UKcmV0dXJuIGFuIGVycm9yIHRvIHVzZXJz
cGFjZS4KCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClJlcG9ydGVkLWJ5OiBYaWFvbGkgRmVu
ZyA8eGlmZW5nQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNh
aGxiZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvcmVhZGRpci5jIHwgMjMgKysrKysrKysrKysrKysr
KysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9yZWFkZGlyLmMgYi9mcy9jaWZzL3JlYWRkaXIuYwppbmRl
eCBiZmVlMTc2YjkwMWQuLjU0ZDc3Yzk5ZTIxYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9yZWFkZGly
LmMKKysrIGIvZnMvY2lmcy9yZWFkZGlyLmMKQEAgLTM2OSw3ICszNjksNyBAQCBpbnQgZ2V0X3N5
bWxpbmtfcmVwYXJzZV9wYXRoKGNoYXIgKmZ1bGxfcGF0aCwgc3RydWN0IGNpZnNfc2JfaW5mbyAq
Y2lmc19zYiwKICAqLwogCiBzdGF0aWMgaW50Ci1pbml0aWF0ZV9jaWZzX3NlYXJjaChjb25zdCB1
bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgZmlsZSAqZmlsZSwKK19pbml0aWF0ZV9jaWZzX3NlYXJj
aChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgZmlsZSAqZmlsZSwKIAkJICAgICBjb25z
dCBjaGFyICpmdWxsX3BhdGgpCiB7CiAJX191MTYgc2VhcmNoX2ZsYWdzOwpAQCAtNDUxLDYgKzQ1
MSwyNyBAQCBpbml0aWF0ZV9jaWZzX3NlYXJjaChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgZmlsZSAqZmlsZSwKIAlyZXR1cm4gcmM7CiB9CiAKK3N0YXRpYyBpbnQKK2luaXRpYXRlX2Np
ZnNfc2VhcmNoKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBmaWxlICpmaWxlLAorCQkg
ICAgIGNvbnN0IGNoYXIgKmZ1bGxfcGF0aCkKK3sKKwlpbnQgcmMsIHJldHJ5X2NvdW50ID0gMDsK
KworCWRvIHsKKwkJcmMgPSBfaW5pdGlhdGVfY2lmc19zZWFyY2goeGlkLCBmaWxlLCBmdWxsX3Bh
dGgpOworCQkvKgorCQkgKiBJZiB3ZSBkb24ndCBoYXZlIGVub3VnaCBjcmVkaXRzIHRvIHN0YXJ0
IHJlYWRpbmcgdGhlCisJCSAqIGRpcmVjdG9yeSBqdXN0IHRyeSBhZ2FpbiBhZnRlciBzaG9ydCB3
YWl0LgorCQkgKi8KKwkJaWYgKHJjICE9IC1FREVBRExLKQorCQkJYnJlYWs7CisKKwkJdXNsZWVw
X3JhbmdlKDUxMiwgMjA0OCk7CisJfSB3aGlsZSAocmV0cnlfY291bnQrKyA8IDUpOworCisJcmV0
dXJuIHJjOworfQorCiAvKiByZXR1cm4gbGVuZ3RoIG9mIHVuaWNvZGUgc3RyaW5nIGluIGJ5dGVz
ICovCiBzdGF0aWMgaW50IGNpZnNfdW5pY29kZV9ieXRlbGVuKGNvbnN0IGNoYXIgKnN0cikKIHsK
LS0gCjIuMzAuMgoK
--0000000000004051cb05ca68ac60--
