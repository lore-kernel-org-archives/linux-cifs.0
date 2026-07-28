Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F1A266B72;
	Tue, 28 Jul 2026 08:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785227886; cv=fail; b=Tv6oF8F3qJPQN7iyNFCWutQtVR2LqRm1MSsN8uZbmqm4TbkXWHc7Z11iGRNshANXLQHSdI5j0AdNXbG40QjHiPODZsNphmcZbnWwFABuexaC3B4205VCElJHWGPwQweTEuZsd/l3O8ZJqJ0QfeKcMLdqSZ1aOnqeN0rrZfs/eKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785227886; c=relaxed/simple;
	bh=P09eGN6hpRCInWRo4Qh+yh2XLVvLlhRVYWeZ3veXGKc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QvIQ9u/1JtSUcFUKWTnaXTDIp07thv9RPejkP67mgp1bToJT27ftgh4qkVykSfRdXXk16nOz52stwgDfeuvuHqS4zlAqmfBMk+FSDH9JF2swSC9Uw6nvXDuHNR91JtnzbYez+v1DgPpyH2TI4ZvcbKnRVNIAyCjkwHPLHVcbfsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=rgk5nBPJ; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="rgk5nBPJ"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S82Wr02760522;
	Tue, 28 Jul 2026 01:36:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=P8i3gXXsaDsoG68/7mX4pXpTw2hD+PLUJspIKegi508=; b=
	rgk5nBPJWGQZ0ECWIreVMF2RCBwu5g+bvqXBbDYAlgWlah9y1R683hVdPEnnttx5
	dPaEE2aurcVQG8gdXGmNh6veNYESS9Qxd4TVr+gmr3kCVcRR9R7Z5I0bwJQKSQiM
	HeQk9gvhbp5TsFJEEi4WMvDrIY+sjdBum+XtT58nn1onpoKJ7F8U/wdACMGemstb
	QWGD2t7Ps1/O+SauthVLkqbWtMd5SvzMT9xOhlRC/LQJ7TzULnjq3s5uYzcJb7bA
	krJ4YNrIHVk8efPFdl1xQkkAhVJT0HE2q3kEUpi+wjlCwBKrjE3agEYDrjt+XUzW
	F1lf0kEA9y5tqK+ymSoRfg==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmre03mwb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 01:36:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQqsLObNsLupTBiIpbP072Sh1n4an8NwHyzkRY9MAG6IPZGKqLv31N2oy50sSJcoq/F/BxkTyKUZ4yGAyOxA+ZMr18xqA6rHBeeUxwKWsgyYZO+GiJ9hkUiRh01XhM0kgLGtxVoztsPIkSPL2QY8DCsrudz7/xcFZeRDC3NeMUKGDWtkbuFZS5tkzUadrvDwj80nA96YbqB+plixglO3lmQ/wKNe/3aXkADWDLQ3UBmRTN07bvSbaOyIrP6Cq2UxcK3qVPYeHMzd1kZw5r1vY0JH+PQBHLvYVc+mpY/rEFwYCNmLWNVWYTMvyS4AO5DUxpWrCy2kiuR6ckmgbSiFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8i3gXXsaDsoG68/7mX4pXpTw2hD+PLUJspIKegi508=;
 b=jSuLNCrV34UrF8XIcq6MMWr5ZWY3T/oKreb5CeV4yzdb93xIPuIExBFgKhLTHqKo8QDwUAHIRd1fuyrm/WtJaePs7gmeYhdV6e6ov5Zbhcg+w19enST1fr707pyIXaUMYCCowXYvewqFw7Z9r2BC37byM0fq+5VsihxhA632tbya0tTOEcKkx7zFcge9zHZMEdv8pdKI0Fhd/hgszbqjFyEG/SckDfSlBRtrfKOd0X0hYb87sRUpOLq5norXltx2w1QabZV10FRjdM3IsQQQCo143T5tXpxZXXQsznj00HV66FBnws+sOYDddTnHwUWt9nU2QEu6j/QKcPtt4/Y9XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SA1PR11MB8351.namprd11.prod.outlook.com (2603:10b6:806:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 08:36:42 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 08:36:41 +0000
Message-ID: <51275778-eec9-4c87-8ee6-97e4c4e6d884@windriver.com>
Date: Tue, 28 Jul 2026 16:36:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] netfs: Fix folio_queue ENOMEM in writeback by adding
 a mempool
To: David Howells <dhowells@redhat.com>,
        Christian Brauner <christian@brauner.io>
Cc: Paulo Alcantara <pc@manguebit.org>, Christoph Hellwig
 <hch@infradead.org>,
        netfs@lists.linux.dev, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+0da43efa72f88bd3a8af@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>
References: <20260727130716.1099906-1-dhowells@redhat.com>
 <20260727130716.1099906-5-dhowells@redhat.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260727130716.1099906-5-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0058.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::17) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SA1PR11MB8351:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c6beaee-4bc9-4b15-b8d2-08deec835938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mTxvuxhm+H6Xdl1EGbuiQ7idSZHatqhXSH1yE1OAxB/W8cd+tB4bn7um5gyiVVvrMnist7Pdpp1JBpFN8FxjcXVQLBZj43mAavt85FKawBy0FwFuqj2vWNVOTvzlhPn3T/Sf/DGXQi/QtrIcPElzHiL9uI6DaLxkquJG/o0Hvgz6wVxNignfoyuoEvBl001XXaOYIaKsxzlL3ZTJRqZap47GZNAa7ao2/MPXTd/c2WyK9Tjjk3I8RpflCYf+ZxfkayUAmgOLs4Zjfb7YHfVhXB1hiMFYqmWU6QtLu0rGM4wxiOFsMa88EVIFsDR4jAGw73qqfYWZ0OaXCoGKeHw15wyilH4D8a64sJCifLcBdoVE+JIUZxA07GRo5bjz9yPD3zT+XnkRpuuk5xFAhtIgcC9xV+LJRVL7UHUsBJSxtSWbLMqtbJn7sqMJGWp2WJ6t1Na9LrTFsft0OQYXjzpyMzYljSxt5t/C7SQuXZtcsPWe0Ph02s/cAKhY/GlEYKFTQ2aIdv8DUdV9U57yzMAJUBmcslrXLJWZSz0ke2+O0CBC35Et/snjePc/qbLoCK/TUsQpjftzjfgRd5WRDmaAx8E7zeSeQ5QPnljeOUuO4a10Hs4Rg++3zXn/4Ybe1ANIwkaNi0a/5tDbWIp+v6y6t2hJ4aCERWw3s3RItCFA6tM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWFIMlhYaTByVWtIUG10SDd2UmlEckxPZzZsN0Q2YjAwVy9kNGhaVlJlcHZL?=
 =?utf-8?B?em9ydGphNklSOHY0OVVYeGZ4RUY4YlpBZVgvMGVzeldvTzNVa1hrN2g2SHMz?=
 =?utf-8?B?RFJzMXVXMU4rclRQQ3k5Ukd6b2YwZSt0Vm53akk0ODZOTW9TaGtsNEIzUmVV?=
 =?utf-8?B?dWFXMkplcW85S2ZhMXcvMk85TDN1bmZtWkp5MXZiaEcrTDNHRUhYVjZUUjhW?=
 =?utf-8?B?UkN3UGU4N2xta05UeFl2SnRmT1dhQWFhWWwxRWJEcFdNejQ5cmtNaUxhZm5V?=
 =?utf-8?B?RzlndXE1dGcrZ284aFFDSy8wSTRVbjNxdTNMSnZiQ0gzL0t6RlJMSEVvV3Fz?=
 =?utf-8?B?ZnVyUHEzdVhKVXVPKzkzQ2o2Q3VVSWhKVGI3M0ptWU1aT3VlNVVHZkFMMHpQ?=
 =?utf-8?B?T2dZcENtTGI3a3AzQmZxbkVZUGNLN1MrWU83dk5aZzFRb2NRUHhTRmhEdTRH?=
 =?utf-8?B?Z09JUnR5M29rYUJMcDNYTkJIVHdGYS9HU0JXcG51eFJ6YmRGaDhuUXNlRzA3?=
 =?utf-8?B?emx1cTZablROcm52dHVlMHJuaXhyTGJEWCtrbkhRQlo0dy9xcWhNVmJUMmFX?=
 =?utf-8?B?aXhlc2pOMlZkK0dPazhVTStKU011eGZRcUZlejJkc2M2WDMvMmwydzRmRi8r?=
 =?utf-8?B?V085OVR0R2VvWksra0FxUnoxLzkzdXdFL0I1VEw5WkpROVZUWk5sYVE5ZGth?=
 =?utf-8?B?MlROb2N2Nnp0VGRlOWNJaFJ6Z05oRkc2MGpad1BtN3FNT0szczRVUVhXdGZD?=
 =?utf-8?B?NW9yWi96UE9TaklKQi9ZM0dxQU1aWGJiamZHMENwVi9razMxL3VLTVhWc0FY?=
 =?utf-8?B?ZEwzUHNPK0dKcEdUNEdxcDVrTE9wNHFqd05aVlcxcitoZWlmNUZIN0g0a3dv?=
 =?utf-8?B?L3lWaUNBRFl2ck9INWZqdjdqcmNFcW1TeWlJTEljQW16dS92S2pUVGgrOXox?=
 =?utf-8?B?VUhmRFRKTTZBZ0RkRnNNMzlkR1IwR09QbWpxbFd3VDRqb0R0aWdWb2h2R2VE?=
 =?utf-8?B?TE0yV09HQ1dUcVpmSzVTYldVNm4xS0hPS25qejBrSGRrWThWU0hJQW93SWVo?=
 =?utf-8?B?SFh4TGpWdUZYSStTRVBqTklKQzM1bkpNWHNLTUVqbXoyVlRFRldDRTJxaFRC?=
 =?utf-8?B?cGVuejJsMzNMY2duMDBLTE90Q25oK1JueDBrOS9remRqbFlycEhUeTM4c0k2?=
 =?utf-8?B?L2REMmtNNUFCNHd5Y3l5MW1rZ0E2NWdWVXhGbks1dCt5d1I5Zk9xVzZmNFdo?=
 =?utf-8?B?WDhFNTVMWTF4VzZNZk16WFlRSjU5eUc5MCtBYkZyUnJ3dFlPZm0vK0l3UjQw?=
 =?utf-8?B?Rkg2Z2dYcDljYUZVMFA3cWtObTZCZkVHVmFUeDZVRVpVUnZYOGRLSUg2SXZD?=
 =?utf-8?B?Slo2Q3Btc2hqYjZDR09RZitaRVhnSWloVWVPaHpEcVMrRlBVUitZVXRzUzZ1?=
 =?utf-8?B?dHVtZzBSM1V3RWpDaFlCeUFCSWxFcHcvRkNsQWJmMXRRb2pUai9HRGg0eUli?=
 =?utf-8?B?V0t0SDlFUDFEa0pKb3FEN1pSSHpwWWRnQnExd2p0WjR5bnZjTU1LS05Rckww?=
 =?utf-8?B?cW0wTDJOMlljWkl5aHhHUVYyK25kZDgxK1RlWTBwSjRzVjI2MnFteWs0aGhI?=
 =?utf-8?B?b21ZejlJNU5QNVMxVVVrTi9sMTVQOUs5RC9DUUZDaEhzdTdEcERLY1oxRzBi?=
 =?utf-8?B?TGdzaVdhSmE4emVPaTFuRnVSN3FtTHBHdEVXUHBockNBUExQcndsbGNoN3Nn?=
 =?utf-8?B?THVnbWdQc0NDWjRZdXB4b1BPTk1Ubk56d3VQdmhORWxOMkowTHVXODJhMW9Z?=
 =?utf-8?B?ZlFueUJUL2phaUkxZFhJbFF1cEYwY2xwT3ovellTaDI5am90THlxaysxTUVq?=
 =?utf-8?B?OGRQVnFkZGZkb1Z5aGJ3Ym1vcVREaEg0d3dYZkVXZkt2K09KcitQWGlDNkhy?=
 =?utf-8?B?d2FsdWgwWHJRMWUyVGZsaFh6R281NFVLQmZrRVl5bzRacisvb2xVa0s3bExI?=
 =?utf-8?B?QXBsMUppdmtSOWFHNkJBQkVQOGJoSTIwTStYMWtYdXdNZWpoeTZ3MytWOFdS?=
 =?utf-8?B?bUNsdmc5bm92WEtib25VTkxiZktHVi9vcXZZcHErSHlsTzBJRlZvVzNteDZE?=
 =?utf-8?B?dEQ2dS9td29QSkh3RmQ0TUxDZGdxU0tMQ01zT2swRWQ3V2YyWU9xaHZGekNI?=
 =?utf-8?B?WlhDRVVqam82MDRDeUgrWExzMStNYk43M0FqTWZEQ0ljTG9OR3Z4Q2NtNU1u?=
 =?utf-8?B?TUlsV294WlhJNHNZcmFZNFowbUplUm4yWWptNXpTS0xwL05uR0MrLzQralFZ?=
 =?utf-8?B?WW5ibFZXNHRjU0M0ejhrRmo2R3BFSDNIdkhMOWxxakdrSWU2dUZqUT09?=
X-Exchange-RoutingPolicyChecked:
	kM2cvGk4dPZUMJ8002TpVEjykphyUBH/zXx2rrlQRRdJ7PSQBAoLV5KwrxHaRw1dvyWZjpC+WbhQ15Vnzs4HmoaJdMP/5dFp0YchSCnWcomStynYUmXi9wS0TeM809Ju05cgzAMMDluwn7JcDmlUO02qHpjP0zN1sbTYMcHa9fHYpApoBANfeKroDf92O2w1TucZYIyGxUIxHH7btj52NlUe4KORtpYXZKN1HTuS19w21+4zIIA8NCQ3b1wgGN4P6U/uV35Kvpa0lBqWgtvF5CYnjgfTf6Me7VoV1G0GaP9Yyq+/d3qHOOTd65J9PtUOcXpqlxmgiwv78YFw/wXYYQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6beaee-4bc9-4b15-b8d2-08deec835938
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 08:36:41.9002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/mHizSMvVb3qLG7ld3LfNZpe1w40q2WDbkkqfjmEc9OYVFblsKnbjpO4ROdvq+zvU48aqMHc9zD3n0U6YWESQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8351
X-Proofpoint-GUID: piuJbqgpemVdcx0AcSIevkbnlpd7C9ve
X-Authority-Analysis: v=2.4 cv=E6z9Y6dl c=1 sm=1 tr=0 ts=6a686a1c cx=c_pps
 a=TuEuCTxUJaX1tclN0RLokw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=dOTxMrXMixf5RNlDy38A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA3MyBTYWx0ZWRfX2SdwKOr9CcEM
 0hevdBGJjbCLCqxqacBEPIhdiS7RQA1utPSM1re7XvNNzjjEXrggsaKzIfMqUa50YvHrOOKwK2p
 IX4tIi8RQJWmshAmLoVGiQwF7MrJWVPx/7/IBx2bbwjS8W60UeGB
X-Proofpoint-ORIG-GUID: piuJbqgpemVdcx0AcSIevkbnlpd7C9ve
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA3MyBTYWx0ZWRfX21WgLOxD8g1p
 h3xMuj3OajnyUqFW9fcdgX7WpYRetCFqAz2TxYNeB46voFcNJAIuZiq5Vua5YlEZxhK56QgLJrE
 gkQ7MMqsiklp1HOOilh9eNw14rZ8z3z7uR+BXFWdTa7goFrg0rovz3ImkkSij+FSZX2aD2V+tN/
 ZuuKiy9NAvoGqflhxgwdP3ofgZDZgnhQx3fr17vygM6ZAh8GG2CkFiuEEsJIGhvumtVcCTDeGH2
 VaqRbAQ0BkB+TqWdK1B9Mo9Tf/55LspFY0wkIh2Gg+1SV2TN0xzWtEVvk6uEda2xWxPaA12nsBz
 fR0oBQkK/vfurh+RvsE3b15qoJvnXPhMj7VoP0xRaYS1+bJK4d7utYHCB32uDJAVI0a2WBEoXqV
 cnho34U1/biqIxk74AvCK4lZZSycAmnZmo4kGmbCuzPAt6dCLYltc2Q84ncTY0PolgJhqUI2lcV
 RZWNRE4XcsrQ7k8TPHQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_02,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280073

On 7/27/2026 9:07 PM, David Howells wrote:
> Fix the handling of folio_queue allocation failure in writeback by adding a
> mempool and passing in gfp_t flags to the rolling buffer functions that
> allocate memory, using the mempool if gfp != GFP_KERNEL.
> 
> This is then extended upwards and the gfp to be used for a request is stored
> in the netfs_io_request struct and is then used for both requests and
> subrequests, eliminating the sleeping loops there.
> 

Have you considered splitting this into multiple patches based on 
different functionalities?

> @@ -200,12 +205,14 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
>          mempool_t *mempool = rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool;
>          struct kmem_cache *cache = mempool->pool_data;
> 
> -       for (;;) {
> -               subreq = mempool_alloc(rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool,
> -                                      GFP_KERNEL);
> -               if (subreq)
> -                       break;
> -               msleep(10);
> +       if (rreq->gfp == GFP_KERNEL) {

Direct equality checks are not reliable; using !(rreq->gfp & GFP_NOFS) 
for the check is more robust.

> +               subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
> +               if (!subreq)
> +                       return ERR_PTR(-ENOMEM);

Since some callers check for success by testing !NULL, we cannot return 
ENOMEM.

221         subreq = netfs_alloc_subrequest(rreq);
222         if (!subreq) {
223             ret = -ENOMEM;
224             break;

> +       } else {
> +               subreq = mempool_alloc(mempool, rreq->gfp);
> +               if (!subreq)
> +                       return NULL;

Redundant check. If it is added to mirror the GFP_KERNEL path above, 
returning the same error code would be better for the caller to handle. 
Or perhaps this is an intentional design?
