Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAEAC433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 09:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BCB561405
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 09:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhD2JaI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 05:30:08 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:21090 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230392AbhD2JaH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 29 Apr 2021 05:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619688560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G8fW7G8N1TjZ2YSBmbILnxt7MIAqR79MLcy3gkAjGbQ=;
        b=i3XjfCBo4O9yzK02E1W7dRbV0vpl2DeyTpmtax+blmSr3iRDEXKzqGf3ejYg7NsjsXP65C
        CbL4A+PCP3HV0wrBfRgwHK2jWAzemLTukwaMLR1o/4H2mw+6fpJ7ehPcTwaZ5L6V4Ncesf
        UhA6og+GS7K9HGuIZWECWRNUkJoaOA8=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-c7bN6wQ4Ob2yacw-Trtz8A-1; Thu, 29 Apr 2021 11:29:18 +0200
X-MC-Unique: c7bN6wQ4Ob2yacw-Trtz8A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8REsIujmooe9QAvfg7rSvDbuQPF9V455IVFsP4GLEf50gc1hR0DOKqX6FmiEjXVjmmdD41OePEWgDma+kqN39qOH87UJiHL2+r/i7jxZbSzEhhrQtixC8PxOqaGKAyeKaw71Xcn22wLQYsHWgTdycQJeGrWtgIlGNT3GXm1W55AkEnpYUhmC3xv0nm7mtpch15FTl990hck+gndG7HJrpL8B3yGecYzrHacwiXyVJf849XJ4LUuik2NnZZH9pEmn/XAuLSjzl0Rk26oYKSHZcG4AAvcOLDMwY/zydB19DLTSQj/bxkMgBSyc5Accu8TYMVTTyoZWRd187zFB2m58w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8fW7G8N1TjZ2YSBmbILnxt7MIAqR79MLcy3gkAjGbQ=;
 b=YySM0OLupm1jtvi0vupeVJtpr8J8OYonAUoPLwfRsc7rr0nCD9HUxbMBmK1g9Ex1QJhFi+PDC8QYpPWsttC4/cCzCk2AHwBYX36E0ZCjs153SkC9Al3FhNX1kcBZm6L8CW9ZEsnNxsW1NpWsbBl3L0j/mp1tVsHtPSvM7kcTT6yZZgZnH9lDMyZWvFigYMbiYr/YRNSImWyWcnOPFG/ACZ8+fq0qzZ9XF2TE5Iuakz+yC+TmPtUuwdFIDSeUP15QJNt/F4awaz7hdMn34S034VGq78mjUmV7VEGlRKURZWmO+bB3I/dO5FV+UuzHuGJd2iLTBiXArky6/ePcz+KxGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3760.eurprd04.prod.outlook.com (2603:10a6:803:23::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Thu, 29 Apr
 2021 09:29:17 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4065.029; Thu, 29 Apr 2021
 09:29:17 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: add shutdown support
In-Reply-To: <CAH2r5mvKfohJ=NkkCM7AxqRYq2+D8kRMTxP3VdG=W0s72Cdh0A@mail.gmail.com>
References: <CAH2r5mvKfohJ=NkkCM7AxqRYq2+D8kRMTxP3VdG=W0s72Cdh0A@mail.gmail.com>
Date:   Thu, 29 Apr 2021 11:29:14 +0200
Message-ID: <8735v9wiad.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3898:6337:f59e:f055:d0d]
X-ClientProxiedBy: ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3898:6337:f59e:f055:d0d) by ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 09:29:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 234301c0-3a26-40d5-3810-08d90af1427a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3760:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3760E6714E8C25682B63F36AA85F9@VI1PR0402MB3760.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EOF5klRZoe1pJ071ClPURN+m9k3AaNsKyNHs7qcL5vdL9oeaO0Axn/9gJ+RuBOTXYhxGkpJtr5fmzmyzKpJA41BHablklLrEJvT65M0T8IISYSWkTGxULVwWjTIOMiHcgtF14x0pMg7gcN0r1lrYJuzAm6zn6NIias8TWqMVyq7T7fVuPV/uvEaIyRX6WeS69LHYRHeR5M9bU+JFmUvXTxHZmIiSD2GrIdPyPkDiLFOaivNiU4ytvDdmFH+obSMWTSEqSKRrzCtZ8Xpuw+Q2Pa6EVdK3q7pXQXTfohAz9DIiOV0rJMTiYNE/g5pIJj7dUDXCB1YOwKYN7fqrNgFBok37KbI2fUPipjLJFHroQ/FnxwhsOi3bbhWBIhnlfagj21F+wsB2rWzLYwWh7sx2aQ+d15ZTL5xF4EavKb7atVTMe7SwSPlmJg3zQvzHN2TYC+mj+QslZMZ64u2Mplyai5h5iISaw5J4uJs59FpUmJoHZjViofeTwvswzkLyp1S3P8NSMgsY6uh5ToAls9e4JGwdehGImsAhmXw4bXs5SiM49aYadmVWRPzPAaZ00WueUmuYOsOtJsMWIvi6t7DsrP5/sxmJADHksS4fHj+Oks7n5IVbro0FQLrSy6GdvNLnvv7osu88N441vcPh0GyqpJcwRPafzSKihq529BGJrA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(376002)(396003)(110136005)(2616005)(5660300002)(186003)(316002)(966005)(478600001)(36756003)(2906002)(8936002)(8676002)(38100700002)(66556008)(66946007)(52116002)(66476007)(86362001)(83380400001)(16526019)(6486002)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UmQ1ZFRoMWdSSm9GK1FBdWpEZERFUDJJUlFxYmNlWElqYWYyYVo5ejZ3SDBs?=
 =?utf-8?B?bW02Mk0xZXdaZ1pOYVZ6N1lqaUROclFVdStwK1BRZ3FSa0tkT1hJZjhwcEU0?=
 =?utf-8?B?QkxzS3J5V3QvZjBPdXFabERwcFN4d1hxVnBDZVVIUG1hMHkvYU9WUHdmeEln?=
 =?utf-8?B?NWxIckRUT0RhWkZqdHBCSSsvOW52SVFXZGVFNjVoRGZuZXNkKzB3VzZ4cVdW?=
 =?utf-8?B?NUpxY3JqaWwwZC9ENHIrOVVoV25vR1JCMWtRUHNLYm9QUGVPOWhjZDBzZ2Zj?=
 =?utf-8?B?YXRRWHRPRUxzbVZ0MDNkUG00c0RBUUZOenI0WURhT0FxSTRhMS9UVWdhaHRB?=
 =?utf-8?B?OTFpQkpvUlBKdkRMb3BITW5GejYxN05kbUpBcWNSMXlmdUI4WVpLcVNRU1Nx?=
 =?utf-8?B?RVZtNThXNWtsUnRHYzFOS2wvbWJOckhBRVRobEF0MUJrTlRRd0NINkhBd0Rh?=
 =?utf-8?B?SG5CN1dCc3V6VDVRVkRhYkxtQlFXOVRMemo3WXRqeVZNN2RURTZxVDJIcDJL?=
 =?utf-8?B?dFc0T1Q1WGE4YzF4WkwyM0tmK2w0c2h4SHhvVWkxV3JRWG9reVQyanNURXFJ?=
 =?utf-8?B?UFZMU3RUb1BUWEZFU0lLbmlCUE0vL09neDJ5WlZPV2x6SU13d2RZTzAyRVNk?=
 =?utf-8?B?d0hUWkphVHMwMjcyYVFFVDFVaUIvUXZqeTBKazFHeUhVSk1OSjZMS1E0S2pB?=
 =?utf-8?B?OGgvTnBzVExrdEttYlQ2QVM3Njdxbld6M0l1a1gzMnRlWktwbkJQL3BEZG10?=
 =?utf-8?B?cm1PaVFpZTVqYno0dU51d1Fka1ZGNzRmN2hrZTRzQityNzdSYU44RC8wbWRo?=
 =?utf-8?B?N2MzcjM3VG5IbFZrckVORjgvVTR5OW81OGI0Rm5QeUJGbkZ6S1VGcElESkFW?=
 =?utf-8?B?UFNFTndFLzd3WmpMS2s1dUdBZjZjWXFkQUVaeGdSYjB6clpUQ1hBeFZkQ1Zp?=
 =?utf-8?B?UlV4MHVxM1BZOGtubUJzSFoxSHMwQ0NIb052STgvYllCZ0xYdDBPS2c5Q3oy?=
 =?utf-8?B?Zzg3NGY0ZXgvTHphRHNtb0d5WWx2VXNLMk5aUG9lWmprTTlLdFBadVA0b0tx?=
 =?utf-8?B?c0hRNGhmRVVGeUJZSW93MGgzYjJ3ZzJ4N2p1QXdpaHZpM0pqWVhYTnZZVHRI?=
 =?utf-8?B?OFI4bkwxb3U3SUxrY01tdEdUWlNSNTNHUlNGT1puK3dVNEVUSEJLU21aODh4?=
 =?utf-8?B?RlUwcU1kd25rMlhGWHZPYVBlbDhjeE0xeDc3ZlJrbW0rT09kUjd3c3AxMUN3?=
 =?utf-8?B?L0grTmphOGZzelVMbTlMR3FPc1pGZGVPeDc0dXZTaEpMYnFrSFVtc2VCbjdW?=
 =?utf-8?B?ci93dlg5VHhxOTJSMWNHYTFobTFjeDhINndVbDBQbWlKQXFwcGZqaFd5dFJj?=
 =?utf-8?B?S0M3eC9WK3dlOUc5Q1d5emlqNmxOdmhYK3llWkpWemlkN3Nxcm5iSkNwZ29G?=
 =?utf-8?B?RitrUC9pQ1JtTVJQemxTVlg4cFA1NHJiQVFVV3JZMUxweGZXaDJrK0pqemVO?=
 =?utf-8?B?QmZ6eG5ndmU0TlJpVG5nYmFPeDZVY1lKa2g1UVRqdHUvdk1ndjlzYzQyWGFn?=
 =?utf-8?B?TWVjT05PVE9jdGRPNGxHSyt2cHJKcUJ6U29SaG1WcXJKQkJaYjZIUTdtWnkr?=
 =?utf-8?B?clZ3SG9LN0h4TnY0RHlDYmtyaFNPYkROQ0ExQm9TUmF5M3h4dHU2R3N0YlUz?=
 =?utf-8?B?QmhGVlB4cU1ld3FoRFdwNHkvK3RyU21QZkVhZ1J0Y2RCbW16MTFlOUNmUG0w?=
 =?utf-8?B?dTZYWitRdmJKYThjQTk4ODljTGR6YWtLbXltS3ZlZC9QSnRrMVVtTXpyTGxU?=
 =?utf-8?B?YjZ0SDhneTI3VkdqT1ExZ0F0dEcvMStvaTh1Qjc0cEVmNk9WR0JnVWxuL0FP?=
 =?utf-8?Q?ODaC3LzZJdMhU?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234301c0-3a26-40d5-3810-08d90af1427a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 09:29:16.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqVAc/KUk/RmUEZc0Z/sVZG7y9g8GlLllDJG2j2SCsP72aWuLAzSfwFHdTmXGBHW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3760
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Do we need to add code to clear the flag on remount or is it implicitely
cleared by not copying it?

Steve French <smfrench@gmail.com> writes:
>  #define CIFS_MOUNT_MODE_FROM_SID 0x10000000 /* retrieve mode from
> special ACE */
>  #define CIFS_MOUNT_RO_CACHE 0x20000000  /* assumes share will not change=
 */
>  #define CIFS_MOUNT_RW_CACHE 0x40000000  /* assumes only client accessing=
 */
> +#define SMB3_MOUNT_SHUTDOWN 0x80000000

While I totally understand wanting to remove the "cifs" name, those
flags are specific to the kernel & filesystem and have nothing to do
with the wire protocol so in this case I would rather use CIFS_ prefix
because SMB3_ is misleading and all the other flags are already using CIFS_=
.

One day we should do s/CIFS/SMBFS/i on the whole tree where CIFS refers
to kernel stuff (not protocol) and rename the module smbfs. But that's a
story for another day I guess.

>
>  struct cifs_sb_info {
>   struct rb_root tlink_tree;
> diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> index 153d5c842a9b..a744022d2a71 100644
> --- a/fs/cifs/cifs_ioctl.h
> +++ b/fs/cifs/cifs_ioctl.h
> @@ -78,3 +78,19 @@ struct smb3_notify {
>  #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info=
)
>  #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug_i=
nfo)
>  #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
> +#define SMB3_IOC_SHUTDOWN _IOR ('X', 125, __u32)

Same

> +
> +/*
> + * Flags for going down operation
> + */
> +#define SMB3_GOING_FLAGS_DEFAULT                0x0     /* going down */
> +#define SMB3_GOING_FLAGS_LOGFLUSH               0x1     /* flush log
> but not data */
> +#define SMB3_GOING_FLAGS_NOLOGFLUSH             0x2     /* don't

Same

> flush log nor data */
> +
> +static inline bool smb3_forced_shutdown(struct cifs_sb_info *sbi)

Same

> +	cifs_dbg(VFS, "shut down requested (%d)", flags); /* BB FIXME */
> +/*	trace_smb3_shutdown(sb, flags);*/

What is there to fix? It's doing like ext4 so it's fine no?

> +
> +	/*
> +	 * see:
> +	 *   https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.2.html
> +	 * for more information and description of original intent of the flags
> +	 */
> +	switch (flags) {
> +	/*
> +	 * We could add support later for default flag which requires:
> +	 *     "Flush all dirty data and metadata to disk"
> +	 * would need to call syncfs or equivalent to flush page cache for
> +	 * the mount and then issue fsync to server (if nostrictsync not set)
> +	 */
> +	case SMB3_GOING_FLAGS_DEFAULT:
> +		cifs_dbg(VFS, "default flags\n");

Should this be removed, less verbose or more info should be printed?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

