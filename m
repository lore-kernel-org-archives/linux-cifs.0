Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A40C6FD1D
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Mar 2023 18:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjCTSvw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Mar 2023 14:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjCTSuz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Mar 2023 14:50:55 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E053A846
        for <linux-cifs@vger.kernel.org>; Mon, 20 Mar 2023 11:44:11 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id s20so5962736ljp.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Mar 2023 11:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679337848;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wsGRixAT3tuvq0GJFObtutOeQn67VzHDaGF9txZ6f0I=;
        b=E7zTYH6z7kHcWP/s6whtW5qPrwTPhbmXewaQ+FVXlFtMUXWZzETFVUx3h29jrty1Jh
         HHrYykJL63qaapzy0OOhN0DngY/JbHr63IKxTujPpzh0EDxSzjblTZhV8eN0t140/8Fh
         tTigFpVtMqsmLrp/+65cB47AhqA9vDrycfr4MD094GLQWrbiiF+QIZ1UvZxgytNxr4z8
         OBqMwkUkLZFs8yXfmUPa+aS8VEmN9XNsdMEMAD9O9zW5VA1Dyt8+ZNi9rxMjxExNvKg4
         kMA876KJDhShEB9wY3Sw3Nty11JA74d7SIkvAXJy1mXwy4gPtcTbKg9ZFBmsMGuYL0l3
         vA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337848;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wsGRixAT3tuvq0GJFObtutOeQn67VzHDaGF9txZ6f0I=;
        b=Ders4wbA6axA5de1nDaPPsIxKq7AYJnNPtAeVPcV0e1lIlgi13p9NuBjwNI+JyRNmK
         26VBLdHxhG4Jlif1rBUQtIYzoGBt+JyGLOFHoICgdnp7a2lDYskM4Jx+QB2WXt6EQV+9
         XFXDKOTuxfjSdH7znvEHFh7DZwWAi3MghITAxRxZXOPMUNdCDmcjznrrKXFD8Gf+1mXq
         NsyxJOT9byW7o9nnXW7OM4/SPVTckjhO4ACoJpIecSGXrhxJok8Bo/w0cIWRZ/FclOhl
         yFuf63D2LBU4gLcc/p7pd+uGD3K3c0UCWYg+si77SK2Q8Ne+ht/S5vz1nG8B3Te21xTt
         MLGw==
X-Gm-Message-State: AO0yUKXRuT5pHJdvxAIRKg6mmcjRLQ12fmP8sJ+73n+Zs32KwWWZBMwO
        GIX8sjQozwmYW9gWdZGf0IyijOi4ZguMpWHPZc5i5A7W
X-Google-Smtp-Source: AK7set8z36lwk35Lhv0/JvhJeoUhaaAHPa+A4hHTK94PwwZvixRrf1waK3lH3LyOvLBWLzUZYU2AFB8syMaALVm3ERE=
X-Received: by 2002:a2e:7405:0:b0:298:b3c7:293d with SMTP id
 p5-20020a2e7405000000b00298b3c7293dmr64897ljc.7.1679337848136; Mon, 20 Mar
 2023 11:44:08 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Mar 2023 13:43:57 -0500
Message-ID: <CAH2r5mvj=ObccFPLXiX0bGsxs_Y6Vex-z138NnyGeke92XNrZg@mail.gmail.com>
Subject: ksmbd not returning errors on unsupported dialects
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells had noticed that ksmbd returned "Input/output error"
when mounting with vers=2.0 to ksmbd.    Looking at this more
carefully, mounting to ksmbd works with 3.1.1 (and 3.0 and 2.1) as
expected, but he is correct it fails with the wrong error for
unsupported dialects like 2.0. ksmbd would be expected to fail with
mounts with vers-2.1 but this error would be confusing to users.

The problem is that ksmbd is returning STATUS_SUCESS on the negprot in
the first part of the SMB1 header, but returning no information in the
NegProt part of the response (e.g. StructureSize, SecurityMode,
Dialect etc.)

Looks like the bug is that you meant to return a status not supported
or similar but left that out (or similar to what you do with vers=1.0,
kill the socket which causes HOST DOWN to be returned by the Linux
client).

MS-SMB2 3.3.5.4 may have the exact error that is best to return in this case

-- 
Thanks,

Steve
