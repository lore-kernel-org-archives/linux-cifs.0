Return-Path: <SRS0=QLD2=UY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FD3C48BD6
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 17:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A6420883
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 17:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvbtrkwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfFYR6d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Jun 2019 13:58:33 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44976 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbfFYR6d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Jun 2019 13:58:33 -0400
Received: by mail-pl1-f180.google.com with SMTP id t7so9237064plr.11
        for <linux-cifs@vger.kernel.org>; Tue, 25 Jun 2019 10:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fk2TCyC1Su2g+PlRiHnA4v4ETNRXPwwBpn6gfZ+MrQM=;
        b=qvbtrkwUajIXAsxRCYahGNls5Pn+Ay4uv4LgXWYD+UglRY92UydxbUhOkCYDQHrbnC
         YwqLr/iSNAv64PSP5TRORICUD5MQ/ntQxDzSWj9juus6NKgM516nKl0XBiCzV4U3IM8y
         Smq3mCqj4Ne7R/SOSyEi6TjnfsWgWCoA14i5AshWDYUlSRm7S7XzOgSpk9PCTY4wCUWq
         3IvqyUyrCLnK5qedfm/u+gokktKXfmv7ejhN2XiBCtpRENOOdNoyPejQlxhj+O+sQla6
         2PPlmWqnGS7VjKLar3OvAofHy8/BnOPlDfZPz8LqyBYxaokkxD7rJwm663fz0qfxFfSF
         2CPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fk2TCyC1Su2g+PlRiHnA4v4ETNRXPwwBpn6gfZ+MrQM=;
        b=s8Wc9aNQP/w+MqhuJ6xxniiR8JmoviHyA+rxqykZ0V9E7KVRkA0fwyLTkHH5K9Z/Qz
         cEi8d1LJ45OD1zkKhzZB8ILaaTdyzopPR4c19gNhcXXQ+9Jc+QrSKUZS0QPPPc0r/KXm
         UjzI4G5f8+gibZi524qph3VqPc0Vv2WP3kYZ/X1fOje0g4Oz5GHRoo0lHYSOHAke7D/7
         eBOni39dQcr+ZmGooZ5bVQVpz1hkRyhtlysI5VgLPyAD1T7AVN4vtTOpu5pu1JPOJLr/
         wEcwyO4o9DC6QBJExKlmGjoBcXMxV3MT5ZAnQvBO4ryvn3A5B4slKKqscRyutsWnESBP
         hKMg==
X-Gm-Message-State: APjAAAV8W0SXEOCKt8IrdMKS4b/GIoQytXvxI4B0Usuxdhy43W19GbvC
        AEZlMrHM0dKGJw0dYeF0h+LoXq9vyNeBWqSlnszcvg==
X-Google-Smtp-Source: APXvYqymwY5qMiLtKGkGox4phRljRV9EzDECWfNSaEKFHntgdzYnUHhxb75q1DYb6et61WN6v09/tpriPCtlBPylWGE=
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr23507964plc.78.1561485512439;
 Tue, 25 Jun 2019 10:58:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 25 Jun 2019 12:58:21 -0500
Message-ID: <CAH2r5mukgyORXm93U0qEw06ox92+ObgO6u=U=66rLC4sfgR-0g@mail.gmail.com>
Subject: rebased part of multichannel patches
To:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="0000000000004aa0e2058c29adb6"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004aa0e2058c29adb6
Content-Type: text/plain; charset="UTF-8"

I rebased some of Aurelien's series (here is first patch in series
that deals with parsing his new mount options) ontop of current
for-next (not merged into for-next though - needs more testing etc.)



-- 
Thanks,

Steve

--0000000000004aa0e2058c29adb6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-mount-options-for-multichannel-support.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-mount-options-for-multichannel-support.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxc4530y0>
X-Attachment-Id: f_jxc4530y0

RnJvbSAzMGQzYzJmZjk5ZDkxNmU3ZGIyZjhmOTIxZGViZDliNzVmN2MyZDk3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpEYXRl
OiBUdWUsIDI1IEp1biAyMDE5IDEyOjUyOjI1IC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gc21iMzog
QWRkIG1vdW50IG9wdGlvbnMgZm9yIG11bHRpY2hhbm5lbCBzdXBwb3J0CgpBZGQgbW91bnQgb3B0
aW9uIHBhcnNpbmcgZm9yICJtdWx0aWNoYW5uZWwiIGFuZCAibWF4X2NoYW5uZWxzPSIKCkZvbGxv
d29uIHBhdGNoZXMgYWRkIGFkZGl0aW9uYWwgc3VwcG9ydCBmb3Igc2V0dGluZyB1cCBhbmQKdXNp
bmcgdGhlIGNoYW5uZWxzLgoKU2lnbmVkLW9mZi1ieTogQXVyZWxpZW4gQXB0ZWwgPGFhcHRlbEBz
dXNlLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvY2lmc2dsb2IuaCB8ICA1ICsrKysrCiBmcy9jaWZzL2Nvbm5lY3Qu
YyAgfCAyNiArKysrKysrKysrKysrKysrKysrKysrKystLQogMiBmaWxlcyBjaGFuZ2VkLCAyOSBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2ds
b2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCBkZDk5ZDAzMThiNzcuLmUwNmU1ZGQ4MDE5
MyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2Iu
aApAQCAtODYsNiArODYsOSBAQAogLyogbWF4aW11bSBudW1iZXIgb2YgUERVcyBpbiBvbmUgY29t
cG91bmQgKi8KICNkZWZpbmUgTUFYX0NPTVBPVU5EIDUKIAorLyogbWF4aW11bSBudW1iZXIgb2Yg
Y2hhbm5lbHMgKHNvY2tldCBjb25uZWN0aW9ucykgaW4gbXVsdGljaGFubmVsIHVzZSBjYXNlICov
CisjZGVmaW5lIENJRlNfTUFYX0NIQU5ORUxTIDE2CisKIC8qCiAgKiBEZWZhdWx0IG51bWJlciBv
ZiBjcmVkaXRzIHRvIGtlZXAgYXZhaWxhYmxlIGZvciBTTUIzLgogICogVGhpcyB2YWx1ZSBpcyBj
aG9zZW4gc29tZXdoYXQgYXJiaXRyYXJpbHkuIFRoZSBXaW5kb3dzIGNsaWVudApAQCAtNTg2LDYg
KzU4OSw3IEBAIHN0cnVjdCBzbWJfdm9sIHsKIAlib29sIHJlc2lsaWVudDoxOyAvKiBub3Jlc2ls
aWVudCBub3QgcmVxdWlyZWQgc2luY2Ugbm90IGZvcmVkIGZvciBDQSAqLwogCWJvb2wgZG9tYWlu
YXV0bzoxOwogCWJvb2wgcmRtYToxOworCWJvb2wgbXVsdGljaGFubmVsOjE7CiAJdW5zaWduZWQg
aW50IGJzaXplOwogCXVuc2lnbmVkIGludCByc2l6ZTsKIAl1bnNpZ25lZCBpbnQgd3NpemU7CkBA
IC02MDAsNiArNjA0LDcgQEAgc3RydWN0IHNtYl92b2wgewogCXVuc2lnbmVkIGludCBlY2hvX2lu
dGVydmFsOyAvKiBlY2hvIGludGVydmFsIGluIHNlY3MgKi8KIAlfX3U2NCBzbmFwc2hvdF90aW1l
OyAvKiBuZWVkZWQgZm9yIHRpbWV3YXJwIHRva2VucyAqLwogCV9fdTMyIGhhbmRsZV90aW1lb3V0
OyAvKiBwZXJzaXN0ZW50IGFuZCBkdXJhYmxlIGhhbmRsZSB0aW1lb3V0IGluIG1zICovCisJdW5z
aWduZWQgaW50IG1heF9jaGFubmVsczsKIAl1bnNpZ25lZCBpbnQgbWF4X2NyZWRpdHM7IC8qIHNt
YjMgbWF4X2NyZWRpdHMgMTAgPCBjcmVkaXRzIDwgNjAwMDAgKi8KIAlfX3UxNiBjb21wcmVzc2lv
bjsgLyogY29tcHJlc3Npb24gYWxnb3JpdGhtIDB4RkZGRiBkZWZhdWx0IDA9ZGlzYWJsZWQgKi8K
IH07CmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmlu
ZGV4IGRhODVhMjUxYTYwOS4uYTdjOGEwM2Y2MWQyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5l
Y3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtOTcsNyArOTcsNyBAQCBlbnVtIHsKIAlP
cHRfcGVyc2lzdGVudCwgT3B0X25vcGVyc2lzdGVudCwKIAlPcHRfcmVzaWxpZW50LCBPcHRfbm9y
ZXNpbGllbnQsCiAJT3B0X2RvbWFpbmF1dG8sIE9wdF9yZG1hLCBPcHRfbW9kZWFjZSwKLQlPcHRf
Y29tcHJlc3MsCisJT3B0X2NvbXByZXNzLCBPcHRfbXVsdGljaGFubmVsLCBPcHRfbm9tdWx0aWNo
YW5uZWwsCiAKIAkvKiBNb3VudCBvcHRpb25zIHdoaWNoIHRha2UgbnVtZXJpYyB2YWx1ZSAqLwog
CU9wdF9iYWNrdXB1aWQsIE9wdF9iYWNrdXBnaWQsIE9wdF91aWQsCkBAIC0xMDUsNyArMTA1LDcg
QEAgZW51bSB7CiAJT3B0X2Rpcm1vZGUsIE9wdF9wb3J0LAogCU9wdF9ibG9ja3NpemUsIE9wdF9y
c2l6ZSwgT3B0X3dzaXplLCBPcHRfYWN0aW1lbywKIAlPcHRfZWNob19pbnRlcnZhbCwgT3B0X21h
eF9jcmVkaXRzLCBPcHRfaGFuZGxldGltZW91dCwKLQlPcHRfc25hcHNob3QsCisJT3B0X3NuYXBz
aG90LCBPcHRfbWF4X2NoYW5uZWxzLAogCiAJLyogTW91bnQgb3B0aW9ucyB3aGljaCB0YWtlIHN0
cmluZyB2YWx1ZSAqLwogCU9wdF91c2VyLCBPcHRfcGFzcywgT3B0X2lwLApAQCAtMTk2LDYgKzE5
Niw4IEBAIHN0YXRpYyBjb25zdCBtYXRjaF90YWJsZV90IGNpZnNfbW91bnRfb3B0aW9uX3Rva2Vu
cyA9IHsKIAl7IE9wdF9ub3Jlc2lsaWVudCwgIm5vcmVzaWxpZW50aGFuZGxlcyJ9LAogCXsgT3B0
X2RvbWFpbmF1dG8sICJkb21haW5hdXRvIn0sCiAJeyBPcHRfcmRtYSwgInJkbWEifSwKKwl7IE9w
dF9tdWx0aWNoYW5uZWwsICJtdWx0aWNoYW5uZWwiIH0sCisJeyBPcHRfbm9tdWx0aWNoYW5uZWws
ICJub211bHRpY2hhbm5lbCIgfSwKIAogCXsgT3B0X2JhY2t1cHVpZCwgImJhY2t1cHVpZD0lcyIg
fSwKIAl7IE9wdF9iYWNrdXBnaWQsICJiYWNrdXBnaWQ9JXMiIH0sCkBAIC0yMTUsNiArMjE3LDcg
QEAgc3RhdGljIGNvbnN0IG1hdGNoX3RhYmxlX3QgY2lmc19tb3VudF9vcHRpb25fdG9rZW5zID0g
ewogCXsgT3B0X21heF9jcmVkaXRzLCAibWF4X2NyZWRpdHM9JXMiIH0sCiAJeyBPcHRfc25hcHNo
b3QsICJzbmFwc2hvdD0lcyIgfSwKIAl7IE9wdF9jb21wcmVzcywgImNvbXByZXNzPSVzIiB9LAor
CXsgT3B0X21heF9jaGFubmVscywgIm1heF9jaGFubmVscz0lcyIgfSwKIAogCXsgT3B0X2JsYW5r
X3VzZXIsICJ1c2VyPSIgfSwKIAl7IE9wdF9ibGFua191c2VyLCAidXNlcm5hbWU9IiB9LApAQCAt
MTYzNiw2ICsxNjM5LDEwIEBAIGNpZnNfcGFyc2VfbW91bnRfb3B0aW9ucyhjb25zdCBjaGFyICpt
b3VudGRhdGEsIGNvbnN0IGNoYXIgKmRldm5hbWUsCiAKIAl2b2wtPmVjaG9faW50ZXJ2YWwgPSBT
TUJfRUNIT19JTlRFUlZBTF9ERUZBVUxUOwogCisJLyogZGVmYXVsdCB0byBubyBtdWx0aWNoYW5u
ZWwgKHNpbmdsZSBzZXJ2ZXIgY29ubmVjdGlvbikgKi8KKwl2b2wtPm11bHRpY2hhbm5lbCA9IGZh
bHNlOworCXZvbC0+bWF4X2NoYW5uZWxzID0gMTsKKwogCWlmICghbW91bnRkYXRhKQogCQlnb3Rv
IGNpZnNfcGFyc2VfbW91bnRfZXJyOwogCkBAIC0xOTIyLDYgKzE5MjksMTIgQEAgY2lmc19wYXJz
ZV9tb3VudF9vcHRpb25zKGNvbnN0IGNoYXIgKm1vdW50ZGF0YSwgY29uc3QgY2hhciAqZGV2bmFt
ZSwKIAkJCWNpZnNfZGJnKFZGUywKIAkJCQkiU01CMyBjb21wcmVzc2lvbiBzdXBwb3J0IGlzIGV4
cGVyaW1lbnRhbFxuIik7CiAJCQlicmVhazsKKwkJY2FzZSBPcHRfbXVsdGljaGFubmVsOgorCQkJ
dm9sLT5tdWx0aWNoYW5uZWwgPSB0cnVlOworCQkJYnJlYWs7CisJCWNhc2UgT3B0X25vbXVsdGlj
aGFubmVsOgorCQkJdm9sLT5tdWx0aWNoYW5uZWwgPSBmYWxzZTsKKwkJCWJyZWFrOwogCiAJCS8q
IE51bWVyaWMgVmFsdWVzICovCiAJCWNhc2UgT3B0X2JhY2t1cHVpZDoKQEAgLTIwNzMsNiArMjA4
NiwxNSBAQCBjaWZzX3BhcnNlX21vdW50X29wdGlvbnMoY29uc3QgY2hhciAqbW91bnRkYXRhLCBj
b25zdCBjaGFyICpkZXZuYW1lLAogCQkJfQogCQkJdm9sLT5tYXhfY3JlZGl0cyA9IG9wdGlvbjsK
IAkJCWJyZWFrOworCQljYXNlIE9wdF9tYXhfY2hhbm5lbHM6CisJCQlpZiAoZ2V0X29wdGlvbl91
bChhcmdzLCAmb3B0aW9uKSB8fCBvcHRpb24gPCAxIHx8CisJCQkJb3B0aW9uID4gQ0lGU19NQVhf
Q0hBTk5FTFMpIHsKKwkJCQljaWZzX2RiZyhWRlMsICIlczogSW52YWxpZCBtYXhfY2hhbm5lbHMg
dmFsdWUsIG5lZWRzIHRvIGJlIDEtJWRcbiIsCisJCQkJCSBfX2Z1bmNfXywgQ0lGU19NQVhfQ0hB
Tk5FTFMpOworCQkJCWdvdG8gY2lmc19wYXJzZV9tb3VudF9lcnI7CisJCQl9CisJCQl2b2wtPm1h
eF9jaGFubmVscyA9IG9wdGlvbjsKKwkJCWJyZWFrOwogCiAJCS8qIFN0cmluZyBBcmd1bWVudHMg
Ki8KIAotLSAKMi4yMC4xCgo=
--0000000000004aa0e2058c29adb6--
