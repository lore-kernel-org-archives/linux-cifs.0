Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822A5C7EE23
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 01:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbjEXBiw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 21:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjEXBiw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 21:38:52 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7423F135
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:38:48 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f3a9ad31dbso246841e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 18:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684892326; x=1687484326;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2vkOVKcZyZtyYOvM2WhxQYGt/Xd401tJAAdS3L4nEeE=;
        b=g/WYkVctiL3NIusal71tSOtcMUU+EHljzl+yARuwQnZgdcZ0GDfeDCr3N6hrpih5XS
         m0ffhcUlRH7kyYLAp/X14lsTskt7sm+1+yEFe5JH3ViqqPT0n02sSqOx0OZAtDQKn11r
         eaPqehxYiRs6r5AMedbYj6gfcU4DsHMEMTJn8hYunNPlYM77PnanrV1AkOY/FUcS5etH
         GumEVMCgMItyBPql0AXymHJDCBaK6KJxqWSkvjwFQf9K8Z/y53BHftWbackTBTqM/+5i
         +SeieC3ZDHNURcUGxwH57/ni/GpFz4M2KhAgEEOFHPzMvbUOwvjLLyDz+k1lEr23wLNS
         v8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684892326; x=1687484326;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2vkOVKcZyZtyYOvM2WhxQYGt/Xd401tJAAdS3L4nEeE=;
        b=ClIUKoc2L6R+0vXzkWYJafLTb5RaZnFPTo+RhXQxTD4PMxEGWft1k8uWgaLEdScFWy
         txF4dfE16IWtLPPs+YVfCfqDhSFaJSCVfKx/igvTbPepKWWbpVckHfYSMCQ+FQ/+tP9z
         idhCLragEKNlGGUfylyCFEa/C8gN5kvEzK/KgEV9XSFU8CZJIaIo36UItfYv2U/v2tLw
         M0RsN+sPNV2H2BHoHdMr7wtLF9CW3b/FzvVpVbspCwHCkCHIj/6BsZi8qzBVk9EQskvM
         MaFr+AzyfJgkuLqfGApRac0SZz24VAhBWanzsJJUdmf4IWEAbyEOnbc3KhCi/dOH7BUm
         kWZw==
X-Gm-Message-State: AC+VfDzoOYXNggjvd76n3zHdCyGyEGzzDjyvr9qJyMVRTb5AynhZF66y
        Rp5oXyKOH0Iy38HBllBi5PpyJOgP1/3mHemYWSkZYp7/Uy7nZix1
X-Google-Smtp-Source: ACHHUZ4UB4Ns+spW2eLGe7xpBXYHixEyQxOTD82SpxTsZ5TUEk1gSRKuEXaNn6sMSgWyl1uQgMTYyASQzbouM1HgOsg=
X-Received: by 2002:a2e:960a:0:b0:2ac:7ffb:6bda with SMTP id
 v10-20020a2e960a000000b002ac7ffb6bdamr5411425ljh.2.1684892325999; Tue, 23 May
 2023 18:38:45 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 May 2023 20:38:34 -0500
Message-ID: <CAH2r5mtuuGd-OR-Ran9XWDzv7pW=pv6xUBGZExE87+NrChsRoQ@mail.gmail.com>
Subject: [PATCH][SMB3] display debug information better for encryption
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000009395e205fc669055"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009395e205fc669055
Content-Type: text/plain; charset="UTF-8"

Fix /proc/fs/cifs/DebugData to use the same case for "encryption"
(ie "Encryption" with init capital letter was used in one place).
In addition, if gcm256 encryption (intead of gcm128) is used on
a connection to a server, note that in the DebugData as well.

It now says (when gcm256 encryption negotiated):
Security type: RawNTLMSSP  SessionId: 0x86125800bc000b0d encrypted(gcm256)

-- 
Thanks,

Steve

--0000000000009395e205fc669055
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-display-debug-information-better-for-encryption.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-display-debug-information-better-for-encryption.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_li113kvk0>
X-Attachment-Id: f_li113kvk0

RnJvbSA5NDRhYWFmYjUwNTFhZDZhMjBhYmU5MTgzOTAwZjFlZDY5ZWZlN2ExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgTWF5IDIwMjMgMjA6MjU6NDcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkaXNwbGF5IGRlYnVnIGluZm9ybWF0aW9uIGJldHRlciBmb3IgZW5jcnlwdGlvbgoKRml4
IC9wcm9jL2ZzL2NpZnMvRGVidWdEYXRhIHRvIHVzZSB0aGUgc2FtZSBjYXNlIGZvciAiZW5jcnlw
dGlvbiIKKGllICJFbmNyeXB0aW9uIiB3aXRoIGluaXQgY2FwaXRhbCBsZXR0ZXIgd2FzIHVzZWQg
aW4gb25lIHBsYWNlKS4KSW4gYWRkaXRpb24sIGlmIGdjbTI1NiBlbmNyeXB0aW9uIChpbnRlYWQg
b2YgZ2NtMTI4KSBpcyB1c2VkIG9uCmEgY29ubmVjdGlvbiB0byBhIHNlcnZlciwgbm90ZSB0aGF0
IGluIHRoZSBEZWJ1Z0RhdGEgYXMgd2VsbC4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlbiBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzX2RlYnVnLmMgfCA4ICsr
KysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jIGIvZnMvY2lmcy9jaWZzX2RlYnVnLmMK
aW5kZXggZDRlZDIwMGE5NDcxLi43NGQyNzc2ZTE2MWYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lm
c19kZWJ1Zy5jCisrKyBiL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCkBAIC0xMDgsNyArMTA4LDcgQEAg
c3RhdGljIHZvaWQgY2lmc19kZWJ1Z190Y29uKHN0cnVjdCBzZXFfZmlsZSAqbSwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbikKIAlpZiAoKHRjb24tPnNlYWwpIHx8CiAJICAgICh0Y29uLT5zZXMtPnNl
c3Npb25fZmxhZ3MgJiBTTUIyX1NFU1NJT05fRkxBR19FTkNSWVBUX0RBVEEpIHx8CiAJICAgICh0
Y29uLT5zaGFyZV9mbGFncyAmIFNISTEwMDVfRkxBR1NfRU5DUllQVF9EQVRBKSkKLQkJc2VxX3By
aW50ZihtLCAiIEVuY3J5cHRlZCIpOworCQlzZXFfcHJpbnRmKG0sICIgZW5jcnlwdGVkIik7CiAJ
aWYgKHRjb24tPm5vY2FzZSkKIAkJc2VxX3ByaW50ZihtLCAiIG5vY2FzZSIpOwogCWlmICh0Y29u
LT51bml4X2V4dCkKQEAgLTQxNSw4ICs0MTUsMTIgQEAgc3RhdGljIGludCBjaWZzX2RlYnVnX2Rh
dGFfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikKIAogCQkJLyogZHVtcCBz
ZXNzaW9uIGlkIGhlbHBmdWwgZm9yIHVzZSB3aXRoIG5ldHdvcmsgdHJhY2UgKi8KIAkJCXNlcV9w
cmludGYobSwgIiBTZXNzaW9uSWQ6IDB4JWxseCIsIHNlcy0+U3VpZCk7Ci0JCQlpZiAoc2VzLT5z
ZXNzaW9uX2ZsYWdzICYgU01CMl9TRVNTSU9OX0ZMQUdfRU5DUllQVF9EQVRBKQorCQkJaWYgKHNl
cy0+c2Vzc2lvbl9mbGFncyAmIFNNQjJfU0VTU0lPTl9GTEFHX0VOQ1JZUFRfREFUQSkgewogCQkJ
CXNlcV9wdXRzKG0sICIgZW5jcnlwdGVkIik7CisJCQkJLyogY2FuIGhlbHAgaW4gZGVidWdnaW5n
IHRvIHNob3cgZW5jcnlwdGlvbiB0eXBlICovCisJCQkJaWYgKHNlcnZlci0+Y2lwaGVyX3R5cGUg
PT0gU01CMl9FTkNSWVBUSU9OX0FFUzI1Nl9HQ00pCisJCQkJCXNlcV9wdXRzKG0sICIoZ2NtMjU2
KSIpOworCQkJfQogCQkJaWYgKHNlcy0+c2lnbikKIAkJCQlzZXFfcHV0cyhtLCAiIHNpZ25lZCIp
OwogCi0tIAoyLjM0LjEKCg==
--0000000000009395e205fc669055--
