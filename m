Return-Path: <SRS0=lfmE=3C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C63C33CA9
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jan 2020 20:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A8A92187F
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jan 2020 20:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZyawoKgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgAMUzL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jan 2020 15:55:11 -0500
Received: from hr2.samba.org ([144.76.82.148]:49934 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgAMUzL (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 Jan 2020 15:55:11 -0500
X-Greylist: delayed 1132 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 15:55:10 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=JNKUuHInooF9ZI3fIFoHcMxkLm77ZEkAj3bulBvDOQE=; b=ZyawoKgBGqgc9wfBvamZTettCB
        FfagFfjTRczYIJAo1y5ZOcioVTbSKZ6FmwfoDxu7ui7sXRQ3WoWbAof3MUj5wTnlspl59KmOLvR5N
        7UKgofrhgmqutPhUyxZREe8VwMZzLv5/9SDd761M7CeYogMbVUAk7v/SB495dLqJeZFp+t4CBPfc4
        PjEkbSOlVRiOyhkd1ddKrXsPwmutgd+ze9JNhgIXRUCaekzPb948JhI8r791gAzbGN2qWacDjV6x9
        Im9Z76Tp0s56gDihN9tm8B7WN7lDtwiu6/jxX7KJZlhMoOK1UimpkU2fAKdA782wZePiCSb8+h8mQ
        hg0uHzCA71vbsosGAZCG8rPkK2s/spH5GoM6KrfbHXd67D8AQ2FqNYCLpnOCfX+wUMQUgboFLV6xD
        PQTPbmLvBYy4EMY1MzjFmgnK8KyzT1wO5IgRkued5SftXQx1G9FAc0ZYnG4F1O1hPnfe48aKBUCbz
        pCdiL0QBmKkKPm5EyNQCiteT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1ir6Rc-0002NT-P4; Mon, 13 Jan 2020 20:36:17 +0000
Date:   Mon, 13 Jan 2020 12:36:13 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Boris Protopopov <boris.v.protopopov@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add support for setting owner info, dos attributes, and
 create time
Message-ID: <20200113203613.GA111855@jra4>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20191219165250.2875-1-bprotopopov@hotmail.com>
 <CAH2r5mu0Jd=MACMn6_KPvNWoAPVu+V_3FOnoEZxDWoy0x2qEzA@mail.gmail.com>
 <780DD595-1F92-4C34-A323-BB32748E5D07@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <780DD595-1F92-4C34-A323-BB32748E5D07@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 13, 2020 at 01:26:39PM -0700, Andreas Dilger via samba-technical wrote:
> On Jan 9, 2020, at 12:10 PM, Steve French <smfrench@gmail.com> wrote:
> > 
> > One loosely related question ...
> > 
> > Your patch adds the ability to set creation time (birth time) which
> > can be useful for backup/restore cases, but doesn't address the other
> > hole in Linux (the inability to restore a files ctime).
> > 
> > In Linux the ability to set timestamps seems quite limited (utimes
> > only allows setting mtime and atime).
> 
> The whole point of not being able to change ctime and btime as a regular
> user is so that it is possible to determine when a file was actually
> created on the filesystem and last modified.  That is often useful for
> debugging or forensics reasons.
> 
> I think if this is something that SMB/CIFS wants to do, it should save
> these attributes into an xattr of its own (e.g. user.dos or whatever),
> rather than using the ctime and btime(crtime) fields in the filesystem.

FYI, we (Samba) already do this for create time to store/fetch it
on systems and filesystems that don't store a create time. It's
easy to add extra info here.
