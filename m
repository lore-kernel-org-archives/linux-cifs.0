Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.73
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793112240;
	b=CQdn8gkKinjuJLni5fDGhhXEr7FaNOxuhIzXZ3rr3sJwtCtrLbfJrU4ERPjaAx+cQkDA
	 QSvPhHKbu3CAdaojZVFZOAhXsh/iy26sK+YbeUj+baCmph8fh3FsVTvzHjCf9tYgLKJO2
	 sslKkaaoeOyi1AV/KU0Xb5t5b22C7Lsu+dCKfzPJqQc/L4IbXK+lbZ8sZz1khhClZ13Fr
	 rA4G1dEupRQye3HMlpHYSRHGjWZLmlP1tBChQTdfSd2GHKn5Y5f5kIQHelVSZjiDPEmhP
	 Cqp3kFFgHc1nQPmke4Xuehq1Pbw6zG8lrwDpRbvR099PTTXan4CBp7LTCQtULgDdY7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793112240;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Reply-To:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Ubtsox+UTcYgetZQTj9uD+NTaAPUXhTZ4XYP487JszU=;
	b=RfRl4r/dtNTfsuS5Gk0LuhCy5UzgatP52+XzwCYKX67J+Z8uLqWIt0HpPqehqpnrbCQy
	 b2zJI9Lm6Lo0g5bnbY66hT7oka8ABRfW8R4zpEp6oqjGCLWuWkHnSX3j0zPWnttmmYp0x
	 h4pDRb4gLYRBlv4DsnyV0y7WcTVIKTx9fNG0uxtnYTgHJyT6isIjosxtrX9NKp4rNx7A9
	 /iRbCE6zgKobDM1NZypc7iNs7Ri0amgIFNrXItWVYVcrQpSUGKZMJLsaLTKRxum455VPW
	 M7+f+DhEaJ+s0B0TloljuxnL2n/VP+4XESGcxYt2v0twtrUTD8nbL8qOoqqYVtLJOdQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ZoesTkpE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.73
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013073.outbound.protection.outlook.com [52.103.43.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F190E606A31E;
	Tue, 27 Oct 2026 14:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F190E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ZoesTkpE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XWLR7J9Z+5MN1eem2bIlZbbdQADVfKhtQGz1yY5vhf7Yl8gazfTR+/cffv96LUpQHB3qbxphbcWQoxv7oO9u9JU8laR0lawCVbopwIsI6zFRTC10Zw6YjJuhJZ4O8kyKa+vvQRKhGg+5h2unuvx5dZ0pb5I86Mf3juVXdmghEM2UH4F9JEeyqdrZKSw1OsiZIZBiu7R52w/HW7bQWhFNXt/fprp22lR4d7Y1NNDPFIe+YepY/MtyfuYPt8EQdDlT1jN6wO83tO444zXBfRlOOgagt/AdulsTmscRcqcFWUrZsMKV/Rvhqrfaj7gLbP4s5KQLrg0DLhORDpaOhw32yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ubtsox+UTcYgetZQTj9uD+NTaAPUXhTZ4XYP487JszU=;
 b=IVjoXaBI7M26cNEY5PGjLKkZQRtZ16dJmvm9HIrswMY11yZtPP5S6E+q2sHXVrg/+dBbcA2XhiP+Vz2r+bPxDnRmkBP3F6BVJ3RkAGmFfMnghmm2GTEQABVpF/Xug7zFEs2SWiu/fMAPVebrvHvjdIG7fc4O6+HC5na+MO5fZ9sTCjdSi70vzzto/sN5lm0ocpRzIqlMPrxEk1cMc2SsChRMn+l7YyroF23crVRVIKzGa03n303PPF1PagD7n/Hgsipe20BKnQNzB6OXB3uqWMieOzfQw1na15qRsqlMljhsvGtaTXj0BX97s0bt3Jgb0bRKMwyVZJ/V5ANzYVwjeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubtsox+UTcYgetZQTj9uD+NTaAPUXhTZ4XYP487JszU=;
 b=ZoesTkpE2BxdcT3pb6TOrANNdF6xt9hEwlcEbCb5Oq/EDcxxaWTsWUtzQJrowelKAF7+B3fmB6Chuz/z0XOS60LQkl+UM4QPCpBpgpJj4cbRnkuRIUx8k53vw1B3yAo46f3dWsxCvwLl75ETcguPv9Cr+x3aaYxNzl1Gea1ELD6PVvOxDsgbzsi/lO3nELvMq1ejSmgLC6YyHNAcEfXfip8YbseRjoxoRYpYyZts/qtMlU8sVZAdxaUE9oqjSvhTDDWxRXOTpIwbwlDzKV3dvkQg3cjC/AUbja8fRZjgzEerLFmhrV2u1Gf6vw3AcV85ADtMuL29dfpNJXK6Iwp1qQ==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by OSQPR02MB8798.apcprd02.prod.outlook.com (2603:1096:604:429::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:43:56 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:43:56 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] ksmbd: fix named-pipe reply loss with small output buffers
Date: Tue, 27 Oct 2026 22:43:24 +0800
Message-ID:
 <TYZPR02MB6959F27B6A5B32E6F0C79035E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <TYZPR02MB6959DA97FC41F99C5DBD9CE8E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
References: <TYZPR02MB6959DA97FC41F99C5DBD9CE8E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
Reply-To: wangzhaolong633@gmail.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:610:cd::12) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <20261027144324.1869357-3-wangzhaolong3@outlook.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR02MB6959:EE_|OSQPR02MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 936596a2-1c6b-450b-d488-08df3438ba46
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|12121999013|23021999003|22091999003|24021099003|24121999003|4140399003|25010399006|260925184616899003|41001999006|51005399006|19110799012|8060799015|5072599009|12091999003|10035399007|1602099012|40105399003|26121999007|3412199025|4302099013|440099028;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rFhLp2SnFKL1ZnYrwtggNqOH/ksq5zGW9J+Wr2hpWrzArkwcM5aMBWYLJAS7?=
 =?us-ascii?Q?KyF0/Cgs5hayt2ph3rVeuOF72WpHlihe5dWsUQxz8HsjpxTVeUmQZ75uFhyK?=
 =?us-ascii?Q?gfbIIOHeTiY88erS046/P70019G3AW1fc9rGgdIEaWx0o0pOtguPVdLyX8N+?=
 =?us-ascii?Q?w8xMFBL2KGhyIGfNYLtrItrz1ddarRWzzXlUmFZVMq5K8zkJXnw2Mn8KGrn5?=
 =?us-ascii?Q?FsIUIyvHm5Z6ymyKbBczcY5qdhnNSKzU4JNbA6y/G0K1cGpDzijXU+fob0Zg?=
 =?us-ascii?Q?HawCnlS8vUINey2Y8viDzNP8TFXmTcVGWkCzErhUuOqbEvfAxf1mlrImQIwy?=
 =?us-ascii?Q?W88QOslj0hcAhvdrzSzhDZTEfZkHAgbl4b6Y+Cr1D+o7ae4yZkH1lAgi3xTc?=
 =?us-ascii?Q?f2/XeYAxdYpEoaMxKkK4rDoUJmtdyavP3YgCxUTtepGKybUxHCnMni8ZUyS1?=
 =?us-ascii?Q?kFPXuhvGJU4ysb/ugDxiY3YR2mBiDDAfGvj91NJwG7p+JiJ0F8X0wESGVT1e?=
 =?us-ascii?Q?oBkYPGwhZoX+BzZEY56kEeUPuD29+Ex/kOsnSRHaOxABzFjrGt+QAIPxAgm4?=
 =?us-ascii?Q?GsvAPcNt7qQDDpMuyLUg31gk3dvOhkXc02YsQ5ZiRAlKdWnZurVRnkEOy3z2?=
 =?us-ascii?Q?QPMFZcLF9fXUXy8iIIQSMAhLoIygJ79xgF3ex+qzHYKEy95UFRxCzT7Ya7Gq?=
 =?us-ascii?Q?Lqy3f3udXXHrBefN3zU28lcfIwa4rvIj3WGqRaSX541mJOGHNSuH2HLOIbx9?=
 =?us-ascii?Q?JLIf7afJMp3J4nbi44mfr0CGy9mlGw+7/3bhayetram//xs/SUXngQ1VoTGK?=
 =?us-ascii?Q?12y4nn3U2lprRZhcuZXbilghH3zWGaLe9qAB8+7DrnmwPHPCoVbeA7f5ovAp?=
 =?us-ascii?Q?RXO2J9sQiYZfDbzjitm4g0UFAuQ7Rzw7j/nDJlZZKOdSn93RjLtE0UL4TCn7?=
 =?us-ascii?Q?ZnHJBKBIJzKK1SkG7fIqPHT8RnbRgm5tw/MlWgzqZGU8Mb1pB73m+T42YF4q?=
 =?us-ascii?Q?hkkJOypVioAniN+CIEfGKio7Soo7xzL99B9kv+lQxmXkjv7yK+Wd9ZaH54kr?=
 =?us-ascii?Q?LYlQNWS00vyUQB1wfl09i7xLqKgQ9ixAhVVVEed4xX2J7rYXaHGPzK9HVU4F?=
 =?us-ascii?Q?O2eWlQGpcAQldYiIsuxWNgpqPXkSCCJPWmWMF9UaYeQzDoqOtcz6aNI=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3PCpcHAhAARa+MEXYUSTToFMThCuIiIGxM6BKmHWejK5+CWzqtg9IiNFyV6S?=
 =?us-ascii?Q?g2zelppEYA/TPeq0ussuWh6aGYKcS5rox/vxKPXn5cJlg28hUShy3HX5VGfA?=
 =?us-ascii?Q?OjBrKlGMgcUBTKgQew9Yq9JdliIMP2Uqn5qvdHTcF5OsDfn9sEOiFXD8ydR9?=
 =?us-ascii?Q?5f4f9yTY/NmlbvyztAZURJVEokJmH+8akhBSEeMloJT0hHmInoNehuQgep+i?=
 =?us-ascii?Q?BvBqjzwN5+7MBvv0chschVGLxPTv1NIopMhYwgF2kTfd8MAIZ6QpspoAFgJZ?=
 =?us-ascii?Q?MbBFnXPYXwRaN6dNl3L+7B1VLBp4/ytwHiUkA2rnClpavGKxRPp3APQY+dup?=
 =?us-ascii?Q?4FWEy9zkc+EBmFzIM/g1qHYVbBEn10wfaP8QlGuIbHrjTicPYABQsFzKRKa+?=
 =?us-ascii?Q?2wQ1N8iNr4mDkqGpM+fCHCsr5Tz7InKTLb9yZdgQuMSFB9BW/7OBNWssYISb?=
 =?us-ascii?Q?Fxotp+p++Oc/p1gvJBnfYfSlbfEFBPPMvCAlFUIpbcIrZmowstmloFoQL2vK?=
 =?us-ascii?Q?MtLQieDHj2UD8mNdWJdWiPyczFbCgLQer8keFwtyWxvCERm6OXvhm2oVs44I?=
 =?us-ascii?Q?PLWwYzGYk3Iu7XonEqcxA9oaFBQYvmCvewfkm8jZBj1XM1kE8XQtnKpgokJd?=
 =?us-ascii?Q?M9/KvcW0C3qmlEKEaLoR4FEguR+3oRF6+bqy77ZJPseSL6m0t6gDam1IxAPc?=
 =?us-ascii?Q?WFeFu1HG67aDjgVx51Mmux9/r44BGagRMAcSdyaDmTCFkRMarUWVuy4RxFKU?=
 =?us-ascii?Q?eA/tl+LTSZ6KxBEV9fOAq8pnGHPIu5HlovPAIs8sHhnD1QZbWc6BQH4Beb/l?=
 =?us-ascii?Q?7pktgkMygls6Zoi8qcY3cdyLNoafUECCauoYJIntIDoFJi4ToLbpicGJMrF1?=
 =?us-ascii?Q?YouTi50H4/FEiOMRYzhit3xXvF575sOcr3oUVZ2gswVVgred/W7o9xwD3SNB?=
 =?us-ascii?Q?qZAZunnJrnmYO6sVemcT3xKYf0QMRAkGoSoJJTKPhENx9xZf2Bbvkt/SwUfy?=
 =?us-ascii?Q?FtZEbxk3MFzbrpWSulFFx7JUblxweH31CQ388xsIus5VfczsbAh4GfshfJ3B?=
 =?us-ascii?Q?oPPu/2SUVbnDcRwb//mH7ucu2ewQODz7LSoyQqdLkQaLoan79U3rJqkwQmPO?=
 =?us-ascii?Q?uK1PXNPmiftEj7EmHTusjTEkrgqR1tvVDvrFZ1lnVYZ2lJqPgHuhmIehOAlN?=
 =?us-ascii?Q?ZovgEjvFZ0NmU9SntnlHpjeqVURjOB81hnr0U5alpX/tVyktRVGgNFR8Tr5F?=
 =?us-ascii?Q?b/roddIeNmw3opyPatnDw3JfZLiYHqSvNYiLCk1gq09mGJPAl+76j2WGVJGg?=
 =?us-ascii?Q?HAPVLqTcPUiN76aQVh3TVufM5HUoTiMjN4e2fk7yNEMoXPheX2gtoHqi0Qix?=
 =?us-ascii?Q?vkZ6C8oOsN2NNE+i0/ar7OhmVrMbYa60WwXN464996hmSGwFJA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936596a2-1c6b-450b-d488-08df3438ba46
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:43:56.0422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR02MB8798

FSCTL_PIPE_TRANSCEIVE copies at most MaxOutputResponse bytes from an RPC
reply and reports STATUS_BUFFER_OVERFLOW when it does not fit. It then
frees the complete IPC reply, including the bytes that were not returned.
The client cannot recover those bytes with a subsequent READ, so an RPC
call can fail even though userspace produced a complete reply. Pipe READ
also ignores the requested Length when copying an IPC reply.

In the reproduced Windows NetShareEnum case, a 2632-byte reply is limited
to 1024 bytes of SMB output. The remaining 1608 bytes are discarded
instead of being available to the follow-up READ. Increasing the
application-level enumeration budget does not change that SMB output
limit.

Keep unread reply data on the pipe and respect each operation's output
limit. Preserve it until successfully included in a response: response
preparation failures and later input must not discard output that the
client has yet to receive. Treat a failed IPC exchange as an I/O error,
rather than reporting an empty read or acknowledging a write without
an IPC reply. Additional RPC reply queueing remains userspace's
responsibility.

Reject TRANSCEIVE with STATUS_PIPE_BUSY while cached reply data remains.
Do this before contacting userspace, without accepting new input or
consuming cached output. The client can drain the reply with READ and
explicitly resubmit the transaction. A successful positive-length READ
that leaves a suffix of the same cached reply reports
STATUS_BUFFER_OVERFLOW.

Keep cached bytes on failed requests, and consume them only after the
response is pinned successfully. Release the original reply
when drained or when its pipe is closed, logged off or disconnected.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=222196
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610260610.5prVfJss-lkp@intel.com/
Signed-off-by: Wang Zhaolong <wangzhaolong3@outlook.com>
---
 fs/smb/server/mgmt/user_session.c |   1 +
 fs/smb/server/mgmt/user_session.h |   3 +
 fs/smb/server/smb2pdu.c           | 154 ++++++++++++++++++++++----------------
 3 files changed, 92 insertions(+), 66 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 4db69809b9fd..3f75049be878 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -301,6 +301,7 @@ static void ksmbd_session_rpc_free(struct ksmbd_session_rpc *entry)
 {
 	if (refcount_dec_and_test(&entry->refcount)) {
 		ksmbd_rpc_id_free(entry->id);
+		kvfree(entry->pending);
 		kfree(entry);
 	}
 }
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 38073ea9089d..5f0f6276e316 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -19,6 +19,7 @@
 #define PREAUTH_HASHVALUE_SIZE		64
 
 struct ksmbd_file_table;
+struct ksmbd_rpc_command;
 struct ksmbd_work;
 
 struct ksmbd_session_rpc {
@@ -27,6 +28,8 @@ struct ksmbd_session_rpc {
 	struct mutex		lock;
 	refcount_t		refcount;
 	bool			closed;
+	struct ksmbd_rpc_command *pending;
+	unsigned int		pending_offset;
 };
 
 struct channel {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 66123b7afd5d..b73e49201417 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9262,6 +9262,17 @@ static __le32 smb2_pipe_error_status(int err, __le32 fallback)
 	}
 }
 
+static void smb2_pipe_response_done(struct ksmbd_session_rpc *rpc,
+				    unsigned int nbytes)
+{
+	rpc->pending_offset += nbytes;
+	if (rpc->pending_offset == rpc->pending->payload_sz) {
+		kvfree(rpc->pending);
+		rpc->pending = NULL;
+		rpc->pending_offset = 0;
+	}
+}
+
 /**
  * smb2_read_pipe() - handler for smb2 read from IPC pipe
  * @work:	smb work containing read IPC pipe command buffer
@@ -9270,12 +9281,14 @@ static __le32 smb2_pipe_error_status(int err, __le32 fallback)
  */
 static noinline int smb2_read_pipe(struct ksmbd_work *work)
 {
-	int nbytes = 0, err;
+	unsigned int nbytes = 0, length;
 	u64 id;
 	struct ksmbd_rpc_command *rpc_resp;
 	struct ksmbd_session_rpc *rpc;
 	struct smb2_read_req *req;
 	struct smb2_read_rsp *rsp;
+	void *aux_payload_buf;
+	int err;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -9294,46 +9307,61 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	rpc = ksmbd_session_rpc_get(work, id);
 	if (IS_ERR(rpc)) {
 		err = PTR_ERR(rpc);
-		rpc_resp = NULL;
 		goto out;
 	}
-	rpc_resp = ksmbd_rpc_read(work->sess, rpc);
-	if (rpc_resp) {
-		void *aux_payload_buf;
 
+	length = le32_to_cpu(req->Length);
+	if (!length)
+		goto empty;
+
+	if (!rpc->pending) {
+		rpc_resp = ksmbd_rpc_read(work->sess, rpc);
+		if (!rpc_resp) {
+			err = -EIO;
+			goto out_put;
+		}
 		if (rpc_resp->flags != KSMBD_RPC_OK) {
+			kvfree(rpc_resp);
 			err = -EINVAL;
 			goto out_put;
 		}
+		rpc->pending = rpc_resp;
+	}
 
-		aux_payload_buf =
-			kvmalloc(ALIGN(rpc_resp->payload_sz, 8),
-				 KSMBD_DEFAULT_GFP);
-		if (!aux_payload_buf) {
-			err = -ENOMEM;
-			goto out_put;
-		}
+	rpc_resp = rpc->pending;
+	nbytes = min(length, rpc_resp->payload_sz - rpc->pending_offset);
+	if (!nbytes) {
+		smb2_pipe_response_done(rpc, 0);
+		goto empty;
+	}
 
-		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
-		if (rpc_resp->payload_sz & 7)
-			memset(aux_payload_buf + rpc_resp->payload_sz, 0,
-			       ALIGN(rpc_resp->payload_sz, 8) -
-			       rpc_resp->payload_sz);
+	aux_payload_buf = kvmalloc(ALIGN(nbytes, 8), KSMBD_DEFAULT_GFP);
+	if (!aux_payload_buf) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+	memcpy(aux_payload_buf, rpc_resp->payload + rpc->pending_offset, nbytes);
+	if (nbytes & 7)
+		memset(aux_payload_buf + nbytes, 0, ALIGN(nbytes, 8) - nbytes);
 
-		nbytes = rpc_resp->payload_sz;
-		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
-					     offsetof(struct smb2_read_rsp, Buffer),
-					     aux_payload_buf, nbytes);
-		if (err) {
-			kvfree(aux_payload_buf);
-			goto out_put;
-		}
-		kvfree(rpc_resp);
-	} else {
-		err = -EIO;
+	err = ksmbd_iov_pin_rsp_read(work, rsp,
+				     offsetof(struct smb2_read_rsp, Buffer),
+				     aux_payload_buf, nbytes);
+	if (err) {
+		kvfree(aux_payload_buf);
 		goto out_put;
 	}
+	smb2_pipe_response_done(rpc, nbytes);
+	if (rpc->pending)
+		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
+	goto done;
 
+empty:
+	err = ksmbd_iov_pin_rsp(work, rsp,
+				offsetof(struct smb2_read_rsp, Buffer));
+	if (err)
+		goto out_put;
+done:
 	rsp->StructureSize = cpu_to_le16(17);
 	rsp->DataOffset = 80;
 	rsp->Reserved = 0;
@@ -9349,7 +9377,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 	rsp->hdr.Status = smb2_pipe_error_status(err,
 						STATUS_UNEXPECTED_IO_ERROR);
 	smb2_set_err_rsp(work);
-	kvfree(rpc_resp);
 	return err;
 }
 
@@ -9947,7 +9974,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	if (IS_ERR(rpc)) {
 		err = PTR_ERR(rpc);
 		rsp->hdr.Status = smb2_pipe_error_status(err,
-							STATUS_INVALID_HANDLE);
+							 STATUS_INVALID_HANDLE);
 		smb2_set_err_rsp(work);
 		return err;
 	}
@@ -11440,14 +11467,21 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
 	struct ksmbd_rpc_command *rpc_resp;
 	struct ksmbd_session_rpc *rpc;
 	char *data_buf = (char *)req + le32_to_cpu(req->InputOffset);
-	unsigned int nbytes;
-	int err;
+	unsigned int nbytes = 0;
+	int ret;
 
 	rpc = ksmbd_session_rpc_get(work, id);
 	if (IS_ERR(rpc)) {
-		err = PTR_ERR(rpc);
-		rsp->hdr.Status = smb2_pipe_error_status(err,
-							STATUS_INVALID_PARAMETER);
+		ret = PTR_ERR(rpc);
+		rsp->hdr.Status = smb2_pipe_error_status(ret,
+						 STATUS_INVALID_PARAMETER);
+		smb2_set_err_rsp(work);
+		return 0;
+	}
+
+	if (rpc->pending) {
+		ksmbd_session_rpc_put(rpc);
+		rsp->hdr.Status = STATUS_PIPE_BUSY;
 		smb2_set_err_rsp(work);
 		return 0;
 	}
@@ -11462,39 +11496,36 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
 	}
 
 	if (rpc_resp->flags == KSMBD_RPC_SOME_NOT_MAPPED) {
-		/*
-		 * set STATUS_SOME_NOT_MAPPED response
-		 * for unknown domain sid.
-		 */
 		rsp->hdr.Status = STATUS_SOME_NOT_MAPPED;
 	} else if (rpc_resp->flags == KSMBD_RPC_ENOTIMPLEMENTED) {
 		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
-		goto error;
+		goto free_resp;
 	} else if (rpc_resp->flags != KSMBD_RPC_OK) {
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
-		goto error;
-	}
-
-	nbytes = rpc_resp->payload_sz;
-	if (rpc_resp->payload_sz > out_buf_len) {
-		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
-		nbytes = out_buf_len;
+		goto free_resp;
 	}
 
 	if (!rpc_resp->payload_sz) {
 		rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
-		goto error;
+		goto free_resp;
 	}
-
-	memcpy((char *)rsp->Buffer, rpc_resp->payload, nbytes);
-	err = smb2_ioctl_rsp(work, rsp, FSCTL_PIPE_TRANSCEIVE, nbytes);
+	rpc->pending = rpc_resp;
+	nbytes = rpc_resp->payload_sz - rpc->pending_offset;
+	if (nbytes > out_buf_len) {
+		rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
+		nbytes = out_buf_len;
+	}
+	memcpy(rsp->Buffer, rpc_resp->payload + rpc->pending_offset, nbytes);
+	ret = smb2_ioctl_rsp(work, rsp, FSCTL_PIPE_TRANSCEIVE, nbytes);
+	if (!ret)
+		smb2_pipe_response_done(rpc, nbytes);
 	ksmbd_session_rpc_put(rpc);
-	kvfree(rpc_resp);
-	return err;
+	return ret;
 
-error:
-	ksmbd_session_rpc_put(rpc);
+free_resp:
 	kvfree(rpc_resp);
+	rsp->hdr.Status = smb2_pipe_error_status(-EINVAL, rsp->hdr.Status);
+	ksmbd_session_rpc_put(rpc);
 	smb2_set_err_rsp(work);
 	return 0;
 }
@@ -11829,7 +11860,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = id;
 		out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
 		ret = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
-		if (ret < 0)
+		if (ret)
 			goto out;
 		return 0;
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
@@ -12210,16 +12241,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		goto out;
 	}
 
-	rsp->CtlCode = cpu_to_le32(cnt_code);
-	rsp->InputCount = cpu_to_le32(0);
-	rsp->InputOffset = cpu_to_le32(112);
-	rsp->OutputOffset = cpu_to_le32(112);
-	rsp->OutputCount = cpu_to_le32(nbytes);
-	rsp->StructureSize = cpu_to_le16(49);
-	rsp->Reserved = cpu_to_le16(0);
-	rsp->Flags = cpu_to_le32(0);
-	rsp->Reserved2 = cpu_to_le32(0);
-	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_ioctl_rsp) + nbytes);
+	ret = smb2_ioctl_rsp(work, rsp, cnt_code, nbytes);
 	if (!ret)
 		return ret;
 
-- 
2.53.0
