Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0CFC6FD1C
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 21:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCWVbD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjCWVbC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 17:31:02 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367ACEB70
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 14:30:58 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id e21so11385837ljn.7
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 14:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679607056;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oISTXFZRGS8O0K5O1KFmjjpiAApQuvt3L6TJvmx2xfc=;
        b=P6oIa9TvPyaiA7MJLG136gT28sHQ1Drpwi+VWLHlExzqjVcdoAhXl8SPfW1xZqDx3G
         EM225vMC1IwjlkxMgAaMB1kphxnTxIIfvWag99xV4kOjtGe9zFwfzfLud8EVW1hEjKKB
         hrlhQZOuCrhxtX4NaCwmoerlldxlwbCJABsKncb8LBR4OyK55PSg/G4pex20yxgbitzE
         w57kxsM3wSoX00ABCLt0nv7TfVOl4eWKy/guL81g2KUmTQGNIfv+Kw/Ut2qAywQ4p68s
         L/amcJxzr9IYobgVvTEdqEBZsT+8QZ7L3inCt8ZHGEiZo3Vth8BuhQ76Wn3x7WTIQlHu
         f46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679607056;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oISTXFZRGS8O0K5O1KFmjjpiAApQuvt3L6TJvmx2xfc=;
        b=FGsKhdKkzqYKJFlsQ9MsHWs+oFIFBrMfIC4+rqKy+/HjcAVj5Dz+q2gCTM2bu0Czn/
         7OQEEXyxYhqk8+Exey5MQE3N4O/aM8WxMfPBewQqMVPF7Ys34I3IpPCSlTP6l7LUgXQJ
         qnEJ4ogumSAf4GKIwqsFrMRFgWPNpyNhkSbTvlmFFVlbttsfeWA2CGnjILvA3kIDscnW
         EFf8CsF6VyeUIvF2MPucmZgE1lqqsKXca3bUtmt0E0Bie1OMev10/5CspHbO3X6+b74V
         RDHMnC1oYjhAabYFT7gCCX+7NLYeiKy239kJMTWuHsOBVqIMG3Yf8HH6GddOU8lxeCB9
         l2Xw==
X-Gm-Message-State: AAQBX9fQEhFAoPq8XuxMbFA9/EQdioeDuALUDlb4o8XwZu8Aqv01QXbY
        ui6A5z24RgXFubPFqmDFyvItAX+jKjwHwcqyT9ELKDM1Jj4=
X-Google-Smtp-Source: AKy350YW6sA+Flj6kavTMIV18Am0Dwzhcxwh3XP7WUC6jYq6EqBVRjOczKm2jiNwuaBQT6ez0R+opvVTgUR7D0Ddz3Q=
X-Received: by 2002:a2e:930f:0:b0:293:2f6e:91bf with SMTP id
 e15-20020a2e930f000000b002932f6e91bfmr201162ljh.7.1679607055938; Thu, 23 Mar
 2023 14:30:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Mar 2023 16:30:44 -0500
Message-ID: <CAH2r5mvJvJdo61-qQ6GjCw_NBL7ZM6dx-9SaacaKpRb0rgGpFQ@mail.gmail.com>
Subject: [PATCH] smb3: fix unusable share after force unmount failure
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ee99d005f797fd73"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ee99d005f797fd73
Content-Type: text/plain; charset="UTF-8"

If user does forced unmount ("umount -f") while files are still open
on the share (as was seen in a Kubernetes example running on SMB3.1.1
mount) then we were marking the share as "TID_EXITING" in umount_begin()
which caused all subsequent operations (except write) to fail ... but
unfortunately when umount_begin() is called we do not know yet that
there are open files or active references on the share that would prevent
unmount from succeeding.  Kubernetes had example when they were doing
umount -f when files were open which caused the share to become
unusable until the files were closed (and the umount retried).

Fix this so that TID_EXITING is not set until we are about to send
the tree disconnect (not at the beginning of forced umounts in
umount_begin) so that if "umount -f" fails (due to open files or
references) the mount is still usable.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>



-- 
Thanks,

Steve

--000000000000ee99d005f797fd73
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-unusable-share-after-force-unmount-failure.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-unusable-share-after-force-unmount-failure.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lflmnz3h0>
X-Attachment-Id: f_lflmnz3h0

RnJvbSBlZDU1ZGYwZGE3NDdhYmRjMWRiNzVmZWY4YmFmM2IwY2FjMmMyZGU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjMgTWFyIDIwMjMgMTY6MjA6MDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggdW51c2FibGUgc2hhcmUgYWZ0ZXIgZm9yY2UgdW5tb3VudCBmYWlsdXJlCgpJZiB1
c2VyIGRvZXMgZm9yY2VkIHVubW91bnQgKCJ1bW91bnQgLWYiKSB3aGlsZSBmaWxlcyBhcmUgc3Rp
bGwgb3BlbgpvbiB0aGUgc2hhcmUgKGFzIHdhcyBzZWVuIGluIGEgS3ViZXJuZXRlcyBleGFtcGxl
IHJ1bm5pbmcgb24gU01CMy4xLjEKbW91bnQpIHRoZW4gd2Ugd2VyZSBtYXJraW5nIHRoZSBzaGFy
ZSBhcyAiVElEX0VYSVRJTkciIGluIHVtb3VudF9iZWdpbigpCndoaWNoIGNhdXNlZCBhbGwgc3Vi
c2VxdWVudCBvcGVyYXRpb25zIChleGNlcHQgd3JpdGUpIHRvIGZhaWwgLi4uIGJ1dAp1bmZvcnR1
bmF0ZWx5IHdoZW4gdW1vdW50X2JlZ2luKCkgaXMgY2FsbGVkIHdlIGRvIG5vdCBrbm93IHlldCB0
aGF0CnRoZXJlIGFyZSBvcGVuIGZpbGVzIG9yIGFjdGl2ZSByZWZlcmVuY2VzIG9uIHRoZSBzaGFy
ZSB0aGF0IHdvdWxkIHByZXZlbnQKdW5tb3VudCBmcm9tIHN1Y2NlZWRpbmcuICBLdWJlcm5ldGVz
IGhhZCBleGFtcGxlIHdoZW4gdGhleSB3ZXJlIGRvaW5nCnVtb3VudCAtZiB3aGVuIGZpbGVzIHdl
cmUgb3BlbiB3aGljaCBjYXVzZWQgdGhlIHNoYXJlIHRvIGJlY29tZQp1bnVzYWJsZSB1bnRpbCB0
aGUgZmlsZXMgd2VyZSBjbG9zZWQgKGFuZCB0aGUgdW1vdW50IHJldHJpZWQpLgoKRml4IHRoaXMg
c28gdGhhdCBUSURfRVhJVElORyBpcyBub3Qgc2V0IHVudGlsIHdlIGFyZSBhYm91dCB0byBzZW5k
CnRoZSB0cmVlIGRpc2Nvbm5lY3QgKG5vdCBhdCB0aGUgYmVnaW5uaW5nIG9mIGZvcmNlZCB1bW91
bnRzIGluCnVtb3VudF9iZWdpbikgc28gdGhhdCBpZiAidW1vdW50IC1mIiBmYWlscyAoZHVlIHRv
IG9wZW4gZmlsZXMgb3IKcmVmZXJlbmNlcykgdGhlIG1vdW50IGlzIHN0aWxsIHVzYWJsZS4KCkNj
OiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3Rm
cmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5jICB8IDkgKysrKysrLS0t
CiBmcy9jaWZzL2NpZnNzbWIuYyB8IDYgKystLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDQgKysr
LQogZnMvY2lmcy9zbWIycGR1LmMgfCA4ICsrLS0tLS0tCiA0IGZpbGVzIGNoYW5nZWQsIDEzIGlu
c2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2Zz
LmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IGNiY2YyMTBkNTZlNC4uYWM5MDM0ZmNlNDA5IDEw
MDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMKQEAgLTcz
MSwxMyArNzMxLDE2IEBAIHN0YXRpYyB2b2lkIGNpZnNfdW1vdW50X2JlZ2luKHN0cnVjdCBzdXBl
cl9ibG9jayAqc2IpCiAJc3Bpbl9sb2NrKCZ0Y29uLT50Y19sb2NrKTsKIAlpZiAoKHRjb24tPnRj
X2NvdW50ID4gMSkgfHwgKHRjb24tPnN0YXR1cyA9PSBUSURfRVhJVElORykpIHsKIAkJLyogd2Ug
aGF2ZSBvdGhlciBtb3VudHMgdG8gc2FtZSBzaGFyZSBvciB3ZSBoYXZlCi0JCSAgIGFscmVhZHkg
dHJpZWQgdG8gZm9yY2UgdW1vdW50IHRoaXMgYW5kIHdva2VuIHVwCisJCSAgIGFscmVhZHkgdHJp
ZWQgdG8gdW1vdW50IHRoaXMgYW5kIHdva2VuIHVwCiAJCSAgIGFsbCB3YWl0aW5nIG5ldHdvcmsg
cmVxdWVzdHMsIG5vdGhpbmcgdG8gZG8gKi8KIAkJc3Bpbl91bmxvY2soJnRjb24tPnRjX2xvY2sp
OwogCQlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCQlyZXR1cm47Ci0JfSBlbHNl
IGlmICh0Y29uLT50Y19jb3VudCA9PSAxKQotCQl0Y29uLT5zdGF0dXMgPSBUSURfRVhJVElORzsK
Kwl9CisJLyoKKwkgKiBjYW4gbm90IHNldCB0Y29uLT5zdGF0dXMgdG8gVElEX0VYSVRJTkcgeWV0
IHNpbmNlIHdlIGRvbid0IGtub3cgaWYgdW1vdW50IC1mIHdpbGwKKwkgKiBmYWlsIGxhdGVyIChl
LmcuIGR1ZSB0byBvcGVuIGZpbGVzKS4gIFRJRF9FWElUSU5HIHdpbGwgYmUgc2V0IGp1c3QgYmVm
b3JlIHRkaXMgcmVxIHNlbnQKKwkgKi8KIAlzcGluX3VubG9jaygmdGNvbi0+dGNfbG9jayk7CiAJ
c3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9j
aWZzc21iLmMgYi9mcy9jaWZzL2NpZnNzbWIuYwppbmRleCBhNDNjNzgzOTZkZDguLjM4YTY5N2Vj
YTMwNSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzc21iLmMKKysrIGIvZnMvY2lmcy9jaWZzc21i
LmMKQEAgLTg2LDEzICs4NiwxMSBAQCBjaWZzX3JlY29ubmVjdF90Y29uKHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sIGludCBzbWJfY29tbWFuZCkKIAogCS8qCiAJICogb25seSB0cmVlIGRpc2Nvbm5l
Y3QsIG9wZW4sIGFuZCB3cml0ZSwgKGFuZCB1bG9nb2ZmIHdoaWNoIGRvZXMgbm90Ci0JICogaGF2
ZSB0Y29uKSBhcmUgYWxsb3dlZCBhcyB3ZSBzdGFydCBmb3JjZSB1bW91bnQKKwkgKiBoYXZlIHRj
b24pIGFyZSBhbGxvd2VkIGFzIHdlIHN0YXJ0IHVtb3VudAogCSAqLwogCXNwaW5fbG9jaygmdGNv
bi0+dGNfbG9jayk7CiAJaWYgKHRjb24tPnN0YXR1cyA9PSBUSURfRVhJVElORykgewotCQlpZiAo
c21iX2NvbW1hbmQgIT0gU01CX0NPTV9XUklURV9BTkRYICYmCi0JCSAgICBzbWJfY29tbWFuZCAh
PSBTTUJfQ09NX09QRU5fQU5EWCAmJgotCQkgICAgc21iX2NvbW1hbmQgIT0gU01CX0NPTV9UUkVF
X0RJU0NPTk5FQ1QpIHsKKwkJaWYgKHNtYl9jb21tYW5kICE9IFNNQl9DT01fVFJFRV9ESVNDT05O
RUNUKSB7CiAJCQlzcGluX3VubG9jaygmdGNvbi0+dGNfbG9jayk7CiAJCQljaWZzX2RiZyhGWUks
ICJjYW4gbm90IHNlbmQgY21kICVkIHdoaWxlIHVtb3VudGluZ1xuIiwKIAkJCQkgc21iX2NvbW1h
bmQpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwpp
bmRleCBjMzE2MmVmOWM5ZTkuLjRjM2Q0ZDQwMDJiOSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25u
ZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTIzNDEsOCArMjM0MSwxMCBAQCBjaWZz
X3B1dF90Y29uKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiAJfQogCiAJeGlkID0gZ2V0X3hpZCgp
OwotCWlmIChzZXMtPnNlcnZlci0+b3BzLT50cmVlX2Rpc2Nvbm5lY3QpCisJaWYgKHNlcy0+c2Vy
dmVyLT5vcHMtPnRyZWVfZGlzY29ubmVjdCkgeworCQl0Y29uLT5zdGF0dXMgPSBUSURfRVhJVElO
RzsKIAkJc2VzLT5zZXJ2ZXItPm9wcy0+dHJlZV9kaXNjb25uZWN0KHhpZCwgdGNvbik7CisJfQog
CV9mcmVlX3hpZCh4aWQpOwogCiAJY2lmc19mc2NhY2hlX3JlbGVhc2Vfc3VwZXJfY29va2llKHRj
b24pOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwpp
bmRleCBhOWZiOTViN2VmODIuLjQxYjlmNDFhNzUwNSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIy
cGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTE2NSwxMyArMTY1LDkgQEAgc21iMl9y
ZWNvbm5lY3QoX19sZTE2IHNtYjJfY29tbWFuZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlz
cGluX2xvY2soJnRjb24tPnRjX2xvY2spOwogCWlmICh0Y29uLT5zdGF0dXMgPT0gVElEX0VYSVRJ
TkcpIHsKIAkJLyoKLQkJICogb25seSB0cmVlIGRpc2Nvbm5lY3QsIG9wZW4sIGFuZCB3cml0ZSwK
LQkJICogKGFuZCB1bG9nb2ZmIHdoaWNoIGRvZXMgbm90IGhhdmUgdGNvbikKLQkJICogYXJlIGFs
bG93ZWQgYXMgd2Ugc3RhcnQgZm9yY2UgdW1vdW50LgorCQkgKiBvbmx5IHRyZWUgZGlzY29ubmVj
dCBhbGxvd2VkIHdoZW4gZGlzY29ubmVjdGluZyAuLi4KIAkJICovCi0JCWlmICgoc21iMl9jb21t
YW5kICE9IFNNQjJfV1JJVEUpICYmCi0JCSAgIChzbWIyX2NvbW1hbmQgIT0gU01CMl9DUkVBVEUp
ICYmCi0JCSAgIChzbWIyX2NvbW1hbmQgIT0gU01CMl9UUkVFX0RJU0NPTk5FQ1QpKSB7CisJCWlm
IChzbWIyX2NvbW1hbmQgIT0gU01CMl9UUkVFX0RJU0NPTk5FQ1QpIHsKIAkJCXNwaW5fdW5sb2Nr
KCZ0Y29uLT50Y19sb2NrKTsKIAkJCWNpZnNfZGJnKEZZSSwgImNhbiBub3Qgc2VuZCBjbWQgJWQg
d2hpbGUgdW1vdW50aW5nXG4iLAogCQkJCSBzbWIyX2NvbW1hbmQpOwotLSAKMi4zNC4xCgo=
--000000000000ee99d005f797fd73--
