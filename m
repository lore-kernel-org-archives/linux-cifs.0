Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7718FC433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 19:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 337FA60C3D
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Mar 2021 19:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbhCATA3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Mar 2021 14:00:29 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:51788 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240797AbhCAS6E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Mar 2021 13:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614625008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=lVIKG+2t1tY05X+GALt4z+9vjuNrQK2jXCua8/q45tQ=;
        b=fs0P8+cPOiDqi7mInp6P7HCpkSjyyoc75fh4gDguoykEyaYLMHXU/oaHmJY6gwDQaiXzub
        KlF1dGArWCsaux7bilYp0oRySB2TfrsTXGrY7D/2GySGJkeUW2JHrevtTt+y9G4tqAYVsO
        i3xBsuLOItq2mxHm93WPKzepWLC8Kj8=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-7-BpQU9-IONFKWbhqGeZ9oTA-1;
 Mon, 01 Mar 2021 19:56:47 +0100
X-MC-Unique: BpQU9-IONFKWbhqGeZ9oTA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYcOKHAbVEm4CbPI+DZ4XI7RRMRwGFMQbnhvwQJkc9wc049wFAC9kip/y/nlrwMQ+77pQoeU28C6pEog6iRcLp7OaPG9zD6bHJyM/ouUikH5EkSf2agPqYkcSmJJOmX3BHW3vR4nAN25MaDNciRRcm+qBnXdrZ2MfmlooZ9JO/IsEBzLVyc9+ubRH8gG9e/z49fetTyKlWAiUssGGAHuTnVfX5jyHWiCI7ch89GkQy751wemFrUoBGQQOkdrUQOBaHKZ5SS/Ns1iUeJNu6c+UKLmU0zQOabDTRnOus6wdDH0JR59P1aUDenm3MqDYgPeR2Q3t1Uu6rOTcyb3Hruiug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVIKG+2t1tY05X+GALt4z+9vjuNrQK2jXCua8/q45tQ=;
 b=VXH7wzCVQ1GAEsQcjblQXz73v3dr+nAeEr/NW8o3HV41MJoN4inl/v+LIeXcvQfvdfkyx1l1wckWnFndBgbG//z18Zq1jE3yKti+8mm1ffVRzes1z+A+M084gHt47ZyLywGgkrjTtcp+7yjAWGB7zJfWNq9A3+OH9kJPpdPRoVvuMHIgfMZY2TyZsnVS52go8RxFTPpqgztYmYucz/XWVqIRUKDSXqWFW+viYR4T2PtB0nxtZxUVZ6Sn+gIJAPjNQQlxnmr5BfzNJTZ9H4jVwUPiDgh0f8yYHTjfUotDvkcPJ6jCkG3ABz1og/pF/oQCdzO5KpNX0f3dLyaeyBNxOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4320.eurprd04.prod.outlook.com (2603:10a6:803:49::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 18:56:45 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 18:56:45 +0000
From:   =?utf-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Subject: [EXPERIMENT] new mount API verbose errors from userspace
Date:   Mon, 01 Mar 2021 19:56:42 +0100
Message-ID: <87tupuya6t.fsf@suse.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-Originating-IP: [2003:fa:70b:4a92:20ca:256:2191:52c5]
X-ClientProxiedBy: ZR0P278CA0123.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a92:20ca:256:2191:52c5) by ZR0P278CA0123.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Mon, 1 Mar 2021 18:56:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da7cebc6-abc0-4c84-e3de-08d8dce3c297
X-MS-TrafficTypeDiagnostic: VI1PR04MB4320:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4320CEE0B90634B0697CDF76A89A9@VI1PR04MB4320.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTfnfyFo8XFWWcRl0lChuBys+9XMWb31lMUhMJZ2tlLcF9YLgKZw16CSGSTbjQCE8f0/ee/NuZ9saOJfYa6TaFg8NK8NKSN3CF0BdfYsbBIp4DAE06EaoY06Pjsv/+ubhK5alkwqEs0EBuOgx4goaLgtgSg8J6nOq0wtJnqaSBh6QytI9oztAUW6W+Bt5zFE0Qcm+e/oxnkjxUsTT1Pdi6FF0+iqmQNVeqPyYmKRhw0lkGMmgrFDbOXj1vgdR+/2pjHoKNnu4eiJbWqFpLnZdMURoA+lbigOgZvi5586Fed5TTgw3ELwO/Vw0HnjbyOUYwEBDzwbhEXlUrXVMEfxG3U9Xyot6xDpV631Cgdw6WuLiwHBAaOaQtAV1V6YeE8CgRVDaVEcOntP9YA9JPrygQV551lFNc8GnqEqmue2P/ooxjlFkkEhFzjcpvc7OKLpHFa7mZYcNOcpQ5bhoYxgZTCpQG07ohi4MmWmCQUn7IH/nEvKU/51iPQZv4qeAq2qkzzVzYDp9Ys164TTkgeipw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39850400004)(136003)(366004)(396003)(316002)(36756003)(86362001)(83380400001)(6916009)(66556008)(2616005)(66476007)(6486002)(235185007)(66946007)(2906002)(66576008)(5660300002)(8936002)(6496006)(478600001)(8676002)(33964004)(186003)(6666004)(52116002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f5wyQNvkdm3JvpQoIGsmLf4HljE8ya3l6Jbhb9EOf3smyan6wZRlLcf6zrnG?=
 =?us-ascii?Q?LNQVccZox+ehtzCzqty++4cDKGFlyVCIKDEpDdkl6KC8/kENDKgJyicMwqwl?=
 =?us-ascii?Q?6QLoQXKBUKBK8AdBktBSK2loE3hrg2UoUo54hKLoASiXqO7CGgJJ99hp0sIS?=
 =?us-ascii?Q?zIHmx5wtJhb6we1+3V4rR1cLIc+J7PN1SWFdZy1CVNmdlTcpCTQFAKiJocSs?=
 =?us-ascii?Q?Xn2b9snulnejAmzAdzDf+iaoJNPxx7lfq9YNJbpICTv3OVDR2C8L3V4pXxz0?=
 =?us-ascii?Q?nrQSjvKhv3+0nITgDj92U6UCSq6AIoyqIOmiKAnnhRO99HPXcGkRy6kLM7A+?=
 =?us-ascii?Q?zVK8cEqCrpDkQ82htcRNuoRDyYRhcGoUzBAAtNeE4t0gGX8iggK9hPtvLZUK?=
 =?us-ascii?Q?BI5jYOE11EMg7dk5JVSJLYmMnJP4Us1tZf+iTPg3m1/7nS2cJak5/Vdvj8WD?=
 =?us-ascii?Q?W0VN8KYZnHpI2IVEKy23tkYelZKaTcdzvOSJId9tv7JEFwHOjpW0+u5d9whu?=
 =?us-ascii?Q?wOEgvJ5Bs1EuoIaSkSDZOOtOS8u2X7c3BcMl19jf4aXH3FfDUXe1TXnB7HIe?=
 =?us-ascii?Q?cBg/U2vLszghxZxTFe5F2SZIufGQaXUbU1/CsZuW2YFt5lGiShE4R1LiXqKJ?=
 =?us-ascii?Q?vfZ4YeECIsmztOBpRgbz0iLi9Mx0CktVz6d+SvUK2ClzgyWF6omuSh6TonmN?=
 =?us-ascii?Q?Ju7b8UL0BmORjUG9DMfHqktuXFK8X+p7JoGOvJ1fB752fguRxYLnTkTH0cfl?=
 =?us-ascii?Q?A3plgH4Q1de74Cz06i0GRtVQBhF+vq2d0NuUHvfN9HCIbQpwpJkT0yWto89F?=
 =?us-ascii?Q?BzXhfWuXp0mMOqC+lxP4Bgc4OP+xgVAkrQE9dN8fsL+Y4TUf6T6bK2kB6E+3?=
 =?us-ascii?Q?Z53ZAgJhcskWTWDqzucXnuMdM7KOaTPQGUML56CcmXL/CWlQsPiiw9P7yWQl?=
 =?us-ascii?Q?WF73fKOnZ4Xl7YrG7NMjdraeeLJLkgJWsB9xE9ek/k+21WxZ/PfadZivvv0H?=
 =?us-ascii?Q?bX634MP89amCXclark6ik+ftzeSDUaACJJgiPD2jszdhmhO6xRpFNg/5l3Hr?=
 =?us-ascii?Q?V+ilRlHDqs6SCrNlruGPm0esKWOa3kObVd3Oc3VYzvDCV7qRrPcW5yFvR4Kb?=
 =?us-ascii?Q?JrBSyUe1drKP7sYIQpcqFEKD1LlcEiZsMJ2FbwLFfoinTue68zzFCgwGdkvF?=
 =?us-ascii?Q?mUwOsq4qAZTQur6UZqdTbqEQBzc9BRAWRfQ2QAzgse4SpNrA3P6wt0cDnBgR?=
 =?us-ascii?Q?7WqC/kKS8oMaOHEG5OsQ/yDa3WkoME90JJ2FfAwUkwmNZYypEQ9psUwvf42o?=
 =?us-ascii?Q?OCH+naY8aiB86QTH8irK220+YZS6J0az8ZfzYXBxNZejQ11tj2MtwBkC3DQd?=
 =?us-ascii?Q?suu0jzvJzCrO415EyKtSgx+LzEVJ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7cebc6-abc0-4c84-e3de-08d8dce3c297
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 18:56:45.6174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2gWq9hULOeaGsqAu8VNV4bo0swnQW897VzPv1ySUiffekKg/9pZD+4V9AmwU6DY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4320
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi,

I have some code to use the new mount API from user space.

The kernel changes are just making the code use the fs_context logging
feature.

The sample userspace prog (fsopen.c) is just a PoC showing how mounting
is done and how the mount errors are read.

If you change the prog to use a wrong version for example (vers=4.0) you
get this:

    $ gcc -o fsopen fsopen.c
    $ ./fsopen
    fsconfig(sfd, FSCONFIG_SET_STRING, "vers", "4.0", 0): Invalid argument
    kernel mount errors:
    e Unknown vers= option specified: 4.0

There are some cons to using this API, mainly that mount.cifs will have
to encode more knowledge and processing of the user-provided option
before passing it to the kernel.

Where previously we would pass most options as-is to the kernel, making
it easier to add new ones without patching mount.cifs; we know have to
know if the option is a key=string, or key=int, or boolean (key/nokey)
and call the appropriate FSCONFIG_SET_{STRING,FLAG,PATH,...}.

The pros are that we process one option at a time and we can fail early
with verbose, helpful messages to the user.


--=-=-=
Content-Type: text/x-patch; charset=utf-8
Content-Disposition: attachment; filename=fs_context_log.patches
Content-Transfer-Encoding: quoted-printable

From fe07bfda2fb9cdef8a4d4008a409bb02f35f1bd8 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Feb 2021 16:05:19 -0800
Subject: [PATCH 1/3] Linux 5.12-rc1

---
 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index b0e1bb472202..f9b54da2fca0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION =3D 5
-PATCHLEVEL =3D 11
+PATCHLEVEL =3D 12
 SUBLEVEL =3D 0
-EXTRAVERSION =3D
-NAME =3D =F0=9F=92=95 Valentine's Day Edition =F0=9F=92=95
+EXTRAVERSION =3D -rc1
+NAME =3D Frozen Wasteland
=20
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
--=20
2.30.0


From a671cb46c29416c0fcb4b8e64e1d8e9013586b36 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Sat, 27 Feb 2021 02:01:46 -0600
Subject: [PATCH 2/3] smb3: allow files to be created with backslash in name

Backslash is reserved in Windows (and SMB2/SMB3 by default) but
allowed in POSIX so must be remapped when POSIX extensions are
not enabled.

The default mapping for SMB3 mounts ("SFM") allows mapping backslash
(ie 0x5C in UTF8) to 0xF026 in UCS-2 (using the Unicode remapping
range reserved for these characters), but this was not mapped by
cifs.ko (unlike asterisk, greater than, question mark etc).  This patch
fixes that to allow creating files and directories with backslash
in the file or directory name.

Before this patch:
   touch "/mnt2/filewith\slash"
would return
   touch: setting times of '/mnt2/filewith\slash': Invalid argument

With the patch touch and mkdir with the backslash in the name works.

This problem was found while debugging xfstest generic/453
    https://bugzilla.kernel.org/show_bug.cgi?id=3D210961

Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifs_unicode.c | 15 ++++++++++-----
 fs/cifs/cifs_unicode.h |  3 +++
 fs/cifs/cifsglob.h     |  5 +----
 fs/cifs/dir.c          | 18 ++++++++++++------
 fs/cifs/misc.c         |  2 +-
 fs/cifs/smb2misc.c     | 18 +++++++++++-------
 6 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 9bd03a231032..4898b1553796 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -98,6 +98,9 @@ convert_sfm_char(const __u16 src_char, char *target)
 	case SFM_PERIOD:
 		*target =3D '.';
 		break;
+	case SFM_SLASH:
+		*target =3D '\\';
+		break;
 	default:
 		return false;
 	}
@@ -431,6 +434,9 @@ static __le16 convert_to_sfm_char(char src_char, bool e=
nd_of_string)
 	case '|':
 		dest_char =3D cpu_to_le16(SFM_PIPE);
 		break;
+	case '\\':
+		dest_char =3D cpu_to_le16(SFM_SLASH);
+		break;
 	case '.':
 		if (end_of_string)
 			dest_char =3D cpu_to_le16(SFM_PERIOD);
@@ -443,6 +449,9 @@ static __le16 convert_to_sfm_char(char src_char, bool e=
nd_of_string)
 		else
 			dest_char =3D 0;
 		break;
+	case '/':
+		dest_char =3D cpu_to_le16(UCS2_SLASH);
+		break;
 	default:
 		dest_char =3D 0;
 	}
@@ -502,11 +511,7 @@ cifsConvertToUTF16(__le16 *target, const char *source,=
 int srclen,
 			dst_char =3D convert_to_sfm_char(src_char, end_of_string);
 		} else
 			dst_char =3D 0;
-		/*
-		 * FIXME: We can not handle remapping backslash (UNI_SLASH)
-		 * until all the calls to build_path_from_dentry are modified,
-		 * as they use backslash as separator.
-		 */
+
 		if (dst_char =3D=3D 0) {
 			charlen =3D cp->char2uni(source + i, srclen - i, &tmp);
 			dst_char =3D cpu_to_le16(tmp);
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 80b3d845419f..8cd58c71cbb6 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -24,6 +24,9 @@
=20
 #define  UNIUPR_NOLOWER		/* Example to not expand lower case tables */
=20
+/* Unicode encoding of backslash character */
+#define UCS2_SLASH 0x005C
+
 /*
  * Windows maps these to the user defined 16 bit Unicode range since they =
are
  * reserved symbols (along with \ and /), otherwise illegal to store
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3de3c5908a72..95bd980ec849 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1430,10 +1430,7 @@ CIFS_FILE_SB(struct file *file)
=20
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
-		return '/';
-	else
-		return '\\';
+	return '/';
 }
=20
 static inline void
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index a3fb81e0ba17..b3ee9871f6b6 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -209,12 +209,18 @@ check_name(struct dentry *direntry, struct cifs_tcon =
*tcon)
 		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
 		return -ENAMETOOLONG;
=20
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
-		for (i =3D 0; i < direntry->d_name.len; i++) {
-			if (direntry->d_name.name[i] =3D=3D '\\') {
-				cifs_dbg(FYI, "Invalid file name\n");
-				return -EINVAL;
-			}
+	/*
+	 * SMB3.1.1 POSIX Extensions, CIFS Unix Extensions and SFM mappings
+	 * allow \ in paths (or in latter case remaps \ to 0xF026)
+	 */
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) ||
+	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SFM_CHR))
+		return 0;
+
+	for (i =3D 0; i < direntry->d_name.len; i++) {
+		if (direntry->d_name.name[i] =3D=3D '\\') {
+			cifs_dbg(FYI, "Invalid file name\n");
+			return -EINVAL;
 		}
 	}
 	return 0;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 82e176720ca6..2b4c53e47888 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1186,7 +1186,7 @@ int update_super_prepath(struct cifs_tcon *tcon, char=
 *prefix)
 			goto out;
 		}
=20
-		convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb));
+		convert_delimiter(cifs_sb->prepath, CIFS_DIR_SEP(cifs_sb)); /* BB Check =
this */
 	} else
 		cifs_sb->prepath =3D NULL;
=20
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 60d4bd1eae2b..ce4f00069653 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -476,13 +476,17 @@ cifs_convert_path_to_utf16(const char *from, struct c=
ifs_sb_info *cifs_sb)
 	if (from[0] =3D=3D '\\')
 		start_of_path =3D from + 1;
=20
-	/* SMB311 POSIX extensions paths do not include leading slash */
-	else if (cifs_sb_master_tlink(cifs_sb) &&
-		 cifs_sb_master_tcon(cifs_sb)->posix_extensions &&
-		 (from[0] =3D=3D '/')) {
-		start_of_path =3D from + 1;
-	} else
-		start_of_path =3D from;
+	start_of_path =3D from;
+	/*
+	 * Only old CIFS Unix extensions paths include leading slash
+	 * Need to skip if for SMB3.1.1 POSIX Extensions and SMB1/2/3
+	 */
+	if (from[0] =3D=3D '/') {
+		if (((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) =3D=3D false) ||
+		    (cifs_sb_master_tlink(cifs_sb) &&
+		     (cifs_sb_master_tcon(cifs_sb)->posix_extensions)))
+			start_of_path =3D from + 1;
+	}
=20
 	to =3D cifs_strndup_to_utf16(start_of_path, PATH_MAX, &len,
 				   cifs_sb->local_nls, map_type);
--=20
2.30.0


From 2b0fa815fe8337f93174eba888dc67b140498af9 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Mon, 1 Mar 2021 19:25:00 +0100
Subject: [PATCH 3/3] cifs: make fs_context error logging wrapper

This new helper will be used in the fs_context mount option parsing
code. It log errors both in:
* the fs_context log queue for userspace to read
* kernel printk buffer (dmesg, old behaviour)

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/fs_context.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 87dd1f7168f2..dc0b7c9489f5 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -13,7 +13,12 @@
 #include <linux/parser.h>
 #include <linux/fs_parser.h>
=20
-#define cifs_invalf(fc, fmt, ...) invalf(fc, fmt, ## __VA_ARGS__)
+/* Log errors in fs_context (new mount api) but also in dmesg (old style) =
*/
+#define cifs_errorf(fc, fmt, ...)			\
+	do {						\
+		errorf(fc, fmt, ## __VA_ARGS__);	\
+		cifs_dbg(VFS, fmt, ## __VA_ARGS__);	\
+	} while (0)
=20
 enum smb_version {
 	Smb_1 =3D 1,
--=20
2.30.0


--=-=-=
Content-Type: text/x-csrc
Content-Disposition: attachment; filename=fsopen.c

/*
 * PoC for using new mount API for mount.cifs
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

/*
 * For MS_*, MNT_* constants
 */
#include <sys/mount.h>

/*
 * For FSCONFIG_*, FSMOUNT_*, MOVE_* constants
 *
 * TODO: need to add configure check for header availability
 */
#include <linux/mount.h>

/*
 * For AT_* constants
 */
#include <fcntl.h>

/*
 * The new mount API syscalls have currently no wrappers in
 * glibc. Call them via syscall().
 *
 * Wrap in #ifdef to be future-proof once they eventually get wrappers
 *
 * TODO: add configure checks for fsopen symbol -> HAVE_FSOPEN
 */
#ifndef HAVE_FSOPEN
#include <sys/syscall.h>
int fsopen(const char *fsname, unsigned int flags)
{
	return syscall(SYS_fsopen, fsname, flags);
}
int fsmount(int fd, unsigned int flags, unsigned int mount_attrs)
{
	return syscall(SYS_fsmount, fd, flags, mount_attrs);
}
int fsconfig(int fd, unsigned int cmd, const char *key, const void *value, int aux)
{
	return syscall(SYS_fsconfig, fd, cmd, key, value, aux);
}
int move_mount(int from_dirfd, const char *from_pathname, int to_dirfd, const char *to_pathname, unsigned int flags)
{
	return syscall(SYS_move_mount, from_dirfd, from_pathname, to_dirfd, to_pathname, flags);
}
#endif

/*
 * To get the kernel log emitted after a call, simply read the context fd
 *
 *     "e <message>"
 *            An error message string was logged.
 *
 *     "i <message>"
 *            An informational message string was logged.
 *
 *     "w <message>"
 *            An warning message string was logged.
 *
 *     Messages are removed from the queue as they're read.
 *
 */
void print_context_log(int fd)
{
	char buf[512];
	ssize_t rc;
	int first = 1;

	while (1) {
		memset(buf, 0, sizeof(buf));
		rc = read(fd, buf, sizeof(buf)-2);
		if (rc == 0 || (rc < 0 && errno == ENODATA)) {
			errno = 0;
			break;
		}
		else if (rc < 0) {
			perror("read");
			break;
		}
		if (first) {
			printf("kernel mount errors:\n");
			first = 0;
		}
		printf("%s", buf);
	}
}


#define CHECK(x)				\
	do {					\
		if ((x) < 0) {			\
			perror(#x);		\
			exit(1);		\
		}				\
	} while (0)

#define CHECK_AND_LOG(fd, x)			\
	do {					\
		if ((x) < 0) {			\
			perror(#x);		\
			print_context_log(fd);	\
			exit(1);		\
		}				\
	} while (0)


int main(void)
{
	int sfd;
	int mfd;

	/*
	 * Converting following old-style mount syscall to new mount api
	 *
	 *   mount(
	 *     "//192.168.2.110/data",
	 *     "/mnt/test",
	 *     "cifs",
	 *     0,
	 *     "ip=192.168.2.110,unc=\\\\192.168.2.110\\data,vers=3.0,user=administrator,pass=my-pass"
	 *   )
	 *
	 */

	CHECK(sfd = fsopen("cifs", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "source", "//192.168.2.110/data", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "ip", "192.168.2.110", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "unc", "\\\\192.168.2.110\\data", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "vers", "3.0", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "user", "administrator", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_SET_STRING, "pass", "my-pass", 0));
	CHECK_AND_LOG(sfd, fsconfig(sfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0));
	CHECK_AND_LOG(sfd, (mfd = fsmount(sfd, FSMOUNT_CLOEXEC, 0)));
	CHECK(move_mount(mfd, "", AT_FDCWD, "/mnt/test", MOVE_MOUNT_F_EMPTY_PATH));
	return 0;
}

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

--=-=-=--

