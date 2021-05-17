Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E553FC433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 17 May 2021 06:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF19060FE3
	for <linux-cifs@archiver.kernel.org>; Mon, 17 May 2021 06:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhEQGDd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 May 2021 02:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhEQGDd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 May 2021 02:03:33 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27FAC061573
        for <linux-cifs@vger.kernel.org>; Sun, 16 May 2021 23:02:17 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 6so3905038pgk.5
        for <linux-cifs@vger.kernel.org>; Sun, 16 May 2021 23:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1SQwAHOFqyGXAuiGSZ9nZJQ7OG1SJ+gUG+hI6p3l3vM=;
        b=qPN0QamCt1scwVzgCt3jAkhlBSXi8W42mhldqhJnTEU/wu9wSqiNfRAluGgnPaNOel
         tLv7wvdTiDFrL+pF3aybDsNQK/Na8xLuXuKKOZMKgHssmxjFxoxPR2Nv1QOMZ/JfvOWd
         l1d2DxcD+iSzNEbX50rbNuBfG2ZQJfZ80pEYKurSPEzMSZCI7s4luYio1Zjc1NfhyR62
         b3DH5UHjVlGjzBsFkvRCvDyXgSZ6jYup/sltrLJJSDzypL3ZLTxlAjETkNqfUY1+ACDk
         BaaMlgRLH8F9OSvuPCSuQcGP8b6u0uROyuj9qdeMZx/HVTf1hEc3mcoxUBS7rSjvZzyv
         8A3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1SQwAHOFqyGXAuiGSZ9nZJQ7OG1SJ+gUG+hI6p3l3vM=;
        b=JxUUs3grNYtz734XcOzWlbXH7O6b5RN2DY9rjyPDOXnf+D/lsRQJPOdXeBm9Z0uIui
         m5GsEHy0eWRFHtmgkKYW9dZCTFGBypFBzBkrgUkNM5f54hSaEHsE5+ifLKOuRoepGi9V
         E5nqbTP+CakShx3z37d0p/+lPhvkuudEIYh4oTGqHTouBzY+gpVFHLtW97OtCUvK1S48
         0/W9i1C29xUSeia/x24qC9ZwJseROfDMfycv0Izt8t6nyq3e96uiproogNrzGvfpcTvw
         21cbt86fnGx2jWYsH9rCN43mIILxWwPieXspCMgTvHxkKbZtVHCXiWerwXJZnsh+1ixk
         o7Ag==
X-Gm-Message-State: AOAM5319txgfryrJvI1wICnP9c5f5cfG4J+2F5radr5o6GsOuPXNVdpM
        rO1TDusnHr1Z85/iK6DNM1pZuwL20Cyv7yWZj9k=
X-Google-Smtp-Source: ABdhPJwQC8CCa6P9U0HZAuLCXcQ3WfIgF2/pckltZczRK0tYKg8Je4BY236EqjlFI8PS/OpNi1cI4R9WsTBr41c+6GE=
X-Received: by 2002:a63:5c5e:: with SMTP id n30mr25491276pgm.87.1621231337409;
 Sun, 16 May 2021 23:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <87fsz7r3du.fsf@cjr.nz> <CACdtm0YDrkTj_bO_wg5MetZiAB-u4hMZVvQLEh6RMpVa8Fs4FA@mail.gmail.com>
 <878s4ltes5.fsf@suse.com> <CACdtm0b9AJ7KFLnhW5w9oqucPjNS0MEAj4+JmBO=R9rmf1CPjA@mail.gmail.com>
In-Reply-To: <CACdtm0b9AJ7KFLnhW5w9oqucPjNS0MEAj4+JmBO=R9rmf1CPjA@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Mon, 17 May 2021 11:32:06 +0530
Message-ID: <CACdtm0ZcMC2Lrh7w5AvEBg4k0Ouss-hEmugt38MENMLkKXU43g@mail.gmail.com>
Subject: Re: oops in deferred close
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000f7275805c28055b2"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f7275805c28055b2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi All,

Have updated the commit message.
Please review and let me know if it is fine.

Regards,
Rohith

On Fri, May 14, 2021 at 3:49 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi Aur=C3=A9lien,
>
> Sorry for the late reply.I am on vacation this week.
>
> I have added the oplock_break_received flag as part of my first commit
> to achieve synchronization between oplock thread and open thread. But
> there is already a lock "open_file_lock" to achieve the same. So, I
> removed the same.
>
> find_readable_file takes open_file_lock and then traverse the
> openFileList. Similarly, cifs_oplock_break while closing the deferred
> handle(i.e cifsFileInfo_put) takes open_file_lock and then sends close
> to the server.
>
> Regards,
> Rohith
>
> On Tue, May 11, 2021 at 9:59 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > Hi,
> >
> > Rohith Surabattula <rohiths.msft@gmail.com> writes:
> > > Will fix the oops which caused the above issue.
> >
> > The patch Steve forwarded to me (I think you forgot to attach it) is no=
t
> > so obvious to me. Could you explain more in the commit msg why you
> > removed oplock_break_received flag
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >

--000000000000f7275805c28055b2
Content-Type: application/octet-stream; 
	name="0001-Fix-kernel-oops-when-CONFIG_DEBUG_ATOMIC_SLEEP-is-en.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-kernel-oops-when-CONFIG_DEBUG_ATOMIC_SLEEP-is-en.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kos78uz00>
X-Attachment-Id: f_kos78uz00

RnJvbSAwZTBkZDI5ZWU5NzkwZmJjOGU0OTBmOTg2NjQwYWNjZWRiMjU5ZDQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogV2VkLCA1IE1heSAyMDIxIDEwOjU2OjQ3ICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gRml4IGtlcm5lbCBvb3BzIHdoZW4gQ09ORklHX0RFQlVHX0FUT01JQ19TTEVFUCBpcwogZW5h
YmxlZC4KClJlbW92ZWQgb3Bsb2NrX2JyZWFrX3JlY2VpdmVkIGZsYWcgd2hpY2ggd2FzIGFkZGVk
IHRvIGFjaGl2ZQpzeW5jaHJvbml6YXRpb24gYmV0d2VlbiBvcGxvY2sgaGFuZGxlciBhbmQgb3Bl
biBoYW5kbGVyIGJ5IGVhcmxpZXIgY29tbWl0LgoKSXQgaXMgbm90IG5lZWRlZCBiZWNhdXNlIHRo
ZXJlIGlzIGFuIGV4aXN0aW5nIGxvY2sgb3Blbl9maWxlX2xvY2sgdG8gYWNoaWV2ZQp0aGUgc2Ft
ZS5maW5kX3JlYWRhYmxlX2ZpbGUgdGFrZXMgb3Blbl9maWxlX2xvY2sgYW5kIHRoZW4gdHJhdmVy
c2UgdGhlCm9wZW5GaWxlTGlzdC4gU2ltaWxhcmx5LCBjaWZzX29wbG9ja19icmVhayB3aGlsZSBj
bG9zaW5nIHRoZSBkZWZlcnJlZApoYW5kbGUoaS5lIGNpZnNGaWxlSW5mb19wdXQpIHRha2VzIG9w
ZW5fZmlsZV9sb2NrIGFuZCB0aGVuIHNlbmRzIGNsb3NlCnRvIHRoZSBzZXJ2ZXIuCgpBZGRlZCBj
b21tZW50cyBmb3IgYmV0dGVyIHJlYWRhYmlsaXR5LgoKU2lnbmVkLW9mZi1ieTogUm9oaXRoIFN1
cmFiYXR0dWxhIDxyb2hpdGhzQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyAg
IHwgIDIgKy0KIGZzL2NpZnMvY2lmc2dsb2IuaCB8ICAzICstLQogZnMvY2lmcy9maWxlLmMgICAg
IHwgMjcgKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCiBmcy9jaWZzL21pc2MuYyAgICAgfCAg
OSArKysrKysrKysKIDQgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMK
aW5kZXggZDdlYTljNWZlMGY4Li4yZmZjYjI5ZDVjOGYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lm
c2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtMTMzLDcgKzEzMyw3IEBAIHN0cnVjdCB3
b3JrcXVldWVfc3RydWN0CSpjaWZzaW9kX3dxOwogc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmRl
Y3J5cHRfd3E7CiBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdAkqZmlsZWluZm9fcHV0X3dxOwogc3Ry
dWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJKmNpZnNvcGxvY2tkX3dxOwotc3RydWN0IHdvcmtxdWV1ZV9z
dHJ1Y3QgKmRlZmVycmVkY2xvc2Vfd3E7CitzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdAkqZGVmZXJy
ZWRjbG9zZV93cTsKIF9fdTMyIGNpZnNfbG9ja19zZWNyZXQ7CiAKIC8qCmRpZmYgLS1naXQgYS9m
cy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggZDg4YjRiNTIzZGNj
Li5lYTkwYzUzMzg2YjggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9j
aWZzL2NpZnNnbG9iLmgKQEAgLTEyNTcsOCArMTI1Nyw3IEBAIHN0cnVjdCBjaWZzRmlsZUluZm8g
ewogCXN0cnVjdCB3b3JrX3N0cnVjdCBvcGxvY2tfYnJlYWs7IC8qIHdvcmsgZm9yIG9wbG9jayBi
cmVha3MgKi8KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QgcHV0OyAvKiB3b3JrIGZvciB0aGUgZmluYWwg
cGFydCBvZiBfcHV0ICovCiAJc3RydWN0IGRlbGF5ZWRfd29yayBkZWZlcnJlZDsKLQlib29sIG9w
bG9ja19icmVha19yZWNlaXZlZDsgLyogRmxhZyB0byBpbmRpY2F0ZSBvcGxvY2sgYnJlYWsgKi8K
LQlib29sIGRlZmVycmVkX3NjaGVkdWxlZDsKKwlib29sIGRlZmVycmVkX2Nsb3NlX3NjaGVkdWxl
ZDsgLyogRmxhZyB0byBpbmRpY2F0ZSBjbG9zZSBpcyBzY2hlZHVsZWQgKi8KIH07CiAKIHN0cnVj
dCBjaWZzX2lvX3Bhcm1zIHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9m
aWxlLmMKaW5kZXggOTE5YzgyZDQ3MTNkLi5jY2RmOWI2MjA2MmEgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5jCkBAIC0zMjMsOCArMzIzLDcgQEAgY2lmc19u
ZXdfZmlsZWluZm8oc3RydWN0IGNpZnNfZmlkICpmaWQsIHN0cnVjdCBmaWxlICpmaWxlLAogCWNm
aWxlLT5kZW50cnkgPSBkZ2V0KGRlbnRyeSk7CiAJY2ZpbGUtPmZfZmxhZ3MgPSBmaWxlLT5mX2Zs
YWdzOwogCWNmaWxlLT5pbnZhbGlkSGFuZGxlID0gZmFsc2U7Ci0JY2ZpbGUtPm9wbG9ja19icmVh
a19yZWNlaXZlZCA9IGZhbHNlOwotCWNmaWxlLT5kZWZlcnJlZF9zY2hlZHVsZWQgPSBmYWxzZTsK
KwljZmlsZS0+ZGVmZXJyZWRfY2xvc2Vfc2NoZWR1bGVkID0gZmFsc2U7CiAJY2ZpbGUtPnRsaW5r
ID0gY2lmc19nZXRfdGxpbmsodGxpbmspOwogCUlOSVRfV09SSygmY2ZpbGUtPm9wbG9ja19icmVh
aywgY2lmc19vcGxvY2tfYnJlYWspOwogCUlOSVRfV09SSygmY2ZpbGUtPnB1dCwgY2lmc0ZpbGVJ
bmZvX3B1dF93b3JrKTsKQEAgLTU3NCwyMSArNTczLDE4IEBAIGludCBjaWZzX29wZW4oc3RydWN0
IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAJCQlmaWxlLT5mX29wID0gJmNpZnNf
ZmlsZV9kaXJlY3Rfb3BzOwogCX0KIAotCXNwaW5fbG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJy
ZWRfbG9jayk7CiAJLyogR2V0IHRoZSBjYWNoZWQgaGFuZGxlIGFzIFNNQjIgY2xvc2UgaXMgZGVm
ZXJyZWQgKi8KIAlyYyA9IGNpZnNfZ2V0X3JlYWRhYmxlX3BhdGgodGNvbiwgZnVsbF9wYXRoLCAm
Y2ZpbGUpOwogCWlmIChyYyA9PSAwKSB7CiAJCWlmIChmaWxlLT5mX2ZsYWdzID09IGNmaWxlLT5m
X2ZsYWdzKSB7CiAJCQlmaWxlLT5wcml2YXRlX2RhdGEgPSBjZmlsZTsKKwkJCXNwaW5fbG9jaygm
Q0lGU19JKGlub2RlKS0+ZGVmZXJyZWRfbG9jayk7CiAJCQljaWZzX2RlbF9kZWZlcnJlZF9jbG9z
ZShjZmlsZSk7CiAJCQlzcGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRfbG9jayk7
CiAJCQlnb3RvIG91dDsKIAkJfSBlbHNlIHsKLQkJCXNwaW5fdW5sb2NrKCZDSUZTX0koaW5vZGUp
LT5kZWZlcnJlZF9sb2NrKTsKIAkJCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxlLCB0cnVlLCBmYWxz
ZSk7CiAJCX0KLQl9IGVsc2UgewotCQlzcGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJy
ZWRfbG9jayk7CiAJfQogCiAJaWYgKHNlcnZlci0+b3Bsb2NrcykKQEAgLTg3OCwxMiArODc0LDEy
IEBAIHZvaWQgc21iMl9kZWZlcnJlZF93b3JrX2Nsb3NlKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykKIAkJCXN0cnVjdCBjaWZzRmlsZUluZm8sIGRlZmVycmVkLndvcmspOwogCiAJc3Bpbl9sb2Nr
KCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOwotCWlmICgh
Y2ZpbGUtPmRlZmVycmVkX3NjaGVkdWxlZCkgeworCWlmICghY2ZpbGUtPmRlZmVycmVkX2Nsb3Nl
X3NjaGVkdWxlZCkgewogCQlzcGluX3VubG9jaygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRy
eSkpLT5kZWZlcnJlZF9sb2NrKTsKIAkJcmV0dXJuOwogCX0KIAljaWZzX2RlbF9kZWZlcnJlZF9j
bG9zZShjZmlsZSk7Ci0JY2ZpbGUtPmRlZmVycmVkX3NjaGVkdWxlZCA9IGZhbHNlOworCWNmaWxl
LT5kZWZlcnJlZF9jbG9zZV9zY2hlZHVsZWQgPSBmYWxzZTsKIAlzcGluX3VubG9jaygmQ0lGU19J
KGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKIAlfY2lmc0ZpbGVJbmZv
X3B1dChjZmlsZSwgdHJ1ZSwgZmFsc2UpOwogfQpAQCAtOTA1LDE0ICs5MDEsMTUgQEAgaW50IGNp
ZnNfY2xvc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAJCQkJaW5v
ZGUtPmlfY3RpbWUgPSBpbm9kZS0+aV9tdGltZSA9IGN1cnJlbnRfdGltZShpbm9kZSk7CiAJCQlz
cGluX2xvY2soJmNpbm9kZS0+ZGVmZXJyZWRfbG9jayk7CiAJCQljaWZzX2FkZF9kZWZlcnJlZF9j
bG9zZShjZmlsZSwgZGNsb3NlKTsKLQkJCWlmIChjZmlsZS0+ZGVmZXJyZWRfc2NoZWR1bGVkKSB7
CisJCQlpZiAoY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCAmJgorCQkJICAgIGRlbGF5
ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CiAJCQkJbW9kX2RlbGF5ZWRfd29y
ayhkZWZlcnJlZGNsb3NlX3dxLAogCQkJCQkJJmNmaWxlLT5kZWZlcnJlZCwgY2lmc19zYi0+Y3R4
LT5hY3JlZ21heCk7CiAJCQl9IGVsc2UgewogCQkJCS8qIERlZmVycmVkIGNsb3NlIGZvciBmaWxl
cyAqLwogCQkJCXF1ZXVlX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3NlX3dxLAogCQkJCQkJJmNm
aWxlLT5kZWZlcnJlZCwgY2lmc19zYi0+Y3R4LT5hY3JlZ21heCk7Ci0JCQkJY2ZpbGUtPmRlZmVy
cmVkX3NjaGVkdWxlZCA9IHRydWU7CisJCQkJY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxl
ZCA9IHRydWU7CiAJCQkJc3Bpbl91bmxvY2soJmNpbm9kZS0+ZGVmZXJyZWRfbG9jayk7CiAJCQkJ
cmV0dXJuIDA7CiAJCQl9CkBAIC0yMDIwLDggKzIwMTcsNyBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZv
ICpmaW5kX3JlYWRhYmxlX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUsCiAJ
CWlmIChmc3VpZF9vbmx5ICYmICF1aWRfZXEob3Blbl9maWxlLT51aWQsIGN1cnJlbnRfZnN1aWQo
KSkpCiAJCQljb250aW51ZTsKIAkJaWYgKE9QRU5fRk1PREUob3Blbl9maWxlLT5mX2ZsYWdzKSAm
IEZNT0RFX1JFQUQpIHsKLQkJCWlmICgoIW9wZW5fZmlsZS0+aW52YWxpZEhhbmRsZSkgJiYKLQkJ
CQkoIW9wZW5fZmlsZS0+b3Bsb2NrX2JyZWFrX3JlY2VpdmVkKSkgeworCQkJaWYgKCghb3Blbl9m
aWxlLT5pbnZhbGlkSGFuZGxlKSkgewogCQkJCS8qIGZvdW5kIGEgZ29vZCBmaWxlICovCiAJCQkJ
LyogbG9jayBpdCBzbyBpdCB3aWxsIG5vdCBiZSBjbG9zZWQgb24gdXMgKi8KIAkJCQljaWZzRmls
ZUluZm9fZ2V0KG9wZW5fZmlsZSk7CkBAIC00ODc0LDEzICs0ODcwLDE0IEBAIHZvaWQgY2lmc19v
cGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCX0KIAkvKgogCSAqIFdoZW4g
b3Bsb2NrIGJyZWFrIGlzIHJlY2VpdmVkIGFuZCB0aGVyZSBhcmUgbm8gYWN0aXZlCi0JICogZmls
ZSBoYW5kbGVzIGJ1dCBjYWNoZWQsIHRoZW4gc2V0IHRoZSBmbGFnIG9wbG9ja19icmVha19yZWNl
aXZlZC4KKwkgKiBmaWxlIGhhbmRsZXMgYnV0IGNhY2hlZCwgdGhlbiBzY2hlZHVsZSBkZWZlcnJl
ZCBjbG9zZSBpbW1lZGlhdGVseS4KIAkgKiBTbywgbmV3IG9wZW4gd2lsbCBub3QgdXNlIGNhY2hl
ZCBoYW5kbGUuCiAJICovCiAJc3Bpbl9sb2NrKCZDSUZTX0koaW5vZGUpLT5kZWZlcnJlZF9sb2Nr
KTsKIAlpc19kZWZlcnJlZCA9IGNpZnNfaXNfZGVmZXJyZWRfY2xvc2UoY2ZpbGUsICZkY2xvc2Up
OwotCWlmIChpc19kZWZlcnJlZCAmJiBjZmlsZS0+ZGVmZXJyZWRfc2NoZWR1bGVkKSB7Ci0JCWNm
aWxlLT5vcGxvY2tfYnJlYWtfcmVjZWl2ZWQgPSB0cnVlOworCWlmIChpc19kZWZlcnJlZCAmJgor
CSAgICBjZmlsZS0+ZGVmZXJyZWRfY2xvc2Vfc2NoZWR1bGVkICYmCisJICAgIGRlbGF5ZWRfd29y
a19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CiAJCW1vZF9kZWxheWVkX3dvcmsoZGVmZXJy
ZWRjbG9zZV93cSwgJmNmaWxlLT5kZWZlcnJlZCwgMCk7CiAJfQogCXNwaW5fdW5sb2NrKCZDSUZT
X0koaW5vZGUpLT5kZWZlcnJlZF9sb2NrKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvbWlzYy5jIGIv
ZnMvY2lmcy9taXNjLmMKaW5kZXggNTI0ZGJkZmI3MTg0Li5jZDcwNWY4YTRlMzEgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvbWlzYy5jCisrKyBiL2ZzL2NpZnMvbWlzYy5jCkBAIC02NzIsNiArNjcyLDkg
QEAgY2lmc19hZGRfcGVuZGluZ19vcGVuKHN0cnVjdCBjaWZzX2ZpZCAqZmlkLCBzdHJ1Y3QgdGNv
bl9saW5rICp0bGluaywKIAlzcGluX3VubG9jaygmdGxpbmtfdGNvbihvcGVuLT50bGluayktPm9w
ZW5fZmlsZV9sb2NrKTsKIH0KIAorLyoKKyAqIENyaXRpY2FsIHNlY3Rpb24gd2hpY2ggcnVucyBh
ZnRlciBhY3F1aXJpbmcgZGVmZXJyZWRfbG9jay4KKyAqLwogYm9vbAogY2lmc19pc19kZWZlcnJl
ZF9jbG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgc3RydWN0IGNpZnNfZGVmZXJyZWRf
Y2xvc2UgKipwZGNsb3NlKQogewpAQCAtNjg4LDYgKzY5MSw5IEBAIGNpZnNfaXNfZGVmZXJyZWRf
Y2xvc2Uoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUsIHN0cnVjdCBjaWZzX2RlZmVycmVkX2Ns
b3NlICoqCiAJcmV0dXJuIGZhbHNlOwogfQogCisvKgorICogQ3JpdGljYWwgc2VjdGlvbiB3aGlj
aCBydW5zIGFmdGVyIGFjcXVpcmluZyBkZWZlcnJlZF9sb2NrLgorICovCiB2b2lkCiBjaWZzX2Fk
ZF9kZWZlcnJlZF9jbG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgc3RydWN0IGNpZnNf
ZGVmZXJyZWRfY2xvc2UgKmRjbG9zZSkKIHsKQEAgLTcwNyw2ICs3MTMsOSBAQCBjaWZzX2FkZF9k
ZWZlcnJlZF9jbG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgc3RydWN0IGNpZnNfZGVm
ZXJyZWRfY2xvc2UgKgogCWxpc3RfYWRkX3RhaWwoJmRjbG9zZS0+ZGxpc3QsICZDSUZTX0koZF9p
bm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2Nsb3Nlcyk7CiB9CiAKKy8qCisgKiBDcml0
aWNhbCBzZWN0aW9uIHdoaWNoIHJ1bnMgYWZ0ZXIgYWNxdWlyaW5nIGRlZmVycmVkX2xvY2suCisg
Ki8KIHZvaWQKIGNpZnNfZGVsX2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNm
aWxlKQogewotLSAKMi4zMC4yCgo=
--000000000000f7275805c28055b2--
