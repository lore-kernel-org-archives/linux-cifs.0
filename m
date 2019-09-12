Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE54C49ED9
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 07:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74D4C208E4
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 07:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s0yooIyt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbfILHBy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 03:01:54 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:36611 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbfILHBx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 03:01:53 -0400
Received: by mail-io1-f47.google.com with SMTP id b136so52116040iof.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 00:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=aepvE8hpPRpuwHsacEjPJ7lLa7f3jhC67m+MevWusTg=;
        b=s0yooIytwvQTEdeWII19CSYL0weEWjJq70GNCRf1HOtbdx+LYI9xQ8xPkUJttKDOc9
         jzzAq6f6HHvJx7PKxFwNXj2i8iBP2zLCoJkc7BxeuQYSmiaI3t8QtS4pjuVKjaps9e93
         ESSyBtYIAtiZ8tGNeOBO3ksgr9t0Fbq7bgrdoufwXrjcVrdJWcEi3vmeTkb+ejxISYY2
         JX8H3xw0z0HlZg8tXcTyxM7x87JSuQAs5saCWCqM1mS6FyLEhz5jXG8Q8d3/paaKXd3I
         c0K+pCpy0MmIzAZw9m6p5EJp69DhjCzLFwbFfD5NbcvlzlAuXRFEkRaGf3Z3r28khCsR
         O92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aepvE8hpPRpuwHsacEjPJ7lLa7f3jhC67m+MevWusTg=;
        b=DwS2nJyE1DwoF+MrzaATPvBRCfqxRjXRVZMgxjL53goKkBgC2P1NnePlUIZ0e8VvoV
         Hb1fEPK9/S/TBbBa1yysqv7P8xFKt5SaZGuCYrm974X5aFGO3M4G3kCrMj2zfdvXcS8f
         ewXRNsaFsC0uXtbAJ7znQys3wgQdesmpSZH/myU8c4GhULR3i7wUDU7eX6IocerdOosq
         p13y2QKOkr3zzagkNNSC+3rcl/QKYi58QQsVEU6rmTxW5GJpu5PlpfYG9TnsLICklsit
         kF4ppN5DtcBu5dZHXCNhNv30P0O7TkUYux9ZgPyf+YbT/icQbZZ84Bgd5mXkI1vk/1qE
         dL2A==
X-Gm-Message-State: APjAAAWxAKJhWQgD4T0GLhgM9TpZVWNs2ftchHl9ldG3UZYVSqU5W49M
        DbpZRGOgg2eHasDJbNSbD898KmCyYeadLVehSKpKS2baHXo=
X-Google-Smtp-Source: APXvYqy9nX7wAlfRVGXSShHgTBGUZayIDcxmrGRfZro1/l8SIEez53oSoY4bUywXjHDzQhAQp7fDaEENjc7yADUqw7Q=
X-Received: by 2002:a02:608:: with SMTP id 8mr41807992jav.88.1568271711067;
 Thu, 12 Sep 2019 00:01:51 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 12 Sep 2019 02:01:36 -0500
Message-ID: <CAH2r5mtc2A-s1is6eZXZx5neDWZs_4aSW_Tx72PH8sBA4pmqhg@mail.gmail.com>
Subject: [PATCH][SMB3] allow disabling requesting of leases
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000407d57059255b605"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000407d57059255b605
Content-Type: text/plain; charset="UTF-8"

smb3: allow disabling requesting leases

In some cases to work around server bugs or performance
problems it can be helpful to be able to disable requesting
SMB2.1/SMB3 leases on a particular mount (not to all servers
and all shares we are mounted to). Add new mount parm
"nolease" which turns off requesting leases on directory
or file opens.  Currently the only way to disable leases is
globally through a module load parameter. This approach is more
granular (and easier for some) as Pavel had noted in a recent suggestion.

-- 
Thanks,

Steve

--000000000000407d57059255b605
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-disabling-requesting-leases.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-disabling-requesting-leases.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0gch4h00>
X-Attachment-Id: f_k0gch4h00

RnJvbSBkMzU5Mzc4ZTEwZWM4YjRlOTNjNTdiMTdmMTgzMDhkYjA5ZmJhNDUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTEgU2VwIDIwMTkgMjE6NDY6MjAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhbGxvdyBkaXNhYmxpbmcgcmVxdWVzdGluZyBsZWFzZXMKCkluIHNvbWUgY2FzZXMgdG8g
d29yayBhcm91bmQgc2VydmVyIGJ1Z3Mgb3IgcGVyZm9ybWFuY2UKcHJvYmxlbXMgaXQgY2FuIGJl
IGhlbHBmdWwgdG8gYmUgYWJsZSB0byBkaXNhYmxlIHJlcXVlc3RpbmcKU01CMi4xL1NNQjMgbGVh
c2VzIG9uIGEgcGFydGljdWxhciBtb3VudCAobm90IHRvIGFsbCBzZXJ2ZXJzCmFuZCBhbGwgc2hh
cmVzIHdlIGFyZSBtb3VudGVkIHRvKS4gQWRkIG5ldyBtb3VudCBwYXJtCiJub2xlYXNlIiB3aGlj
aCB0dXJucyBvZmYgcmVxdWVzdGluZyBsZWFzZXMgb24gZGlyZWN0b3J5Cm9yIGZpbGUgb3BlbnMu
ICBDdXJyZW50bHkgdGhlIG9ubHkgd2F5IHRvIGRpc2FibGUgbGVhc2VzIGlzCmdsb2JhbGx5IHRo
cm91Z2ggYSBtb2R1bGUgbG9hZCBwYXJhbWV0ZXIuIFRoaXMgaXMgbW9yZQpncmFudWxhci4KClN1
Z2dlc3RlZC1ieTogUGF2ZWwgU2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+ClNpZ25l
ZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9j
aWZzL2NpZnNmcy5jICAgfCAyICsrCiBmcy9jaWZzL2NpZnNnbG9iLmggfCAyICsrCiBmcy9jaWZz
L2Nvbm5lY3QuYyAgfCA5ICsrKysrKysrLQogZnMvY2lmcy9zbWIycGR1LmMgIHwgMiArLQogNCBm
aWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IGMxYjY4NTA3MjA2
My4uNjk2MDFhOWIyOWFkIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2Np
ZnMvY2lmc2ZzLmMKQEAgLTQzOCw2ICs0MzgsOCBAQCBjaWZzX3Nob3dfb3B0aW9ucyhzdHJ1Y3Qg
c2VxX2ZpbGUgKnMsIHN0cnVjdCBkZW50cnkgKnJvb3QpCiAJY2lmc19zaG93X3NlY3VyaXR5KHMs
IHRjb24tPnNlcyk7CiAJY2lmc19zaG93X2NhY2hlX2ZsYXZvcihzLCBjaWZzX3NiKTsKIAorCWlm
ICh0Y29uLT5ub19sZWFzZSkKKwkJc2VxX3B1dHMocywgIixub2xlYXNlIik7CiAJaWYgKGNpZnNf
c2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9NVUxUSVVTRVIpCiAJCXNlcV9wdXRzKHMs
ICIsbXVsdGl1c2VyIik7CiAJZWxzZSBpZiAodGNvbi0+c2VzLT51c2VyX25hbWUpCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggZWYyMTk5
OTEzMjE3Li4wOWI2MGVjNWRlM2UgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysg
Yi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAgLTU3OSw2ICs1NzksNyBAQCBzdHJ1Y3Qgc21iX3ZvbCB7
CiAJYm9vbCBub2Jsb2Nrc25kOjE7CiAJYm9vbCBub2F1dG90dW5lOjE7CiAJYm9vbCBub3N0cmlj
dHN5bmM6MTsgLyogZG8gbm90IGZvcmNlIGV4cGVuc2l2ZSBTTUJmbHVzaCBvbiBldmVyeSBzeW5j
ICovCisJYm9vbCBub19sZWFzZToxOyAgICAgLyogZGlzYWJsZSByZXF1ZXN0aW5nIGxlYXNlcyAq
LwogCWJvb2wgZnNjOjE7CS8qIGVuYWJsZSBmc2NhY2hlICovCiAJYm9vbCBtZnN5bWxpbmtzOjE7
IC8qIHVzZSBNaW5zaGFsbCtGcmVuY2ggU3ltbGlua3MgKi8KIAlib29sIG11bHRpdXNlcjoxOwpA
QCAtMTA5MCw2ICsxMDkxLDcgQEAgc3RydWN0IGNpZnNfdGNvbiB7CiAJYm9vbCBuZWVkX3Jlb3Bl
bl9maWxlczoxOyAvKiBuZWVkIHRvIHJlb3BlbiB0Y29uIGZpbGUgaGFuZGxlcyAqLwogCWJvb2wg
dXNlX3Jlc2lsaWVudDoxOyAvKiB1c2UgcmVzaWxpZW50IGluc3RlYWQgb2YgZHVyYWJsZSBoYW5k
bGVzICovCiAJYm9vbCB1c2VfcGVyc2lzdGVudDoxOyAvKiB1c2UgcGVyc2lzdGVudCBpbnN0ZWFk
IG9mIGR1cmFibGUgaGFuZGxlcyAqLworCWJvb2wgbm9fbGVhc2U6MTsgICAgLyogRG8gbm90IHJl
cXVlc3QgbGVhc2VzIG9uIGZpbGVzIG9yIGRpcmVjdG9yaWVzICovCiAJX19sZTMyIGNhcGFiaWxp
dGllczsKIAlfX3UzMiBzaGFyZV9mbGFnczsKIAlfX3UzMiBtYXhpbWFsX2FjY2VzczsKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggZGYxY2Ni
NTgxODI4Li5lMTZiNmNjMWUzMWIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBi
L2ZzL2NpZnMvY29ubmVjdC5jCkBAIC03NCw3ICs3NCw3IEBAIGVudW0gewogCU9wdF91c2VyX3hh
dHRyLCBPcHRfbm91c2VyX3hhdHRyLAogCU9wdF9mb3JjZXVpZCwgT3B0X25vZm9yY2V1aWQsCiAJ
T3B0X2ZvcmNlZ2lkLCBPcHRfbm9mb3JjZWdpZCwKLQlPcHRfbm9ibG9ja3NlbmQsIE9wdF9ub2F1
dG90dW5lLAorCU9wdF9ub2Jsb2Nrc2VuZCwgT3B0X25vYXV0b3R1bmUsIE9wdF9ub2xlYXNlLAog
CU9wdF9oYXJkLCBPcHRfc29mdCwgT3B0X3Blcm0sIE9wdF9ub3Blcm0sCiAJT3B0X21hcHBvc2l4
LCBPcHRfbm9tYXBwb3NpeCwKIAlPcHRfbWFwY2hhcnMsIE9wdF9ub21hcGNoYXJzLCBPcHRfc2Z1
LApAQCAtMTM1LDYgKzEzNSw3IEBAIHN0YXRpYyBjb25zdCBtYXRjaF90YWJsZV90IGNpZnNfbW91
bnRfb3B0aW9uX3Rva2VucyA9IHsKIAl7IE9wdF9ub2ZvcmNlZ2lkLCAibm9mb3JjZWdpZCIgfSwK
IAl7IE9wdF9ub2Jsb2Nrc2VuZCwgIm5vYmxvY2tzZW5kIiB9LAogCXsgT3B0X25vYXV0b3R1bmUs
ICJub2F1dG90dW5lIiB9LAorCXsgT3B0X25vbGVhc2UsICJub2xlYXNlIiB9LAogCXsgT3B0X2hh
cmQsICJoYXJkIiB9LAogCXsgT3B0X3NvZnQsICJzb2Z0IiB9LAogCXsgT3B0X3Blcm0sICJwZXJt
IiB9LApAQCAtMTczOCw2ICsxNzM5LDkgQEAgY2lmc19wYXJzZV9tb3VudF9vcHRpb25zKGNvbnN0
IGNoYXIgKm1vdW50ZGF0YSwgY29uc3QgY2hhciAqZGV2bmFtZSwKIAkJY2FzZSBPcHRfbm9hdXRv
dHVuZToKIAkJCXZvbC0+bm9hdXRvdHVuZSA9IDE7CiAJCQlicmVhazsKKwkJY2FzZSBPcHRfbm9s
ZWFzZToKKwkJCXZvbC0+bm9fbGVhc2UgPSAxOworCQkJYnJlYWs7CiAJCWNhc2UgT3B0X2hhcmQ6
CiAJCQl2b2wtPnJldHJ5ID0gMTsKIAkJCWJyZWFrOwpAQCAtMzI5NCw2ICszMjk4LDggQEAgc3Rh
dGljIGludCBtYXRjaF90Y29uKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHN0cnVjdCBzbWJfdm9s
ICp2b2x1bWVfaW5mbykKIAkJcmV0dXJuIDA7CiAJaWYgKHRjb24tPmhhbmRsZV90aW1lb3V0ICE9
IHZvbHVtZV9pbmZvLT5oYW5kbGVfdGltZW91dCkKIAkJcmV0dXJuIDA7CisJaWYgKHRjb24tPm5v
X2xlYXNlICE9IHZvbHVtZV9pbmZvLT5ub19sZWFzZSkKKwkJcmV0dXJuIDA7CiAJcmV0dXJuIDE7
CiB9CiAKQEAgLTM1MTYsNiArMzUyMiw3IEBAIGNpZnNfZ2V0X3Rjb24oc3RydWN0IGNpZnNfc2Vz
ICpzZXMsIHN0cnVjdCBzbWJfdm9sICp2b2x1bWVfaW5mbykKIAl0Y29uLT5ub2Nhc2UgPSB2b2x1
bWVfaW5mby0+bm9jYXNlOwogCXRjb24tPm5vaGFuZGxlY2FjaGUgPSB2b2x1bWVfaW5mby0+bm9o
YW5kbGVjYWNoZTsKIAl0Y29uLT5sb2NhbF9sZWFzZSA9IHZvbHVtZV9pbmZvLT5sb2NhbF9sZWFz
ZTsKKwl0Y29uLT5ub19sZWFzZSA9IHZvbHVtZV9pbmZvLT5ub19sZWFzZTsKIAlJTklUX0xJU1Rf
SEVBRCgmdGNvbi0+cGVuZGluZ19vcGVucyk7CiAKIAlzcGluX2xvY2soJmNpZnNfdGNwX3Nlc19s
b2NrKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMK
aW5kZXggMDFkNWM0YWYyNDU4Li5jZTY0N2NmZGMwNGYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21i
MnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0yNDU5LDcgKzI0NTksNyBAQCBTTUIy
X29wZW5faW5pdChzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3Qs
IF9fdTggKm9wbG9jaywKIAlpb3ZbMV0uaW92X2xlbiA9IHVuaV9wYXRoX2xlbjsKIAlpb3ZbMV0u
aW92X2Jhc2UgPSBwYXRoOwogCi0JaWYgKCFzZXJ2ZXItPm9wbG9ja3MpCisJaWYgKCghc2VydmVy
LT5vcGxvY2tzKSB8fCAodGNvbi0+bm9fbGVhc2UpKQogCQkqb3Bsb2NrID0gU01CMl9PUExPQ0tf
TEVWRUxfTk9ORTsKIAogCWlmICghKHNlcnZlci0+Y2FwYWJpbGl0aWVzICYgU01CMl9HTE9CQUxf
Q0FQX0xFQVNJTkcpIHx8Ci0tIAoyLjIwLjEKCg==
--000000000000407d57059255b605--
