Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA05DC47404
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 18:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D312077B
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 18:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXjohjjK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfJDSnn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Oct 2019 14:43:43 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45318 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfJDSnn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Oct 2019 14:43:43 -0400
Received: by mail-lf1-f68.google.com with SMTP id r134so5141351lff.12
        for <linux-cifs@vger.kernel.org>; Fri, 04 Oct 2019 11:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YSDRFl52GFWGI04MQIAO+HwptcNoPyl7ywBMJawSE5c=;
        b=gXjohjjK4MaVNqR2wEtAk9EHovhCgx2ESvB6xP32g6WG+/ixz/ufDZSeQxkFilP54R
         uj4Hu1l/EFDAQ+L3ElBsGpoKQVllH99Ia9BdE5Cv+v3S5q7KEkTXNUTXPxLxEYhZLom1
         S+Ik5vgWGRAe6N5HDGoE1fajRY3njq7N4plTe1df16PXApdstnFX/5f38b8Y+1Av5kGC
         48sfBSuvxI6GI6jhj6sBaqdtyVgQu8IdA9wIqTnhcxyhxPUOh+DA4zA/+S3w4YRnU/HV
         Ymv9OTm+2+PlkW2zM6JZNKyh5oWboQj/S6itAZ3Mdbe49cvfrZkyDBzqSsGnZiIJTHz5
         r6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YSDRFl52GFWGI04MQIAO+HwptcNoPyl7ywBMJawSE5c=;
        b=LpJ2jtesw67ZCjKuKhb1vYJBDhkfZqr/6PDhy8Zt6NUvercyX7cXHvV5MTtNZGuFN9
         AmTwWuTOawewTKt+Gwb0iGXWRCJD5MDY+27AEm9qgvnhZxQWSP41+An/QLLu3k51q75U
         gJb27v+ko/AFT2XJZ4pV/DVtFNeQhe9YTBH6oF3P/7EOLGDpvVqL1HrKb+bZ6xpOJOxP
         nwcjmAU4V8DSqN9BLzkNvbq3DTj0vdVcA7+OH5nXx3nhqD+C57JrFuZYqIh9QTh0PmZM
         +RVpT9+COOixBs+BWDizzYG1my1SVDBfS/a7fRbh1RNVxxJrf/h9LECP+Rhc5wJN0jvv
         dJbg==
X-Gm-Message-State: APjAAAV4iVMW4SKp2Jl590ZVRMI2H7pp/UZpbnkU8ZXoQ+8a3MrWk1Bs
        KFGrnuhDH/VtTzalrH1xFUad52yTvutG3m9juQ==
X-Google-Smtp-Source: APXvYqzMp8CGK3JNCsZygs/n1INpIQeceAIT5UFx5ncy6KGvmKtCuNeGv6DOn2MwcR3XqUxcYHfvzaDF0t+HJhlRL1Q=
X-Received: by 2002:ac2:4196:: with SMTP id z22mr9446217lfh.54.1570214619174;
 Fri, 04 Oct 2019 11:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190924045611.21689-1-kdsouza@redhat.com>
In-Reply-To: <20190924045611.21689-1-kdsouza@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 4 Oct 2019 11:43:28 -0700
Message-ID: <CAKywueQhMtWWpPWCYC2Vp44OtY+uZS7yY+kTh20jVMOso2Qckg@mail.gmail.com>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. thanks.
--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 23 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 21:56, Kenne=
th D'souza <kdsouza@redhat.com>:
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  smb2quota.py | 172 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 172 insertions(+)
>  create mode 100755 smb2quota.py
>
> diff --git a/smb2quota.py b/smb2quota.py
> new file mode 100755
> index 0000000..11d98db
> --- /dev/null
> +++ b/smb2quota.py
> @@ -0,0 +1,172 @@
> +#!/usr/bin/env python
> +# coding: utf-8
> +#
> +# smb2quota is a cmdline tool to display quota information for the
> +# Linux SMB client file system (CIFS)
> +#
> +# Copyright (C) Ronnie Sahlberg (lsahlberg@redhat.com) 2019
> +# Copyright (C) Kenneth D'souza (kdsouza@redhat.com) 2019
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License as published by
> +# the Free Software Foundation; either version 2 of the License, or
> +# (at your option) any later version.
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +# GNU General Public License for more details.
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write to the Free Software
> +# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 US=
A
> +
> +
> +import array
> +import fcntl
> +import os
> +import struct
> +import sys
> +import argparse
> +
> +CIFS_QUERY_INFO =3D 0xc018cf07
> +BBOLD =3D '\033[1;30;47m'   # Bold black text with white background.
> +ENDC =3D '\033[m'   # Rest to defaults
> +
> +
> +def usage():
> +    print("Usage: %s [-h] <options>  <filename>" % sys.argv[0])
> +    print("Try 'smb2quota -h' for more information")
> +    sys.exit()
> +
> +
> +class SID:
> +    def __init__(self, buf):
> +        self.sub_authority_count =3D buf[1]
> +        self.buffer =3D buf[:8 + self.sub_authority_count * 4]
> +        self.revision =3D self.buffer[0]
> +        if self.revision !=3D 1:
> +            raise ValueError('SID Revision %d not supported' % self.revi=
sion)
> +        self.identifier_authority =3D 0
> +        for x in self.buffer[2:8]:
> +            self.identifier_authority =3D self.identifier_authority * 25=
6 + x
> +        self.sub_authority =3D []
> +        for i in range(self.sub_authority_count):
> +            self.sub_authority.append(struct.unpack_from('<I', self.buff=
er, 8 + 4 * i)[0])
> +
> +    def __str__(self):
> +        s =3D "S-%u-%u" % (self.revision, self.identifier_authority)
> +        for x in self.sub_authority:
> +            s +=3D '-%u' % x
> +        return s
> +
> +
> +def convert(num):  # Convert bytes to closest human readable UNIT.
> +    for unit in ['', 'kiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB']:
> +        if abs(num) < 1024.0:
> +            return "%3.1f %s" % (num, unit)
> +        num /=3D 1024.0
> +
> +
> +class QuotaEntry:
> +    def __init__(self, buf, flag):
> +        sl =3D struct.unpack_from('<I', buf, 4)[0]
> +        self.sid =3D SID(buf[40:40 + sl])
> +        self.used =3D struct.unpack_from('<Q', buf, 16)[0]
> +        self.thr =3D struct.unpack_from('<Q', buf, 24)[0]
> +        self.lim =3D struct.unpack_from('<Q', buf, 32)[0]
> +        self.a =3D (convert(self.used))
> +        self.b =3D (convert(self.thr))
> +        self.c =3D (convert(self.lim))
> +        self.flag =3D flag
> +
> +    def __str__(self):
> +        if self.flag =3D=3D 0:
> +            s =3D " %-11s | %-11s | %-13s | %s" % (self.a, self.c, self.=
b, self.sid)
> +        elif self.flag =3D=3D 1:
> +            s =3D "%s,%d,%d,%d" % (self.sid, self.used, self.lim, self.t=
hr)
> +        else:
> +            s =3D 'SID:%s\n' % self.sid
> +            s +=3D 'Quota Used:%d\n' % self.used
> +            if self.thr =3D=3D 0xffffffffffffffff:
> +                s +=3D 'Quota Threshold Limit:NO_WARNING_THRESHOLD\n'
> +            else:
> +                s +=3D 'Quota Threshold Limit:%d\n' % self.thr
> +            if self.lim =3D=3D 0xffffffffffffffff:
> +                s +=3D 'Quota Limit:NO_LIMIT\n'
> +            else:
> +                s +=3D 'Quota Limit:%d\n' % self.lim
> +        return s
> +
> +
> +class Quota:
> +    def __init__(self, buf, flag):
> +        self.quota =3D []
> +        s =3D struct.unpack_from('<I', buf, 0)[0]
> +        while s:
> +            qe =3D QuotaEntry(buf[0:s], flag)
> +            self.quota.append(qe)
> +            buf =3D buf[s:]
> +            a =3D s
> +            s =3D struct.unpack_from('<I', buf, 0)[0]
> +            if s =3D=3D 0:
> +                s =3D a   # Use the last value of s and process it.
> +                qe =3D QuotaEntry(buf[0:s], flag)
> +                self.quota.append(qe)
> +                break
> +
> +    def __str__(self):
> +        s =3D ''
> +        for q in self.quota:
> +            s +=3D '%s\n' % q
> +        return s
> +
> +
> +def parser_check(path, flag):
> +    titleused =3D "Amount Used"
> +    titlelim =3D "Quota Limit"
> +    titlethr =3D "Warning Level"
> +    titlesid =3D "SID"
> +    buf =3D array.array('B', [0] * 16384)
> +    struct.pack_into('<I', buf, 0, 4)  # InfoType: Quota
> +    struct.pack_into('<I', buf, 16, 16384)  # InputBufferLength
> +    struct.pack_into('<I', buf, 20, 16)  # OutputBufferLength
> +    struct.pack_into('b', buf, 24, 0)  # return single
> +    struct.pack_into('b', buf, 25, 1)  # return single
> +    try:
> +        f =3D os.open(path, os.O_RDONLY)
> +        fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
> +        os.close(f)
> +        if flag =3D=3D 0:
> +            print(BBOLD + " %-7s | %-7s | %-7s | %s " + ENDC) % (titleus=
ed, titlelim, titlethr, titlesid)
> +        q =3D Quota(buf[24:24 + struct.unpack_from('<I', buf, 16)[0]], f=
lag)
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
> +    parser =3D argparse.ArgumentParser(description=3D"Please specify an =
action to perform.", prog=3D"smb2quota")
> +    parser.add_argument("-tabular", "-t", metavar=3D"", help=3D"Print qu=
ota information in tabular format")
> +    parser.add_argument("-csv", "-c", metavar=3D"", help=3D"Print quota =
information in csv format")
> +    parser.add_argument("-list", "-l", metavar=3D"", help=3D"Print quota=
 information in list format")
> +    args =3D parser.parse_args()
> +
> +    if args.tabular:
> +        path =3D args.tabular
> +        parser_check(path, 0)
> +
> +    if args.csv:
> +        path =3D args.csv
> +        parser_check(path, 1)
> +
> +    if args.list:
> +        path =3D args.list
> +        parser_check(path, 2)
> +
> +
> +if __name__ =3D=3D "__main__":
> +    main()
> --
> 2.21.0
>
