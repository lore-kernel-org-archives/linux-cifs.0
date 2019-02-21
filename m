Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D03C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 16:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A7FC2077B
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 16:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfBUQ5w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:57:52 -0500
Received: from smtp03.citrix.com ([162.221.156.55]:22146 "EHLO
        SMTP03.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfBUQ5w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 11:57:52 -0500
X-IronPort-AV: E=Sophos;i="5.58,396,1544486400"; 
   d="scan'208";a="78730599"
To:     <linux-cifs@vger.kernel.org>
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: Failure to reconnect after cluster failvoer
Message-ID: <70e91b0b-4bca-60ea-19cf-3df0f49d4e5a@citrix.com>
Date:   Thu, 21 Feb 2019 16:57:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I have an issue with SMB cluster failover. There are two Windows 2012 R2
Datacenter servers in the cluster. If the primary server is turned off,
then the secondary server becomes the primary. However, when this
happens the kernel client is not able to recover the mount.

Here is the reconnection network trace:

Time      Source       Destination  Protocol Length Info
16.640530 10.71.217.53 10.71.217.50 SMB2     172    Negotiate Protocol 
Request
16.641723 10.71.217.50 10.71.217.53 SMB2     318    Negotiate Protocol 
Response
16.641799 10.71.217.53 10.71.217.50 SMB2     190    Session Setup 
Request, NTLMSSP_NEGOTIATE
16.642148 10.71.217.50 10.71.217.53 SMB2     442    Session Setup 
Response, Error: STATUS_MORE_PROCESSING_REQUIRED, NTLMSSP_CHALLENGE
16.642201 10.71.217.53 10.71.217.50 SMB2     562    Session Setup 
Request, NTLMSSP_AUTH, User: clusterad.local7337\Administrator
16.656407 10.71.217.50 10.71.217.53 SMB2     142    Session Setup Response
16.656492 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
16.656916 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_BAD_NETWORK_NAME
16.659249 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
16.659635 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_BAD_NETWORK_NAME
20.224591 10.71.217.53 10.71.217.50 SMB2     182    Tree Connect Request 
Tree: \\10.71.217.50\IPC$
20.225344 10.71.217.50 10.71.217.53 SMB2     150    Tree Connect Response
20.225449 10.71.217.53 10.71.217.50 SMB2     216    Ioctl Request 
FSCTL_VALIDATE_NEGOTIATE_INFO
20.225934 10.71.217.50 10.71.217.53 SMB2     206    Ioctl Response 
FSCTL_VALIDATE_NEGOTIATE_INFO
20.225975 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
20.226355 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_BAD_NETWORK_NAME
22.240595 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
22.241159 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_BAD_NETWORK_NAME
24.256590 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
24.257380 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_BAD_NETWORK_NAME
...
40.384609 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
40.385135 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_BAD_NETWORK_NAME
41.772006 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
41.772562 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_NETWORK_NAME_DELETED
41.772641 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
41.773037 10.71.217.50 10.71.217.53 SMB2     143    Tree Connect 
Response, Error: STATUS_NETWORK_NAME_DELETED
42.400589 10.71.217.53 10.71.217.50 SMB2     190    Tree Connect Request 
Tree: \\10.71.217.50\smbshare
...

After the secondary server takes over (presumably once it stops
returning STATUS_BAD_NETWORK_NAME), it then returns
STATUS_NETWORK_NAME_DELETED indefinitely.

This can be fixed by delaying the tree connect to IPC$ until after the
tree connect to the share succeeds.  The server then no longer returns
STATUS_NETWORK_NAME_DELETED and instead responds successfully.  I'm not
sure why the server behaves like this and I'm not sure if the client is
doing something wrong. I found this out because it used to work on older
kernels before b327a717e506 ("CIFS: make IPC a regular tcon").

Here is the patch that makes it work:

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dba986524917..1f97ed6459bf 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2864,7 +2864,14 @@ void smb2_reconnect_server(struct work_struct *work)

  	spin_unlock(&cifs_tcp_ses_lock);

+	rc = 0;
  	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
+		if (rc) {
+			list_del_init(&tcon->rlist);
+			cifs_put_tcon(tcon);
+			continue;
+		}
+
  		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon);
  		if (!rc)
  			cifs_reopen_persistent_handles(tcon);

Can anyone give any more info on this oddity and whether this is a 
useful patch?

Thanks,
-- 
Ross Lagerwall
