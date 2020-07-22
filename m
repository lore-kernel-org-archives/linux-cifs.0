Return-Path: <SRS0=JAQl=BB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD51C433E1
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jul 2020 03:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EF5420714
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jul 2020 03:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=arrloffice.onmicrosoft.com header.i=@arrloffice.onmicrosoft.com header.b="UybY3Vk8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731879AbgGVDsd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jul 2020 23:48:33 -0400
Received: from mail-dm6nam11on2121.outbound.protection.outlook.com ([40.107.223.121]:52065
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731857AbgGVDsc (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Jul 2020 23:48:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeAD2DRDaTnByM8M2KkCT4w0g1ocgpnFEWl6yVKRup9zVHuU6aDOPCd0RDb50rXDBQV9ct3vkNEWgLsDz9ugB0vNHcTCAZzVV2DNJe22RZZIxla8Cn8qdLxXnMmwGBQvgCekxIokEcBDz37AACPQ2CELANXA8XtWQLiFRh16TNEws7W5RszWx8wnbRXkvQmcmKQrEeNyAywVaJ9l5yzKJTBcgjLWaekJsGd/7O/jaEBS9d/33/HhG15FIGqxs3EUH9pXysF3dM5qPVbYHIJEBBIdybWsIm06VVzetQONp3EJc7gDZY07+pPRaeZMSfLbM++TFqXJnlwgTjMMwazsiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ixwc4s4KPgzJ5H42Y3kBaBw6FeczwegwmkC2ZptYUA=;
 b=XbKFfMHlM2y9ot7mwRJYEn+U250PG+mvVhcNFrEu/uOKKjqzWxl7LqNB41pPTlss0+wY0RTCSzZ3OpMFsI+M8lBaFWz7PWuGZsbvpqY5tzKEwjERFTpwnQQdC+1evLFRpAHsYDgjYx2c0xClkN+JyZ7gFM9wa85vBEZ2Wy2AW4aAJb/2VUJ1BdLEV8sWllE5ZFweK/XfsYMNifGS/6PomwozdX09s922547pY7lRrrvpMnxn5v28WJl5FUJ4r2hMMTh1Ywc1j/EjEHkcg6umy2JuofD0noCkigMTrEmxS00V379pBgZsdDLAv/CxzlcpeHPwM15I6GsluKTbrIeSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arrl.org; dmarc=pass action=none header.from=arrl.org;
 dkim=pass header.d=arrl.org; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrloffice.onmicrosoft.com; s=selector2-arrloffice-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ixwc4s4KPgzJ5H42Y3kBaBw6FeczwegwmkC2ZptYUA=;
 b=UybY3Vk8Wtn4B+8b7zL7C++L4n6OjFO81Pr+vBV8TADD7bx2P/n8HExXIMHr7gNGDg7igf1wpY8FMZ2+cAkJpQdkOjN1nek1DuOqc4517bTOH599I3I7AInZlhW5vHJRzQsuYlnqcEfJ8aIGR6IJjQnGDg6NFqaO8oQDwqv4U64=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=arrl.org;
Received: from BLAPR16MB3684.namprd16.prod.outlook.com (2603:10b6:208:273::7)
 by BLAPR16MB3762.namprd16.prod.outlook.com (2603:10b6:208:27b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 03:48:28 +0000
Received: from BLAPR16MB3684.namprd16.prod.outlook.com
 ([fe80::2441:e64c:89a1:780]) by BLAPR16MB3684.namprd16.prod.outlook.com
 ([fe80::2441:e64c:89a1:780%8]) with mapi id 15.20.3195.027; Wed, 22 Jul 2020
 03:48:28 +0000
Subject: Re: issue -- cifs automounts stopped working
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <b14432a4-bb8c-7a0f-4339-b7e6ddec9b4a@arrl.org>
 <CAH2r5msj3KMMonyhjDeyAweHEBezOHFkJwCUXpJ4Gv59Q=S9bQ@mail.gmail.com>
 <752d5d05-7b91-b119-b5a6-7fcdeb1f0ced@arrl.org>
 <CAH2r5muNtwm3V-0GpaRBXmrptGDO9w1vDSWN9Wrf_eebuevg6A@mail.gmail.com>
 <61450b64-ed70-6b8f-2beb-57267ddcb8c5@arrl.org>
 <CAH2r5mu-g-RrR9Q4ghmqjkd-mbXbfeJE=HgVSaEEosCyBNoO8Q@mail.gmail.com>
From:   "Michael Keane, K1MK" <mkeane@arrl.org>
Organization: American Radio Relay League, Inc.
Message-ID: <119a0298-4099-c65e-30db-746814e36cce@arrl.org>
Date:   Tue, 21 Jul 2020 23:48:24 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAH2r5mu-g-RrR9Q4ghmqjkd-mbXbfeJE=HgVSaEEosCyBNoO8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: MN2PR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:208:23d::31) To BLAPR16MB3684.namprd16.prod.outlook.com
 (2603:10b6:208:273::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.151] (24.188.245.132) by MN2PR06CA0026.namprd06.prod.outlook.com (2603:10b6:208:23d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Wed, 22 Jul 2020 03:48:27 +0000
X-Originating-IP: [24.188.245.132]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a0591ab-e247-4256-2c5d-08d82df217c6
X-MS-TrafficTypeDiagnostic: BLAPR16MB3762:
X-Microsoft-Antispam-PRVS: <BLAPR16MB376200B766454B8A723643FBAA790@BLAPR16MB3762.namprd16.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HcLGjm7sAKWGHXkGYbNETJDiqVQBx6vjHw1/Zo6uzsJTVf1A6/GEDGEBIIQKFXxqIksBiL0J2wLkouNRg7SRX0hfCn7bm6WkLwVnIe7ajB+wZr7VtLEtCxPSvyj4CTyWtrVJ2955xIRPvpP3oAqypcjejRThMTohWfLyJ1mxSZ0rk+U/U5YIy2JDL8RWYj6M0uu7J/dP4fa+trPFwTYsn4o0arMzNU/BuTXNeSHKRqoIZBWDadSu+HFQdOelAU+eD7DSIZv9yYYQ8ukYPsy9N7/U5G5QjdmjOvUek+J4KEKvaPzom4TV8KLP36fGPJ8/hJP616wS9z0NwbRpQcmrCDM38/V+ZSKuOdSYEEnySCPYZbdpbqyzDuBj4xmtzKAp+F3I44V4xXxz/SjGCIq8TvmVwMEjg4irkfIdpixNI8FXCXFVcLM2Y/VjuNUE2gkiS7dIWDxQdeWKggwWYY6ERQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR16MB3684.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39850400004)(136003)(376002)(366004)(396003)(8676002)(36916002)(478600001)(6916009)(36756003)(31686004)(15188445003)(186003)(66556008)(6486002)(966005)(66476007)(52116002)(53546011)(83380400001)(66946007)(16526019)(83080400001)(31696002)(6666004)(54906003)(956004)(26005)(30864003)(8936002)(5660300002)(4326008)(2906002)(86362001)(2616005)(16576012)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /E7POYdhbYawyMdOto1qLTcOvQf8JQ6ucsIEpIOeaQC7dREpPs/YolAVjUAhIivgRLzOrvndiX1yA3Kaq80nujagDuYO/7lcJJRwOXCvFNp3US0FKvLc9Bsl1f46fUtr8ewXCHG5bAmWzeaQezDDgOWRWn+EUs3Bnz77jZ82KRhlKhNW9C5lborkCHuPVc/pMJq/T1o3nX8rtSN4OaU7vv/Krz2Y6MsYjWIQEMnrmG6TaBShChmhCpYPFKpz+KajWbgD2hhsdFh3GHkHkCQZmTjdWMOShQtVlrMU3H3D35A8C6RCzrtWlXkOWaEdWLi5AA6+qMCg/UcwfKkiM64C5v+4Uba3qv2EV7McymyAhWUAt3YSp1z4Q26AuVjvU/jCC489cqTWtHGKNvA1aFhwxmmzEF2Z+tmaNT9Mvs1Mcmn35TrK5f9iYVvf9eBhIrWFf0t77oF1R133HGWxa/FjS8zqn/IFKluL/5RZTaWPNjSOA9C8BnLYboy5VCJlyzWl
X-OriginatorOrg: arrl.org
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0591ab-e247-4256-2c5d-08d82df217c6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR16MB3684.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 03:48:27.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: baa21d0f-7301-40fe-bdd6-03d443a8c218
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqEEXNAjacLcbXEG6WFEgE8IROrmb12IRQxYTBztgqgTXo/d90qy/jSug88bLk/M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR16MB3762
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tried setting KRB5_CCNAME to KEYRING:persistent:1000 with no change 
(Also tried KRB5CCNAME  as well, as that's the environment variable 
which seems to work with kinit & klist)

Also tried setting default_ccahe_name in /etc/krb5.conf to a legacy 
value of

     default_ccache_name = /tmp/krb5_%{uid}

in order to force it to use the filesystem rather than the kernel space 
for the credentials cache. And it still fails in the same way. I think 
that tends to makes this more likely a regression in krb5 than the kernel.

I believe that I may have verified this by reverting from 
krb5-*/-/1.18.2-10 to krb5-*-1.17.1-5 which resolves the issue



On 07/21/2020 3:59 PM, Steve French wrote:
> Would setting KRB5_CCNAME (as would be expected in the past) for that
> process fix the issue?
>
> On Tue, Jul 21, 2020 at 2:52 PM Michael Keane, K1MK <mkeane@arrl.org> wrote:
>> KRB5_CCNAME is not set in the environment of the user for whom the
>> automount is failing.
>>
>> In /etc/krb5.conf the default is set to:
>>
>>      default_ccache_name = KEYRING:persistent:%{uid}
>>
>> The calls to keyctl()  in the strace for cifs.upcall  indicate that it's
>> successfully locating the user's keyring in the kernel and that it is
>> able to read key data from that keying
>>
>> I haven't gone through and tried unpacking and decoding the contents of
>> those reads, but the reads aren't failing outright like it couldn't find
>> the credentials cache or the contents that it's looking for
>>
>>
>> On 07/21/2020 1:36 PM, Steve French wrote:
>>> That is plausible but I also wonder about other whether other parts of
>>> krb5 configuration are changed/broken eg KRB5_CCNAME environment variable
>>>
>>> See https://web.mit.edu/kerberos/krb5-1.12/doc/basic/ccache_def.html
>>>
>>> On Tue, Jul 21, 2020, 12:24 Michael Keane, K1MK <mkeane@arrl.org
>>> <mailto:mkeane@arrl.org>> wrote:
>>>
>>>      Thanks
>>>
>>>      In trying to further debug this problem, I've stood up a separate
>>>      Fedora 31 instance for testing with the result that the same
>>>      configuration that is failing on Fedora 32 is working under Fedora 31
>>>
>>>      Using strace it would appear the deviation occurs at the point of
>>>      "handle_krb5_mech" where the Fedora 31 instance proceeds though
>>>      several keyctl() calls to a successful return while the Fedora 32
>>>      instance goes through a similar sequence of keyctl() calls but
>>>      rather than finishing up with a final call to keyctl() to
>>>      instantiate the key it appears that the krb5 library and/or sssd
>>>      is going through a series of steps to locate the KDC (and failing)
>>>      even though the KDCs have always been explicitly configured in
>>>      /etc/krb5.conf
>>>
>>>      So the root cause of this issue may not be anything in cifs.upcall
>>>      but rather something in the sssd or kerberos that got changed as a
>>>      result of moving from Fedora 31 to Fedora 32
>>>
>>>      On 07/18/2020 8:40 PM, Steve French wrote:
>>>>      Looks like error obtaining the key (either keyutils package not
>>>>      installed or no Kerberos ticket found).
>>>>
>>>>      This page has debug instructions for cifs.upcall. see of that
>>>>      information is helpful.
>>>>
>>>>      http://sprabhu.blogspot.com/2014/12/debugging-calls-to-cifsupcall.html?m=1
>>>>
>>>>      Also try kinit as a local user and then mount with cruid mount
>>>>      option pointing to their uid to see if that helps.
>>>>
>>>>      On Fri, Jul 17, 2020, 09:04 Michael Keane, K1MK <mkeane@arrl.org
>>>>      <mailto:mkeane@arrl.org>> wrote:
>>>>
>>>>          CIFS automounts to local NAS devices have stopped working
>>>>          recently
>>>>
>>>>          Fedora 32
>>>>
>>>>          kernel 5.7.8-200.fc32.x86_64
>>>>
>>>>          mount.cifs version: 6.9
>>>>
>>>>          auto.misc: it-share
>>>>          -fstype=cifs,multiuser,cruid=${UID},rw,vers=default,sec=krb5
>>>>          ://filer5/IT_Share
>>>>
>>>>          dmesg:
>>>>
>>>>              [ 3428.883661] fs/cifs/cifsfs.c: Devname:
>>>>              //filer5.arrlhq.org/IT_Share
>>>>          <http://filer5.arrlhq.org/IT_Share> flags: 0
>>>>              [ 3428.883702] fs/cifs/connect.c: Username: root
>>>>              [ 3428.883706] fs/cifs/connect.c: file mode: 0755 dir
>>>>          mode: 0755
>>>>              [ 3428.883709] fs/cifs/connect.c: CIFS VFS: in
>>>>          mount_get_conns as
>>>>              Xid: 12 with uid: 0
>>>>              [ 3428.883710] fs/cifs/connect.c: UNC:
>>>>          \\filer5.arrlhq.org <http://filer5.arrlhq.org>\IT_Share
>>>>              [ 3428.883721] fs/cifs/connect.c: Socket created
>>>>              [ 3428.883723] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
>>>>              rcvtimeo 0x1b58
>>>>              [ 3428.884126] fs/cifs/fscache.c:
>>>>          cifs_fscache_get_client_cookie:
>>>>              (0x000000006d2b3226/0x0000000090edec3a)
>>>>              [ 3428.884130] fs/cifs/connect.c: CIFS VFS: in
>>>>          cifs_get_smb_ses as
>>>>              Xid: 13 with uid: 0
>>>>              [ 3428.884131] fs/cifs/connect.c: Existing smb sess not found
>>>>              [ 3428.884135] fs/cifs/smb2pdu.c: Negotiate protocol
>>>>              [ 3428.884141] fs/cifs/connect.c: Demultiplex PID: 5778
>>>>              [ 3428.884156] fs/cifs/transport.c: Sending smb: smb_len=252
>>>>              [ 3429.010818] fs/cifs/connect.c: RFC1002 header 0x11c
>>>>              [ 3429.010830] fs/cifs/smb2misc.c: SMB2 data length 96
>>>>          offset 128
>>>>              [ 3429.010832] fs/cifs/smb2misc.c: SMB2 len 224
>>>>              [ 3429.010835] fs/cifs/smb2misc.c: length of negcontexts
>>>>          60 pad 0
>>>>              [ 3429.010871] fs/cifs/transport.c: cifs_sync_mid_result:
>>>>          cmd=0
>>>>              mid=0 state=4
>>>>              [ 3429.010885] fs/cifs/misc.c: Null buffer passed to
>>>>              cifs_small_buf_release
>>>>              [ 3429.010891] fs/cifs/smb2pdu.c: mode 0x1
>>>>              [ 3429.010893] fs/cifs/smb2pdu.c: negotiated smb3.1.1 dialect
>>>>              [ 3429.010903] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2
>>>>          0x348 0xbb92
>>>>              [ 3429.010907] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2
>>>>          0x348 0x1bb92
>>>>              [ 3429.010910] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3
>>>>          0x6 0x1
>>>>              [ 3429.010912] fs/cifs/smb2pdu.c: decoding 2 negotiate
>>>>          contexts
>>>>              [ 3429.010914] fs/cifs/smb2pdu.c: decode SMB3.11
>>>>          encryption neg
>>>>              context of len 4
>>>>              [ 3429.010916] fs/cifs/smb2pdu.c: SMB311 cipher type:1
>>>>              [ 3429.010921] fs/cifs/connect.c: Security Mode: 0x1
>>>>          Capabilities:
>>>>              0x300046 TimeAdjust: 0
>>>>              [ 3429.010923] fs/cifs/smb2pdu.c: Session Setup
>>>>              [ 3429.010926] fs/cifs/smb2pdu.c: sess setup type 5
>>>>              [ 3429.010949] fs/cifs/cifs_spnego.c: key description =
>>>>              ver=0x2;host=filer5.arrlhq.org
>>>>          <http://filer5.arrlhq.org>;ip4=10.1.123.38;sec=krb5;uid=0x0;creduid=0x3e8;user=root;pid=0x1690
>>>>              [ 3429.025053] CIFS VFS: \\filer5.arrlhq.org
>>>>          <http://filer5.arrlhq.org> Send error in SessSetup
>>>>              = -126
>>>>              [ 3429.025056] fs/cifs/connect.c: CIFS VFS: leaving
>>>>          cifs_get_smb_ses
>>>>              (xid = 13) rc = -126
>>>>              [ 3429.025059] fs/cifs/connect.c: build_unc_path_to_root:
>>>>              full_path=\\filer5.arrlhq.org
>>>>          <http://filer5.arrlhq.org>\IT_Share
>>>>              [ 3429.025059] fs/cifs/connect.c: build_unc_path_to_root:
>>>>              full_path=\\filer5.arrlhq.org
>>>>          <http://filer5.arrlhq.org>\IT_Share
>>>>              [ 3429.025060] fs/cifs/connect.c: build_unc_path_to_root:
>>>>              full_path=\\filer5.arrlhq.org
>>>>          <http://filer5.arrlhq.org>\IT_Share
>>>>              [ 3429.025062] fs/cifs/dfs_cache.c: __dfs_cache_find:
>>>>          search path:
>>>>              \filer5.arrlhq.org <http://filer5.arrlhq.org>\IT_Share
>>>>              [ 3429.025063] fs/cifs/dfs_cache.c: get_dfs_referral: get
>>>>          an DFS
>>>>              referral for \filer5.arrlhq.org
>>>>          <http://filer5.arrlhq.org>\IT_Share
>>>>              [ 3429.025065] fs/cifs/dfs_cache.c: dfs_cache_noreq_find:
>>>>          path:
>>>>              \filer5.arrlhq.org <http://filer5.arrlhq.org>\IT_Share
>>>>              [ 3429.025071] fs/cifs/fscache.c:
>>>>              cifs_fscache_release_client_cookie:
>>>>              (0x000000006d2b3226/0x0000000090edec3a)
>>>>              [ 3429.025076] fs/cifs/connect.c: CIFS VFS: leaving
>>>>          mount_put_conns
>>>>              (xid = 12) rc = 0
>>>>              [ 3429.025077] CIFS VFS: cifs_mount failed w/return code = -2
>>>>
>>>>          journalctl:
>>>>
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: key
>>>>              description:
>>>>              cifs.spnego;0;0;39010000;ver=0x2;host=filer5.arrlhq.org
>>>>          <http://filer5.arrlhq.org>;ip4=10.1.123.38;sec=krb5;uid=0x0;creduid=0x3e8;user=root;pid=0x1690
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: ver=2
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
>>>>              host=filer5.arrlhq.org <http://filer5.arrlhq.org>
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: ip=10.1.123.38
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: sec=1
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: uid=0
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: creduid=1000
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: user=root
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: pid=5776
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
>>>>              get_cachename_from_process_env: pathname=/proc/5776/environ
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
>>>>              get_existing_cc: default ccache is
>>>>          KEYRING:persistent:1000:1000
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
>>>>              handle_krb5_mech: getting service ticket for
>>>>          filer5.arrlhq.org <http://filer5.arrlhq.org>
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
>>>>              cifs_krb5_get_req: unable to get credentials for
>>>>          filer5.arrlhq.org <http://filer5.arrlhq.org>
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
>>>>              handle_krb5_mech: failed to obtain service ticket
>>>>          (-1765328370)
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: Unable to
>>>>              obtain service ticket
>>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
>>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: Exit status
>>>>              -1765328370
>>>>
>>>>          $ klist
>>>>          Ticket cache: KEYRING:persistent:1000:1000
>>>>          Default principal: mkeane@ARRLHQ.ORG <mailto:mkeane@ARRLHQ.ORG>
>>>>
>>>>          Valid starting       Expires              Service principal
>>>>          07/17/2020 09:43:06  07/17/2020 19:43:06
>>>>          krbtgt/ARRLHQ.ORG@ARRLHQ.ORG <mailto:ARRLHQ.ORG@ARRLHQ.ORG>
>>>>                   renew until 07/24/2020 09:42:57
>>>>
>>>>          Filer5 is a QNAP TS-870U-RP Version 4.3.6.1070 (2019/09/10)
>>>>          NAS device
>>>>          but having this issue with other NAS device on LAN
>>>>
>>>>          --
>>>>          Michael Keane, K1MK
>>>>          IT Manager
>>>>          ARRL, The National Association for Amateur Radio™
>>>>          225 Main Street, Newington, CT 06111-1494 USA
>>>>          Telephone: (860) 594-0285
>>>>          email: mkeane@arrl.org <mailto:mkeane@arrl.org>
>>>>
>>>      --
>>>      Michael Keane, K1MK
>>>      IT Manager
>>>      ARRL, The National Association for Amateur Radio™
>>>      225 Main Street, Newington, CT 06111-1494 USA
>>>      Telephone: (860) 594-0285
>>>      email:mkeane@arrl.org  <mailto:mkeane@arrl.org>
>>>
>> --
>> Michael Keane, K1MK
>> IT Manager
>> ARRL, The National Association for Amateur Radio™
>> 225 Main Street, Newington, CT 06111-1494 USA
>> Telephone: (860) 594-0285
>> email: mkeane@arrl.org
>>
>

-- 
Michael Keane, K1MK
IT Manager
ARRL, The National Association for Amateur Radio™
225 Main Street, Newington, CT 06111-1494 USA
Telephone: (860) 594-0285
email: mkeane@arrl.org

