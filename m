Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5DD3806DD
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 23:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776814833; cv=none; b=ZP+IcEusESjvkCJNSdbDlDKcFhtVWMJLNsFnWpX1YuLGYXzeCU+PeiJJ2d/sqj3ajxx4ltsV+x+apfvla92XuP6YDKeP5wGTm96n54R1ILMC+Fo7R8CcbwEWALYgDxltyBC09HUNMd+Go9qAHx/qgw9bpvb6CsluQ25+0LLp3XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776814833; c=relaxed/simple;
	bh=FAjd0SGYlTGbrBuZkkUHlFzHmjvnupkiWc5/sWK4Frc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SifaiU5rHPbURed//HuafqN5bYkEx5sd6oBsenNABiTgql3vT9kxF7oq4eeytK0PMoRmYEj+EQhwRL6ZIsuARi9npwajN/n7x6mJBy5Lt5WSQGGKlhXiwu/VjCzMtBa/J0PDCkONBlq2AVnV9j94208QJoXdv99E0GWZ+QfoNI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/KYD38C; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/KYD38C"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b038a00370so34899836d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 16:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776814831; x=1777419631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WHYPowIO/Ty/lLtBU9hns/rmbNm5oK+oGzhuJOxaFBs=;
        b=E/KYD38CDdCa0WDj2RnqfZ0gy0G5TYbjL4OQ8UrFBMedffCPEg9BrhMXWeaLh4XdKh
         uV48BmGHysY3wOsgTky57ggCu6VaBU0Tdqx6bP7XNedOQ0qEihQRm8Bi8cRoJQWS6efv
         Jgl9s74VpVQfkxliYxhXZs3aAs64VPPU6hgWvvGZ8Gg6bz8CkEfN0xP6QxDWscuMUYJM
         HVlJTywkRjPdj5eepDrOgyu75SQgTJPCzN+WUo5G6Nq1MpdbqiPipD/XAfrMupzSP/iR
         cOKPXPzQjTOirg89GrhCx0FnoaGDnx8VOI+AdCgMd6HDwSkYdHezR4gvEPGxMk3SrP7Z
         99zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776814831; x=1777419631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WHYPowIO/Ty/lLtBU9hns/rmbNm5oK+oGzhuJOxaFBs=;
        b=dRdzwDbMCi6wf3ouIfgK//vX+j24rzaOKXYQyjQSPQ+8s2FcMBxLuZueNFuHvRYJTW
         NcSoTeNxHphlwbilnfgjn/O+2sjSuUxMnrtiOITd2thjotSY3P6revzVBvihf3RyE/6s
         diEb9TQzUuBMd2uOg5joRau/QgXs6QjxQsaNF1wHmm6HgItV3qC419sA17Sa6sobQbYD
         B8Ie9eXmKIl3T6nDCpbwsK5w+XFgcFOS8D7AUQv09LKTPknb/Aviz1XIxC5PfOVRnI3a
         EoWG8EzxqcTpTaPOfPvdXLQPvV3CGyFfaWssQS8pXrDldiWy8PG1x+SwgniOce9GIeNj
         ulkg==
X-Forwarded-Encrypted: i=1; AFNElJ+aAPZH2Bvz1yuYJ0D19xwFxQ21bZg3WE7XzjwPIEHGHKqZwRNO3wMc9XFmINseD+fRSLO2IBqotHPL@vger.kernel.org
X-Gm-Message-State: AOJu0YyNGBOKHDPLNCAiRA0KdoXesqNu/kTnHx5sFtc2cAexR/+sjT/B
	twmLN9MRL5y5ASoeZZTHaUtLFGYUEElS1CoJaY/twshjomn5xlHRht50BZQ1gzEJ
X-Gm-Gg: AeBDieuMpFt7rinbM2Q6xpj4NZ54c/eSgU6Syiya2pyMdfUYC/dmSaL5Ww4E+jfonkC
	/EoFG0RTpkzjoOCz4gZf+uUrfL6SEMfN9a7R1/P1O6Wv0v2RWQR6RRaU+zzKeNWtCjiJomWsyP2
	3t5oe0SRzm0Kdp+ix7IxTcRUwg44VGij9soUoBee66q1Hk9Aky7d7PjB3mrFWEDI9HN3hl+Gjv0
	oTXvWR5fYzGigOjWizZFhtlOeZJMzGddlV3AbFt4pkE+mOubxEwI3QM6uWNFmxieTQOWchNsel5
	w/Oq1xRuGflqT8bv8CsGFQd/YRolKEbX2knMU1XEOd9K6uJH5Ac7MMrmMdlLAKLt3X1UVz/SSYj
	64xvKv4yvR6JsIoW4N6DtptVQas3eYQXvXInS4IL+h83WZQWO7nUbyqdRUxwQi2C5a7JmqNNsxh
	7KwdkM7FAhS3v7a4VxTWwlsZ61txtd8pFAnpIr10mgK0O7QGlZfpfRfH1y0VAZg34EUhp1RTkH0
	c6n3ayvLfoeeqUoyXf0LWAKoOg80xo=
X-Received: by 2002:a05:6214:2f03:b0:8ac:af0d:c101 with SMTP id 6a1803df08f44-8b027fd9d3fmr313865016d6.10.1776814831016;
        Tue, 21 Apr 2026 16:40:31 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae86947sm152590596d6.37.2026.04.21.16.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 16:40:30 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Steve French <stfrench@microsoft.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	oe-kbuild-all@lists.linux.dev
Subject: [PATCH] smb: client: scope end_of_dacl to CIFS_DEBUG2 use in parse_dacl
Date: Tue, 21 Apr 2026 19:40:22 -0400
Message-ID: <20260421234022.4144209-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <202604220046.tGkRxVtS-lkp@intel.com>
References: <202604220046.tGkRxVtS-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After validate_dacl() was factored out in commit 149822e5541c, the
local end_of_dacl in parse_dacl() is only read by the dump_ace()
call under #ifdef CONFIG_CIFS_DEBUG2.  With CIFS_DEBUG2 off the
variable is assigned but never used, which gcc -W=1 flags as
-Wunused-but-set-variable.

Remove the local and compute the end-of-dacl pointer inline at the
single call site inside the existing CIFS_DEBUG2 guard.  No
functional change: when CIFS_DEBUG2 is enabled the argument value
is identical to what the removed local carried; when CIFS_DEBUG2
is disabled the code was already dead.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604220046.tGkRxVtS-lkp@intel.com/
Fixes: 149822e5541c ("smb: client: validate the whole DACL before rewriting it in cifsacl")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/smb/client/cifsacl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 4ec204d2c774..ec5d47779304 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -836,7 +836,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	int i;
 	u16 num_aces = 0;
 	int acl_size;
-	char *acl_base, *end_of_dacl;
+	char *acl_base;
 	struct smb_ace **ppace;
 
 	/* BB need to add parm so we can store the SID BB */
@@ -860,7 +860,6 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	   user/group/other have no permissions */
 	fattr->cf_mode &= ~(0777);
 
-	end_of_dacl = (char *)pdacl + le16_to_cpu(pdacl->size);
 	acl_base = (char *)pdacl;
 	acl_size = sizeof(struct smb_acl);
 
@@ -876,7 +875,8 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 			ppace[i] = (struct smb_ace *) (acl_base + acl_size);
 
 #ifdef CONFIG_CIFS_DEBUG2
-			dump_ace(ppace[i], end_of_dacl);
+			dump_ace(ppace[i],
+				 (char *)pdacl + le16_to_cpu(pdacl->size));
 #endif
 			if (mode_from_special_sid &&
 			    ppace[i]->sid.num_subauth >= 3 &&
-- 
2.53.0

