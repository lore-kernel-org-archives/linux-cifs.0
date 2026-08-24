Received: from mail.amicon.ru (mail.amicon.ru [77.108.111.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6E225B083;
	Mon, 24 Aug 2026 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.108.111.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787582448; cv=none; b=RbxV1NA4iGxerUX+i3aajZsWH38AL66ikqKmc6s5704SnCoCb6AAKccUsjZyf1B35e10A36YmcCX6WDscpJXnYctC9ij40kT2B12rM7ANkmE+qKCpduuXbJhNSe38QbKvyAd4klwmTrRTYoeSPb2eLisdrp+pMyHu49qsS38q+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787582448; c=relaxed/simple;
	bh=V1q2o3bM0UJXljAjvLFZgvGUWqFH10QWoCSptq+YvbE=;
	h=Content-Type:From:To:CC:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version; b=fX6eZyTvJ4JNM+hEXgjazZ17HDCl+d4rK0PSVdKXpimSEUhrE7rT+qEnsGts2oVknuSfeasLJU1iI9BVPazL/jI9jD5hPvoqvoSBjgeOAb1q6Nt2tbmlxuc4I7MRNw7DEO3ynkaxX0kDJhksK+jV02wg2mOEbOUlPEbK+9X2BzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru; spf=pass smtp.mailfrom=amicon.ru; dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b=Yn7ojGwQ; arc=none smtp.client-ip=77.108.111.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amicon.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b="Yn7ojGwQ"
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; d=amicon.ru; s=mail; c=simple/simple;
	t=1787582440; h=from:subject:to:date:message-id;
	bh=V1q2o3bM0UJXljAjvLFZgvGUWqFH10QWoCSptq+YvbE=;
	b=Yn7ojGwQF9Yl2ZQPqpQdbLm9mnCztprs+1whQC9n7zAX2k6csZQ2lqSyCMrr2TersQ9cHmFyEip
	UWB7vQzW4SpgRgfswV69PWrX51WxUfK8OS0gC2e64qBZbvbbkWwO1sPNxC5vOZ+KapasJOd0xS671
	jkyHCRWNjolc9IFJvNpbZFq1VDkZSBKxSMYAwchDIP72Ari01Mki9pIegX5KrkghdhQB33Jvnx1hr
	VjEoFfTkQTOHjNl8sRmmr9Ze6k0Z9TkRlKsuP7DIsSifos6F5pDwU/AFXFdBpDOqcMYDvfJVVK8+u
	qskFJjDEiGe7J8YHQ9SXKfr995VmyDt1hIXw==
Received: from localhost.localdomain (192.168.0.250) by mail.amicon.lan
 (192.168.0.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Mon, 24 Aug
 2026 17:40:38 +0300
From: Aleksandr Khromov <haa@amicon.ru>
To: <linkinjeon@kernel.org>, <smfrench@gmail.com>
CC: <senozhatsky@chromium.org>, <tom@talpey.com>,
	<linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, <haa@amicon.ru>, <rrv@amicon.ru>
Subject: [PATCH v3] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Mon, 24 Aug 2026 17:40:30 +0300
Message-ID: <20260824144030.444300-1-haa@amicon.ru>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260824102248.178152-4-haa@amicon.ru>
References: <20260824102248.178152-4-haa@amicon.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: mail.amicon.lan (192.168.0.59) To mail.amicon.lan
 (192.168.0.59)

smb2_get_info_filesystem() reports 56 bytes for FS_POSIX_INFORMATION,
that is the whole of FILE_SYSTEM_POSIX_INFO, but never assigns
FileSysIdentifier.  Those eight bytes go to the client as they are found
in the response buffer.

The buffer is zeroed on allocation, so a standalone request leaks
nothing.  A compound request can leak: the offset of the next response
is advanced by the length pinned for the previous one, so a reply that
was written into the buffer and then dropped in favour of the short
error response of smb2_set_err_rsp() stays there, and the next reply is
laid over it with only the header cleared.

Report the file system id statfs() returned, which is what the field is
for.  FileSysIdentifier is __le64 and f_fsid is a pair of ints, so
assemble the value first, val[0] as the low half, and convert it on the
way out.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
---
v3: FileSysIdentifier is __le64, so assemble the value and convert it
    instead of memcpy()ing the host representation of f_fsid into the
    field (Namjae Jeon).  Patches 1/3 and 2/3 of v2 were applied to
    ksmbd-for-next, so this is the only one left of the series.
v2: https://lore.kernel.org/linux-cifs/20260824102248.178152-4-haa@amicon.ru/

 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5e83ad4f085e..a5771474b2af 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6167,6 +6167,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			info->FileSysIdentifier =
+				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+					    (u32)stfs.f_fsid.val[0]);
 			rsp->OutputBufferLength = cpu_to_le32(56);
 		}
 		break;
-- 
2.48.1

