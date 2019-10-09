Return-Path: <SRS0=5iq/=YC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E537C47404
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 13:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8DA206B6
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 13:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfJINNE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Oct 2019 09:13:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37118 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731133AbfJINNE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 9 Oct 2019 09:13:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 621D4B16B;
        Wed,  9 Oct 2019 13:13:02 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Kenneth D'souza <kdsouza@redhat.com>, piastryyy@gmail.com,
        smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     lsahlber@redhat.com
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
In-Reply-To: <20190924045611.21689-1-kdsouza@redhat.com>
References: <20190924045611.21689-1-kdsouza@redhat.com>
Date:   Wed, 09 Oct 2019 15:13:01 +0200
Message-ID: <87o8yqf4f6.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


We now have 2 user scripts in the repo but the configure script doesn't
know about them: they are not installed. If they are considered dev
tools or experimental that's fine otherwise we should consider
installing them on make install. I just wanted to point this out.

A bit late but some comments on the script.

Kenneth D'souza <kdsouza@redhat.com> writes:
> +#!/usr/bin/env python

We should script for python3 at this point I think. Python2 is on the
way out.

> +def usage():
> +    print("Usage: %s [-h] <options>  <filename>" % sys.argv[0])
> +    print("Try 'smb2quota -h' for more information")
> +    sys.exit()

argparse already generates usage message from its conf.

> +
> +def parser_check(path, flag):
> +    titleused = "Amount Used"
> +    titlelim = "Quota Limit"
> +    titlethr = "Warning Level"
> +    titlesid = "SID"
> +    buf = array.array('B', [0] * 16384)
> +    struct.pack_into('<I', buf, 0, 4)  # InfoType: Quota
> +    struct.pack_into('<I', buf, 16, 16384)  # InputBufferLength
> +    struct.pack_into('<I', buf, 20, 16)  # OutputBufferLength
> +    struct.pack_into('b', buf, 24, 0)  # return single
> +    struct.pack_into('b', buf, 25, 1)  # return single
> +    try:
> +        f = os.open(path, os.O_RDONLY)
> +        fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
> +        os.close(f)
> +        if flag == 0:
> +            print(BBOLD + " %-7s | %-7s | %-7s | %s " + ENDC) % (titleused, titlelim, titlethr, titlesid)
> +        q = Quota(buf[24:24 + struct.unpack_from('<I', buf, 16)[0]], flag)
> +        print(q)
> +    except IOError as reason:
> +        print("ioctl failed: %s" % reason)
> +    except OSError as reason:
> +        print("ioctl failed: %s" % reason)
> +
> +
> +def main():
> +    if len(sys.argv) < 2:
> +        usage()
> +
> +    parser = argparse.ArgumentParser(description="Please specify an action to perform.", prog="smb2quota")

description is used to generate a useful help/usage message. Maybe use
"tool to display quota information for the Linux SMB client file system (CIFS)"

> +    parser.add_argument("-tabular", "-t", metavar="", help="Print quota information in tabular format")
> +    parser.add_argument("-csv", "-c", metavar="", help="Print quota information in csv format")
> +    parser.add_argument("-list", "-l", metavar="", help="Print quota information in list format")

* I think we should use 2 dashes (i.e. "--tabular") for long options.
* For boolean flags, action="store_true" is what you want
* You can put let argparse know about the path arg, and then use args.path

    parser.add_argument("--tabular", "-t", action="store_true", help="Print quota information in tabular format")
    parser.add_argument("--csv", "-c", action="store_true", help="Print quota information in csv format")
    parser.add_argument("--list", "-l", action="store_true", help="Print quota information in list format")
    parser.add_argument("path", help="Path to query")

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
