Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECF7C49EA6
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 20:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3A5613BD
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 20:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhFXUg3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhFXUg3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Jun 2021 16:36:29 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65ACC061574
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jun 2021 13:34:08 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id d13so9453901ljg.12
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jun 2021 13:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=LN6s2yCtRIeJn4no/JRinYyKm3zCu0o0ugOVBzFGoA0=;
        b=UxIOD131RIWKdcj6ufPWMTYHOxs8HMhJrEka4akD9UQlD9o4cG/lmzqfFVfHWlAz7d
         mX7az+ryIeeALXThh8Sk8j5XXFrkeP68iqIYLdPLkVSTpMAEkjti+fqKPkod6hIHzunJ
         ZIlsHC/k7oCbJTSkA6MLQTWy34G+6aEz0vYhpwatbdkhF4RFP4Vyc5eFRjHKIWj8sL8j
         /d3CnCM9A5aNyn2goIp9tzYlwCeZlWefaenbJfjDyWh3PcqBLCPJouh1K+Ncu9GujMWb
         Ma3crhqjwp7upBARu0PbU52xotRKysPbnaZI+4XOvLOSrazd0x6BZmg44F1ISYxP7WgS
         9CoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LN6s2yCtRIeJn4no/JRinYyKm3zCu0o0ugOVBzFGoA0=;
        b=Ziqyr4IDKpJpcuiQCAJO8Mz5LCqIbUeU54jeKhddqOxBCms1Ey2gA3gkEJ3S0pVcAE
         TLFADMEDFdVyJFuP9aVmdzuqj0q4JMjfquIvB9xqni6gLGL6uJgoBTeKUFVMoJ4s9yH2
         lg1/WYdwC2x5zW0hR28BU/dVDUsmEZ+puIJiavkQHZEEz9CFwZ1k2Ddv7xQf/62VbkFi
         aUeicmvlZLfcOAp16C5ciZ8VybdgLAL8mzhfRWyShajZU4tHGP8X5rnXRaqskKc7Sjdn
         VEvxMcqVdufDuLjiGC9tJ0LbCU+6LnzXU/XIVCt5mK7S1i7JYqotCtTF28ILaFH5ipqA
         Vx6w==
X-Gm-Message-State: AOAM530ByfaV0UyNl2dl+JAom0d0m03tUHYVs+NrjbcCjY3nejHi6UOP
        KfBfZgDl18dJQLgSUM0rU8piBFzw0VeiSmRi/YPvtweLSK8TuQ==
X-Google-Smtp-Source: ABdhPJz73wigHxHT8QKfOkmroZ0jsRrUTPdFhHKI5PKVObW5sbDuSJyTyeJqknYAHxha3r5bPyhOi/tlIC+gkq4b96c=
X-Received: by 2002:a2e:a234:: with SMTP id i20mr5386653ljm.272.1624566846730;
 Thu, 24 Jun 2021 13:34:06 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 24 Jun 2021 15:33:55 -0500
Message-ID: <CAH2r5muNO=LB=v6AuoSmqku_z+66-ZR89z7ZGfYXXJCeswGHeg@mail.gmail.com>
Subject: [PATCH][CIFS] fix missing spinlock around update to ses->status
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d05c9105c588f163"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d05c9105c588f163
Content-Type: text/plain; charset="UTF-8"

In the other places where we update ses->status we protect the
updates via GlobalMid_Lock. So to be consistent add the same
locking around it in cifs_put_smb_ses where it was missing.

Addresses-Coverity: 1268904 ("Data race condition")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsglob.h | 3 ++-
 fs/cifs/connect.c  | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 988346904fd0..fc6b08e5ebbc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -887,7 +887,7 @@ struct cifs_ses {
  struct mutex session_mutex;
  struct TCP_Server_Info *server; /* pointer to server info */
  int ses_count; /* reference counter */
- enum statusEnum status;
+ enum statusEnum status;  /* updates protected by GlobalMid_Lock */
  unsigned overrideSecFlg;  /* if non-zero override global sec flags */
  char *serverOS; /* name of operating system underlying server */
  char *serverNOS; /* name of network operating system of server */
@@ -1785,6 +1785,7 @@ require use of the stronger protocol */
  * list operations on pending_mid_q and oplockQ
  *      updates to XID counters, multiplex id  and SMB sequence numbers
  *      list operations on global DnotifyReqList
+ *      updates to ses->status
  *  tcp_ses_lock protects:
  * list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the tcon
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c8079376d294..5d269f583dac 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1598,9 +1598,12 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
  spin_unlock(&cifs_tcp_ses_lock);
  return;
  }
+ spin_unlock(&cifs_tcp_ses_lock);
+
+ spin_lock(&GlobalMid_Lock);
  if (ses->status == CifsGood)
  ses->status = CifsExiting;
- spin_unlock(&cifs_tcp_ses_lock);
+ spin_unlock(&GlobalMid_Lock);

  cifs_free_ipc(ses);


-- 
Thanks,

Steve

--000000000000d05c9105c588f163
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-missing-spinlock-around-update-to-ses-statu.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-missing-spinlock-around-update-to-ses-statu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqbd3lxr0>
X-Attachment-Id: f_kqbd3lxr0

RnJvbSA1OTEwNzFmYWIyMzJiY2RlMzU4NGFkMWZkMWVkMGY2ZmRjMmZjZGI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjQgSnVuIDIwMjEgMTU6Mjg6MDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggbWlzc2luZyBzcGlubG9jayBhcm91bmQgdXBkYXRlIHRvIHNlcy0+c3RhdHVzCgpJ
biB0aGUgb3RoZXIgcGxhY2VzIHdoZXJlIHdlIHVwZGF0ZSBzZXMtPnN0YXR1cyB3ZSBwcm90ZWN0
IHRoZQp1cGRhdGVzIHZpYSBHbG9iYWxNaWRfTG9jay4gU28gdG8gYmUgY29uc2lzdGVudCBhZGQg
dGhlIHNhbWUKbG9ja2luZyBhcm91bmQgaXQgaW4gY2lmc19wdXRfc21iX3NlcyB3aGVyZSBpdCB3
YXMgbWlzc2luZy4KCkFkZHJlc3Nlcy1Db3Zlcml0eTogMTI2ODkwNCAoIkRhdGEgcmFjZSBjb25k
aXRpb24iKQpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgMyArKy0KIGZzL2NpZnMvY29ubmVjdC5jICB8
IDUgKysrKy0KIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaApp
bmRleCA5ODgzNDY5MDRmZDAuLmZjNmIwOGU1ZWJiYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZz
Z2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtODg3LDcgKzg4Nyw3IEBAIHN0cnVj
dCBjaWZzX3NlcyB7CiAJc3RydWN0IG11dGV4IHNlc3Npb25fbXV0ZXg7CiAJc3RydWN0IFRDUF9T
ZXJ2ZXJfSW5mbyAqc2VydmVyOwkvKiBwb2ludGVyIHRvIHNlcnZlciBpbmZvICovCiAJaW50IHNl
c19jb3VudDsJCS8qIHJlZmVyZW5jZSBjb3VudGVyICovCi0JZW51bSBzdGF0dXNFbnVtIHN0YXR1
czsKKwllbnVtIHN0YXR1c0VudW0gc3RhdHVzOyAgLyogdXBkYXRlcyBwcm90ZWN0ZWQgYnkgR2xv
YmFsTWlkX0xvY2sgKi8KIAl1bnNpZ25lZCBvdmVycmlkZVNlY0ZsZzsgIC8qIGlmIG5vbi16ZXJv
IG92ZXJyaWRlIGdsb2JhbCBzZWMgZmxhZ3MgKi8KIAljaGFyICpzZXJ2ZXJPUzsJCS8qIG5hbWUg
b2Ygb3BlcmF0aW5nIHN5c3RlbSB1bmRlcmx5aW5nIHNlcnZlciAqLwogCWNoYXIgKnNlcnZlck5P
UzsJLyogbmFtZSBvZiBuZXR3b3JrIG9wZXJhdGluZyBzeXN0ZW0gb2Ygc2VydmVyICovCkBAIC0x
Nzg1LDYgKzE3ODUsNyBAQCByZXF1aXJlIHVzZSBvZiB0aGUgc3Ryb25nZXIgcHJvdG9jb2wgKi8K
ICAqCWxpc3Qgb3BlcmF0aW9ucyBvbiBwZW5kaW5nX21pZF9xIGFuZCBvcGxvY2tRCiAgKiAgICAg
IHVwZGF0ZXMgdG8gWElEIGNvdW50ZXJzLCBtdWx0aXBsZXggaWQgIGFuZCBTTUIgc2VxdWVuY2Ug
bnVtYmVycwogICogICAgICBsaXN0IG9wZXJhdGlvbnMgb24gZ2xvYmFsIERub3RpZnlSZXFMaXN0
CisgKiAgICAgIHVwZGF0ZXMgdG8gc2VzLT5zdGF0dXMKICAqICB0Y3Bfc2VzX2xvY2sgcHJvdGVj
dHM6CiAgKglsaXN0IG9wZXJhdGlvbnMgb24gdGNwIGFuZCBTTUIgc2Vzc2lvbiBsaXN0cwogICog
IHRjb24tPm9wZW5fZmlsZV9sb2NrIHByb3RlY3RzIHRoZSBsaXN0IG9mIG9wZW4gZmlsZXMgaGFu
Z2luZyBvZmYgdGhlIHRjb24KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lm
cy9jb25uZWN0LmMKaW5kZXggYzgwNzkzNzZkMjk0Li41ZDI2OWY1ODNkYWMgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0xNTk4LDkgKzE1
OTgsMTIgQEAgdm9pZCBjaWZzX3B1dF9zbWJfc2VzKHN0cnVjdCBjaWZzX3NlcyAqc2VzKQogCQlz
cGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCQlyZXR1cm47CiAJfQorCXNwaW5fdW5s
b2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisKKwlzcGluX2xvY2soJkdsb2JhbE1pZF9Mb2NrKTsK
IAlpZiAoc2VzLT5zdGF0dXMgPT0gQ2lmc0dvb2QpCiAJCXNlcy0+c3RhdHVzID0gQ2lmc0V4aXRp
bmc7Ci0Jc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKKwlzcGluX3VubG9jaygmR2xv
YmFsTWlkX0xvY2spOwogCiAJY2lmc19mcmVlX2lwYyhzZXMpOwogCi0tIAoyLjMwLjIKCg==
--000000000000d05c9105c588f163--
