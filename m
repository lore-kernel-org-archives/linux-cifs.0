Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705A314A8B
	for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 00:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779063125; cv=none; b=S8MViJHlFOf/lUQxiiVCB2V7cBP5NwyhnyNrHQvdM9so3+NKmI3bmCuyeRh6RiU4bAUwiRBIgQMOnMmyWepHRszizb2o56ZfpvKdC0Skay3hNp5Ne4wiz4EFAInEQ5+Jhk7riBxnYgwrHFAF99pKWRiaBGXvaRzxCKRSwaRZwfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779063125; c=relaxed/simple;
	bh=KVjJNxcyTgwPTRdAr4r8Yh7pAXqku4sn53MOOnoBVMU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=prygNFZAjmV/Qna+xS1EEovaCtNKE4Hv4rT/uqw6sg3rEY01mxVE1bb43y7LfkD3NyVrDFA5yesr461INx94GAIsg8kjvC9HwVXPhQQgkVO3gF5R9UO/ElPHRLECjRzgrBi2lo+gV2j9b4A9dwakG82mpQofrndshTUqc59ZtRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mPWoYwUp; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPWoYwUp"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-912475287a5so190816685a.2
        for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 17:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779063122; x=1779667922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UQLRqqIXi5TmHp4J/vedRu4WjTVYGEWcMBgCRYzppyQ=;
        b=mPWoYwUp/8axx6xxxTT+hetSd8TaJeNd3Hc2RmJCB7o7vhzuTaPdxi/Bw3mfqzX2qB
         BtFV0kVMeb462t3FrO1HapqWEr6rYlZiXJKvQTQJ1Y/mui8cDBwzI9ylMqOfocW4LEin
         JmfvFaPhhaSujXc9Y4VNzKXMkRatHiuZIJgd+04eRvGsw3A0hmOZQahndpbTT+tm7IZd
         xyd7WUZNjXFNAim36bu2GmZV97uZg/+V95BtdcBD2CpDGIwEXWVhtqzCcTSPb7ncn+1X
         97vQ6isR3r+mHQgt35cBMT2Y0vmi1kz00rHMSWupKjVvJHCeHq7uwjxbTtK0LQh1Dm54
         OzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779063122; x=1779667922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQLRqqIXi5TmHp4J/vedRu4WjTVYGEWcMBgCRYzppyQ=;
        b=XfQ8Fr1h4Oza+DlmygJ3z/i59ZnFyaZGfC6fmiCs6VhkVb5n578sJGWbLbPuMJ6D6g
         3fe/K2/j1UR8TRjiUFReIJ/7kXKY+JrniKBBflZUThrH8//8kWWt6HMiYODSAt9huyvR
         jCnyazZoGK2YTGrTqJYDK3Y5LNIAhZkQ7qydGbdJcEn1oKkXpYUgmb3GawPk/IKAR75/
         Z0+jzeOS+hJvAn9AquUT2JtOFYJh1rbrc21TYde9A9QZrc+2FOC5+lpsK9WXU0IsV3RL
         ZHlB5OcOH0KtAvBa9DZ+PeTNEdDa6q+z/EtdK4ao7MwsVM+wm+DAZ2O6yDal9Es14lul
         vBwA==
X-Forwarded-Encrypted: i=1; AFNElJ/9tDV+0wXARVymWGlc+0ZVJCIWB3/VpYegpJUh0Rf0LP4KTPc/mvY3Srfm2OwZCXJcVoRgKY6MWdIF@vger.kernel.org
X-Gm-Message-State: AOJu0YxScCmzv7p31oItB8+Q54iuxmghcy9aPdn29CXfi1XnvAlsIwf5
	bn73WRj36u5OooZW3Y6GYXTJXcr2XcpXOL0XUQwn6ss7QwstZHSNynbU
X-Gm-Gg: Acq92OF4X+LpcIpjYlWE1s1kVaD9N+uxnThbIwFK9v0MuM68Y3xcfH8OZ9X2kDrKHeA
	YiYV6oHpsE36AUWG90K4uW4IQAL11lUWcks9EG3dSRxc7Yxz1S4aDClUHJDgHRPxLsmJwWLnTNK
	4wUZjcxHxoDktF6EdixlhfxCRvsHikYxDXD1Pu0yo+GjoLcMvrRmcfTXAlg1y6CUmLAns17Nx8/
	IqMLYYe31W5Qt4XqKlnhoiYQxRx4Z9ZXxU8zLNx5q9BMK6TTOefAKHUcuIYgLv+dsBkfKxwgMxh
	7KwR3SsA/955t/PS270qLWSffXAYtD9za3kTmRRwv4nfhHj++gsqQYwgCCtkRkjRTLFHHCtgw/O
	3b8F0QhUB8IAV8bj7DQIQBg6bDuNO50cI65In+AY7QwQp3Zgu9dxFntv2mSRBIHev91gSL5ky7G
	LTbitv7tw+Gur/EqDRiKb+INzR8CeF5SnIZBGCVvroSJOpGZYjjWF1G+ALUXZ5/8ynEOMdB5gWm
	i03QZmYgMf7zXyK3/SMoX5WJJsGJwHtWW0H0IO0DTY=
X-Received: by 2002:a05:620a:1790:b0:910:4023:4fd5 with SMTP id af79cd13be357-911cda50abfmr1969211585a.4.1779063122384;
        Sun, 17 May 2026 17:12:02 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba463814sm1302131285a.5.2026.05.17.17.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 17:12:01 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Samuel Cabrero <scabrero@suse.de>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] smb: client: fix CIFS SWN notify lifetime and permissions
Date: Sun, 17 May 2026 20:11:48 -0400
Message-ID: <20260518001150.1323245-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the CIFS witness notify fix series.  v1 fixed the
basic cifs_swn_notify() use-after-free and added GENL_ADMIN_PERM to
the incoming notify command, but review pointed out that the lifetime
fix still trusted the raw tcon pointer cached in cifs_swn_reg.

That cache is unsafe because cifs_get_swn_reg() lets multiple tcons
for the same net/share name share one witness registration id.  If the
first tcon goes away while another same-share tcon keeps the
registration alive, swnreg->tcon can dangle.  Taking tc_lock through
that pointer is therefore still a use-after-free, and taking tc_lock
while holding cifs_swnreg_idr_mutex also violates the documented CIFS
lock order.

Patch 1 changes the SWN registration model so the registration stores
only stable witness identity: registration id, net name, share name,
and notify flags.  Notify handling copies that identity under
cifs_swnreg_idr_mutex, drops the mutex, and then finds and pins a live
matching tcon under the normal cifs_tcp_ses_lock -> tc_lock order.
Register and unregister messages use the caller's live tcon rather
than a cached registration tcon, and the unregister path no longer
finds a registration, drops the mutex, and later puts a raw pointer.

The intended one-registration/many-tcon semantics are therefore:
a registration id represents a net/share pair, and notify handling acts
on a live representative selected at use time.  If the registration id
exists but no live matching tcon remains, cifs_swn_notify() reports
that separately instead of logging "registration id not found".

Patch 2 keeps the GENL_ADMIN_PERM gate for SWN_NOTIFY and also adds
GENL_MCAST_CAP_NET_ADMIN to CIFS_GENL_MCGRP_SWN.  The multicast group
carries register messages that include the registration id and, for
NTLM-authenticated mounts, username/domain/password attributes copied
from the CIFS session, so unprivileged local users should not be able
to join the group.

Build, static, and runtime validation for this revision:

Targeted UM build of fs/smb/client/cifs_swn.o and fs/smb/client/netlink.o
on top of v7.1-rc2 rebuilt both touched objects with no new warnings.
scripts/checkpatch.pl --strict on both patches is clean.

I also ran a KASAN + PROVE_LOCKING QEMU build with the existing ksmbd
test harness that advertises CLUSTER capability so the client witness
path is exercised:

  - root-sender race campaign, four parallel mount/umount profiles,
    using root notify senders to bypass GENL_ADMIN_PERM and stress the
    lifetime fix directly: no KASAN, oops, or lockdep signatures
  - same-share regression: two witness mounts with nosharesock shared
    one registration id; after unmounting the first tcon, CLIENT_MOVE
    against that id completed successfully on the remaining live tcon
  - CLIENT_MOVE trace: unregister-for-old-IP still precedes
    register-for-new-IP
  - echo/check path: echo_interval=1 drove cifs_swn_check() while
    DebugData exercised cifs_swn_dump()
  - SWN_NOTIFY permission probe: uid 65534 gets -EPERM; root reaches
    the handler and receives the expected no-registration -EINVAL
  - multicast permission probe: uid 65534 gets -EPERM joining
    CIFS_GENL_MCGRP_SWN; root joins successfully

The notable runtime results are summarized above.

Changes since v1:

  - remove the raw struct cifs_tcon pointer from struct cifs_swn_reg
  - resolve and pin a live matching tcon after dropping the SWN idr
    mutex
  - avoid taking tc_lock while holding cifs_swnreg_idr_mutex
  - keep unregister send and kref put under one SWN mutex section
  - distinguish "registration id not found" from "no live tcon"
  - mirror extract_hostname() / extract_sharename() byte-for-byte in
    the new cifs_swn_tcon_matches() helper to avoid GFP_KERNEL
    allocations under cifs_tcp_ses_lock and tcon->tc_lock
  - restrict joins to the CIFS SWN multicast group
  - add runtime coverage for the shared-registration case called out
    in v1 review

Michael Bommarito (2):
  smb: client: resolve SWN tcon from live registrations
  smb: client: require net admin for CIFS SWN netlink

 fs/smb/client/cifs_swn.c | 314 +++++++++++++++++++++++++++++++--------
 fs/smb/client/netlink.c  |   6 +-
 fs/smb/client/trace.h    |   2 +
 3 files changed, 267 insertions(+), 55 deletions(-)

-- 
2.53.0
