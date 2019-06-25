Return-Path: <SRS0=QLD2=UY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FB1C4646B
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 01:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 981C020644
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 01:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnQxvjfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfFYBoS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 21:44:18 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:43614 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfFYBoS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 21:44:18 -0400
Received: by mail-pl1-f174.google.com with SMTP id cl9so7875285plb.10
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 18:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Ot0LXBFCVazcXCFhS5snXLm+Lg5dyElM/SZz5OLDKeM=;
        b=fnQxvjfqQjxgFecyOgiE+ZKPjIfG/IAKL1iv+ch8m308koImBwanG0AhqK+X6T5foy
         pL69KKuSMoPqca2dfpzTHEkZXCEf6tcpXrUwkYhr9XCL14VpGwWDOpoK8/wjNL9vTbDn
         nBbBbZD+/QFdrS1/wDavFo/1btSIu9Uq39p1u6Wd5OtV2wf8ncWYgY0200vy7KgRTRLL
         31yARZK8EkAXWyttzezlwoSg+EPCtCXuHZsL+s98L4hxx0MUqQ47OXEsjvPJc+Vzvt2Y
         YPBUTudJUZzSB+40NPuoIFQshzZRSvezmYdd+u3ymPGowZFXEIkVa98Q7nuzlktgv4AX
         l49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Ot0LXBFCVazcXCFhS5snXLm+Lg5dyElM/SZz5OLDKeM=;
        b=DhQ5y0MFQhFUipTVdBPAF18Gf6jScbQfkzNhSO1wD8pi4arbbE28R3gRnC/QVJq3WQ
         9sHyjTMczXtFBZ6Wc6UYWvCUuPWvS77eQbCAndhyvNx7MdGX/XtIgA/Z4Q0Adxb6LFAs
         e/KleLQTtbRmd7iVBJHpk3VvQ9OoJ6UM3fyV2StHv6zKy0qqT210BHzeNqmisd6e+fzA
         GuC9fylT3E3+e+sp/F9QZPoZjRVlBXFgwnwObFkfkfnBScMQTnkohQzZPo2Vdgp3qPGN
         YSiM1pDusXa0lkiA/xdZbIjOOtYn9l/LCCsNTbRvpUr4DGHxMQkivvEk26JTzcwjMSYF
         t3mw==
X-Gm-Message-State: APjAAAVLf74PFcP3zts6d+X4vgROs0LsgUBc0xbnxgJWD3b0bDU+yENT
        Nq/+yWDC7sZ4iCsyP1QJHqDcuCzAYukpXBwkkWbLQ7Hr
X-Google-Smtp-Source: APXvYqx7fmTZHaoiqck+9GsWxEaX9EmdAiXiaovcHqx1Erk9E6I1qt+4WDAwfzXfNsTya7cZ3ilq0LTiRoeX57Zk5bc=
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr18737502plc.78.1561427056699;
 Mon, 24 Jun 2019 18:44:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 20:44:05 -0500
Message-ID: <CAH2r5muc79aECUnSCyM9CX9mYiARagHe=FaoCGPLpnqUD+r0_A@mail.gmail.com>
Subject: [PATCH][SMB3] do not negotiate compression information unless
 explicitly requested by user at mount
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000000f2f3b058c1c1171"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000f2f3b058c1c1171
Content-Type: text/plain; charset="UTF-8"

Since in theory a server could respond with compressed read
responses even if not requested on read request (assuming that
a compression negcontext is sent in negotiate protocol) - do
not send compression information during negotiate protocol
unless the user asks for compression explicitly (compression
is experimental), and add a mount warning that compression
is experimental.



-- 
Thanks,

Steve

--0000000000000f2f3b058c1c1171
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-send-compression-info-by-default.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-send-compression-info-by-default.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxb5ch6f0>
X-Attachment-Id: f_jxb5ch6f0

RnJvbSAzZDYzNWQ4OWJkZTllYTAzM2FjNzIxNzgwNTNhYmY2NjhjOTM3MjY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjQgSnVuIDIwMTkgMjA6Mzk6MDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3Qgc2VuZCBjb21wcmVzc2lvbiBpbmZvIGJ5IGRlZmF1bHQKClNpbmNlIGluIHRo
ZW9yeSBhIHNlcnZlciBjb3VsZCByZXNwb25kIHdpdGggY29tcHJlc3NlZCByZWFkCnJlc3BvbnNl
cyBldmVuIGlmIG5vdCByZXF1ZXN0ZWQgb24gcmVhZCByZXF1ZXN0IChhc3N1bWluZyB0aGF0CmEg
Y29tcHJlc3Npb24gbmVnY29udGV4dCBpcyBzZW50IGluIG5lZ290aWF0ZSBwcm90b2NvbCkgLSBk
bwpub3Qgc2VuZCBjb21wcmVzc2lvbiBpbmZvcm1hdGlvbiBkdXJpbmcgbmVnb3RpYXRlIHByb3Rv
Y29sCnVubGVzcyB0aGUgdXNlciBhc2tzIGZvciBjb21wcmVzc2lvbiBleHBsaWNpdGx5IChjb21w
cmVzc2lvbgppcyBleHBlcmltZW50YWwpLCBhbmQgYWRkIGEgbW91bnQgd2FybmluZyB0aGF0IGNv
bXByZXNzaW9uCmlzIGV4cGVyaW1lbnRhbC4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNnbG9iLmggfCAgMSArCiBm
cy9jaWZzL2Nvbm5lY3QuYyAgfCAgOCArKysrKysrKwogZnMvY2lmcy9zbWIycGR1LmMgIHwgMjIg
KysrKysrKysrKysrLS0tLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCsp
LCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9j
aWZzL2NpZnNnbG9iLmgKaW5kZXggOTA4NjcyNjRiYTRlLi5kZDk5ZDAzMThiNzcgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAgLTYwMSw2
ICs2MDEsNyBAQCBzdHJ1Y3Qgc21iX3ZvbCB7CiAJX191NjQgc25hcHNob3RfdGltZTsgLyogbmVl
ZGVkIGZvciB0aW1ld2FycCB0b2tlbnMgKi8KIAlfX3UzMiBoYW5kbGVfdGltZW91dDsgLyogcGVy
c2lzdGVudCBhbmQgZHVyYWJsZSBoYW5kbGUgdGltZW91dCBpbiBtcyAqLwogCXVuc2lnbmVkIGlu
dCBtYXhfY3JlZGl0czsgLyogc21iMyBtYXhfY3JlZGl0cyAxMCA8IGNyZWRpdHMgPCA2MDAwMCAq
LworCV9fdTE2IGNvbXByZXNzaW9uOyAvKiBjb21wcmVzc2lvbiBhbGdvcml0aG0gMHhGRkZGIGRl
ZmF1bHQgMD1kaXNhYmxlZCAqLwogfTsKIAogLyoqCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5l
Y3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IDU0ZTJiMjY1MmMzZC4uZGE4NWEyNTFhNjA5
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpA
QCAtOTcsNiArOTcsNyBAQCBlbnVtIHsKIAlPcHRfcGVyc2lzdGVudCwgT3B0X25vcGVyc2lzdGVu
dCwKIAlPcHRfcmVzaWxpZW50LCBPcHRfbm9yZXNpbGllbnQsCiAJT3B0X2RvbWFpbmF1dG8sIE9w
dF9yZG1hLCBPcHRfbW9kZWFjZSwKKwlPcHRfY29tcHJlc3MsCiAKIAkvKiBNb3VudCBvcHRpb25z
IHdoaWNoIHRha2UgbnVtZXJpYyB2YWx1ZSAqLwogCU9wdF9iYWNrdXB1aWQsIE9wdF9iYWNrdXBn
aWQsIE9wdF91aWQsCkBAIC0yMTMsNiArMjE0LDcgQEAgc3RhdGljIGNvbnN0IG1hdGNoX3RhYmxl
X3QgY2lmc19tb3VudF9vcHRpb25fdG9rZW5zID0gewogCXsgT3B0X2VjaG9faW50ZXJ2YWwsICJl
Y2hvX2ludGVydmFsPSVzIiB9LAogCXsgT3B0X21heF9jcmVkaXRzLCAibWF4X2NyZWRpdHM9JXMi
IH0sCiAJeyBPcHRfc25hcHNob3QsICJzbmFwc2hvdD0lcyIgfSwKKwl7IE9wdF9jb21wcmVzcywg
ImNvbXByZXNzPSVzIiB9LAogCiAJeyBPcHRfYmxhbmtfdXNlciwgInVzZXI9IiB9LAogCXsgT3B0
X2JsYW5rX3VzZXIsICJ1c2VybmFtZT0iIH0sCkBAIC0xOTE1LDYgKzE5MTcsMTEgQEAgY2lmc19w
YXJzZV9tb3VudF9vcHRpb25zKGNvbnN0IGNoYXIgKm1vdW50ZGF0YSwgY29uc3QgY2hhciAqZGV2
bmFtZSwKIAkJY2FzZSBPcHRfcmRtYToKIAkJCXZvbC0+cmRtYSA9IHRydWU7CiAJCQlicmVhazsK
KwkJY2FzZSBPcHRfY29tcHJlc3M6CisJCQl2b2wtPmNvbXByZXNzaW9uID0gVU5LTk9XTl9UWVBF
OworCQkJY2lmc19kYmcoVkZTLAorCQkJCSJTTUIzIGNvbXByZXNzaW9uIHN1cHBvcnQgaXMgZXhw
ZXJpbWVudGFsXG4iKTsKKwkJCWJyZWFrOwogCiAJCS8qIE51bWVyaWMgVmFsdWVzICovCiAJCWNh
c2UgT3B0X2JhY2t1cHVpZDoKQEAgLTI2OTEsNiArMjY5OCw3IEBAIGNpZnNfZ2V0X3RjcF9zZXNz
aW9uKHN0cnVjdCBzbWJfdm9sICp2b2x1bWVfaW5mbykKIAl0Y3Bfc2VzLT5zZXF1ZW5jZV9udW1i
ZXIgPSAwOwogCXRjcF9zZXMtPnJlY29ubmVjdF9pbnN0YW5jZSA9IDE7CiAJdGNwX3Nlcy0+bHN0
cnAgPSBqaWZmaWVzOworCXRjcF9zZXMtPmNvbXByZXNzX2FsZ29yaXRobSA9IGNwdV90b19sZTE2
KHZvbHVtZV9pbmZvLT5jb21wcmVzc2lvbik7CiAJc3Bpbl9sb2NrX2luaXQoJnRjcF9zZXMtPnJl
cV9sb2NrKTsKIAlJTklUX0xJU1RfSEVBRCgmdGNwX3Nlcy0+dGNwX3Nlc19saXN0KTsKIAlJTklU
X0xJU1RfSEVBRCgmdGNwX3Nlcy0+c21iX3Nlc19saXN0KTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggYWIzMzAwYTM5MDcxLi44ZTI4OTQw
NGY2YjAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBk
dS5jCkBAIC01MjEsNyArNTIxLDcgQEAgYnVpbGRfcG9zaXhfY3R4dChzdHJ1Y3Qgc21iMl9wb3Np
eF9uZWdfY29udGV4dCAqcG5lZ19jdHh0KQogCiBzdGF0aWMgdm9pZAogYXNzZW1ibGVfbmVnX2Nv
bnRleHRzKHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJlcSwKLQkJICAgICAgdW5zaWduZWQg
aW50ICp0b3RhbF9sZW4pCisJCSAgICAgIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwg
dW5zaWduZWQgaW50ICp0b3RhbF9sZW4pCiB7CiAJY2hhciAqcG5lZ19jdHh0ID0gKGNoYXIgKily
ZXE7CiAJdW5zaWduZWQgaW50IGN0eHRfbGVuOwpAQCAtNTUxLDE3ICs1NTEsMTkgQEAgYXNzZW1i
bGVfbmVnX2NvbnRleHRzKHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yZXEgKnJlcSwKIAkqdG90YWxf
bGVuICs9IGN0eHRfbGVuOwogCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKIAotCWJ1aWxkX2NvbXBy
ZXNzaW9uX2N0eHQoKHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19jb250ZXh0
ICopCisJaWYgKHNlcnZlci0+Y29tcHJlc3NfYWxnb3JpdGhtKSB7CisJCWJ1aWxkX2NvbXByZXNz
aW9uX2N0eHQoKHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19jb250ZXh0ICop
CiAJCQkJcG5lZ19jdHh0KTsKLQljdHh0X2xlbiA9IERJVl9ST1VORF9VUCgKLQkJc2l6ZW9mKHN0
cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19jb250ZXh0KSwgOCkgKiA4OwotCSp0
b3RhbF9sZW4gKz0gY3R4dF9sZW47Ci0JcG5lZ19jdHh0ICs9IGN0eHRfbGVuOwotCisJCWN0eHRf
bGVuID0gRElWX1JPVU5EX1VQKAorCQkJc2l6ZW9mKHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2Nh
cGFiaWxpdGllc19jb250ZXh0KSwKKwkJCQk4KSAqIDg7CisJCSp0b3RhbF9sZW4gKz0gY3R4dF9s
ZW47CisJCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKKwkJcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291
bnQgPSBjcHVfdG9fbGUxNig0KTsKKwl9IGVsc2UKKwkJcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291
bnQgPSBjcHVfdG9fbGUxNigzKTsKIAlidWlsZF9wb3NpeF9jdHh0KChzdHJ1Y3Qgc21iMl9wb3Np
eF9uZWdfY29udGV4dCAqKXBuZWdfY3R4dCk7CiAJKnRvdGFsX2xlbiArPSBzaXplb2Yoc3RydWN0
IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQpOwotCi0JcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291bnQg
PSBjcHVfdG9fbGUxNig0KTsKIH0KIAogc3RhdGljIHZvaWQgZGVjb2RlX3ByZWF1dGhfY29udGV4
dChzdHJ1Y3Qgc21iMl9wcmVhdXRoX25lZ19jb250ZXh0ICpjdHh0KQpAQCAtODI5LDcgKzgzMSw3
IEBAIFNNQjJfbmVnb3RpYXRlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Nl
cyAqc2VzKQogCQlpZiAoKHNlcy0+c2VydmVyLT52YWxzLT5wcm90b2NvbF9pZCA9PSBTTUIzMTFf
UFJPVF9JRCkgfHwKIAkJICAgIChzdHJjbXAoc2VzLT5zZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3Ry
aW5nLAogCQkgICAgIFNNQkRFRkFVTFRfVkVSU0lPTl9TVFJJTkcpID09IDApKQotCQkJYXNzZW1i
bGVfbmVnX2NvbnRleHRzKHJlcSwgJnRvdGFsX2xlbik7CisJCQlhc3NlbWJsZV9uZWdfY29udGV4
dHMocmVxLCBzZXJ2ZXIsICZ0b3RhbF9sZW4pOwogCX0KIAlpb3ZbMF0uaW92X2Jhc2UgPSAoY2hh
ciAqKXJlcTsKIAlpb3ZbMF0uaW92X2xlbiA9IHRvdGFsX2xlbjsKLS0gCjIuMjAuMQoK
--0000000000000f2f3b058c1c1171--
