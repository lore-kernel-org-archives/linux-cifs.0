Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021090.outbound.protection.outlook.com [52.101.52.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F3733AD9B
	for <linux-cifs@vger.kernel.org>; Sat,  3 Oct 2026 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791038199; cv=fail; b=IbySpQypC7qLkZx/hj2bx27o7VZeccNez652tzWlzBZzUCKiD0fZeBdZcS+36tEz35mQxZ9DnGz/AbdwhGMSnoDAdgXWMSlmf32PZDq0UQOkad4EURWgIYnJYV5fIIqw6VFZGrkEk77StBPszGSCmkvZ9TiZ9kzBb+AMv7azAzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791038199; c=relaxed/simple;
	bh=OcAkqKKW5cKYiDq6pePmtvId8rpeU4i4ki1P4ZqJ8rc=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=V8lG4UfYyFIalctG2SplP8gnhx6wR1eJc/J0IHd+NQW3NYI/1Gu5S5IyabVVhnTk0KbCaOVq51JOikK0CTJpc1rWATRfl27auPiVVp/GmJzxzbEtZS8ScvAuPYmCRs/Lxlyr9USquIALjjVMkGtQFehrVpXHjl5Z7yym5bYB/Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.52.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wX9lddFJr/X3mxbudlw8ml9vYWCcSL6IiFDCD4cHFxs7iAbfHIe2xBYFsncecGJ58Uuw2HuvRTLGT97vQ2Z7fD3nu6HCDKg0qYu7SXCRXUYP72JE5ENoxAhcTG7biFPdHRN6DdZeyfNU6H3llY8lvfFwU28QvyPFBtCEHUo9UwtmO6HDrRiNAJ6UwUYHozJ9nVQ1+ilrExUVdXNRx65ORrAJVo8274jnUry7Os0RBpNUGip3gfB0lo9u5ADKPFtrYvPDeXhBG+WVGeqUO35gZv3LlkXMoC72ZURuqyDBt+22UXs53KryxXeRydy5zIcDKFMQk5zNyik2ln5Dc6oifw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcAkqKKW5cKYiDq6pePmtvId8rpeU4i4ki1P4ZqJ8rc=;
 b=WVu2LRNcpA5oukZqY9DrM9nXaYDxJSRIVSZ2lbGvgoiOC/CR8/v7AvfEI62sZ0LiEeMdhOKkAa300LGagmxoRkl5mJA9NlUrKNmXMgXlnldWvPrIgz0NEH8Jn/Y8Oa51kQTpv2YuIWUWLZOBzeL/t4SPMcOpS1gCEahLKLuKb+bPcRtIHyRjrsmfTyUd8c9NVxNjtk7Nz3bEEFnRYtur1MvZapY59x/knkSmvu4SU5uEC3YnREseFwMnxYMXU2/bY9oID3GjHxl61ZTLt3TloRQPS1PLXRwOmarTUpYsW+qlh1tWHfskIH7Cgpf56ysxBorcGY0a/f9UMXVIx4DHag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 CYYPR01MB8385.prod.exchangelabs.com (2603:10b6:930:bc::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.26; Sat, 3 Oct 2026 14:36:33 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 14:36:31 +0000
Date: Sat, 3 Oct 2026 10:36:22 -0400
From: Tom Talpey <tom@talpey.com>
To: =?UTF-8?B?66CI65Oc7YyA7ZWY6rOg7Iu27Ja07JqU?= <ihopenre@gmail.com>
Cc: linkinjeon@kernel.org, metze@samba.org, linux-cifs@vger.kernel.org
Message-ID: <e9d8518e-d762-444a-8dba-c2deafeaf66e@talpey.com>
In-Reply-To: <CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com>
References: <CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com>
Subject: Re: ksmbd: pre-auth remote DoS via SMB-Direct listener backlog slot
 leak
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <e9d8518e-d762-444a-8dba-c2deafeaf66e@talpey.com>
X-ClientProxiedBy: YQBPR0101CA0298.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::25) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|CYYPR01MB8385:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b0c4d65-3706-4a81-fd74-08df215bb758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|52116014|22082099003|18002099003|38350700014|3023799007|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	xri6pMF+mHGNABEZkViph5YFAgNE4vyGIOMCBWmpqieaxHO/SxCtiBmILRC3QV/PPAuEoKp3l31b0v7S0xVnR+ZrJWQ/7yz5g9OCMUVhQUxh8QMi4D0U8ITP+jVdEN37jnsI46nOWcNohjwIAv9R4LHgQ0TQL/9HBs5GhG9fBwj7GIaGOsVFZ4M/ycfjF6CKtbkyZoMkt5uj9uJIkYkJJqzLDtTZ1n/E0mB1r8Uy4po+igSrHn5Z/o5J69A33PaKhM26Ca3pz+0OwkydlNmSIASSyKNcghJSsxS5ickmwmam2gklOgCu05V1CVd9mJGDeH6xjBhJWuoayBOoQdZ9TUgH//3NRUdZtI7dtmVBG5PEJjEU2yqpd5qQ5wDO3oq73AklsSSs3oRe3phif4xkdLGeYI49lOHpe8y2FATym8nAB/y1Yyi7mHFei/syxJglzYrrb6FVJobox2K5ut46xP5f99PJOjCjgfH3fwyVRzhsn4nGYPG9Ug58rFPd/LWzzEbuw16EAkiOPoF8RXRSazZkIA7IeEir3XO610aOd8EurOy1kJgBmN5hAZEfgdDzJPV/rJBBST7F+POdP1GNSTwZ93C+bss1ALG4rl8dUiRc+PlwEIxiWy+W5Yt5F8lNjgNIjvsMtuWKiuN+Yn+ku30XB2dYBgSv+Hf2axvrYD+q2BUysta0cTkAQmIFog3lPEZo8MRZndQnzyoUUCmoG8vD35FY0N2QTTDCVqhJ4Gs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(52116014)(22082099003)(18002099003)(38350700014)(3023799007)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXFkNWpTc3c4dFh3SExjVXhIS0N3Ly9hVWZrWStONDdxQm5RVVJDV0Q1azJ4?=
 =?utf-8?B?ZW0xMFZRN3dGVVltNk4vcDlkZklkM2VpRnpKb0VsRFUwdENvNEljV3dPVFNv?=
 =?utf-8?B?T1JHai9VS0wrdVgrRGxtREt5cHFvYmt4NG9tQ0FYWEdWdjNkTHRLQWJQZW5a?=
 =?utf-8?B?SitkUDFrRXhzczIyc2tLSWZlMVlLcEJWZk5ONWNOQkFZRTRtMjRCemNDODZG?=
 =?utf-8?B?RzJheW9ZSzVXSEN3aUJBdUZxTlE5aUVuMGE2UFdnaGxCYTRTWWFjVFQ3U2RS?=
 =?utf-8?B?NUJtYXB3SHZzMVF6UDNobFJrakJYL1pham5wSTUwKzVscFpvN1lES0EzamhD?=
 =?utf-8?B?THVFd2xMWUtuT2U1THVjTVFDQ1F5OTNFckhvekthd2hZVXgwU2ZTSExDejM3?=
 =?utf-8?B?UjVEbU8xTVF3emZSc0lpS0tzRGZueUwvNDZoUlZCdmdGaUlmckF5KzNJZVRQ?=
 =?utf-8?B?TUtYOW1xR3hrV3RCSGpyWXF1WW9qQjNkSUNNNXFJaG55YkpsaytCUnV5Ulp6?=
 =?utf-8?B?cE9tbWpBeHNEdjFXK0NXTTJ3aFIrS2hzUTY0bG9nb3RWVi9zbjZvQnMvRmR4?=
 =?utf-8?B?VURWVi9odDNNdDU1SFlMQkpEMEJqdVlTVUUyZU44YkxsbXJoTGxLRHAzcFll?=
 =?utf-8?B?ZlJjejN6VmFaZkp0UkhhbXhjSCtZdnRONkplbjM1MGN0ZUZOanBsUVZiOGxH?=
 =?utf-8?B?Qkovemd2U21ZUXBDaWQ5OEE3Y0c0Z0NOU1h0aVhRaXIzOW4rYVdpb1RjSVlr?=
 =?utf-8?B?ODlTOUxBWElqSEoyVmdPM1g4U2ZSOVZ6Zkx0RDJpbEdvcU0ycmNvUHhNM3Jt?=
 =?utf-8?B?bzZhYndLOHVzWm1WSnJJUnFmMjFybG1ab053VFBoQXBKTXUyZFVZSUVaeTAy?=
 =?utf-8?B?YnBZU2tmc09uN2JzSHViWU1uSFZFeCtUQ1hMTHJlRURvWDBrT0NEbkNiRmp0?=
 =?utf-8?B?a1J3N0p4UWJqbVpyV1czNlR4UXd3WGk2QTRJN3FhRkF1VzBNMlIzS1N1dDF0?=
 =?utf-8?B?NGNjeFpIUExWR00zdUQ2Zllpcjh5MGp2WW90VWY2VElySUk2Y1VvaVEwbnNX?=
 =?utf-8?B?Mk03dHQ4WUhDdFhSYnlHQnlwemNCYjE2WjY2TzJZaVBZK1kvVjFNc0YrVDU1?=
 =?utf-8?B?enFpQmMxcCtlM1N5MnJYaGxjUncyeFhIZjZYUVBOMDlMUWpCOUE5Wk8rZVRm?=
 =?utf-8?B?cDY1Rm5MMnI4bEoxRlMyZ1ArNnNlcUtLMmhMUzdlY1BWT0NBWFpZaWZqYnJU?=
 =?utf-8?B?ejRIWmVBV0tmYlI3OUNNRE96UzRjeHZScmtyTWF6RjlGMENEWUpYbG53NlZ1?=
 =?utf-8?B?akNLK3pYcXZoNUdDZVZOY2NQRTRpcjc4QlNvUXZZck9LMnViVzJYcmhlNVd4?=
 =?utf-8?B?ZHF3SW9nekFDelMxQU8wR0d1RmxoNmczRGxicUIrN1o4L0trdmhkVU45RGFN?=
 =?utf-8?B?eWt2QVZoRHd3cGs3d0tOc0xON21CNklsM1M5YlMrREZ4a3Vud0FvUGUyd0J4?=
 =?utf-8?B?VTc0SjNHY0kwYm9ONUtISmVLSWlFWSt2aXA1Q09uTGJtbmtBTyt2MUVzby9N?=
 =?utf-8?B?RXJzaWhNWTRpa2cxQTdwT3Ivc2dWY3RFOEZ6azBBeURpZHlQWnRuY29JdFp6?=
 =?utf-8?B?WEJoWVBEOUF5UnpMS0NRaXNMb3ltT3lpOGRjQitpdHZ0cXRiMkZOQy82QXBw?=
 =?utf-8?B?akpDNmdZVU40TXFyeGdOUEdCVnp4TFVxVnFYMWo4VlNJWjdUYkxaejh1b0ll?=
 =?utf-8?B?eSt4U29YZ2NHM2dJVGZRRHJ1RHU0b3gzSCs1OEY4c0REMDJrT0tJVEd1a09n?=
 =?utf-8?B?UUpjRFM1N1psNklFbGtNTE1xeEFaTGJCWU1kc2VIamZPajMzOTZuMC9CWUFB?=
 =?utf-8?B?UFlGV2tiOUNOV2lVZElnQVgxelFDSFZzbWREYWZxWUZaUS9NckpOa0xKb3g3?=
 =?utf-8?B?dVovWWwyVmVZeEMyNGF2NTljbjdPd0ZCVm1ydjNLcHJuZTlURmcxY2U4eSsy?=
 =?utf-8?B?TUdvS0c0eGk2dzJxbTFkVCtudDFUaGRSb21PR25ZTmpxVFJMV2hibnRsclpE?=
 =?utf-8?B?TkdUdkFYNVVEVmduRS96d3YrcHY1d2Z6aldkYVNpQzQ3eXZLK3RUcklhQzBP?=
 =?utf-8?B?MzhEQzlDaS9Jc0hMajg2RCtxcjFvMDdOWk83dnhjTGY4R3IyMlMxaEYwRkhn?=
 =?utf-8?B?MzNUay96UWZDa0FOYlh3b1VKejdKVTkrUDlGWFRoVlNqQmFGMksxNDZJZzJx?=
 =?utf-8?B?NGFocFVCNDdxNmRTczdDN0VSUkNmenRyS0JNUkU2NTZGMmI1cmwrTUpoV2lk?=
 =?utf-8?Q?n/7JaR0MVNWr7AEQoJ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0c4d65-3706-4a81-fd74-08df215bb758
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 14:36:31.3118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFCFOEPc/YQITnn1ZM9PYQoJsb9GWClx4ptFin0NK6C2MM7dFlRHtedl6ji3BHVW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR01MB8385

I think we hit this while testing at the IOLab this week. Thanks I'll give =
your fix a try after getting my test machine back together.

Tom.

Oct 2, 2026 9:30:36 PM =EB=A0=88=EB=93=9C=ED=8C=80=ED=95=98=EA=B3=A0=EC=8B=
=B6=EC=96=B4=EC=9A=94 <ihopenre@gmail.com>:

> Hi Namjae,
>=20
> I found a pre-authentication remote denial of service in ksmbd's
> SMB-Direct transport. An unauthenticated peer can permanently stop the
> server from accepting any new RDMA connection using about ten RDMA
> connections, with no valid credentials and without completing the
> SMB-Direct negotiate.
>=20
> This affects deployments that run ksmbd with SMB-Direct over an RDMA
> device (CONFIG_SMB_SERVER_SMBDIRECT). It does not affect the plain TCP
> transport.
>=20
> Summary
>=20
> The SMB-Direct listener keeps accepted connections on a fixed-size
> backlog (listen.pending, limit 10). A connection is removed from that
> backlog only on the success path: promotion to listen.ready after a
> completed negotiate, dequeue by the accept path, or a synchronous
> failure during connect-request setup. A connection that is accepted
> onto the backlog and then disconnects before completing the negotiate
> is never removed from the listener's pending list. The slot is leaked.
> After ten such events the listener rejects every further connection.
>=20
> Root Cause
>=20
> On an incoming RDMA connect request, smbdirect_listen_connect_request()
> (fs/smb/smbdirect/listen.c) checks the backlog, then adds the new child
> socket to lsc->listen.pending and calls
> smbdirect_accept_connect_request(), which does rdma_accept() and arms
> the negotiate timeout.
>=20
> The child is taken off listen.pending in only three places, all on the
> success path:
>=20
> =C2=A0 - smbdirect_accept.c, after a valid negotiate: list_del() from pen=
ding
> =C2=A0=C2=A0=C2=A0 and list_add_tail() to listen.ready.
> =C2=A0 - the accept path: dequeue from listen.ready.
> =C2=A0 - listen.c: synchronous failure of accept_connect_request, before =
the
> =C2=A0=C2=A0=C2=A0 connection is live.
>=20
> If the child is accepted and then torn down before the negotiate
> completes (peer disconnects, or sends a malformed negotiate), the
> cleanup path does not apply. smbdirect_socket_schedule_cleanup() and
> smbdirect_socket_cleanup_work() (fs/smb/smbdirect/socket.c) only walk
> the pending/ready lists of a socket that is itself a listener; they
> never remove a child from its parent listener's pending list. The child
> stays linked in listen.pending, the pending list holds a reference so
> the socket is never released, and the backlog slot is leaked permanently.
>=20
> smbdirect_socket_destroy() has WARN_ONCE(sc->accept.listener), which
> shows the design expects a connection to be delisted before teardown.
> No code path performs that delist for a connection that dies before
> negotiate.
>=20
> Trigger
>=20
> Repeat about eleven times:
>=20
> =C2=A0 1. RDMA connect to the SMB-Direct listener and reach ESTABLISHED.
> =C2=A0 2. Disconnect. Send no SMB-Direct negotiate.
>=20
> Each connection leaks one backlog slot. After the backlog (10) is full,
> smbdirect_listen_connect_request() logs
>=20
> =C2=A0 ksmbd: smb_direct: Backlog[10][10] full pending[11] ready[0]
>=20
> and returns -EBUSY for every new connection, including from legitimate
> clients. The negotiate timeout (SMB_DIRECT_NEGOTIATE_TIMEOUT, 5 seconds)
> does not reclaim the slots. The service stays down until ksmbd restarts.
>=20
> Impact
>=20
> =C2=A0 - Pre-authentication: no credentials, no completed negotiate.
> =C2=A0 - Remote: any peer that can open an RDMA connection to port 445.
> =C2=A0 - Permanent: slots are never reclaimed, so SMB-Direct service is d=
ead
> =C2=A0=C2=A0=C2=A0 until restart. Roughly ten connections are enough.
> =C2=A0 - Availability only. No memory corruption, no information disclosu=
re.
> =C2=A0 - CWE-400 (Uncontrolled Resource Consumption), CWE-404 (Improper
> =C2=A0=C2=A0=C2=A0 Resource Release).
>=20
> CVSS
>=20
> CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H (7.5 High)
>=20
> Affected
>=20
> fs/smb/smbdirect/ (the shared SMB-Direct module). Confirmed on Linux
> v7.3-rc2 (commit df2908090). The backlog handling in listen.c, accept.c
> and socket.c is the same in current mainline.
>=20
> Reproduction
>=20
> Environment: a guest with ksmbd built with CONFIG_SMB_SERVER_SMBDIRECT
> and an RDMA device. Soft-RoCE over loopback is enough:
>=20
> =C2=A0 rdma link add rxe0 type rxe netdev eth0
>=20
> PoC (attached, poc_smbd_dos.c, built with
> gcc -O2 -o poc_smbd_dos poc_smbd_dos.c -lrdmacm -libverbs):
>=20
> =C2=A0 ./poc_smbd_dos <server-ip>
>=20
> Output on the vulnerable server:
>=20
> =C2=A0 [*] baseline: does a legitimate client negotiate?
> =C2=A0=C2=A0=C2=A0 victim: negotiate OK (service alive)
> =C2=A0 [*] opening 12 pre-negotiate connections ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 conn=C2=A0 1..11: ESTABLISHED ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 conn 12: REFUSED (reject status 28) -- bac=
klog already full
> =C2=A0 [*] waiting 10s (> 5s negotiate_timeout) ...
> =C2=A0 [*] legitimate client retry after the flood:
> =C2=A0=C2=A0=C2=A0 victim: connect REFUSED (RDMA_CM reject status 28)
> =C2=A0 [+] DoS CONFIRMED
>=20
> I verified this over Soft-RoCE (rxe) on a loopback setup. I did not test
> it on hardware RoCE or InfiniBand, but the backlog handling is in the
> transport-independent listen/accept/socket code, so I expect the same
> behaviour there.
>=20
> Proposed Fix (attached: fix-smbd-backlog.patch)
>=20
> Reclaim the leaked backlog slots in smbdirect_listen_connect_request(),
> before the backlog check, by removing from the listener's pending and
> ready lists any connection that has already been torn down
> (first_error set), and releasing it. This runs in the listener context,
> so the release is safe there, and it mirrors the delist that the
> success and listener-teardown paths already perform. Doing it on the
> child's own cleanup path is not an option, because that would release
> the socket from inside its own disconnect_work and deadlock on
> disable_work_sync().
>=20
> =C2=A0=C2=A0=C2=A0 struct smbdirect_socket *psc, *tsc;
> =C2=A0=C2=A0=C2=A0 LIST_HEAD(dead);
> =C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0 spin_lock_irqsave(&lsc->listen.lock, flags);
> =C2=A0=C2=A0=C2=A0 list_for_each_entry_safe(psc, tsc, &lsc->listen.ready,=
 accept.list) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (psc->first_error) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_m=
ove_tail(&psc->accept.list, &dead);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 psc->a=
ccept.listener =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0 list_for_each_entry_safe(psc, tsc, &lsc->listen.pendin=
g, accept.list) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (psc->first_error) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_m=
ove_tail(&psc->accept.list, &dead);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 psc->a=
ccept.listener =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&lsc->listen.lock, flags);
> =C2=A0=C2=A0=C2=A0 list_for_each_entry_safe(psc, tsc, &dead, accept.list)=
 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&psc->accept.lis=
t);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 smbdirect_socket_release(psc);
> =C2=A0=C2=A0=C2=A0 }
>=20
> I built this on the KASAN kernel and retested over Soft-RoCE. With the
> fix: the PoC can no longer wedge the listener (30 aborted pre-negotiate
> connections all accepted, a legitimate client still negotiates, no
> "Backlog full"), a normal "mount -o rdma" still works, and 500
> connect/abort cycles leave the service healthy with no KASAN report or
> warning. This is one possible fix; you may prefer a different spot or to
> reap asynchronously rather than in the connect path.
>=20
> Regards,
> ihopenre-eng
> Github: ihopenre-eng
>=20
> ----------------------------------------
> fix-smbd-backlog.patch
>=20
> diff --git a/fs/smb/smbdirect/listen.c b/fs/smb/smbdirect/listen.c
> index 2f78bcaed..3215cd027 100644
> --- a/fs/smb/smbdirect/listen.c
> +++ b/fs/smb/smbdirect/listen.c
> @@ -215,6 +215,8 @@ static int smbdirect_listen_connect_request(struct sm=
bdirect_socket *lsc,
> =C2=A0=C2=A0=C2=A0 size_t psockets;
> =C2=A0=C2=A0=C2=A0 size_t rsockets;
> =C2=A0=C2=A0=C2=A0 int ret;
> +=C2=A0=C2=A0 struct smbdirect_socket *psc, *tsc;
> +=C2=A0=C2=A0 LIST_HEAD(dead);
> =20
> =C2=A0=C2=A0=C2=A0 if (!smbdirect_frwr_is_supported(&new_id->device->attr=
s)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 smbdirect_log_rdma_event(lsc, =
SMBDIRECT_LOG_ERR,
> @@ -251,6 +253,36 @@ static int smbdirect_listen_connect_request(struct s=
mbdirect_socket *lsc,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EPROTONOSUPPORT;
> =C2=A0=C2=A0=C2=A0 }
> =20
> +=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0 * Reclaim backlog slots from connections that were pu=
t on the
> +=C2=A0=C2=A0=C2=A0 * pending or ready list but then died before the uppe=
r layer
> +=C2=A0=C2=A0=C2=A0 * accepted them, e.g. an unauthenticated peer that co=
nnects and
> +=C2=A0=C2=A0=C2=A0 * disconnects before completing the negotiate. Such a=
 connection
> +=C2=A0=C2=A0=C2=A0 * is only removed from the listener lists on the succ=
ess paths
> +=C2=A0=C2=A0=C2=A0 * (promotion to ready, accept dequeue) or on listener=
 teardown, so
> +=C2=A0=C2=A0=C2=A0 * without this its slot would be leaked and the backl=
og would fill
> +=C2=A0=C2=A0=C2=A0 * up permanently. first_error is set once the connect=
ion is torn
> +=C2=A0=C2=A0=C2=A0 * down, so use it to identify the dead ones.
> +=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0 spin_lock_irqsave(&lsc->listen.lock, flags);
> +=C2=A0=C2=A0 list_for_each_entry_safe(psc, tsc, &lsc->listen.ready, acce=
pt.list) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (psc->first_error) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_move_t=
ail(&psc->accept.list, &dead);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 psc->accept=
.listener =3D NULL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> +=C2=A0=C2=A0 }
> +=C2=A0=C2=A0 list_for_each_entry_safe(psc, tsc, &lsc->listen.pending, ac=
cept.list) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (psc->first_error) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_move_t=
ail(&psc->accept.list, &dead);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 psc->accept=
.listener =3D NULL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> +=C2=A0=C2=A0 }
> +=C2=A0=C2=A0 spin_unlock_irqrestore(&lsc->listen.lock, flags);
> +=C2=A0=C2=A0 list_for_each_entry_safe(psc, tsc, &dead, accept.list) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del_init(&psc->accept.list);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 smbdirect_socket_release(psc);
> +=C2=A0=C2=A0 }
> +
> =C2=A0=C2=A0=C2=A0 spin_lock_irqsave(&lsc->listen.lock, flags);
> =C2=A0=C2=A0=C2=A0 psockets =3D list_count_nodes(&lsc->listen.pending);
> =C2=A0=C2=A0=C2=A0 rsockets =3D list_count_nodes(&lsc->listen.ready);
