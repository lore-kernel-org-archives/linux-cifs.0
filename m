Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013080.outbound.protection.outlook.com [52.103.51.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668953CF694;
	Sun,  6 Sep 2026 23:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788737933; cv=fail; b=VSGaUb+eBIjlNnBjXZqHoIK4q2jRGwacLIvVdfE7MjxwTU1wQkFrMhLD2k4aK/6k9QVNGqPty71eFC/qXuwUapIg9h/D3QGCh8xE+2oQ2elaMLJTZe8MOt9t7y3TOb72M+Vnmy2Ri8G2F4KJlreN5H1Ryccywi+JAjLDa1Ejgos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788737933; c=relaxed/simple;
	bh=RqtZ3O9LiiEhVxYTj/uEB5p4+7YiOCy6cfTrHtT3QKY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qvJfG8iks1qAygIOBUHgDESScL6kXJvwmAwu+fzLk95txD+WYZIM9AdHwsRTa2KX3N4P4zzZTwm3BQG17Gg4QmTvdQO5iWbojubc+MmwdCuNQJwlpFR/szMis2D/RAHvPlYKzSkS/IPvfw8wSKvFPUlvR/14wVHyh20O3W9/0/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=GrHRPrSC; arc=fail smtp.client-ip=52.103.51.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="GrHRPrSC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDAphgVwB6/Rz5dfnCecnbAczqTaHp55ct7x4ziY1/XwByaHHjYfB2YuN2mjBrTkjwK65DHnogtyMgOWR7LSHrwSiMNgOe41CMHAHaP0zlN/3SGkAWMWdyZf16C5g4zsueNNEQNG81S3SFh9HCA1avTUe22WYTgHXEYMHhBhTC0/fvEptd/GHlp00p2cBxYk1yGnTe0AIPp5Gms3/OeS7SCpGfCRntvGFN+1RSV9UCT+JtAu6JG7GkDqY1c688NRCgY3iwKBH/EBh28PaJWqjREXdchgPdjxL40ZN+Uq5skqJ0aow3QsSdobqGoV4PTv6kSs8r28KWan8yr91HQ9lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDRXZ0qTcRDNEF8ObAvtDimPi8hFsMb+j/qYlWg8n7w=;
 b=nv3M7o5idlcbUCSzYWXBNnoSqV78YdawY7Ns+IYBEejkBn8MJiioORVRU4B6HFSFQ54vKU2U1xe7MwWQmMjgufG+0H8O5j6Q9xoSQq7KYdvxIgsUbMSh2fycaVnXvk3/+wiJbfj2mpNierv/MqAiZYdd3iCx1mSVbEyWeNQnYkWJ5mJtCR29h7I4ZfR7Da516rAUaYebCsYjt9hoLvvrEvq5blp0Lby01xuZlLMwm/rih3mNbYMEXm3gsdAJBF6EzAeaW2Hb1DP9Go0qs81eJbNtjbXZ1RMIie1KPVddJVE20pUkWSbifZ4fcEAEtfCL+NHiPv4nM6AOAYQ5en/bdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDRXZ0qTcRDNEF8ObAvtDimPi8hFsMb+j/qYlWg8n7w=;
 b=GrHRPrSCm3VEE5VS5UlYhUyQsLhyXZtRRRu7HahobFKG7hl8uAEjZZoP610lXCvOWrR4yq5rnOaRFSwGQvMkH8WREnN1RWV3ERV7MdDkar0i5Z2SG3tAx6YfwhGoeKqdKSZIWs6nLI9b0IiiW2mbxrFKJHu8v4I3idbNKvTDPf13rb6aY1sq93UN/iVnW0XN0yXxfzyUATSHG5h8yjqS+104ckhrTxRhsaiPhdaBx5Z1p+iPAOoG5wmf7xpDVY+k3nztbNhlbMbma3EZa8JsyGyletCjmjBH7Mf4L6k1ZgGtZ453XEGgYtFi9FK7NZb7URpeJCTgeiDY++VfvqyJ2g==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PAXP251MB0113.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 23:38:50 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 23:38:49 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: deny access for an empty DACL instead of granting the request
Date: Mon,  7 Sep 2026 00:38:45 +0100
Message-ID:
 <AS8P251MB000152D9BF4B8E0601640661C8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0126.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::23) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260906233845.87826-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PAXP251MB0113:EE_
X-MS-Office365-Filtering-Correlation-Id: a022481b-188c-439e-9225-08df0c70005d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|16051099003|5062599005|5072599009|15080799012|25010399006|51005399006|23021999003|25031999004|37011999003|19110799012|8060799015|41001999006|12121999013|440099028|3412199025|26104999009|40105399003|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zB1Y41Zwtb20amQJj32Zt1Sxwln7QJwI04Ws0QCbtQqkxylvUfCXSrh7uqsv?=
 =?us-ascii?Q?DjuZ0lYhsFZJPGPL7asoxlxBWmydJqt50i8k/zkhF9eWOcRlEzCSN9V56pt3?=
 =?us-ascii?Q?hMkYvyTsKO1I+zZ2Oh1nn4q5bmftXxg8Q8qoHKCLuAkWmCbxsN2kT1bS7gdw?=
 =?us-ascii?Q?BbLEB+wkkPxlLk2TEbbIf8VSS/j6nazt2GEc+gUbxcOjRf9Cp8+QWZdx9bg8?=
 =?us-ascii?Q?bntwwDuFaJ9XEr34RHRGsmIQTeouFGZE0E3dYwkk5OU/jFlMM2c+wjyLgAdm?=
 =?us-ascii?Q?cTzg9PfGCSCJrsz7YEQHDEAJpQ9LBUX16rODGnazE0tJk0UztqFdq9LolyXk?=
 =?us-ascii?Q?DcxzSdgjxUbyhVnaIm9QEw0Dkaruw0zgn3L5b1nqDDbCwyPVw8/CV1mpTy37?=
 =?us-ascii?Q?CMPvFTDHb3TWY/0OI4PjSsFwkCN2PMs9ZA8+g42aBPy+6rCFzAspI3FY2D2d?=
 =?us-ascii?Q?8WJn+0p7r6hpmwMYl+5M19ZEqrMRB7jr2eexhLlUNvrEB7ljQSEizdloxaxz?=
 =?us-ascii?Q?LCgjEfBA/jiA9eAr1G/mF1a/FXWaNJvMhD0EY4F6o7OLKvCmQoPEmx5Gm/tx?=
 =?us-ascii?Q?UtfJQugremUBckvuATjKaSfFkOXYhCX08qYPWJSO+IUUIHiKnYh7Zxtp6M7G?=
 =?us-ascii?Q?V78O/AdEJsbfDZrDZ2hcSVSLFMbZmoPtT0BY+rCsjMH3sVLAD+ATwBTYsUet?=
 =?us-ascii?Q?5g55f5l4aCsDw7RlrhrkEMWSLQqWxgwG/ESSDRjfPGySQwpIwgtRbMcta+fD?=
 =?us-ascii?Q?g71TVx+tn+eQ7NuOzIcmFcVJi8b6AjC1bvYVf3l1/4iEDYsoTWXTLTN9Wq8Y?=
 =?us-ascii?Q?rceB8LZtW+ABdBxFQAgfUcVCcxsL9FB+0bOX4A7Qe+H0v4fSWAVMJNIHubDU?=
 =?us-ascii?Q?PwvU9l+FGZdLZSpS4eKuZ+jrz/AYKs9Q72dWL5RDf8EqwqBBVW3wfDhXo2CC?=
 =?us-ascii?Q?3T4KPhRgHL4mX1vFbhmJ3b3vnvPVsEYax6S30rdAkZrnTnteVFdAwAfr3XKv?=
 =?us-ascii?Q?Ja+/vA29PzGouzUM2Cb6Q17UkIGqXrVoFph3R8RY8AoAnpuH2etNlIPkHMe7?=
 =?us-ascii?Q?YaW8yhvCTSQdoxzAe6koGYfIe9U0n8kd8dfgChwl5arjUVu0NOxS0tzOzhDl?=
 =?us-ascii?Q?f/9UNarBU8mJhWFHNpCfJ4FRp7ffPAMSFZsvPr4rwDHwpCzpSDKwk1A=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O//L9Mge6+YT3iLl/OEwFyPgr1dGBIi4jeJHZAWbsmEa5dGJEgh8lZP042Qt?=
 =?us-ascii?Q?+VlWzpbegvoCZC6USoDLOavdFQUB1TUKcqDzWMjUFy/CPQ2Dmk0zzINqxeBY?=
 =?us-ascii?Q?io8qutEPS/1NwqV1r4g7n9RdZtdEOQeS0ye437YKAX+2ngnNjk58kxzYYqsO?=
 =?us-ascii?Q?GsdchqyPS3kNBm+kA8WIlbv2uRUoB24zAVW30i8zvR1rEC17qX1CLrLPbrov?=
 =?us-ascii?Q?05dssfzD0f8RSyFQJ3WSA9kkTJL6lrS48XLlXcdQ+nZn1VyjudZ6y9dmb7TC?=
 =?us-ascii?Q?H0fWZRqiDer2xJ4sdRzg6SxZ9koByxFZdx6Kz5Q3UqpF+PW2BSrebzuEtuNs?=
 =?us-ascii?Q?1KWcNi/dkJPH9U/qMuAXxthPg1HT5Gj51rJ+yrtsznqESaAZCyZTaGBzsSPd?=
 =?us-ascii?Q?/kNueWjZ22U0/WMgAjKlJlf5p5wlH55M1/lRGkFlqdz+2LA+RzU7fPwgFd0Q?=
 =?us-ascii?Q?tXzQ3JoV3FnubV4vRCH4JLX6Imxq7RIKhyW3wwBSg+xMLGp9iM6mwXhqYxRt?=
 =?us-ascii?Q?csiSccjm0tGwwiZI1gQx+DjoH+/TGaROgtVkWHmoyrhxdEBTb83cRDRAr8LN?=
 =?us-ascii?Q?tJZvU8haBWFkgo0GS4m0LZw+ts0gn+SehHtf72ugq3SGqWwklzThD+jeJ6Jt?=
 =?us-ascii?Q?irAvRk4xUOOd0gPiv/b38UA3Yis/dOYOBKyY37kVKZyDqWnyyOMuJsmCUrQ5?=
 =?us-ascii?Q?SCZRcKbYEOpD52qDDpXE1KLmIVgNuyAaLWQykNhnWXPqyQXthYtXZ16a69ut?=
 =?us-ascii?Q?mpE1i/mIiM2VRseTERINhQgK6AjYB6qGsYKvhEKmOWwCsI89LuK70lZ6GZm5?=
 =?us-ascii?Q?FCO8oH2hd67J3sYUCSTZMi9qKZF9AnEzYXt45VunSnlPoeDFKnwx+8q0ZMF6?=
 =?us-ascii?Q?sGn545X40LkeP464MaIZ6LQn1Q8xDY45Tg6Z9w7r7p0j5xNOr8UBsK+RqtzK?=
 =?us-ascii?Q?qgF6sutXAc66iA2pQjwpDiHPz8GygsLHW9IDQwxRWuCPy0Pj1x0lmmZ6FVYg?=
 =?us-ascii?Q?kehogSGOpbtA3a/IKwyRYCy9BRatPp1KeaiHoO8LI0VwAx/JQfTI/K1g1HyJ?=
 =?us-ascii?Q?x42a4AC3eyTSOUl9N8PjIMevZ/qcJNcTTfl+TJsNDYfe034nyUSGN0EdogjO?=
 =?us-ascii?Q?F4gHpjRfV/gGiy7bXEFotGGlcGK7cvs6yOskA7goyxkRFhzYxBbGjq3pwnC6?=
 =?us-ascii?Q?FDoFOdrFy+XVoF2q036jF/3z9ReEXa/XBhEfyqrFKqZ4GI5fny+V0LUiksXc?=
 =?us-ascii?Q?IWDroMKIzaMWqPJ1ic+JKoYrU+uNCT7ylcncrQtGlGQJ1eoTIHIxpV/Qvr1q?=
 =?us-ascii?Q?XB+yE6KUGfYiNsRWCa8Awl/JGYcHY1/cPYa7eCFnWiNUw7/YlfeHZrhmz9Ce?=
 =?us-ascii?Q?inSDn7m+XZE8yCWx3mkXsLoH6msef1QeTUJQGLqmo7loZZ1VOpF+eOvMdFj+?=
 =?us-ascii?Q?+NxiY+MY0VY2XB6tr/3cY7VhTGcBmM4/?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a022481b-188c-439e-9225-08df0c70005d
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 23:38:49.4152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP251MB0113

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
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
Found with AI assistance (Claude Code). The bug was located by auditing
smb_check_perm_dacl() for paths that return success (rc == 0) while
leaving *pdaccess unmodified -- the same class as commit 08f41323f549
("ksmbd: fix maximal access leak when object has no NT ACL"), which fixed
one such path for the maximal-access caller. The empty-DACL and
malformed-descriptor paths were not covered. The fix was compiled
(CC fs/smb/server/smbacl.o) and checkpatch --strict clean; the decision
change was cross-checked with a small semantic model of the branch for
owner/non-owner x requested-bits x trailing-bytes.

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 1fad6ccf3a72a..ae55813790bd2 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1490,21 +1490,27 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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
