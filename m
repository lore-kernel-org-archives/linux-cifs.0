Return-Path: <SRS0=tjAs=R2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F365C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 14:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 071A6218A2
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 14:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jp+8VJid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfCWORS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Mar 2019 10:17:18 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:45084 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfCWORS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Mar 2019 10:17:18 -0400
Received: by mail-pf1-f177.google.com with SMTP id e24so2560780pfi.12
        for <linux-cifs@vger.kernel.org>; Sat, 23 Mar 2019 07:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ewSSTdMgf99mZBdF+MNT7RJYAR0uPl5b2oJyPofm67M=;
        b=jp+8VJidJdyyFU+K/shM+N5Ld1t6fw+L0CWWed5hyi5Ib++wRSnsJZ7fIIuqdVFWHx
         VmItLkRkRYnfjFYLdIz/925MedBvTaSbDYygMUMyBuJRfjfw1IAQw93YzkUk52R7Fsxp
         99jso6XJxlpqLpGqiqRoFA7i+Clp2YPa5LwXfFow0Agw1iCINNXjL+u5YYt9zH4kNHz1
         0Zk8yj+UiyWUpPPc6KVLFFD+gA9HcWF1kOhsYBhjAgjyBOorlxq+N2dOW+SFbWeBwY27
         3qvY5lumo0+XAXRJiFgIKudeThgedPafuDIa836EEISbfyErqu/L5uelN8FkSU5VHbFl
         e8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ewSSTdMgf99mZBdF+MNT7RJYAR0uPl5b2oJyPofm67M=;
        b=bwdN18y9KLyqIA8jgVXd2bDlbvbmqFl6UDkvebpWs3jS8t5FZmkyXTOjXSW+6xGxsK
         DdPA8ABM4WNpsrq464mhoprBSODoM9eckfwIRPQ55yHB1oDNHVk5uajVik5KgF9TVj+q
         owNZ4yXQIy0VbgSYD4j0bGstyl/1ThGUJVO93261uOe+j/jOYEY92ez6gG3SC+SYVYhJ
         efOK2FXDYhroNwOnL9tzm/ZbFgyyBny61+VcZQY4PVPaVYwi5DZQZ/Nvrp1lVwjtK5W0
         KHaohaUST+XNeewtNlf9kpwKAfkpM06SYmVNTa7aHuQ9JBp7PrdKAAjx1MFj5twMc2da
         MjBA==
X-Gm-Message-State: APjAAAXrotIdv5doLGQ9dqc+VlYFYF5RrpZpDNUyDbXCc5mcT5CeyeNj
        BSJyB6yiRPyC0OVHjT/ImV65HDjvgb5mIs1jPcs=
X-Google-Smtp-Source: APXvYqxD7MXlPHXhDZtSxy+YywSBDgY/uWD/YYEgvrIdpElBqpJimqHGA21at3pvCfC/a0pW9qQbYThLOjpaNF17DTE=
X-Received: by 2002:a63:544f:: with SMTP id e15mr14469720pgm.344.1553350637432;
 Sat, 23 Mar 2019 07:17:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 23 Mar 2019 09:17:06 -0500
Message-ID: <CAH2r5muo2JT6sx8EPAsg9q_12XZL7a3v8jGUx2qS=sTX08PDSQ@mail.gmail.com>
Subject: More reflink tests added for smb3 to Samba
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Just added 20 more xfststests to the SMB3 Linux client 'buildbot'
automated tests (from the surprisingly large set of xfstests that
depend on reflink support) to Samba with vfs_btrfs (these tests were
added to the cifs-testing group on the buildbot).

I suspect that there are  about 20 more reflink related existing
xfstests that could be added fairly easily, and another ~80 that
require additional fallocate features or bugfixes or will only work on
local block devices so not appropriate for SMB3 mounts.

Continuing to make progress in improving automated testing.  Next step
is to automate some of the testing of the SMB3.1.1 POSIX extensions to
Samba

-- 
Thanks,

Steve
