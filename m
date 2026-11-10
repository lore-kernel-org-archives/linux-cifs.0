Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794295695;
	b=xcQwZS/DosPwYC6pkIrPjLS28awrNTTDW61ZizT65x9f5qYaHlCbOfkq24AB8LNG7vGF
	 I8RT1w+FnCeFYYMxnIXGsm4xvR0kr5nzwsgT92De662qDc9XlNsNlVpHSeY7jEbYsmork
	 4fOrgCIjiRGgqeV2kT9y/vbF3nbSOH3zLEyOLQmW3PnUTFbpMsjWqLZKVY2XmrPxKYIuI
	 ZtGrRWAtXliPKId9HGxmKWcy1oGm1inqzVzKLngBmhN2Iqbl7NNpzfUO3TNoRkmQknyC0
	 gmd91XMaCsmLVBRYnrgvFzqcDRzTQcOxrlLVd2u+sA+k4armlMBOzy9Ui4kJ8Qv4XWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794295695;
	h=DMARC-Filter:DKIM-Signature:X-Virus-Scanned:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=M4r2qj7P4QEx7t98vQMOBPu9orxS4AyICajawHUCaJE=;
	b=hG30X1ijneadVl1JU5H2wV4rctWspJpzABhDbl2ZZyrbUDPS3LCYF3PLv96vDx5zao8W
	 R3GMn9ih/S7JbaBdicKtpXZsy5dn+2rlra+Q4SS1AV8gsRb7drxTR1IERlWOyvFv1bMEL
	 6Lfe48GVXCiZnZ6diiP1IXiwWUpmDt3jEeIMYZ7lCcyGe9QWDxMk3mn5BDn5q6JZ9+87L
	 YVDD/rC7Jpu22Kft0UrydW+ajjaK3jr4IWn7Fo20+zbLv5QBD7xuAW3pJ/vTWxLVsiSi+
	 rs3U5pyGTI2S9WhySHAaqSSQsVYQUpkXfBro8rT82t4KkngN5kQhKeIpB1DUS0RA3MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=pass smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=CqRPeBZR;
	arc=none smtp.remote-ip=173.212.254.19
Received: from proxyplus-primary (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B08606A31C;
	Tue, 10 Nov 2026 07:28:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11B08606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=CqRPeBZR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxist.de; s=201705; h=from:to:subject:date:message-id; bh=M4r2qj7P4QEx7t98vQMOBPu9orxS4AyICajawHUCaJE=; b=CqRPeBZRTid32NIDO1Fo39yS3qxCXMTZoy8RV+och/8pD0WmpfZW6Ce4ilN6pQ/GzQ58wLz5I8hufLVplK3SxIxt4loiMZJq2TrS9Gkw3UxolFM6GJoY8FWSkTMLpPOxzllCgtv84EHi/PTBkGyTjPrHkRM4n1EmEBznFYzHxSp6Ktb/okJzYEwhd4FscwG1pF0jC0ZApDzurln6OT8SctaDL2GEq5v+EEBVcLyYTsntM316ec61U31yl9EFTrMSUt+lQfRJ/FBwOXIs/YvVCQ11EWs7nIVS+FpR58/ZLEsEBKbYEezlivgbZNbH7nLizVT8Vs8ckpDyqKuND3Wsog==
Authentication-Results: proxyplus-primary; auth=pass smtp.auth=c0b31cfa-45fd-47d9-942d-1f6e173ca729
X-Virus-Scanned: proxyplus-clamav builtin
Received: from dibsi-vdi.intranet.tuxist.de ([94.31.110.105]) by proxyplus-primary (ProxyPlus) with ESMTPSA; Tue, 10 Nov 2026 07:27:35 +0000
From: Jan Koester <jan.koester@tuxist.de>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	brauner@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/6] ksmbd: Windows SIDs for user and group ids
Date: Tue, 10 Nov 2026 08:27:39 +0100
Message-ID: <20261110072745.1546158-1-jan.koester@tuxist.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Changes since v1
(https://lore.kernel.org/linux-cifs/cover.1793168155.git.jan.koester@tuxist.de/):
- 4/6: the token's SIDs are compared with the ACEs' through a new
  exported smb_sid_equal() next to compare_sids(), which also replaces
  the private copy of the same comparison in idmap.c. compare_sids()
  and its existing callers are unchanged, as some rely on its prefix
  matching (Namjae).
- 4/6: the SID mapping stays an on-demand lookup on a cache miss, as
  discussed; no change there.
- 4/6 also converts the smb_check_perm_dacl() caller in
  smb2_handle_app_instance_id().
- samba-technical dropped from Cc: it only takes mail from subscribers.

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
adconnect for the directory lookups.

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
 fs/smb/server/idmap.c                 | 315 +++++++++++++++++++++++++++++++++
 fs/smb/server/idmap.h                 |  25 +++
 fs/smb/server/ksmbd_netlink.h         |  62 ++++++-
 fs/smb/server/mgmt/user_config.c      |  21 ++-
 fs/smb/server/mgmt/user_config.h      |   7 +-
 fs/smb/server/server.c                |   2 +
 fs/smb/server/smb2pdu.c               |  37 +++-
 fs/smb/server/smbacl.c                | 267 ++++++++++++++++++++++++----
 fs/smb/server/smbacl.h                |  19 +-
 fs/smb/server/transport_ipc.c         |  72 +++++++-
 fs/smb/server/transport_ipc.h         |   5 +-
 13 files changed, 797 insertions(+), 55 deletions(-)
 create mode 100644 fs/smb/server/idmap.c
 create mode 100644 fs/smb/server/idmap.h

-- 
2.56.0
