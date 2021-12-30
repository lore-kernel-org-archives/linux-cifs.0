Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7F3C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Dec 2021 08:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhL3IP3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Dec 2021 03:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhL3IP2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Dec 2021 03:15:28 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9257FC061574
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 00:15:28 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id s15so20790293pfk.6
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 00:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:mime-version:subject:message-id:date:to;
        bh=sw3QPnKQCF/U+4v/Crq3SYPNJ6wegRCRUFRLMfBwQjU=;
        b=nh/F4VU2A+P/6kDXPfLoBQbgO7YFyXqlCrvJ7HjBX4hro4y9ZbMTZLfd7g5jUa9nK6
         NcwCphFnULY98233XJlL3/vZW877cerfU/QAoSQ1JF7CKGSiWDPH4M/roynQvjl8FWz3
         b8vE+8p+Rc+1LabZQDvYZ2Mc9G4l8lgOGZCIvmFwsFpkz7Po7XZbfDdpA8nAwp7KdJ1O
         z8Eh5S5zvpS4Kv771WVGHJeL/069Y8fSkcKgsrLyKH2G/0tbx1YZ1KSoeSsk0Gb9/Ulv
         nCCKmVhDWApeLN+xc5XY2I3SBx1CUhnZy1d3GHCv8pWhmmq6M+CxE1VmRFv0RGqoEUOw
         coPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:mime-version:subject:message-id:date:to;
        bh=sw3QPnKQCF/U+4v/Crq3SYPNJ6wegRCRUFRLMfBwQjU=;
        b=oFviPbR3tXCaDaD0uydWGQ5214GHnrUlrisIamP7kjQt0C6x75faSNnsxvTB7Dle4I
         FQmbEj+EfQ5Edq9AgTWgeYMQcaSpw+4OWxE8z91l3xPSZexK+tiwjEwpVU94CsDuA3gu
         9s2rCihOimrZr3n95YJ7DJcmCEfLuj/yIc6T69uHevQcUex1KTh19p0wZAaZlzDc/2KC
         FE1FBRpMHaZBjAU6+Cfd4QiwJySoZBXkEKinluMZsl3ddn5i+Dh3DACYK9fxBKbsRjrx
         bNYXMVYLO8pHHcpW7yPM4opjvdUweEUg1GMsX2hVfcdt6P+8XHpeqChDf/p35e9LtWv7
         KcgQ==
X-Gm-Message-State: AOAM532mm9/GqPJ4sc1Iy3RqDpHC9vEz9TPYexqOCbxNvZhk0bJkP3n0
        co5H/G9zCk2WFXCe5XEFlcWO9Cg+6TA=
X-Google-Smtp-Source: ABdhPJy9Ue/G6JNi+cvJMB9ztVuUzbw1e0q9SUYaSkMxZ8Z+fzdzCM0l9n1o8eh1dj9igc6lAOKdPg==
X-Received: by 2002:aa7:88ce:0:b0:4ba:efec:39e0 with SMTP id k14-20020aa788ce000000b004baefec39e0mr30526296pff.80.1640852127798;
        Thu, 30 Dec 2021 00:15:27 -0800 (PST)
Received: from smtpclient.apple ([110.76.108.172])
        by smtp.gmail.com with ESMTPSA id j20sm405221pfh.22.2021.12.30.00.15.26
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Dec 2021 00:15:27 -0800 (PST)
From:   =?utf-8?B?6rmA7JiB7ZuI?= <lanph3re@gmail.com>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_4AB26377-62D8-4938-AA3F-B4B93D2A1C06"
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Patch for ksmbd-tools (issue #222)
Message-Id: <BCCDD94E-F82F-4EDA-AC7E-9393C217A459@gmail.com>
Date:   Thu, 30 Dec 2021 17:15:24 +0900
To:     linux-cifs@vger.kernel.org
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--Apple-Mail=_4AB26377-62D8-4938-AA3F-B4B93D2A1C06
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello, I wrote an issue #222 in ksmbd-tools repository.

The one of the maintainers commented that I can send the patch to the =
mailing list.
I attached the patch generated with `git diff`.
I=E2=80=99ll also leave the original link for the issue below.

Thank you.

Issue link: https://github.com/cifsd-team/ksmbd-tools/issues/222=

--Apple-Mail=_4AB26377-62D8-4938-AA3F-B4B93D2A1C06
Content-Disposition: attachment;
	filename=issue222.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="issue222.patch"
Content-Transfer-Encoding: 7bit

diff --git a/addshare/addshare.c b/addshare/addshare.c
index 7458b6c..3c997e1 100644
--- a/addshare/addshare.c
+++ b/addshare/addshare.c
@@ -91,10 +91,10 @@ static int sanity_check_share_name_simple(char *name)
 		return -EINVAL;
 
 	for (i = 0; i < sz; i++) {
-		if (isalnum(name[i]))
-			return 0;
+		if (!isalnum(name[i]))
+			return -EINVAL;
 	}
-	return -EINVAL;
+	return 0;
 }
 
 int main(int argc, char *argv[])
diff --git a/adduser/adduser.c b/adduser/adduser.c
index 5ffb296..7f7988b 100644
--- a/adduser/adduser.c
+++ b/adduser/adduser.c
@@ -88,10 +88,10 @@ static int sanity_check_user_name_simple(char *uname)
 		return -EINVAL;
 
 	for (i = 0; i < sz; i++) {
-		if (isalnum(uname[i]))
-			return 0;
+		if (!isalnum(uname[i]))
+			return -EINVAL;
 	}
-	return -EINVAL;
+	return 0;
 }
 
 int main(int argc, char *argv[])

--Apple-Mail=_4AB26377-62D8-4938-AA3F-B4B93D2A1C06--
