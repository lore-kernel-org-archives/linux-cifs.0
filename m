Return-Path: <SRS0=jMYF=Q2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2721C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 19:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD8142146F
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 19:46:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWiywuuH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfBSTqi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:46:38 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:42728 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfBSTqi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Feb 2019 14:46:38 -0500
Received: by mail-lf1-f48.google.com with SMTP id l10so15697240lfh.9
        for <linux-cifs@vger.kernel.org>; Tue, 19 Feb 2019 11:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NYqtoNHrossGoHk4kxOOjSKsNjniMTXlrtnZlCi79F8=;
        b=XWiywuuHRjt4FbS4droX56go/gDdGeWQA28D3SSuA9UhoKur4VoA9/nVIF48YcNdQP
         jrrrT43cUUIV0cg9dmaggqaKMK1QDy+KVABTSLErdzloZwW76NFrf4w2RumMpaTbx8RI
         fqO2OoOfevJVx3Aggl37hnrpycfAmnTkVJvoTB0jIMGeIQPjYLh4cXzdg0qoQJyhDSrn
         iMg5eLSeLCFUenwNaFQNmZ/zfJmUF41wqRNgGR9Fui4n+5DFtWeEnno6/AZedoPtzLk5
         eQnalR4CpF2aKbFv+OrX4Uaaitjtyn4dnHvMIdjUfRrOfsZpTdx6pQYiLMxCvGoBvZYE
         2iNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NYqtoNHrossGoHk4kxOOjSKsNjniMTXlrtnZlCi79F8=;
        b=c3UAL0ZRMKj0Azj/2E5XozNBodgJ2efpgK3GR4Y3bpE7ukJZf+PQ/+27fUBx+Nzwpo
         Kn40Hku3Jc36ochuemJBko0gswCE/Rc0In66tN5sNOS13c4kEq+Cupm+HyNixLb9WsYe
         bsNN/dEwBZQDGPqdL3dAotmSGbF9oMQ/IFFA3rRnITDmjs5nYMcovCUwOfsXgfNx+i9v
         D1tVfgwYZ23hAtp027F3WJ3fR+u2EznTdEZnYGweB4qUzIMeGmjl1Y3VTWc5hIswV7QU
         iTFbqRV4+WXxRPQSWTFAdHx13o5cR+4f2Zkwnc4079hmLG4UnibWfrma746G8ji1z6aj
         aQlg==
X-Gm-Message-State: AHQUAuauGDUbESX1uDzp4WUKUVIPSk/Po9MQVD+WMl4gn9oxHtddUloZ
        zuf3ATbR/OfPWNGfMnd7Lkb5RQH9k24N8IwWLS9Ij84=
X-Google-Smtp-Source: AHgI3IZB+/dKJiJOB4tcOcu1vo5CoFt2jiv2V/Q0gP2ubn/Mp3s5x7G9QgWGjVWiTZAO7fsWJRdigBQFFTAkMT86lcU=
X-Received: by 2002:a19:d83:: with SMTP id 125mr17487231lfn.159.1550605596211;
 Tue, 19 Feb 2019 11:46:36 -0800 (PST)
MIME-Version: 1.0
References: <5C6B997B.8050203@tlinx.org>
In-Reply-To: <5C6B997B.8050203@tlinx.org>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 19 Feb 2019 11:46:24 -0800
Message-ID: <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com>
Subject: Re: regressions & flakiness make for ugly symlink links
To:     L A Walsh <cifs@tlinx.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 18 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 22:16, L A W=
alsh <cifs@tlinx.org>:
>
>
> In my Windows root directory I have several links.  This is how
> they look on the Windows machine's "root".  Several months ago I
> sent an email to this list complimenting you on how they looked.
> (without user+group)
>
> > ll |grep -- '->'
> lrwxrwxrwx   1           17 Jun 13  2016 Documents -> //Bliss/Documents/
> lrwxrwxrwx   1            6 Jul 13  2009 Documents and Settings -> /Users=
/
> lrwxrwxrwx   1           16 Jun  5  2015 FolderChanger -> /m/FolderChange=
r/
> lrwxrwxrwx   1            5 May 13  2017 Home -> Users/
> lrwxrwxrwx   1           20 Nov  6  2014 Prog -> /Program Files (x86)/
> lrwxrwxrwx   1           13 Apr 21  2013 Prog64 -> Program Files/
> lrwxrwxrwx   1           12 Aug  9  2015 ProgD -> /ProgramData/
> lrwxrwxrwx   1            2 Apr 17  2017 Share -> /s/
> lrwxrwxrwx   1           22 Aug 22 16:08 Symbols -> //Bliss/Share/Symbols=
//
> lrwxrwxrwx   1            7 Mar  1  2018 WINNT -> Windows/
> lrwxrwxrwx   1            3 May 13  2017 lib64 -> lib/
> lrwxrwxrwx   1            3 Jan 12  2014 temp -> tmp/
>
> Now, I'm getting flakiresults -- with them not resolving 1 time,
> then resolving,  then not again...etc.  By flakey I mean
> output like random can't access messages, followed by question
> marks in all fields of links.
>
> # ll|more
> ls: cannot access 'D': Operation not supported
> ls: cannot access 'Documents': Operation not supported
> ls: cannot access 'FolderChanger': Operation not supported
> ls: cannot access 'Home': Operation not supported
> ls: cannot access 'lib64': Operation not supported
> ls: cannot access 'M': Operation not supported
> ls: cannot access 'P': Operation not supported
> ls: cannot access 'pagefile.sys': Device or resource busy
> ls: cannot access 'Prog64': Operation not supported
> ls: cannot access 'Share': Operation not supported
> ls: cannot access 'temp': Operation not supported
> ls: cannot access 'WINNT': Operation not supported
> d????????? ?       ?            ? D/
> d????????? ?       ?            ? Documents/
> d????????? ?       ?            ? FolderChanger/
> d????????? ?       ?            ? Home/
> d????????? ?       ?            ? M/
> d????????? ?       ?            ? P/
> d????????? ?       ?            ? Prog64/
> d????????? ?       ?            ? Share/
> d????????? ?       ?            ? WINNT/
> d????????? ?       ?            ? lib64/
> d????????? ?       ?            ? temp/
>
> Depending on timing, Sometimes I will get most or all of
> them appearing the same as they would on windows.
>
> If I can't resolve them more quickly, is there a know
> or two to increase cache size and item lifetime?
>
> Thanks
>

Which kernel version shows symlinks right and which - wrong?

--
Best regards,
Pavel Shilovsky
