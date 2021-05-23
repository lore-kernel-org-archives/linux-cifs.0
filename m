Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AC6C4707F
	for <linux-cifs@archiver.kernel.org>; Sun, 23 May 2021 02:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A511A61163
	for <linux-cifs@archiver.kernel.org>; Sun, 23 May 2021 02:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhEWChq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 May 2021 22:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhEWChp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 May 2021 22:37:45 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23CEC061574;
        Sat, 22 May 2021 19:36:19 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id q7so34145515lfr.6;
        Sat, 22 May 2021 19:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NkGqd4k53BMXwjja9+wvjjI9pdHrq5VLDgaEoS0K1w0=;
        b=gxeyTaWjWQ2/QslbA0YaCi0fUS3wPrRcYacWGUVUBXLQvxMsq6qNrGtPh7EuZ8nmlt
         r17YJfc3Gv7n192UF4B9MG31VygXGqASmY8tyGn4e3f9OlB+pKf6KDjSXLndAY+YWPVb
         CgxO6MFYA2mFgE6k/gQW2HtiywGMQvf4dSQjnUM9sdB8W4gPDxbocR7zDjYbYlrqUaKn
         N2l4DIXS/xogszW0ooQxotsMQjlufXqIEyn80thkoeFvhyugwVx6sPXZ+LktGuEqXBnD
         UT2BMua96v51n5WzvV8ZQD7DdqwplrXnjD247VB3GbLIL2TeG+8UAm6h3YKFeFtMIK62
         8kUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NkGqd4k53BMXwjja9+wvjjI9pdHrq5VLDgaEoS0K1w0=;
        b=FyXXnyPdZcv0iSr4ngoI0KFyogCQahHyN4Fy6H2bSMmdp9jjX0nC2k/OvQzmztyuGJ
         9kqOn5qjzeTj7nTdTKgD5ZSRmS19JtUkAMqRxmeXYv0HXRrwY1rsB++KnlrKBKlriHJ2
         8whXIPFUCYRVJeQW4Z7Z7V5AiEDCn4mQtG7WLAePrkEycGHPcbcFCNngFC3v+0rDe/uA
         gqGVfW+mh3DYezrxOoO0MZW6llzQ8Xx5kDtblvzuKxLLlFpdlN1hShU7wuSV8gxIBLlg
         /OX5jcLCPr4+jFku5rjsGJKEXi0DPzaOUYgI+FczEDYeZS6Afm0+KTMTTWrjQ9Beduiy
         ygpA==
X-Gm-Message-State: AOAM530csKwzKd0/Z20Y9P3IQzv8ycjlKh70p9+dwpZy/h6K7D3FsW4g
        dOVpV9jQGldZ0lzVnFT3W0a+zZTsxxRDxOhh51M=
X-Google-Smtp-Source: ABdhPJyYeFI4q2C9mD9PW9pKzF9kAjVifvOLTDg0EXYi50/aq2X7GL9aFDPeQ7k93ZE2s0K8xTRia5xYHi2SJG34tDE=
X-Received: by 2002:ac2:546b:: with SMTP id e11mr6508563lfn.395.1621737376856;
 Sat, 22 May 2021 19:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210521020051.196434-1-hyc.lee@gmail.com> <87o8d4qxyi.fsf@suse.com>
In-Reply-To: <87o8d4qxyi.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 22 May 2021 21:36:06 -0500
Message-ID: <CAH2r5muZDKC1uZM-q2AGe1f50WtxCHZEPS0oHTBQtROJCZ0QJw@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: decoding negTokenInit with generic ASN1 decoder
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, May 21, 2021 at 3:44 AM Aur=C3=A9lien Aptel via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Hi Hyunchul,
>
> The existence of multiple ASN1 decoder has been a regular complaint,
> this looks nice. Have you tested it against any servers?
>
> I think we need to make sure it works with Windows Server (including
> increased ones with the increased security flag, Steve do you remember
> the name of that flag?) and Samba at least.

Are you thinking about the authentication problem to Windows when a
stricter registry setting is chosen for server name hardening?

This involves populating the ntlmv2 response area of an NTLMSSP blob
with the  "Target Name" attribute ie missing MsvAvTargetNamefield and
maybe also
MsvAvTimestamp and NTLMSSP_AVFLAG_MIC_IN_AUTHENTICATE_MESSAGE in
MsvAvFlags.   These (the target name field in particular) are required
when Windows servers set the registry parm SmbServerNameHardeningLevel
to 2

See e.g. https://docs.microsoft.com/en-us/windows/security/threat-protectio=
n/security-policy-settings/microsoft-network-server-server-spn-target-name-=
validation-level

> There is the SDC EMEA plugfest coming up, might be a good time to try it
> out against other vendors as well.

Yes - definitely need to try with various cases (krb5 and ntlmssp in
SPNEGO) to various servers (Macs, NetApp, Windows, Azure, Samba,ksmbd
etc)


--=20
Thanks,

Steve
