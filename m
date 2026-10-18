Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06173EFD0E;
	Sun, 18 Oct 2026 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792346008; cv=none; b=u+vg8inG9vOz11OEg4E6Ocgjj34Q36rSD3KnqDH0pzs74lSfZsTk3t7xBkN9zRofl/Q6V3iO1OhesSmEihhiVu4DcGoRbFJcmahVvno3HDFrLpfer3x2C25kLw2RZ3QRYU84ZoS3yqw0yIJg3077KkKVRaT7wwEed8zuH8iA7po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792346008; c=relaxed/simple;
	bh=n3Nds5bgpG/JAHM0pFdSCGcUG0lWLJLVtJbkNGHKOjE=;
	h=Message-ID:From:Subject:To:Cc:Date; b=Ht2BescHqL1aOfvf3tE00/HlC4WlgtzqLDYuYGn/Vbe2mSDC6pYj+0PL5whtYx7rJsYKsa4dIy9MW//R25AU6O3FsxCZt5pDcZAV2Zg7LKq15oNu7dldG5E01TlOUV/x866LCcqfu3BonWBHW/2jn8FBkDJwMaV8ccKz44bPhys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b=WpXFsghG; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b="WpXFsghG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1792345996; x=1792950796; i=jan.koester@gmx.net;
	bh=HiageaLU7PDrKjhAgcDMq6YDvQMkrjIcbDb5XqSxjxE=;
	h=X-UI-Sender-Class:Message-ID:From:Subject:To:Cc:Date:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WpXFsghGQB/130TeUD5QgKzweL4XEWRBs3uRMyRYWtSZQGwzjmuzgB2vSy0xvMoh
	 eYTMf3AuhCixH/S+FKvgk9Wd3FC/YEQ1GWGb6JIyOPGSsvZd69cYne+Y6ex8AfJyQ
	 FxHnkrEgAstt4wwiar0DqlkQ/aVecdPT1Ir3rsEpedx1BtPjBdDG5oZvIVHFMo94s
	 n2ULjHeqhmQ19qfwfudcMecOxu4YVWkJxoppy3BXaFYajZaTD44B8XE2wFMf1dxx+
	 MjWNlimigC32dRBJGeMVXcqjeIqPI4GpGWzyUYO2GyDiRVtfkr6DERcHyPSKPtYX/
	 v5VmimFkooB1Cgtwhw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MplXz-1woidV0fTJ-00gGq9; Sun, 18
 Oct 2026 19:53:16 +0200
Message-ID: <cover.1792345559.git.jan.koester@gmx.net>
From: Jan Koester <jan.koester@gmx.net>
Subject: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 19:53:14 +0200
X-Provags-ID: V03:K1:QYXzFwv8tcrcNGZ0x+JuOS2iOvJVKue1qVIkG/CbHbsIdVnM2UP
 kpX64scEc9/vAL7BLafcy2ODKcHL1vjTLp7KcoAS+BcNWdGQTr1EP2vNAP6iO74KvtT0lks
 7Pm0ha1kfjhd1sKLiUSpRK+KkxLCpv7I9WATLJVLV9yITd4JmPqJDqygph279M/ej98mV1j
 h9E8TgMeEgKm5BMokuBJQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:w89379Gbzys=;GFsWZQPfB/VZYWeaxrWNkce9uJz
 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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

Hi,

a ksmbd server joined to an Active Directory domain can authenticate
domain users with Kerberos, but not with NTLM: it has no password hash
for them, so the NTLMv2 response can't be checked locally. Clients that
fall back to NTLM (access by IP address, machines outside the domain,
mount.cifs with user name and password) are refused.

Samba solves this by forwarding the response to a domain controller
over NETLOGON (NetrLogonSamLogonEx on a schannel connection). These two
patches give ksmbd the kernel half of that, and leave the NETLOGON client
to user space, like the rest of ksmbd's user handling:

1/2 adds a KSMBD_USER_FLAG_PASSTHROUGH login flag. For such a user,
    ksmbd_decode_ntlmssp_auth_blob() doesn't compute the response from a
    local hash. It sends the server challenge, the user, domain and
    workstation names and the NT/LM responses to user space in a new
    KSMBD_EVENT_NTLM_AUTHEN_REQUEST event, then takes the session base
    key from KSMBD_EVENT_NTLM_AUTHEN_RESPONSE and goes on with the
    existing key exchange. Both events have a strict netlink policy and
    are checked in ipc_validate_msg().

2/2 puts the workgroup, not the netbios name, into MsvAvNbDomainName and
    MsvAvDnsDomainName of the challenge's target info. A domain
    controller checks these when it verifies the NTLMv2 response (Samba
    in NTLMv2_RESPONSE_verify_workstation()), so without this patch
    every pass-through login fails with NT_STATUS_LOGON_FAILURE. The
    patch also checks that the challenge blob fits the response buffer,
    since the workgroup can be longer than the netbios name.

Logins of users without the new flag are checked as before. The only
change they see is the domain names in the challenge's target info
(patch 2/2). ksmbd-tools doesn't set the flag yet. The user space side
we tested with is sharedd/adconnect from FenrirOS: it marks domain users
without a local hash as pass-through, and it answers the event through
a NETLOGON schannel client, tested against a Samba 4.22 AD DC.

I can send the matching ksmbd-tools change if the interface looks
acceptable.

The series is based on v7.3-rc7.

Jan Koester (2):
  ksmbd: pass through NTLM authentication to a domain controller
  ksmbd: put the workgroup into the NTLMSSP target info's domain names

 fs/smb/server/auth.c          | 109 +++++++++++++++++++++++++++++++---
 fs/smb/server/ksmbd_netlink.h |  41 +++++++++++++
 fs/smb/server/smb2pdu.c       |  21 ++++++-
 fs/smb/server/transport_ipc.c |  73 ++++++++++++++++++++++-
 fs/smb/server/transport_ipc.h |   3 +
 5 files changed, 236 insertions(+), 11 deletions(-)


base-commit: 32c52ec87d6245ee2d12ed5dd509e40062939b50
=2D-=20
2.56.0

