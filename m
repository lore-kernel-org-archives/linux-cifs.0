Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazon11021123.outbound.protection.outlook.com [40.107.39.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86F6390C96;
	Tue, 17 Mar 2026 08:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.39.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773734927; cv=fail; b=ogreuWCdI/8blDeY/Iu4L/j970PzL/wndF8sl6ircAzaJGn7BC8LLH0g16DH16rsQ5GarNPCOO6Xi4n+oIVFysO6rUAGL/HW7M5GJQ3c6RCJJfvKOvB01Nf3aYL3jCXqDC8K8dKZV+LZh0DvqQcRAY/+kseKvSPg4yCokuCr+zw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773734927; c=relaxed/simple;
	bh=5UOIcl6uP31SxigqV0r3F5xU3vutxElaBrIWbBeE49c=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mO1ry0KYW6dxBLHF00yG5YpWkjjbVdNOkHOva4cFb8LV9N5BYTPcni5XoXRd16NwLRNv1P/7EgmjMGjE2tzfvJlvRgMSsQlNv7FYWuyfFLWH7N2lANTkZmezQ8fNQF36vXyqu5MokOxumXrPArdA5llJo/b3SBf0u3LgCOgWNlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=S9vVMr0Z reason="signature verification failed"; arc=fail smtp.client-ip=40.107.39.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="S9vVMr0Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhlAxSM1JIY6XRywT62V1AAyZqV8PPQdlLOPkYGCipgpBzbNkR490KvfTAMeCufcc5Rm+dFXAT2jDgdxmB3jQeYyWqRluAN7iq23cBqzxivx1O8L6ZKHZOPnIxoQDyjW8Ur+EBSTZnCLFXXG5CQ5v6yHVmJARjxPO0s/se1lwJt4o6gl6luUm19CNUinx3m2hGz9ujFxeg518b4GaV82OICh4L/mXtEfPq34JCheBqi2oTjnjqX1KBjyPRvmtRgzdPdyEdzzqHib7NMd/lTOZtjI2jJJhAlIfurtcLfOeYfFcQQny1bnsOGFkNHoDQSAGmB2jtC3nLKkF/Q+Fvdvbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvmRLKOxfci5iIX5/sT/JNEi8lN/d5bDKTVt37821Q8=;
 b=Qm1bkGrr8b/5ioRrSubcKQPSUveRhlvxjk60Ilrdvti+30FUQNv48rmohZSkGuKjQiOlvOoVLKdzEqY1v80vhkxvQv5cmt2Vag+krR+MkEbt1SLr7OUFOEvyvPJKu90LhkW5pPW5KRZdex82hLkRsw06OL5Hw46WlCYxjBvB+AKi9eYkXD/F9zT7zM1NHAaxObLpgI0OVJzl9BHsQ9Zfy4G2xZWFzQ19tE/0ZDRd9pGvjg7vOfRZOT++/WUXvqDyafbJ2GDf0TOuOFIhZqBOp8QKwA9/M8kH6kKK/aBIg30ggr0v2XBRxinfTuPFNoindvNU7evuNM5/ksUudrVSLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvmRLKOxfci5iIX5/sT/JNEi8lN/d5bDKTVt37821Q8=;
 b=S9vVMr0ZLCYmKvGdQYRxBC/6j8wqF8eptpwN+JMSCS9QxbcyVvBShIaCjXQ5WmkOLRTblUYR7ydgYuALi6UgZwgFWZExFmrxvIZn/j6Eq1z0Odw19LAhcnjCi1dWPxfBQRb8WdX3FLHf0ilCTZOWX85TzjhAnQ2xZNjrx19SUawGbWkGY1X4mw7S+j4lYKsAxYLe3oDI7IEJLJJwhFQBbHtBgL96dFvm+iGTNrELrw2mpxQ/Zo5o63Vva7UUPmE0qjLWsUMlQrdgEiaqmWiNJPq0nc4weRMYIeOFCulzgMFXHfcPhAZlQFSG0AOBYf54RqnrVFrYHFb+cPp3M2o+IA==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY7P300MB1515.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:2c9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 17 Mar
 2026 08:08:38 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 08:08:37 +0000
From: Werner Kasselman <werner@verivus.ai>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
CC: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
	<tom@talpey.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Werner Kasselman
	<werner@verivus.ai>
Subject: [PATCH] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Topic: [PATCH] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Index: AQHcteVCmLHUy6PFJkipVHvK9wCm3g==
Date: Tue, 17 Mar 2026 08:08:37 +0000
Message-ID: <20260317080835.1947664-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY7P300MB1515:EE_
x-ms-office365-filtering-correlation-id: 6249c52b-b9de-4b6d-02e1-08de83fc64c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|18002099003|56012099003;
x-microsoft-antispam-message-info:
 Z7NwSSfxRXymxD5pzXkdT43+3DNkka+GP+n81ztIOkkKIylkh9m0uWqWKAzHU8hPxl/q+jxW7/9jJjAK6Sb3rhphku4FMtdo3U09IuRD59HtTaeWsm22s1FAVbHDT4+zNSjYIKFkVr7qxi96j5sqtf9/ZF0X/locO/peciW0RRDlyYEt3FERb3mmbzu5yV2chrl5Un9sRNT3v+66DRB1R/2wQFkFzo+gMawsSY9NzkUWQRithIcdx6sgR4PwzEaER1w7GQ5pjviuFlEvUeiD3aloqdMpPfXfQD2FtQaFRa2PI6p+Yp2ABNHO9Fa28rvgl3VwFAAbkz7ZDi7bRVE6fhk48qQHyLEaUQotvh+i7EV+CotJdatzpwT+r/SSAh5qOpuajPqQz7EzZhS0nHUJ3EvWt5R1qsv7tkQx1GX2mgXfZPNMgS0hZE70cwYVdoC50AwMfpEoMJNtCe7PE4VNLDD5ZOdzKAmvAoayoYnZIbyhb0c3YGlU12ozqp4kqxGjZ3Wz1dieBSmdJEdStqI6Q6DvahZOh0Vc6e5BhvHEWsrrt2ciKvVsXLnpoSXbZm3JYTJ/OX86IpHixB4sHXLuPrX2cP5PgFu5BBTq/onET6AFOTbhAWNuXtEG1M0Zs4zCmRpsl+H/TAe8pepgf7sxz3Nook7I3NkjiyIsEsgEyk8X3ICgS0a+9v2nVf1K6o3bUHVy9zZbV67Hs9WHO0Juu896GFe2nakqshzE0Af0VOSN9T5LVRaZ67WeWbqPBCBoBPoMp7Oa3apMc5trjdmTMRtaaphnTHcQYra/uoP3JsM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(18002099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?LPXrWysSebbl4EGhYvnETpCNRRGiLh5s8USH4A/hvBeaaMLBm9HqxaHs3r?=
 =?iso-8859-1?Q?UQRbjliuQRHzZYRVtQD9lyEUxGnFYfbfT/6EEEn7H1XSu01Xrw7CKWKxZV?=
 =?iso-8859-1?Q?0SMAzfQb8ZqljJTnCx+rfSAWoWqkxu+hSgwZjg9r+Bpd40HP/tumhaORLO?=
 =?iso-8859-1?Q?q7hHZGDxM7XqG3QXeBydh4tRcWkrBWhXgUrB6zmSIJBnvsUqtMRawzchN1?=
 =?iso-8859-1?Q?KfU0h8OmAmVWWaRuUIMAoHkgfCEotAM8XneHkJtd3NO+RxTb01QCYzGYej?=
 =?iso-8859-1?Q?4EQjRyx7iJAbT71lT+jBeGdfeEfUhp4yIDorVNqRzolgm1xs9z7zW2VR50?=
 =?iso-8859-1?Q?ZOpbNMVlgURg6ZbP+XwmoZuWxUqAkMln0qTTWBX0lklbyO2Zl7NUHYCV1P?=
 =?iso-8859-1?Q?mHvrziIIjgGwiimiE1BYtOqCkpiMYBJ6q449z1K2Eh/nKQ4atS49aAnT+c?=
 =?iso-8859-1?Q?1ZCGkD3/a8c3Y4E/SYpHt0y5uUUKEQDLZ2AVJot/XQBxVS2MsUj9uqrcbc?=
 =?iso-8859-1?Q?qTTEGSROsdezvWUW+du1rWhMWO17s6LTcYJmFJs6uUUsWVkYbBC5ngsaNM?=
 =?iso-8859-1?Q?uf7XYiLDlANu3X2ol41cO+sZqx+W4qLkCy7LWiXich0oPtf29bM/uWkjNZ?=
 =?iso-8859-1?Q?rhfFWD1hX//L3wvN08sTsP5WwghTGoi3k0B7ffVgYaGGlSA2xS5A9tZPoY?=
 =?iso-8859-1?Q?G/+/qjwiao1IdB2m8PN6qxsxgDV0MA8B5YbTOcbskJMCgOmw4Aae1TrTWH?=
 =?iso-8859-1?Q?FxpL8QlNYgnT1/pvR8WnODYGS+nl1N5yqXrbm9lDhfd/k6dVWvNKwPqvqv?=
 =?iso-8859-1?Q?EodhPt838WclXBNbNF3tYmj4mBgqVgeKn/yrvFw+enNPzm8B4zDFPQZfvd?=
 =?iso-8859-1?Q?3FceKHme4zbpQFWSDw6Fc0gTAmez8Pg/rwlmjzoGbcZTn4pAwQDrLHLJm3?=
 =?iso-8859-1?Q?UdC4ccT79UXotKxdmxEsmokloP6KJuMjXooXLy0e6nWGXE/+hJJ0qFLcEI?=
 =?iso-8859-1?Q?k3xd/Esn747jeLRRpZEwpQ/yp+5X6erAd0u70X6WKcTxJh3O4m6x4JYZES?=
 =?iso-8859-1?Q?96kJZYeoVRsBMlnzBkQ6c9N2yAdFkiuABou/s4V19GOOmyf85bO+PcsgwR?=
 =?iso-8859-1?Q?HnQ0IuF+VFeMvqx+O4OmzptFZ1Ii2HWy29dIpwQrhxO1BPw4zFNkq8WzlH?=
 =?iso-8859-1?Q?pZ7MTVtwNYOqIanbW59s2YEXXcPC/ppG5/clWI/5x/diEz7jWtui9SfV8D?=
 =?iso-8859-1?Q?0WjbR9VBmV18GspnJsbHGP7O2KNvZtLR4LOBaqqgGSKG7hfgf4c9g2NTNz?=
 =?iso-8859-1?Q?2kmsBzJRIxM9PXSa69CoEkHGp9sTTDvIvf66UT+5SSiYs0hrEa02YBQntH?=
 =?iso-8859-1?Q?AhbeHEZ8jgMQd+fkaJy75NdE67VppaTa8gp+G2J68V+4WwtHlDs1gI5UdF?=
 =?iso-8859-1?Q?KtOvgTiz6uQWtLUoUv92g6pz99r4/x8xn4n157NutL755Tqq9lNTr6j1qn?=
 =?iso-8859-1?Q?Xm1jP9XPMNS7gA296WKbfodCIh4ZDKUYc0ltCTOlK6xgr3xEHK3rg2/XiU?=
 =?iso-8859-1?Q?9NZZ16TK+bs6iXrJfu5SrhIi9+a9LDeKDeRu045qyzcEkYEg6nwVoWEsid?=
 =?iso-8859-1?Q?7Qkox1oe7+9hwsdY5ggAkf/R5Q2vfactO3lLildc5V4iA3FBywSpiXOjTk?=
 =?iso-8859-1?Q?JnZeoX7fI50zfBGg5hWd1MP2YpMZPbDoC1bNBulPiZ06/NgXIMD3MVzrgx?=
 =?iso-8859-1?Q?KFINurLv3KJ/H1dJz40EPf0M7OgG7xEdg6dPXg3ErE7oyuDMNAkxaxqZL0?=
 =?iso-8859-1?Q?MkAu/aYR9w=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: verivus.ai
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6249c52b-b9de-4b6d-02e1-08de83fc64c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 08:08:37.8498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rrp2xCzdXSm/UiTWmo2m/XOwfl87N0CRYb+sjAEHeh+W/aEEiHEBuhdK50mwIEpqPGDSJvNPXB/JjbZBQxJ8Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY7P300MB1515

smb2_lock() has three error handling issues after list_del() detaches=0A=
smb_lock from lock_list at no_check_cl:=0A=
=0A=
1) If vfs_lock_file() returns an unexpected error in the non-UNLOCK=0A=
   path, goto out leaks smb_lock and its flock because the out:=0A=
   handler only iterates lock_list and rollback_list, neither of=0A=
   which contains the detached smb_lock.=0A=
=0A=
2) If vfs_lock_file() returns -ENOENT in the UNLOCK path, goto out=0A=
   leaks smb_lock and flock for the same reason.  The error code=0A=
   returned to the dispatcher is also stale.=0A=
=0A=
3) In the rollback path, smb_flock_init() can return NULL on=0A=
   allocation failure.  The result is dereferenced unconditionally,=0A=
   causing a kernel NULL pointer dereference.  Add a NULL check to=0A=
   prevent the crash and clean up the bookkeeping; the VFS lock=0A=
   itself cannot be rolled back without the allocation and will be=0A=
   released at file or connection teardown.=0A=
=0A=
Fix by freeing smb_lock and flock before goto out in cases 1 and 2,=0A=
propagating the correct error code, and adding a NULL check for the=0A=
rollback allocation in case 3.=0A=
=0A=
Found via call-graph analysis using sqry.=0A=
=0A=
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Werner Kasselman <werner@verivus.com>=0A=
---=0A=
 fs/smb/server/smb2pdu.c | 19 +++++++++++++++++++=0A=
 1 file changed, 19 insertions(+)=0A=
=0A=
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c=0A=
index 9f7ff7491e9a..36e281f5924a 100644=0A=
--- a/fs/smb/server/smb2pdu.c=0A=
+++ b/fs/smb/server/smb2pdu.c=0A=
@@ -7583,6 +7583,9 @@ int smb2_lock(struct ksmbd_work *work)=0A=
 				ksmbd_debug(SMB, "File unlocked\n");=0A=
 			} else if (rc =3D=3D -ENOENT) {=0A=
 				rsp->hdr.Status =3D STATUS_NOT_LOCKED;=0A=
+				locks_free_lock(flock);=0A=
+				kfree(smb_lock);=0A=
+				err =3D -ENOENT;=0A=
 				goto out;=0A=
 			}=0A=
 			locks_free_lock(flock);=0A=
@@ -7655,6 +7658,9 @@ int smb2_lock(struct ksmbd_work *work)=0A=
 				spin_unlock(&work->conn->llist_lock);=0A=
 				ksmbd_debug(SMB, "successful in taking lock\n");=0A=
 			} else {=0A=
+				locks_free_lock(flock);=0A=
+				kfree(smb_lock);=0A=
+				err =3D rc;=0A=
 				goto out;=0A=
 			}=0A=
 		}=0A=
@@ -7685,6 +7691,19 @@ int smb2_lock(struct ksmbd_work *work)=0A=
 		struct file_lock *rlock =3D NULL;=0A=
 =0A=
 		rlock =3D smb_flock_init(filp);=0A=
+		if (!rlock) {=0A=
+			pr_err("rollback unlock alloc failed\n");=0A=
+			list_del(&smb_lock->llist);=0A=
+			spin_lock(&work->conn->llist_lock);=0A=
+			if (!list_empty(&smb_lock->flist))=0A=
+				list_del(&smb_lock->flist);=0A=
+			list_del(&smb_lock->clist);=0A=
+			spin_unlock(&work->conn->llist_lock);=0A=
+=0A=
+			locks_free_lock(smb_lock->fl);=0A=
+			kfree(smb_lock);=0A=
+			continue;=0A=
+		}=0A=
 		rlock->c.flc_type =3D F_UNLCK;=0A=
 		rlock->fl_start =3D smb_lock->start;=0A=
 		rlock->fl_end =3D smb_lock->end;=0A=
-- =0A=
2.43.0=0A=
=0A=
