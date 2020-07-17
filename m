Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33786C433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 14:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFFC62083B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 14:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=arrloffice.onmicrosoft.com header.i=@arrloffice.onmicrosoft.com header.b="zHI5pCVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGQOEY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jul 2020 10:04:24 -0400
Received: from mail-dm6nam11on2098.outbound.protection.outlook.com ([40.107.223.98]:35137
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbgGQOEX (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 17 Jul 2020 10:04:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQqAQjQn7w1v3Hm25YXwr0fef/11v+ZACI8b3TKX7DpZpoYtWKjx7vn40mmu4JpN2NxK05lX2BD4sQClG0P8/jfvtsG4GbILx1680PSxUZVSLhEIESNQhWamoBJ2dYemiKodWFjKwuZdfWIzaZS/mdSY25kzNZmTRzTM4AbRIQ1ifhlJgJPA36KmDdM1Lr78zCk3bXwJeeGy4Nj+iRGDqiXylExJCqaia0qJTc0BKK8eozY6LcQYCGEdTnGA2jpVEoWsf4H2CdrMK5I3zKRW7xdUYTHbRdXxs5+o44pTvWaut8JnLchfubSTmD+C4iUH9pG3oPFfdCdj2tczjIBaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LxZPdtzgnYxzwDe4f9hPrPph1EA3AQe5Zva3s/nnhs=;
 b=TeA9hZ00AfxMuDknBkrfoX/wUr/G6gH/KSRzIF+s6TC5/993fPp8h47xSSPO2I5sQKcuUBpGWOkJ6E+FT+7XJn+nePTcUc9vvfDovP+kU5ZGVrAK+UbXBnDcHtNyR82jMmN8pcOzgCtdBUOv09Yx4UxpvD91AsRKdQmUQ02E7fkpfg8tUxyIjedHz0CRxTx+/thcWRpRs/EQcVq4FciDhfjL7ApXsQq3R6QvTtmYF7ShGPXBw5JJIa74kuZrEIZtQ/pNNTMrYX1ElOldbM97Jch5xNcDIYeEaS7dfph7u2zCN3n6LRZ45T24eahcooN5wM2LOKWUvkrrGoby/i3IWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arrl.org; dmarc=pass action=none header.from=arrl.org;
 dkim=pass header.d=arrl.org; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrloffice.onmicrosoft.com; s=selector2-arrloffice-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LxZPdtzgnYxzwDe4f9hPrPph1EA3AQe5Zva3s/nnhs=;
 b=zHI5pCVFY6yLdKwLPjiC6OKvYRXWiYFOv80C0OMQigXmFfcoAOo70nL9f4gL2jWoOAU7bBtAI0mv4aAfqnfuD/1x9LSoopqyYanYdUmtkT8iwVyM4VqOArOxMB9xx2zbbkL3JSXlzeqWt8JCIokkYBaqvfkkcy3MPQZNw40D8hY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=arrl.org;
Received: from BLAPR16MB3684.namprd16.prod.outlook.com (2603:10b6:208:273::7)
 by BL0PR16MB2434.namprd16.prod.outlook.com (2603:10b6:208:32::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 14:04:17 +0000
Received: from BLAPR16MB3684.namprd16.prod.outlook.com
 ([fe80::2441:e64c:89a1:780]) by BLAPR16MB3684.namprd16.prod.outlook.com
 ([fe80::2441:e64c:89a1:780%9]) with mapi id 15.20.3174.026; Fri, 17 Jul 2020
 14:04:17 +0000
To:     linux-cifs@vger.kernel.org
From:   "Michael Keane, K1MK" <mkeane@arrl.org>
Subject: issue -- cifs automounts stopped working
Organization: American Radio Relay League, Inc.
Message-ID: <b14432a4-bb8c-7a0f-4339-b7e6ddec9b4a@arrl.org>
Date:   Fri, 17 Jul 2020 10:04:14 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: MN2PR12CA0033.namprd12.prod.outlook.com
 (2603:10b6:208:a8::46) To BLAPR16MB3684.namprd16.prod.outlook.com
 (2603:10b6:208:273::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.151] (24.188.245.132) by MN2PR12CA0033.namprd12.prod.outlook.com (2603:10b6:208:a8::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Fri, 17 Jul 2020 14:04:16 +0000
X-Originating-IP: [24.188.245.132]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a46ce0f2-93c8-433e-d240-08d82a5a4b09
X-MS-TrafficTypeDiagnostic: BL0PR16MB2434:
X-Microsoft-Antispam-PRVS: <BL0PR16MB24343FFE0869D82FB7221CD7AA7C0@BL0PR16MB2434.namprd16.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Epium10ruBgEEOrtP+tVIE8Wt8apLWnN3aSwu59TONt24G2Up21MBwQ+3oxSfpRwelqEOa2f68z4SYbk8YTb1+Skkb+g0gm5S35usEOvMuBh8SqoNopXF3j9OqDoZQZWO8Rgt5ekiA0Xok01kR4JduOL8SNc47SoqV2Yu4YGgN7TCYTtWd3KL/lu8JWPhoIB0rNoTgkSoQpdRad+NV//GosgPAFdjPc4Qfypl86dFI3uYThzjUVeE3KffHjp67/4aF+1CnSOF7eV7JbC6ilgVIEk1Q9Zu3wMGy9P968rFHDQRFwZ9SFohEXhz6Tp0AvDeAFaiOCvPYEoY4G3Zx6QnL21PFPIZtsmUn1+vf+XK/Obm/chQLt6Y1dZFx5vCoX/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR16MB3684.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39840400004)(346002)(376002)(366004)(396003)(26005)(956004)(2906002)(6916009)(16576012)(478600001)(186003)(36916002)(6486002)(316002)(52116002)(8676002)(16526019)(31686004)(66556008)(5660300002)(66476007)(86362001)(2616005)(66946007)(83380400001)(8936002)(36756003)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KIXG8r0AbL0DWKLoB3YmAOgZADi+NbvJLkJV/wUM6dDF7AxLoU2t5rsMV8OlopsAh7CqaHlfGdSsaeiYmEHAWHTRIEBg2aWmrPwuABUQCu7JKeaKGhywd/a8fv2IoGj2cx9ReVVwcassDJO9ITylQVBE4Y7GwlTTv3WBQlQBFzzHV6oUKWVVm5vidTyUCuuT1yarrk0JKSpd1ULSo6BMADsN1dB+YPQagmQ3QYJqhk2MisPOdtsr3juFoSF5tuSC1TILu/etDqvp2fIonXS043Nm09rflaK4F+MdeAOIRUagkXVCiku1vjiLKGRLj9to+rjo79MVlZeGvj1BKcBSzjFIOry69HemCLzKte5+VX4nDtGfHMdMsWLcuaeB1UnuyGDBmu85uuaN7MuoEPGTyVcWjAPQ+FRvJ+6iXIx/52WzKvIvoXs1gmt6uyWfDwC8d/BBifyDiUeRRYHNH5zewYXrGQtcAUlLAAvXynqMC67bRRg5fgLOohV/hs4AnaQE
X-OriginatorOrg: arrl.org
X-MS-Exchange-CrossTenant-Network-Message-Id: a46ce0f2-93c8-433e-d240-08d82a5a4b09
X-MS-Exchange-CrossTenant-AuthSource: BLAPR16MB3684.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 14:04:16.9712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: baa21d0f-7301-40fe-bdd6-03d443a8c218
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6EC3gOo1FvBPKUmpkifNv+tFBCWxLaYI6orcf1NE0O/DScwbYfJuZygOr36wsPfX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR16MB2434
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

CIFS automounts to local NAS devices have stopped working recently

Fedora 32

kernel 5.7.8-200.fc32.x86_64

mount.cifs version: 6.9

auto.misc: it-share 
-fstype=cifs,multiuser,cruid=${UID},rw,vers=default,sec=krb5 
://filer5/IT_Share

dmesg:

    [ 3428.883661] fs/cifs/cifsfs.c: Devname:
    //filer5.arrlhq.org/IT_Share flags: 0
    [ 3428.883702] fs/cifs/connect.c: Username: root
    [ 3428.883706] fs/cifs/connect.c: file mode: 0755  dir mode: 0755
    [ 3428.883709] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as
    Xid: 12 with uid: 0
    [ 3428.883710] fs/cifs/connect.c: UNC: \\filer5.arrlhq.org\IT_Share
    [ 3428.883721] fs/cifs/connect.c: Socket created
    [ 3428.883723] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
    rcvtimeo 0x1b58
    [ 3428.884126] fs/cifs/fscache.c: cifs_fscache_get_client_cookie:
    (0x000000006d2b3226/0x0000000090edec3a)
    [ 3428.884130] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as
    Xid: 13 with uid: 0
    [ 3428.884131] fs/cifs/connect.c: Existing smb sess not found
    [ 3428.884135] fs/cifs/smb2pdu.c: Negotiate protocol
    [ 3428.884141] fs/cifs/connect.c: Demultiplex PID: 5778
    [ 3428.884156] fs/cifs/transport.c: Sending smb: smb_len=252
    [ 3429.010818] fs/cifs/connect.c: RFC1002 header 0x11c
    [ 3429.010830] fs/cifs/smb2misc.c: SMB2 data length 96 offset 128
    [ 3429.010832] fs/cifs/smb2misc.c: SMB2 len 224
    [ 3429.010835] fs/cifs/smb2misc.c: length of negcontexts 60 pad 0
    [ 3429.010871] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0
    mid=0 state=4
    [ 3429.010885] fs/cifs/misc.c: Null buffer passed to
    cifs_small_buf_release
    [ 3429.010891] fs/cifs/smb2pdu.c: mode 0x1
    [ 3429.010893] fs/cifs/smb2pdu.c: negotiated smb3.1.1 dialect
    [ 3429.010903] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
    [ 3429.010907] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
    [ 3429.010910] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
    [ 3429.010912] fs/cifs/smb2pdu.c: decoding 2 negotiate contexts
    [ 3429.010914] fs/cifs/smb2pdu.c: decode SMB3.11 encryption neg
    context of len 4
    [ 3429.010916] fs/cifs/smb2pdu.c: SMB311 cipher type:1
    [ 3429.010921] fs/cifs/connect.c: Security Mode: 0x1 Capabilities:
    0x300046 TimeAdjust: 0
    [ 3429.010923] fs/cifs/smb2pdu.c: Session Setup
    [ 3429.010926] fs/cifs/smb2pdu.c: sess setup type 5
    [ 3429.010949] fs/cifs/cifs_spnego.c: key description =
    ver=0x2;host=filer5.arrlhq.org;ip4=10.1.123.38;sec=krb5;uid=0x0;creduid=0x3e8;user=root;pid=0x1690
    [ 3429.025053] CIFS VFS: \\filer5.arrlhq.org Send error in SessSetup
    = -126
    [ 3429.025056] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses
    (xid = 13) rc = -126
    [ 3429.025059] fs/cifs/connect.c: build_unc_path_to_root:
    full_path=\\filer5.arrlhq.org\IT_Share
    [ 3429.025059] fs/cifs/connect.c: build_unc_path_to_root:
    full_path=\\filer5.arrlhq.org\IT_Share
    [ 3429.025060] fs/cifs/connect.c: build_unc_path_to_root:
    full_path=\\filer5.arrlhq.org\IT_Share
    [ 3429.025062] fs/cifs/dfs_cache.c: __dfs_cache_find: search path:
    \filer5.arrlhq.org\IT_Share
    [ 3429.025063] fs/cifs/dfs_cache.c: get_dfs_referral: get an DFS
    referral for \filer5.arrlhq.org\IT_Share
    [ 3429.025065] fs/cifs/dfs_cache.c: dfs_cache_noreq_find: path:
    \filer5.arrlhq.org\IT_Share
    [ 3429.025071] fs/cifs/fscache.c:
    cifs_fscache_release_client_cookie:
    (0x000000006d2b3226/0x0000000090edec3a)
    [ 3429.025076] fs/cifs/connect.c: CIFS VFS: leaving mount_put_conns
    (xid = 12) rc = 0
    [ 3429.025077] CIFS VFS: cifs_mount failed w/return code = -2

journalctl:

    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: key
    description:
    cifs.spnego;0;0;39010000;ver=0x2;host=filer5.arrlhq.org;ip4=10.1.123.38;sec=krb5;uid=0x0;creduid=0x3e8;user=root;pid=0x1690
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: ver=2
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]:
    host=filer5.arrlhq.org
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: ip=10.1.123.38
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: sec=1
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: uid=0
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: creduid=1000
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: user=root
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: pid=5776
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]:
    get_cachename_from_process_env: pathname=/proc/5776/environ
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]:
    get_existing_cc: default ccache is KEYRING:persistent:1000:1000
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]:
    handle_krb5_mech: getting service ticket for filer5.arrlhq.org
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]:
    cifs_krb5_get_req: unable to get credentials for filer5.arrlhq.org
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]:
    handle_krb5_mech: failed to obtain service ticket (-1765328370)
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: Unable to
    obtain service ticket
    Jul 17 09:43:13 mkZ230.ARRLHQ.ORG cifs.upcall[5779]: Exit status
    -1765328370

$ klist
Ticket cache: KEYRING:persistent:1000:1000
Default principal: mkeane@ARRLHQ.ORG

Valid starting       Expires              Service principal
07/17/2020 09:43:06  07/17/2020 19:43:06 krbtgt/ARRLHQ.ORG@ARRLHQ.ORG
         renew until 07/24/2020 09:42:57

Filer5 is a QNAP TS-870U-RP Version 4.3.6.1070 (2019/09/10) NAS device 
but having this issue with other NAS device on LAN

-- 
Michael Keane, K1MK
IT Manager
ARRL, The National Association for Amateur Radio™
225 Main Street, Newington, CT 06111-1494 USA
Telephone: (860) 594-0285
email: mkeane@arrl.org

