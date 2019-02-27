Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBC3C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 14:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752D12133D
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 14:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfB0ORm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 09:17:42 -0500
Received: from ul-exc-pr-as01.ulaval.ca ([132.203.244.29]:17813 "EHLO
        ul-exc-pr-as01.ulaval.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbfB0ORl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 09:17:41 -0500
Received: from ul-exc-pr-edg01.ulaval.ca ([132.203.244.26])
  by ul-exc-pr-as01.ulaval.ca with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2019 09:17:41 -0500
Received: from UL-EXC-PR-MBX11.ulaval.ca (10.40.67.111) by
 UL-EXC-PR-EDG01.ulaval.ca (132.203.244.26) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Wed, 27 Feb 2019 09:17:39 -0500
Received: from UL-EXC-PR-MBX20.ulaval.ca (10.40.67.120) by
 ul-exc-pr-mbx11.ulaval.ca (10.40.67.111) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 27 Feb 2019 09:17:39 -0500
Received: from UL-EXC-PR-MBX20.ulaval.ca ([fe80::5d31:55ba:ae63:96d4]) by
 UL-EXC-PR-MBX20.ulaval.ca ([fe80::5d31:55ba:ae63:96d4%22]) with mapi id
 15.00.1395.000; Wed, 27 Feb 2019 09:17:39 -0500
From:   =?iso-8859-1?Q?Alexis_Fortin-C=F4t=E9?= 
        <alexis.fortin-cote.1@ulaval.ca>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC:     "Robin P. Blanchard" <robin.blanchard@gmail.com>
Subject: RE: mount -t cifs fails while smbclient succeed
Thread-Topic: mount -t cifs fails while smbclient succeed
Thread-Index: AQHUyrzXfCa6KTecaEaRGQ0BBWS51qXr8SPBgACSrACABzQvuw==
Date:   Wed, 27 Feb 2019 14:17:39 +0000
Message-ID: <1551277059649.97069@ulaval.ca>
References: <637c6227392d4f67b76aa6ebb8b71d0c@UL-EXC-PR-MBX20.ulaval.ca>
 <1550849364135.34775@ulaval.ca>,<CAJUwKM3kKM-g6L+vAVNUvVbCds6ezFmaB8J2BQT2zWyHBmmc6Q@mail.gmail.com>
In-Reply-To: <CAJUwKM3kKM-g6L+vAVNUvVbCds6ezFmaB8J2BQT2zWyHBmmc6Q@mail.gmail.com>
Accept-Language: fr-CA, en-US
Content-Language: fr-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.40.104.18]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,
Thanks for your help.
But it doesn't seem to be an authentication failure. I tried all sec option. Some clearly failed early (in the wireshark trace) due to authentification problem. Its seems to be able to authenticate with ntlmv2.
But fails latter in the exchange.

https://pastebin.com/zkRHtTvq

Frame 25 Create Response, Error: STATUS_PATH_NOT_COVERED

Any idea?

Thanks again.

Alex

________________________________________
De : Robin P. Blanchard <robin.blanchard@gmail.com>
Envoyé : 22 février 2019 14:13
À : Alexis Fortin-Côté
Cc : linux-cifs@vger.kernel.org
Objet : Re: mount -t cifs fails while smbclient succeed

Compare:

failed: lines 21-42

I think you may need to mount with a different sec option:


       sec=
           Security mode. Allowed values are:

           ·   none - attempt to connection as a null user (no name)

           ·   krb5 - Use Kerberos version 5 authentication

           ·   krb5i - Use Kerberos authentication and forcibly enable packet
               signing

           ·   ntlm - Use NTLM password hashing

           ·   ntlmi - Use NTLM password hashing and force packet signing

           ·   ntlmv2 - Use NTLMv2 password hashing

           ·   ntlmv2i - Use NTLMv2 password hashing and force packet signing

           ·   ntlmssp - Use NTLMv2 password hashing encapsulated in Raw
               NTLMSSP message

           ·   ntlmsspi - Use NTLMv2 password hashing encapsulated in Raw
               NTLMSSP message, and force packet signing

           The default in mainline kernel versions prior to v3.8 was sec=ntlm.
           In v3.8, the default was changed to sec=ntlmssp.

On Fri, Feb 22, 2019 at 9:30 AM Alexis Fortin-Côté
<alexis.fortin-cote.1@ulaval.ca> wrote:
>
>
> Hi,
> I have trouble mounting a windows share on my Ubuntu 18.04 workstation.
> I've tried every thing I found using google search to no avail.
>
> The following smbclient command works, so I know my Username and Password are working
> smbclient -U ulaval.ca\\alfoc //132.203.235.15/Partages/FSS
>
> But the following mount fails with errors :
> sudo mount -t cifs -o cred=/home/alexis/smbcred,vers=2.0 //fssdc1.fss.ulaval.ca/Partages/FSS/ /home/alexis/win/
>
> mount error(22): Invalid argument
>
> I've logged the failing and successful trace with wireshark
> failed : https://pastebin.com/7UTBNgs2
> success : https://pastebin.com/kQ80vVmr
>
> I'm using Kernel 4.20.11-042011-generic
> I'm not sure about the server configuration, but it looks like its a windows server that support smb vers=1.0 and vers=2.0
> mount.cifs version: 6.8
>
> dmesg with debug information reads when it fails:
> [ 2021.652324] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
> [ 2021.667748] CIFS VFS: DFS capability contradicts DFS flag
> [ 2021.673168] Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
> [ 2021.675001] CIFS VFS: cifs_mount failed w/return code = -22
>
> Thanks for helping,
> Please respond (cc) to this address.
>
> Alex
>
>
