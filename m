Return-Path: <SRS0=JIor=ZZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70165C432C0
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Dec 2019 22:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3342320684
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Dec 2019 22:16:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPQC4C82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfLCWQm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Dec 2019 17:16:42 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:39069 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfLCWQl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Dec 2019 17:16:41 -0500
Received: by mail-io1-f44.google.com with SMTP id c16so5661633ioh.6
        for <linux-cifs@vger.kernel.org>; Tue, 03 Dec 2019 14:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LH7cMl3ZB9eQQPmmyekfW4dnd44DFrMWxyoA3nmuUu0=;
        b=RPQC4C82+xE8/g+Ulwtcb8assl9oCcKvRnqL9nnadRGXj4DtPGPsFpjU9xJ8odi4f4
         sOys1jbTTnJBsJVFReNxLMyHeXpVDy2Wr/nJRHR2XxkO3GQEMAvCNV6YDAxY+hVirZk0
         F2K/hzB6QXubvxsE2ugi5DjMPCXHrTnqDuyOoOiPwAU6nOZHE3HZxmcaHYAEwTkBr6lY
         e+csarw9d3x+1mPfC1XlE3ue47UAdyymbKthGUzXWjrIDtkpua9FN5VtBvWFINIYmkdf
         Z2uVPNr59MXPBXSHWBSSHDKsKdeCbvMfKQIfoAcy2HJ1yOku3WAjK/3zY4Q76+OEFN+a
         pttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LH7cMl3ZB9eQQPmmyekfW4dnd44DFrMWxyoA3nmuUu0=;
        b=nkVFWyoE3Ne3gU2VTWsWqVD87Xt/jwEzgMfgOfODx3YqVU0dURUZ/tR39Gevc8vsX5
         XbttzeT04oN2uwhzKnvnUJCp0K668hyfuNQuVb2V5A969yJlmfOD2syomtKFYudXG9Hh
         Q+GsOsWmTtk3sjhnWH+5ahu/3XUucZ5qQCRoiw7/wLo2VbEE20M2rJFqk/DZPGqB0tdj
         sWKiE8qH7NLweEWb01clDbHEVxyxYjxmDLVwvQT4N4Nz3GbtspGURl9Yeda/nsLd0o5Y
         22KElDUPBZSrUkvuZKEVWCd0YYqb1+gGQukafWY2o/0IsWPujXZf4cqFHOHO27kldhNz
         4b7g==
X-Gm-Message-State: APjAAAXgJUNSDvj5Lz5NngkF/4PLYIns59glkL+FHIuFvrkYgzvafaR5
        XFbJCa2GoTpYzSyMq1+85vaq4QbPuNE4vsQ63+KSrQ==
X-Google-Smtp-Source: APXvYqz0zbB8dqauQ+Huv6sA7aw6TXMGd4OU+IptGAxy11tUTeAi7rhOtSrpYVRHDbGalTeXUMJ170Ifnq4RF4FbbuM=
X-Received: by 2002:a6b:6310:: with SMTP id p16mr373190iog.5.1575411400598;
 Tue, 03 Dec 2019 14:16:40 -0800 (PST)
MIME-Version: 1.0
References: <5a987faff74646e68207e26e570a708669dd4103.camel@inogs.it>
In-Reply-To: <5a987faff74646e68207e26e570a708669dd4103.camel@inogs.it>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 Dec 2019 16:16:29 -0600
Message-ID: <CAH2r5mu5dedRmPQzRUH=E87J2txsBv3DiFYZLT-a_xYay=2czA@mail.gmail.com>
Subject: Re: Permission denied mounting a DFS share with multiuser options
To:     abrosich@inogs.it
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Have you experimented with a newer kernel (e.g. Ubuntu 19 or the
download from the Ubuntu mainline kernel download site) to see if some
of Paulo's DFS fixes (e.g. a large set went in last year) help.

On Wed, Nov 27, 2019 at 6:20 AM <abrosich@inogs.it> wrote:
>
>
> Hello,
>
> I'm trying to configure a linux client (Unubtu 18.04.3) to mount a DFS
> share from a windows server 2019. Both machines are joined in the same
> Active Directory domain. I joined the linux client using the "realm"
> command and it works fine: for example I can login with ssh using AD
> credentials.
>
> The package cifs-utils is version 6.8.
>
> I start by saying that I have a little konwledge of the windows world
> and in particular of SMB, hence my question could by silly but I
> searched for days without find any solution.
>
> I found the following entries in the krb5.conf file (I suppose added by
> "realm" coomand):
> 3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (des-cbc-crc)
>    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (des-cbc-md5)
>    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (arcfour-hmac)
>    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (aes128-cts-hmac-
> sha1-96)
>    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (aes256-cts-hmac-
> sha1-96)
>    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (des-cbc-crc)
>    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (des-cbc-md5)
>    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (arcfour-hmac)
>    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (aes128-cts-hmac-
> sha1-96)
>    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (aes256-cts-hmac-
> sha1-96)
>
> I created on the Domain Controller a user principal "linuxclientuser-
> cifs" and associated to it an SPN "cifs/linuxclient.fqdn@AD.DOMAIN". I
> exported the keytab file and added it in krb5.keytab where I have now
> the followind entries:
>
>   3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (des-cbc-crc)
>    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (des-cbc-md5)
>    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (arcfour-hmac)
>    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (aes256-cts-
> hmac-sha1-96)
>    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (aes128-cts-
> hmac-sha1-96)
>
>
> I use the following command to mount the share:
> sudo mount --verbose --types cifs //winsrv/CifsShare /mnt/cifs --
> options
> sec=krb5,multiuser,vers=3,user=cifs/linuxclient.fqdn,domain=AD.DOMAIN
>
> and the response is: "mount error(13): Permission denied"
>
> Looking at logs I find:
> Nov 27 13:07:18 linuxclient cifs.upcall: key description:
> cifs.spnego;0;0;39010000;ver=0x2;host=winsrv;ip4=XXX.XXX.XXX.XXX;sec=kr
> b5;uid=0x0;creduid=0x0;user=cifs/linuxclient.fqdn;pid=0x6ac
> Nov 27 13:07:18 linuxclient cifs.upcall: ver=2
> Nov 27 13:07:18 linuxclient cifs.upcall: host=winsrv
> Nov 27 13:07:18 linuxclient cifs.upcall: ip=XXX.XXX.XXX.XXX
> Nov 27 13:07:18 linuxclient cifs.upcall: sec=1
> Nov 27 13:07:18 linuxclient cifs.upcall: uid=0
> Nov 27 13:07:18 linuxclient cifs.upcall: creduid=0
> Nov 27 13:07:18 linuxclient cifs.upcall: user=cifs/linuxclient.fqdn
> Nov 27 13:07:18 linuxclient cifs.upcall: pid=1708
> Nov 27 13:07:18 linuxclient cifs.upcall:
> get_cachename_from_process_env: pid == 0
> Nov 27 13:07:18 linuxclient cifs.upcall: get_existing_cc: default
> ccache is FILE:/tmp/krb5cc_0
> Nov 27 13:07:18 linuxclient cifs.upcall: get_tgt_time: unable to get
> principal
> Nov 27 13:07:18 linuxclient cifs.upcall: handle_krb5_mech: getting
> service ticket for winsrv
> Nov 27 13:07:18 linuxclient cifs.upcall: handle_krb5_mech: obtained
> service ticket
> Nov 27 13:07:18 linuxclient cifs.upcall: Exit status 0
>
>
> where it says that it get the service ticket (I can see it sniffing
> packets with wireshark) but it is "unable to get principal". Which
> principal?
>
> On the server side I have the following error:
>
> A process has requested access to an object, but has not been granted
> those access rights. (0xC0000022)
> SPN: session setup failed before the SPN could be queried
> SPN Validation Policy: SPN optional / no validation
>
>
> What I'm doing wrong?
>
> Any suggest is welcome.
>
> Best regards
>
> Alberto
>
>


-- 
Thanks,

Steve
