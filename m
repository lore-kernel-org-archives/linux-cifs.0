Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E32C74A5B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 10:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCQKse (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 06:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQKsd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 06:48:33 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6871EB77B
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 03:48:32 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t11so5950359lfr.1
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 03:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679050110;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AyNvMLc7eYOPjl4W5OWdPnerL1yRFW6+/ryUvwBXvhE=;
        b=k4KQAtwbOnJPe/xBszn4l7tAvQTJeMj5eVk5nxta/uyTs80b0bCDvmbUwFNwmMDHKx
         9TcKGZ+lXM11YNOHsY4Xp8Fx6lzI7meE3+7U1WyRVvXMrmH45Ko8JPneeUiwQakWyQ3c
         89svoIT3q49NZoFzyroYW75x4qZl0hjy1U0iez+JRWTCq2StQaQ4BQX+PM0SPCYacBjX
         WpS6fjNZQzpqN9az+LiomaG030exIus9WCy7FOSorT5OnKbmBMY0QSiRW2CGRdH4qZYe
         fp/ojYKanDX3joLEkIYEX/wUXZJjlFm0Z/tu1i8FJo7hDrRQpKFl71Gn4rs1kB1wIdd5
         Ff9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679050110;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AyNvMLc7eYOPjl4W5OWdPnerL1yRFW6+/ryUvwBXvhE=;
        b=dcJPeBVktBDbm6gj03ux8xssggHRHL3hzt1vcrpYsEE6XjxHN/j4L+lvptfAjFPDAY
         qos6Qi1s+kNAfP4t3h5Tj4K4lhAXuOZpoPS2DuKO/XdUTkvQ49SooLwBEhpXPhDCvh5m
         N9bS+ZV684fd4av+kTMT+60MEcPHY3g/oYIoRFwyfLdM+dIq7o38Xqr7msZdGq7FUfcM
         Z3KDJvXJR3npwy8fEnvyNuJxp7he81Ftmpt4Of5mIoGS6/pv8e4CnwW3mafs39ZSYucz
         XFOdwvD9sPyr8queWdFBT/3vXGk1ja/LzMD1TOPMqLkZX+3f8vDsUYQ6Srs57SdpguAf
         Pycg==
X-Gm-Message-State: AO0yUKWS1BZwDPkXWFy8zAFNFTTik2+KXA8yV4sySvTyjqGXqkfw5A0a
        eTOSXGi4/kBM41v8YxapzZNZ8slwCPNGNmEue6I=
X-Google-Smtp-Source: AK7set+VlQZZH9+7LMRW81XsI9MnXmHrcf1Uokt2k2siH3d8maKsCcavtSumLGUoRSAYF26uZbSJof19CVJu7JPdpLw=
X-Received: by 2002:ac2:5934:0:b0:4e9:717a:e60c with SMTP id
 v20-20020ac25934000000b004e9717ae60cmr327194lfi.1.1679050110455; Fri, 17 Mar
 2023 03:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <95f468756e26ebfb41f00b01f13d09da.pc.crab@mail.manguebit.com>
 <CANT5p=pfZNefhzGSytg9tuGXhNgvesVecTGoZFhWnUmnLxb-9g@mail.gmail.com> <ee7ad068976dcf1a7356fb6cd230fb69.pc@manguebit.com>
In-Reply-To: <ee7ad068976dcf1a7356fb6cd230fb69.pc@manguebit.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 17 Mar 2023 16:18:19 +0530
Message-ID: <CANT5p=qyFkJn0cCfiyJma3RFcmeBcjq4C4qDhw7CL8A+fiAUEQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] cifs: fix tcon status change after tree connect
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000064e69505f71651f3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000064e69505f71651f3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 2:29=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > On Wed, Mar 15, 2023 at 3:49=E2=80=AFAM Paulo Alcantara <pc@manguebit.c=
om> wrote:
> >> Shyam Prasad N <nspmangalore@gmail.com> writes:
> >>
> >> > After cifs_tree_connect, tcon status should not be
> >> > set to TID_GOOD. There could still be files that need
> >> > reopen. The status should instead be changed to
> >> > TID_NEED_FILES_INVALIDATE. That way, after reopen of
> >> > files, the status can be changed to TID_GOOD.
> >> >
> >> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >> > ---
> >> >  fs/cifs/cifsglob.h |  2 +-
> >> >  fs/cifs/connect.c  | 14 ++++++++++----
> >> >  fs/cifs/dfs.c      | 16 +++++++++++-----
> >> >  fs/cifs/file.c     | 10 +++++-----
> >> >  4 files changed, 27 insertions(+), 15 deletions(-)
> >>
> >> With this patch, the status of TID_GOOD is no longer set after
> >> reconnecting tcons.  I've noticed that when the DFS cache refresher
> >> attempted to get a new referral for updating a cached entry but the IP=
C
> >> tcon status was still set to TID_NEED_FILES_INVALIDATE, therefore
> >> skipping the I/O as it thought the IPC tcon was disconnected.
> >>
> >> IOW, the TID_NEED_FILES_INVALIDATE status remains set for both types o=
f
> >> tcons after reconnect.
> >>
> >> Besides, could you please split this patch into two?  The first one
> >> would fix the checking of tcon statuses by using the appropriate spin
> >> lock, and the second would make use of TID_NEED_FILES_INVALIDATE on
> >> non-IPC tcons and set the TID_GOOD status afterwards.
> >
> > Good point. The tcon status were indeed messed up after this patch.
> > Should have checked it earlier. My bad.
> >
> > Let me revert this one and include only the checking of tcon status
> > with the right lock.
> >
> > Attached the patch for that.
>
> Thanks for the patch!  Looks good to me.
>
> BTW, don't you think we need to get rid of unnecessary ses status check
> in __refresh_tcon() as well
>
>         ...
>         spin_lock(&ipc->tc_lock);
>         if (ses->ses_status !=3D SES_GOOD || ipc->status !=3D TID_GOOD) {

Good point.
Here's the updated patch.

--=20
Regards,
Shyam

--00000000000064e69505f71651f3
Content-Type: application/octet-stream; 
	name="0001-cifs-check-only-tcon-status-on-tcon-related-function.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-check-only-tcon-status-on-tcon-related-function.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lfcf2otd0>
X-Attachment-Id: f_lfcf2otd0

RnJvbSA3ODdmNGUyYWZkNTRjN2I1ODY1OTM5YjYxZjY2MTAyOWE0ZjVmNmI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDE2IE1hciAyMDIzIDEwOjQ1OjEyICswMDAwClN1YmplY3Q6IFtQQVRDSCAw
MS8xM10gY2lmczogY2hlY2sgb25seSB0Y29uIHN0YXR1cyBvbiB0Y29uIHJlbGF0ZWQgZnVuY3Rp
b25zCgpXZSBoYWQgYSBjb3VwbGUgb2YgY2hlY2tzIGZvciBzZXNzaW9uIGluIGNpZnNfdHJlZV9j
b25uZWN0CmFuZCBjaWZzX21hcmtfb3Blbl9maWxlc19pbnZhbGlkLCB3aGljaCB3ZXJlIHVubmVj
ZXNzYXJ5LgpBbmQgdGhhdCB3YXMgZG9uZSB3aXRoIHNlc19sb2NrLiBDaGFuZ2VkIHRoYXQgdG8g
dGNfbG9jayB0b28uCgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jICAgfCAxMCArKysrKysrLS0tCiBmcy9j
aWZzL2Rmcy5jICAgICAgIHwgMTAgKysrKysrKy0tLQogZnMvY2lmcy9kZnNfY2FjaGUuYyB8ICAy
ICstCiBmcy9jaWZzL2ZpbGUuYyAgICAgIHwgIDggKysrKy0tLS0KIDQgZmlsZXMgY2hhbmdlZCwg
MTkgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9j
b25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCA1MjMzZjE0ZjA2MzYuLmUyNDlmNmZl
Y2QyNiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0
LmMKQEAgLTQwMzgsOSArNDAzOCwxMyBAQCBpbnQgY2lmc190cmVlX2Nvbm5lY3QoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgY29uc3Qgc3RydQogCiAJLyog
b25seSBzZW5kIG9uY2UgcGVyIGNvbm5lY3QgKi8KIAlzcGluX2xvY2soJnRjb24tPnRjX2xvY2sp
OwotCWlmICh0Y29uLT5zZXMtPnNlc19zdGF0dXMgIT0gU0VTX0dPT0QgfHwKLQkgICAgKHRjb24t
PnN0YXR1cyAhPSBUSURfTkVXICYmCi0JICAgIHRjb24tPnN0YXR1cyAhPSBUSURfTkVFRF9UQ09O
KSkgeworCWlmICh0Y29uLT5zdGF0dXMgIT0gVElEX05FVyAmJgorCSAgICB0Y29uLT5zdGF0dXMg
IT0gVElEX05FRURfVENPTikgeworCQlzcGluX3VubG9jaygmdGNvbi0+dGNfbG9jayk7CisJCXJl
dHVybiAtRUhPU1RET1dOOworCX0KKworCWlmICh0Y29uLT5zdGF0dXMgPT0gVElEX0dPT0QpIHsK
IAkJc3Bpbl91bmxvY2soJnRjb24tPnRjX2xvY2spOwogCQlyZXR1cm4gMDsKIAl9CmRpZmYgLS1n
aXQgYS9mcy9jaWZzL2Rmcy5jIGIvZnMvY2lmcy9kZnMuYwppbmRleCBiNjRkMjAzNzRiOWMuLjgz
YmM3ZTE2ZjNhMyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9kZnMuYworKysgYi9mcy9jaWZzL2Rmcy5j
CkBAIC00NzksOSArNDc5LDEzIEBAIGludCBjaWZzX3RyZWVfY29ubmVjdChjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBjb25zdCBzdHJ1CiAKIAkvKiBvbmx5
IHNlbmQgb25jZSBwZXIgY29ubmVjdCAqLwogCXNwaW5fbG9jaygmdGNvbi0+dGNfbG9jayk7Ci0J
aWYgKHRjb24tPnNlcy0+c2VzX3N0YXR1cyAhPSBTRVNfR09PRCB8fAotCSAgICAodGNvbi0+c3Rh
dHVzICE9IFRJRF9ORVcgJiYKLQkgICAgdGNvbi0+c3RhdHVzICE9IFRJRF9ORUVEX1RDT04pKSB7
CisJaWYgKHRjb24tPnN0YXR1cyAhPSBUSURfTkVXICYmCisJICAgIHRjb24tPnN0YXR1cyAhPSBU
SURfTkVFRF9UQ09OKSB7CisJCXNwaW5fdW5sb2NrKCZ0Y29uLT50Y19sb2NrKTsKKwkJcmV0dXJu
IC1FSE9TVERPV047CisJfQorCisJaWYgKHRjb24tPnN0YXR1cyA9PSBUSURfR09PRCkgewogCQlz
cGluX3VubG9jaygmdGNvbi0+dGNfbG9jayk7CiAJCXJldHVybiAwOwogCX0KZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvZGZzX2NhY2hlLmMgYi9mcy9jaWZzL2Rmc19jYWNoZS5jCmluZGV4IGFjODZiZDBl
YmQ2My4uYTAzZDAyMDk3MjBlIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Rmc19jYWNoZS5jCisrKyBi
L2ZzL2NpZnMvZGZzX2NhY2hlLmMKQEAgLTEzMjYsNyArMTMyNiw3IEBAIHN0YXRpYyBpbnQgX19y
ZWZyZXNoX3Rjb24oY29uc3QgY2hhciAqcGF0aCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgYm9v
bCBmb3JjZV9yCiAJfQogCiAJc3Bpbl9sb2NrKCZpcGMtPnRjX2xvY2spOwotCWlmIChzZXMtPnNl
c19zdGF0dXMgIT0gU0VTX0dPT0QgfHwgaXBjLT5zdGF0dXMgIT0gVElEX0dPT0QpIHsKKwlpZiAo
aXBjLT5zdGF0dXMgIT0gVElEX0dPT0QpIHsKIAkJc3Bpbl91bmxvY2soJmlwYy0+dGNfbG9jayk7
CiAJCWNpZnNfZGJnKEZZSSwgIiVzOiBza2lwIGNhY2hlIHJlZnJlc2ggZHVlIHRvIGRpc2Nvbm5l
Y3RlZCBpcGNcbiIsIF9fZnVuY19fKTsKIAkJZ290byBvdXQ7CmRpZmYgLS1naXQgYS9mcy9jaWZz
L2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IDRkNGEyZDgyNjM2ZC4uNjgzMWE5OTQ5YzQz
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtMTc0
LDEzICsxNzQsMTMgQEAgY2lmc19tYXJrX29wZW5fZmlsZXNfaW52YWxpZChzdHJ1Y3QgY2lmc190
Y29uICp0Y29uKQogCXN0cnVjdCBsaXN0X2hlYWQgKnRtcDE7CiAKIAkvKiBvbmx5IHNlbmQgb25j
ZSBwZXIgY29ubmVjdCAqLwotCXNwaW5fbG9jaygmdGNvbi0+c2VzLT5zZXNfbG9jayk7Ci0JaWYg
KCh0Y29uLT5zZXMtPnNlc19zdGF0dXMgIT0gU0VTX0dPT0QpIHx8ICh0Y29uLT5zdGF0dXMgIT0g
VElEX05FRURfUkVDT04pKSB7Ci0JCXNwaW5fdW5sb2NrKCZ0Y29uLT5zZXMtPnNlc19sb2NrKTsK
KwlzcGluX2xvY2soJnRjb24tPnRjX2xvY2spOworCWlmICh0Y29uLT5zdGF0dXMgIT0gVElEX05F
RURfUkVDT04pIHsKKwkJc3Bpbl91bmxvY2soJnRjb24tPnRjX2xvY2spOwogCQlyZXR1cm47CiAJ
fQogCXRjb24tPnN0YXR1cyA9IFRJRF9JTl9GSUxFU19JTlZBTElEQVRFOwotCXNwaW5fdW5sb2Nr
KCZ0Y29uLT5zZXMtPnNlc19sb2NrKTsKKwlzcGluX3VubG9jaygmdGNvbi0+dGNfbG9jayk7CiAK
IAkvKiBsaXN0IGFsbCBmaWxlcyBvcGVuIG9uIHRyZWUgY29ubmVjdGlvbiBhbmQgbWFyayB0aGVt
IGludmFsaWQgKi8KIAlzcGluX2xvY2soJnRjb24tPm9wZW5fZmlsZV9sb2NrKTsKLS0gCjIuMzQu
MQoK
--00000000000064e69505f71651f3--
