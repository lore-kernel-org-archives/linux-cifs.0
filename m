Return-Path: <SRS0=5iq/=YC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718F8ECE58D
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 13:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E5C6206BB
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 13:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfJIN5y convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Oct 2019 09:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbfJIN5x (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 9 Oct 2019 09:57:53 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30B0C368FF
        for <linux-cifs@vger.kernel.org>; Wed,  9 Oct 2019 13:57:53 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id w198so2105899qka.0
        for <linux-cifs@vger.kernel.org>; Wed, 09 Oct 2019 06:57:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OMsgE8P+LJOeRnB7Qu3oymdAG2DDyrodWuRE6dqPbF0=;
        b=Y97qEtKvhglvc9I12S1osWf83lyy6M3lgN2D40TaxQ1dj+gqXU4kF2W4OJd9x0vxTa
         ZaR5KDe06tCXNcM6pCV2dLGPfz4kXoL2o6XM7WfX1C6DihoBbSBn/tvPsagOTgGEqLfq
         KWhO5Mc8ybIOvJsi5hGjNsWghN9eg+9/TGdaFmaGFnigT/hPfMHNOKpRb3dHo3Km3Bm1
         G8xRMQ7JTSX5A7bsttocCUdli/305IqkFNDtL61tRY4qXwf/SirWFwDplD3xEfEDQQQK
         fxTWQI17GoJL2AGvEDI6rukNAsfAsqZnXEYTK9WW99gpCit+r+oJP6IsFnSHXyddM2iP
         8T0Q==
X-Gm-Message-State: APjAAAW1h6j8plYge0mEi5ouTWm3TferuWzQXVZLqv+ThRfW+yLJyE7N
        ZZ+xCAePO1svq1EzCfelmqtxruOg24iI7HHTghP+8ikLzPzUlQ7qp+9nsVkg8BNqawKkUrddUnR
        kJBm3sikDo7rOoQFF+NtUe8/quBU5iqoIg1Y6Xg==
X-Received: by 2002:aed:23b1:: with SMTP id j46mr3814325qtc.188.1570629472424;
        Wed, 09 Oct 2019 06:57:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzjDvT7Bz+B2eS0wbjqNokq2inion8jjrmtkV+kp+LL8Ch/IgNEK0mt/IuKL525r/rnmq7bXnVGG9jXWE96tgY=
X-Received: by 2002:aed:23b1:: with SMTP id j46mr3814305qtc.188.1570629472145;
 Wed, 09 Oct 2019 06:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190924045611.21689-1-kdsouza@redhat.com> <87o8yqf4f6.fsf@suse.com>
In-Reply-To: <87o8yqf4f6.fsf@suse.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Wed, 9 Oct 2019 19:27:40 +0530
Message-ID: <CAA_-hQL+2nn6N7ig13onQpnDdTC2Ceb1Z6TSnsJCRdJYLYCiFg@mail.gmail.com>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Can you try the new updated patch?
Some of the suggested changes have been incorporated.
Pavel picked up the new changes from my github repo.
https://github.com/piastry/cifs-utils/commits/next

I will send a follow-on patch to work on the remaining changes.

On Wed, Oct 9, 2019 at 6:43 PM Aurélien Aptel <aaptel@suse.com> wrote:
>
>
> We now have 2 user scripts in the repo but the configure script doesn't
> know about them: they are not installed. If they are considered dev
> tools or experimental that's fine otherwise we should consider
> installing them on make install. I just wanted to point this out.
>
> A bit late but some comments on the script.
>
> Kenneth D'souza <kdsouza@redhat.com> writes:
> > +#!/usr/bin/env python
>
> We should script for python3 at this point I think. Python2 is on the
> way out.
>
> > +def usage():
> > +    print("Usage: %s [-h] <options>  <filename>" % sys.argv[0])
> > +    print("Try 'smb2quota -h' for more information")
> > +    sys.exit()
>
> argparse already generates usage message from its conf.
>
> > +
> > +def parser_check(path, flag):
> > +    titleused = "Amount Used"
> > +    titlelim = "Quota Limit"
> > +    titlethr = "Warning Level"
> > +    titlesid = "SID"
> > +    buf = array.array('B', [0] * 16384)
> > +    struct.pack_into('<I', buf, 0, 4)  # InfoType: Quota
> > +    struct.pack_into('<I', buf, 16, 16384)  # InputBufferLength
> > +    struct.pack_into('<I', buf, 20, 16)  # OutputBufferLength
> > +    struct.pack_into('b', buf, 24, 0)  # return single
> > +    struct.pack_into('b', buf, 25, 1)  # return single
> > +    try:
> > +        f = os.open(path, os.O_RDONLY)
> > +        fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
> > +        os.close(f)
> > +        if flag == 0:
> > +            print(BBOLD + " %-7s | %-7s | %-7s | %s " + ENDC) % (titleused, titlelim, titlethr, titlesid)
> > +        q = Quota(buf[24:24 + struct.unpack_from('<I', buf, 16)[0]], flag)
> > +        print(q)
> > +    except IOError as reason:
> > +        print("ioctl failed: %s" % reason)
> > +    except OSError as reason:
> > +        print("ioctl failed: %s" % reason)
> > +
> > +
> > +def main():
> > +    if len(sys.argv) < 2:
> > +        usage()
> > +
> > +    parser = argparse.ArgumentParser(description="Please specify an action to perform.", prog="smb2quota")
>
> description is used to generate a useful help/usage message. Maybe use
> "tool to display quota information for the Linux SMB client file system (CIFS)"
>
> > +    parser.add_argument("-tabular", "-t", metavar="", help="Print quota information in tabular format")
> > +    parser.add_argument("-csv", "-c", metavar="", help="Print quota information in csv format")
> > +    parser.add_argument("-list", "-l", metavar="", help="Print quota information in list format")
>
> * I think we should use 2 dashes (i.e. "--tabular") for long options.
> * For boolean flags, action="store_true" is what you want
> * You can put let argparse know about the path arg, and then use args.path
>
>     parser.add_argument("--tabular", "-t", action="store_true", help="Print quota information in tabular format")
>     parser.add_argument("--csv", "-c", action="store_true", help="Print quota information in csv format")
>     parser.add_argument("--list", "-l", action="store_true", help="Print quota information in list format")
>     parser.add_argument("path", help="Path to query")
>
> Cheers,
> --
> Aurélien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
> GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
