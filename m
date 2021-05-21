Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F05FC47078
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B23613CB
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhEUPVU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 11:21:20 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:56913 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237421AbhEUPVR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 May 2021 11:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621610392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCKopmHmH88ad9N1m8CpoCpgMCsFu3zI5iDygLRo8cE=;
        b=FWvWu8AH4dxFXKJXl4RhU7BaD74cn1EXVaFH5pmuChZAvreuwHI1vD1B6DN36OHbuWORHQ
        rcwO57gezT30y/2yMt++KvJJl8MEHYnr6Hmwfz1Yg7qOlTHO/S1+tNkHKfpbYN5tOdPV/Q
        eGwGcQGKEpz+zZ0Xez9FqlAjfA4FJ4E=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-9VnvBE1cM7qaXTVHV8_KtQ-1; Fri, 21 May 2021 17:19:51 +0200
X-MC-Unique: 9VnvBE1cM7qaXTVHV8_KtQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWBkFAW6Tb2GGvWuBdhBltg8FVuC8VXQr4LNtGg1Wbo6+iDpAWBc4DjPgVZC8WDiTKYtOSKW+Mcuxh2xYmeqPw8NodOpNbpYPh0zhI6O7fEFM/T+XFWe01enwifo6+1nwdleTfIB3Jx1otNDHFBYY/aon6PiV3Hx8BzFk4Jk4hSPPLATpjSDYoqE0/N5UKbn7AqQOvwJHKX6o/iOh6P/nzzVDWPydiq9VQjGXMJC9WgAeBQUa/6HF+ZtCyQdO+dyZRJG4vHWPYlMZ379NBMhapreCE+QbGLlIvzDrzy39PNVXy1PcG923cFifDSc6gkEirAGyuKVQB2W+wmw993vjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhqPrVJFVe+uQrpkx+X226CIgsFgFBzhY1L/lobAge8=;
 b=XIIFuI8i97WNqA0ZALb2jQzVr5vt9GRAqHxkCEFbMHEgwVZtBjfN/PvksrW/92LO4vH0oC8oE1cZm3TVaKtakj7YQC0/LUxnKTIGA0OJ+64u/9ZlpAKXSV+DWnxW0y17YVYTYkZemk09RrcFG4+i5pALwPx64DXG2RHyflzknIWnloav/OD4cml0ohXJNVO5FBUvpV6X5FpM9YVQfWUjY3hyXxQPE8VhXq1enFsemOtuf9edQ8ro3H8DQT/FUFlYJmDzz7l2RKy3wWfLuPz290SFBia+o1cToICISct7qf8WpM1IjOpF+MRK7CzMkJf4lQA27aLmWRHmX1IHrrdnqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7453.eurprd04.prod.outlook.com (2603:10a6:800:1b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Fri, 21 May
 2021 15:19:50 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 15:19:50 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, metze@samba.org,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1 2/2] cifs: change format of CIFS_FULL_KEY_DUMP ioctl
Date:   Fri, 21 May 2021 17:19:28 +0200
Message-ID: <20210521151928.17730-3-aaptel@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521151928.17730-1-aaptel@suse.com>
References: <20210521151928.17730-1-aaptel@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:713:d396:524:65d3:25:9e8c]
X-ClientProxiedBy: ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::21) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d396:524:65d3:25:9e8c) by ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 15:19:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d69945f2-49ff-41e5-be0f-08d91c6be065
X-MS-TrafficTypeDiagnostic: VE1PR04MB7453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74531638A74BBA6B3DFFE8C4A8299@VE1PR04MB7453.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YO3z/EQhndc66dXMJ57Wn78w15xUARozWhEJXQ2IiLjr0JuKE9kJJjrWvJ5KSI8VdwVneVQLo53ItfPI/BiMTehrWfs2jFIhM6VIiSYbL29fi3m/FdO1junTMm1yh9mgPGj7fLq54HBjMuZsZYvDg1O1Myr34i6Jq2E6/1pDBKDlio0UGja8BxJTE8iWiIyTEdfyjPfxL3Zsjx2GRpInBdeUD8yoTKjK0Mfy5zlfkHAHYqApqVeOCIBsnYieabr0voe6Ue4/X+uJjvoUCaD1uADvnQ28Si6EuhhXwmBy8uYbzN4zHnC6um9uqPhqjU8Sdlv7DvUFOIgBdnm4NbGk6TJadRTtdbhnT/4l38EHVnbKHELMlJ5RhOaU86wGSke8Bfev48GHrW9jpwQ1Qq7J0LB0o1NSJpz3nwkCcYdIY8DDoAJMcdszBVTjivLUjK3IhB/i8KQVoNcOId6NXopMZKTpvjPYoaT0ZFThWmecO0/Go+ZuXxaJ2+Mw30gr/D+pF3tSd6osm+01fh7Xnzowh5xH3KVBilHcuq++FbjaJNOPfvw+Ruwp+5/SQnthRqHvdYkF3U67AtCjcUWF+owq20wBeyt7ROWO7HZKLytMKjOe5YNwwSbf30TdQ1SrOaPt3OEqinQ16L8qD/ziGMfpFnViRFiBzfQDsUiVjr0qy8qe6rPcRM4oYajGeZtd5bnsAMPfz6XQ03M5kwe03a0FXtBsnmGwe5fumJ7VRyIb7oB8zufvfdLtqBSxj3bVeezOeCB99EAe9xM2mkY8PiPRbLWJCCIfCLz18L/FZuAXdAcVVyimDJoctv+eQoE2qAO5Nu9GywML+8sSqLBZMBzbGP8KPCMPxPrm0wNleUBkTqT84iW5jceWoW6rZpruBx3J5W8S4Uo85X9fWMKE5+v8pk4MYD5l70Uaw+8uKXMx66Ll34tQeQPPJiqOjdB+64pzLKq
 JTVqnhW9WaXaWpbPjlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(316002)(1076003)(66476007)(66556008)(8936002)(52116002)(6486002)(6496006)(186003)(30864003)(8676002)(16526019)(2616005)(86362001)(66946007)(5660300002)(83380400001)(6916009)(6666004)(2906002)(478600001)(38100700002)(36756003)(107886003)(4326008)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5xfTUwuIR15yibyMdMJ1XXf5ZutUq6oW7kNGhX0VDKzqQsNMv/iJzWtbKhwz?=
 =?us-ascii?Q?ZVrGPRRz/zSBjG+hKCALMc551PrD1SKCgS7ss0qwrAPz3OpXOvC7GLIA7yJg?=
 =?us-ascii?Q?Y3vPk82Qymj30XwaKJD2YWjLoEcAJ8FtIjQrgVKwpxTiT+iz/wFDXkYSoafl?=
 =?us-ascii?Q?ChmVNttbu0NGMWJNrQhrGxY3tomsFOG+luqBAvXtxFpMDTdAxlANiLjKqMhd?=
 =?us-ascii?Q?9KcvgIeikzjQEduCnto+6aOQJxx3tuHbreCwxUP6y2i/xcAuDL/EN0ohRqbO?=
 =?us-ascii?Q?0kBiAAX0Hvz/AXy+Cb2xpZOjTM7oj1JyhOR6IsBMoSp+13s/wH00p7k3X9Dj?=
 =?us-ascii?Q?X2V3rDGADh2vP0lN3GNZhqEPmiNe0Zf+KRevB1idobZXvNhUKdtg/nd06kwM?=
 =?us-ascii?Q?LQxYtfQyj5h/FoLwZyV3Hjt8+mdXOwpTPWEm1MheapeqKf4665uMt+p35Sm1?=
 =?us-ascii?Q?ltWEzf7vSlISMFzcWBCOZFgYcCPhO8dZRz42HCNrXYkLkANWa/j3CSZxiZin?=
 =?us-ascii?Q?R1Q7TKEB05hVTWKzRhC48IqSewAcSxJJqG2v1iY1jinjOo3RiCwOKAqefqfv?=
 =?us-ascii?Q?ttQcJAEPsXf/1OUaNnqtoTv1Gw0ppR8aWn80fVNxjWGq8mm0Pr1gLXvX5Vzk?=
 =?us-ascii?Q?gaCD3gdrfonHHGxRdzDzU502BgUfgMn6XnXL8H17Hlq85rvZaIQhQTKRCj3b?=
 =?us-ascii?Q?w/Zlwy3Pt3ugyCu94V1i5RVjehs3D2GdcfMBbqQSDXQdKmiyKin8x8UIESKA?=
 =?us-ascii?Q?/2QSLA7hHXmVIYENSnTf8lpQedFRKr1P4Ub4Qxe8Ev3bBygEgfikXjPoU6FP?=
 =?us-ascii?Q?2bUyntTSVWwpzLjWM1Zzfuf+RY02bCaO5ZgJe3aFxo42NO3kujeE2ZNDNxWw?=
 =?us-ascii?Q?HmM5t8rymjy9n/TDDRN0n2JtASuWVEb6pIM8FCXbFx3Le+FolTsznzPtjgwK?=
 =?us-ascii?Q?7mrSW9hTlE09zc195f40zplUR7UTaCRFHBRKRN5GehBKp6kqF6rhVzADCA2u?=
 =?us-ascii?Q?NvCImBLBfyKt+53vycXMNdUdtCb8CEjE7TPw0+F5D2sUx1vXvFWHA0b0djDl?=
 =?us-ascii?Q?imt8zx1VMgTgn8eoCNBJUgSjseqYI4f0HU9HwoEvyroB/N/yitKCs2WEogGH?=
 =?us-ascii?Q?PlJAQOCOedWdQZM5rdMUvSGr8PGWMYwAGOix9kb1s3HfmGJuX5an3EDYA+gS?=
 =?us-ascii?Q?lin4e9uYPA54jvIW+9GuEp/F3l70gw2R+SrYOBnkvQk0iFRzd0fWRn40Wx18?=
 =?us-ascii?Q?+y5rkbhZUWY25+y9BG/IA+I9uPPVcMTrcqmKaQCzjZbogSy3zGO5TPHlnvqk?=
 =?us-ascii?Q?AXGbqo6WPLtoosSESzy6q/a7RgI+e+5dlFBf1VtoasqEyB4b1P0+g7P/Yyo+?=
 =?us-ascii?Q?aoOkWZA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69945f2-49ff-41e5-be0f-08d91c6be065
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 15:19:50.2667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UZeGw9P3mRFOKP/z0BGvIKoqRyCzOhLYU8blSprr1OUqO5+DdznM8ZQWd+Y1RvS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7453
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

Make CIFS_FULL_KEY_DUMP ioctl able to return variable-length keys.

* userspace needs to pass the struct size along with optional
  session_id and some space at the end to store keys
* if there is enough space kernel returns keys in the extra space and
  sets the length of each key via xyz_key_length fields

This also fixes the build error for get_user() on ARM.

Sample program:

	#include <stdlib.h>
	#include <stdio.h>
	#include <stdint.h>
	#include <sys/fcntl.h>
	#include <sys/ioctl.h>

	struct smb3_full_key_debug_info {
	        uint32_t   in_size;
	        uint64_t   session_id;
	        uint16_t   cipher_type;
	        uint8_t    session_key_length;
	        uint8_t    server_in_key_length;
	        uint8_t    server_out_key_length;
	        uint8_t    data[];
	        /*
	         * return this struct with the keys appended at the end:
	         * uint8_t session_key[session_key_length];
	         * uint8_t server_in_key[server_in_key_length];
	         * uint8_t server_out_key[server_out_key_length];
	         */
	} __attribute__((packed));

	#define CIFS_IOCTL_MAGIC 0xCF
	#define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct smb3_full_ke=
y_debug_info)

	void dump(const void *p, size_t len) {
	        const char *hex =3D "0123456789ABCDEF";
	        const uint8_t *b =3D p;
	        for (int i =3D 0; i < len; i++)
	                printf("%c%c ", hex[(b[i]>>4)&0xf], hex[b[i]&0xf]);
	        putchar('\n');
	}

	int main(int argc, char **argv)
	{
	        struct smb3_full_key_debug_info *keys;
	        uint8_t buf[sizeof(*keys)+1024] =3D {0};
	        size_t off =3D 0;
	        int fd, rc;

	        keys =3D (struct smb3_full_key_debug_info *)&buf;
	        keys->in_size =3D sizeof(buf);

	        fd =3D open(argv[1], O_RDONLY);
	        if (fd < 0)
	                perror("open"), exit(1);

	        rc =3D ioctl(fd, CIFS_DUMP_FULL_KEY, keys);
	        if (rc < 0)
	                perror("ioctl"), exit(1);

	        printf("SessionId      ");
	        dump(&keys->session_id, 8);
	        printf("Cipher         %04x\n", keys->cipher_type);

	        printf("SessionKey     ");
	        dump(keys->data+off, keys->session_key_length);
	        off +=3D keys->session_key_length;

	        printf("ServerIn Key   ");
	        dump(keys->data+off, keys->server_in_key_length);
	        off +=3D keys->server_in_key_length;

	        printf("ServerOut Key  ");
	        dump(keys->data+off, keys->server_out_key_length);

	        return 0;
	}

Usage:

	$ gcc -o dumpkeys dumpkeys.c

Against Windows Server 2020 preview (with AES-256-GCM support):

	# mount.cifs //$ip/test /mnt -o "username=3Dadministrator,password=3Dfoo,v=
ers=3D3.0,seal"
	# ./dumpkeys /mnt/somefile
	SessionId      0D 00 00 00 00 0C 00 00
	Cipher         0002
	SessionKey     AB CD CC 0D E4 15 05 0C 6F 3C 92 90 19 F3 0D 25
	ServerIn Key   73 C6 6A C8 6B 08 CF A2 CB 8E A5 7D 10 D1 5B DC
	ServerOut Key  6D 7E 2B A1 71 9D D7 2B 94 7B BA C4 F0 A5 A4 F8
	# umount /mnt

	With 256 bit keys:

	# echo 1 > /sys/module/cifs/parameters/require_gcm_256
	# mount.cifs //$ip/test /mnt -o "username=3Dadministrator,password=3Dfoo,v=
ers=3D3.11,seal"
	# ./dumpkeys /mnt/somefile
	SessionId      09 00 00 00 00 0C 00 00
	Cipher         0004
	SessionKey     93 F5 82 3B 2F B7 2A 50 0B B9 BA 26 FB 8C 8B 03
	ServerIn Key   6C 6A 89 B2 CB 7B 78 E8 04 93 37 DA 22 53 47 DF B3 2C 5F 02=
 26 70 43 DB 8D 33 7B DC 66 D3 75 A9
	ServerOut Key  04 11 AA D7 52 C7 A8 0F ED E3 93 3A 65 FE 03 AD 3F 63 03 01=
 2B C0 1B D7 D7 E5 52 19 7F CC 46 B4

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifs_ioctl.h |  25 ++++++--
 fs/cifs/cifspdu.h    |   3 +-
 fs/cifs/ioctl.c      | 143 +++++++++++++++++++++++++++++++------------
 3 files changed, 126 insertions(+), 45 deletions(-)

diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index 4a97fe12006b..4b3d33b2838d 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -72,15 +72,28 @@ struct smb3_key_debug_info {
 } __packed;
=20
 /*
- * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
- * is needed if GCM256 (stronger encryption) negotiated
+ * Dump variable-sized keys
  */
 struct smb3_full_key_debug_info {
-	__u64	Suid;
+	/* INPUT: size of userspace buffer */
+	__u32   in_size;
+
+	/*
+	 * INPUT: 0 for current user, otherwise session to dump
+	 * OUTPUT: session id that was dumped
+	 */
+	__u64	session_id;
 	__u16	cipher_type;
-	__u8	auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
-	__u8	smb3encryptionkey[32]; /* SMB3_ENC_DEC_KEY_SIZE */
-	__u8	smb3decryptionkey[32]; /* SMB3_ENC_DEC_KEY_SIZE */
+	__u8    session_key_length;
+	__u8    server_in_key_length;
+	__u8    server_out_key_length;
+	__u8    data[];
+	/*
+	 * return this struct with the keys appended at the end:
+	 * __u8 session_key[session_key_length];
+	 * __u8 server_in_key[server_in_key_length];
+	 * __u8 server_out_key[server_out_key_length];
+	*/
 } __packed;
=20
 struct smb3_notify {
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index b53a87db282f..554d64fe171e 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -148,7 +148,8 @@
 #define SMB3_SIGN_KEY_SIZE (16)
=20
 /*
- * Size of the smb3 encryption/decryption keys
+ * Size of the smb3 encryption/decryption key storage.
+ * This size is big enough to store any cipher key types.
  */
 #define SMB3_ENC_DEC_KEY_SIZE (32)
=20
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 28ec8d7c521a..87b2f1309e6f 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -33,6 +33,7 @@
 #include "cifsfs.h"
 #include "cifs_ioctl.h"
 #include "smb2proto.h"
+#include "smb2glob.h"
 #include <linux/btrfs.h>
=20
 static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
@@ -214,48 +215,112 @@ static int cifs_shutdown(struct super_block *sb, uns=
igned long arg)
 	return 0;
 }
=20
-static int cifs_dump_full_key(struct cifs_tcon *tcon, unsigned long arg)
+static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key=
_debug_info __user* in)
 {
-	struct smb3_full_key_debug_info pfull_key_inf;
-	__u64 suid;
-	struct list_head *tmp;
+	struct smb3_full_key_debug_info out;
 	struct cifs_ses *ses;
+	int rc =3D 0;
 	bool found =3D false;
+	u8 __user *end;
=20
-	if (!smb3_encryption_required(tcon))
-		return -EOPNOTSUPP;
+	if (!smb3_encryption_required(tcon)) {
+		rc =3D -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* copy user input into our output buffer */
+	if (copy_from_user(&out, in, sizeof(out))) {
+		rc =3D -EINVAL;
+		goto out;
+	}
+
+	if (!out.session_id) {
+		/* if ses id is 0, use current user session */
+		ses =3D tcon->ses;
+	} else {
+		/* otherwise if a session id is given, look for it in all our sessions *=
/
+		struct cifs_ses *ses_it =3D NULL;
+		struct TCP_Server_Info *server_it =3D NULL;
=20
-	ses =3D tcon->ses; /* default to user id for current user */
-	if (get_user(suid, (__u64 __user *)arg))
-		suid =3D 0;
-	if (suid) {
-		/* search to see if there is a session with a matching SMB UID */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each(tmp, &tcon->ses->server->smb_ses_list) {
-			ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
-			if (ses->Suid =3D=3D suid) {
-				found =3D true;
-				break;
+		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
+			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
+				if (ses_it->Suid =3D=3D out.session_id) {
+					ses =3D ses_it;
+					/*
+					 * since we are using the session outside the crit
+					 * section, we need to make sure it won't be released
+					 * so increment its refcount
+					 */
+					ses->ses_count++;
+					found =3D true;
+					goto search_end;
+				}
 			}
 		}
+search_end:
 		spin_unlock(&cifs_tcp_ses_lock);
-		if (found =3D=3D false)
-			return -EINVAL;
-	} /* else uses default user's SMB UID (ie current user) */
-
-	pfull_key_inf.cipher_type =3D le16_to_cpu(ses->server->cipher_type);
-	pfull_key_inf.Suid =3D ses->Suid;
-	memcpy(pfull_key_inf.auth_key, ses->auth_key.response,
-	       16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
-	memcpy(pfull_key_inf.smb3decryptionkey, ses->smb3decryptionkey,
-	       32 /* SMB3_ENC_DEC_KEY_SIZE */);
-	memcpy(pfull_key_inf.smb3encryptionkey,
-	       ses->smb3encryptionkey, 32 /* SMB3_ENC_DEC_KEY_SIZE */);
-	if (copy_to_user((void __user *)arg, &pfull_key_inf,
-			 sizeof(struct smb3_full_key_debug_info)))
-		return -EFAULT;
+		if (!found) {
+			rc =3D -ENOENT;
+			goto out;
+		}
+	}
=20
-	return 0;
+	switch (ses->server->cipher_type) {
+	case SMB2_ENCRYPTION_AES128_CCM:
+	case SMB2_ENCRYPTION_AES128_GCM:
+		out.session_key_length =3D CIFS_SESS_KEY_SIZE;
+		out.server_in_key_length =3D out.server_out_key_length =3D SMB3_GCM128_C=
RYPTKEY_SIZE;
+		break;
+	case SMB2_ENCRYPTION_AES256_CCM:
+	case SMB2_ENCRYPTION_AES256_GCM:
+		out.session_key_length =3D CIFS_SESS_KEY_SIZE;
+		out.server_in_key_length =3D out.server_out_key_length =3D SMB3_GCM256_C=
RYPTKEY_SIZE;
+		break;
+	default:
+		rc =3D -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* check if user buffer is big enough to store all the keys */
+	if (out.in_size < sizeof(out) + out.session_key_length + out.server_in_ke=
y_length
+	    + out.server_out_key_length) {
+		rc =3D -ENOBUFS;
+		goto out;
+	}
+
+	out.session_id =3D ses->Suid;
+	out.cipher_type =3D le16_to_cpu(ses->server->cipher_type);
+
+	/* overwrite user input with our output */
+	if (copy_to_user(in, &out, sizeof(out))) {
+		rc =3D -EINVAL;
+		goto out;
+	}
+
+	/* append all the keys at the end of the user buffer */
+	end =3D in->data;
+	if (copy_to_user(end, ses->auth_key.response, out.session_key_length)) {
+		rc =3D -EINVAL;
+		goto out;
+	}
+	end +=3D out.session_key_length;
+
+	if (copy_to_user(end, ses->smb3encryptionkey, out.server_in_key_length)) =
{
+		rc =3D -EINVAL;
+		goto out;
+	}
+	end +=3D out.server_in_key_length;
+
+	if (copy_to_user(end, ses->smb3decryptionkey, out.server_out_key_length))=
 {
+		rc =3D -EINVAL;
+		goto out;
+	}
+
+out:
+	if (found)
+		cifs_put_smb_ses(ses);
+	return rc;
 }
=20
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long ar=
g)
@@ -371,6 +436,10 @@ long cifs_ioctl(struct file *filep, unsigned int comma=
nd, unsigned long arg)
 				rc =3D -EOPNOTSUPP;
 			break;
 		case CIFS_DUMP_KEY:
+			/*
+			 * Dump encryption keys. This is an old ioctl that only
+			 * handles AES-128-{CCM,GCM}.
+			 */
 			if (pSMBFile =3D=3D NULL)
 				break;
 			if (!capable(CAP_SYS_ADMIN)) {
@@ -398,11 +467,10 @@ long cifs_ioctl(struct file *filep, unsigned int comm=
and, unsigned long arg)
 			else
 				rc =3D 0;
 			break;
-		/*
-		 * Dump full key (32 bytes instead of 16 bytes) is
-		 * needed if GCM256 (stronger encryption) negotiated
-		 */
 		case CIFS_DUMP_FULL_KEY:
+			/*
+			 * Dump encryption keys (handles any key sizes)
+			 */
 			if (pSMBFile =3D=3D NULL)
 				break;
 			if (!capable(CAP_SYS_ADMIN)) {
@@ -410,8 +478,7 @@ long cifs_ioctl(struct file *filep, unsigned int comman=
d, unsigned long arg)
 				break;
 			}
 			tcon =3D tlink_tcon(pSMBFile->tlink);
-			rc =3D cifs_dump_full_key(tcon, arg);
-
+			rc =3D cifs_dump_full_key(tcon, (void __user *)arg);
 			break;
 		case CIFS_IOC_NOTIFY:
 			if (!S_ISDIR(inode->i_mode)) {
--=20
2.31.1

