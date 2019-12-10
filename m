Return-Path: <SRS0=09eL=2A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CECAC43603
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Dec 2019 04:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0F71206E0
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Dec 2019 04:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P48L8SuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLJErO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Dec 2019 23:47:14 -0500
Received: from mail-il1-f175.google.com ([209.85.166.175]:45191 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfLJErO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Dec 2019 23:47:14 -0500
Received: by mail-il1-f175.google.com with SMTP id p8so14910666iln.12
        for <linux-cifs@vger.kernel.org>; Mon, 09 Dec 2019 20:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=l5k3tSvrzPlMHzPUGMTvQ4KRjgYVuYEZaaaA7axUuSo=;
        b=P48L8SuARty4OpEmtoJ7CI3z0GGWlMdEBgEXel4Kz0aYmlJ2+4RJhiMmd8LrP7Kloz
         P9r9/skplf7nkE3NdZJGdgikqpRnE7PzI5KJM1H2Sb2erTGWlO8zdfks+Ysp+Xlizphm
         cJz9R/n0GwtHz3OYtpMu30YReU+d7w39aEwwBh9GPLqAjoCFdEkDJUaj23J38xiq2HTw
         V3BqS6NtOPTtpel/NsDhh2AFyGLLTp9H29Wd1HLc47rUqgawezPQVxiROchjy85RBgYW
         H6Y0nSh1HxSkRMhazykN1qXQMzLQiSFCDw3gj9DEh6uFsARZGOVR3fl6FVbRuxcslzYJ
         8y6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=l5k3tSvrzPlMHzPUGMTvQ4KRjgYVuYEZaaaA7axUuSo=;
        b=TlSb5LLgS7QPLEHarCkmHEPogYc+ZGw1IV1JHqMpU7C6dEnnFPQ24mOvNNN5yUQC1k
         FcR2AZVfuT33tK02dsCf341haheOxVaFj1ZENYqeMJwgE07Lh5YM8hpXMAlaYPC6j3EW
         bndrccj3z4q2lB3ybyVCmAW8z0dlCjFJDl8/Y2QQCofZTv+QLk5s4Qi/by5lYtAl2Dwf
         vFsqRdLHsBeHiVY9NyXjAUbbaMcLDOX31JM7rkoT9RdNs0sgqeSLsBuea5E42pg8Lq/3
         Cg8dypKsueiBRvPvjHptGVEG6hDXxphfwVFiYGzj4eM0rrvec29p0ZdGtmH/xRRFL1oA
         5yzQ==
X-Gm-Message-State: APjAAAXCs17MxyO3sP/Ms4ed46tzLZLjWsZsjhGqTdM/qZQvAgQjrtX7
        JSwXrGnwi8nRujzCQ0V/KiPQVrdxgelKDgfxVgiyCB9H
X-Google-Smtp-Source: APXvYqwS797wuHDPMucTVMS5uFZjW4qjRjorojcnGYZ85IuMeWjA9aOWhBqtCkvvua9X8pWDgipE+0Yttvgzt6f8PmQ=
X-Received: by 2002:a92:3dd0:: with SMTP id k77mr31517339ilf.3.1575953233227;
 Mon, 09 Dec 2019 20:47:13 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 9 Dec 2019 22:47:02 -0600
Message-ID: <CAH2r5mtYvagfPDfZB3ru5X9O6vve9JGjuiwDKvxU6rN-iuo3-g@mail.gmail.com>
Subject: SMB3: Fix crash in SMB2_open_init due to uninitialized field in
 compounding path
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a65083059952341a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a65083059952341a
Content-Type: text/plain; charset="UTF-8"

    Ran into an intermittent crash in
            SMB2_open_init+0x2f6/0x970
    due to oparms.cifs_sb not being initialized when called from:
            smb2_compound_op+0x45d/0x1690
    Zero the whole oparms struct in the compounding path before setting up the
    oparms so we don't risk any uninitialized fields.

    Fixes: fdef665ba44a ("smb3: fix mode passed in on create for
modetosid mount option")


-- 
Thanks,

Steve

--000000000000a65083059952341a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Fix-crash-in-SMB2_open_init-due-to-uninitialize.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Fix-crash-in-SMB2_open_init-due-to-uninitialize.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k3zduuoz0>
X-Attachment-Id: f_k3zduuoz0

RnJvbSBkOTRhODhjMzY1Y2I1M2FlZTU2MGMwZGU3MTk0OGEyNThiZWVmZDVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgOSBEZWMgMjAxOSAyMjozNDoxMCAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBTTUIzOiBGaXggY3Jhc2ggaW4gU01CMl9vcGVuX2luaXQgZHVlIHRvIHVuaW5pdGlhbGl6ZWQK
IGZpZWxkIGluIGNvbXBvdW5kaW5nIHBhdGgKClJhbiBpbnRvIGFuIGludGVybWl0dGVudCBjcmFz
aCBpbgoJU01CMl9vcGVuX2luaXQrMHgyZjYvMHg5NzAKZHVlIHRvIG9wYXJtcy5jaWZzX3NiIG5v
dCBiZWluZyBpbml0aWFsaXplZCB3aGVuIGNhbGxlZCBmcm9tOgoJc21iMl9jb21wb3VuZF9vcCsw
eDQ1ZC8weDE2OTAKWmVybyB0aGUgd2hvbGUgb3Bhcm1zIHN0cnVjdCBpbiB0aGUgY29tcG91bmRp
bmcgcGF0aCBiZWZvcmUgc2V0dGluZyB1cCB0aGUKb3Bhcm1zIHNvIHdlIGRvbid0IHJpc2sgYW55
IHVuaW5pdGlhbGl6ZWQgZmllbGRzLgoKRml4ZXM6IGZkZWY2NjViYTQ0YSAoInNtYjM6IGZpeCBt
b2RlIHBhc3NlZCBpbiBvbiBjcmVhdGUgZm9yIG1vZGV0b3NpZCBtb3VudCBvcHRpb24iKQoKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpBY2tlZC1i
eTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgotLS0KIGZzL2NpZnMvc21i
Mmlub2RlLmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvc21iMmlub2RlLmMgYi9mcy9jaWZzL3NtYjJpbm9kZS5jCmluZGV4IDE4Yzdh
MzNhZGNlYi4uNWVmNWU5N2E2ZDEzIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJpbm9kZS5jCisr
KyBiL2ZzL2NpZnMvc21iMmlub2RlLmMKQEAgLTk1LDYgKzk1LDcgQEAgc21iMl9jb21wb3VuZF9v
cChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQlnb3Rv
IGZpbmlzaGVkOwogCX0KIAorCW1lbXNldCgmb3Bhcm1zLCAwLCBzaXplb2Yoc3RydWN0IGNpZnNf
b3Blbl9wYXJtcykpOwogCW9wYXJtcy50Y29uID0gdGNvbjsKIAlvcGFybXMuZGVzaXJlZF9hY2Nl
c3MgPSBkZXNpcmVkX2FjY2VzczsKIAlvcGFybXMuZGlzcG9zaXRpb24gPSBjcmVhdGVfZGlzcG9z
aXRpb247Ci0tIAoyLjIzLjAKCg==
--000000000000a65083059952341a--
