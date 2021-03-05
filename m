Return-Path: <SRS0=1BtU=ID=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8347C433DB
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 14:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 891EA6508B
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 14:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCEOYf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:24:35 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:42700 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhCEOYN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Mar 2021 09:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614954251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CU4Edc4Nb2L1oekOUmDbA9OcvYDz2BK57rdSw+B+klY=;
        b=PwY/P1ncoylqYtXpNmviQPBslSNA2y2ir3bGR4tUpVkTyKLT+fofqAF9moJM4ElmBxq8+W
        aMK9JaCrz/UNwaddlDznDOKygBSkYNrea2pj7hETvZJMmp7z5KJ94giLcw+4DHbiLYiC/c
        CPHe0c+hlH5L7+4SUWxQb/4SEZp3Hn4=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-t2LdRMV8M3yaimAqLp0Tnw-1; Fri, 05 Mar 2021 15:24:10 +0100
X-MC-Unique: t2LdRMV8M3yaimAqLp0Tnw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EawHtouxQO8yx4oc8kTJiOZ8HkiFbfWpZN16hVRgkD6EX5PBh64+hOuZMZcM6m/DpV5L8jUOAqn3st3ew1L1w5nkWxerQ87YjUfSgPCMLrg3o5zUZVLmQ3kML2R3tIqDCX0tX0WF/2rCyMPljutf+lOmqNI44pNHW1ruLSAnSmf+UHeM6FOAaJX49nz+3JKjAwUhFKQ0jz1plODDpxW7zIBoI1d9aVy7CBcwUk+9QUPqrz/Iw/rdHd1Yr/tVaTHDVyywBmHy9j9eNUAISx5zb+22x/OPUOIDcsI/0CMr4xi1m22qUs3i0v4KoruQxL8tPMxufxRPc0PUCDwCr54zdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e45w77dJhTstvFXFKKZNVl9dnz9ZBH5F9ayQkjFN6Ts=;
 b=AIYwbcPMIlGhMcM1+8FqWpLJ5KPE9z7n0bttZdd12Bj/LMTnETIxEpLVJrFGe07LI7wlZa9Spp3oNCRDe7Jm3ONhFNteepPsJNUeOaSvuWc2VofYpVkmNIK6musG3WLLTTdXUx9RTOxJskq/J8HSmRKOx+ZTm3FAQw2AySvLGlstD6Ivs4U614J+Y6rA0HU84Du4GjWWMvOgcodxKlVOeCDo0uBt+75zYJeZMkOtCWmkB9nO9Kd2ZMS/XprPSzKTSq/b8kQKogx5F32O5glD0ZvznwOzK8iQtjJHHaGScx66Li3YXCyfJLsrLG51DCKoFU+/ADcLiOaNfzufj5/Jaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2381.eurprd04.prod.outlook.com (2603:10a6:800:2a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Fri, 5 Mar
 2021 14:24:09 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.028; Fri, 5 Mar 2021
 14:24:09 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] cifs: try to pick channel with a minimum of credits
Date:   Fri,  5 Mar 2021 15:24:07 +0100
Message-ID: <20210305142407.23652-1-aaptel@suse.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:70b:4a89:f10d:233d:fc9f:58b]
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a89:f10d:233d:fc9f:58b) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 14:24:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5879b283-7165-4ea4-686d-08d8dfe25768
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2381:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2381E86B10E46F9D79DCEBF8A8969@VI1PR0401MB2381.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xAeAZ2dwqOZYC/6Dd2c943+aXIEDe8C9YjPJJdrRtMyVW0XIXwS8zA9Tif8WAX9x8cYr2nATy9RLNw2A4JcRWCMq7M47Dzojq16dn+RWRIUkaGs1pB0KA7tPMYaiUnVej1ND4aw9s9wZOmqKzdYhC1T7+vPPdOlEUSRXyKgEIqmRDH6pQyxPUGSoDv36lcaGxQcNHmJfidzfBbLzLsMEuGigY9CNz1PO5p0cxcMo3PwE2Z/PA96D+03zytbmmcIGWI4e4SL3AXHt0FKP84mnXG0r0CvDgsfX4C1COD8ZtNWPpqw2ok+FVx//yjthXj9de5zSoYIFejHwjH39DvYqbw48EsyA4G5+pUaxKdb5MsjbXNX5FABqWWb88mg+EEMTN8UPtR/HIWPr9p/diBWCqjCB/NXREFmSUZshBv77q3Sq0LYnujFLJRxCQ/luscen3aVO1O1rlQBPtXhWJnvMWhYUngHi2TCMmFnCRGpDQJ8B3u3m/2A1aMZnqEPjHVKd3ca2BQNSvDL3WrIUBsblRd/IWKQeHJttnCr5ApVsRBYxRd4Fcw4WY39sLqmq3vFCfrfjfx/pzsRW9zyph3cCbqTfZpg8SSk6PW3tea3oHSc6nq5n7snK3B5pKsQDFPgaddrxA+OeTxWUMaDVNxPLtTe7zOHo9Zk8yr96uWCES3mpvItbptYskzmQW9yN91CKUF7sf7hpaFnmmEOwD5kdFE+ihv5IekgCSyEKwDrvkcHH2nUmxVtLTjPb+IRTW2fW8qTp2JlNdnCdmLsKLp6wCu0FXSJlfPi3/Fxn0OWBfQDQwLgnVAyKEBnQglq2S48DG5h3e2J4RJ6bKsSJE+61PoRUDL2R9xANsqXRszTaUasNOAeYEvnRjQCvql87saSL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(136003)(346002)(376002)(39860400002)(366004)(396003)(16526019)(2906002)(83380400001)(186003)(4326008)(1076003)(2616005)(36756003)(8936002)(6916009)(66946007)(6496006)(8676002)(107886003)(478600001)(5660300002)(86362001)(316002)(66476007)(66556008)(52116002)(6486002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?u84LTkOiQV6C6LGBPPw76kCb/a4c6QT66za/CYrWOqPIUVG/iyMKPtwa8mQJ?=
 =?us-ascii?Q?3n9VFNjfCeQys//+/nwJcSpUkiPaBLqCloNoRdcARykChDoROmZAMi3/oD0U?=
 =?us-ascii?Q?ItB1VhFBvXkJrf1yXCXkOma0FI1/+cYd6mOaacniXTwa5w15vKecV6U4tgyN?=
 =?us-ascii?Q?3Q6YOCzCQ0enWhoXngkdHyCgXyjniBtQZyTYTMJHO7aAToOYCAM4vIWSOnL1?=
 =?us-ascii?Q?nZzCJMkNCcc0wWl6NMVISzrNFIE9oIwA43Gigxw7M7iZLod6C+rP7vuWexb2?=
 =?us-ascii?Q?HloKDlBnfzBhw/NbbZYubvjxLV9E1ZBW+IBIwWwrWmYxXOsY1pexuDIQXitl?=
 =?us-ascii?Q?fHw5W7s1kIbo5nFhlqgRGAp+uZT+Ox4ZwSZSqlLW/wTVt8FCrB7c4YKia0Bz?=
 =?us-ascii?Q?+mYQKSj2ygxutZRMsjyKkynnWRJdEj1ncK+one+UX6u7OmhjHQVjK9USVLsO?=
 =?us-ascii?Q?JrDj+iu3t7ci8SKLc+eQGLzLS7QANp83SeXB7bO0dXzGNRPKtsZcZ8WYRcGw?=
 =?us-ascii?Q?+xv0MEkoAvsoZw3F7CK3cOU5pFH1y/L1aePxMWllfBuTCXKxaftR1BSzun7E?=
 =?us-ascii?Q?keF3AoL8ZXVXr5/e0tgFfQacrr01kFNPVgWAE8b/nlFF832nxAESkhPmJdl3?=
 =?us-ascii?Q?fo+MYwVbDCXJwDnE7elBkv6YLKPUUh7muA+JUEiKLCdkVqodmtYhl11hcsJ/?=
 =?us-ascii?Q?g+mi6tIijRDDtpAgO6waEYzXU7J5mU7luW+0OHq3NN5crCCHylaTXU0x4Qeu?=
 =?us-ascii?Q?z89Y2GVUzOUhXQ6hDJYZVsQHwpOEZ1mc2JWXnEzKW0EdygGbia45vdBkVwoZ?=
 =?us-ascii?Q?grmst8/vwHbniYVyZLyLRJfSVAv3rDj4FXMJmON7Fl6cVMRhk+jNuaNhGbvF?=
 =?us-ascii?Q?/dvPjslTG74I1grNmcag6LMXijLfwoNMOIw8icXjzRmg9yiW5K7+Txw8xQwP?=
 =?us-ascii?Q?YrfKczjFDWc6m8vOvFsBWpdxfeTqT2ozvIZvA1cNupUWBIi75A5Y+QqmT6cy?=
 =?us-ascii?Q?T2xPuNS0GtL2LXmUxLbzlb9u9HyboNOvJMQhIP6dP85+ptM6Y+yZowhJTeXx?=
 =?us-ascii?Q?M6Xs+Vs2QBXvfR/BFHbd4E/D5d3pWm5Q5/4q3/A+5RCrdPlIPx3JvfpL54N6?=
 =?us-ascii?Q?lnIUkP0eIe4Se1Ub6XH1/LLqOEipv+vUZbjMo3w4QL8kJ/zfNrxj+aiu2lXA?=
 =?us-ascii?Q?newF93qosRfGHvM70yqeh1dSHJrwC6zJ3AnOx3QKlsx14jrk5EKGMVBwGyw3?=
 =?us-ascii?Q?Vcd1jgECivDRBkhp3wu8ZMIHRQTynppbPWwpibWW3bihBb9Bnv+HvDNRoBml?=
 =?us-ascii?Q?j6BGPXDFV1SJNWcfPsE1PRhYch9bOIb3pHLZqfLmQKb0ZmPXJqksHp3EyVbg?=
 =?us-ascii?Q?tRKLndJcTXfrN3/3NhUCiSCt6mXB?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5879b283-7165-4ea4-686d-08d8dfe25768
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 14:24:09.6067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rX9LdnICxwoYR0ahtQK2+gVZi4IEqpyt0ZxHrOCBWOUEPUegIG2/9T8UBmy8g7k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2381
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

Check channel credits to prevent the client from using a starved
channel that cannot send anything.

Special care must be taken in selecting the minimum value: when
channels are created they start off with a small amount that slowly
ramps up as the channel gets used. Thus a new channel might never be
picked if the min value is too small.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/transport.c | 57 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index e90a1d1380b0..7bb1584b3724 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -44,6 +44,14 @@
 /* Max number of iovectors we can use off the stack when sending requests.=
 */
 #define CIFS_MAX_IOV_SIZE 8
=20
+/*
+ * Min number of credits for a channel to be picked.
+ *
+ * Note that once a channel reaches this threshold it will never be
+ * picked again as no credits can be requested from it.
+ */
+#define CIFS_CHANNEL_MIN_CREDITS 3
+
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
 {
@@ -1051,20 +1059,53 @@ cifs_cancelled_callback(struct mid_q_entry *mid)
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 {
 	uint index =3D 0;
+	struct TCP_Server_Info *s;
=20
 	if (!ses)
 		return NULL;
=20
-	if (!ses->binding) {
-		/* round robin */
-		if (ses->chan_count > 1) {
-			index =3D (uint)atomic_inc_return(&ses->chan_seq);
-			index %=3D ses->chan_count;
-		}
-		return ses->chans[index].server;
-	} else {
+	if (ses->binding)
 		return cifs_ses_server(ses);
+
+	/*
+	 * Channels are created right after the session is made. The
+	 * count cannot change after that so it is not racy to check.
+	 */
+	if (ses->chan_count =3D=3D 1)
+		return ses->chans[index].server;
+
+	/* round robin */
+	index =3D (uint)atomic_inc_return(&ses->chan_seq);
+	index %=3D ses->chan_count;
+	s =3D ses->chans[index].server;
+
+	/*
+	 * Checking server credits is racy, but getting a slightly
+	 * stale value should not be an issue here
+	 */
+	if (s->credits <=3D CIFS_CHANNEL_MIN_CREDITS) {
+		uint i;
+
+		cifs_dbg(VFS, "cannot pick conn_id=3D0x%llx not enough credits (%u)",
+			 s->conn_id,
+			 s->credits);
+
+		/*
+		 * Look at all other channels starting from the next
+		 * one and pick first possible channel.
+		 */
+		for (i =3D 1; i < ses->chan_count; i++) {
+			s =3D ses->chans[(index+i) % ses->chan_count].server;
+			if (s->credits > CIFS_CHANNEL_MIN_CREDITS)
+				return s;
+		}
 	}
+
+	/*
+	 * If none are possible, keep the initially picked one, but
+	 * later on it will block to wait for credits or fail.
+	 */
+	return ses->chans[index].server;
 }
=20
 int
--=20
2.30.0

