Return-Path: <SRS0=MmJ1=4W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BC9C3F2D1
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Mar 2020 15:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5743208C3
	for <linux-cifs@archiver.kernel.org>; Thu,  5 Mar 2020 15:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inogs-it.20150623.gappssmtp.com header.i=@inogs-it.20150623.gappssmtp.com header.b="bqaLBGF0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgCEPIB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:08:01 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33926 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCEPIA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Mar 2020 10:08:00 -0500
Received: by mail-wm1-f65.google.com with SMTP id x3so2141516wmj.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Mar 2020 07:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=inogs-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=os2PwD6uL7SxKU7S9lu7+0/3xktcofRxRlJ0AJF/J9o=;
        b=bqaLBGF0dUdFfi5kYNpoi5SpEgWoFnvKIQ2GSuTVhl235mpdWGWsH1vNFGb/pAb4R0
         aP5Awjj4G5TEqYLXhbVJxayCl8Phhd2WJVNqUFVHRABwP7tAI0dRovntdxW4+UC/fbue
         6ke43qtVgRAoQ2/rxA+/ZVKpM1cqvIXMCs5MainQHT35HX03f6jgQGPh/cAatLlsKfQj
         zG9zSR9Yupa2c8hM2z293pnD/poDtVfeeK6yNeYRYQZr4jeQ3rQLfNkj2TF0z3ltcMMS
         0kyVo3QWnm+f2/gDpSDrzc5p1GDytqIBrVzwHPN4uuAmP94wsTT3TsP+jSOj7ZZUV0iP
         vEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=os2PwD6uL7SxKU7S9lu7+0/3xktcofRxRlJ0AJF/J9o=;
        b=TqCD2eeSMvIhtrTygOxI0IDeHnJBXLISiKrD4RY4hgl8ZFF9ms9POEa9q7KWSR3y+Z
         OSfScPQ/Gu0wjJMpSb1neGzoDOhj+mN+99kD42niJLQV7lyq6alhxxUkl/jjYodQMAM+
         8UJ6jiU16lipoV7DxgvYeX8ulXAfN4pdbHBgmFCm4mxtGok+G7QXKrMkrKUVNa+DtV5k
         1JJfLjEZVYBZgBPKeMqODIPg6xU2TZBk91bxSIJBRdyLU2BjNoEl26NLv27R19SKHXyJ
         gCnNKqmOP+SlhDiHESb8WoRb/3JL8l6PB7k2qPnvf61IFKuJ+jR9+n7MIcSa8jkAZQSh
         rpqg==
X-Gm-Message-State: ANhLgQ22cWixuOp0HOlHPmB7+WnCIKfJtedFpDMo0XLH4FbUXcfODT8y
        IIbQDvHGjvBYVFsibZ+swiXnHb53v+MQ+pLF305wjQfB3mQ/an2dx0/Jg7dNm8cP+VFBUqb2WPK
        g82I9q2AMQmfBL4sABmcv3Dj+t3HkcFUxjgxP9Y7+JHU1PgXHW6PZNkpGIjpapcxqDMJwGw==
X-Google-Smtp-Source: ADFU+vupeKLJOTdWy+rkoA9Ft0sdpkVO2jjxjR6t18/mNxPJh8sCOkQSdtsyG0Ef8KgVsVDjyuPXLQ==
X-Received: by 2002:a1c:155:: with SMTP id 82mr9521365wmb.99.1583420878031;
        Thu, 05 Mar 2020 07:07:58 -0800 (PST)
Received: from deimos.ogs.trieste.it (deimos.ogs.trieste.it. [140.105.70.97])
        by smtp.gmail.com with ESMTPSA id c2sm9592335wma.39.2020.03.05.07.07.57
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 07:07:57 -0800 (PST)
Message-ID: <5d4bb5621aa6d204c9d1ab668224b55edfe01009.camel@inogs.it>
Subject: Re: Permission denied mounting a DFS share with multiuser options
From:   abrosich@inogs.it
To:     CIFS <linux-cifs@vger.kernel.org>
Date:   Thu, 05 Mar 2020 16:07:56 +0100
In-Reply-To: <CAH2r5mvYeX5y-=ajH7h9i1TqrRgS8SCO6hXCjFVZx--QqTzD_A@mail.gmail.com>
References: <5a987faff74646e68207e26e570a708669dd4103.camel@inogs.it>
         <CAH2r5mu5dedRmPQzRUH=E87J2txsBv3DiFYZLT-a_xYay=2czA@mail.gmail.com>
         <4c74eb81aa7757e48679eb83c2f2dcbfeb841a3f.camel@inogs.it>
         <87a74ysp99.fsf@cjr.nz>
         <6eb9b4d8d22629a0b78f12abf7e8a30c547b8c07.camel@inogs.it>
         <faaff7b8c00926fda402a3b7e2509e225b06533c.camel@inogs.it>
         <CAH2r5mvYeX5y-=ajH7h9i1TqrRgS8SCO6hXCjFVZx--QqTzD_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hello,
I always tried as root, using sudo.
I'm trying using a domain administrator accout. In production I will use (if it
will work) using an SPN.
I obtain a ticket using kinit and I can see it with klist.

The problem is surely with kerberos and cifs.upcall used together, because:

- using "smbclient -k -U domainuser -W AD.DOMAIN" I can connect and browse the
share without password

- using "mount -t cifs" without "sec=krb5" works, after asking for the password


These are the errors in /var/log/debug

Mar  5 15:33:19 linws003 cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_0
Mar  5 15:33:19 linws003 cifs.upcall: handle_krb5_mech: getting service ticket
for server.domain
Mar  5 15:33:19 linws003 cifs.upcall: cifs_krb5_get_req: unable to get
credentials for server.domain
Mar  5 15:33:19 linws003 cifs.upcall: handle_krb5_mech: failed to obtain service
ticket (-1765328377)
Mar  5 15:33:19 linws003 cifs.upcall: Unable to obtain service ticket
Mar  5 15:33:19 linws003 cifs.upcall: Exit status -1765328377

The cache file /tmp/krb5cc_0 exists. I can see the content with klist and it is
correct.

Tracing the call of cifs.upcall the only errors I can find are:

7295  15:33:19 openat(AT_FDCWD, "/var/lib/sss/pubconf/kpasswdinfo.AD.DOMAIN",
O_RDONLY) = -1 ENOENT (No such file or directory)
7295  15:33:19 sendto(3, "<31>Mar  5 15:33:19 cifs.upcall: cifs_krb5_get_req:
unable to get credentials for server.domain", 100, MSG_NOSIGNAL, NULL, 0) = 100
7295  15:33:19 sendto(3, "<31>Mar  5 15:33:19 cifs.upcall: handle_krb5_mech:
failed to obtain service ticket (-1765328377)", 96, MSG_NOSIGNAL, NULL, 0) = 96
7295  15:33:19 sendto(3, "<31>Mar  5 15:33:19 cifs.upcall: Unable to obtain
service ticket", 64, MSG_NOSIGNAL, NULL, 0) = 64
7295  15:33:19 sendto(3, "<31>Mar  5 15:33:19 cifs.upcall: Exit status
-1765328377", 56, MSG_NOSIGNAL, NULL, 0) = 56

I don't know if the absence of the file
/var/lib/sss/pubconf/kpasswdinfo.AD.DOMAIN is the cause of the following errors.

What I'm doing wrong?

Best regards

Alberto

On Wed, 2020-03-04 at 15:11 -0600, Steve French wrote:
> The first thing I would look at for a problem like this is what
> kerberos ticket you are using.
> 
> The username and domain on the mount command shouldn't matter much
> since you are using kerberos tickets not ntlmv2/ntmssp.  The request
> key upcall will typically look in the key cache for the kerberos
> ticket for the user running the current process (usually root).  One
> common problem is that user's ssh into the system but it doesn't get
> them a krb5 ticket in the expected location due to the kerberos client
> library they are using (you can use the klist command e.g. "klist -a"
> to display additional information) or another common problem is that
> the user sshs into the system but then mounts while running as a
> different user (usually root) so it can't find the kerberos ticket
> that root got (you can do a "kinit" as root to get one to workaround
> this.
> 
> Sachin has a blog entry that can be useful:
> http://sprabhu.blogspot.com/2014/12/debugging-calls-to-cifsupcall.html
> 
> On Wed, Mar 4, 2020 at 3:18 AM <abrosich@inogs.it> wrote:
> > 
> > Hello,
> > I installed also the latest version of cifs-utils from source but nothing
> > changed.
> > 
> > Kernel: 5.6.0-rc4
> > cifs.upcall: version: 6.10
> > keyutils: keyctl from keyutils-1.6.1 (Built 2020-02-10)
> > sssd: 2.2.3
> > cifs module: 2.25
> > 
> > Best regards
> > 
> > Alberto
> > 
> > On Tue, 2020-03-03 at 16:40 +0100, abrosich@inogs.it wrote:
> > > Hello,
> > > 
> > > I installed kernel version 5.6-rc4 but nothing changed.
> > > 
> > > This is the command line:
> > > 
> > > sudo kinit domainuser
> > > sudo mount --type cifs --verbose //server.domain/share /mnt/cifs --options
> > > sec=krb5i,username=domainuser,domain=AD.DOMAIN
> > > 
> > > And these are the dmesg logs:
> > > 
> > > [  374.413601] fs/cifs/cifsfs.c: Devname: //server.domain/share flags: 0
> > > [  374.413627] fs/cifs/connect.c: Domain name set
> > > [  374.413633] No dialect specified on mount. Default has changed to a
> > > more
> > > secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use the
> > > less
> > > secure SMB1 dialect to access old servers which do not support SMB3 (or
> > > SMB2.1)
> > > specify vers=1.0 on mount.
> > > [  374.413635] fs/cifs/connect.c: Username: domainuser
> > > [  374.413639] fs/cifs/connect.c: file mode: 0755  dir mode: 0755
> > > [  374.413643] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as Xid: 2
> > > with
> > > uid: 0
> > > [  374.413645] fs/cifs/connect.c: UNC: \\server.domain\share
> > > [  374.413670] fs/cifs/connect.c: Socket created
> > > [  374.413673] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo
> > > 0x6d6
> > > [  374.414805] fs/cifs/fscache.c: cifs_fscache_get_client_cookie:
> > > (0x000000001802b6c5/0x00000000a61d46cb)
> > > [  374.414810] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 3
> > > with
> > > uid: 0
> > > [  374.414812] fs/cifs/connect.c: Existing smb sess not found
> > > [  374.414818] fs/cifs/smb2pdu.c: Negotiate protocol
> > > [  374.414840] fs/cifs/transport.c: Sending smb: smb_len=252
> > > [  374.414898] fs/cifs/connect.c: Demultiplex PID: 969
> > > [  374.415589] fs/cifs/connect.c: RFC1002 header 0x134
> > > [  374.415599] fs/cifs/smb2misc.c: SMB2 data length 120 offset 128
> > > [  374.415601] fs/cifs/smb2misc.c: SMB2 len 248
> > > [  374.415603] fs/cifs/smb2misc.c: length of negcontexts 60 pad 0
> > > [  374.415620] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0
> > > state=4
> > > [  374.415627] fs/cifs/misc.c: Null buffer passed to
> > > cifs_small_buf_release
> > > [  374.415630] fs/cifs/smb2pdu.c: mode 0x1
> > > [  374.415632] fs/cifs/smb2pdu.c: negotiated smb3.1.1 dialect
> > > [  374.415637] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> > > [  374.415640] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
> > > [  374.415642] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
> > > [  374.415644] fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
> > > [  374.415646] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> > > [  374.415648] fs/cifs/smb2pdu.c: decoding 2 negotiate contexts
> > > [  374.415650] fs/cifs/smb2pdu.c: decode SMB3.11 encryption neg context of
> > > len
> > > 4
> > > [  374.415652] fs/cifs/smb2pdu.c: SMB311 cipher type:2
> > > [  374.415655] fs/cifs/connect.c: Security Mode: 0x1 Capabilities:
> > > 0x300067
> > > TimeAdjust: 0
> > > [  374.415657] fs/cifs/smb2pdu.c: Session Setup
> > > [  374.415659] fs/cifs/smb2pdu.c: sess setup type 5
> > > [  374.415664] fs/cifs/cifs_spnego.c: key description =
> > > ver=0x2;host=server.domain;ip4=xxx.xxx.xxx.xxx;sec=krb5;uid=0x0;creduid=0x
> > > 0;us
> > > er
> > > =domainuser;pid=0x3c7
> > > [  374.431889] CIFS VFS: \\server.domain Send error in SessSetup = -126
> > > [  374.431898] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid
> > > = 3)
> > > rc = -126
> > > [  374.431903] fs/cifs/connect.c: build_unc_path_to_root:
> > > full_path=\\server.domain\share
> > > [  374.431906] fs/cifs/connect.c: build_unc_path_to_root:
> > > full_path=\\server.domain\share
> > > [  374.431909] fs/cifs/connect.c: build_unc_path_to_root:
> > > full_path=\\server.domain\share
> > > [  374.431913] fs/cifs/dfs_cache.c: __dfs_cache_find: search path:
> > > \server.domain\share
> > > [  374.431917] fs/cifs/dfs_cache.c: get_dfs_referral: get an DFS referral
> > > for
> > > \server.domain\share
> > > [  374.431921] fs/cifs/dfs_cache.c: dfs_cache_noreq_find: path:
> > > \server.domain\share
> > > [  374.431932] fs/cifs/fscache.c: cifs_fscache_release_client_cookie:
> > > (0x000000001802b6c5/0x00000000a61d46cb)
> > > [  374.431944] fs/cifs/connect.c: CIFS VFS: leaving mount_put_conns (xid =
> > > 2)
> > > rc
> > > = 0
> > > [  374.431946] CIFS VFS: cifs_mount failed w/return code = -2
> > > 
> > > 
> > > Best regards
> > > 
> > > Alberto
> > > 
> > > On Mon, 2020-03-02 at 13:19 -0300, Paulo Alcantara wrote:
> > > > abrosich@inogs.it writes:
> > > > 
> > > > > I've changed the environment.
> > > > > The linux client now is a Debian machine with testing flavour to have
> > > > > the
> > > > > latest
> > > > > versions of the involved softwares. These are the versions of some of
> > > > > them:
> > > > > 
> > > > > Kernel: #1 SMP Debian 5.4.19-1 (2020-02-13)
> > > > > cifs.upcall: version: 6.9
> > > > > keyutils: keyctl from keyutils-1.6.1 (Built 2020-02-10)
> > > > > sssd: 2.2.3
> > > > > cifs module: 2.23
> > > > 
> > > > I'd guess the following commit would fix your issue:
> > > > 
> > > >     5739375ee423 ("cifs: Fix mount options set in automount")
> > > > 
> > > > but could you please try it with 5.6-rc4?
> > > > 
> > > > Provide full dmesg logs as well.
> 
> 

