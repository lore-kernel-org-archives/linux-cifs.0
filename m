Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1626C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D947D6124B
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 19:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243039AbhIWTvn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 15:51:43 -0400
Received: from wolff.to ([98.103.208.27]:33602 "HELO wolff.to"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S242861AbhIWTvn (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 15:51:43 -0400
Received: (qmail 7811 invoked by uid 500); 23 Sep 2021 19:38:05 -0000
Date:   Thu, 23 Sep 2021 14:38:05 -0500
From:   Bruno Wolff III <bruno@wolff.to>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: setcifsacl: Shouldn't 0x0 be a valid mask?
Message-ID: <20210923193805.GA5478@wolff.to>
References: <20210923155510.GA2171@wolff.to>
 <CAH2r5msCBzGM3Rc1JofLpCQEbkfRbJ5kgY+eSJrMX5Zx3xr6hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msCBzGM3Rc1JofLpCQEbkfRbJ5kgY+eSJrMX5Zx3xr6hw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 23, 2021 at 11:15:26 -0500,
  Steve French <smfrench@gmail.com> wrote:
>Do you have an example of doing the same thing via
>
>"smbcacls" (from Linux) or "icacls" (or cacls.exe) from Windows?

I'm still trying to get the correct syntax for icacls, but when I 
used a GUI I was able to add an ACL with no access which icacls 
will display:
PS C:\Users\bruno-a> icacls forwards
forwards OWNER RIGHTS:
         NT AUTHORITY\SYSTEM:(I)(F)
         BUILTIN\Administrators:(I)(F)
         AD\bruno-a:(I)(F)

Successfully processed 1 files; Failed processing 0 files
