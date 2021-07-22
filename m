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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F72C6377D
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 16:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AF56120C
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 16:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhGVQJA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhGVQHY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jul 2021 12:07:24 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE2AC0619DF
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 09:44:54 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id t3so8142917ljc.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 09:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZljMzZHOgtO4kkhGy7h8lFcfHKzYupnCNcLpMQLqp7g=;
        b=TyeyJLb6kUcqGeqAesLVsCTW5c4bXXAFJB0q/fd1ZjYCmdzq4ryANEZf/vHxoNBLfq
         46TI7wpu+KRyH8VREk9e9X5+Eqs+54tARWNbRguxaBoqP0+9pNqV+Oa10gQKi+qaaPV7
         4WZvYprclfwWuOghtmOXVa8GUbAvSO4s82lwWDxNa28KF3nmjayPj4WJgdec1RokD0Eb
         b+bdgbxTQKITGySbCB7y4E/bjvPN/nDPEOKTel5EK4oZWImOPs9Z/1sWv89S+R/vEJF+
         a7yt1wNscWF0VnCrkW/rg0VsH/WSMGbKd8MvrLSqBW7aVTi+1XTpZsMIyBilcu8Qyd2q
         DkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZljMzZHOgtO4kkhGy7h8lFcfHKzYupnCNcLpMQLqp7g=;
        b=oU3zbT4N8qI9ZW81tYu4JR+dxiAqKobev8J2FfiMejtkltLV1pkdBW2i3SaaIa+axr
         +K2XJh/pcQsP9pkP1YGF/cMw+HgEIU0JXS87koSgKgQ4jGobuo02MHNvhlvdf2R0cMxX
         YKYZC54XM68xpLgfBgMhmjrm+ptgvFchpR1mcPwpq41UAZSWDgD5ouOeP8ooqQ5DF7MW
         SqxAneuqJZSUvyYu5aJKtTCRTzBajJ92tG3zr51cZL8eX+8yPVMm8deNi86MatlivSBv
         lthVNKotZTd8KoF4JHzStYvHobX6bQxRiJwJ/586BxVIMEjoF0pi7cIzqiQp9ZTxAzOV
         J2JQ==
X-Gm-Message-State: AOAM532Kx61witSMSBnnFBY9WIFghDm5YEnxXRttR3DNF+nDlg7K9E5F
        /w+pk+R6SzMEwlU9POyYA16WvFnpZwF8bcV6TIE=
X-Google-Smtp-Source: ABdhPJwv9JuGQDsyQe1oQzNxU+dtWIkD2C6rs/OQvFwOoCM8TazLgAykq4v0rDHwFEeiguzPSaipdP7r5+JlxmA3XW0=
X-Received: by 2002:a2e:9852:: with SMTP id e18mr681123ljj.6.1626972293134;
 Thu, 22 Jul 2021 09:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71@epcas1p4.samsung.com>
 <014c01d77dd3$57add320$07097960$@samsung.com> <016b01d77e00$fe61efd0$fb25cf70$@samsung.com>
 <CAGvGhF55Tq-sLUtKBn+QX6kWrL9dDzKkXFKdQ==gz3s=RkySKQ@mail.gmail.com>
 <006601d77ec6$6b1b13c0$41513b40$@samsung.com> <CAN05THTv3o8yDuGLJE5M+YXhdW6ChnnUyznVF_a_3uLQcE=5Tw@mail.gmail.com>
In-Reply-To: <CAN05THTv3o8yDuGLJE5M+YXhdW6ChnnUyznVF_a_3uLQcE=5Tw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Jul 2021 11:44:41 -0500
Message-ID: <CAH2r5mt0JdioMoVZ4zOpe7cM=_tWif2VdbscAR6Osh1hJO_wfA@mail.gmail.com>
Subject: Re: [PATCH] cifs: only write 64kb at a time when fallocating a small
 region of a file
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Leif Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000979ce805c7b901ac"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000979ce805c7b901ac
Content-Type: text/plain; charset="UTF-8"

Removed the deletion from the patch, and added Reported-by: Namjae ...
and pushed to cifs-2.6.git for-next

On Thu, Jul 22, 2021 at 2:19 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Yes, ofcourse.
>
> Steve, can you revert that deletion in the patch?
>
> On Thu, Jul 22, 2021 at 4:55 PM Namjae Jeon <namjae.jeon@samsung.com> wrote:
> >
> > > This code is actually bogus and does the opposite of what the comment says.
> > > If out_data_len is 0 then that means that the entire region is unallocated and then we should not
> > > bail out but proceed and allocate the hole.
> >
> > > generic/071 works against a windows server for me.
> >
> >
> > > If it fails with this code removed it might mean that generic/071 never worked with cifs.ko correctly.
> >
> > generic/071 create preallocated extent by calling fallocate with keep size flags.
> > It means the file size should not be increased.
> > But if (out_buf_len == 0) check is removed, 1MB write is performed using SMB2_write loop().
> > It means the file size becomes 1MB.
> >
> > And then, generic/071 call again fallocate(0, 512K) which mean file size should be 512K.
> > but SMB2_set_eof() in cifs is not called due to the code below(->i_size is bigger than off + len),
> > So 071 test failed as file size remains 1MB.
> >
> >         /*
> >          * Extending the file
> >          */
> >         if ((keep_size == false) && i_size_read(inode) < off + len) {
> >                 rc = inode_newsize_ok(inode, off + len);
> >                 if (rc)
> >                         goto out;
> >
> >                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> >                         smb2_set_sparse(xid, tcon, cfile, inode, false);
> >
> >                 eof = cpu_to_le64(off + len);
> >                 rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> >                                   cfile->fid.volatile_fid, cfile->pid, &eof);
> >                 if (rc == 0) {
> >                         cifsi->server_eof = off + len;
> >                         cifs_setsize(inode, off + len);
> >                         cifs_truncate_page(inode->i_mapping, inode->i_size);
> >                         truncate_setsize(inode, off + len);
> >                 }
> >                 goto out;
> >         }
> >



-- 
Thanks,

Steve

--000000000000979ce805c7b901ac
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-only-write-64kb-at-a-time-when-fallocating-a-sm.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-only-write-64kb-at-a-time-when-fallocating-a-sm.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krf5adf50>
X-Attachment-Id: f_krf5adf50

RnJvbSAyNDg1YmQ3NTU3YTdlZGI0NTIwYjQwNzJhZjQ2NGYwYTA4YzhlZmUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFRodSwgMjIgSnVsIDIwMjEgMTQ6NTM6MzIgKzEwMDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gY2lmczogb25seSB3cml0ZSA2NGtiIGF0IGEgdGltZSB3aGVuIGZhbGxvY2F0aW5nIGEgc21h
bGwKIHJlZ2lvbiBvZiBhIGZpbGUKCldlIG9ubHkgYWxsb3cgc2VuZGluZyBzaW5nbGUgY3JlZGl0
IHdyaXRlcyB0aHJvdWdoIHRoZSBTTUIyX3dyaXRlKCkgc3luY2hyb25vdXMKYXBpIHNvIHNwbGl0
IHRoaXMgaW50byBzbWFsbGVyIGNodW5rcy4KCkZpeGVzOiA5NjZhM2NiN2M3ZGIgKCJjaWZzOiBp
bXByb3ZlIGZhbGxvY2F0ZSBlbXVsYXRpb24iKQoKU2lnbmVkLW9mZi1ieTogUm9ubmllIFNhaGxi
ZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpSZXBvcnRlZC1ieTogTmFtamFlIEplb24gPG5hbWph
ZS5qZW9uQHNhbXN1bmcuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCAyNiArKysrKysrKysrKysr
KysrKysrLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDcgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMu
YwppbmRleCBiYTNjNThlMWY3MjUuLjVjZWZiNTk3MjM5NiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9z
bWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTM2MTcsNyArMzYxNyw3IEBAIHN0
YXRpYyBpbnQgc21iM19zaW1wbGVfZmFsbG9jYXRlX3dyaXRlX3JhbmdlKHVuc2lnbmVkIGludCB4
aWQsCiAJCQkJCSAgICAgY2hhciAqYnVmKQogewogCXN0cnVjdCBjaWZzX2lvX3Bhcm1zIGlvX3Bh
cm1zID0gezB9OwotCWludCBuYnl0ZXM7CisJaW50IHJjLCBuYnl0ZXM7CiAJc3RydWN0IGt2ZWMg
aW92WzJdOwogCiAJaW9fcGFybXMubmV0ZmlkID0gY2ZpbGUtPmZpZC5uZXRmaWQ7CkBAIC0zNjI1
LDEzICszNjI1LDI1IEBAIHN0YXRpYyBpbnQgc21iM19zaW1wbGVfZmFsbG9jYXRlX3dyaXRlX3Jh
bmdlKHVuc2lnbmVkIGludCB4aWQsCiAJaW9fcGFybXMudGNvbiA9IHRjb247CiAJaW9fcGFybXMu
cGVyc2lzdGVudF9maWQgPSBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkOwogCWlvX3Bhcm1zLnZv
bGF0aWxlX2ZpZCA9IGNmaWxlLT5maWQudm9sYXRpbGVfZmlkOwotCWlvX3Bhcm1zLm9mZnNldCA9
IG9mZjsKLQlpb19wYXJtcy5sZW5ndGggPSBsZW47CiAKLQkvKiBpb3ZbMF0gaXMgcmVzZXJ2ZWQg
Zm9yIHNtYiBoZWFkZXIgKi8KLQlpb3ZbMV0uaW92X2Jhc2UgPSBidWY7Ci0JaW92WzFdLmlvdl9s
ZW4gPSBpb19wYXJtcy5sZW5ndGg7Ci0JcmV0dXJuIFNNQjJfd3JpdGUoeGlkLCAmaW9fcGFybXMs
ICZuYnl0ZXMsIGlvdiwgMSk7CisJd2hpbGUgKGxlbikgeworCQlpb19wYXJtcy5vZmZzZXQgPSBv
ZmY7CisJCWlvX3Bhcm1zLmxlbmd0aCA9IGxlbjsKKwkJaWYgKGlvX3Bhcm1zLmxlbmd0aCA+IFNN
QjJfTUFYX0JVRkZFUl9TSVpFKQorCQkJaW9fcGFybXMubGVuZ3RoID0gU01CMl9NQVhfQlVGRkVS
X1NJWkU7CisJCS8qIGlvdlswXSBpcyByZXNlcnZlZCBmb3Igc21iIGhlYWRlciAqLworCQlpb3Zb
MV0uaW92X2Jhc2UgPSBidWY7CisJCWlvdlsxXS5pb3ZfbGVuID0gaW9fcGFybXMubGVuZ3RoOwor
CQlyYyA9IFNNQjJfd3JpdGUoeGlkLCAmaW9fcGFybXMsICZuYnl0ZXMsIGlvdiwgMSk7CisJCWlm
IChyYykKKwkJCWJyZWFrOworCQlpZiAobmJ5dGVzID4gbGVuKQorCQkJcmV0dXJuIC1FSU5WQUw7
CisJCWJ1ZiArPSBuYnl0ZXM7CisJCW9mZiArPSBuYnl0ZXM7CisJCWxlbiAtPSBuYnl0ZXM7CisJ
fQorCXJldHVybiByYzsKIH0KIAogc3RhdGljIGludCBzbWIzX3NpbXBsZV9mYWxsb2NhdGVfcmFu
Z2UodW5zaWduZWQgaW50IHhpZCwKLS0gCjIuMzAuMgoK
--000000000000979ce805c7b901ac--
