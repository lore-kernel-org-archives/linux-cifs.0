Return-Path: <SRS0=oOOd=W6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F98C3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 23:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08DD021883
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 23:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBu0BbZ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfICXnu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 19:43:50 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:33429 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfICXnu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 19:43:50 -0400
Received: by mail-io1-f54.google.com with SMTP id m11so8083913ioo.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 16:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=eMI5R1XNLBGpqSIPvixX15Za/Km4574QwAhHM/+if6g=;
        b=tBu0BbZ9tQgby0lMxShBLpfp19wm9IX6o5tHDeWGY0EXNXEnuvn2pcSyjki1rQ5SOc
         rALZJF6yOW7EvSN7oh0BNC9yX+fRkMEZ3MOdSOK79PUoay3ViMVVOy/RQdYOEmT0TzvX
         vUsN0FlyIrz/CR8U0cBiJ2AaVi+/zYXsBUPn1EduOwj0mSZcpGepbJ8HgrpMbpDaGITo
         9p92UltmxoIJaqMO0oFmEQqr0ik3YDqq0G0MSSXGNXE1dnPfkfFtLeElogMPa1r5hknm
         ym2rW/UUwuFBIe10c3JDMWxh6quaQBWcLUMFOaEuT/kDkMHAzjSB7+Ya71YzQ0IqpoQY
         MbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eMI5R1XNLBGpqSIPvixX15Za/Km4574QwAhHM/+if6g=;
        b=BGPucHj0GKxR6ZGIhhTMGPaT7Clt94gKlOaXgbRQ7bhWJgC85JA2d2FHtbKM32m9Su
         dF3Vwtj9J4LQAG1RLxswI5m5guFA6g6V6jHzjVnXbp7txiYcZzOdkHoh+FM74qHAlc4c
         UYfUX0czqoigrt7ZSY5g/abWdkaDOcyVlw5TuJLSUtsVng9EI3+TdpOLtcHNlxKC8gxG
         qdYzDM8lKh3VwfT/VzgimlT2eQBeMn/0/K65BwaP5ZIhEKxpkQkQfwgHOxlqMnIGbsJc
         be/oCrAelVnVtjNRB0+Q0gt/5qB6xqkjDGWejFRiofoCwmyjgjLhq4s9/gfZoVITq+4+
         wvsw==
X-Gm-Message-State: APjAAAXkg2CSlBR4IB8ZkwB8PHXdR34bcYflwkdoeaO60nWETAlCyg3M
        wtoQiGNf7z1+3HY4q1sQSnovtDEeYnZuUC6r3w3dQGSTUk4=
X-Google-Smtp-Source: APXvYqzJpMp526oRErim1MRgt6o2MhZrTfYlqlJLbbHPYwL2QlWoo0XUZEg7PSnahIRyBWjdqLqeJLEfi37GW7NlMQo=
X-Received: by 2002:a5d:9c4c:: with SMTP id 12mr1378404iof.5.1567554229107;
 Tue, 03 Sep 2019 16:43:49 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 Sep 2019 18:43:37 -0500
Message-ID: <CAH2r5muz2=FgVGaZN-VfVYpai3x_SHm=GGR_OaM6c+YgP9d_Hg@mail.gmail.com>
Subject: [SMB3][PATCH] Add four more dynamic tracepoints
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000fe3ee00591aea8a0"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fe3ee00591aea8a0
Content-Type: text/plain; charset="UTF-8"

Add four more dynamic tracepoints (for flush enter and non-error exit,
and for close enter and non-error exit - we already had them for flush
error and close error). For example:

              cp-22823 [002] .... 123439.179701: smb3_enter:
_cifsFileInfo_put: xid=10
              cp-22823 [002] .... 123439.179705: smb3_close_enter:
xid=10 sid=0x98871327 tid=0xfcd585ff fid=0xc7f84682
              cp-22823 [002] .... 123439.179711: smb3_cmd_enter:
sid=0x98871327 tid=0xfcd585ff cmd=6 mid=43
              cp-22823 [002] .... 123439.180175: smb3_cmd_done:
sid=0x98871327 tid=0xfcd585ff cmd=6 mid=43
              cp-22823 [002] .... 123439.180179: smb3_close_done:
xid=10 sid=0x98871327 tid=0xfcd585ff fid=0xc7f84682

              dd-22981 [003] .... 123696.946011: smb3_flush_enter:
xid=24 sid=0x98871327 tid=0xfcd585ff fid=0x1917736f
              dd-22981 [003] .... 123696.946013: smb3_cmd_enter:
sid=0x98871327 tid=0xfcd585ff cmd=7 mid=123
              dd-22981 [003] .... 123696.956639: smb3_cmd_done:
sid=0x98871327 tid=0x0 cmd=7 mid=123
              dd-22981 [003] .... 123696.956644: smb3_flush_done:
xid=24 sid=0x98871327 tid=0xfcd585ff fid=0x1917736f


-- 
Thanks,

Steve

--000000000000fe3ee00591aea8a0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-tracepoints-for-flush-and-close.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-tracepoints-for-flush-and-close.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k04ha14o0>
X-Attachment-Id: f_k04ha14o0

RnJvbSBiMDY5Nzg4YTAzOTIwY2Q2MjEyYWM2NTZhMjg2NDU3MWYyY2MxYzdkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMyBTZXAgMjAxOSAxODozNTo0MiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFkZCBkeW5hbWljIHRyYWNlcG9pbnRzIGZvciBmbHVzaCBhbmQgY2xvc2UKCldlIG9ubHkg
aGFkIGR5bmFtaWMgdHJhY2Vwb2ludHMgb24gZXJyb3JzIGluIGZsdXNoCmFuZCBjbG9zZSwgYnV0
IG1heSBiZSBoZWxwZnVsIHRvIHRyYWNlIGVudGVyCmFuZCBub24tZXJyb3IgZXhpdHMgZm9yIHRo
b3NlLiAgU2FtcGxlIHRyYWNlIGV4YW1wbGVzCihleGNlcnB0cykgZnJvbSAiY3AiIGFuZCAiZGQi
IHNob3cgdHdvIG9mIHRoZSBuZXcKdHJhY2Vwb2ludHMuCgogIGNwLTIyODIzIFswMDJdIC4uLi4g
MTIzNDM5LjE3OTcwMTogc21iM19lbnRlcjogX2NpZnNGaWxlSW5mb19wdXQ6IHhpZD0xMAogIGNw
LTIyODIzIFswMDJdIC4uLi4gMTIzNDM5LjE3OTcwNTogc21iM19jbG9zZV9lbnRlcjogeGlkPTEw
IHNpZD0weDk4ODcxMzI3IHRpZD0weGZjZDU4NWZmIGZpZD0weGM3Zjg0NjgyCiAgY3AtMjI4MjMg
WzAwMl0gLi4uLiAxMjM0MzkuMTc5NzExOiBzbWIzX2NtZF9lbnRlcjogc2lkPTB4OTg4NzEzMjcg
dGlkPTB4ZmNkNTg1ZmYgY21kPTYgbWlkPTQzCiAgY3AtMjI4MjMgWzAwMl0gLi4uLiAxMjM0Mzku
MTgwMTc1OiBzbWIzX2NtZF9kb25lOiBzaWQ9MHg5ODg3MTMyNyB0aWQ9MHhmY2Q1ODVmZiBjbWQ9
NiBtaWQ9NDMKICBjcC0yMjgyMyBbMDAyXSAuLi4uIDEyMzQzOS4xODAxNzk6IHNtYjNfY2xvc2Vf
ZG9uZTogeGlkPTEwIHNpZD0weDk4ODcxMzI3IHRpZD0weGZjZDU4NWZmIGZpZD0weGM3Zjg0Njgy
CgogIGRkLTIyOTgxIFswMDNdIC4uLi4gMTIzNjk2Ljk0NjAxMTogc21iM19mbHVzaF9lbnRlcjog
eGlkPTI0IHNpZD0weDk4ODcxMzI3IHRpZD0weGZjZDU4NWZmIGZpZD0weDE5MTc3MzZmCiAgZGQt
MjI5ODEgWzAwM10gLi4uLiAxMjM2OTYuOTQ2MDEzOiBzbWIzX2NtZF9lbnRlcjogc2lkPTB4OTg4
NzEzMjcgdGlkPTB4ZmNkNTg1ZmYgY21kPTcgbWlkPTEyMwogIGRkLTIyOTgxIFswMDNdIC4uLi4g
MTIzNjk2Ljk1NjYzOTogc21iM19jbWRfZG9uZTogc2lkPTB4OTg4NzEzMjcgdGlkPTB4MCBjbWQ9
NyBtaWQ9MTIzCiAgZGQtMjI5ODEgWzAwM10gLi4uLiAxMjM2OTYuOTU2NjQ0OiBzbWIzX2ZsdXNo
X2RvbmU6IHhpZD0yNCBzaWQ9MHg5ODg3MTMyNyB0aWQ9MHhmY2Q1ODVmZiBmaWQ9MHgxOTE3NzM2
ZgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgot
LS0KIGZzL2NpZnMvc21iMnBkdS5jIHwgMTAgKysrKysrKystLQogZnMvY2lmcy90cmFjZS5oICAg
fCAzNSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2Vk
LCA0MyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggMGU5Mjk4M2RlMGI3Li40YzljMzRj
ZGYwNWYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBk
dS5jCkBAIC0yOTE4LDYgKzI5MTgsNyBAQCBTTUIyX2Nsb3NlX2ZsYWdzKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcnFzdC5ycV9pb3YgPSBpb3Y7CiAJ
cnFzdC5ycV9udmVjID0gMTsKIAorCXRyYWNlX3NtYjNfY2xvc2VfZW50ZXIoeGlkLCBwZXJzaXN0
ZW50X2ZpZCwgdGNvbi0+dGlkLCBzZXMtPlN1aWQpOwogCXJjID0gU01CMl9jbG9zZV9pbml0KHRj
b24sICZycXN0LCBwZXJzaXN0ZW50X2ZpZCwgdm9sYXRpbGVfZmlkKTsKIAlpZiAocmMpCiAJCWdv
dG8gY2xvc2VfZXhpdDsKQEAgLTI5MzAsNyArMjkzMSw5IEBAIFNNQjJfY2xvc2VfZmxhZ3MoY29u
c3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJdHJhY2Vfc21i
M19jbG9zZV9lcnIoeGlkLCBwZXJzaXN0ZW50X2ZpZCwgdGNvbi0+dGlkLCBzZXMtPlN1aWQsCiAJ
CQkJICAgICByYyk7CiAJCWdvdG8gY2xvc2VfZXhpdDsKLQl9CisJfSBlbHNlCisJCXRyYWNlX3Nt
YjNfY2xvc2VfZG9uZSh4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJCQkJICAgICAg
c2VzLT5TdWlkKTsKIAogCWF0b21pY19kZWMoJnRjb24tPm51bV9yZW1vdGVfb3BlbnMpOwogCkBA
IC0zMzUzLDEzICszMzU2LDE2IEBAIFNNQjJfZmx1c2goY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgdTY0IHBlcnNpc3RlbnRfZmlkLAogCWlmIChyYykKIAkJ
Z290byBmbHVzaF9leGl0OwogCisJdHJhY2Vfc21iM19mbHVzaF9lbnRlcih4aWQsIHBlcnNpc3Rl
bnRfZmlkLCB0Y29uLT50aWQsIHNlcy0+U3VpZCk7CiAJcmMgPSBjaWZzX3NlbmRfcmVjdih4aWQs
IHNlcywgJnJxc3QsICZyZXNwX2J1ZnR5cGUsIGZsYWdzLCAmcnNwX2lvdik7CiAKIAlpZiAocmMg
IT0gMCkgewogCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24sIFNNQjJfRkxVU0hfSEUpOwogCQl0
cmFjZV9zbWIzX2ZsdXNoX2Vycih4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsIHNlcy0+
U3VpZCwKIAkJCQkgICAgIHJjKTsKLQl9CisJfSBlbHNlCisJCXRyYWNlX3NtYjNfZmx1c2hfZG9u
ZSh4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJCQkJICAgICAgc2VzLT5TdWlkKTsK
IAogIGZsdXNoX2V4aXQ6CiAJU01CMl9mbHVzaF9mcmVlKCZycXN0KTsKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvdHJhY2UuaCBiL2ZzL2NpZnMvdHJhY2UuaAppbmRleCA5OWM0ZDc5OWMyNGIuLmYxMzM5
ZjRhMmQwNyAxMDA2NDQKLS0tIGEvZnMvY2lmcy90cmFjZS5oCisrKyBiL2ZzL2NpZnMvdHJhY2Uu
aApAQCAtMTE3LDYgKzExNyw0MSBAQCBERUZJTkVfU01CM19SV19ET05FX0VWRU5UKGZhbGxvY19k
b25lKTsKIC8qCiAgKiBGb3IgaGFuZGxlIGJhc2VkIGNhbGxzIG90aGVyIHRoYW4gcmVhZCBhbmQg
d3JpdGUsIGFuZCBnZXQvc2V0IGluZm8KICAqLworREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2Zk
X2NsYXNzLAorCVRQX1BST1RPKHVuc2lnbmVkIGludCB4aWQsCisJCV9fdTY0CWZpZCwKKwkJX191
MzIJdGlkLAorCQlfX3U2NAlzZXNpZCksCisJVFBfQVJHUyh4aWQsIGZpZCwgdGlkLCBzZXNpZCks
CisJVFBfU1RSVUNUX19lbnRyeSgKKwkJX19maWVsZCh1bnNpZ25lZCBpbnQsIHhpZCkKKwkJX19m
aWVsZChfX3U2NCwgZmlkKQorCQlfX2ZpZWxkKF9fdTMyLCB0aWQpCisJCV9fZmllbGQoX191NjQs
IHNlc2lkKQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnhpZCA9IHhpZDsKKwkJ
X19lbnRyeS0+ZmlkID0gZmlkOworCQlfX2VudHJ5LT50aWQgPSB0aWQ7CisJCV9fZW50cnktPnNl
c2lkID0gc2VzaWQ7CisJKSwKKwlUUF9wcmludGsoIlx0eGlkPSV1IHNpZD0weCVsbHggdGlkPTB4
JXggZmlkPTB4JWxseCIsCisJCV9fZW50cnktPnhpZCwgX19lbnRyeS0+c2VzaWQsIF9fZW50cnkt
PnRpZCwgX19lbnRyeS0+ZmlkKQorKQorCisjZGVmaW5lIERFRklORV9TTUIzX0ZEX0VWRU5UKG5h
bWUpICAgICAgICAgIFwKK0RFRklORV9FVkVOVChzbWIzX2ZkX2NsYXNzLCBzbWIzXyMjbmFtZSwg
ICAgXAorCVRQX1BST1RPKHVuc2lnbmVkIGludCB4aWQsCQlcCisJCV9fdTY0CWZpZCwJCQlcCisJ
CV9fdTMyCXRpZCwJCQlcCisJCV9fdTY0CXNlc2lkKSwJCQlcCisJVFBfQVJHUyh4aWQsIGZpZCwg
dGlkLCBzZXNpZCkpCisKK0RFRklORV9TTUIzX0ZEX0VWRU5UKGZsdXNoX2VudGVyKTsKK0RFRklO
RV9TTUIzX0ZEX0VWRU5UKGZsdXNoX2RvbmUpOworREVGSU5FX1NNQjNfRkRfRVZFTlQoY2xvc2Vf
ZW50ZXIpOworREVGSU5FX1NNQjNfRkRfRVZFTlQoY2xvc2VfZG9uZSk7CisKIERFQ0xBUkVfRVZF
TlRfQ0xBU1Moc21iM19mZF9lcnJfY2xhc3MsCiAJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwK
IAkJX191NjQJZmlkLAotLSAKMi4yMC4xCgo=
--000000000000fe3ee00591aea8a0--
