Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2A5C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 17:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F5812077B
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 17:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LbJnIn1j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfBURHD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 12:07:03 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39392 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfBURHC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 12:07:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id 101so14469529pld.6
        for <linux-cifs@vger.kernel.org>; Thu, 21 Feb 2019 09:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XsZPhxdBdlYV34oAYODhqA30vWo4o5xEmRE9ImoE88Y=;
        b=LbJnIn1jBXkiUflcu49Ctoz2qMmpY79T7lAs3yOJ+Uj8LPwANDqTxpnpKO0SLvbT0t
         JcN6d0iB/O3P8kQTefVDp+Uq+yRsyY2xpgiLB9TCJBpszOiBToNvqaR9/dLSx9Ab7n8k
         hrYaoXXYk3aDHZwTfnLvlMFgGZclbPf/Xqs7M9U2t/oCXp+x53VpUe3qVOggl6iOqdfQ
         mrQfmTL9ldfn3KrySg5bIgRzpcvcUg5K7TAH2Fxxg9vNTPHvDwhqpsbnPTWsBOhxxIMV
         F/Ak7S4P5836zI4UmIVwblMDcOye1GgJu2GtHMV24pOGuUoNp83NDU2NP3ppRf6vehFT
         Lotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XsZPhxdBdlYV34oAYODhqA30vWo4o5xEmRE9ImoE88Y=;
        b=gUdqhWrYhjerjl57UBLm1fe0b0HmxrRncC+lgvh2UE7I7c6dBxZ0bdafmqnX4jB5u2
         vIkgN4wHhTh9K43jHK4uVEc74GGgjn84XdFXZx/1ROge09WGq4wd4xRbKrLue1ZGwyOB
         29PpME3k8Gx8XynEnxZN7kZUGXR1UkrWH7vD77X7f4JdiyodXX+WvbEEPTm42XFsZCES
         /AKyAiQ1M6jmAJZHiRp/lkCQ5Vbr1+2ZuZQOTh9FHOUOIUmqof/0WXPOo/BXzSquDQQQ
         +kyaohObwYdg10Ln/ZlzzSX6pKoy0/U5NrP3c1zqgKlrP67bc+kzu7lBGqyhYs/lkABR
         ylHQ==
X-Gm-Message-State: AHQUAubMYnheYmF11F6PH7zIEtM46qCJIvo/KXtOWDtTyAPwrnBgvZbz
        29tgVqhv/n3KD3w3ddeH0UaLo2nVP/9bIV5ZDez5ig==
X-Google-Smtp-Source: AHgI3IYBSKRvuo2hYtFA+AzPIhktEEP1rvun9mViAu8CEnmjhp59GcmgJe/yRSRdIOrgIKqKEv3B/KqHK6PSjopB4bM=
X-Received: by 2002:a17:902:a506:: with SMTP id s6mr10619876plq.24.1550768821390;
 Thu, 21 Feb 2019 09:07:01 -0800 (PST)
MIME-Version: 1.0
References: <70e91b0b-4bca-60ea-19cf-3df0f49d4e5a@citrix.com>
In-Reply-To: <70e91b0b-4bca-60ea-19cf-3df0f49d4e5a@citrix.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Feb 2019 11:06:49 -0600
Message-ID: <CAH2r5mvDFFMhwyKdEGhgb+5-+v2PyuAWpWN9drofXVvj3mQxYQ@mail.gmail.com>
Subject: Re: Failure to reconnect after cluster failvoer
To:     Ross Lagerwall <ross.lagerwall@citrix.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Couple quick thoughts.

Does this work on current kernels (5.0 for example).

Was thinking about patches that might affect this like:
- "cifs: connect to servername instead of IP for IPC$ share"
- "smb3: on reconnect set PreviousSessionId field"
- Paulo's patches (has cifs-utils coreq) to reconnect to new IP
address if hostname's IP address changed and his add support for
failover
- Paulo's patch to remove trailing slashes from server UNC name

On Thu, Feb 21, 2019 at 10:58 AM Ross Lagerwall
<ross.lagerwall@citrix.com> wrote:
>
> Hi,
>
> I have an issue with SMB cluster failover. There are two Windows 2012 R2
> Datacenter servers in the cluster. If the primary server is turned off,
> then the secondary server becomes the primary. However, when this
> happens the kernel client is not able to recover the mount.
>
> Here is the reconnection network trace:
>
> Time      Source       Destination  Protocol Length Info
> 16.640530 10.71.217.53 10.71.217.50 SMB2     172    Negotiate Protocol
> Request
> 16.641723 10.71.217.50 10.71.217.53 SMB2     318    Negotiate Protocol
> Response
> 16.641799 10.71.217.53 10.71.217.50 SMB2     190    Session Setup
> Request, NTLMSSP_NEGOTIATE
> 16.642148 10.71.217.50 10.71.217.53 SMB2     442    Session Setup
> Response, Error: STATUS_MORE_PROCESSING_REQUIRED, NTLMSSP_CHALLENGE
> 16.642201 10.71.217.53 10.71.217.50 SMB2     562    Session Setup
> Request, NTLMSSP_AUTH, User: clusterad.local7337\Administrator
> 16.656407 10.71.217.50 10.71.217.53 SMB2     142    Session Setup Response
> 16.656492 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 16.656916 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_BAD_NETWORK_NAME
> 16.659249 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 16.659635 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_BAD_NETWORK_NAME
> 20.224591 10.71.217.53 10.71.217.50 SMB2     182    Tree Connect Request
> Tree: \\10.71.217.50\IPC$
> 20.225344 10.71.217.50 10.71.217.53 SMB2     150    Tree Connect Response
> 20.225449 10.71.217.53 10.71.217.50 SMB2     216    Ioctl Request
> FSCTL_VALIDATE_NEGOTIATE_INFO
> 20.225934 10.71.217.50 10.71.217.53 SMB2     206    Ioctl Response
> FSCTL_VALIDATE_NEGOTIATE_INFO
> 20.225975 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 20.226355 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_BAD_NETWORK_NAME
> 22.240595 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 22.241159 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_BAD_NETWORK_NAME
> 24.256590 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 24.257380 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_BAD_NETWORK_NAME
> ...
> 40.384609 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 40.385135 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_BAD_NETWORK_NAME
> 41.772006 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 41.772562 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_NETWORK_NAME_DELETED
> 41.772641 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> 41.773037 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect
> Response, Error: STATUS_NETWORK_NAME_DELETED
> 42.400589 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request
> Tree: \\10.71.217.50\smbshare
> ...
>
> After the secondary server takes over (presumably once it stops
> returning STATUS_BAD_NETWORK_NAME), it then returns
> STATUS_NETWORK_NAME_DELETED indefinitely.
>
> This can be fixed by delaying the tree connect to IPC$ until after the
> tree connect to the share succeeds.  The server then no longer returns
> STATUS_NETWORK_NAME_DELETED and instead responds successfully.  I'm not
> sure why the server behaves like this and I'm not sure if the client is
> doing something wrong. I found this out because it used to work on older
> kernels before b327a717e506 ("CIFS: make IPC a regular tcon").
>
> Here is the patch that makes it work:
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index dba986524917..1f97ed6459bf 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2864,7 +2864,14 @@ void smb2_reconnect_server(struct work_struct *work)
>
>         spin_unlock(&cifs_tcp_ses_lock);
>
> +       rc = 0;
>         list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
> +               if (rc) {
> +                       list_del_init(&tcon->rlist);
> +                       cifs_put_tcon(tcon);
> +                       continue;
> +               }
> +
>                 rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon);
>                 if (!rc)
>                         cifs_reopen_persistent_handles(tcon);
>
> Can anyone give any more info on this oddity and whether this is a
> useful patch?
>
> Thanks,
> --
> Ross Lagerwall



-- 
Thanks,

Steve
