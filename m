Return-Path: <SRS0=S2CZ=4U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A742CC3F2C6
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 15:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D52820848
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 15:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inogs-it.20150623.gappssmtp.com header.i=@inogs-it.20150623.gappssmtp.com header.b="llKS+tiW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgCCPkx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 10:40:53 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46299 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgCCPkx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 10:40:53 -0500
Received: by mail-wr1-f68.google.com with SMTP id j7so4853144wrp.13
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2020 07:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=inogs-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=IF5dPtNe0AL+ANqQOIwuJI3fqHz6NDLAQ9H6SFan71Q=;
        b=llKS+tiWGUh2+1/Ny0O+t2VPxO37fGJyLkgUWj30bUeewYckLtoR4SQ2fswiFaR7LI
         Xsc5tchXjs1OKUL8VAly7q8a8pkUQr3acOCeVhCnZ5ip1rQYaRV7Qd2luGr3ZF/QZgBX
         /aUiWNGtGYfm8g91TkjDaBL/Bbpcvw+acX2QRcQXgZ/zebcAHKdrsbioNh1YtV8QATPo
         d/G9xABkgSAcCRJCqZjmPWWkliq9dA895S0l/qVK5Nmd3a4pf3d4LYE+OUWqk8HgB/WL
         lzQQcNjLR3LDknS4pwENzun0u1pKdSDBVUXSEYo9JlKsP6vrkhXV73soVIHF032Unuck
         HGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IF5dPtNe0AL+ANqQOIwuJI3fqHz6NDLAQ9H6SFan71Q=;
        b=ZVrIp3pLb/O4TPvPIkZUOKvJgzkmAr7h6kQEWHmDXamSO9FUhKfkSheMX2O0KporEj
         CqOMzXE0gQ21RQf96gLNbFew1lwSdbJ077wAQj0662rz29xid3urEA4nXVWFRtLn95UX
         Uw6gFtY/0V4POFZ6Vy1oUEPuWSl513xifBaK+QnMsH+4Ldb6OVjqwuzHDj/3ZStPLpK3
         HRtimhJKvPqqRfm3s9bcIkuoAyrRPb0wJOZSwgqzm6clMQxyk8D8KH3fElWnKNEp3Oa9
         QP6dngi8SdDYM7M1h29wd/4S6dUU6ip3nhsJsBou9m71iScPjbJvDDH1SCZsNsZcfrcB
         //Sg==
X-Gm-Message-State: ANhLgQ37RRIJ2hEJwq5aESSP8GSYTF5hK3c6/xQxCp785YC1SdinkrbT
        Us5fPjvHni2G4/xNUnRca8cwcXVgFK5MwQ==
X-Google-Smtp-Source: ADFU+vvpAmUoZhT6qEyGX7F6FsGMGe91aMc1wIWT93jwACwGXoZyhb5elsMtpPSzLjgMcfQTw1tFCA==
X-Received: by 2002:a5d:4382:: with SMTP id i2mr5823319wrq.424.1583250050062;
        Tue, 03 Mar 2020 07:40:50 -0800 (PST)
Received: from deimos.ogs.trieste.it (deimos.ogs.trieste.it. [140.105.70.97])
        by smtp.gmail.com with ESMTPSA id i7sm5248280wma.32.2020.03.03.07.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 07:40:49 -0800 (PST)
Message-ID: <6eb9b4d8d22629a0b78f12abf7e8a30c547b8c07.camel@inogs.it>
Subject: Re: Permission denied mounting a DFS share with multiuser options
From:   abrosich@inogs.it
To:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Date:   Tue, 03 Mar 2020 16:40:48 +0100
In-Reply-To: <87a74ysp99.fsf@cjr.nz>
References: <5a987faff74646e68207e26e570a708669dd4103.camel@inogs.it>
         <CAH2r5mu5dedRmPQzRUH=E87J2txsBv3DiFYZLT-a_xYay=2czA@mail.gmail.com>
         <4c74eb81aa7757e48679eb83c2f2dcbfeb841a3f.camel@inogs.it>
         <87a74ysp99.fsf@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hello,

I installed kernel version 5.6-rc4 but nothing changed.

This is the command line:

sudo kinit domainuser
sudo mount --type cifs --verbose //server.domain/share /mnt/cifs --options
sec=krb5i,username=domainuser,domain=AD.DOMAIN

And these are the dmesg logs:

[  374.413601] fs/cifs/cifsfs.c: Devname: //server.domain/share flags: 0
[  374.413627] fs/cifs/connect.c: Domain name set
[  374.413633] No dialect specified on mount. Default has changed to a more
secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use the less
secure SMB1 dialect to access old servers which do not support SMB3 (or SMB2.1)
specify vers=1.0 on mount.
[  374.413635] fs/cifs/connect.c: Username: domainuser
[  374.413639] fs/cifs/connect.c: file mode: 0755  dir mode: 0755
[  374.413643] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as Xid: 2 with
uid: 0
[  374.413645] fs/cifs/connect.c: UNC: \\server.domain\share
[  374.413670] fs/cifs/connect.c: Socket created
[  374.413673] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
[  374.414805] fs/cifs/fscache.c: cifs_fscache_get_client_cookie:
(0x000000001802b6c5/0x00000000a61d46cb)
[  374.414810] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 3 with
uid: 0
[  374.414812] fs/cifs/connect.c: Existing smb sess not found
[  374.414818] fs/cifs/smb2pdu.c: Negotiate protocol
[  374.414840] fs/cifs/transport.c: Sending smb: smb_len=252
[  374.414898] fs/cifs/connect.c: Demultiplex PID: 969
[  374.415589] fs/cifs/connect.c: RFC1002 header 0x134
[  374.415599] fs/cifs/smb2misc.c: SMB2 data length 120 offset 128
[  374.415601] fs/cifs/smb2misc.c: SMB2 len 248
[  374.415603] fs/cifs/smb2misc.c: length of negcontexts 60 pad 0
[  374.415620] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4
[  374.415627] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  374.415630] fs/cifs/smb2pdu.c: mode 0x1
[  374.415632] fs/cifs/smb2pdu.c: negotiated smb3.1.1 dialect
[  374.415637] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
[  374.415640] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
[  374.415642] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
[  374.415644] fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
[  374.415646] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
[  374.415648] fs/cifs/smb2pdu.c: decoding 2 negotiate contexts
[  374.415650] fs/cifs/smb2pdu.c: decode SMB3.11 encryption neg context of len 4
[  374.415652] fs/cifs/smb2pdu.c: SMB311 cipher type:2
[  374.415655] fs/cifs/connect.c: Security Mode: 0x1 Capabilities: 0x300067
TimeAdjust: 0
[  374.415657] fs/cifs/smb2pdu.c: Session Setup
[  374.415659] fs/cifs/smb2pdu.c: sess setup type 5
[  374.415664] fs/cifs/cifs_spnego.c: key description =
ver=0x2;host=server.domain;ip4=xxx.xxx.xxx.xxx;sec=krb5;uid=0x0;creduid=0x0;user
=domainuser;pid=0x3c7
[  374.431889] CIFS VFS: \\server.domain Send error in SessSetup = -126
[  374.431898] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 3)
rc = -126
[  374.431903] fs/cifs/connect.c: build_unc_path_to_root:
full_path=\\server.domain\share
[  374.431906] fs/cifs/connect.c: build_unc_path_to_root:
full_path=\\server.domain\share
[  374.431909] fs/cifs/connect.c: build_unc_path_to_root:
full_path=\\server.domain\share
[  374.431913] fs/cifs/dfs_cache.c: __dfs_cache_find: search path:
\server.domain\share
[  374.431917] fs/cifs/dfs_cache.c: get_dfs_referral: get an DFS referral for
\server.domain\share
[  374.431921] fs/cifs/dfs_cache.c: dfs_cache_noreq_find: path:
\server.domain\share
[  374.431932] fs/cifs/fscache.c: cifs_fscache_release_client_cookie:
(0x000000001802b6c5/0x00000000a61d46cb)
[  374.431944] fs/cifs/connect.c: CIFS VFS: leaving mount_put_conns (xid = 2) rc
= 0
[  374.431946] CIFS VFS: cifs_mount failed w/return code = -2


Best regards

Alberto

On Mon, 2020-03-02 at 13:19 -0300, Paulo Alcantara wrote:
> abrosich@inogs.it writes:
> 
> > I've changed the environment.
> > The linux client now is a Debian machine with testing flavour to have the
> > latest
> > versions of the involved softwares. These are the versions of some of them:
> > 
> > Kernel: #1 SMP Debian 5.4.19-1 (2020-02-13)
> > cifs.upcall: version: 6.9
> > keyutils: keyctl from keyutils-1.6.1 (Built 2020-02-10)
> > sssd: 2.2.3
> > cifs module: 2.23
> 
> I'd guess the following commit would fix your issue:
> 
>     5739375ee423 ("cifs: Fix mount options set in automount")
> 
> but could you please try it with 5.6-rc4?
> 
> Provide full dmesg logs as well.

