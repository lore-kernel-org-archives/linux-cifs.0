Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1810EC6FD1F
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Mar 2023 10:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjCPK6T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Mar 2023 06:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCPK6S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Mar 2023 06:58:18 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEBE1C309
        for <linux-cifs@vger.kernel.org>; Thu, 16 Mar 2023 03:58:09 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y20so1789680lfj.2
        for <linux-cifs@vger.kernel.org>; Thu, 16 Mar 2023 03:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678964287;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ10toemGBC5+3ANaCOIcU5tNyv4z65v0HLVMIcmza8=;
        b=QTLVPdWG9DFazfdZ7ALkKh2MsyQgS4fgRqHZAZJ1xKYxyFi62FziPrGBft1ICAWoMl
         rNAXNBZ38uvNJN4ZR1qIPc6qxFB0v8EZD3PxYhPrmiFEAmFWmfiBZGdB8ehiSZzYWdRN
         GI8PSLR/vcXuXK3sG0296YQNUkcDP6XHFwy3a2rTuhWwWJ86MCM3PAtgI3DiLz3lbyzU
         rSBi8JGp1Ca6hXWYGGwaLpElDS4jAL+zgpkKBeqvSl2QpHnvSrK5LEEEU8h4MK5hbX6+
         vAiUhoevex0gZxvtvbJcNPXdxT5TLegU31H+hlrvIJ7AA4KBv6JdYpBrAVcfoVsr9hxp
         4cMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678964287;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJ10toemGBC5+3ANaCOIcU5tNyv4z65v0HLVMIcmza8=;
        b=ZFPixTpZwlIukLovV0Aw8LbHvMaA38Qaa4sPqD4dxypHcfX1Zpo2+Uq9t4ip932h19
         rpQMCHVqGpuyNeQAshQWIhcVkrtkmE8gTgwdbECreF4BsjJjkS+pHKmFWmYwtdVP8N5R
         Qtwawjr7xlioLb0KM303KlF+RSmETGiM3ZtzPVRrqXW9pu7/ak6HdZ9viPav2/6FZg/h
         i/peT8Fa/cfrQ0VnVKaiU5zT/2BEMwsQnaULjfGN7kaS+ju9TRdJj3QFBzYXTbOLCHHj
         rtR8YiYWiWLNyXj2ACxgjD2KaT/DxBnmeaX1bV63weXAArHHoWN6oEwUvSBC/6gny0gC
         tSxQ==
X-Gm-Message-State: AO0yUKVOxelt9JOvCq92jEC5YIOGalYRcbGWolelwq/VTdmX8tkcKEv2
        ytnfgKuW+yiAnPV7ZetXBaWu0yPWY/lfpW4svQE=
X-Google-Smtp-Source: AK7set+YENp0pS8u16okZwCTAArEIo3KP8FqSqJPoHwyxjZ04eFQIWPlmBu4krvSQVhBU53gc3KZLAObaSFpnJHlG5c=
X-Received: by 2002:ac2:44a1:0:b0:4d9:861e:26cc with SMTP id
 c1-20020ac244a1000000b004d9861e26ccmr3038286lfm.4.1678964287146; Thu, 16 Mar
 2023 03:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <95f468756e26ebfb41f00b01f13d09da.pc.crab@mail.manguebit.com>
In-Reply-To: <95f468756e26ebfb41f00b01f13d09da.pc.crab@mail.manguebit.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 16 Mar 2023 16:27:55 +0530
Message-ID: <CANT5p=pfZNefhzGSytg9tuGXhNgvesVecTGoZFhWnUmnLxb-9g@mail.gmail.com>
Subject: Re: [PATCH 01/11] cifs: fix tcon status change after tree connect
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000ed360a05f70255ea"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ed360a05f70255ea
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 3:49=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Hi Shyam,
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > After cifs_tree_connect, tcon status should not be
> > set to TID_GOOD. There could still be files that need
> > reopen. The status should instead be changed to
> > TID_NEED_FILES_INVALIDATE. That way, after reopen of
> > files, the status can be changed to TID_GOOD.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/cifs/cifsglob.h |  2 +-
> >  fs/cifs/connect.c  | 14 ++++++++++----
> >  fs/cifs/dfs.c      | 16 +++++++++++-----
> >  fs/cifs/file.c     | 10 +++++-----
> >  4 files changed, 27 insertions(+), 15 deletions(-)
>
> With this patch, the status of TID_GOOD is no longer set after
> reconnecting tcons.  I've noticed that when the DFS cache refresher
> attempted to get a new referral for updating a cached entry but the IPC
> tcon status was still set to TID_NEED_FILES_INVALIDATE, therefore
> skipping the I/O as it thought the IPC tcon was disconnected.
>
> IOW, the TID_NEED_FILES_INVALIDATE status remains set for both types of
> tcons after reconnect.
>
> Besides, could you please split this patch into two?  The first one
> would fix the checking of tcon statuses by using the appropriate spin
> lock, and the second would make use of TID_NEED_FILES_INVALIDATE on
> non-IPC tcons and set the TID_GOOD status afterwards.
>
> Thanks.

Hi Paulo,

Good point. The tcon status were indeed messed up after this patch.
Should have checked it earlier. My bad.

Let me revert this one and include only the checking of tcon status
with the right lock.

Attached the patch for that.

--=20
Regards,
Shyam

--000000000000ed360a05f70255ea
Content-Type: application/octet-stream; 
	name="0001-cifs-check-only-tcon-status-on-tcon-related-function.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-check-only-tcon-status-on-tcon-related-function.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lfazxnns0>
X-Attachment-Id: f_lfazxnns0

RnJvbSBkNDFlODQxNzVkNzk1Njk0ODMyMGJhYjY0OGJjZWE2MjVjMzVmZDNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDE2IE1hciAyMDIzIDEwOjQ1OjEyICswMDAwClN1YmplY3Q6IFtQQVRDSCAw
MS8xM10gY2lmczogY2hlY2sgb25seSB0Y29uIHN0YXR1cyBvbiB0Y29uIHJlbGF0ZWQgZnVuY3Rp
b25zCgpXZSBoYWQgYSBjb3VwbGUgb2YgY2hlY2tzIGZvciBzZXNzaW9uIGluIGNpZnNfdHJlZV9j
b25uZWN0CmFuZCBjaWZzX21hcmtfb3Blbl9maWxlc19pbnZhbGlkLCB3aGljaCB3ZXJlIHVubmVj
ZXNzYXJ5LgpBbmQgdGhhdCB3YXMgZG9uZSB3aXRoIHNlc19sb2NrLiBDaGFuZ2VkIHRoYXQgdG8g
dGNfbG9jayB0b28uCgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgMTAgKysrKysrKy0tLQogZnMvY2lm
cy9kZnMuYyAgICAgfCAxMCArKysrKysrLS0tCiBmcy9jaWZzL2ZpbGUuYyAgICB8ICA4ICsrKyst
LS0tCiAzIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXgg
NTIzM2YxNGYwNjM2Li5lMjQ5ZjZmZWNkMjYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5j
CisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC00MDM4LDkgKzQwMzgsMTMgQEAgaW50IGNpZnNf
dHJlZV9jb25uZWN0KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24sIGNvbnN0IHN0cnUKIAogCS8qIG9ubHkgc2VuZCBvbmNlIHBlciBjb25uZWN0ICovCiAJc3Bp
bl9sb2NrKCZ0Y29uLT50Y19sb2NrKTsKLQlpZiAodGNvbi0+c2VzLT5zZXNfc3RhdHVzICE9IFNF
U19HT09EIHx8Ci0JICAgICh0Y29uLT5zdGF0dXMgIT0gVElEX05FVyAmJgotCSAgICB0Y29uLT5z
dGF0dXMgIT0gVElEX05FRURfVENPTikpIHsKKwlpZiAodGNvbi0+c3RhdHVzICE9IFRJRF9ORVcg
JiYKKwkgICAgdGNvbi0+c3RhdHVzICE9IFRJRF9ORUVEX1RDT04pIHsKKwkJc3Bpbl91bmxvY2so
JnRjb24tPnRjX2xvY2spOworCQlyZXR1cm4gLUVIT1NURE9XTjsKKwl9CisKKwlpZiAodGNvbi0+
c3RhdHVzID09IFRJRF9HT09EKSB7CiAJCXNwaW5fdW5sb2NrKCZ0Y29uLT50Y19sb2NrKTsKIAkJ
cmV0dXJuIDA7CiAJfQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9kZnMuYyBiL2ZzL2NpZnMvZGZzLmMK
aW5kZXggYjY0ZDIwMzc0YjljLi44M2JjN2UxNmYzYTMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZGZz
LmMKKysrIGIvZnMvY2lmcy9kZnMuYwpAQCAtNDc5LDkgKzQ3OSwxMyBAQCBpbnQgY2lmc190cmVl
X2Nvbm5lY3QoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwg
Y29uc3Qgc3RydQogCiAJLyogb25seSBzZW5kIG9uY2UgcGVyIGNvbm5lY3QgKi8KIAlzcGluX2xv
Y2soJnRjb24tPnRjX2xvY2spOwotCWlmICh0Y29uLT5zZXMtPnNlc19zdGF0dXMgIT0gU0VTX0dP
T0QgfHwKLQkgICAgKHRjb24tPnN0YXR1cyAhPSBUSURfTkVXICYmCi0JICAgIHRjb24tPnN0YXR1
cyAhPSBUSURfTkVFRF9UQ09OKSkgeworCWlmICh0Y29uLT5zdGF0dXMgIT0gVElEX05FVyAmJgor
CSAgICB0Y29uLT5zdGF0dXMgIT0gVElEX05FRURfVENPTikgeworCQlzcGluX3VubG9jaygmdGNv
bi0+dGNfbG9jayk7CisJCXJldHVybiAtRUhPU1RET1dOOworCX0KKworCWlmICh0Y29uLT5zdGF0
dXMgPT0gVElEX0dPT0QpIHsKIAkJc3Bpbl91bmxvY2soJnRjb24tPnRjX2xvY2spOwogCQlyZXR1
cm4gMDsKIAl9CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmlu
ZGV4IDRkNGEyZDgyNjM2ZC4uNjgzMWE5OTQ5YzQzIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUu
YworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtMTc0LDEzICsxNzQsMTMgQEAgY2lmc19tYXJrX29w
ZW5fZmlsZXNfaW52YWxpZChzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogCXN0cnVjdCBsaXN0X2hl
YWQgKnRtcDE7CiAKIAkvKiBvbmx5IHNlbmQgb25jZSBwZXIgY29ubmVjdCAqLwotCXNwaW5fbG9j
aygmdGNvbi0+c2VzLT5zZXNfbG9jayk7Ci0JaWYgKCh0Y29uLT5zZXMtPnNlc19zdGF0dXMgIT0g
U0VTX0dPT0QpIHx8ICh0Y29uLT5zdGF0dXMgIT0gVElEX05FRURfUkVDT04pKSB7Ci0JCXNwaW5f
dW5sb2NrKCZ0Y29uLT5zZXMtPnNlc19sb2NrKTsKKwlzcGluX2xvY2soJnRjb24tPnRjX2xvY2sp
OworCWlmICh0Y29uLT5zdGF0dXMgIT0gVElEX05FRURfUkVDT04pIHsKKwkJc3Bpbl91bmxvY2so
JnRjb24tPnRjX2xvY2spOwogCQlyZXR1cm47CiAJfQogCXRjb24tPnN0YXR1cyA9IFRJRF9JTl9G
SUxFU19JTlZBTElEQVRFOwotCXNwaW5fdW5sb2NrKCZ0Y29uLT5zZXMtPnNlc19sb2NrKTsKKwlz
cGluX3VubG9jaygmdGNvbi0+dGNfbG9jayk7CiAKIAkvKiBsaXN0IGFsbCBmaWxlcyBvcGVuIG9u
IHRyZWUgY29ubmVjdGlvbiBhbmQgbWFyayB0aGVtIGludmFsaWQgKi8KIAlzcGluX2xvY2soJnRj
b24tPm9wZW5fZmlsZV9sb2NrKTsKLS0gCjIuMzQuMQoK
--000000000000ed360a05f70255ea--
