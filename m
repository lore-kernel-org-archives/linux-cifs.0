Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654CE3770B;
	Tue, 15 Apr 2025 02:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744682590; cv=fail; b=KbBmj/wyihYmWhgoKFH4ZIkYmxV6Dd3WmrB8uUin2e0ITPHunM7STE/zvyWYPW870Dxe9FBVi0M4z8LR54KXsjAZkFgsqYzegy/CfZ6rhMgk3SxqEXAccL8HO75UlhkTqDSAgZorpc58yy8P0fUt6gNsvnsa77MuE08ARlRhQ4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744682590; c=relaxed/simple;
	bh=dEzM4ZTm7CNeCSfRW4HmIlYvxso6wv5kjWf60w9RzE4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=NDWxUSRL/yUduTGxc7RnEhB9OQ9GvPzUEt4zWnrpmGGZvpOwwLmQTNzISMRwULdjL4C4h0nXTbtuNtZTrhalcaGbYALewGSVoe/XpjHFmm+iQwtR2OjfsVT7abx3OX3qBFokXj2oE5acMLm3C+2j8gS0s7jwKT7+0k7109iDAS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53F0RIeU020620;
	Tue, 15 Apr 2025 02:02:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45yf58jqy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 02:02:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0jCuLNfTsX3ydxqu1OnM1KA7sGfW+Td+KUF0xugEkTUi/2hylxYSyXShtSPsHFjTcngY+W+hPsSsEY3x0TaUqAgnr0yLY3zGynwdJRJIfGjs4O3dfhOJJ+c7jPNtsiZCa7y/mOtgFai3Oyo4rOqwCbYfYqCeYDGP+rbIG8g2WbVULN7Xq7oVYNBZsHPH7aoFWXmOTYgdHv8z1vJrqW3FOjpyMrkPcZcoB1T7AnmI1MA8IP/b05YDVh/5wh+1ncT7jlBlwpYKMaoyT4s+nm4WBAsBgHCbStFTXgIGqgPcOe+jNkund/gSNQaglAty8CLWuKGcFzz52qBMeXLuw8UUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJizoYRMNlFVk7MIdN+EMN0e0/FeoiX9feeeazRAbvk=;
 b=ZanMD2wbBh3+SkXHo0l9ZqBt51EnCyLNSELB2rDz1Z+5EHhlBOh9Zt85Y62wiAin4Rrsfi0VKRLcyOqk+3iE0p78Qal6fQEseKddQF3VNka2qMhkEMDwdF6fNfF8B0Krh8/0KUWhYeapQ5Si7SbBwdZz7zmmGRaJhDW7Mh4yY8lGf4bsqBK6Y0H28QYDMT7N76aSltNq+1l0m6ZbYbJdm1DBw64/GdyEmT7iXp/ilvQFJmDiHVfdbSkwcq9UvS8/o5vdIM73gSTFr8AlrFYLWCVwPWiaBg0b9++dGQqVTP48J8TGFHeGtx1uaXEixLFsq8zlazAYNk6hEeFT9SBy9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6)
 by SA1PR11MB6661.namprd11.prod.outlook.com (2603:10b6:806:255::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.36; Tue, 15 Apr
 2025 02:02:24 +0000
Received: from CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d]) by CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d%4]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 02:02:24 +0000
From: Cliff Liu <donghua.liu@windriver.com>
To: stable@vger.kernel.org
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Zhe.He@windriver.com, donghua.liu@windriver.com
Subject: [PATCH 5.15.y] smb: client: fix potential UAF in is_valid_oplock_break()
Date: Tue, 15 Apr 2025 10:02:12 +0800
Message-Id: <20250415020212.320762-1-donghua.liu@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::25) To CY8PR11MB7012.namprd11.prod.outlook.com
 (2603:10b6:930:54::6)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7012:EE_|SA1PR11MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa58b08-9e3e-4c08-f4a2-08dd7bc19061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IgywF0jovTb/llp/rfXa16g2tJTw+Q74g7n4qzEK/fK2zvRBMd5arWqTDk7M?=
 =?us-ascii?Q?3q6hNEpXLcRhThLkvpazzx2DaZsNVPDuXFuVpSTbacmNQUmarPJ+5mtwiD9d?=
 =?us-ascii?Q?LLD2PpVwB0+ud3xYEaLZMptskcean97E+sKNhkj368Zwy6C5y5Dcym9Eba07?=
 =?us-ascii?Q?DIhKQa0iQvN8USY4963eYYKn9xATNE7GT64UtuRVYfQ/zPHxyISxcgxcTjNV?=
 =?us-ascii?Q?GTLjq/xaF1ASU2HjIfTl0ZL1xfUmcjgrK7dhxedzltQokApOv6WZ2GW7Sfe5?=
 =?us-ascii?Q?dE5SPb80dxOqzmk/b3GlnlsRqnbrBCpxyoleAkPbAbAkNUFVPSd/zqEaRRz+?=
 =?us-ascii?Q?ovXH7d6YPDTZU4r9nyk50E7Eh/BMGJMTYM+LWNp3Z/VgHrr+f38Bovr4m2h3?=
 =?us-ascii?Q?IqjTrIf/wpXkG17vqIqJqgrF12YR0rYGYy99T9N9f0wk9qSPRF1w4zjm8hyt?=
 =?us-ascii?Q?CLfhBhoFbWtpcCRqzQRzJMAGMR2/2HRxfSewE1bQu4muAnGzVui1MM7fNR1H?=
 =?us-ascii?Q?fbW5c2jlSzxMg//AFW3aJOEZJe4gODLTmKz1wTDOIlBnqruZxhycj1KP3+6U?=
 =?us-ascii?Q?iYBmvHUow6GFWIXol/PLUqFKsMdHxFdnv+WyWRXPC+e7tFefKktwT3mq6ysF?=
 =?us-ascii?Q?24MCUQaqBRjnECV5ZcvYf/uYZtKHV8fNGnfSCa+pbuVKAQFqqxufWjntKnUU?=
 =?us-ascii?Q?JUqPAgO1Zsvy3goQyMiXOaSC0JlFFZtr6+4h2mW23BtzT2OocLZRv12qtQXO?=
 =?us-ascii?Q?n16X+Anca2ueOrdQD9Hs0+LWcWbuWvkU7uxVBe2/hK7m8OpmzU1CyDrda4OZ?=
 =?us-ascii?Q?tZHksouuIFhgO/Bhqp8VNpSE4TT4Vqe7os3uTI5Pph09cTRopsdE+qadx9ol?=
 =?us-ascii?Q?qfZfon6tCb/5QEtRr8H2FYH0kFwxRvBEex/+6e0Ixegx+iPAqWaEssaK05HM?=
 =?us-ascii?Q?T+Hla+neCIB0PP67YUqIHfOMbWB4a9g08HRQo5yilWkVRrKRlJOFDhW4dJZF?=
 =?us-ascii?Q?eE95hXAlhzG5006LgoSFXrkBcm1cUgVhF+7eZThwJ1/VvPXqvsmHszkfBZw9?=
 =?us-ascii?Q?zZh1WfOoP1wGoL8djmy+pGkkOBT1aJjyFdsN5a7EfCt1TPGOB6MY1PX/TSrU?=
 =?us-ascii?Q?aMoxDBGRTL6ThUYctYOLyyA6CqpLVuWII2gWijWyuvnD9qzTF7FSfZEHcZoJ?=
 =?us-ascii?Q?AO1eYAHkeqgHsHNbOdhh8T+Kr51mHOKLrKiSgjgj76ytucBmPOd9WRDmmfDV?=
 =?us-ascii?Q?FBaKb4RgNST4rRmGdaanmQshaFSfmtYAaWvb5QMP+9MHChEYvbRuf7fuAphi?=
 =?us-ascii?Q?zhd/UmnLgQ6ZyFsbba79cOJWBuBAmdBjD31B+9b6VzzYzLwv3GuFZ87lZ4Bf?=
 =?us-ascii?Q?zhE58O1Dk2RN4OOFoqXhrZJP5/ZRAK45s8lWHjWGHCEv5+vA3osJoFeEtY3U?=
 =?us-ascii?Q?QwVYTO5ub//kQxn/jflW2nGeWj670xEKcKimREQ8OyxZFujzMwl90Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/g8mpIRRCGrAtrmeEGLw3rd8m4GVHn6Vm7mVh/OFl1WlOb4dXnjwEPSa98Zh?=
 =?us-ascii?Q?NzuJ8yT7+t5lFPBJIHFLtfmNxDfutQ7TCkyhXo3G+pLuV21Ru+Hq56hG/Q8h?=
 =?us-ascii?Q?hy7wIzXfU3suad1J2QxetvCD3hGWNnX2zZDRBg/trMjDgeHkZn9oDNOF65Wn?=
 =?us-ascii?Q?04HKDsN37MfEabxIykrQzDxyaqD1vmd1lEnTzdp7Sx7AP4Vk1NUgQNdIqLva?=
 =?us-ascii?Q?n67n/IjamXouUkI2DvBfmpCXv138umL9xvDr881Dmb/tjqqtQA1FYFC3LTCX?=
 =?us-ascii?Q?ZgV8VtwOXSF8K2XPc6wmfT0Ix9t4HnR7Kg5oAM7MXtZXhr03t1KzgJwYvaU2?=
 =?us-ascii?Q?LD8RuGT5ywf0b9/gItMdw/qEDFgA+CpmRLeDfrwbwyCsDq7TGj5floj88Mr8?=
 =?us-ascii?Q?9Z6mpXczx5LqdY5WiUYx9vIymfqzqYMu7J+IlHT0HRiPOoib47ZCIF7QxOk/?=
 =?us-ascii?Q?Z5KoFJCSGj9QDgiPbZu2GiMoB0MElWPOg6BHAJgVKHk7FMjz22I5pSI8GH+P?=
 =?us-ascii?Q?ygJQo51tVZ1L/B/Vm5y/oU9yzHK+Wgk42tQhUy+pyfoW8JwCg3umDQL2NXmA?=
 =?us-ascii?Q?3FY2L1JDzCK97L75lB8GKBEFQ021DK4qPJrDGFn8/9lrql3u+eGFYjcqqnoX?=
 =?us-ascii?Q?oR+7MNuc0iFmAaFlnZ3Xehu+6e5CGqHdLQwTiSMPOAEnEz8DCazo6PctR5Jq?=
 =?us-ascii?Q?Fm+zs24Lp1eSMQn0xwnBWBI6cot4S0s8DY0J6RR6EFpkE6Thh/orcspKmivW?=
 =?us-ascii?Q?9gGc1KmucGliiCg9GvFn5jJDhrEfdrkbc3iigyRmOCABGiHA8qwGGNJ3p4bI?=
 =?us-ascii?Q?4xVQ0N4vayTWLaCzOLk21shXHdYN0oxLz67VNkPIA4+GmdIn0Z86IIIKNrUp?=
 =?us-ascii?Q?TgZpJ1sANGRSB67fI7xLL40PGy+MnxEIcUc2QJ0WMAjUTo1OjcyNKg4/wl9u?=
 =?us-ascii?Q?smdbl5thOCdSgzOjR+MyJZNAVskUS/GVIjoMNmgud2FjJH6W9bVr/Fu4QEGB?=
 =?us-ascii?Q?Pz3WDCQYEqCpXRORID5qmS53tlq6l5co5tWnHZJd6Vaw8E4x9BLMVQPRWKOD?=
 =?us-ascii?Q?O1nHCfn905AqJy2b0Gx8QBhozvTimySNtXSku0C533Ee48djShqdzYHebbrV?=
 =?us-ascii?Q?39kz5xryjqcyrOgAL/I2Ik4NyIdPjZ960k2CipyzZnuHrm1XUIIQg3Suhvtg?=
 =?us-ascii?Q?ZLacWhmkORFlZDs2mHGlnAI7mf6Ql9zaQgCgj4KZCQLVRmvZLM00ZYCtQZjv?=
 =?us-ascii?Q?zR87pJ7OQcR4lMy2l7V7Os9bEjuXpt9nlyPVedRUD5jXYyCuO6ODqQhNEmZ6?=
 =?us-ascii?Q?APSThzbWvxuy2o5x07/1bqVKGTxikd3kIzF83AeN7fSIC06/F7oUCdZSI9U4?=
 =?us-ascii?Q?fuIka+uqmQLCzkNMmmPPeo8OOMrCtSmkXKVxPKjozeqGMiXVI/Vjy5Na4jIp?=
 =?us-ascii?Q?whU8h6kYGfEwKOUG7aoJVw09j0nxREupFZ5NT/3PZ/+cyZa0cyTlvyirzKO+?=
 =?us-ascii?Q?Gaffl85Oy/qJn5amljWaDf5P+BQjOK47PS6C9tUHJ6rSgCN5bKAL9wGIsP0r?=
 =?us-ascii?Q?wRJMMWZouUkElnJK6USRgkRwqKG5QgflUuQVSGwB5uWWuvqs9zuBOq3Q3ASI?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa58b08-9e3e-4c08-f4a2-08dd7bc19061
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 02:02:24.0286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGVaI/uTmEXaMxZ8ISMYe0xfh4sGHzpcNw2j3rzIIhSW5yd5CdVEMJX6BD1O27eeSm6RMbzwV1Xlh6zKfVQMBdrRo1Tled40uhpqDUjg06U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6661
X-Authority-Analysis: v=2.4 cv=UPPdHDfy c=1 sm=1 tr=0 ts=67fdbe32 cx=c_pps a=oQ/SuO94mqEoePT5f2hFBg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=kTq-Ll_e2unazRsUWSIA:9 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 3tpJTQMJSlkTnk6VkY4NW2G_6S7St2qd
X-Proofpoint-ORIG-GUID: 3tpJTQMJSlkTnk6VkY4NW2G_6S7St2qd
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-15_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=943 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504150010

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 69ccf040acddf33a3a85ec0f6b45ef84b0f7ec29 ]

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[Minor context change fixed]
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
---
Verified the build test.
---
 fs/cifs/misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 33328eae03d7..c7e2bf7a0a0d 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -464,6 +464,8 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &srv->smb_ses_list) {
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each(tmp1, &ses->tcon_list) {
 			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 			if (tcon->tid != buf->Tid)
-- 
2.34.1

