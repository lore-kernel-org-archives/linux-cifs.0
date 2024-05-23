Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2135.outbound.protection.outlook.com [40.107.243.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76E414F104
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474547; cv=fail; b=VdQZjRt6Tgp5PJw5sWJaRVVMQ73LkC2Rcrvn2cFZsUcQ968dBc7jPZ4Ku7sqDIKLxjn6KxI9/hWFWZ+gH+ugEWwPuCcqQVydaz3jWu/dIXFOibuQYuTuO3vkY5B0GBQYDnwm6TW62nhxAYNo3LfEkHV7d5RYYXo1Hi1/boc6prs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474547; c=relaxed/simple;
	bh=lSFBhIHBywKHbu3HPD9XAAnoCLBuDj2j7WigpWysBOI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tMxhKyccOb5iqPLP5r9heGKYvGQ7k8j5qZecqhvESXXDujVwe+AG7xJfetOQE2OmL2XqckyDk27n7Hm+cwFhUVyYfInGblvxRIj05Zc+PTV95dEEJ+ow3ch0gh9ZE9Vo0dase0S1XiLvBvrXfGKqJwltC7BzSk5r0lAMAZEaOb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.243.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lO4iBJyf0+KdPcjmOiyQoSmH95rql+B81j6Sp6XdCaZWJAZx3dM6PwPoJ5Csju+q7aSBaVX3ol23HJrJnANLsQ42ngJkEzNDvI3mCtb4F9r7fmcs9Zd63G54y5UgPoSKSlzJw353WWYCxFFEXrDZk5y5qZscpNGKiPyRJ/FATqg1RapFnCkKJYa9YFuXPWF3A3uhPcffgcOi4UxVa4K3oKvKx+7X6TMKMMK296Lpkkna9nh6LK0ti/T6LRd35Wu49V2oIH+s4DBmIAUPQJJGU3Qc614PrwWuwPENirSB8TjBfxYCOz54GTQRDsfH4lHiZaWL1ipyvgyLX7tQnTNurA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnFV0fUxPcThohWfrBYy/o1/a6A0Bv7N+URcNDjmFFo=;
 b=H5cfqlf336eI2xc5hy+z7C7lyenwdADh6aHnaMUZLkqED7bV2cYl3HnS1goN5awx9QdFIhNvy44dbrpvHSn6NE1TtXlVOcFpZ5fmCLucnBMD24AKIuT1AVSOM1GgFsX/9Uj1yTzWldl0w0MpzZaBgahGfH6l31oo5petvi+6mwUr8MPfiZgGRZpB+gE1bw17FPbfzxqYlX5k4yYShEX7ITHXcefRRzMtqmjzqLKgpK5v5sFDQEAzHb+Fx5GaVg4bmwFUkRyxyCsMWvXRnrJsbfkE0NMLwHcfWgXQzxY5UEDNp4PoYFxUsRTr2eTOkpT6OzXsUR0AUEzxzcO1l+JxwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 DM8PR01MB7013.prod.exchangelabs.com (2603:10b6:8:16::24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.19; Thu, 23 May 2024 14:29:02 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%4]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 14:29:02 +0000
Message-ID: <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
Date: Thu, 23 May 2024 10:29:00 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
To: David Howells <dhowells@redhat.com>,
 ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: David Disseldorp <ddiss@samba.org>,
 David Howells via samba-technical <samba-technical@lists.samba.org>,
 Steve French <sfrench@samba.org>, Jeremy Allison <jra@samba.org>,
 linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
References: <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
 <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk>
 <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna>
 <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
 <476489.1716445261@warthog.procyon.org.uk>
 <477167.1716446208@warthog.procyon.org.uk>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <477167.1716446208@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0050.namprd20.prod.outlook.com
 (2603:10b6:208:235::19) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|DM8PR01MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: 96e8f8fb-1fe7-4fd7-9f08-08dc7b34b114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ME9VREVjTlRpVkxyVCtqNDk0MEtmZnBPOGwrcldHR2xkamZyZXpsdUJNL1N2?=
 =?utf-8?B?bGw1SkxIUnY3WWdTMTYzajRRajRaOXordkJhQzlzUGI4bmtXamdBSHZ1YmNL?=
 =?utf-8?B?VE1Ga1g5TStXNzNuWTdQQURyQmM4RWRtS2dJdEtxdk15ZVg3MXAyd2tjRDFs?=
 =?utf-8?B?UTlzbGdqWU54WjVEUG40b3I0WHg4dmNvdkNYZSt6Z3M3bFkrL01oR2l6WWNX?=
 =?utf-8?B?MHBSSE5BWDhxa09qOHpJbmIrUmVjZEZudWNiTk9Nc1JuRkNuK3hUL2pGR2Vp?=
 =?utf-8?B?OXhRTVVxWk1HT3pzZW14MWVVRnBWQ0ZwdkUyb1lacFNkWTdSSjQ4QkdkTFQv?=
 =?utf-8?B?Wk9BYzBSSXMrUTJNWlpaYWtnVkU3emxmdzZTaHIrNXJ5bmVQK2FvM3RJVFVX?=
 =?utf-8?B?TWcwMXFQem5zcCtwcXZObzltSGMxN004aDg5RW1QZU03cDJKZnZOWGJWZUdR?=
 =?utf-8?B?OGhEdVd4M2VQRUFmM2tMTTdEdVNOc01QWWhLVnc0Y3IwOFM3eHVhQ0NOdmRk?=
 =?utf-8?B?NWZ6WWk2aEFIaEZBSUJTVWxHSUllbjU5dXI5elNYZUN3N0cveVFKdnBrUVY0?=
 =?utf-8?B?V2RDSmVBZHFNSENKTFBpT3BLNXdSTnVLTTEyR3lTZkRPd0VvZmNJZ09jYllx?=
 =?utf-8?B?Vi9wVGJBRDN1Z2JJV1RoUTI5eVF1R0diK2VTTG40Vm1zMSt6VFE0ZFU4ZjZQ?=
 =?utf-8?B?dnZmdFZyeG0xQVJZMTU5QmNLU0psY0JvZXZSR3FzbHVrV0prNjNuUHRqZ0hS?=
 =?utf-8?B?VFAwRnV4ZHMvaktoeEhSeVgxTkJWbHEvWm1xUE4yY0xoSHhFTUxFeDdheGI3?=
 =?utf-8?B?SU9POWdnQ1ROZWpoaXdZV2FNTkhVVFRHTmdjMGdqTlNqNWdrUFJIdHBONXhE?=
 =?utf-8?B?c3kra0lESTlVTEh3N1ZjYlZsSWNuNUxDcU16KzlRUUtXQWMvdnpjK2lGVmo4?=
 =?utf-8?B?ZTE5a21vYnJIek4zVU5JeHg5UDRqTkNrNGZRTFEwV09xcVNjTWY2M1VQNGt6?=
 =?utf-8?B?MnRacyt6b3BYM24rb1BPa3A3eGxiWmg2cU96Ujk3eWcvM1ArdGtWb0JJcGZx?=
 =?utf-8?B?TjZHdW1PYjBsNGRIeDYrMm5UQlNhc1B2cTVSdFk5VkhYUVloY1FjVFYzR1lD?=
 =?utf-8?B?a25iY0dOcTY1UkUwTDlrdUl1S3V1dk4yL0h6MmpSWTNSWmJLbllhVmNvakpL?=
 =?utf-8?B?TllQYkJpb0pQNkF4N0ljZmZFSmRFYU5sNTdMYUtTOUtjMHM2ZjJWUEhXODRy?=
 =?utf-8?B?cFZGY1pONnkwcDBYVDdLaDJWZkZYUzJkYlQxZEhxWW1Ec0pQekh5WHBNekd3?=
 =?utf-8?B?TmhkRlJFeStKaFNhMU1ZaWpZSThHY29lRFZ0K2U1MUdQWU8ybEpHZ2x3RlVG?=
 =?utf-8?B?eUZ4SXVQampDa3JGMEV4UUNvWFp5ZEtheS83MXpqd3ZFN2pZMVlBMTNMTDI3?=
 =?utf-8?B?ME43c3J5dDNwNU9ScFZ1cEhjVXBJeGxGcHcwZG05WXlhMUxqVXVwSnNFc29K?=
 =?utf-8?B?V3RyN3AwL2xuYWJYUituZ0QxdVo2eFNQaEIzM0hBUldSZGF6SllYazJJcUxK?=
 =?utf-8?B?VGx0eXZEWmtpS1cvRkg2UTFsalBRcVNqeHkxcS8xb2dGc3dGT0xJcVFZYUxn?=
 =?utf-8?B?MUFUakVvU0crM2JXMzlSNDFtVnNBS1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkdtUDdLbDdyUmlZTWMweHJ2Ylg1N0NDR085UW9YR1VxTXREcXdhMUZxWEhG?=
 =?utf-8?B?aXh3YWhoNGowaklvQ1hmQlpLQ09oUnBZWjBjL2hvcEVsVnRuYk1WUHBNTUd0?=
 =?utf-8?B?OUNmUTEvVHhCUXdaUEh0L2JjYzNjNm5oN1dBUDVxVVdnaCtmekxMSmVvN0ZT?=
 =?utf-8?B?Qndsb1VZZTZJT0M5RDZJcHJZc0QxSDh4MElZall2UGlrYXJPMkdvQjF3NVJl?=
 =?utf-8?B?ZjF6K21HaU9oRjFON3BYV1FWQjByMWZNSXhZRVhvdVJiSmw4LzJjeDNBMDlj?=
 =?utf-8?B?LzFUUUIwQThJTnpiUkNkUDB5S1JudU5XbHlyYzJLWHRKUXNnNnUyTXpRQkVY?=
 =?utf-8?B?NW1CWEFtNm5iS3B2b1JORUp5eTlXQlA0djJtV21qalVORGFJTjB6cWljT0xG?=
 =?utf-8?B?aUx3YjAydlU4cGY2ZGNqVEtMMHR6SkJtUU1FWkZyanRZdHZpVGxGbmpUNHh6?=
 =?utf-8?B?TGxPNEdxaGdMZjh2NjNoYzB1cGRBVFdzczV0QmN1RkhaRTkrczlPNlA2SUZv?=
 =?utf-8?B?M1RoZzNIRjBFc2l6U3ZUV2VLMTJBNUhTcU82eWg1Zk1BdmN6ODVLZnRkVytE?=
 =?utf-8?B?Q0lLVHpXa0NQN3FGYWFJWGpDaVlsS0o5SFJHb2huZTZrTWs5ZGlsMG5hZXd2?=
 =?utf-8?B?K0RtQ3hxcEZjUG1qKzJGbGxzR1AwZ29PdzJ1ellMNnA1VzJyVDIxWHNRREVK?=
 =?utf-8?B?Y2RObnZxTU9VbExxOWxjeERDNmgzc0I3eW8yVmFVNVQ4OW9BalZ3Yk9sSlJ4?=
 =?utf-8?B?U0RuOU91MzBjME55TW5UNzlSNkNqc0pWMDg4cjhDY1YvYUhoWG1OOTlld3ZZ?=
 =?utf-8?B?R0NwTWVrWWJBSDJNV21xekVzNmdvQXZLWnJEbTJyOVJ3QkR5Vnd0L2ZTVzRS?=
 =?utf-8?B?NTQ5ckZOcHpNTHdheVZ4b3FvZFZxS3JYalljaFFoQy9aeTU3OC9tUTE5elBO?=
 =?utf-8?B?QTE2UmFRbW9Vb1JOQ3BGSkNjNXhGbWMxS3R6bjNOSkFKYzJ1aXowa1RxYThq?=
 =?utf-8?B?VlhUUmIwUVN6bDU0MldFcVQ1SFFuL1lDUmZyRFlrS09kQ2V4bEc1b0ZUNXkv?=
 =?utf-8?B?VXB0S1ovSzJIYlJwUlNkQmFYbDR6Q3FqeWc4OFlUNnVJSjJZbUwwMzZOdXpr?=
 =?utf-8?B?TzBvdThrclNwK0NDeUo0S01mOFF6NURpWHdudlZnKzdPRmtTcHhlMm5VSHVt?=
 =?utf-8?B?RlpITHVSTmNQUXpTeFM5eFBjcWkxRlhRUHM0VmxQcGtCYU1ZclU0VVV2clo3?=
 =?utf-8?B?VFdVcTQ1dDFuanZ0alNLTkI1L2FNQk1yT25oZ0tLa0ZNaG42OUZmSUFXU2N4?=
 =?utf-8?B?Yys5RUpHWUlDTmI5QWE5bWRmZFJqRlBxK3RnMFRTVnJZbWszaitraVJZUXVt?=
 =?utf-8?B?RElYVUFXOVN0bHhIYzNLZE9BZ01uMHA5SmM0VGYzTE9hWTZoZ2lMZ3c1OVRq?=
 =?utf-8?B?Y0VZTk1pV1h4Mjg4VndHbmFzUzBEZThKQ25NWjVLcC9RVFIvck5rMkR5cnd3?=
 =?utf-8?B?ZE11NEJjUzZDNWk1NHVGVUhHWVowc1k0RENONFc0MzVPVGIyajBBb2NxWFlX?=
 =?utf-8?B?U0luTUYySU1nYWQ0VmtGN01aeVJWY2FtVk5mTE9id1pVeUY2WjA5S1QyRm1B?=
 =?utf-8?B?eGR6Szhza2l6UEVEQmZnVTltVlVmU0wvVUVXSzV6UktIS1c0NXZ3ZTNzZE9t?=
 =?utf-8?B?ZTJDU1hRdzMvem1Db1BNK1A0VUNQK2YxNCtpQTBuaHpJTGgxc2Q0OXlRRENL?=
 =?utf-8?B?MTZmY0FPQ3dEdENGeTdRbWVHNTZoajAxQ0wrbGxIVU55VmJhUTZuaFNzSVV0?=
 =?utf-8?B?NGhZaHk4MkhObi9xYnYrUk4xS0pHOERKZ0QxYUF1Q1hDS3h3MFhZYWwvc2xo?=
 =?utf-8?B?a3JqeEY5Rnh3ZFNoOE85YnlKdDROVlpGR0c0U2JpdGpNZ0YzdlUyMlM1YzIv?=
 =?utf-8?B?aGRxTzNOOHN0T1BvU1A1Ni9NOTB4SkpzNkw3TExQL3lsQ2dkNk1OVG9LZjZu?=
 =?utf-8?B?MVc5MmhxY0RJWjBqT1laSGtraUZyZDh5eXA2d3pSYXJxRTV4TVBWb3BaYS9C?=
 =?utf-8?B?bkpRK0UrOXBzcXFhNkRSLzZBQ1JVNDQ1OXBXZVR4dWdKMXVYQnNablBJcUVO?=
 =?utf-8?Q?91q24Bj28tBxgn8g21wNFwNSg?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e8f8fb-1fe7-4fd7-9f08-08dc7b34b114
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 14:29:02.0289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSXlsMRFkjaSXLGhRxWgOr88kVJ2DM7TiuSBrffW8864VqdhBD5ojBhLyC868z9V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7013

On 5/23/2024 2:36 AM, David Howells wrote:
> ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> 
>>> The problem is that it essentially renders SEEK_DATA/SEEK_HOLE unusable for
>>> applications on cifs.  If there's more than one extent above the starting
>>> position, they'll fail with EIO.  The only way to do it is to provide for a
>>> sufficiently large buffer to accommodate however many extents that there are
>>> (and there could be millions, in theory) in order to get just the first one.
>>
>> Wait, I didn't read all the text in the initial posts correctly.
>> Do you mean if you ask for "max x bytes of response, enough for n
>> entries" then if there
>> are > n entries on the server you get nothing back?
>>
>> I am pretty sure Windows will return as many entries as fits in the
>> reponse out-data-size
>> nad some error code.
>> But you are saying that instead of returning a truncated out-blob that > If OutputBufferSize < ((OutputBufferIndex + 1) * 
sizeof(FILE_ALLOCATED_RANGE_BUFFER)) then:
> 
>     Set Status to STATUS_BUFFER_OVERFLOW.

>> samba will return nothing?
> 
> It returns a STATUS_BUFFER_TOO_SMALL error if there's more than one extent
> record to return.

Yeah, I think this is a Samba server issue. Ronnie is right that it
should return a partial response and a STATUS_BUFFER_OVERFLOW error
indicating that it's partial. It's not supposed to return
STATUS_BUFFER_TOO_SMALL unless the entire buffer is less than one
entry.

MS-FSA section 2.5.10.22

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/385dec98-90fe-477f-9789-20a47a7b8467

Tom.
