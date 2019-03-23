Return-Path: <SRS0=tjAs=R2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160FEC43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 00:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A64218A1
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 00:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfCWAFy convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:05:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbfCWAFy (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Mar 2019 20:05:54 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0922A356E8;
        Sat, 23 Mar 2019 00:05:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED72A19C57;
        Sat, 23 Mar 2019 00:05:53 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF73A41F3C;
        Sat, 23 Mar 2019 00:05:53 +0000 (UTC)
Date:   Fri, 22 Mar 2019 20:05:53 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Message-ID: <1655233503.8177640.1553299553654.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5mvSnV-e+iFQf_FXNNBaX3ti3gAaiP5VB-0Lq3KCkYqyqw@mail.gmail.com>
References: <599904512.8051095.1553257291511.JavaMail.zimbra@redhat.com> <280287391.8052131.1553257423805.JavaMail.zimbra@redhat.com> <CAH2r5mvSnV-e+iFQf_FXNNBaX3ti3gAaiP5VB-0Lq3KCkYqyqw@mail.gmail.com>
Subject: Re: CIFS support preallocate partially
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.72.12.24, 10.4.195.28]
Thread-Topic: CIFS support preallocate partially
Thread-Index: SNeXrA00cqY6klbb+VmVU+/QoFNqtg==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Sat, 23 Mar 2019 00:05:54 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't know what local file system that does not support preallocate. But I test nfs.
It return "Operation not supported" and create a zero size file.

# xfs_io -f -c "resvsp 4 4" nfs/file
XFS_IOC_RESVSP64: Operation not supported
# echo $?
0
# du -h nfs/file
0	nfs/file


----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>, "Dave Chinner" <dchinner@redhat.com>
> Sent: Saturday, March 23, 2019 12:01:50 AM
> Subject: Re: CIFS support preallocate partially
> 
> No preallocate is actually sent on the wire (other than creating the
> file) in the example you tried.   Some servers do not support
> preallocate - do you know the expected behavior on a local file system
> that does not support preallocate whether it should 1) fail to create
> the file and return an error or 2) succeed in creating the file (even
> though couldn't preallocate the size).
> 
> Looking at the code I am surprised it is not returning an error
> message though it looks like smb3_simple_falloc would return an
> EOPNOTSUPP error (at least if allocating more than a few pages beyond
> end of file)
> 
> On Fri, Mar 22, 2019 at 7:26 AM Xiaoli Feng <xifeng@redhat.com> wrote:
> >
> > Hello,
> >
> > Use xfs_io to test preallocate. It returns successfuly. But it's a empty
> > file. And doesn't allocate space.
> >
> > # mount //localhost/cifs  ~/cifs
> > # xfs_io -f -c "resvsp 4 4" cifs/file
> > # du -h cifs/file
> > 0       cifs/file
> >
> >
> > Test on xfs:
> > # rm -rf file
> > # xfs_io -f -c "resvsp 4 4" file
> > # du -h file
> > 4.0K    file
> >
> > Is it expected for cifs? I think the size should be a block size(1M for
> > cifs).
> >
> > Thanks.
> >
> > --
> > Best regards!
> > XiaoLi Feng 冯小丽
> >
> > Red Hat Software (Beijing) Co.,Ltd
> > filesystem-qe Team
> > IRC:xifeng，#channel: fs-qe
> > Tel:+86-10-8388112
> > 9/F, Raycom
> 
> 
> 
> --
> Thanks,
> 
> Steve
> 
