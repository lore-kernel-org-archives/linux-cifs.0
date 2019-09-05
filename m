Return-Path: <SRS0=hPid=XA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32048C43331
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Sep 2019 23:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76322206DF
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Sep 2019 23:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rVXbbkeZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfIEXAD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Sep 2019 19:00:03 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:37677 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbfIEXAD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Sep 2019 19:00:03 -0400
Received: by mail-io1-f46.google.com with SMTP id r4so8559440iop.4
        for <linux-cifs@vger.kernel.org>; Thu, 05 Sep 2019 16:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2fn+U7E9o4/fsYuYo96+Wt1jksbDto1e6gs7W58Oj/I=;
        b=rVXbbkeZXa0i3ZxX7LwMQga/PKIYS2SylL77PyDzokUQUZN2WvK1/ad15m2zGpgPB7
         NeeOJlQAPPS+AJYN663kcsQ2tmnU24vR1OLZs8BZg5nnViKO5Q7kEitr5QlJ/FiCqw6l
         03x7anUCIvEUFfTNWS54q/NazdeOG9YllSMtUAixPmi5fWffJ4U0UmVHUTMps3BRs+Jo
         K6ah2roFYvYzHErMkNvitmeDU7OFeuo9ol5xkVEvbGRvdymEYdFCBAoCH0uAdINJtMoO
         VTC+CFVCcQCBp1xtQa1UIbmQO8dsix3Yc6EhdHH4twgScumKWspfnoWYTs+3pHg2z/vN
         MDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2fn+U7E9o4/fsYuYo96+Wt1jksbDto1e6gs7W58Oj/I=;
        b=bjUJUqw3u0sJp3z98D0AVIMI25D3WT1f4SP/sYLL6xRS5dH1NzLuwaOy22+06/N9zT
         rRjlDTW9bvNbV6VUfaSt3/KSzWu0vdgZXTTYARMT0MqqVWCUaaL8sexbcLbu1Z7o0l2l
         SzTQeZ7RdR7iBDjCF7xGRuIv9CZp5X4TaqC+ojqyUlXhgAzvd80GhCk6hCHDwlCuQa5e
         FrzBZ5vhTdsy37pD8m1Gv/I2Nyyp4tOMu98IH2k6hRZxA7EQ+DkL7nSTyoEHLZfxP50q
         l1fpRpKZo6OwRjxOqeDp9PDEGbT427Up7ruNDrFIlLEu2jyvJIMC3PtNKrQ/eFNP0uYP
         /hRA==
X-Gm-Message-State: APjAAAUXltB2TfJnuOn/KQv8MXO61K3M39N3x/gCNSFypg7Bo9n0fjm+
        Nvleb791bBEujjnsknKl8SlOKVEDu+aiey9VxNKvc+k7
X-Google-Smtp-Source: APXvYqziwT4CLNjtu+lAN7/leyAWGA9/xCC9o+4ev07NU2TQbj6Jx8ZPsU69apgKTQNTU9n/JH+5HWQwlVMhCJbo0lg=
X-Received: by 2002:a02:290e:: with SMTP id p14mr7127554jap.22.1567724402453;
 Thu, 05 Sep 2019 16:00:02 -0700 (PDT)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 6 Sep 2019 08:59:51 +1000
Message-ID: <CAN05THTazV4oLs+yq5SR1RYDO2p1VVmN7qnb=KBkfmZEpx8E0A@mail.gmail.com>
Subject: Oddity: When should Mtime and Ctime be updated for SMB servers?
To:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

List, All,

I was trying to investigate why we had a regression in xfstests
generic/313 and found something odd about when Windows updates the
timestamps for a file.

What the test performs is basically:
1, Create a file
2, Set file size to 0
3, explicitly set the ctime and mtime to the current time of the client
4, read the timestamps back  and verify they are set correctly
delay for 1 second
5, write to the file
6, truncate the file back to 0
7, and check the timestamps again, they should have been updated due to 5,6

This works as expected IF step 3 uses a compound, i.e. a different
handle (how cifs.ko used to work, since this particular kernel api is
path based)

However, IF step 3 uses the same handle from step 1 instead of a
compound then this no longer works. The timestamps are no longer
updated in steps 5,6.

What are the semantics for when these timestamps should be updated by
a write or a truncate?
And why does it matter if step 4 is a compound with
create/setinfo/close versus if it just uses the same handle from the
create in step 1?


Since the traces are tiny I will include them in ASCII form. Anyone
that wants the actual pcap traces to view them in wireshark, just
email me and I will send them.


Original cifs.ko behavior:
====================
    1 0.000000000 SMB2 Create Request File: bar
    2 0.001809747 SMB2 Create Response File: bar
    8 0.004397925 SMB2 Flush Request File: bar
    9 0.013682200 SMB2 Flush Response
   11 0.014561091 SMB2 SetInfo Request
FILE_INFO/SMB2_FILE_ENDOFFILE_INFO File: bar
   12 0.014957578 SMB2 SetInfo Response
   14 0.015851218 SMB2 Create Request File: bar;SetInfo Request
FILE_INFO/SMB2_FILE_BASIC_INFO;Close Request
   15 0.016358273 SMB2 Create Response File: bar;SetInfo Response;Close Response
   17 0.017253133 SMB2 Create Request File: bar;GetInfo Request
FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
   18 0.017736416 SMB2 Create Response File: bar;GetInfo Response;Close Response
   20 1.019048674 SMB2 Write Request Len:22 Off:0 File: bar
   21 1.020140390 SMB2 Write Response
   23 1.021696732 SMB2 SetInfo Request
FILE_INFO/SMB2_FILE_ENDOFFILE_INFO File: bar
   24 1.022446473 SMB2 SetInfo Response
   26 1.024223917 SMB2 Create Request File: bar;GetInfo Request
FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
   27 1.025163155 SMB2 Create Response File: bar;GetInfo Response;Close Response
   29 1.028479545 SMB2 Close Request File: bar
   30 1.029246502 SMB2 Close Response

In this case, packet 14 is the compound used to set the timestamps.
Packet 17 reports that the timestamps were set to the values in 14.
Now there is a one second delay and we write to the file, truncate it
and then read back the timestamps and the timestamps have incremented.

New cifs.ko behavior:
=================
    4 0.003062951 SMB2 Create Request File: bar
    5 0.004362998 SMB2 Create Response File: bar
    7 0.005922755 SMB2 Flush Request File: bar
    8 0.009779700 SMB2 Flush Response
   10 0.011293505 SMB2 SetInfo Request
FILE_INFO/SMB2_FILE_ENDOFFILE_INFO File: bar
   11 0.012076033 SMB2 SetInfo Response
   12 0.013181837 SMB2 SetInfo Request FILE_INFO/SMB2_FILE_BASIC_INFO File: bar
   13 0.014015512 SMB2 SetInfo Response
   14 0.015743571 SMB2 Create Request File: bar;GetInfo Request
FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
   15 0.016904597 SMB2 Create Response File: bar;GetInfo Response;Close Response
   17 1.018801828 SMB2 Write Request Len:22 Off:0 File: bar
   18 1.019773131 SMB2 Write Response
   20 1.021448036 SMB2 SetInfo Request
FILE_INFO/SMB2_FILE_ENDOFFILE_INFO File: bar
   21 1.022202409 SMB2 SetInfo Response
   23 1.023990091 SMB2 Create Request File: bar;GetInfo Request
FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
   24 1.025077567 SMB2 Create Response File: bar;GetInfo Response;Close Response
   26 1.028801682 SMB2 Close Request File: bar
   27 1.029697708 SMB2 Close Response

The only difference here is that in packet 12, where we set the
timestamps, we no longer use a new handle in a c reate/setinfo/close
compound but instead
use the existing handle that is already open.
In this case the timestamps are no longer updated by the write or
truncate in packets 17 and 20.


Regards
Ronnie Sahlberg
