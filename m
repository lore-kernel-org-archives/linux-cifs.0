Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E34C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Feb 2022 19:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiBTTIN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 20 Feb 2022 14:08:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbiBTTIM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 20 Feb 2022 14:08:12 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AA940E67
        for <linux-cifs@vger.kernel.org>; Sun, 20 Feb 2022 11:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=6roXkl1hawGu1OtzMYvihsEZoXJVgvf/ELRFmzr3u8o=; b=QusTwOZYue7d3HkoxyAhlO4unZ
        Qw0LKtN0UUwSvRjpi9uyalcZ6sdUkpEQHttM5UcNU6oEvVYUe1z4wvRp2meSl1n9HmgesYdDyudLq
        kWC9D1ye3xqSkxr0JmnBJySKVhMpqrYQ1v80bdd5C/wgiekodhxPTzM8yhBSx3Q/m+c08/HC3bYpc
        50VsoGX+Zi8SODJiRroaOe/kPTETjkYyu3pEXaEDEFt8DNaCWST2YcIuvdFhMYaksfln+P0L4slKU
        kZsuYFdVazsbtX/UawN8fwk6H48m20RrCnHlUfLqZH07BoW9ZVtI5JZp2HuLL1GIvTcY4jkqEOVlt
        P+1GyCUhgpvuXVqnOk6XK+ig2u9mrBWN6J9CWU2g9ejgUlczLITI5ehZ09BoZdzskWc1qsIH5WzLE
        JvKjHv9g2i5V1AYOrNOk/D0G+tieXBdwySAQG2cWKfTm7uqCxtR03hWxf5wfyW1oIxVe6Uc+ickY/
        vFNzjESOjIKntvMDgmMxvAas;
Received: from [2a01:4f8:192:486::6:0] (port=59788 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nLrYh-004gg2-6B
        for cifs-qa@samba.org; Sun, 20 Feb 2022 19:07:47 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nLrYg-0034Wx-FU
        for cifs-qa@samba.org; Sun, 20 Feb 2022 19:07:46 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Sun, 20 Feb 2022 19:07:45 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richard.flint@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-jr8d9dN2Dp@https.bugzilla.samba.org/>
In-Reply-To: <bug-14713-10630@https.bugzilla.samba.org/>
References: <bug-14713-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14713

--- Comment #39 from Richard Flint <richard.flint@gmail.com> ---
Appreciate it has been sometime since this was updated but I just wanted to
update this for completeness. I have tested this on Fedora 35
(5.16.9-200.fc35.x86_64) and can confirm successful negotiation of 3.0 3.0.2
and 3.1.1 with Solaris 11.4 servers both with and without encryption (as
enabled by the seal parameter).=20

E.g. the following is successful:=20
//myserver/myshare/myfolder /mnt/myserver/myfolder cifs
noauto,nounix,vers=3D3.1.1,seal,noserverino,ro,_netdev,noexec,nosuid,perm,n=
odev,iocharset=3Dutf8,cache=3Dstrict,sec=3Dntlmv2,credentials=3D/root/passw=
ord,port=3D445,context=3D"system_u:object_r:myapp_content_t:s0",forceuid,fo=
rcegid,file_mode=3D0440,dir_mode=3D0550,uid=3D1000,gid=3D1001
0 0

Though noisy. E.g.:

[Sat Feb 19 08:34:30 2022] CIFS: decode_ntlmssp_challenge: authentication h=
as
been weakened as server does not support key exchange
[Sat Feb 19 08:34:30 2022] CIFS: VFS: \\myserver\myshare error -9 on ioctl =
to
get interface list
[Sat Feb 19 08:34:30 2022] CIFS: VFS: \\myserver\IPC$ smb2_get_dfs_refer: i=
octl
error: rc=3D-19

Intriguingly, despite specifying nounix in the mount, Wireshark shows we are
still sending SMB2_POSIX_EXTENSIONS_CAPABILITY in the Negotiate Protocol
Request - I'm not clear if that is the desired behaviour.

The issue is still reproducible on the latest CentOS 8 Stream release, but =
that
it works on Fedora 35 makes we wonder if an issue was fixed in the meantime
that never got back-ported to CentOS 8. If that's true, then this isn't rea=
lly
a fault in the CIFSVFS product itself I think - or maybe it isn't anymore.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
