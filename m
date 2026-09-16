Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011036.outbound.protection.outlook.com [52.103.39.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77C24E56C7;
	Wed, 16 Sep 2026 10:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.39.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789555806; cv=fail; b=I1+xiiu4+oge+B8AIo9aKSpJKO6DkiWMXxmPT2iJSeikJ64ucDeZ6J80MlAHemYapwV9VtU4U0Hfqm5YMRcV/krRCaIdItUuth2JBPBd0W/rxnbBtpxYVraSBH9HIq5Qpz1ioTToag6X20/ZFq0IMd9/La4EOn25nAjEN3Ew2pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789555806; c=relaxed/simple;
	bh=PZovdgJLKKrrK4650llKJ32TbTBFmX4NutU7Xt9TPms=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=udqDDRwxmV4AM+tJq4iK0s5SPQDyOmH/F03WrI3L5qlGH6y81X1EIJ2wAWXFM/N8Z1aQB9J20l5JOT1aFqqZQ/xAXCPXwUluc+nA49ePLr+9qGYquDtsqQ5+3hf/EYghHYan8RgQ05GR2Kw1Mj5jQ1ADqR9K2WeQZCeuKuelAh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=FeITsGkI; arc=fail smtp.client-ip=52.103.39.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="FeITsGkI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOAHh4eCBwYDVLL4WJLn2j462X3nzdMZwUlKIbi67GnliSa5KEh0Yjg7QDhnJmJbGVkuRnLSXKR7ppGUqe8rs2UYngPXb78sT9Kk3lk91ioI0uLy4p167dSFGboHiuGbrKiyCcZGNxHIs52sGyf8CRRlZW+vR1Ukdn5xYFUdTa31v35z4w/+U+2WJYdmORjGaWH28m0ykOYXiCZq8xRy/kMkzmFkinc6pQTl6PTDP4YohjZmRqUQj2NgPNQOnTVRJb5gl8JPPilXDKT+YtZXcUt2chg/Y/2OOJHry1EU3lrADfns4jXvWM0EZCU3PKuz5elkzIbWdRZPIhOksXY/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxISeNYsdCPhy9m4AawHsiwHLbPj/mJ3BIxnAntxNj0=;
 b=nlyVerGqlypASmlpUiasH6Q1gDbsWZjgCz4noo559IWh2VIRjCQHKd/sS2pnV7ZJItbDC2QcA1n9t2n9A+wGDEQXrSn29lMFYAGcYr0a7SdgG64QWMC11rBwMEAxP0snQg4B/HmCrXs7OkaWCEia7xWLTQfaBYPOZfOtml3U+b/0yFV+/YJXg3I5dXyTZCAsu5ZesJ9djlc3W4TUNORBIl49Rrkuc6JA2I3sKRV8yYkysF60e2NuVyQu1nwlH8xd2V0UOgl/NlqfTu33+eu7Sis6XR9tmUmAi5gpaw6PkvHJD+VUM8BJ6m74ZmmODqArSL4K/Q6JIE0kQM9pY6oIhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxISeNYsdCPhy9m4AawHsiwHLbPj/mJ3BIxnAntxNj0=;
 b=FeITsGkIsnMI2/j2tI1d5CqcnT1v6mq/raZFy8oRlHJ7k5M3uIhlG30kMPRpAktAP9YLiOnSbVYqRln3aQc0dmQPTcioSC+2EEq2rAfP9j1Lev+EGGg+5ZZum5bR4xTRxTXUigRJI3QphtjW305iSxbHR5iPhPpEHp1Vmy9JYRZjOXpCh9bgI0GD9sZCaBB0sa4Vd53WyIkl4VIkktmRffn+Sv7E4Wlque/mdwpbgaoUNAvIiumBfENTKKW+bpR5SgZxjkP4+/6BkGy0iMZcMCFgk5SrLOgn93xOjJtkwobO9Ui7xeTslOM+Pe7Wc9otdEdVZZWi8N2I90FZFuDglg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AS4P251MB0798.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:511::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 10:49:30 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 10:49:30 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: deny access for an empty DACL instead of granting the request
Date: Wed, 16 Sep 2026 11:49:27 +0100
Message-ID:
 <AS8P251MB000104EEF679ECC44D8791F2C8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0117.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::20) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260916104927.18825-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AS4P251MB0798:EE_
X-MS-Office365-Filtering-Correlation-Id: 64158b6e-6db4-4d4e-7125-08df13e02f66
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|4140399003|55001999006|24021099003|41001999006|51005399006|5072599009|5062599005|15080799012|23021999003|8060799015|19110799012|12121999013|25031999004|37011999003|40105399003|1602099012|10035399007|2607281247196008|4302099013|26104999009|3412199025|440099028|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l6ZRoFvGsk1Ba3Z4cGQYhSytOI9/Gjvjq/Bb4UDwiWQNixqIyoT1oFIlPxwB?=
 =?us-ascii?Q?BIQN6rt+DipFNjgkWe2KpSs5MVovSV+mtYape8OGuWGbrDklaID60voMmCHh?=
 =?us-ascii?Q?ivp9XDcvsXaPhajMPuL1ftK/SuoZAfUqyzrWYL3cIBWf8LfczbiwqUrcH5cb?=
 =?us-ascii?Q?MfeZC6vbDKvTyumQ6GiQX1WCBiLm6yQBkKYC+o2ak5/WT7yJaRfAppJ0Qcm/?=
 =?us-ascii?Q?TT+6K+ZqtUVZ71pBczng/vZV2tRAb9EvdR7sXtceb6dbH3EGQKIQ46iTX3wq?=
 =?us-ascii?Q?pvr8qDTYSaG64WtLpqwJrCxiAaQLkwunuk9qk5eODeTBhDZ3tBVy7kp9M28X?=
 =?us-ascii?Q?ydqZtuY1KA+AoaEw4nrrMssf9HiqjfKEgnOONq+1gQxu0RGNPuUA2gCxhksk?=
 =?us-ascii?Q?yWRjWWb24tJ2e8TI9feCwbr9c7xxu6QqwrMcz7WCgT5jVeNh4F5N+8plcvOU?=
 =?us-ascii?Q?byZoSbCjUoVc5Wxu9aSHMJkaZ116Jtr+AVcATqqbbg1bJGN7KxEjKJNo26ky?=
 =?us-ascii?Q?yVMtBV1YrmeIPjvF51HoJWbNbI5nkQo4DxoTQwa7QJUad4hDmT4DrHD5S/hg?=
 =?us-ascii?Q?Nk1i2R+1lCm7/NEvAXAUx2frj3sxjTzdrQuLf46cSDrrxmaS9t8rAa0D95OZ?=
 =?us-ascii?Q?jTzecCREC0ybTCw39tPB34zoOTqc641SL1CMZBVJWIGc7xBMBnxuVr1d4H9C?=
 =?us-ascii?Q?uhSu7n006FA03wXcGuNQ2JmWAyCHU3vz/eT3U6IJakmMp80spNCo2JaDZpzn?=
 =?us-ascii?Q?aNpmdEYy+eMyeLJRsG7MWzC04OUj+7D+NT+zOtuhknWvq9nUlOni1CwYJo+O?=
 =?us-ascii?Q?M21EGYmI81GKAYWR9iI9+ddNGXO2xUX4cbEkOpBHv1C4BjE0jzFc7OBhzZgs?=
 =?us-ascii?Q?J+VLHjm2HnQFxRbP+5qmdvrmg1rEYndfyZUPEinXQaKhKrnVLwPxbVm4rhTJ?=
 =?us-ascii?Q?Kkg9yfBejryyEQoQbysZDt7hpaInTR7h3GzFRP9g+edpnDjqDutiV5DsuKP6?=
 =?us-ascii?Q?kHsaqf0vTMM7kSDtZyDkpO+jVjI7pVcfQRH/Td8dMQmPzAd7C7XL/xwcMxAs?=
 =?us-ascii?Q?1T91U1/hlVw1Z8RmDt3Ww2aZTn2XIs/ebTeNDT5Hyx44trzLTzdrJ7W+x6Uc?=
 =?us-ascii?Q?TqYbndW8CfKQfSk+PnulKwXP2k7k1QWPLWLx2U4a6IhEcaC3Zj1YJ16SNlGX?=
 =?us-ascii?Q?UNclbjChBjMuXAmx03RalL94p0sWBIl4/ywyn2vdtgvJ5tt382LR8meeK8ni?=
 =?us-ascii?Q?fxFtgRwRG7lO4PogtRg0?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XTRuTLwCoTyhl8Vyc7ECGdfKDsslz4OxsiMU9IXZac6VeSidFlRIdEaJq/d4?=
 =?us-ascii?Q?1dQ6v0z/U02W36dh9zT3FoqCtqFtGc/wQ+V9R4AKkyxl9DUWPhJME06HSF8n?=
 =?us-ascii?Q?AoRNWwv7TTkDY7pUXbMYftENTA33jiue7XMPwbybfywD38bp+eTsCDNJJyEE?=
 =?us-ascii?Q?u5Ru5wm6FdsBmNWM6ZsSfKkWKEiCZiIZH5+kVWSi8aFOx5dOFPEahsia7NDa?=
 =?us-ascii?Q?Jqmm+4pqvwDDcRSsHyTY4gM/ab+GBbtthuKZn9GIsq36N7lGRM6Ccb12c+mj?=
 =?us-ascii?Q?YqJ0cl/470ps4qc3xJGmXlCHrG92KTTSd1qzUeC15bCZFlqQaLExWCrbErWg?=
 =?us-ascii?Q?UjWzeVdnZwPu5zsFDPliWIYJJX6+/UYttOpee6jX5x1vCcjNSfEv0Sv1mmgW?=
 =?us-ascii?Q?vpC67KuHESpwXRnX8bb0dZngXT4MF8qZo8wJg8ZPxAATXBW96uREDi3tgsZy?=
 =?us-ascii?Q?lvbu7dG9xd3HUSuA/RRve4hDLJ6VtlOJr3Il/3XcR2n8kSDkuFk/CbVbwHvD?=
 =?us-ascii?Q?lqVbz5Ctjj8qQM7I5EuX5wvuj3i2wY2ncPDehC9rr7Lyq2iISkHQdercoKrN?=
 =?us-ascii?Q?tne5T3WL8L/6dDGCCdt7VpjPmljfQo83yWTAn9FpJjvS6dfS2ffBdtiHrCyQ?=
 =?us-ascii?Q?e6hnfhTajrvRz8idjqxjuiPL7dpV0/FpQWtaWgCBh216BVs/RzyHi6NgZ+EI?=
 =?us-ascii?Q?IWiasPe4JSukiIsbaa4lhIuutcUqZhJgONwZnEGbFtqprPCESwG/v/MJpNA3?=
 =?us-ascii?Q?uFMaCgfA+qjbsV4Guh4qXqEoQUkYKzxg69HK+uoCzR/jFyyo3aHm4S//B6oo?=
 =?us-ascii?Q?e/UrWQNbNM4fQ1nBZlc24QkWhn07XhLgV5sg7p17ZGwQ31rBWo/3Zl3+LkSP?=
 =?us-ascii?Q?Z74/6luiCK4NfTbp4gymXL6/Z62i4EV+kChhofNXfTpy0WjcJFdQhT1HStcK?=
 =?us-ascii?Q?8wnHvBJqwPahMc+5+dOzwlteMil7QtUsa2YXhKncw7sMOSKXe5Es3uZ7PXcG?=
 =?us-ascii?Q?MOzZDOnPJWV7wsJ/z0TJNHOqpob64RONkkfP87fZJ7NDH/SYdchWn/nlWEDw?=
 =?us-ascii?Q?E0c84WoUKhGH+DcQylvScJWgo9GquDezxpfTDal5INz+LcgSYSj3WTNCGIBD?=
 =?us-ascii?Q?Sw8Gg5Debs6NTlZU1s1+F4M/iQAqsrCdcWJ0sI4/hr6Wkg8gq1/mYu/CDDJv?=
 =?us-ascii?Q?PGj+hmpVcDtjQIbfpKGIR6fvhbHmpT16huq4qBfmrWK/etoBiwTDhmFgXOXk?=
 =?us-ascii?Q?HMowcBUjAg2IVkVK+7pUSqJCIPzR4AdhE34Hv3Sx71BgJNHig6si/Pu864Sm?=
 =?us-ascii?Q?8L0iAF7A2h4GpoTA1IwiIXDeVlo+ypN2+pF+D+WKL2TTPXjwGPzTqnkobk2q?=
 =?us-ascii?Q?njc7EWQ0nTVQKetx7FQF5Zt4tJ1rJmgROdG7R2gy80ju3bAcUDpbSSXkbcr1?=
 =?us-ascii?Q?tWeGp/UZkE11QIZwhd9iBf2z1QXH6je8?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 64158b6e-6db4-4d4e-7125-08df13e02f66
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 10:49:30.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P251MB0798

smb_check_perm_dacl() returns the access mask it computes to the SMB2
CREATE handler, which uses it as the granted access for the open. For a
security descriptor whose DACL is present but contains no ACEs, the
function is supposed to deny access: an empty (non-NULL) DACL grants no
access to anyone except the object owner's implicit READ_CONTROL and
WRITE_DAC (MS-DTYP 2.4.5).

The empty-DACL branch only denies when both

  - the DACL has no trailing bytes (pdacl_size == sizeof(struct smb_acl)),
    and
  - the request contains bits beyond READ_CONTROL / WRITE_DAC.

In every other case it takes the shared "goto err_out" with rc still 0,
which returns success without modifying *pdaccess, so the caller grants
the full requested access. Three problems follow:

  - The READ_CONTROL / WRITE_DAC carve-out models the owner's implicit
    rights, but the check runs before is_owner is computed, so those
    rights are handed to *every* caller, not just the owner. For
    READ_CONTROL the SMB2 CREATE path does not fall back to
    inode_permission(), so any user can read the security descriptor of
    an object whose empty DACL is meant to deny them.

  - A request of exactly READ_CONTROL and/or WRITE_DAC is granted to any
    caller. WRITE_DAC lets the handle rewrite the DACL.

  - A DACL that declares zero ACEs but carries trailing bytes
    (pdacl_size > sizeof(struct smb_acl)) skips the deny entirely and is
    granted whatever was requested.

On shares where the NT ACL is the authoritative access control -- e.g.
"force user" shares, where every client maps to one POSIX identity so
POSIX cannot distinguish users -- this is an access-control bypass.

Compute is_owner before the empty-DACL branch and deny access from an
empty DACL unless the caller is the owner requesting no more than
READ_CONTROL / WRITE_DAC.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---

Notes:
    v2:
      - add the Assisted-by: LLM tag
    v1: https://lore.kernel.org/linux-cifs/AS8P251MB000152D9BF4B8E0601640661C8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/
    
    This supersedes both v1 postings; "ksmbd: fix empty DACL handling in
    smb_check_perm_dacl()" was the same patch sent by mistake and can be
    dropped.
    
    The bug was located by auditing smb_check_perm_dacl() for paths that
    return success (rc == 0) while leaving *pdaccess unmodified -- the same
    class as commit 08f41323f549 ("ksmbd: fix maximal access leak when
    object has no NT ACL"), which fixed one such path for the maximal-access
    caller. The empty-DACL and malformed-descriptor paths were not covered.
    
    Compiled (CC fs/smb/server/smbacl.o) and checkpatch --strict clean; the
    decision change was cross-checked with a small semantic model of the
    branch for owner/non-owner x requested-bits x trailing-bytes.

 fs/smb/server/smbacl.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index e752479..3611dc6 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1494,21 +1494,27 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	if (pdacl_size > acl_size || pdacl_size < sizeof(struct smb_acl))
 		goto err_out;
 
-	if (!pdacl->num_aces) {
-		if (!(pdacl_size - sizeof(struct smb_acl)) &&
-		    *pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)) {
-			rc = -EACCES;
-			goto err_out;
-		}
-		goto err_out;
-	}
-
 	if (!uid)
 		sid_type = SIDUNIX_USER;
 	id_to_sid(uid, sid_type, &sid);
 	vfsuid = i_uid_into_vfsuid(idmap, d_inode(path->dentry));
 	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 
+	if (!pdacl->num_aces) {
+		/*
+		 * An empty (present, zero-ACE) DACL grants no access to
+		 * anyone except the object owner's implicit READ_CONTROL
+		 * and WRITE_DAC (MS-DTYP 2.4.5). Deny every other caller,
+		 * deny the owner any access beyond those two bits, and do
+		 * not let trailing bytes after a zero-ACE DACL become an
+		 * implicit grant.
+		 */
+		if (!is_owner ||
+		    (*pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)))
+			rc = -EACCES;
+		goto err_out;
+	}
+
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
 		aces_size = pdacl_size - sizeof(struct smb_acl);
-- 
2.53.0.windows.1

