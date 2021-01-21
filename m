Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38848C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 10:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B29239E4
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 10:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbhAUKN6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jan 2021 05:13:58 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:35421 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729040AbhAUKMm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 21 Jan 2021 05:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611223892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6JWVnXpESjeRKvkI7N26UO7PGKTxoqSzJDBYo6je1rU=;
        b=AXGdualwMqEXOBEQoan5/w9GlZAgF1lCvzJWWws9rDxC5mwxcsmCswlUdfVJvbNNxDx7Y4
        fk3kxARJaI7/IK3OIZHML/0wz0f7Af0RjWneY5Kwg5CM458rHA/unsahqMCod5pPb6sa1O
        L3oLgmHexgFarmIMPk0ISDEVA9pm+68=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-zAW8qXLhN9yzYY4qSoqbZQ-1; Thu, 21 Jan 2021 11:11:31 +0100
X-MC-Unique: zAW8qXLhN9yzYY4qSoqbZQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auMXw/dXq+ltu6A8g2qvT1tr3VQJprTWvABSMONMrqFqKfrMBAuz9qbWvWTv9kCmmYP9SgCA636fUGLLvH8+mETCDSTzZ6n7/BLUh3ZYFDWghhCHuTCn61GVJAPlFKqi+I4SQYuJGM38hvrcd+IGuV126r43/eKfQCJ/obHOdYEdDK0kICbOo96sZ30GPbq3U6IiQkrasGBszVK9UA0HIs0l3O6hhY6EgwAop+RuBXa+pk+ZB0RXpZnQBaPrGgxlZ69CZNZArOCppghpRanOxKp1RfIwq1q9uatK6I1fcNCqhc8rue+SOYJfiTsnJeWqzgeiIO8T3niKHGA6dE6TXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JWVnXpESjeRKvkI7N26UO7PGKTxoqSzJDBYo6je1rU=;
 b=Vy6yb6L+2FP4XXaJHqe4ZEgUSsN/QtrM9JlfECxOTPX0YOSq/9UcfhQkBO8wSMF/nI+DiCe4QXTHiEaIGiC8M7bn0+rEvTEPaUN371jgz/njzRLeB0x2uKHETYYyKS91gpG8aKuY8TD6qUu/8rNwZXBy3GObvm0xSc6BjZvLfv8YRDSfjASeeU+yT55mMMbNT/EJG1ng/sQvFD0OI08tyb2HsHn0QtYUcVvUvRtJbeDSFq1FyeGZTDBRqU9GLG38MUWjapPDPZWb2hMIAT+H7bCdudc+uG+LLA3NphvE2L7ug6H15b+Wy+1RAe/vIOBG2rGrCMcNQ+/4/aeJm+3cJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6912.eurprd04.prod.outlook.com (2603:10a6:803:134::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 10:11:29 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3763.013; Thu, 21 Jan 2021
 10:11:29 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
In-Reply-To: <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
References: <20210120043209.27786-1-lsahlber@redhat.com>
 <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
Date:   Thu, 21 Jan 2021 11:11:26 +0100
Message-ID: <87y2gmk3ap.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f47:f45f:bc81:70ef:c11b]
X-ClientProxiedBy: ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::6) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f47:f45f:bc81:70ef:c11b) by ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 10:11:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d48b9808-9dc1-45be-35ec-08d8bdf4eb85
X-MS-TrafficTypeDiagnostic: VI1PR04MB6912:
X-Microsoft-Antispam-PRVS: <VI1PR04MB691226122D374E9D983B66D0A8A10@VI1PR04MB6912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtouG/NJmp7H1AFYRmtMPtDq1d0aqpvS8gKLNal/6JHZ5m86Nftc+w27f/maSgOdvSu4Sa8NfXK9JL2PGcz6aa4eWvHEm9c1i2ug0IwZw8x5Iy3s5KFuA6vXP7W7RTTN54r9lUXBsd0iL4hPCaQJYzHBJ7YqBr4K+hXIkoU7LOY2rrFQAiRg9HoPgwdVJwpkbhylBSVCTChDeAf74P0lzTTxsxa8BR4+pipIJI0lo6RiVEZPZHSdiwx1RhlIRltuDDzMz1v481kllj/+qLO+gAOI9fHp8UOGmx4PtPtkIzHHswoKcavxuocJbRsnPF0FYeTtwSvtiUevGKai/KVzBCrZEGy5n1ARNIMtSCBNvFySC/1YKI3wSafWs7nNxa+kqi8SGVmrOK5TmPKwgs9ULQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(66574015)(6486002)(2906002)(66946007)(86362001)(66556008)(66476007)(5660300002)(8936002)(83380400001)(316002)(4326008)(6666004)(478600001)(6496006)(2616005)(52116002)(45080400002)(8676002)(110136005)(53546011)(36756003)(186003)(16526019)(54906003)(4001150100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1dNTTByTHEydWM5dWY1dytIRkxHY0NIbk1KZ25Tb0lzeWd2Q2s1YytaR2JD?=
 =?utf-8?B?SU9VRE1FUWRSZnNCQjdnamlESmsvM0IwZ0d3N1hiT2dZRk9TYm83SWxEQ0dJ?=
 =?utf-8?B?U1QxRzhQR29PMjdhcEpPelJJTXFCejRVYzVqQ1E0dGJKUHMxaDFrVi9mbHVU?=
 =?utf-8?B?Q2pyOFpRK3p2ZndVaStXYjJNNDBtNFFJVDE2ZWwvVVE2d2p2Q1o4bkdkOXkz?=
 =?utf-8?B?NXhNYTVtNGsveGFzRGFSSmw5ZkUrd0M2QTFkN0Nob09tekMxRTBJUjJuWDcy?=
 =?utf-8?B?dnBJbkJNM3hZb0hXVCtZSkpMRzl5dkdjRm5qZmg0VVZRSzdOQURFRStERFR1?=
 =?utf-8?B?Z2hUUGpWZVFFaGl6eUNYRzZHWVRES1ovcnVWOGVJOE42M2JhYVRkVjN3cW9t?=
 =?utf-8?B?UlhxSkxyb1hFU3lCaHh3YXg4dE9rR0hyRGJxeVV5WWVqd0xwWUkrQnUyRm1j?=
 =?utf-8?B?Wjg0anBSUWFQaHRqSmFrQllpWmpZb0FDZ282WXozdTVNYmpkWUJZZEhpWGov?=
 =?utf-8?B?L2lvNWdJZmtJRktESVJTRkxWVy9WRndVaVpYU1I2TS9uZVZEQnpzeFRmVWts?=
 =?utf-8?B?WnAyQ2R0S3prK05kVWk1Rm1haVNEa3I2M1hFWThUdWE2SGpSaGptNHcyWnhF?=
 =?utf-8?B?dXJvYjRBVXRxVEloK2lnS1RnQ1BMOGs2MTBRVVZRZEJnWUlYSjdiQk1IbGp0?=
 =?utf-8?B?V3RzZ1Y5Ykw3d051VTRDelhNOWZ0SzFvaWFtbnB3NDkvZ3NlMHR1OUdOVy9o?=
 =?utf-8?B?Q2dpbDRIT3lRU25hcDZQWUMzbTdsSklsREc4OElBYUNwN2EySnRmTkpFNnho?=
 =?utf-8?B?UnBPL1Jad0VlWkZuRVp0REFQSGc2Q0xmT3J4Z2NUd3M3VnNEYlpweEVDdlE2?=
 =?utf-8?B?amNPbDlBcFd0MVdIdFhrSXJsWFhHN2ZkcWJrZFZaL0o1MmoxZG95TWtNT1o0?=
 =?utf-8?B?VFBzcDd6MzlZeFNsTWJvQmxxaEJnUlhYeFROMTJhNGJPTDNpc2h2SUNCYTNO?=
 =?utf-8?B?ZDlQOHhuQyt5ajYyVnB4RStlei9sczBsTVhzSllYN0JNMHdHSzFtR2FZNE9Z?=
 =?utf-8?B?bmJWV1kzY3JKY2pmYXlLZnFyWURyb2d3ekFGeG1rYml5OUUxVXdEdnhpSnlL?=
 =?utf-8?B?S2dLMmJ6Qmtiak5lZW9SMEdFNGpvZko3Y0lBeGJndmh2WlJ2Ym1KQXlpcVJw?=
 =?utf-8?B?eXFhaHdxMzYwS0EzMEszcDFnUlpQd2hSWm8wdEVZTnpvOFhyT0tUOEZGbnRY?=
 =?utf-8?B?N0RGdjBwejBJRUt0WU00SGc0VGRuNi9TQXN1ak12Y2FEMVJKaUlaVTVsVFdo?=
 =?utf-8?B?MlYyay9LUkRZemRWQVgrRXRyNFdIeWsrdDAvcVQzV2pWQ2txLytzYnB2TGpn?=
 =?utf-8?Q?oJlcTAzB0TZZEq1yiudmSMG0QG6Z2So0=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d48b9808-9dc1-45be-35ec-08d8bdf4eb85
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 10:11:29.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Mw+UWQpZWm/4zFJIz7Txc/CB5Nv1Bpz55kcsp8ZTLXXCUp2pXjJNhqswyR2m+QU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6912
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel Shilovsky <piastryyy@gmail.com> writes:

> =D0=B2=D1=82, 19 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 22:38, Steve Fre=
nch <smfrench@gmail.com>:
>>
>> The patch won't merge (also has some text corruptions in it).  This
>> line of code is different due to commit 6988a619f5b79
>>
>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
>>  cifs_dbg(FYI, "signal pending before send request\n");
>> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
>>  return -ERESTARTSYS;
>>
>>         if (signal_pending(current)) {
>>                 cifs_dbg(FYI, "signal pending before send request\n");
>>                 return -ERESTARTSYS;
>>         }
>>
>> See:
>>
>> Author: Paulo Alcantara <pc@cjr.nz>
>> Date:   Sat Nov 28 15:57:06 2020 -0300
>>
>>     cifs: allow syscalls to be restarted in __smb_send_rqst()
>>
>>     A customer has reported that several files in their multi-threaded a=
pp
>>     were left with size of 0 because most of the read(2) calls returned
>>     -EINTR and they assumed no bytes were read.  Obviously, they could
>>     have fixed it by simply retrying on -EINTR.
>>
>>     We noticed that most of the -EINTR on read(2) were due to real-time
>>     signals sent by glibc to process wide credential changes (SIGRT_1),
>>     and its signal handler had been established with SA_RESTART, in whic=
h
>>     case those calls could have been automatically restarted by the
>>     kernel.
>>
>>     Let the kernel decide to whether or not restart the syscalls when
>>     there is a signal pending in __smb_send_rqst() by returning
>>     -ERESTARTSYS.  If it can't, it will return -EINTR anyway.
>>
>>     Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>>     CC: Stable <stable@vger.kernel.org>
>>     Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>>
>> On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@redhat.com> w=
rote:
>> >
>> > RHBZ 1848178
>> >
>> > There is no need to fail this function if non-fatal signals are
>> > pending when we enter it.
>> >
>> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> > ---
>> >  fs/cifs/transport.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> > index c42bda5a5008..98752f7d2cd2 100644
>> > --- a/fs/cifs/transport.c
>> > +++ b/fs/cifs/transport.c
>> > @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, in=
t num_rqst,
>> >         if (ssocket =3D=3D NULL)
>> >                 return -EAGAIN;
>> >
>> > -       if (signal_pending(current)) {
>> > +       if (fatal_signal_pending(current)) {
>> >                 cifs_dbg(FYI, "signal is pending before sending any da=
ta\n");
>> >                 return -EINTR;
>> >         }

I've looked up the difference

static inline int __fatal_signal_pending(struct task_struct *p)
{
	return unlikely(sigismember(&p->pending.signal, SIGKILL));
}


> I have been thinking around the same lines. The original intent of
> failing the function here was to avoid interrupting packet send in the
> middle of the packet and not breaking an SMB connection.
> That's also why signals are blocked around smb_send_kvec() calls. I
> guess most of the time a socket buffer is not full, so, those
> functions immediately return success without waiting internally and
> checking for pending signals. With this change the code may break SMB

Ah, interesting.

I looked up the difference between fatal/non-fatal and it seems
fatal_signal_pending() really only checks for SIGKILL, but I would
expect ^C (SIGINT) to return quickly as well.

I thought the point of checking for pending signal early was to return
quickly to userspace and not be stuck in some unkillable state.

After reading your explanation, you're saying the kernel funcs to send
on socket will check for any signal and err early in any case.

some_syscall() {

    if (pending_fatal_signal)  <=3D=3D=3D=3D=3D if we ignore non-fatal here
        fail_early();

    block_signals();
    r =3D kernel_socket_send {
        if (pending_signal) <=3D=3D=3D=3D they will be caught here
            return error;

        ...
    }
    unblock_signals();
    if (r)
        fail();
    ...
}

So this patch will (potentially) trigger more reconnect (because we
actually send the packet as a vector in a loop) but I'm not sure I
understand why it returns less errors to userspace?

Also, shouldn't we move the pending_fatal_signal check *inside* the blocked
signal section?

In any case I think we should try to test some of those changes given
how we have 3,4 patches trying to tweak it on top of each other.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

