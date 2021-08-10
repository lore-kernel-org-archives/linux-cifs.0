Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30849C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 19:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0710460ED8
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 19:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhHJTsz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 15:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhHJTsz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 15:48:55 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5950DC0613C1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 12:48:32 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u13so411508lje.5
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 12:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fWWWc6R2n9vN6ZD9qkSo+V9674scsksuoFM+dOxkdrQ=;
        b=gISot/ZuTtjiwXs+jNPV9tTvqfazA8rnsk1Rsq3tuWDGFls7JqOkV7HHKZXu9+iWUZ
         EqnEoY3VJCU3YDvClxOC2vsRTv6GlIbtCu1tHYmWlMtYbVW8r3yLzBusBE2LmcVInlyM
         5vSe7h6kKmqHryDKkzX6ukOxPAheeZUFl3Pa79mUA8hYCG1MXjg9xDbjb4puh4ImDpft
         yOKVS0d2CsC2jlpyhezD8aK0whzOQa+Hg5h2+Zmj+xxFY/PWUhqhOp6B+IfKU735osXD
         ubZ1zXzie6x54I7y4NM1yldbzw4BWOUmBmEgj1olUCLQhvAGf7750QX7EZhmzjyhOEh9
         6nIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fWWWc6R2n9vN6ZD9qkSo+V9674scsksuoFM+dOxkdrQ=;
        b=oacMFeTyr20k3+YrAMEhZjM9ptqOuH74DzbEHkBEpEvOo3Bomqa/xIanz2rknPwL/F
         zTifEPE6mDLc1Y3lMWqBw0BGo4/BqCnVeY5ezqxftp747U50VuNZ397MgRtrYbwJK75a
         +Oy8E5tL8s61pnMbEcuaTs1UZGqjEXrb74/qgDRe6RcgC8eQ2ck/Xt7cxh5V5tHNHWq8
         rVEG5XucdmmH56+p7S/Kozr5xKOP2ectuV6SN6h2XuyRtbCqix0pPLfsR7vE0nHhJ1qM
         EmQoeirfj1Mi3ppHrTTjxgZsnGflhOcIwoC20TDByIaDsCBodqycF8KunIMccCqFLof+
         KUOg==
X-Gm-Message-State: AOAM532IQLfuF8yuOTh/2pDufk93iMwoErHUlz5y0ZexKBkESaDoX+Sm
        Ai8YNmPr0xhlL0MIngiaWAuAbPkRqwut7IIaagA=
X-Google-Smtp-Source: ABdhPJzvwYQfoud+3ObZYR5mjw3T3+RKLPTEvDkJSaHRWSyawQWC1xUxiKxksmK6SQOPzMuzX3FMC/a/vjQSz9xA9ok=
X-Received: by 2002:a2e:95c1:: with SMTP id y1mr20603153ljh.71.1628624910608;
 Tue, 10 Aug 2021 12:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Z4rDEGsi02+0DJnw2EoTV2CSC-jDN-SyDhKz0WcGZoAQ@mail.gmail.com>
 <CANT5p=rN_ogRccKmYpE+17qz=zRyUJChcKo5+cJiwDTFq_cBJw@mail.gmail.com>
 <CACdtm0aGGqtSsv1t2=VTGZZTBD52JvOsWD_oqXuUnejeDCVJFw@mail.gmail.com>
 <CAH2r5mtQCC8upykXm5zZVO94-TRbxq2HMN5S65ROASwaRqOfuA@mail.gmail.com> <CAH2r5mvAr5FYn3-y7MxJE=uaODvgp8c6J6NwFLiyh8u8r5LdCA@mail.gmail.com>
In-Reply-To: <CAH2r5mvAr5FYn3-y7MxJE=uaODvgp8c6J6NwFLiyh8u8r5LdCA@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Wed, 11 Aug 2021 01:18:19 +0530
Message-ID: <CACdtm0aekkd95jiibdC8wx0eNupP2wRQET5h1F2CVoZKRVDqaA@mail.gmail.com>
Subject: Re: [PATCH][CIFS]Call close synchronously during unlink/rename/lease break.
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000004503bd05c939c96f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004503bd05c939c96f
Content-Type: text/plain; charset="UTF-8"

Hi All,

I have attached an old version of patch by mistake.
Have attached the correct one.

Sorry for the confusion.

Regards.
Rohith

On Wed, Aug 11, 2021 at 1:02 AM Steve French <smfrench@gmail.com> wrote:
>
> This is in http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/766
>
> On Tue, Aug 10, 2021 at 2:28 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I saw some test failures in
> >
> > and looking in /var/log/messages I see e.g.
> >
> > Aug 10 14:00:22 fedora29 systemd[1]: Started /usr/bin/bash -c exit 77.
> > Aug 10 14:00:25 fedora29 kernel: kmemleak: 10 new suspected memory
> > leaks (see /sys/kernel/debug/kmemleak)
> > Aug 10 14:00:28 fedora29 kernel: kmemleak: 1 new suspected memory
> > leaks (see /sys/kernel/debug/kmemleak)
> > Aug 10 14:00:28 fedora29 kernel: CIFS: Attempting to mount
> > \\win16.vm.test\Scratch
> > Aug 10 14:00:28 fedora29 kernel: CIFS: Attempting to mount
> > \\win16.vm.test\Scratch
> > Aug 10 14:00:29 fedora29 root[6460]: run xfstest cifs/100
> > Aug 10 14:00:29 fedora29 journal: run fstests cifs/100 at 2021-08-10 14:00:29
> > Aug 10 14:00:29 fedora29 systemd[1]: Started /usr/bin/bash -c test -w
> > /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec
> > ./tests/cifs/100.
> > Aug 10 14:00:30 fedora29 kernel: general protection fault, probably
> > for non-canonical address 0xdead000000000110: 0000 [#4] SMP PTI
> > Aug 10 14:00:30 fedora29 kernel: CPU: 0 PID: 6624 Comm: rm Tainted: G
> >     D           5.14.0-rc4 #1
> > Aug 10 14:00:30 fedora29 kernel: Hardware name: Red Hat KVM, BIOS
> > 0.5.1 01/01/2011
> > Aug 10 14:00:30 fedora29 kernel: RIP:
> > 0010:cifs_close_deferred_file+0x77/0x140 [cifs]
> > Aug 10 14:00:30 fedora29 kernel: Code: 85 de 00 00 00 4c 89 ef e8 06
> > 96 2e e8 48 8b 1c 24 4c 39 e3 74 55 49 bd 00 01 00 00 00 00 ad de 48
> > bd 22 01 00 00 00 00 ad de <48> 8b 7b 10 31 d2 be 01 00 00 00 e8 a9 c5
> > fe ff 48 89 df e8 61 46
> > Aug 10 14:00:30 fedora29 kernel: RSP: 0018:ffffb121806dbdd0 EFLAGS: 00010287
> > Aug 10 14:00:30 fedora29 kernel: RAX: ffff88dc55b8ca01 RBX:
> > dead000000000100 RCX: 00000000000034d9
> > Aug 10 14:00:30 fedora29 kernel: RDX: 00000000000034d8 RSI:
> > 67739b6f43694caa RDI: 0000000000032080
> >
> > and
> >
> > Aug 10 14:00:30 fedora29 kernel: ---[ end trace b062b12a095f4dd5 ]---
> > Aug 10 14:00:30 fedora29 kernel: RIP:
> > 0010:cifs_close_deferred_file+0x77/0x140 [cifs]
> > Aug 10 14:00:30 fedora29 kernel: Code: 85 de 00 00 00 4c 89 ef e8 06
> > 96 2e e8 48 8b 1c 24 4c 39 e3 74 55 49 bd 00 01 00 00 00 00 ad de 48
> > bd 22 01 00 00 00 00 ad de <48> 8b 7b 10 31 d2 be 01 00 00 00 e8 a9 c5
> > fe ff 48 89 df e8 61 46
> > Aug 10 14:00:30 fedora29 kernel: RSP: 0018:ffffb12180f0fc80 EFLAGS: 00010283
> > Aug 10 14:00:30 fedora29 kernel: RAX: ffff88dc5b2ca201 RBX:
> > dead000000000100 RCX: 0000000000002367
> > Aug 10 14:00:30 fedora29 kernel: RDX: 0000000000002366 RSI:
> > 67100f614dfd246a RDI: 0000000000032080
> > Aug 10 14:00:30 fedora29 kernel: RBP: dead000000000122 R08:
> > 0000000000000001 R09: 0000000000000001
> > Aug 10 14:00:30 fedora29 kernel: R10: ffffb12180f0fba0 R11:
> > 0000000000000001 R12: ffffb12180f0fc80
> >
> > On Tue, Aug 10, 2021 at 12:29 PM Rohith Surabattula
> > <rohiths.msft@gmail.com> wrote:
> > >
> > > Hi All,
> > >
> > > Have updated the patch to fix the memleak.
> > >
> > > Regards,
> > > Rohith
> > >
> > > On Tue, Aug 10, 2021 at 5:18 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > >
> > > > Already gave my review comments along with this one to the other email.
> > > >
> > > > Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> > > >
> > > > On Mon, Aug 9, 2021 at 3:28 PM Rohith Surabattula
> > > > <rohiths.msft@gmail.com> wrote:
> > > > >
> > > > > Hi Steve/All,
> > > > >
> > > > > During unlink/rename/lease break, deferred work for close is
> > > > > scheduled immediately but in asynchronous manner which might
> > > > > lead to race with actual(unlink/rename) commands.
> > > > >
> > > > > This change will schedule close synchronously which will avoid
> > > > > the race conditions with other commands.
> > > > >
> > > > > Regards,
> > > > > Rohith
> > > >
> > > >
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve

--0000000000004503bd05c939c96f
Content-Type: application/octet-stream; 
	name="cifs-Call-close-synchronously-during-unlink-rename-l.patch"
Content-Disposition: attachment; 
	filename="cifs-Call-close-synchronously-during-unlink-rename-l.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ks6h7i200>
X-Attachment-Id: f_ks6h7i200

RnJvbSAyMmI0NjRmOGY3ZmZmNGQzNjZlMDU3YmY1ZTVhNTFiMTJjZTQ4YmRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCA5IEF1ZyAyMDIxIDA5OjMyOjQ2ICswMDAwClN1YmplY3Q6IFtQQVRD
SCAyLzJdIGNpZnM6IENhbGwgY2xvc2Ugc3luY2hyb25vdXNseSBkdXJpbmcgdW5saW5rL3JlbmFt
ZS9sZWFzZQogYnJlYWsuCgpEdXJpbmcgdW5saW5rL3JlbmFtZS9sZWFzZSBicmVhaywgZGVmZXJy
ZWQgd29yayBmb3IgY2xvc2UgaXMKc2NoZWR1bGVkIGltbWVkaWF0ZWx5IGJ1dCBpbiBhc3luY2hy
b25vdXMgbWFubmVyIHdoaWNoIG1pZ2h0CmxlYWQgdG8gcmFjZSB3aXRoIGFjdHVhbCh1bmxpbmsv
cmVuYW1lKSBjb21tYW5kcy4KClRoaXMgY2hhbmdlIHdpbGwgc2NoZWR1bGUgY2xvc2Ugc3luY2hy
b25vdXNseSB3aGljaCB3aWxsIGF2b2lkCnRoZSByYWNlIGNvbmRpdGlvbnMgd2l0aCBvdGhlciBj
b21tYW5kcy4KClNpZ25lZC1vZmYtYnk6IFJvaGl0aCBTdXJhYmF0dHVsYSA8cm9oaXRoc0BtaWNy
b3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2dsb2IuaCB8ICA1ICsrKysrCiBmcy9jaWZzL2Zp
bGUuYyAgICAgfCAzNSArKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQogZnMvY2lm
cy9taXNjLmMgICAgIHwgNDYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCA1NiBpbnNlcnRpb25zKCspLCAzMCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgK
aW5kZXggYzBiZmMyZjAxMDMwLi5jNmE5NTQyY2EyODEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lm
c2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAgLTE2MTEsNiArMTYxMSwxMSBAQCBz
dHJ1Y3QgZGZzX2luZm8zX3BhcmFtIHsKIAlpbnQgdHRsOwogfTsKIAorc3RydWN0IGZpbGVfbGlz
dCB7CisJc3RydWN0IGxpc3RfaGVhZCBsaXN0OworCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxl
OworfTsKKwogLyoKICAqIGNvbW1vbiBzdHJ1Y3QgZm9yIGhvbGRpbmcgaW5vZGUgaW5mbyB3aGVu
IHNlYXJjaGluZyBmb3Igb3IgdXBkYXRpbmcgYW4KICAqIGlub2RlIHdpdGggbmV3IGluZm8KZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggMGE3Mjg0MGE4
OGYxLi5iYjk4ZmJkZDIyYTkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZmlsZS5jCisrKyBiL2ZzL2Np
ZnMvZmlsZS5jCkBAIC00ODQ3LDE3ICs0ODQ3LDYgQEAgdm9pZCBjaWZzX29wbG9ja19icmVhayhz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCWNpZnNfZGJnKFZGUywgIlB1c2ggbG9ja3MgcmMg
PSAlZFxuIiwgcmMpOwogCiBvcGxvY2tfYnJlYWtfYWNrOgotCS8qCi0JICogcmVsZWFzaW5nIHN0
YWxlIG9wbG9jayBhZnRlciByZWNlbnQgcmVjb25uZWN0IG9mIHNtYiBzZXNzaW9uIHVzaW5nCi0J
ICogYSBub3cgaW5jb3JyZWN0IGZpbGUgaGFuZGxlIGlzIG5vdCBhIGRhdGEgaW50ZWdyaXR5IGlz
c3VlIGJ1dCBkbwotCSAqIG5vdCBib3RoZXIgc2VuZGluZyBhbiBvcGxvY2sgcmVsZWFzZSBpZiBz
ZXNzaW9uIHRvIHNlcnZlciBzdGlsbCBpcwotCSAqIGRpc2Nvbm5lY3RlZCBzaW5jZSBvcGxvY2sg
YWxyZWFkeSByZWxlYXNlZCBieSB0aGUgc2VydmVyCi0JICovCi0JaWYgKCFjZmlsZS0+b3Bsb2Nr
X2JyZWFrX2NhbmNlbGxlZCkgewotCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPm9wbG9j
a19yZXNwb25zZSh0Y29uLCAmY2ZpbGUtPmZpZCwKLQkJCQkJCQkgICAgIGNpbm9kZSk7Ci0JCWNp
ZnNfZGJnKEZZSSwgIk9wbG9jayByZWxlYXNlIHJjID0gJWRcbiIsIHJjKTsKLQl9CiAJLyoKIAkg
KiBXaGVuIG9wbG9jayBicmVhayBpcyByZWNlaXZlZCBhbmQgdGhlcmUgYXJlIG5vIGFjdGl2ZQog
CSAqIGZpbGUgaGFuZGxlcyBidXQgY2FjaGVkLCB0aGVuIHNjaGVkdWxlIGRlZmVycmVkIGNsb3Nl
IGltbWVkaWF0ZWx5LgpAQCAtNDg2NSwxNyArNDg1NCwyNyBAQCB2b2lkIGNpZnNfb3Bsb2NrX2Jy
ZWFrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkgKi8KIAlzcGluX2xvY2soJkNJRlNfSShp
bm9kZSktPmRlZmVycmVkX2xvY2spOwogCWlzX2RlZmVycmVkID0gY2lmc19pc19kZWZlcnJlZF9j
bG9zZShjZmlsZSwgJmRjbG9zZSk7CisJc3Bpbl91bmxvY2soJkNJRlNfSShpbm9kZSktPmRlZmVy
cmVkX2xvY2spOwogCWlmIChpc19kZWZlcnJlZCAmJgogCSAgICBjZmlsZS0+ZGVmZXJyZWRfY2xv
c2Vfc2NoZWR1bGVkICYmCiAJICAgIGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJy
ZWQpKSB7Ci0JCS8qCi0JCSAqIElmIHRoZXJlIGlzIG5vIHBlbmRpbmcgd29yaywgbW9kX2RlbGF5
ZWRfd29yayBxdWV1ZXMgbmV3IHdvcmsuCi0JCSAqIFNvLCBJbmNyZWFzZSB0aGUgcmVmIGNvdW50
IHRvIGF2b2lkIHVzZS1hZnRlci1mcmVlLgotCQkgKi8KLQkJaWYgKCFtb2RfZGVsYXllZF93b3Jr
KGRlZmVycmVkY2xvc2Vfd3EsICZjZmlsZS0+ZGVmZXJyZWQsIDApKQotCQkJY2lmc0ZpbGVJbmZv
X2dldChjZmlsZSk7CisJCWlmIChjYW5jZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJyZWQp
KSB7CisJCQlfY2lmc0ZpbGVJbmZvX3B1dChjZmlsZSwgZmFsc2UsIGZhbHNlKTsKKwkJCWdvdG8g
b3Bsb2NrX2JyZWFrX2RvbmU7CisJCX0KIAl9Ci0Jc3Bpbl91bmxvY2soJkNJRlNfSShpbm9kZSkt
PmRlZmVycmVkX2xvY2spOworCS8qCisJICogcmVsZWFzaW5nIHN0YWxlIG9wbG9jayBhZnRlciBy
ZWNlbnQgcmVjb25uZWN0IG9mIHNtYiBzZXNzaW9uIHVzaW5nCisJICogYSBub3cgaW5jb3JyZWN0
IGZpbGUgaGFuZGxlIGlzIG5vdCBhIGRhdGEgaW50ZWdyaXR5IGlzc3VlIGJ1dCBkbworCSAqIG5v
dCBib3RoZXIgc2VuZGluZyBhbiBvcGxvY2sgcmVsZWFzZSBpZiBzZXNzaW9uIHRvIHNlcnZlciBz
dGlsbCBpcworCSAqIGRpc2Nvbm5lY3RlZCBzaW5jZSBvcGxvY2sgYWxyZWFkeSByZWxlYXNlZCBi
eSB0aGUgc2VydmVyCisJICovCisJaWYgKCFjZmlsZS0+b3Bsb2NrX2JyZWFrX2NhbmNlbGxlZCkg
eworCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPm9wbG9ja19yZXNwb25zZSh0Y29uLCAm
Y2ZpbGUtPmZpZCwKKwkJCQkJCQkgICAgIGNpbm9kZSk7CisJCWNpZnNfZGJnKEZZSSwgIk9wbG9j
ayByZWxlYXNlIHJjID0gJWRcbiIsIHJjKTsKKwl9CitvcGxvY2tfYnJlYWtfZG9uZToKIAlfY2lm
c0ZpbGVJbmZvX3B1dChjZmlsZSwgZmFsc2UgLyogZG8gbm90IHdhaXQgZm9yIG91cnNlbGYgKi8s
IGZhbHNlKTsKIAljaWZzX2RvbmVfb3Bsb2NrX2JyZWFrKGNpbm9kZSk7CiB9CmRpZmYgLS1naXQg
YS9mcy9jaWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IGNkYjFlYzE0NjFkZS4uOTQ2
OWYxY2YwYjQ2IDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2Mu
YwpAQCAtNzIzLDIwICs3MjMsMzIgQEAgdm9pZAogY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlKHN0
cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzX2lub2RlKQogewogCXN0cnVjdCBjaWZzRmlsZUluZm8g
KmNmaWxlID0gTlVMTDsKKwlzdHJ1Y3QgZmlsZV9saXN0ICp0bXBfbGlzdCwgKnRtcF9uZXh0X2xp
c3Q7CisJc3RydWN0IGxpc3RfaGVhZCBmaWxlX2hlYWQ7CiAKIAlpZiAoY2lmc19pbm9kZSA9PSBO
VUxMKQogCQlyZXR1cm47CiAKKwlJTklUX0xJU1RfSEVBRCgmZmlsZV9oZWFkKTsKKwlzcGluX2xv
Y2soJmNpZnNfaW5vZGUtPm9wZW5fZmlsZV9sb2NrKTsKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNm
aWxlLCAmY2lmc19pbm9kZS0+b3BlbkZpbGVMaXN0LCBmbGlzdCkgewogCQlpZiAoZGVsYXllZF93
b3JrX3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkpIHsKLQkJCS8qCi0JCQkgKiBJZiB0aGVyZSBp
cyBubyBwZW5kaW5nIHdvcmssIG1vZF9kZWxheWVkX3dvcmsgcXVldWVzIG5ldyB3b3JrLgotCQkJ
ICogU28sIEluY3JlYXNlIHRoZSByZWYgY291bnQgdG8gYXZvaWQgdXNlLWFmdGVyLWZyZWUuCi0J
CQkgKi8KLQkJCWlmICghbW9kX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3NlX3dxLCAmY2ZpbGUt
PmRlZmVycmVkLCAwKSkKLQkJCQljaWZzRmlsZUluZm9fZ2V0KGNmaWxlKTsKKwkJCWlmIChjYW5j
ZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CisJCQkJdG1wX2xpc3QgPSBrbWFs
bG9jKHNpemVvZihzdHJ1Y3QgZmlsZV9saXN0KSwgR0ZQX0FUT01JQyk7CisJCQkJaWYgKHRtcF9s
aXN0ID09IE5VTEwpCisJCQkJCWNvbnRpbnVlOworCQkJCXRtcF9saXN0LT5jZmlsZSA9IGNmaWxl
OworCQkJCWxpc3RfYWRkX3RhaWwoJnRtcF9saXN0LT5saXN0LCAmZmlsZV9oZWFkKTsKKwkJCX0K
IAkJfQogCX0KKwlzcGluX3VubG9jaygmY2lmc19pbm9kZS0+b3Blbl9maWxlX2xvY2spOworCisJ
bGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHRtcF9saXN0LCB0bXBfbmV4dF9saXN0LCAmZmlsZV9o
ZWFkLCBsaXN0KSB7CisJCV9jaWZzRmlsZUluZm9fcHV0KHRtcF9saXN0LT5jZmlsZSwgdHJ1ZSwg
ZmFsc2UpOworCQlsaXN0X2RlbCgmdG1wX2xpc3QtPmxpc3QpOworCQlrZnJlZSh0bXBfbGlzdCk7
CisJfQogfQogCiB2b2lkCkBAIC03NDQsMjAgKzc1NiwzMCBAQCBjaWZzX2Nsb3NlX2FsbF9kZWZl
cnJlZF9maWxlcyhzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogewogCXN0cnVjdCBjaWZzRmlsZUlu
Zm8gKmNmaWxlOwogCXN0cnVjdCBsaXN0X2hlYWQgKnRtcDsKKwlzdHJ1Y3QgZmlsZV9saXN0ICp0
bXBfbGlzdCwgKnRtcF9uZXh0X2xpc3Q7CisJc3RydWN0IGxpc3RfaGVhZCBmaWxlX2hlYWQ7CiAK
KwlJTklUX0xJU1RfSEVBRCgmZmlsZV9oZWFkKTsKIAlzcGluX2xvY2soJnRjb24tPm9wZW5fZmls
ZV9sb2NrKTsKIAlsaXN0X2Zvcl9lYWNoKHRtcCwgJnRjb24tPm9wZW5GaWxlTGlzdCkgewogCQlj
ZmlsZSA9IGxpc3RfZW50cnkodG1wLCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvLCB0bGlzdCk7CiAJCWlm
IChkZWxheWVkX3dvcmtfcGVuZGluZygmY2ZpbGUtPmRlZmVycmVkKSkgewotCQkJLyoKLQkJCSAq
IElmIHRoZXJlIGlzIG5vIHBlbmRpbmcgd29yaywgbW9kX2RlbGF5ZWRfd29yayBxdWV1ZXMgbmV3
IHdvcmsuCi0JCQkgKiBTbywgSW5jcmVhc2UgdGhlIHJlZiBjb3VudCB0byBhdm9pZCB1c2UtYWZ0
ZXItZnJlZS4KLQkJCSAqLwotCQkJaWYgKCFtb2RfZGVsYXllZF93b3JrKGRlZmVycmVkY2xvc2Vf
d3EsICZjZmlsZS0+ZGVmZXJyZWQsIDApKQotCQkJCWNpZnNGaWxlSW5mb19nZXQoY2ZpbGUpOwor
CQkJaWYgKGNhbmNlbF9kZWxheWVkX3dvcmsoJmNmaWxlLT5kZWZlcnJlZCkpIHsKKwkJCQl0bXBf
bGlzdCA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBmaWxlX2xpc3QpLCBHRlBfQVRPTUlDKTsKKwkJ
CQlpZiAodG1wX2xpc3QgPT0gTlVMTCkKKwkJCQkJY29udGludWU7CisJCQkJdG1wX2xpc3QtPmNm
aWxlID0gY2ZpbGU7CisJCQkJbGlzdF9hZGRfdGFpbCgmdG1wX2xpc3QtPmxpc3QsICZmaWxlX2hl
YWQpOworCQkJfQogCQl9CiAJfQogCXNwaW5fdW5sb2NrKCZ0Y29uLT5vcGVuX2ZpbGVfbG9jayk7
CisKKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUodG1wX2xpc3QsIHRtcF9uZXh0X2xpc3QsICZm
aWxlX2hlYWQsIGxpc3QpIHsKKwkJX2NpZnNGaWxlSW5mb19wdXQodG1wX2xpc3QtPmNmaWxlLCB0
cnVlLCBmYWxzZSk7CisJCWxpc3RfZGVsKCZ0bXBfbGlzdC0+bGlzdCk7CisJCWtmcmVlKHRtcF9s
aXN0KTsKKwl9CiB9CiAKIC8qIHBhcnNlcyBERlMgcmVmZmVyYWwgVjMgc3RydWN0dXJlCi0tIAoy
LjMzLjAucmMxCgo=
--0000000000004503bd05c939c96f--
