Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020109.outbound.protection.outlook.com [52.101.150.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28A53793B8;
	Tue, 17 Mar 2026 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773740904; cv=fail; b=UnuWNdP4fzol8/rLsBzVOF7gl4VyMQPZWwX4fYsLrQAwmfW65Czv0Gm6CMCfi3y2bTRnFeIiq4SnUzcWtPpLnhTYWlZOj5QuRa0rcRB5ASI93rZJdsL/OXI6FhEaHekCiBPr1JyAjylL5luza5oBhk7U6QYmHVzf0oGpuFhuyBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773740904; c=relaxed/simple;
	bh=cNza0jkHEes//CsUTV+oiL3Y3Qu8ol/7ac4gY+XgVtg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YjZAXlDpOPcDpq64Z5Fce/cPVVj0KU06EkcyfBKxCBzpksduSTXVh4QYkLgrkb9a07lszEdAkBS5a9CYAhpHssbxJm3fNb5xM/BGnCSN0hWbOQ5kpgFOsBvGkvdk0HquYGZYqDLaG9nMq5/LKakExJhdAQfiAs8yRFIa6EAES4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=PiL3+Vgb reason="signature verification failed"; arc=fail smtp.client-ip=52.101.150.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="PiL3+Vgb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NkKe3JUWFxNGaa3pkatW9PlKQZQxqv4fZnkTXMMKibD+c0mf/q0UdJqDwRChTlO7e2ZZG4FMT5xiSLIAJqu5wQNaAcVETvSfzGcE2W68W8E1H51QosrxiPEviXske0ValUgoV63cXTqXBPnpZO2eqQ1NDUiv4aZeO4lEMY/bShOg+cc6mbfsZWLGm9V0B+p4tTm23X8FrU/hbTf5RwKZ/jnd63VhDj72i+V4K66pJFo4Iccz7yTu7cKvolXI5D/+I/H4vIE7vWhxgd1mrIDpHSoOYaeVYcyDpAFecA3oJCV33YNryxrJc759XrzbUsax72TOL6iFkysNADBhlfYe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yD47+w5XsLzwjVsW1DvPKEn7Lc9LGrkzcJ1A2iQ2RN8=;
 b=hZbgf6ggDhBzCGegXgtSu/K3PlVRGGGBAoEMbXd4VKGcI56C0pATHsecyc+nSVwgDqar28SKrMoqvz5RI7tqOH+M5VvYJz/XlEUSpnAWdTYhUJSRhm9PNedrFncFxuObR+jmc8N9Ti8qTg+Ybqi+2i25lmhXOcGlcWj9M4zgSXyjrMAWbh23Fzz6p40J4g6D2a284yVqvHpifByFR3aNUPNqMUQnRm3Tf0xpf8dC9x0BRmqpZ6K1f+4PQgMCKK7+2qhVBIHcsEUIHQbNLm0jclOBDxxL0uNwvN4I8/u8PxliWRXpXBJil7bsFqwH/1zai4aTmdCaJ/+ss6hI0apvCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yD47+w5XsLzwjVsW1DvPKEn7Lc9LGrkzcJ1A2iQ2RN8=;
 b=PiL3+Vgb2KzT863rULDMo0gAS+obdjXpY0WkGjyzajJxwyOTIREWR0HUYmu4H46AD2i66VjgqtXs4F23HaHDHy7APh9/AvEJl6tzO/sBMIPNQIT5voMoagUW7VkbqXrELMCjRtm5rTYTcA7+vF5pRxHBxKM6hf3dGqm6wLFzTiyN+9M5oZSuHBV6NRwJxB9BbgKg7L+8w9nGq7EpONNRDDk2RIwZBl9mXj6inXQXbdh/oDfT2RvtjtKowxAZE7alJdMidaXBTaxBSS2VEnu91I4WzpMI+Tkb+A8yZxOhtecfx5rA1/Jy8K7yh60yxJTsrrsCiBYePUZG5CZXfhMNCA==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY0P300MB1638.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:300::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.14; Tue, 17 Mar
 2026 09:46:56 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 09:46:55 +0000
From: Werner Kasselman <werner@verivus.ai>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
CC: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
	<tom@talpey.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, ChenXiaoSong
	<chenxiaosong@kylinos.cn>, Werner Kasselman <werner@verivus.ai>
Subject: [PATCH v2] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Topic: [PATCH v2] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Index: AQHctfL97tBqj4F1oEO2D0vU5/26+g==
Date: Tue, 17 Mar 2026 09:46:55 +0000
Message-ID: <20260317094653.2236624-1-werner@verivus.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.43.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY0P300MB1638:EE_
x-ms-office365-filtering-correlation-id: ff984fc5-dd37-4899-7cf2-08de840a2042
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|18002099003|56012099003;
x-microsoft-antispam-message-info:
 ZD+u9O1tYzJwxUeZdaonWtwoVnNMOtEJtVRgmoDm0x3EslgnVg5CsiGVPUe+cthabmPNK3ayzkhN5d8uzjPog027swiUDWQT3TNcbIS/lrMBi8CtpkTLila+3JxH2ZAXEBYIzYpOmIKHZf1GspnQ+bM6Oo5Tv9BxGnmfOZdE2e48Xpk2RSnLVNxT/B4vDZFKWtxUxOqRD0AEjudcHm7IssxL3iUbzsP7k8dO3D4JD0wlU/56vGr8ZqnjW1fuuiof0EfIIv1rVHOKMqd1J4n3w4slmSIQPhJz00IFY83y3c7ruO0xfQ50Q6YvzEpQeMMdtACfJbQ2ih3t62gW+fJTm3h8K0wK1eyByhAkZQmWdBzCkggPE5fQUfd0DzqJcU1CfRarj2FkMp0cdXS4z3pxabXmhzN6eDwbdMur6f9RI9jMkiw0zK085yZU2WyMFmzDfR1+IbwmYHNpidztEEIHYL2k8LAnEYGZ5bnpedcR+x9u7UtbId88D396wyTwt9cyWum8c8hStQN7sFC85YzijU88GEDoDp9SPsraX2ECyvsbR454+Z7ugbKGLkLLxpCtu5ILJWRBdaYHKj29H/y2S212lDuBECGbwrixJu6lsE1O7Ah6bmB0JKInsP+Wr7/dfNIMQTsnijFF4vZfaYYutq0OkjmrtO4JuCSTmgws0VoCwLJDgustXKZ3qYzIApsZNmFnk9xsFUvQ6T4pzbmaYIMTBLvEBiF8plcHqG78GE4JCSUNyA8Se7VLMQGMOoKuqnbEAeNcLbmuOjZjorjxQGxpsM62Nky6pzEikjnoywc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(18002099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?UVjyvmN56TFHH7VewMzX/ZyjAfpVpQhi5VoEyE0wCqAVPOWjpXJ5WVlF6W?=
 =?iso-8859-1?Q?+kWKrGBDi1OL8X0/ktqdcFEostOvi5H+sZvHinxRsNoqrQL9iy+s1CQWOU?=
 =?iso-8859-1?Q?HhfOOtAwvbeeWjkYM7i7w2CRajGShd1SLD6VBs1szf7tLUih81QyURGO+P?=
 =?iso-8859-1?Q?xhnAZ3zLvF3Cam+70bRJ3dUJSa/ubcDOyUnBEjGbVJlS5p/bNL8/FUiBwW?=
 =?iso-8859-1?Q?1iga7SWroCcucUk5mRxgI29uyWsZ+kBCuemjFkkJPbbgfvQzs4wwmYBw1A?=
 =?iso-8859-1?Q?2hU91bVKYz9RCJmh41DgVwmGsLDTDlv2NGWb3AKM/A4HXI3ZMlr7IP1tXh?=
 =?iso-8859-1?Q?QZb1seLcJbj1b2AKg13hfGAU92cU5c2zhE/j4j+3ao2C27qkLc7s9Hht3V?=
 =?iso-8859-1?Q?Mdgiqjaj/BwmwkorsLADRENNH1xFyPfWMVk3SczaE3fDJBPEsq87aQP+cc?=
 =?iso-8859-1?Q?ifzz5o7Ndfmm98NvdAsWQ6ShDxsFnqBiMrs5eYGaKKeTV2VWq7fbDxcK+1?=
 =?iso-8859-1?Q?k75FNb6rQ1Xa6PSGkV5Zta7gGlEWEtZkcHpICIIBvd5x3+c30FyXVejd2e?=
 =?iso-8859-1?Q?Q08isBYI439WQuKtueSlld7MFXBQIgJanVTQN7i5v6/2Xzv0TinyCm3W+F?=
 =?iso-8859-1?Q?Cq9fCEa2P6lMF1VaCzLqQCoheo3u+5dbVw8QheN3vwmH3vZkFZ503V3rHI?=
 =?iso-8859-1?Q?AcOG/sFDAZxpVV+DmL5XJ0supXgI4YBuM/Vi1j41IEj4lJUzmNDOoWM+/N?=
 =?iso-8859-1?Q?RB6wlyFq1vO1Cz4Kl6eTm8MT+dxQijz4W0QKrfv1yLBuLBIYDUjNql5RUg?=
 =?iso-8859-1?Q?Urrs8ez1kLnctdsr2LYXkVmp072r1GSw9rsDa9CIKbHkCaM+l9cSTqlycf?=
 =?iso-8859-1?Q?4sBCNcakhSSnGiwAT6qHbLrlON3veinmKRZpssBgx1ove6Oh6VyqavQPFN?=
 =?iso-8859-1?Q?duZrbFdz2vSKi56p+h7Ar4uy2OMCCsOG5tKRS3u7OgpB4bIgZTkqQ226Z3?=
 =?iso-8859-1?Q?Bw+YxKYhyWy4Tc09Ig3rSWUzSRtMDpntGhf9bgxon2XH6fsWgSia1DwS+p?=
 =?iso-8859-1?Q?psNrlTa1Do/sFtI+dQPvXR+gyfsKPUKebr8+ttcMxV1qbedJX4h0lhIpcd?=
 =?iso-8859-1?Q?wzg75S2MTj4A7CHaUjRs8t3ot2alPm2Yhhsitg1TDqlAKLrwn2ImsHa4Fa?=
 =?iso-8859-1?Q?5vjfKYf8vDyGxJ/lXoefT4lNMjWyqVmjkowQhmoXFYBv04+PzR5AV37Q2t?=
 =?iso-8859-1?Q?hEkSSzqFC9A0Cjb2iq8od4s7CN6tcyRLJaDtoQlovy916aZtt5GQlZEoc1?=
 =?iso-8859-1?Q?RVWmMeG15ldZUWSCh0KL9xJmENKaEeiB/71gcQC5CkkIlwQoBQ5bA/u39K?=
 =?iso-8859-1?Q?YDdMBJQWzlJeGnWGSERoj80+1jvTNR2zjtqv6PQgQ/j/QrP3WA+xZsUffj?=
 =?iso-8859-1?Q?w9ItrYcZAQrkseDuPsyeJzXs5GiCXFXjRN8KKvk9ETyw/f1aJB6kWrCIDQ?=
 =?iso-8859-1?Q?6IjFVGgX51eEFBlvB9XYyy0dihFrxqyUb+8nHIzyAD9snNJ9pORkf1hObb?=
 =?iso-8859-1?Q?0ItuImEGdBvbhEopA+MTcb6FInHmSMI6HEdD3y3RmxI0uQW8eUbb1spahh?=
 =?iso-8859-1?Q?qsR2YSPGitiRDzMYTzPTDGWM6d8lmy25/zqMPF97ZuEyNSQKjTRbR6nUWg?=
 =?iso-8859-1?Q?q63s0YXa+W7ifYsJ8VWc67YfBvwBLDM7Ca7BTsssAIy+VOQ0jEJy8zVk3F?=
 =?iso-8859-1?Q?vdEKcVw44w1ZaM5S+dOfNmpd8HJ2d01tSmXDlPEv0mICukRa+9cuZzVbrd?=
 =?iso-8859-1?Q?Xdo0b//J3A=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ff984fc5-dd37-4899-7cf2-08de840a2042
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 09:46:55.8443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SUOpnK3QlxSNXSs8Yj9LlvVOHNmi6foLN/MpWibPzrUzlbH0K3Tsqd30poifQGV+OiZlnwizHGJkQEFk6W+NhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY0P300MB1638

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
Fix cases 1 and 2 by hoisting the locks_free_lock()/kfree() to before=0A=
the if(!rc) check in the UNLOCK branch so all exit paths share one=0A=
free site, and by freeing smb_lock and flock before goto out in the=0A=
non-UNLOCK branch.  Propagate the correct error code in both cases.=0A=
Fix case 3 by wrapping the VFS unlock in an if(rlock) guard and adding=0A=
a NULL check for locks_free_lock(rlock) in the shared cleanup.=0A=
=0A=
Found via call-graph analysis using sqry.=0A=
=0A=
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")=0A=
Cc: stable@vger.kernel.org=0A=
Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>=0A=
Signed-off-by: Werner Kasselman <werner@verivus.com>=0A=
---=0A=
 fs/smb/server/smb2pdu.c | 27 ++++++++++++++++++---------=0A=
 1 file changed, 18 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c=0A=
index 9f7ff7491e9a..0485187e5156 100644=0A=
--- a/fs/smb/server/smb2pdu.c=0A=
+++ b/fs/smb/server/smb2pdu.c=0A=
@@ -7579,14 +7579,15 @@ int smb2_lock(struct ksmbd_work *work)=0A=
 		rc =3D vfs_lock_file(filp, smb_lock->cmd, flock, NULL);=0A=
 skip:=0A=
 		if (smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) {=0A=
+			locks_free_lock(flock);=0A=
+			kfree(smb_lock);=0A=
 			if (!rc) {=0A=
 				ksmbd_debug(SMB, "File unlocked\n");=0A=
 			} else if (rc =3D=3D -ENOENT) {=0A=
 				rsp->hdr.Status =3D STATUS_NOT_LOCKED;=0A=
+				err =3D rc;=0A=
 				goto out;=0A=
 			}=0A=
-			locks_free_lock(flock);=0A=
-			kfree(smb_lock);=0A=
 		} else {=0A=
 			if (rc =3D=3D FILE_LOCK_DEFERRED) {=0A=
 				void **argv;=0A=
@@ -7655,6 +7656,9 @@ int smb2_lock(struct ksmbd_work *work)=0A=
 				spin_unlock(&work->conn->llist_lock);=0A=
 				ksmbd_debug(SMB, "successful in taking lock\n");=0A=
 			} else {=0A=
+				locks_free_lock(flock);=0A=
+				kfree(smb_lock);=0A=
+				err =3D rc;=0A=
 				goto out;=0A=
 			}=0A=
 		}=0A=
@@ -7685,13 +7689,17 @@ int smb2_lock(struct ksmbd_work *work)=0A=
 		struct file_lock *rlock =3D NULL;=0A=
 =0A=
 		rlock =3D smb_flock_init(filp);=0A=
-		rlock->c.flc_type =3D F_UNLCK;=0A=
-		rlock->fl_start =3D smb_lock->start;=0A=
-		rlock->fl_end =3D smb_lock->end;=0A=
+		if (rlock) {=0A=
+			rlock->c.flc_type =3D F_UNLCK;=0A=
+			rlock->fl_start =3D smb_lock->start;=0A=
+			rlock->fl_end =3D smb_lock->end;=0A=
 =0A=
-		rc =3D vfs_lock_file(filp, F_SETLK, rlock, NULL);=0A=
-		if (rc)=0A=
-			pr_err("rollback unlock fail : %d\n", rc);=0A=
+			rc =3D vfs_lock_file(filp, F_SETLK, rlock, NULL);=0A=
+			if (rc)=0A=
+				pr_err("rollback unlock fail : %d\n", rc);=0A=
+		} else {=0A=
+			pr_err("rollback unlock alloc failed\n");=0A=
+		}=0A=
 =0A=
 		list_del(&smb_lock->llist);=0A=
 		spin_lock(&work->conn->llist_lock);=0A=
@@ -7701,7 +7709,8 @@ int smb2_lock(struct ksmbd_work *work)=0A=
 		spin_unlock(&work->conn->llist_lock);=0A=
 =0A=
 		locks_free_lock(smb_lock->fl);=0A=
-		locks_free_lock(rlock);=0A=
+		if (rlock)=0A=
+			locks_free_lock(rlock);=0A=
 		kfree(smb_lock);=0A=
 	}=0A=
 out2:=0A=
-- =0A=
2.43.0=0A=
=0A=
