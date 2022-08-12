Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94924C25B06
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 00:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiHLA5b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 20:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiHLA5b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 20:57:31 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13377A2206
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 17:57:30 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 125so19936322vsd.5
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 17:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/9ma0+aNY1C82Hs5D9oCmVrS2FxDqxi9+9LtLsOZw6E=;
        b=IWQN7p+1096tKUcPW7k8dug2w2aZaksjQPbK9ZQqOBoHzMhnhYuGvbJ9WUoVlsbH4s
         1SHS+G5cjv1Y/+4maBhOBKGIBJYDaE+rIfvP36k7M3x3n16R7757mlP6/u2Dr7dFGqAt
         RHMc3ctE7CAe9fK1bFGzNvtZWswX8onAA3GjMK1UlNQNz/WHJwTeCHnf1jL+6f4uqUJ2
         /sWOJE0R4awDi6l7i0DeIdgP23DAjQk8kESkvKP7PSUVgQew3DoE2AR1JpjZDICbAht+
         L3Pj/7f/wl85rBFmFbK9AVYIgODk/aznMmBGZk7Yp879PxRAw1Doq0ELTyY/KNv4dcmg
         6bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/9ma0+aNY1C82Hs5D9oCmVrS2FxDqxi9+9LtLsOZw6E=;
        b=rPMZA2aDIg4TYSRvp5ckzjMTfqSAZerLrZ/NVQe0d038VyXZ/oJ/CIYhYEEsDwzmsw
         GmZCtU2ydscTx6tvEHR6yROtvLU95reJ/J94QGfPybMs6bY82BVoaruKJL2Nu72KpgFE
         Rgfyg0UbKyCKZkWPAqtj8lJJtQPxlg3eP7dRuq5pDtrZb5wiVuJwthuBnufjLfY8dIsk
         UY61suF//pJyeKkZxBcrmMBFyY/YzDgNCQ9Pr5YPEjbRdTUnxzwC6AAr/8OEtyHnvliF
         bUdltqgIxYb1vHq0Twk46Xsd/RN06d9dhAcWvzTP46nB9sACXyd1cEeaRRgIC6yYtbJT
         gDVQ==
X-Gm-Message-State: ACgBeo0paEKar493AW92q366f3PRxUq+/FeMYLb3K7ZfG+3+wd3mgm7t
        Quj88XzKFsx259EGLoyy4UbcHjrkHtkLc4pdZ2st0BsAcyI=
X-Google-Smtp-Source: AA6agR7McivtZNy/YNjZnJGEloEGuYIBmW+nnr1iSxxsg/Qvq1cORVbYzNqQnxwBF4/9Wr7o0NYT5ytAq7qS5gNROjE=
X-Received: by 2002:a67:b401:0:b0:387:8734:a09 with SMTP id
 x1-20020a67b401000000b0038787340a09mr916434vsl.61.1660265848999; Thu, 11 Aug
 2022 17:57:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-6-lsahlber@redhat.com>
 <87leruudal.fsf@cjr.nz> <CAH2r5mvCuJM5z5nzfXW6Mkqgo4CWxoORUhsNT4ZtrjS=tVSJxg@mail.gmail.com>
In-Reply-To: <CAH2r5mvCuJM5z5nzfXW6Mkqgo4CWxoORUhsNT4ZtrjS=tVSJxg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 19:57:17 -0500
Message-ID: <CAH2r5mtXaJB02+zBZ3M2U75YKs308oZmcpgDMod5hbPt9MwCDw@mail.gmail.com>
Subject: Re: [PATCH 5/9] cifs: Do not access tcon->cfids->cfid directly from is_path_accessible
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000029a86805e600c486"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000029a86805e600c486
Content-Type: text/plain; charset="UTF-8"

updated patch attached


On Thu, Aug 11, 2022 at 7:56 PM Steve French <smfrench@gmail.com> wrote:
>
> Tentatively merged this patch (after rebasing it and fixing a minor
> checkpatch problem).  Added Paulo's RB
>
> Skipped adding patch 4 though (cifs: Make tcon contain a wrapper
> structure cached_fids instead of cached_fid) - let me know if problem
> skipping that patch in the short term
>
> On Thu, Aug 11, 2022 at 8:20 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Ronnie Sahlberg <lsahlber@redhat.com> writes:
> >
> > > cfids will soon keep a list of cached fids so we should not access this
> > > directly from outside of cached_dir.c
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/cached_dir.c | 10 ++++++----
> > >  fs/cifs/cached_dir.h |  2 +-
> > >  fs/cifs/readdir.c    |  4 ++--
> > >  fs/cifs/smb2inode.c  |  2 +-
> > >  fs/cifs/smb2ops.c    | 18 ++++++++++++++----
> > >  5 files changed, 24 insertions(+), 12 deletions(-)
> >
> > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--00000000000029a86805e600c486
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Do-not-access-tcon-cfids-cfid-directly-from-is_.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Do-not-access-tcon-cfids-cfid-directly-from-is_.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l6preta00>
X-Attachment-Id: f_l6preta00

RnJvbSA1Njk2NDE4ZjVlOTE0MDRkYTEzNGIyY2M5Yjg4ZDY0ZjRmNTc0NjUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTEgQXVnIDIwMjIgMTk6NTE6MTggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBEbyBub3QgYWNjZXNzIHRjb24tPmNmaWRzLT5jZmlkIGRpcmVjdGx5IGZyb20KIGlzX3Bh
dGhfYWNjZXNzaWJsZQoKY2ZpZHMgd2lsbCBzb29uIGtlZXAgYSBsaXN0IG9mIGNhY2hlZCBmaWRz
IHNvIHdlIHNob3VsZCBub3QgYWNjZXNzIHRoaXMKZGlyZWN0bHkgZnJvbSBvdXRzaWRlIG9mIGNh
Y2hlZF9kaXIuYwoKUmV2aWV3ZWQtYnk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkgPHBjQGNqci5u
ej4KU2lnbmVkLW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpT
aWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQog
ZnMvY2lmcy9jYWNoZWRfZGlyLmMgfCAxMCArKysrKystLS0tCiBmcy9jaWZzL2NhY2hlZF9kaXIu
aCB8ICAyICstCiBmcy9jaWZzL3JlYWRkaXIuYyAgICB8ICA0ICsrLS0KIGZzL2NpZnMvc21iMmlu
b2RlLmMgIHwgIDIgKy0KIGZzL2NpZnMvc21iMm9wcy5jICAgIHwgMTkgKysrKysrKysrKysrKysr
LS0tLQogNSBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NhY2hlZF9kaXIuYyBiL2ZzL2NpZnMvY2FjaGVkX2Rpci5j
CmluZGV4IDc4ZThkZWI4MmEwYS4uYjQwMTMzOWY2ZTczIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nh
Y2hlZF9kaXIuYworKysgYi9mcy9jaWZzL2NhY2hlZF9kaXIuYwpAQCAtMTYsOSArMTYsOSBAQAog
ICogSWYgZXJyb3IgdGhlbiAqY2ZpZCBpcyBub3QgaW5pdGlhbGl6ZWQuCiAgKi8KIGludCBvcGVu
X2NhY2hlZF9kaXIodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLQkJ
Y29uc3QgY2hhciAqcGF0aCwKLQkJc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKLQkJc3Ry
dWN0IGNhY2hlZF9maWQgKipyZXRfY2ZpZCkKKwkJICAgIGNvbnN0IGNoYXIgKnBhdGgsCisJCSAg
ICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAorCQkgICAgYm9vbCBsb29rdXBfb25seSwg
c3RydWN0IGNhY2hlZF9maWQgKipyZXRfY2ZpZCkKIHsKIAlzdHJ1Y3QgY2lmc19zZXMgKnNlczsK
IAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7CkBAIC02OCw5ICs2OCwxMSBAQCBpbnQg
b3Blbl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24s
CiAJICogY2lmc19tYXJrX29wZW5fZmlsZXNfaW52YWxpZCgpIHdoaWNoIHRha2VzIHRoZSBsb2Nr
IGFnYWluCiAJICogdGh1cyBjYXVzaW5nIGEgZGVhZGxvY2sKIAkgKi8KLQogCW11dGV4X3VubG9j
aygmY2ZpZC0+ZmlkX211dGV4KTsKIAorCWlmIChsb29rdXBfb25seSkKKwkJcmV0dXJuIC1FTk9F
TlQ7CisKIAlpZiAoc21iM19lbmNyeXB0aW9uX3JlcXVpcmVkKHRjb24pKQogCQlmbGFncyB8PSBD
SUZTX1RSQU5TRk9STV9SRVE7CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2FjaGVkX2Rpci5oIGIv
ZnMvY2lmcy9jYWNoZWRfZGlyLmgKaW5kZXggODljMDM0M2Q3ZTI2Li5iZDI2MmRjOGIxNzkgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY2FjaGVkX2Rpci5oCisrKyBiL2ZzL2NpZnMvY2FjaGVkX2Rpci5o
CkBAIC01MCw3ICs1MCw3IEBAIGV4dGVybiB2b2lkIGZyZWVfY2FjaGVkX2RpcihzdHJ1Y3QgY2lm
c190Y29uICp0Y29uKTsKIGV4dGVybiBpbnQgb3Blbl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4
aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkgICBjb25zdCBjaGFyICpwYXRoLAogCQkJ
ICAgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKLQkJCSAgIHN0cnVjdCBjYWNoZWRfZmlk
ICoqY2ZpZCk7CisJCQkgICBib29sIGxvb2t1cF9vbmx5LCBzdHJ1Y3QgY2FjaGVkX2ZpZCAqKmNm
aWQpOwogZXh0ZXJuIGludCBvcGVuX2NhY2hlZF9kaXJfYnlfZGVudHJ5KHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiAJCQkJICAgICBzdHJ1Y3QgZGVudHJ5ICpkZW50cnksCiAJCQkJICAgICBzdHJ1
Y3QgY2FjaGVkX2ZpZCAqKmNmaWQpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9yZWFkZGlyLmMgYi9m
cy9jaWZzL3JlYWRkaXIuYwppbmRleCBhMDYwNzJhZTZjN2UuLjJlZWNlOGEwN2MxMSAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9yZWFkZGlyLmMKKysrIGIvZnMvY2lmcy9yZWFkZGlyLmMKQEAgLTEwNzIs
NyArMTA3Miw3IEBAIGludCBjaWZzX3JlYWRkaXIoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBk
aXJfY29udGV4dCAqY3R4KQogCQl0Y29uID0gdGxpbmtfdGNvbihjaWZzRmlsZS0+dGxpbmspOwog
CX0KIAotCXJjID0gb3Blbl9jYWNoZWRfZGlyKHhpZCwgdGNvbiwgZnVsbF9wYXRoLCBjaWZzX3Ni
LCAmY2ZpZCk7CisJcmMgPSBvcGVuX2NhY2hlZF9kaXIoeGlkLCB0Y29uLCBmdWxsX3BhdGgsIGNp
ZnNfc2IsIGZhbHNlLCAmY2ZpZCk7CiAJY2lmc19wdXRfdGxpbmsodGxpbmspOwogCWlmIChyYykK
IAkJZ290byBjYWNoZV9ub3RfZm91bmQ7CkBAIC0xMTQzLDcgKzExNDMsNyBAQCBpbnQgY2lmc19y
ZWFkZGlyKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgZGlyX2NvbnRleHQgKmN0eCkKIAl0Y29u
ID0gdGxpbmtfdGNvbihjaWZzRmlsZS0+dGxpbmspOwogCXJjID0gZmluZF9jaWZzX2VudHJ5KHhp
ZCwgdGNvbiwgY3R4LT5wb3MsIGZpbGUsIGZ1bGxfcGF0aCwKIAkJCSAgICAgJmN1cnJlbnRfZW50
cnksICZudW1fdG9fZmlsbCk7Ci0Jb3Blbl9jYWNoZWRfZGlyKHhpZCwgdGNvbiwgZnVsbF9wYXRo
LCBjaWZzX3NiLCAmY2ZpZCk7CisJb3Blbl9jYWNoZWRfZGlyKHhpZCwgdGNvbiwgZnVsbF9wYXRo
LCBjaWZzX3NiLCBmYWxzZSwgJmNmaWQpOwogCWlmIChyYykgewogCQljaWZzX2RiZyhGWUksICJm
Y2UgZXJyb3IgJWRcbiIsIHJjKTsKIAkJZ290byByZGRpcjJfZXhpdDsKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvc21iMmlub2RlLmMgYi9mcy9jaWZzL3NtYjJpbm9kZS5jCmluZGV4IDk2OTYxODRhMDll
My4uYjgzZjU5MDUxYjI2IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJpbm9kZS5jCisrKyBiL2Zz
L2NpZnMvc21iMmlub2RlLmMKQEAgLTUxNiw3ICs1MTYsNyBAQCBzbWIyX3F1ZXJ5X3BhdGhfaW5m
byhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCWlmIChz
dHJjbXAoZnVsbF9wYXRoLCAiIikpCiAJCXJjID0gLUVOT0VOVDsKIAllbHNlCi0JCXJjID0gb3Bl
bl9jYWNoZWRfZGlyKHhpZCwgdGNvbiwgZnVsbF9wYXRoLCBjaWZzX3NiLCAmY2ZpZCk7CisJCXJj
ID0gb3Blbl9jYWNoZWRfZGlyKHhpZCwgdGNvbiwgZnVsbF9wYXRoLCBjaWZzX3NiLCBmYWxzZSwg
JmNmaWQpOwogCS8qIElmIGl0IGlzIGEgcm9vdCBhbmQgaXRzIGhhbmRsZSBpcyBjYWNoZWQgdGhl
biB1c2UgaXQgKi8KIAlpZiAoIXJjKSB7CiAJCWlmIChjZmlkLT5maWxlX2FsbF9pbmZvX2lzX3Zh
bGlkKSB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5j
CmluZGV4IDY1MDc3NjFhODA0MC4uZjQwNmFmNTk2ODg3IDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtNzIwLDcgKzcyMCw3IEBAIHNtYjNf
cWZzX3Rjb24oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwK
IAlvcGFybXMuZmlkID0gJmZpZDsKIAlvcGFybXMucmVjb25uZWN0ID0gZmFsc2U7CiAKLQlyYyA9
IG9wZW5fY2FjaGVkX2Rpcih4aWQsIHRjb24sICIiLCBjaWZzX3NiLCAmY2ZpZCk7CisJcmMgPSBv
cGVuX2NhY2hlZF9kaXIoeGlkLCB0Y29uLCAiIiwgY2lmc19zYiwgZmFsc2UsICZjZmlkKTsKIAlp
ZiAocmMgPT0gMCkKIAkJbWVtY3B5KCZmaWQsICZjZmlkLT5maWQsIHNpemVvZihzdHJ1Y3QgY2lm
c19maWQpKTsKIAllbHNlCkBAIC03ODMsOSArNzgzLDE2IEBAIHNtYjJfaXNfcGF0aF9hY2Nlc3Np
YmxlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJX191
OCBvcGxvY2sgPSBTTUIyX09QTE9DS19MRVZFTF9OT05FOwogCXN0cnVjdCBjaWZzX29wZW5fcGFy
bXMgb3Bhcm1zOwogCXN0cnVjdCBjaWZzX2ZpZCBmaWQ7CisJc3RydWN0IGNhY2hlZF9maWQgKmNm
aWQ7CiAKLQlpZiAoKCpmdWxsX3BhdGggPT0gMCkgJiYgdGNvbi0+Y2ZpZC0+aXNfdmFsaWQpCi0J
CXJldHVybiAwOworCXJjID0gb3Blbl9jYWNoZWRfZGlyKHhpZCwgdGNvbiwgZnVsbF9wYXRoLCBj
aWZzX3NiLCB0cnVlLCAmY2ZpZCk7CisJaWYgKCFyYykgeworCQlpZiAoY2ZpZC0+aXNfdmFsaWQp
IHsKKwkJCWNsb3NlX2NhY2hlZF9kaXIoY2ZpZCk7CisJCQlyZXR1cm4gMDsKKwkJfQorCQljbG9z
ZV9jYWNoZWRfZGlyKGNmaWQpOworCX0KIAogCXV0ZjE2X3BhdGggPSBjaWZzX2NvbnZlcnRfcGF0
aF90b191dGYxNihmdWxsX3BhdGgsIGNpZnNfc2IpOwogCWlmICghdXRmMTZfcGF0aCkKQEAgLTI0
MzAsOCArMjQzNywxMiBAQCBzbWIyX3F1ZXJ5X2luZm9fY29tcG91bmQoY29uc3QgdW5zaWduZWQg
aW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlyZXNwX2J1ZnR5cGVbMF0gPSByZXNw
X2J1ZnR5cGVbMV0gPSByZXNwX2J1ZnR5cGVbMl0gPSBDSUZTX05PX0JVRkZFUjsKIAltZW1zZXQo
cnNwX2lvdiwgMCwgc2l6ZW9mKHJzcF9pb3YpKTsKIAorCS8qCisJICogV2UgY2FuIG9ubHkgY2Fs
bCB0aGlzIGZvciB0aGluZ3Mgd2Uga25vdyBhcmUgZGlyZWN0b3JpZXMuCisJICovCiAJaWYgKCFz
dHJjbXAocGF0aCwgIiIpKQotCQlvcGVuX2NhY2hlZF9kaXIoeGlkLCB0Y29uLCBwYXRoLCBjaWZz
X3NiLCAmY2ZpZCk7IC8qIGNmaWQgbnVsbCBpZiBvcGVuIGRpciBmYWlsZWQgKi8KKwkJb3Blbl9j
YWNoZWRfZGlyKHhpZCwgdGNvbiwgcGF0aCwgY2lmc19zYiwgZmFsc2UsCisJCQkJJmNmaWQpOyAv
KiBjZmlkIG51bGwgaWYgb3BlbiBkaXIgZmFpbGVkICovCiAKIAltZW1zZXQoJm9wZW5faW92LCAw
LCBzaXplb2Yob3Blbl9pb3YpKTsKIAlycXN0WzBdLnJxX2lvdiA9IG9wZW5faW92OwotLSAKMi4z
NC4xCgo=
--00000000000029a86805e600c486--
