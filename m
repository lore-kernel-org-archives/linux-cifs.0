Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9794315F
	for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 00:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779063130; cv=none; b=MjI7yb89I9z9POjFKZhwQkqaPGYBOBE0dzxgITNSlM1HW2EcTmi1JYbeDwCMdFt9/C7BsEhzShSbTwbMSYCX75okkB2fP8wWanMYPX56O/Iu8jtZR8VWccFeVhmdFax//lznOYya+PjLRuCEqPMbcJ95IV+eoxcReBR4sIfM5p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779063130; c=relaxed/simple;
	bh=hZ2s3bYyC849WhRpbjz47wBYW2bqeoYAepeRDbHrjMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnD/OXEVbfveSSx71VL4miqFvVSPcLL8TdDfqgLhz5mVwFh+qXZgyfZqT7ruXHG7tlQ/OKQDXw2D7XFHa2lhhUHO8BqaMjFedlu2QG1FqaI76XJzngPSrIihDNzJY4w14x8Q8HreT5jwGoevyOR5gA2knQZ7b0Y+GHNxMhU/ysk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kek2f7E8; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kek2f7E8"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-911488599e3so218872885a.3
        for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 17:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779063128; x=1779667928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezHZ13i3eCkMlaokSKeUT4qhol7hZOeBasCQQK8buDM=;
        b=Kek2f7E8Qs9uFQ/ka5yuKSrY+BR2iS5vnyCWRlw92s+XXcZhpECk1xtYmJl+x7kgOq
         58oM5ZkXl2mzEyi0EgfhLHUb15IAO/WvRm5VWJ2AxluC77Ttfv5OgeIJ/wZ26pxmHUqM
         zgLpQiRIC6pd9my/CZEo16Ebnli5eKK6ytjynJgoYnAnddK/s4QD5JsnOUUZqJW4Cvif
         MpfAPpKEjpnDUk8O+AxTm/WMdYAspWhwJTYLofHV9hsxWPF2JonxrjJMFKdUYJMTo8ki
         XO/0W/4BGOt63LvVjCC45/39TMOsUd82HdK2jNgDIv9EQtG7EYgbhDw/oKQrQ1K8rmJw
         FmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779063128; x=1779667928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ezHZ13i3eCkMlaokSKeUT4qhol7hZOeBasCQQK8buDM=;
        b=gLLtNVc6jGZwCJNBW72ims4vwLRWZkoNkkZ0BTCpoWAeXZJkDkbzHEyu8cVDzqjQ0f
         jJWzRnZZr0BwiM8Z+E/k2SqmVMXFgPc6VaHB510CVaEReWwi1xZAYPSEqjXoqlVpwmRH
         WWINJUQW0TfQX8WTH3UkkbvuXHQNkMgcaGysX37Q4goODXfWTlLgfyM6hrilMud3Iwox
         z8t618ytrhWGa7lP+L80gSwK1Ct8nq7IY/wiBHYV7JyWABx3FiBspa8Cd4xuerviUZle
         61jshe+LxmZhLhlH3O+Nz/2o881JB2095kfiXeYZKEdAJIUYrHnOCljPMWV4QNvOQxd0
         SfaQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Z95oHqm/w0SGhLal5cHAD/3HGO+xxpMUe8M1guEsJXUOge2dFxP184jmOu7IzHilQdxf6cTf4dA4j@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2BrpIeZtQYz3LH15lDKDzJA5UGXUBYB1QyQ4sdMoWz28K8+3f
	t0vIWMqXYLh3hQGmwWzR24VVWiFGpPOI7QrCs+gKGkIuAd31J3xNBYhkgwho1sVi
X-Gm-Gg: Acq92OGtFEN7vGzDNnDuIbI4zKYTr84UgdMURG41PDX/hAdhuEHlXsED/EHRIHrkBIi
	KpiTFV8BHXkh5Dv01HQOZR5bT51d2FOKmARuC10RtOMTC5AWvLF7rhFmWyvv3Hs3nrS3F0hxnjp
	YVWZumKuvBhVWpBv8ygVfg7G9rPC9Svg+NtRo2wNUwT6xQ9SsyzZ0foy0f/ToYakVyfK5gEmv2M
	Z/vbeGCjXv19mxbPqp7ke/stk3Yy9rtYJcTKoR/E0H/+VH6m6R+4dvGGsYiOKBB/HTNFwxYvro1
	JQx0nR7+LrYa9BwXD6n8/7pga25i4aFZhPgxBfnLbfaW8KJPn8sig/NWt5FkuJ2OIROzwDbXG1e
	gjUNamkrWD0i9FlNR9E1F4RScu7YlnYuWCB/5HeqmcGZ2QQgVFbwk0lLiXEWyzGI6LlGQMOqACS
	g4CYE0d7KsL33pBRaT10JxESm1rkheUmstum9Iqb5S4YmVFt37z5C1V23ID9G4vRFYaxA9S+rVV
	Nyrsl8heUkuVfeOq5i/i20apORKQcoBAWZtc/SMqaw=
X-Received: by 2002:a05:620a:6cc1:b0:910:3019:f463 with SMTP id af79cd13be357-911cce86fbfmr1906344285a.8.1779063127992;
        Sun, 17 May 2026 17:12:07 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba463814sm1302131285a.5.2026.05.17.17.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 17:12:07 -0700 (PDT)
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
Subject: [PATCH v2 2/2] smb: client: require net admin for CIFS SWN netlink
Date: Sun, 17 May 2026 20:11:50 -0400
Message-ID: <20260518001150.1323245-3-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518001150.1323245-1-michael.bommarito@gmail.com>
References: <20260518001150.1323245-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CIFS_GENL_CMD_SWN_NOTIFY is the userspace witness-notify command.  The
intended sender is the cifs.witness helper, but the generic-netlink
operation currently has no capability flag, so any local process can send
RESOURCE_CHANGE or CLIENT_MOVE notifications to the in-kernel witness
handler.

The same family exposes CIFS_GENL_MCGRP_SWN without multicast-group
capability flags.  Register messages sent to that group include the witness
registration id and, for NTLM-authenticated mounts, the username, domain,
and password attributes copied from the CIFS session.  An unprivileged
local process should not be able to join that group and receive those
messages.

Require CAP_NET_ADMIN for incoming SWN_NOTIFY commands with
GENL_ADMIN_PERM, and require CAP_NET_ADMIN over the network namespace for
joining the SWN multicast group with GENL_MCAST_CAP_NET_ADMIN.  The
cifs.witness service runs with the privileges needed for both operations.

Fixes: fed979a7e082 ("cifs: Set witness notification handler for messages from userspace daemon")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/smb/client/netlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/netlink.c b/fs/smb/client/netlink.c
index 147d9409252cd..0dd10913c37a0 100644
--- a/fs/smb/client/netlink.c
+++ b/fs/smb/client/netlink.c
@@ -33,13 +33,17 @@ static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
 static const struct genl_ops cifs_genl_ops[] = {
 	{
 		.cmd = CIFS_GENL_CMD_SWN_NOTIFY,
+		.flags = GENL_ADMIN_PERM,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = cifs_swn_notify,
 	},
 };
 
 static const struct genl_multicast_group cifs_genl_mcgrps[] = {
-	[CIFS_GENL_MCGRP_SWN] = { .name = CIFS_GENL_MCGRP_SWN_NAME },
+	[CIFS_GENL_MCGRP_SWN] = {
+		.name = CIFS_GENL_MCGRP_SWN_NAME,
+		.flags = GENL_MCAST_CAP_NET_ADMIN,
+	},
 };
 
 struct genl_family cifs_genl_family = {
-- 
2.53.0

