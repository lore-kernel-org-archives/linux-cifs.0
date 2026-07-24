Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3FF248893
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889686; cv=none; b=qMfNYOkLWBOZYBTAu9i08W2kVb3BYYWfA0LT6jmcKNlCHCIbdmR4VQHHv8htVRWp0tRzl7nlk7KS/+0hFMNTiS9WMs/2+TD7QmfaG20dBziN5qAwYcsalxMU10ISMFGkw5UMKJ/HI841NUCZ6s0uWRWx3r8ieqik4kvPbSBVUf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889686; c=relaxed/simple;
	bh=RSmQAXhObH/bYMnGcCR2Dfd5Z+gMrKOuWqASsOxAwbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmsHfYxUekt6R0WXI0f6I9cjQDE6a3PnCAFgLpf/Wpdf2lo5P/V2CimZBnaT0LyFV0icTFmDSXH9V71TZEdVukG7FaAJ4rJXaoNUPiLJX++FQBZPW/PrSlAceGKOmTGgy+RDSDvRu5JZzZ2NcEsmlp10oHZSWfSwBIOD/jL5stE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 33e02f82874c11f1aa26b74ffac11d73-20260724
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2833ec38-5eb5-4742-9ab3-9996a56e629f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:2833ec38-5eb5-4742-9ab3-9996a56e629f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c6d8aca15335c6c1a7617ed150e0ef5d,BulkI
	D:260724184118WZGMR124,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 33e02f82874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1662463279; Fri, 24 Jul 2026 18:41:18 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	linkinjeon@kernel.org,
	slow@samba.org,
	pc@manguebit.org,
	jra@samba.org,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn
Subject: [PATCH 12/15] smb: client: avoid batch oplocks for reentrant POSIX EAs
Date: Fri, 24 Jul 2026 18:40:06 +0800
Message-ID: <c8d554906ee1093a732435c6178394c0b519b502.1784888897.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784888897.git.tanze@kylinos.cn>
References: <cover.1784888897.git.tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Native killpriv handling can reopen a path for EA queries or removal
while a write handle is active. Without lease support, a batch oplock
cannot identify the temporary EA open as the same caching owner and can
deadlock while breaking against the blocked write path.

Request no oplock for data-writing opens when POSIX extensions and
xattrs are enabled but leasing is unavailable. Leave read opens,
non-POSIX mounts, and servers with lease support unchanged.

After applying the native EA patches, configure the server with oplocks
enabled and SMB2 leases disabled. Use an SMB account that maps to root
or an admin account on the server.

Mount both the TEST and SCRATCH shares with SMB3 POSIX extensions and
SID-encoded Unix IDs:

  $ TEST_USER=fsgqa
  $ TEST_UID=$(id -u "$TEST_USER")
  $ TEST_GID=$(id -g "$TEST_USER")
  $ MOUNT_OPTS="credentials=/path/to/credentials,vers=3.1.1"
  $ MOUNT_OPTS="$MOUNT_OPTS,posix,idsfromsid"
  $ MOUNT_OPTS="$MOUNT_OPTS,uid=$TEST_UID,gid=$TEST_GID"
  $ export TEST_FS_MOUNT_OPTS="-o $MOUNT_OPTS"
  $ export MOUNT_OPTIONS="-o $MOUNT_OPTS"

Then run:

  $ su root
  $ XFSTESTS_DIR=/path/to/xfstests
  $ cd "$XFSTESTS_DIR"
  $ ./check generic/093

Signed-off-by: Ze Tan <tanze@kylinos.cn>
---
 fs/smb/client/smb2file.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index f35b6488d810..b07ff4570f56 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -160,6 +160,13 @@ int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec
 					 cifs_sb);
 }
 
+static bool smb2_open_writes_data(const struct cifs_open_parms *oparms)
+{
+	return oparms->desired_access &
+		(FILE_WRITE_DATA | FILE_APPEND_DATA |
+		 GENERIC_WRITE | GENERIC_ALL);
+}
+
 int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		   __u32 *oplock, void *buf)
 {
@@ -192,6 +199,17 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		retry_without_read_attributes = true;
 	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
+	/*
+	 * A killpriv EA reopen without a lease can break this write's batch
+	 * oplock and deadlock against itself.
+	 */
+	if (IS_ENABLED(CONFIG_CIFS_XATTR) && oparms->cifs_sb &&
+	    !(cifs_sb_flags(oparms->cifs_sb) & CIFS_MOUNT_NO_XATTR) &&
+	    oparms->tcon->posix_extensions &&
+	    !(oparms->tcon->ses->server->capabilities &
+	      SMB2_GLOBAL_CAP_LEASING) &&
+	    smb2_open_writes_data(oparms))
+		smb2_oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 		       &err_buftype);
-- 
2.43.0

