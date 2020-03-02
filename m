Return-Path: <SRS0=r9u8=4T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE74C3F2D1
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Mar 2020 14:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DE12173E
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Mar 2020 14:12:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inogs-it.20150623.gappssmtp.com header.i=@inogs-it.20150623.gappssmtp.com header.b="b7o+0sGK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgCBOMB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Mar 2020 09:12:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38013 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgCBOMB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 Mar 2020 09:12:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id u9so4923841wml.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Mar 2020 06:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=inogs-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=hq5BeSBAvnG3VbKtr9WPya65JMfTAxDuZMFwpGZsotQ=;
        b=b7o+0sGKtITFb4uiur/e2MXrwQjwFGRzo3ZuUcyvs2jOcWRRRN3CM86h04b+sQIyyo
         eBedU+PKGSbJLJVBIe5XrpbhJnKlQ+k+xv8t3NfjOiXIQno3CtXzQLoVSF7znwhGGsVl
         75jr0eqsGQ+uUd1ns8WJwFG3b3ov6utHvQTiw2B6GpAf3+l7SlMb5ZKd0/aDKMAfbL2O
         M8vtNwPL2qsMI2VdAIdW0J7Qsfr1B8ojFH/oI2XLYoLfm7FUnOZR6vEJwF+MYbf7p3Yt
         7eDh7mgDe6V9KeCz5xINKV3CaCqY9j7p6dIexdglalCIvV8bOg83pmpRNy3PlzLR3VsY
         /yZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hq5BeSBAvnG3VbKtr9WPya65JMfTAxDuZMFwpGZsotQ=;
        b=tf+HKx0564RFjBQNAnB6CVUmuYcQ9mdo7Ou6isHVeqkZ85tEbx5rRMcgu6Fmg+iTTE
         Bwph6Smkj5J1+z7S8D3j5DEwcXqCf3Tsl8HIB0j4dgh1kLKS54gD9aWxjSs5gPiUE0lg
         DmeN3XcndNYOM9ZCGoaLX6YXEJOHUgDVADvhJI0d0ISzrZmPxhTnq5UAVZ50XqB1/sCC
         +cNvIJHUh81rKMHKOoxyb+A6QB2+hfKLIq3wMoKBYl7SDQjw6jN//FnRtFDvQolKWecB
         a1Obw8os7zuUAwXV+kmqVIfwQqKtUKQ8YiAa4TH/xQipAEpVoxpt6sSX77jTDUH4tb43
         I8bA==
X-Gm-Message-State: APjAAAVeNQfa7+3RrfgULR+mSfYshRFpDOaqitExmc+D7h8hfubcln7n
        P8CLrotON4jqPS6ZVMRxBXm2/V6RApp19qrWUFtwhJ75hOFCfv8CDdQtfa7qzDUkDE14kj+n+4A
        H6WeMHL1Rbeyjm3aUnxPZCUP2PWLV9O7b2jFwoKh8O4OwgxDHNXxqWW2hHB8YPWXxcLJNyZdl
X-Google-Smtp-Source: APXvYqys8kwxqOukl/4+PS7YTKvC/e59DGb3yWyz+Xszdh/PT4V27cdEQeYdm53R/6Xj76ZUU7RkUQ==
X-Received: by 2002:a05:600c:10d2:: with SMTP id l18mr19667851wmd.122.1583158317168;
        Mon, 02 Mar 2020 06:11:57 -0800 (PST)
Received: from deimos.ogs.trieste.it (deimos.ogs.trieste.it. [140.105.70.97])
        by smtp.gmail.com with ESMTPSA id i18sm25140743wrv.30.2020.03.02.06.11.56
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 06:11:56 -0800 (PST)
Message-ID: <4c74eb81aa7757e48679eb83c2f2dcbfeb841a3f.camel@inogs.it>
Subject: Re: Permission denied mounting a DFS share with multiuser options
From:   abrosich@inogs.it
To:     CIFS <linux-cifs@vger.kernel.org>
Date:   Mon, 02 Mar 2020 15:11:55 +0100
In-Reply-To: <CAH2r5mu5dedRmPQzRUH=E87J2txsBv3DiFYZLT-a_xYay=2czA@mail.gmail.com>
References: <5a987faff74646e68207e26e570a708669dd4103.camel@inogs.it>
         <CAH2r5mu5dedRmPQzRUH=E87J2txsBv3DiFYZLT-a_xYay=2czA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hello Steve,
after a while I'am trying again to find a solution.

I've changed the environment.
The linux client now is a Debian machine with testing flavour to have the latest
versions of the involved softwares. These are the versions of some of them:

Kernel: #1 SMP Debian 5.4.19-1 (2020-02-13)
cifs.upcall: version: 6.9
keyutils: keyctl from keyutils-1.6.1 (Built 2020-02-10)
sssd: 2.2.3
cifs module: 2.23

The linux machine is joined in the AD domain. I can log on using ssh as domain
user and I can use smbclient with "-k" option after obtaining a ticket using
"kinit".

When I try to do a mount

mount --type cifs --verbose //server.domain/ShareName /mountpoint --options
sec=krb5i,username=domainuser,domain=ad.domain

I receive the following error:
mount error(2): No such file or directory

and dmesg gives:

CIFS VFS: \\server.domain Send error in SessSetup = -126
fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 54) rc = -126
...
CIFS VFS: cifs_mount failed w/return code = -2

Raising log level as in 
https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting gives (to me) no
useful information about the cause.

What does it mean "Send error in SessSetup"? And error -126?

In the event viewer of the windows server I cannot find any event related to it.

I sniffed the ethernet conversation using wireshark. The conversation is quite
short (9 packets). The client closes it with a FIN,ACK after receiving a good
SMB Negotiate Protocol Response that seems good to me. The version of the
protocol is correctly set (3.1.1 when it is not specified).

Any suggest?

Best regards

Alberto


On Tue, 2019-12-03 at 16:16 -0600, Steve French wrote:
> Have you experimented with a newer kernel (e.g. Ubuntu 19 or the
> download from the Ubuntu mainline kernel download site) to see if some
> of Paulo's DFS fixes (e.g. a large set went in last year) help.
> 
> On Wed, Nov 27, 2019 at 6:20 AM <abrosich@inogs.it> wrote:
> > 
> > Hello,
> > 
> > I'm trying to configure a linux client (Unubtu 18.04.3) to mount a DFS
> > share from a windows server 2019. Both machines are joined in the same
> > Active Directory domain. I joined the linux client using the "realm"
> > command and it works fine: for example I can login with ssh using AD
> > credentials.
> > 
> > The package cifs-utils is version 6.8.
> > 
> > I start by saying that I have a little konwledge of the windows world
> > and in particular of SMB, hence my question could by silly but I
> > searched for days without find any solution.
> > 
> > I found the following entries in the krb5.conf file (I suppose added by
> > "realm" coomand):
> > 3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (des-cbc-crc)
> >    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (des-cbc-md5)
> >    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (arcfour-hmac)
> >    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (aes128-cts-hmac-
> > sha1-96)
> >    3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (aes256-cts-hmac-
> > sha1-96)
> >    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (des-cbc-crc)
> >    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (des-cbc-md5)
> >    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (arcfour-hmac)
> >    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (aes128-cts-hmac-
> > sha1-96)
> >    3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (aes256-cts-hmac-
> > sha1-96)
> > 
> > I created on the Domain Controller a user principal "linuxclientuser-
> > cifs" and associated to it an SPN "cifs/linuxclient.fqdn@AD.DOMAIN". I
> > exported the keytab file and added it in krb5.keytab where I have now
> > the followind entries:
> > 
> >   3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (des-cbc-crc)
> >    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (des-cbc-md5)
> >    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (arcfour-hmac)
> >    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (aes256-cts-
> > hmac-sha1-96)
> >    3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (aes128-cts-
> > hmac-sha1-96)
> > 
> > 
> > I use the following command to mount the share:
> > sudo mount --verbose --types cifs //winsrv/CifsShare /mnt/cifs --
> > options
> > sec=krb5,multiuser,vers=3,user=cifs/linuxclient.fqdn,domain=AD.DOMAIN
> > 
> > and the response is: "mount error(13): Permission denied"
> > 
> > Looking at logs I find:
> > Nov 27 13:07:18 linuxclient cifs.upcall: key description:
> > cifs.spnego;0;0;39010000;ver=0x2;host=winsrv;ip4=XXX.XXX.XXX.XXX;sec=kr
> > b5;uid=0x0;creduid=0x0;user=cifs/linuxclient.fqdn;pid=0x6ac
> > Nov 27 13:07:18 linuxclient cifs.upcall: ver=2
> > Nov 27 13:07:18 linuxclient cifs.upcall: host=winsrv
> > Nov 27 13:07:18 linuxclient cifs.upcall: ip=XXX.XXX.XXX.XXX
> > Nov 27 13:07:18 linuxclient cifs.upcall: sec=1
> > Nov 27 13:07:18 linuxclient cifs.upcall: uid=0
> > Nov 27 13:07:18 linuxclient cifs.upcall: creduid=0
> > Nov 27 13:07:18 linuxclient cifs.upcall: user=cifs/linuxclient.fqdn
> > Nov 27 13:07:18 linuxclient cifs.upcall: pid=1708
> > Nov 27 13:07:18 linuxclient cifs.upcall:
> > get_cachename_from_process_env: pid == 0
> > Nov 27 13:07:18 linuxclient cifs.upcall: get_existing_cc: default
> > ccache is FILE:/tmp/krb5cc_0
> > Nov 27 13:07:18 linuxclient cifs.upcall: get_tgt_time: unable to get
> > principal
> > Nov 27 13:07:18 linuxclient cifs.upcall: handle_krb5_mech: getting
> > service ticket for winsrv
> > Nov 27 13:07:18 linuxclient cifs.upcall: handle_krb5_mech: obtained
> > service ticket
> > Nov 27 13:07:18 linuxclient cifs.upcall: Exit status 0
> > 
> > 
> > where it says that it get the service ticket (I can see it sniffing
> > packets with wireshark) but it is "unable to get principal". Which
> > principal?
> > 
> > On the server side I have the following error:
> > 
> > A process has requested access to an object, but has not been granted
> > those access rights. (0xC0000022)
> > SPN: session setup failed before the SPN could be queried
> > SPN Validation Policy: SPN optional / no validation
> > 
> > 
> > What I'm doing wrong?
> > 
> > Any suggest is welcome.
> > 
> > Best regards
> > 
> > Alberto
> > 
> > 
> 
> 

