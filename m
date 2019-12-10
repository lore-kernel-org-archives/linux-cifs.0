Return-Path: <SRS0=09eL=2A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C75C43603
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Dec 2019 19:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F25982077B
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Dec 2019 19:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EPT0JEIE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfLJTxm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Dec 2019 14:53:42 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38470 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJTxm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Dec 2019 14:53:42 -0500
Received: by mail-lj1-f194.google.com with SMTP id k8so21243082ljh.5
        for <linux-cifs@vger.kernel.org>; Tue, 10 Dec 2019 11:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IDHfg7O5F4emNloWuqCOyeEF22vlm/bu86T9QAjIh18=;
        b=EPT0JEIE06S/Ozg0wsQHLDdfnUDv/edjqKpty3OWPGYGMdNtEAYOrlYpxV+40pQg9I
         rv6gOTfSP7W8ZpoSiATQjUBeeRnUq6q3mOTmCXhI6xdIxdzWGtU+Dp0IPxT8zLzCOrDp
         SW9Vv07qjvyKlIi8/PbqpsiuGRSb3dBmZ3xU2x9GpT0LoCqDf6HstlMdC8xHumbj78hf
         UAXjelPWSyrqnaJ6KhjHCvsxLIWtrMpNhZpWuEoW/KKSMRAhopRJA/pyh7iIwYT35jjk
         Vfna8lZrWwK2uEHYvdSyawyGT6u8jQbnqNTybOk2y4NV18Evx16CFkgYlvGW0szxb89l
         FtCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IDHfg7O5F4emNloWuqCOyeEF22vlm/bu86T9QAjIh18=;
        b=kd+lCrwsxckeip9VUjQJFRzlIczkN+k77V7n6WS+SspSLnQnE8/G0hwgjXUhX6BOdH
         /0l5xzvxDDuoweSmcDclPCPQnf8zG41rmCjYdRH3M0ioxTIXYAWe5uxyU46/jrBaTHfc
         fgCVvSmzer0pwW4BHK13f2jhsNSV2oXM16JKLwiERs+r3gHEWb/P7x6V5f17XPkOBnNi
         /55rYJlBFlKW++m5j7VL+Lt4Oa2zlMody/CT0k+f7/1uM7E0vAj21lFZbX0xeWxgrDAN
         oRr/31rqIH3aus7f8qevwOjz+dC/QrDTpVjOYetudVqK6HC2RhHU43dMe0GNIEfyKfOs
         yuZQ==
X-Gm-Message-State: APjAAAWBpOJTWNIU0KBNb/C4Q4ps0oJCu3NMykk1pKa3kKiSPw3jrlZt
        vXvM5VqzQ0kXKLbpryTWrtOVnYmHPsr+1uju/g==
X-Google-Smtp-Source: APXvYqzAaBjHcmB0ZJ+f2XRd3849j8GVMevLxM1KZY/PB+VtjhPktUhxTU69MP4D35jIIswHhdXbrnA8Vkrj8iUJQoA=
X-Received: by 2002:a2e:9e4c:: with SMTP id g12mr21344425ljk.15.1576007619233;
 Tue, 10 Dec 2019 11:53:39 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJSARbGJ4cOZoGy32mCtUTG9wyEyw8aF06zexshAmqfQ@mail.gmail.com>
In-Reply-To: <CAH2r5muJSARbGJ4cOZoGy32mCtUTG9wyEyw8aF06zexshAmqfQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 10 Dec 2019 11:53:27 -0800
Message-ID: <CAKywueQSgGgPB+tQz28_VCe1LiyxpY7tU9tByypkTJALdHOOWg@mail.gmail.com>
Subject: Re: [PATCH] smb3: fix refcount underflow warning on unmount when no
 directory leases
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004f5a4405995edee2"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004f5a4405995edee2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D0=BF=D0=BD, 9 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 20:48, Steve French=
 <smfrench@gmail.com>:
>
> Fix refcount underflow warning when unmounting to servers which didn't gr=
ant
> directory leases.
>
> [  301.680095] refcount_t: underflow; use-after-free.
> [  301.680192] WARNING: CPU: 1 PID: 3569 at lib/refcount.c:28
> refcount_warn_saturate+0xb4/0xf3
> ...
> [  301.682139] Call Trace:
> [  301.682240]  close_shroot+0x97/0xda [cifs]
> [  301.682351]  SMB2_tdis+0x7c/0x176 [cifs]
> [  301.682456]  ? _get_xid+0x58/0x91 [cifs]
> [  301.682563]  cifs_put_tcon.part.0+0x99/0x202 [cifs]
> [  301.682637]  ? ida_free+0x99/0x10a
> [  301.682727]  ? cifs_umount+0x3d/0x9d [cifs]
> [  301.682829]  cifs_put_tlink+0x3a/0x50 [cifs]
> [  301.682929]  cifs_umount+0x44/0x9d [cifs]
>
> Fixes: 72e73c78c446 ("cifs: close the shared root handle on tree disconne=
ct")
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
>
> --
> Thanks,
>
> Steve

Looking at this more, I think that the fact that the handle is valid
doesn't mean that it has a directory lease. So, I think we need to
track that fact separately. I coded a quick follow-on fix (untested)
to describe my idea - see the attached patch.

Thoughts?

--
Best regards,
Pavel Shilovsky

--0000000000004f5a4405995edee2
Content-Type: application/octet-stream; 
	name="0001-CIFS-Close-cached-root-handle-only-if-it-has-a-lease.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Close-cached-root-handle-only-if-it-has-a-lease.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k40a7hby0>
X-Attachment-Id: f_k40a7hby0

RnJvbSA5ZTU3NmZmMzU2ZTc4ZGViYWMyMDdjY2M5NDc3MjVlYmYxODAxYzRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNv
bT4KRGF0ZTogVHVlLCAxMCBEZWMgMjAxOSAxMTo0NDo1MiAtMDgwMApTdWJqZWN0OiBbUEFUQ0hd
IENJRlM6IENsb3NlIGNhY2hlZCByb290IGhhbmRsZSBvbmx5IGlmIGl0IGhhcyBhIGxlYXNlCgpT
TUIyX3RkaXMoKSBjaGVja3MgaWYgYSByb290IGhhbmRsZSBpcyB2YWxpZCBpbiBvcmRlciB0byBk
ZWNpZGUKd2hldGhlciBpdCBuZWVkcyB0byBjbG9zZSB0aGUgaGFuZGxlIG9yIG5vdC4gSG93ZXZl
ciBpZiBhbm90aGVyCnRocmVhZCBoYXMgcmVmZXJlbmNlIGZvciB0aGUgaGFuZGxlLCBpdCBtYXkg
ZW5kIHVwIHdpdGggcHV0dGluZwp0aGUgcmVmZXJlbmNlIHR3aWNlLiBUaGUgZXh0cmEgcmVmZXJl
bmNlIHRoYXQgd2Ugd2FudCB0byBwdXQKZHVyaW5nIHRoZSB0cmVlIGRpc2Nvbm5lY3QgaXMgdGhl
IHJlZmVyZW5jZSB0aGF0IGhhcyBhIGRpcmVjdG9yeQpsZWFzZS4gU28sIHRyYWNrIHRoZSBmYWN0
IHRoYXQgd2UgaGF2ZSBhIGRpcmVjdG9yeSBsZWFzZSBhbmQKY2xvc2UgdGhlIGhhbmRsZSBvbmx5
IGluIHRoYXQgY2FzZS4KClNpZ25lZC1vZmYtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2dsb2IuaCAgfCAgMiArLQogZnMvY2lmcy9j
aWZzc21iLmMgICB8ICAzICsrKwogZnMvY2lmcy9zbWIyb3BzLmMgICB8IDE5ICsrKysrKysrKysr
KysrKysrKy0KIGZzL2NpZnMvc21iMnBkdS5jICAgfCAgMyArLS0KIGZzL2NpZnMvc21iMnByb3Rv
LmggfCAgMiArKwogNSBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2Iu
aAppbmRleCAzOWNhMTk5MGViMWQuLmI0ODcwMmI5ZjA1ZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTAwMyw3ICsxMDAzLDcgQEAg
Y2FwX3VuaXgoc3RydWN0IGNpZnNfc2VzICpzZXMpCiBzdHJ1Y3QgY2FjaGVkX2ZpZCB7CiAJYm9v
bCBpc192YWxpZDoxOwkvKiBEbyB3ZSBoYXZlIGEgdXNlYWJsZSByb290IGZpZCAqLwogCWJvb2wg
ZmlsZV9hbGxfaW5mb19pc192YWxpZDoxOwotCisJYm9vbCBoYXNfbGVhc2U6MTsKIAlzdHJ1Y3Qg
a3JlZiByZWZjb3VudDsKIAlzdHJ1Y3QgY2lmc19maWQgKmZpZDsKIAlzdHJ1Y3QgbXV0ZXggZmlk
X211dGV4OwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzc21iLmMgYi9mcy9jaWZzL2NpZnNzbWIu
YwppbmRleCAzOTA3NjUzZTYzYzcuLmE1MzVjNmE5ZDIwYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzc21iLmMKKysrIGIvZnMvY2lmcy9jaWZzc21iLmMKQEAgLTQyLDYgKzQyLDcgQEAKICNpbmNs
dWRlICJjaWZzcHJvdG8uaCIKICNpbmNsdWRlICJjaWZzX3VuaWNvZGUuaCIKICNpbmNsdWRlICJj
aWZzX2RlYnVnLmgiCisjaW5jbHVkZSAic21iMnByb3RvLmgiCiAjaW5jbHVkZSAiZnNjYWNoZS5o
IgogI2luY2x1ZGUgInNtYmRpcmVjdC5oIgogI2lmZGVmIENPTkZJR19DSUZTX0RGU19VUENBTEwK
QEAgLTExMiw2ICsxMTMsOCBAQCBjaWZzX21hcmtfb3Blbl9maWxlc19pbnZhbGlkKHN0cnVjdCBj
aWZzX3Rjb24gKnRjb24pCiAKIAltdXRleF9sb2NrKCZ0Y29uLT5jcmZpZC5maWRfbXV0ZXgpOwog
CXRjb24tPmNyZmlkLmlzX3ZhbGlkID0gZmFsc2U7CisJLyogY2FjaGVkIGhhbmRsZSBpcyBub3Qg
dmFsaWQsIHNvIFNNQjJfQ0xPU0Ugd29uJ3QgYmUgc2VudCBiZWxvdyAqLworCWNsb3NlX3Nocm9v
dF9sZWFzZV9sb2NrZWQoJnRjb24tPmNyZmlkKTsKIAltZW1zZXQodGNvbi0+Y3JmaWQuZmlkLCAw
LCBzaXplb2Yoc3RydWN0IGNpZnNfZmlkKSk7CiAJbXV0ZXhfdW5sb2NrKCZ0Y29uLT5jcmZpZC5m
aWRfbXV0ZXgpOwogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCmluZGV4IDVhMTM2ODdiZjU0Ny4uMmRiZjZhYWQxMWRmIDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtNjAzLDYgKzYwMyw3IEBA
IHNtYjJfY2xvc2VfY2FjaGVkX2ZpZChzdHJ1Y3Qga3JlZiAqcmVmKQogCQkJICAgY2ZpZC0+Zmlk
LT52b2xhdGlsZV9maWQpOwogCQljZmlkLT5pc192YWxpZCA9IGZhbHNlOwogCQljZmlkLT5maWxl
X2FsbF9pbmZvX2lzX3ZhbGlkID0gZmFsc2U7CisJCWNmaWQtPmhhc19sZWFzZSA9IGZhbHNlOwog
CX0KIH0KIApAQCAtNjEzLDEzICs2MTQsMjggQEAgdm9pZCBjbG9zZV9zaHJvb3Qoc3RydWN0IGNh
Y2hlZF9maWQgKmNmaWQpCiAJbXV0ZXhfdW5sb2NrKCZjZmlkLT5maWRfbXV0ZXgpOwogfQogCit2
b2lkIGNsb3NlX3Nocm9vdF9sZWFzZV9sb2NrZWQoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQpCit7
CisJaWYgKGNmaWQtPmhhc19sZWFzZSkgeworCQljZmlkLT5oYXNfbGVhc2UgPSBmYWxzZTsKKwkJ
a3JlZl9wdXQoJmNmaWQtPnJlZmNvdW50LCBzbWIyX2Nsb3NlX2NhY2hlZF9maWQpOworCX0KK30K
Kwordm9pZCBjbG9zZV9zaHJvb3RfbGVhc2Uoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQpCit7CisJ
bXV0ZXhfbG9jaygmY2ZpZC0+ZmlkX211dGV4KTsKKwljbG9zZV9zaHJvb3RfbGVhc2VfbG9ja2Vk
KGNmaWQpOworCW11dGV4X3VubG9jaygmY2ZpZC0+ZmlkX211dGV4KTsKK30KKwogdm9pZAogc21i
Ml9jYWNoZWRfbGVhc2VfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogewogCXN0cnVj
dCBjYWNoZWRfZmlkICpjZmlkID0gY29udGFpbmVyX29mKHdvcmssCiAJCQkJc3RydWN0IGNhY2hl
ZF9maWQsIGxlYXNlX2JyZWFrKTsKIAotCWNsb3NlX3Nocm9vdChjZmlkKTsKKwljbG9zZV9zaHJv
b3RfbGVhc2UoY2ZpZCk7CiB9CiAKIC8qCkBAIC03NTQsNiArNzcwLDcgQEAgaW50IG9wZW5fc2hy
b290KHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVjdCBjaWZz
X2ZpZCAqcGZpZCkKIAkvKiBCQiBUQkQgY2hlY2sgdG8gc2VlIGlmIG9wbG9jayBsZXZlbCBjaGVj
ayBjYW4gYmUgcmVtb3ZlZCBiZWxvdyAqLwogCWlmIChvX3JzcC0+T3Bsb2NrTGV2ZWwgPT0gU01C
Ml9PUExPQ0tfTEVWRUxfTEVBU0UpIHsKIAkJa3JlZl9nZXQoJnRjb24tPmNyZmlkLnJlZmNvdW50
KTsKKwkJdGNvbi0+Y3JmaWQuaGFzX2xlYXNlID0gdHJ1ZTsKIAkJc21iMl9wYXJzZV9jb250ZXh0
cyhzZXJ2ZXIsIG9fcnNwLAogCQkJCSZvcGFybXMuZmlkLT5lcG9jaCwKIAkJCQlvcGFybXMuZmlk
LT5sZWFzZV9rZXksICZvcGxvY2ssIE5VTEwpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1
LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBmNGEwZjYzNDUzODYuLjYwZjk4YzJhM2YyMiAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAg
LTE4MDQsOCArMTgwNCw3IEBAIFNNQjJfdGRpcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uKQogCWlmICgodGNvbi0+bmVlZF9yZWNvbm5lY3QpIHx8ICh0Y29u
LT5zZXMtPm5lZWRfcmVjb25uZWN0KSkKIAkJcmV0dXJuIDA7CiAKLQlpZiAodGNvbi0+Y3JmaWQu
aXNfdmFsaWQpCi0JCWNsb3NlX3Nocm9vdCgmdGNvbi0+Y3JmaWQpOworCWNsb3NlX3Nocm9vdF9s
ZWFzZSgmdGNvbi0+Y3JmaWQpOwogCiAJcmMgPSBzbWIyX3BsYWluX3JlcV9pbml0KFNNQjJfVFJF
RV9ESVNDT05ORUNULCB0Y29uLCAodm9pZCAqKikgJnJlcSwKIAkJCSAgICAgJnRvdGFsX2xlbik7
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwcm90by5oIGIvZnMvY2lmcy9zbWIycHJvdG8uaApp
bmRleCBlMjM5Zjk4MDkzYTkuLjgyZjhkYWE4YzU5MCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIy
cHJvdG8uaAorKysgYi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC02OSw2ICs2OSw4IEBAIGV4dGVy
biBpbnQgc21iM19oYW5kbGVfcmVhZF9kYXRhKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZl
ciwKIGV4dGVybiBpbnQgb3Blbl9zaHJvb3QodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNf
dGNvbiAqdGNvbiwKIAkJCXN0cnVjdCBjaWZzX2ZpZCAqcGZpZCk7CiBleHRlcm4gdm9pZCBjbG9z
ZV9zaHJvb3Qoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQpOworZXh0ZXJuIHZvaWQgY2xvc2Vfc2hy
b290X2xlYXNlKHN0cnVjdCBjYWNoZWRfZmlkICpjZmlkKTsKK2V4dGVybiB2b2lkIGNsb3NlX3No
cm9vdF9sZWFzZV9sb2NrZWQoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQpOwogZXh0ZXJuIHZvaWQg
bW92ZV9zbWIyX2luZm9fdG9fY2lmcyhGSUxFX0FMTF9JTkZPICpkc3QsCiAJCQkJICAgc3RydWN0
IHNtYjJfZmlsZV9hbGxfaW5mbyAqc3JjKTsKIGV4dGVybiBpbnQgc21iMl9xdWVyeV9wYXRoX2lu
Zm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLS0gCjIu
MTcuMQoK
--0000000000004f5a4405995edee2--
