Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B16C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 08:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0DB3207D8
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 08:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nf2JVT9S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgESINk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 04:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgESINk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 04:13:40 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C992AC061A0C
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 01:13:39 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id 190so13840314qki.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 01:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=z1aKyGVstSxgvZKBf5pLwF1xs8pWkWrTSVxdLEZi1Ys=;
        b=Nf2JVT9SRwdYsi5cCsOn7TMmWYY2Y+WCV5BQxO50WGsFmspIkPQje+rX4m70FHrImX
         4Lq2X0UxWNLPwcyVHxhYm4T8oXfGBEitplRY/4NwQ3AOR4QF9/jGnvTxIWQYQ1RFeWm/
         D+MVFJp3Wddqp1YtvJcSkEC0DUsmEljQAc9kFxFrMGgQpUrxPcYhCjs/UluMaiGPbT+E
         juWTXm2nGyXpCw6g+tYNGwzKCR8emRfX/K0htvE29qNmBgLSSAoF1H3g6Oss9CXrWv6p
         rkjTmTerkTvJHEtAoe1A+Oqw8x7Plo6tPnHxOrOo+QW7uzixUPV+YmTv8+nYuZsXvaq4
         7Qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=z1aKyGVstSxgvZKBf5pLwF1xs8pWkWrTSVxdLEZi1Ys=;
        b=anZKl73f5QKHE6iWU52pXylrvoRuSaP3KLYxlP3dxO+65IFVncvlhC7mbtroqKfm4u
         0Pw7rZ0qkzOSBAeY0/y7v9niACgL9dCT3xWGqB1E7sho4XkxrWB+bbHE2mDaREvVh8Zw
         S/K+HBcPj/MypYLkwmoHjYSF+/kNy08Lj4Cb7IfMafP3fG/Olqh/xcYZzgR2tKUQaAjY
         3/1HjeUi5Kjy0Uhmi9senENd5sI2w0132bGQdkWxdQuO7DgKfLbGK2pQN0f3BNmgCYpZ
         KFpEIxqko3PNjUi7sN1jTSdT+t2sbv5fYzq9OOIa88KNXtGKPZ5kAuAC0196Wp3j/LP0
         D10g==
X-Gm-Message-State: AOAM531ICqTwEPtcVwx/tD7ng1yca2uK+mk+OmRw5LsRmhaAR/Gqtnyp
        Zq/uwIr/gT5tH9CDeM6ouvzdCY4bjU3ATkI46LNxt/Ql
X-Google-Smtp-Source: ABdhPJytLx/CPHm7lK3+8J6jvt5eTuhU6Vkq0KJoAgxVo/iCsTG7kRM1H76JXcNLBmZ/ZIjP3JuoPjVFA8MUCc0hNPs=
X-Received: by 2002:a25:d6c3:: with SMTP id n186mr27235649ybg.375.1589876018746;
 Tue, 19 May 2020 01:13:38 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 19 May 2020 03:13:28 -0500
Message-ID: <CAH2r5muydPce3j9R_he3DE0uMhPF-A40J0aPVEOXH-LKdjr3nA@mail.gmail.com>
Subject: [PATCH][CIFS] Add 'nodelete' mount parm
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000055c45905a5fbdb4f"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000055c45905a5fbdb4f
Content-Type: text/plain; charset="UTF-8"

    In order to handle workloads where it is important to make sure that
    a buggy app did not delete content on the drive, the new mount option
    "nodelete" allows standard permission checks on the server to work,
    but prevents on the client any attempts to unlink a file or delete
    a directory on that mount point.  This can be helpful when running
    a little understood app on a network mount that contains important
    content that should not be deleted.


-- 
Thanks,

Steve

--00000000000055c45905a5fbdb4f
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-smb3-Add-new-parm-nodelete.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-new-parm-nodelete.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kadn4ffb0>
X-Attachment-Id: f_kadn4ffb0

RnJvbSAyNzU1Mzg4ZjVlOGI1YzZkYzk0OWZhMDEwOGQzMjEwZTgxOGNhODgzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTkgTWF5IDIwMjAgMDM6MDY6NTcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBBZGQgbmV3IHBhcm0gIm5vZGVsZXRlIgoKSW4gb3JkZXIgdG8gaGFuZGxlIHdvcmtsb2Fk
cyB3aGVyZSBpdCBpcyBpbXBvcnRhbnQgdG8gbWFrZSBzdXJlIHRoYXQKYSBidWdneSBhcHAgZGlk
IG5vdCBkZWxldGUgY29udGVudCBvbiB0aGUgZHJpdmUsIHRoZSBuZXcgbW91bnQgb3B0aW9uCiJu
b2RlbGV0ZSIgYWxsb3dzIHN0YW5kYXJkIHBlcm1pc3Npb24gY2hlY2tzIG9uIHRoZSBzZXJ2ZXIg
dG8gd29yaywKYnV0IHByZXZlbnRzIG9uIHRoZSBjbGllbnQgYW55IGF0dGVtcHRzIHRvIHVubGlu
ayBhIGZpbGUgb3IgZGVsZXRlCmEgZGlyZWN0b3J5IG9uIHRoYXQgbW91bnQgcG9pbnQuICBUaGlz
IGNhbiBiZSBoZWxwZnVsIHdoZW4gcnVubmluZwphIGxpdHRsZSB1bmRlcnN0b29kIGFwcCBvbiBh
IG5ldHdvcmsgbW91bnQgdGhhdCBjb250YWlucyBpbXBvcnRhbnQKY29udGVudCB0aGF0IHNob3Vs
ZCBub3QgYmUgZGVsZXRlZC4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hA
bWljcm9zb2Z0LmNvbT4KQ0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KLS0tCiBm
cy9jaWZzL2NpZnNmcy5jICAgfCAgMiArKwogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgIDIgKysKIGZz
L2NpZnMvY29ubmVjdC5jICB8ICA5ICsrKysrKysrLQogZnMvY2lmcy9pbm9kZS5jICAgIHwgMTEg
KysrKysrKysrKysKIDQgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmlu
ZGV4IGMzMWYzNjJmYTA5OC4uODg5ZjljNzEwNDliIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNm
cy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMKQEAgLTUzNCw2ICs1MzQsOCBAQCBjaWZzX3Nob3df
b3B0aW9ucyhzdHJ1Y3Qgc2VxX2ZpbGUgKnMsIHN0cnVjdCBkZW50cnkgKnJvb3QpCiAJCXNlcV9w
dXRzKHMsICIsc2lnbmxvb3NlbHkiKTsKIAlpZiAodGNvbi0+bm9jYXNlKQogCQlzZXFfcHV0cyhz
LCAiLG5vY2FzZSIpOworCWlmICh0Y29uLT5ub2RlbGV0ZSkKKwkJc2VxX3B1dHMocywgIixub2Rl
bGV0ZSIpOwogCWlmICh0Y29uLT5sb2NhbF9sZWFzZSkKIAkJc2VxX3B1dHMocywgIixsb2NhbGxl
YXNlIik7CiAJaWYgKHRjb24tPnJldHJ5KQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZ2xvYi5o
IGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IDM5YjcwOGQ5ZDg2ZC4uNGQyNjFmZDc4ZmNiIDEw
MDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCkBA
IC01NjIsNiArNTYyLDcgQEAgc3RydWN0IHNtYl92b2wgewogCWJvb2wgb3ZlcnJpZGVfZ2lkOjE7
CiAJYm9vbCBkeW5wZXJtOjE7CiAJYm9vbCBub3Blcm06MTsKKwlib29sIG5vZGVsZXRlOjE7CiAJ
Ym9vbCBtb2RlX2FjZToxOwogCWJvb2wgbm9fcHN4X2FjbDoxOyAvKiBzZXQgaWYgcG9zaXggYWNs
IHN1cHBvcnQgc2hvdWxkIGJlIGRpc2FibGVkICovCiAJYm9vbCBjaWZzX2FjbDoxOwpAQCAtMTEz
Niw2ICsxMTM3LDcgQEAgc3RydWN0IGNpZnNfdGNvbiB7CiAJYm9vbCByZXRyeToxOwogCWJvb2wg
bm9jYXNlOjE7CiAJYm9vbCBub2hhbmRsZWNhY2hlOjE7IC8qIGlmIHN0cmFuZ2Ugc2VydmVyIHJl
c291cmNlIHByb2IgY2FuIHR1cm4gb2ZmICovCisJYm9vbCBub2RlbGV0ZToxOwogCWJvb2wgc2Vh
bDoxOyAgICAgIC8qIHRyYW5zcG9ydCBlbmNyeXB0aW9uIGZvciB0aGlzIG1vdW50ZWQgc2hhcmUg
Ki8KIAlib29sIHVuaXhfZXh0OjE7ICAvKiBpZiBmYWxzZSBkaXNhYmxlIExpbnV4IGV4dGVuc2lv
bnMgdG8gQ0lGUyBwcm90b2NvbAogCQkJCWZvciB0aGlzIG1vdW50IGV2ZW4gaWYgc2VydmVyIHdv
dWxkIHN1cHBvcnQgKi8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9j
b25uZWN0LmMKaW5kZXggNjI1MDNmYmVkMmFiLi5jZGU3ZmY1NWYwYTMgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC03NSw3ICs3NSw3IEBA
IGVudW0gewogCU9wdF9mb3JjZXVpZCwgT3B0X25vZm9yY2V1aWQsCiAJT3B0X2ZvcmNlZ2lkLCBP
cHRfbm9mb3JjZWdpZCwKIAlPcHRfbm9ibG9ja3NlbmQsIE9wdF9ub2F1dG90dW5lLCBPcHRfbm9s
ZWFzZSwKLQlPcHRfaGFyZCwgT3B0X3NvZnQsIE9wdF9wZXJtLCBPcHRfbm9wZXJtLAorCU9wdF9o
YXJkLCBPcHRfc29mdCwgT3B0X3Blcm0sIE9wdF9ub3Blcm0sIE9wdF9ub2RlbGV0ZSwKIAlPcHRf
bWFwcG9zaXgsIE9wdF9ub21hcHBvc2l4LAogCU9wdF9tYXBjaGFycywgT3B0X25vbWFwY2hhcnMs
IE9wdF9zZnUsCiAJT3B0X25vc2Z1LCBPcHRfbm9kZnMsIE9wdF9wb3NpeHBhdGhzLApAQCAtMTQx
LDYgKzE0MSw3IEBAIHN0YXRpYyBjb25zdCBtYXRjaF90YWJsZV90IGNpZnNfbW91bnRfb3B0aW9u
X3Rva2VucyA9IHsKIAl7IE9wdF9zb2Z0LCAic29mdCIgfSwKIAl7IE9wdF9wZXJtLCAicGVybSIg
fSwKIAl7IE9wdF9ub3Blcm0sICJub3Blcm0iIH0sCisJeyBPcHRfbm9kZWxldGUsICJub2RlbGV0
ZSIgfSwKIAl7IE9wdF9tYXBjaGFycywgIm1hcGNoYXJzIiB9LCAvKiBTRlUgc3R5bGUgKi8KIAl7
IE9wdF9ub21hcGNoYXJzLCAibm9tYXBjaGFycyIgfSwKIAl7IE9wdF9tYXBwb3NpeCwgIm1hcHBv
c2l4IiB9LCAvKiBTRk0gc3R5bGUgKi8KQEAgLTE3NjEsNiArMTc2Miw5IEBAIGNpZnNfcGFyc2Vf
bW91bnRfb3B0aW9ucyhjb25zdCBjaGFyICptb3VudGRhdGEsIGNvbnN0IGNoYXIgKmRldm5hbWUs
CiAJCWNhc2UgT3B0X25vcGVybToKIAkJCXZvbC0+bm9wZXJtID0gMTsKIAkJCWJyZWFrOworCQlj
YXNlIE9wdF9ub2RlbGV0ZToKKwkJCXZvbC0+bm9kZWxldGUgPSAxOworCQkJYnJlYWs7CiAJCWNh
c2UgT3B0X21hcGNoYXJzOgogCQkJdm9sLT5zZnVfcmVtYXAgPSB0cnVlOwogCQkJdm9sLT5yZW1h
cCA9IGZhbHNlOyAvKiBkaXNhYmxlIFNGTSBtYXBwaW5nICovCkBAIC0zMzYzLDYgKzMzNjcsOCBA
QCBzdGF0aWMgaW50IG1hdGNoX3Rjb24oc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IHNt
Yl92b2wgKnZvbHVtZV9pbmZvKQogCQlyZXR1cm4gMDsKIAlpZiAodGNvbi0+bm9fbGVhc2UgIT0g
dm9sdW1lX2luZm8tPm5vX2xlYXNlKQogCQlyZXR1cm4gMDsKKwlpZiAodGNvbi0+bm9kZWxldGUg
IT0gdm9sdW1lX2luZm8tPm5vZGVsZXRlKQorCQlyZXR1cm4gMDsKIAlyZXR1cm4gMTsKIH0KIApA
QCAtMzU5OCw2ICszNjA0LDcgQEAgY2lmc19nZXRfdGNvbihzdHJ1Y3QgY2lmc19zZXMgKnNlcywg
c3RydWN0IHNtYl92b2wgKnZvbHVtZV9pbmZvKQogCXRjb24tPnJldHJ5ID0gdm9sdW1lX2luZm8t
PnJldHJ5OwogCXRjb24tPm5vY2FzZSA9IHZvbHVtZV9pbmZvLT5ub2Nhc2U7CiAJdGNvbi0+bm9o
YW5kbGVjYWNoZSA9IHZvbHVtZV9pbmZvLT5ub2hhbmRsZWNhY2hlOworCXRjb24tPm5vZGVsZXRl
ID0gdm9sdW1lX2luZm8tPm5vZGVsZXRlOwogCXRjb24tPmxvY2FsX2xlYXNlID0gdm9sdW1lX2lu
Zm8tPmxvY2FsX2xlYXNlOwogCUlOSVRfTElTVF9IRUFEKCZ0Y29uLT5wZW5kaW5nX29wZW5zKTsK
IApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pbm9kZS5jIGIvZnMvY2lmcy9pbm9kZS5jCmluZGV4IDVk
Mjk2NWEyMzczMC4uODczYjFlZmZkNDEyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2lub2RlLmMKKysr
IGIvZnMvY2lmcy9pbm9kZS5jCkBAIC0xNDE4LDYgKzE0MTgsMTEgQEAgaW50IGNpZnNfdW5saW5r
KHN0cnVjdCBpbm9kZSAqZGlyLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCiAKIAl4aWQgPSBnZXRf
eGlkKCk7CiAKKwlpZiAodGNvbi0+bm9kZWxldGUpIHsKKwkJcmMgPSAtRUFDQ0VTOworCQlnb3Rv
IHVubGlua19vdXQ7CisJfQorCiAJLyogVW5saW5rIGNhbiBiZSBjYWxsZWQgZnJvbSByZW5hbWUg
c28gd2UgY2FuIG5vdCB0YWtlIHRoZQogCSAqIHNiLT5zX3Zmc19yZW5hbWVfbXV0ZXggaGVyZSAq
LwogCWZ1bGxfcGF0aCA9IGJ1aWxkX3BhdGhfZnJvbV9kZW50cnkoZGVudHJ5KTsKQEAgLTE3NDYs
NiArMTc1MSwxMiBAQCBpbnQgY2lmc19ybWRpcihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3Qg
ZGVudHJ5ICpkaXJlbnRyeSkKIAkJZ290byBybWRpcl9leGl0OwogCX0KIAorCWlmICh0Y29uLT5u
b2RlbGV0ZSkgeworCQlyYyA9IC1FQUNDRVM7CisJCWNpZnNfcHV0X3RsaW5rKHRsaW5rKTsKKwkJ
Z290byBybWRpcl9leGl0OworCX0KKwogCXJjID0gc2VydmVyLT5vcHMtPnJtZGlyKHhpZCwgdGNv
biwgZnVsbF9wYXRoLCBjaWZzX3NiKTsKIAljaWZzX3B1dF90bGluayh0bGluayk7CiAKLS0gCjIu
MjUuMQoK
--00000000000055c45905a5fbdb4f--
