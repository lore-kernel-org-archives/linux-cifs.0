Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8546C433E0
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 04:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A32D620781
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 04:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbhACEOL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Jan 2021 23:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbhACEOK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Jan 2021 23:14:10 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21951C061573
        for <linux-cifs@vger.kernel.org>; Sat,  2 Jan 2021 20:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=mlTWyUP6drbnfj+htpMtytpuW37BT9IdnIQthb2kRCI=; b=Ph+ZFDGGXUHDRb8D8xwnVB76aT
        NYRIXIupUINH+uCGQcAwo7O4tx7Y9+XzrNbczGWpw9FiZmdFGYv5J9ZplEQiyRJsx6OEXCbHBLk/U
        5Bsv2mKHB1wYDkDBQaJJ9iGa+1TpOBamNIZiw2BSUuoCHNtiUkCiFe6DLBnycaqh7LW/QDIMPWlb2
        RSVRaDDMYbeepu3cjdWoXL/7BdwffgIDOgUoMw2YnWq4TI/jq9gn3kEHEs36tr0FhZtnADWA4dQsW
        WEK55lF/KeR+X1tTWLDdn36yoBUaehzHBIyRzIKu/+5gmr8lULFXILO7iNcgNUBtPcQ/KWbMYVL4i
        +G2Bi7NDNwgEFkOu1INVz5Sr+5F3ow3pmBvMCvIbtrN07dddA/zFRxQWudk9sWTTQrrX3E29YxG1C
        ohir2OWXryCNI4Z1gFiRS8JCgfA/VviSAIe9EpOGcw32dxH892Cnepteq5y8Bw7REdLFyHvYRuA0p
        dHVKzIeNZgs9W/QokoTh+jej;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kvuli-0005XH-8z; Sun, 03 Jan 2021 04:13:26 +0000
Date:   Sat, 2 Jan 2021 20:13:23 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Xiaoli Feng <xifeng@redhat.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file
 name
Message-ID: <20210103041323.GA162327@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
 <20210101195821.GA41555@jeremy-acer>
 <CAH2r5mvt_cHDbT0xaeLNQn=5cQ0T2-wPgpMkYEGQNdtDZ3kP=A@mail.gmail.com>
 <20210102025837.GA61433@jeremy-acer>
 <CAH2r5ms1V2KKb6T3ELQ-JsQ3fniOScTE2654_xLwnPruiekzEw@mail.gmail.com>
 <20210102052524.GA67422@jeremy-acer>
 <CAH2r5msZt0UZG5r5Z7=_jQf=-xgNz8zW7fZOnqncqeJHB=mOmA@mail.gmail.com>
 <20210103012116.GA117067@jeremy-acer>
 <20210103012511.GC117067@jeremy-acer>
 <CAH2r5muZ9tFZtHakrSf6Px2HGQTDUzg8+V52+NQaytKX_ZpHCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muZ9tFZtHakrSf6Px2HGQTDUzg8+V52+NQaytKX_ZpHCA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Jan 02, 2021 at 09:45:53PM -0600, Steve French wrote:
>> So just creating a file containing : \ etc. doesn't do
>> this - you have to misconfigure the server FIRST.
>
>I agree that with Samba server this is less common (not sure how many
>vendors set that smb.conf

No one sets it by default to my knowledge.

>parm) but note that "man smb.conf" does not warn that disabling name
>mangling will break

Patches to the manpage welcome :-).

>smbclient (assuming that local files have been created on the server with one of
>the various reserved characters, perhaps over NFS for example).  But
>... there are many
>other servers, and I wouldn't be surprised if other servers have
>sometimes returned files
>created by NFS or Ceph or some cluster fs that contain reserved
>characters, even if
>it is illegal.

Sure - but that then becomes a possible CVE for these
filesystem clients if they don't protect themselves
against server attacks.

What does *your* client code do if a server returns a
filename containing a / ? If you pass it up, the upper
layers may screw things up badly.

>> The SMBecho is due to the keepalive failing
>We (SMB/CIFS developers) would know that, but I doubt that all users
>would realize that
>(for example) creating a file over NFS with a reserved character and
>then reexporting the
>file over SMB with Samba configured with managled names off, or with a
>server that
>is less strict than Samba.   Seems like it would be better to print a
>warning like:
>                    "exiting due to invalid character found in file name"
>rather than killing the session and ending up with the (to most users)
>unehelpful error message.

True. Again, patches welcome :-).
