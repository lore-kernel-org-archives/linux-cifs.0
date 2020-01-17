Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB719C33CB1
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 06:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AD622082F
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 06:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kbet3eoI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAQG23 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jan 2020 01:28:29 -0500
Received: from mail-il1-f175.google.com ([209.85.166.175]:42915 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgAQG22 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jan 2020 01:28:28 -0500
Received: by mail-il1-f175.google.com with SMTP id t2so20410202ilq.9
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2020 22:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BmmngnEvJtiPArRGg8h/3VTtmGvYdWfkKyZbJWBjV+I=;
        b=Kbet3eoIzBEIBvuUpwkv5FRqvBQ98J8DdJqtkbv/H3mwBZM4W2pN5jBLLRrFW22SL1
         VteViHCStmMX7M8DaYs72F02O2EkRWpSQrN7/c+7gyJR6gzxioxzR++IYBgJYAjzxGkU
         SyCsIiVi7260+nvB8lhxnYMyzdM8iTC33AUkMnTYGb5PVarcbKLyPZvGoJ0NTUBmBPfO
         BQClzpht9D8uDQv6Gs0iQ4GtDJH3cmtzJsAUfaBQQ/ywQr2jSt0qJyxYupOO1aIqLYtv
         AJ2TyqE4ehpj9RaPuxeMUxp17iSeLov3dnDqfTXhJ8D7iHFTzrqEdX3+avQA60b8bFAG
         J36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BmmngnEvJtiPArRGg8h/3VTtmGvYdWfkKyZbJWBjV+I=;
        b=D3cRZxg0NErC1H8qSZXregTF1Hkb8yz5hRm1XnYZi/YBrzzl6GXoU3bluMGjsNBaOl
         vl8o4zxMUHvj1bIK95RwIoSIl5lqXnNykZQd+nJjPuITp/B1CcpomIEWEejUCeXNQKKL
         A2hLvrm5XLTHz0SJb90NEyNAA+Ihe3mtbPgdsQhHbqEcWQ7cof3lxBUOZHFp9Fr2b2hH
         CKBMPA9vF6vxvwsI4Cc7dYJdDL3FMaPvswXIa3IfWEOiSJcRVLhTRztM1BbUtOcVWPkb
         LSPIlYuwclaxf4eJTg7C5gKL9VmrySJLgj3Hid75dQl/lWwEi6T6Cu4vNag89xMj/tKG
         DJSQ==
X-Gm-Message-State: APjAAAVEGm++qfGZhnSAhQprihI8MSZ8V+Jqgu4lGI032Z6PJVwpzSYj
        /5S179aBxXlDh7JhXgpOB4sSsytqnUL2E0fjftQ=
X-Google-Smtp-Source: APXvYqyunpPaxghUD3X/gKriYwjjlTu4ypTX65hwhFHtE8cN8nE2qM/G6r//qxikYpDOCIR+wxf5L8otwa1GgNntWKc=
X-Received: by 2002:a05:6e02:d05:: with SMTP id g5mr1759030ilj.272.1579242508030;
 Thu, 16 Jan 2020 22:28:28 -0800 (PST)
MIME-Version: 1.0
References: <CALe0_75KJMBOMMAtSWNH=GkHv-vzvYQxOVuj8Eht6jfVfoYCcA@mail.gmail.com>
In-Reply-To: <CALe0_75KJMBOMMAtSWNH=GkHv-vzvYQxOVuj8Eht6jfVfoYCcA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Jan 2020 00:28:16 -0600
Message-ID: <CAH2r5mvJZ07D1+UtGJP-r-V3E2x4mxYkgP5PO530Lew7jDeW2Q@mail.gmail.com>
Subject: Re: cruid+multiuser mount options
To:     Jacob Shivers <jshivers@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a really good question and I think they should be allowed
together.   looking at cifs_sb_tlink in some detail, and also thinking
about common scenarios and how to make them less confusing to the user
I think they need to be supported together (optionally).  As an
example:

Imagine a scenario in which two users access the same Linux client
machine, and the machine is joined to the domain (and they login via
sssd or winbind to Active Directory or equivalent).   These users
would want to be able access the server with the correct permissions
for the particular user they are running as at the moment in a
particular app, a particular process, on Linux.   So as an example:

ssh in to the client as kerberos admin_user@domain
su root
mount -t cifs //server/share /mnt -o
sec=krb5,mfsymlinks,noperm,mutliuser,cruid=admin_user
<any access to the mount as either root or the admin_user on the Linux
client gets the expected permissions of "admin_user@domain")

then in different session ssh in to the client as kerberos
some_non_admin_user@domain
<any access to the user from processes running as
"some_non_admin_user" gets the expected permissions because with
multiuser we automatically setup a session for him>

If we didn't support cruid and mutliuser together then the user would
have had to do an extra step, he would have to do a confusing kinit
before doing the mount (which was unneeded since he could specify
cruid on mount)



On Thu, Jan 16, 2020 at 11:57 AM Jacob Shivers <jshivers@redhat.com> wrote:
>
> When mounting a Kerberized SMB share with both cruid and multiuser,
> the multiuser mount option is negated. This is not documented as
> explicit behavior. The question is whether this intended behavior or
> if it is unexpected.
>
> Does anyone have any existing thoughts on this?
>


-- 
Thanks,

Steve
