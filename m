Return-Path: <SRS0=mJ1i=RE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F32EC43381
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Mar 2019 00:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC7320850
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Mar 2019 00:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MaTXeR0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfCAANu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 19:13:50 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:35446 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731073AbfCAANu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Feb 2019 19:13:50 -0500
Received: by mail-pg1-f173.google.com with SMTP id e17so8463158pgd.2
        for <linux-cifs@vger.kernel.org>; Thu, 28 Feb 2019 16:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xSD2kAAJcR4gTSOPFNKouQXXmHd0rkBuo33KHRk965o=;
        b=MaTXeR0AQSSMalKBb1KeFs0zoJQi/QheAFlAmIu/dfj3ZJLE4eiCAsUrGbrDLVfzzt
         rr83wSxnleE0kY35rqzyrVr4+IMaiRRo0lw32koAdz3PiXf5nhzZScWaYAXbfNxW1VJz
         I5TcpnZjOmYHd7iMy2uA5MJYj9LjhD8OVJKfEcP3ZrqSwDynQfAnQ4nX4zSCSzpTbsDJ
         k86MkStRaZlabJr/5kWNL9fh1wltA4vzsQKm0UAvthhyp7ipJWnnUywy5e5r2GrOe7Jj
         CDaY/Ej6qKtnahUoMWf2SkopZz0i+Nz5EWSF5TSE2WdAZ6a4wEFzcsaOEBXHmGhk6x1G
         DsNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xSD2kAAJcR4gTSOPFNKouQXXmHd0rkBuo33KHRk965o=;
        b=psW7LTsPXWrgJtYNfx8cfcxwQXIJC0U3H7sFKMIVF0+JBPRuQL4iOr/u835ZrSevrX
         wJK0TOkamEUzK6Uw2KDfuPK5iSSk9oMTsZ+Fo609Yc3iYatNrfo6SaprSfgEdRoG8Yqp
         4+xz4T2vkPUaN9laABTtT+85tBxf/tfufVZXBm4fvjPNAxQNh9eSnS4b/lBt5cm7V/hL
         IxBsk9P6Q5BEpZ+eNRamatAwDa1+DnTuZxH3HlXm+vxbGa67O6YCCKxsJBWr4Sk6E+TY
         7/ShjzhmMWJ53N5N0z4j3fumeeokFwTX+gB6C9aHuaRr6FS7rwzhv6Kt/+PFF9vvUydb
         eXOQ==
X-Gm-Message-State: APjAAAVVImW2lJ2fxaHwYBGtVCTUra2p/ihW4PmsNcfc6wMQkjV4RR7g
        JCVakuq2FpACPHjNMcEDwAN+z3uf7k8IzJz/NdsjhQ==
X-Google-Smtp-Source: APXvYqxD/ain4cPT4AyHPqkq3iqFcrW0zFrdPbj8Ui5bMZrm3p1qv9fax0fCyCvscePL9NEksk+Pqn9lzZxoVGoOmW4=
X-Received: by 2002:a63:1053:: with SMTP id 19mr1918067pgq.55.1551399228947;
 Thu, 28 Feb 2019 16:13:48 -0800 (PST)
MIME-Version: 1.0
References: <SN4PR0701MB383772AF71C30A2DE029741DCA750@SN4PR0701MB3837.namprd07.prod.outlook.com>
In-Reply-To: <SN4PR0701MB383772AF71C30A2DE029741DCA750@SN4PR0701MB3837.namprd07.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 28 Feb 2019 18:13:37 -0600
Message-ID: <CAH2r5muOHrQ_utAWqTtcoHKE_5w9W_wvyA+8mzrunWVLYhUEKw@mail.gmail.com>
Subject: Re: Alternate Data Stream Status for LinuxCIFS utils
To:     Coan Dillahunty <cdillahunty@nasuni.com>
Cc:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

So we generalized the solution for this problem (how to query various
information, metadata like stream information among others from user
space tools) by creating an "smbinfo" utility in cifs-utils.   I have
been experimenting with adding an option to it "smbinfo streams
<filename>" to list the information on the alternate data streams
(currently there are about 10 options, different queries, exposed in
the tool).  Are you interested in looking at cleaning this (smbinfo
streams query option) and submitting updates to make it more user
friendly?

On Thu, Feb 28, 2019 at 4:14 PM Coan Dillahunty <cdillahunty@nasuni.com> wr=
ote:
>
> Hello,
>
> I noticed on page 16 of this 2016 presentation (https://sambaxp.org/archi=
ve_data/SambaXP2016-SLIDES/thu/track1/sambaxp2016-thu-track1-Steve_French-A=
ccessingSambaFromLinuxWhatsNewWhatsFasterWhatsBetter.pdf) that an IOCTL to =
list alternate data streams using LInuxCIFS utils was in the work in progre=
ss section. We need this functionality for an upcoming project and hoped yo=
u might have an update on the status.
>
> I've read the release notes for the latest releases on the LinuxCIFS util=
s wiki page (https://wiki.samba.org/index.php/LinuxCIFS_utils) and didn't s=
ee an indication that this has yet to be addressed. Is that correct? If lis=
ting alternate data streams using LinuxCIFS utils isn't yet supported, is t=
here a timeline when we might expect to see them supported?
>
> Thank you,
>
> Coan Dillahunty
>
> Coan Dillahunty
> Senior Product Manager
> Nasuni | One Marina Park Drive, Boston, MA 02210
> M +1.512.694.4388
>
> This e-mail message and all attachments transmitted with it may contain p=
rivileged and/or confidential information intended solely for the use of th=
e addressee(s). If the reader of this message is not the intended recipient=
, you are hereby notified that any reading, dissemination, distribution, co=
pying, forwarding or other use of this message or its attachments is strict=
ly prohibited. If you have received this message in error, please notify th=
e sender immediately and delete this message, all attachments and all copie=
s and backups thereof.



--=20
Thanks,

Steve
