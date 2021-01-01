Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE68C433E6
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 20:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE86221F2
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 20:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbhAAUHg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jan 2021 15:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbhAAUHg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jan 2021 15:07:36 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8431C0613C1
        for <linux-cifs@vger.kernel.org>; Fri,  1 Jan 2021 12:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=Xia1L87USBW5apqIGMF1dwRCIxOBi6OYUM3sTOiJ1ng=; b=CJLYzXxEF86RmQx7sX8zM9jlLz
        EApF3+3LWaSm62KuodmVObVxc/WlWoIqeQyAal+rbmxeiCc+xwIvOm5Z6YFUP6id6u7GERV2CHTqn
        9NUKQiCBnKSCobd+O1DehGNDIHCFArkAlBn3T4GUX46LcdXBSL+vLcEWoFLbMmrKgcmwUXAb1jpcz
        eunBD2G4GT9jwMgu38Jo4tStdVDXeZkIRvhN/oOjLOO9MAbUaV5SxXVmSfn3W17TcTRXqOJxgTlIG
        X6V7YNSppp85Xin/tntg+FkSW3l0i7OFqoy7RyHNPNK4LFKwp9E6iswTHPlk1brlJiwtRQl7IgXP1
        r0qQqxCaCjDLtZ/bvrmDyqeZW60ClgLpqGSkFIp9GrJ6dxRARnBXfAx39dwnCqrgW69B7SejzBYYs
        iz2yelD8MeMiFgteVEjmgAKCPR8tcezP4L4uhMI0tTgCMzLSWDpwKbP+ZP5g8F4TqY2S60R5UlHOp
        jRcNJ9bJLaujWuSkoSCEns5v;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kvQhJ-0005dv-GS; Fri, 01 Jan 2021 20:06:53 +0000
Date:   Fri, 1 Jan 2021 12:06:50 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Xiaoli Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file
 name
Message-ID: <20210101200650.GA42108@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
 <20210101060050.GA1892237@jeremy-acer>
 <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jan 01, 2021 at 09:12:14AM -0600, Steve French wrote:
>On Fri, Jan 1, 2021 at 12:00 AM Jeremy Allison <jra@samba.org> wrote:
>>
>> On Thu, Dec 31, 2020 at 09:35:23PM -0600, Steve French via samba-technical wrote:
>> >
>> >This patch may be even more important to Samba, as alternative ways of
>> >storing these files can create more problems. Interestingly Samba
>> >server reports local files with backslashes in them over the wire
>> >without remapping, even though these are illegal in SMB3 which would
>> >cause confusion on the client(s).  Has anyone tried Windows mounting
>>
>> Samba should mangle names containing '\' to 8.3 names.
>
>You were right mangled names was enabled.  But that is also
>interesting - it does expose a bug in smbclient.
>
>When you connect smbclient - doing a ls of a subdirectory with
>reserved characters worked, but doing an ls of the parent (root
>directory of share) caused smbclient to disconnect.  See below
>
>smb: \> ls rsvd-chars
>  rsvd-chars                          D        0  Fri Jan  1 08:55:49 2021
>
>556368460 blocks of size 1024. 296010296 blocks available
>smb: \> ls
>  .                                   D        0  Fri Jan  1 08:54:28 2021
>  ..                                  D        0  Thu Dec 31 21:42:28 2020
>  topdir                              D        0  Mon Dec 14 16:01:25 2020
>  lock1.txt                           A      200  Fri Dec 18 12:28:18 2020
>  lock_rw_shared.dat                  A      200  Fri Dec 18 12:28:18 2020
>  lock_rw_exclusive.dat               A      200  Fri Dec 18 12:28:18 2020
>  autounlock.txt                      A      200  Fri Dec 18 12:28:18 2020
>is_bad_finfo_name: bad finfo->name
>NT_STATUS_INVALID_NETWORK_RESPONSE listing \*

This is coming from the following code which is designed to
protect the client from a malicious server returning a '\' or '/'
character in an filename component.

/****************************************************************************
  Check if a returned directory name is safe.
****************************************************************************/

static NTSTATUS is_bad_name(bool windows_names, const char *name)
{
         const char *bad_name_p = NULL;

         bad_name_p = strchr(name, '/');
         if (bad_name_p != NULL) {
                 /*
                  * Windows and POSIX names can't have '/'.
                  * Server is attacking us.
                  */
                 return NT_STATUS_INVALID_NETWORK_RESPONSE;
         }
         if (windows_names) {
                 bad_name_p = strchr(name, '\\');
                 if (bad_name_p != NULL) {
                         /*
                          * Windows names can't have '\\'.
                          * Server is attacking us.
                          */
                         return NT_STATUS_INVALID_NETWORK_RESPONSE;
                 }
         }
         return NT_STATUS_OK;
}
