Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168407;
	b=AkCV5cC4spL9g3bpnLVFMxv8tAMCkxbQ0wzkYZlRCtXMTphhQG05LGhJfFgHhxD8u8sH
	 51WMhe47L9Bb2bHVkq3QLJPyr9dj67J6Y2sGXVDkRSxOew+2Kh2QhVlSpbCR296Mt4ZYR
	 7oFRnFWXkd4BrVZ1AsZGi9g8uTu0VVrIWgn/YG3rWvPaEfby0nXkZbyCLIL9nM+dzhUhf
	 OfzN6yfAEbpyAOA5h8Mkn2ZuE+0IlDemjsD6OXZtB4nN5/CeBpqdIpfBT2rmxQ2Wcti+5
	 NGVBAZ2+jybp+y0xe1sDSHUpGM//T2CZ/U2hBdlV7bzC8fWnhwCuBVclTpycLW149Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168407;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:Subject:To:Cc:
	 Date;
	bh=doXMqxRODfzcrsGtOjzu7RBeQRWg5UN0ZwTEGSD08Jk=;
	b=aBrYAncFDOuO07ihFcXc2XC+tE5AOwp4HT4mgi+MGkA03WmLaa2dSc9+yFLpSY8V5idP
	 ygCc+/LGpR1fTjgyE+25p8bsWWglM8FuJWUA/UAAWIZelaPL1NIsuieF2/WUDOyZbL/ZY
	 Hs61gD8QD+F3ZMl7foh/LqRTzC2dpekDW2fOJifm1WFoA7PHXlfl2vr+5FyQeo2a+aPyZ
	 SmIfJpZweOuH6l89hpsCA6/vZOw0kJdUyxNbGzK05myym7gPD9VWukE9SJLaJ5RmYC8Rg
	 IIIangxc1OS8okllnUwz25klmsAjF9Ka9zQ82pM8foCKXeH/+hHtRkeUXcKnauC8BjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=fail smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=f20wnOYR;
	arc=none smtp.remote-ip=173.212.254.19
Received: from groupware.tuxist.de (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550D7606A31D;
	Wed, 28 Oct 2026 06:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 550D7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=f20wnOYR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tuxist.de; s=201705;
	t=1793168397; bh=/5Ih0Wj6tbWvcXAfgwCbxvF48Wd3xvVfYp7DaJM315w=;
	h=From:Subject:To:Cc:Date:From;
	b=f20wnOYRTzAM3yyd9ZOGDken8BO94ZeLlb4vOe3XyGemByk4FLJ7AmX/pxeNwnXhc
	 jRkgsv2XCghYfqTlBdtliC9yurOAeZUO242+7RscaghApfC29DKjrm3TUQtpKJAILx
	 Tzc4vx2rtJ6hSXcFpCLiJx3bAhYT8kgGDlO26iZEcmyFUQQqAE9HfotFjZCX+jFyba
	 3t8HwHbWg1PlKxVfyWYh8Rej49Iu+jIPlh0Qo6WgRTEvrTdbdMzjvUGOKRv7vst3b4
	 0D0Mgedd0Vc405zWR92ims1G2LykFaG7P8FG7QfS9gsySjXrSa3KZ1rGV6Pi1HSVCf
	 p/CmHRG5uxEMA==
Received: from [10.1.1.106] (unknown [10.1.2.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by groupware.tuxist.de (Postfix) with ESMTPSA id 8AB2D8A0236;
	Wed, 28 Oct 2026 07:19:57 +0100 (CET)
Message-ID: <cover.1793168155.git.jan.koester@tuxist.de>
From: Jan Koester <jan.koester@tuxist.de>
Subject: [RFC PATCH 0/6] ksmbd: Windows SIDs for user and group ids
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Christian Brauner <brauner@kernel.org>,
    linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Wed, 28 Oct 2026 07:19:57 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

Hi,

Windows names owners and ACL entries by SID; for a domain account that
is its objectSid. ksmbd shows a file's owner, group and POSIX ACL
entries as S-1-22 SIDs or as its server domain SID + uid, which a
Windows client can't relate to the domain's accounts, and a SID a client
sets for a domain account doesn't map back to an id at all. This series
lets user space, which knows the directory, translate between ids and
SIDs in both directions, for accounts that are logged in or not.

It applies on top of the UUID/GUID id RFC (uid_r v2,
<cover.1792552161.git.jan.koester@tuxist.de>) and the NTLM pass-through
series (<cover.1792345559.git.jan.koester@gmx.net>); the netlink events
it adds follow theirs. Patches 1-3 are independent of uid_r in substance;
I can rebase them onto mainline to go on their own if that is preferred.

1/6 ksmbd ignored the owner and group of a descriptor without a DACL,
    which is what Windows sends to take ownership (and smbcacls -C/-G),
    and still reported success.

2/6 After setting a POSIX ACL from a DACL, the following chmod used the
    owning group's bits as the mask and left named entries without
    effect.

3/6 passes the domain of an NTLM login (NTLMSSP DomainName) to user
    space in the formerly reserved room of the login request, so a user
    space serving several domains can tell DOMAIN\user from OTHER\user.

4/6 adds KSMBD_EVENT_SID_MAP_REQUEST/RESPONSE for a user space that sets
    KSMBD_GLOBAL_FLAG_SID_MAP at startup: the SID of an id ksmbd shows,
    the id of a domain SID a client sets. Answers are cached (mappings
    5 minutes, "none" 1 minute, "couldn't say" never). Showing a
    descriptor never fails on a missing mapping; setting one fails with
    STATUS_NO_LOGON_SERVERS, STATUS_INVALID_OWNER or
    STATUS_INVALID_PRIMARY_GROUP instead of being applied in part or
    ignored. The session user also matches ACEs for its groups' SIDs,
    like a Windows access token.

5/6 shows classic users as S-1-22-1-<uid> instead of the per-server
    domain SID + uid, and still takes the old form.

6/6 documents it in Documentation/userspace-api/uid_r.rst.

The user space side is sharedd (FenrirOS' ksmbd user space) with
adconnect for the directory lookups. Tested in a VM against a directory
server: owner and group of accounts that aren't logged in, ownership and
group changes, DACL round trips, a session getting access only through
a nested group, inherited CREATOR OWNER ACEs, and the directory going
away (cached mappings stay, new ones fail cleanly).

Questions:
- Is a netlink round trip per uncached id acceptable here, or would you
  rather have user space push the mappings of a session's ids at login
  only? The latter can't cover owners that aren't logged in.
- compare_sids() matches a SID against any prefix of it; the token uses
  an exact comparison. Should the existing callers move to that too?

Thanks,
Jan

Jan Koester (6):
  ksmbd: don't ignore the owner and group of a descriptor without a DACL
  ksmbd: keep named ACL entries effective when a DACL sets a POSIX ACL
  ksmbd: pass the domain of an NTLM login to user space
  ksmbd: map user and group ids to Windows SIDs through user space
  ksmbd: show classic users as S-1-22-1-<uid> on every server
  Documentation: uid_r: describe ksmbd's SID mapping

 Documentation/userspace-api/uid_r.rst |  18 +-
 fs/smb/server/Makefile                |   2 +-
 fs/smb/server/idmap.c                 | 320 ++++++++++++++++++++++++++
 fs/smb/server/idmap.h                 |  25 ++
 fs/smb/server/ksmbd_netlink.h         |  62 ++++-
 fs/smb/server/mgmt/user_config.c      |  21 +-
 fs/smb/server/mgmt/user_config.h      |   7 +-
 fs/smb/server/server.c                |   2 +
 fs/smb/server/smb2pdu.c               |  35 ++-
 fs/smb/server/smbacl.c                | 256 ++++++++++++++++++---
 fs/smb/server/smbacl.h                |  18 +-
 fs/smb/server/transport_ipc.c         |  72 +++++-
 fs/smb/server/transport_ipc.h         |   5 +-
 13 files changed, 793 insertions(+), 50 deletions(-)
 create mode 100644 fs/smb/server/idmap.c
 create mode 100644 fs/smb/server/idmap.h


base-commit: bdd1d550e3f518d445d199c8ee73dc962c5abab8
-- 
2.56.0

