Return-Path: <SRS0=3qap=V4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0165BC32751
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 18:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8563206A2
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 18:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfGaSQL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Jul 2019 14:16:11 -0400
Received: from whm03.asteroidpc.com ([204.191.218.21]:58688 "EHLO
        nathanshearer.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfGaSQL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Jul 2019 14:16:11 -0400
Received: from [204.191.243.35] (port=39084 helo=[172.16.1.42])
        by whm03.asteroidpc.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <mail@nathanshearer.ca>)
        id 1hst8y-0003LZ-Ly
        for linux-cifs@vger.kernel.org; Wed, 31 Jul 2019 12:16:08 -0600
From:   Nathan Shearer <mail@nathanshearer.ca>
Subject: Forced to authenticate with "pre-Windows 2000" logon names
To:     linux-cifs@vger.kernel.org
Message-ID: <e33b9809-b3e2-6ace-6213-f63d8792e6ca@nathanshearer.ca>
Date:   Wed, 31 Jul 2019 12:16:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - whm03.asteroidpc.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - nathanshearer.ca
X-Get-Message-Sender-Via: whm03.asteroidpc.com: authenticated_id: mail@nathanshearer.ca
X-Authenticated-Sender: whm03.asteroidpc.com: mail@nathanshearer.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I spent the last two days trying to mount a windows share, and it turns 
out it was not a problem with:

  * share permissions
  * filesystem permissions
  * incorrect password
  * firewalls
  * antivirus software
  * smb version

But was in fact an issue with the username. The username I had was 23 
characters, which is longer than the "pre-Windows 2000" logon name which 
is what cifs was using, even with smb vers=3.0. The error was always 
status code 0xc000006d STATUS_LOGON_FAILURE which this time was actually 
an authentication problem since the client was using the wrong username.

Is there any plan to support windows usernames in samba/cifs that are 
*post* windows 2000 era?

# mount.cifs -V
mount.cifs version: 6.9

