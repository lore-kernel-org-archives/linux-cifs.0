Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD09C433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 11:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9DBA6143D
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 11:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhD2LrQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 07:47:16 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:44329 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhD2LrQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 29 Apr 2021 07:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619696789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VkuPNi/r1ePywGxhOCGjcH78gu7DKTS2oh8/hkzqlKA=;
        b=JYuTEwMajXF5u5SGGsAlNdnIqOJMszzz5OQp8sev2HV6yBbJIzk2lQCyzCKpxk2YFWxcj/
        RcSHyKx4Jqj+egMFS3hxwfXyZMhZDzBOPYJEMqjarjVKEvEZY8clPp4XMwXI43APSNon0D
        BKnw8uSb6zsVO75JOeYetIZwhT8+Vt8=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2052.outbound.protection.outlook.com [104.47.0.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-6xo1fkn-Pqezlv5NKo-htA-1; Thu, 29 Apr 2021 13:46:27 +0200
X-MC-Unique: 6xo1fkn-Pqezlv5NKo-htA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9bhmYOcgE3qEY4ATfU++vkhgPDdcX9O7Ev4AJIRMgjYfutVVP+PGvRoQFPTaOmWZo7yiP5K8iWu7+PUP07/z0kk+P3WyzX98tR3hHqz+BkrzYtvsMv+HX0hLXZ+FCUGnMSyajyU6lqEuBbdMC9CL2Yk77uxi0NHoZtuq/i2gktEo/6xiThVq8LjFwwziLe4tdIycrer02HmJaxHBz4PEe7CuZIsg31HnV45UDr5CM9xuzuYzwkjOLQXB61p2LkDH7eKRkSzp00j/d+QeNxa9YwfnPZeQX1vTuuvAwy4oXT8VrUjCvelw0G6CcOd+K0FJqSWekag0+78ylasA52Peg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkuPNi/r1ePywGxhOCGjcH78gu7DKTS2oh8/hkzqlKA=;
 b=AmxPqUaNTF49erOQtSLRcIyz6cWjjbjM6yeEJknkUCzRXGWPpp8LsfVb5I3YwWKeu1/DKZ5gT+UcoPEj9KrXmc1XSmiPPGEIVqjWjFolJFFpAA8BrVeOeJ2FD1tB93cV4IAhPy36MkYfQJEvG0TVWZcdMXoj0c4M+8AQJXjFbmfRLkffYYsfnZW3yGP1HTE9vixyMsSjGXUwQOKeHf/G6rWApvC+rm3bJoVPQcWWyNor6FdQukFVQ0M6v2G9cFaLMrgmbmwXdiVAGyKprzBpDLYnYPq+6NNZQFo8yrb/HxmItQAiCowUVVpkfJFhFtf49r6SPyjQW/g4O8f+88xPlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4526.eurprd04.prod.outlook.com (2603:10a6:803:6e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Thu, 29 Apr
 2021 11:46:25 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4065.029; Thu, 29 Apr 2021
 11:46:25 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] cifs: detect dead connections only when echoes are
 enabled.
In-Reply-To: <CANT5p=qykPGoWwtfSdXe9BsXp083M9-7zaAXJgkPok0Onp6Zow@mail.gmail.com>
References: <CANT5p=qykPGoWwtfSdXe9BsXp083M9-7zaAXJgkPok0Onp6Zow@mail.gmail.com>
Date:   Thu, 29 Apr 2021 13:46:22 +0200
Message-ID: <87zgxhuxdd.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3898:6337:f59e:f055:d0d]
X-ClientProxiedBy: ZR0P278CA0154.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::9) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3898:6337:f59e:f055:d0d) by ZR0P278CA0154.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 11:46:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4c163f3-81d4-442d-e663-08d90b046ab3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4526:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4526876B9DC0EF573A6671E7A85F9@VI1PR04MB4526.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRYwiboP/7gUYqlg/HLsxZlQh0eIQDd5xqV7ncqS9cq7BasPqBuHsRy0MbX85SZbBSs5gaQc7Wc2zB1qWQasHArO/AfNayWXkaW6YR9YCYGczMKwdtVAfK8fReGqGmJYn0FoRC+3MYHrItRDtxHLbvSJX5jQumvBJjNDzDVy9+kgqulBEobMwMifWAPk3gLY8nzGYOokKb0OQEsBFnr1J3tq+tK9NObmyXdnyOykzF+QvsqaVWcCz/Ffx2nKC7ZhVQaUyXDwYycO3ZHq4P7KsJo0Kew4E5BghXto+YxVSp3/DZQbZpveSyLH9IZLBfC2gAulFzeCByuS72UlvVrw2c9+54L7gBcFIVaV3mZvkZfhKQYl2d2s9XVc29z9g6jlAcmuwrLbSaGrD3RdVEhsCq/YvWpdcFSg7H5QK8hlm/sr7HDS4/7EcMdbi5yR/0YL98srDqFACZWAV+uuBB5HwlfN6WIM8tDtcH6mv9GKDXrjQQZtu7Z3NxuedR/gVdWt2E8nuGzgGFZqWPSxY3YFR9o9VO5/0Y0GFapAYyyDK3PJB+fLLWV2mJ1Rc7V6hmjxyMnzbFacVd6fywvYidRUaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(396003)(39850400004)(16526019)(186003)(8936002)(86362001)(110136005)(2616005)(66574015)(66556008)(66476007)(52116002)(8676002)(316002)(6496006)(5660300002)(83380400001)(478600001)(66946007)(6486002)(2906002)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHlsRnZIREcySUZFbTZLbUl1OW9ZbGFTZ2J1M0duVXgwdG9LU3RQUmNmU0RQ?=
 =?utf-8?B?U0lsbSsxOU5YSHcydXh6emFvYzhMdC92cFlCZ0JPMjQydi85dEhnRFYrMElB?=
 =?utf-8?B?eDBWQ2tPNFlBUnBmTHVxMXJBZ2NKUkp2UHRxM0dNQTlNYWdOSnhpdHFMelZm?=
 =?utf-8?B?Z1dzblNtV010YnB1Mnk1YUZUdnFqRHljRnlXcENjUUx5NTNiZkRvVmpsZTFV?=
 =?utf-8?B?UnZkOEtRMlRhRGQ0QUV6TlUyV2UxUXk1QkxhcjFWRFptSG51NjdLcXVyQlYr?=
 =?utf-8?B?NUNCOE9tNGxkR3pFYWFvL0pYOUhyYVRLeHhTT0JtYkZYcEVqNXJPZDQ4clRI?=
 =?utf-8?B?aityY3JBMnZudGZCUDRTeldaUkszWXdKZzgvcktHa1N1ZE9NOXpoZTM3V2R6?=
 =?utf-8?B?QklYdTl5dHlrSndSYjRzTlcrSU4rbGFNWXlhZEJFOTV1cVZlNGNLcHNTZWdW?=
 =?utf-8?B?cmRFRVNnTXRmQXl2SjM4b2RpYmVCS2tWRnNwTE1YdHg3RnpDQTdUMFhldDdN?=
 =?utf-8?B?VnlOSzhaNnF1MldHTmpITUx2emsxd1pKdHlnMGVLajhZaEo2YTZiR1Z0QWZR?=
 =?utf-8?B?RnNHZks0LzJIMDljN2FXZnhJMzUrTkwxZWlBMDVoQjJFR3o4N0JzYnhRTTRS?=
 =?utf-8?B?cXcwT25OaGRjNTkxZTVjMXRWaG9YNW9OT0hOUW80dHlvS0FVL2NDdVUrbkVh?=
 =?utf-8?B?cXp5T09BYmNmUkNDRVVuL0F0NUF1WkJBZGd2aWdXQUwyM21vcGMvMHpJWklB?=
 =?utf-8?B?YUpJMjNDRmJjK3FEUzdUY1crMFRmNnFreG0xN25Ma0dxTlovQnZRdnBzZzBt?=
 =?utf-8?B?Y0o4YUJ2d0ZLWk82bjlEOHdKYllTN04vTVdMWU12Z0xYZGxkenptakl2a2k5?=
 =?utf-8?B?Um9FOG12eWZyUVpIZ2NuNmd1TmtsMjJqTFFKQ0owZjI3VU44bWRnOEppYytp?=
 =?utf-8?B?Mm1jVWt1TGt6V3FFeERrbFR5a0VxTkFKbFBSV0U2dkVGN0dudDN5ejI5NGxz?=
 =?utf-8?B?SWxrSXV0UVBzdW5CcnNDWjNES1NOOG1CcXMrQnRTY0IyR2plOWROL2RJMk14?=
 =?utf-8?B?eU55MUdnTlhJTmpYRXpRVkZMbkhTcGRsZTRYZkNrSXpBaEdTdGM0TWVaZnFs?=
 =?utf-8?B?WklBMHlIcVE5M01mM3FLODNiWXRoR1Ywek0vMUVST3d3RWs5dUxncVpQdTBh?=
 =?utf-8?B?c0NQeTNUZysxSjE4eDI3VXdDaXNrQm5iemovSnE1d0pRU2ZtNG1SYkUwMWp6?=
 =?utf-8?B?aDBITll5c1lUOXZQZ1h6ODB5UEZQY1ZEVUpaN2l4ejRDWHhvelJPRTdnYVAv?=
 =?utf-8?B?dDc3VmloQkRjdVdpQ3g2YmpRSG90R2RlNi9uT2l4S013RlhQVnhiQ3NSbVFZ?=
 =?utf-8?B?aStWN2dFRWZGQmZGOUNPaytMK3BzTkh3UUpTRVFUakxVSS9wV0lxeExZRlQw?=
 =?utf-8?B?dVdGV3BWai92enRjMVlpTkxHTFRHTG5GTHgra3ZxbWVvZWpwNU8yTW90R1l4?=
 =?utf-8?B?eHZaWHFCVWFlemtFNElkaU1TbWsyOVFLTU5SaUcvMHR1cUNDbThzWWl1ZGhN?=
 =?utf-8?B?Q3lFYUpxUmFVZ1Vxd1lYem1XTyttU3lHUzNjTGVERzFQRWhMRzJLQzhJQTdN?=
 =?utf-8?B?dERNNkd4RFBhNzN5bnYzOWc0bU9aeWtuUWM5c25vY1ZENElNSng5TW5Xei9S?=
 =?utf-8?B?dkVDRU82aDRQTDZZYzlVTUNIVFdoS043SGg5dUJvMkVxa3NDeStKMXhVYm9J?=
 =?utf-8?B?SkU0WStQbFI5Rjl5RHh1aXU4RnFTYTdnVE5KSW4vQU8wK3V0czl3bjVhYjk3?=
 =?utf-8?B?eWxLS3V4T0s5QnBqZEwramNNVW94K2NsdUZUTUVmNEVHSTFydzYwMjdldzNG?=
 =?utf-8?Q?3nkgWQ08uSgZy?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c163f3-81d4-442d-e663-08d90b046ab3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 11:46:24.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+CFpt1BJimDl//PNHFTZnoritjoD879xV4parZND8Bdq+Rb7A0vbQW5B3KYHGl/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4526
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Shyam,

Ok so I ended up looking at a lot of code to check this... And I'm still
unsure.

First, it looks like server->echoes is only used for smb2 and there is
a generic server->ops->can_echo() you can use that just returns
server->echoes it for smb2.

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Hi,
>
> Recently, some xfstests and later some manual testing on multi-channel
> revealed that we detect unresponsive servers on some of the channels
> to the same server.
>
> The issue is seen when a channel is setup and sits idle without any
> traffic. Generally, we enable echoes and oplocks on a channel during
> the first request, based on the number of credits available on the
> channel. So on idle channels, we trip in our logic to check server
> unresponsiveness.

That makes sense but while looking at the code I see we always queue
echo request in cifs_get_tcp_session(), which is called when adding a
channel.

cifs_ses_add_channel() {
	ctx.echo_interval =3D ses->server->echo_interval / HZ;

	chan->server =3D cifs_get_tcp_session(&ctx);

	rc =3D cifs_negotiate_protocol(xid, ses) {
		server->tcpStatus =3D CifsGood;
	}

	rc =3D cifs_setup_session(xid, ses, cifs_sb->local_nls);
}

cifs_get_tcp_session() {

	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);

	tcp_ses->tcpStatus =3D CifsNeedNegotiate;

	tcp_ses->lstrp =3D jiffies;

	if (ctx->echo_interval >=3D SMB_ECHO_INTERVAL_MIN &&
		ctx->echo_interval <=3D SMB_ECHO_INTERVAL_MAX)
		tcp_ses->echo_interval =3D ctx->echo_interval * HZ;
	else
		tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DEFAULT * HZ;

	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
}

cifs_echo_request() {

	if (server->tcpStatus =3D=3D CifsNeedNegotiate)
		echo_interval =3D 0; <=3D=3D=3D branch taken
	else
		echo_interval =3D server->echo_interval;

	if (server->tcpStatus not in {NeedReconnect, Exiting, New}
	   && server->can_echo()
	   && jiffies > server->lstrp + echo_interval - HZ)
	{
		server->echo();
	}

	queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
        =3D=3D=3D> echo_interval =3D 0 so calls itself immediatly
}

SMB2_echo() {
	if (server->tcpStatus =3D=3D CifsNeedNegotiate) {
		/* No need to send echo on newly established connections */
		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
                =3D=3D=3D=3D> calls smb2_reconnect_server() immediatly if N=
eedNego
		return rc;
	}

}

smb2_reconnect_server() {
	// channel has no TCONs so it does essentially nothing
}

server_unresponsive() {
	if (server->tcpStatus in {Good, NeedNegotiate}
           && jiffies > server->lstrp + 3 * server->echo_interval)
        {
		cifs_server_dbg(VFS, "has not responded in %lu seconds. Reconnecting...\n=
",
			 (3 * server->echo_interval) / HZ);
		cifs_reconnect(server);
		return true;
	}
        return false;
}

So it looks to me that cifs_get_tcp_session() starts the
cifs_echo_request() work, which calls itself with no delay in an
infinite loop doing nothing (that's probably bad...) until session_setup
succeeds, after which the delay between the self-call is set.

During session_setup():

* last response time (lstrp) gets updated

* sending/recv requests should interact with the server
  credits and call change_conf(), which should enable server->echoes
  =3D=3D> is that part not working?

Once enabled, the echo_request workq will finally send the echo on the
wire, which should -/+ 1 credit and update lstrp.

> Attached a one-line fix for this. Have tested it in my environment.
> Another approach to fix this could be to enable echoes during
> initialization of a server struct. Or soon after the session setup.
> But I felt that this approach is better. Let me know if you feel
> otherwise.

I think the idea of your change is ok but there's probably also an issue
in crediting in session_setup()/change_conf() if echoes is not enabled
at this point no?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

