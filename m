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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B36C47076
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF47260698
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhEUPbL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 11:31:11 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:51307 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232010AbhEUPbK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 May 2021 11:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621610986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zGSkuNKFP3D2PWSDBtHEQDDjKw4lT/w1XPR9+3VtUN4=;
        b=gS7inGCO+z8gdkRUZ34Q3hqTAv7uN1mn6DoraujK10yn2oDeaanWrrW12VcIDpvGmlwDNL
        J/WoX6BhUPtkufw+RXkbodxTSmsCqcL4edPu0No0cVS8f8RiIJAFqw94wIh+vnqQ+2J80E
        NRa5RTuVSrdm/zDKdd9bnkyVV2DHnv0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-wYQSaZMJMUK6FfOnQMyGsA-1; Fri, 21 May 2021 17:29:45 +0200
X-MC-Unique: wYQSaZMJMUK6FfOnQMyGsA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yq/o85gO8oT9/c5RS+EwCir1gppe0smGYtEWi0jgJbvGW6p1drGC05i6w/yv68AiCapos9lCxlLPiB3GWk2BM10V7+1WT9IKCdoc1fM2DHyRmqNwV56qnAKpwmver3AcowFbiQR40iPId7yH9P8N27jqPOzqt77nSUvgeKPvuUIcM58JBAYNazb9d1TP7EN7ne0n9BV7GrQT2Vk4jbGgQGFD0YL4JLPHOOvXHzNsGMu6tQ62wmLKZ/1kFVgoMk2ugemhqxO60wnqpEi2fNf594whnPMLmSWtHq+hZ3kr6Tks07pNKUgGyRnqR5k0uPhjjv0ZfvnmrywJTN0+z9OBBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOI2jeSeOlGm65uxj10kXakf+poeQt7WK+HxUZiGJAU=;
 b=X1DWtHspgHGEnoS1fd2v7qK8SAxar0EPh2pbMOd3PIdR03C3fo3dblVFHrt0Ny8s0ghodYfbfO6iWqTFrK91zMQwhOzLtJGJD0DEw4GomezvzB0PZtGACmn+UNV56jKz0/fcvuVX/iM71W7UmDD+oSrsds8NtsfLyrOIc/iXAkZ7euFQXay0QBj2JQAIqeegQb4z7O4JZtTutmyUrdDdTRQAGOcDokgD+zgsCDsTNKvaw+wmlNdI2MtYBWMC5kIMRK/oTcvcGYShxsYqNq4RZA13SWyxAou/tcc1m3GOMsrBRZDQ4T2pd2AetRP2KuKDFcHJw3kGDjyeu+/7jMKf0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6909.eurprd04.prod.outlook.com (2603:10a6:803:13d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 15:29:44 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 15:29:44 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, piastryyy@gmail.com,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH cifs-utils] smbinfo: add support for new key dump ioctl
Date:   Fri, 21 May 2021 17:29:40 +0200
Message-ID: <20210521152940.23072-1-aaptel@suse.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:713:d396:524:65d3:25:9e8c]
X-ClientProxiedBy: ZRAP278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::12) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d396:524:65d3:25:9e8c) by ZRAP278CA0002.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 15:29:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 476a4147-464a-4efb-8710-08d91c6d423a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6909B9E0C81D3E59E021B6E0A8299@VI1PR04MB6909.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZsbd1yJcLj9d7FMx/deAbSQLgCdBDhvT1eFGuE86MbJU3WwLCpfxgXzUvOpaIuW2NtR7CezfdIpH279aYHRqtgX3moJU4NpPJL+W6mT527iNZVDYl0ZmH1BindgFuwKlCuepBs5X5LoEGk/xuMq7ADb7YTCCibfibIhMt201RRFi2aeiRdcB+fvUHwYHjCUbD2KzcPV78u6ZjZxT+ojQD+H0O1YvUsJ0zYyKqxoZurguzkJ7LtybiPzjKcgTxfCi00cWZEpme6pK2fnK1/PuzyQFYBMWqP5gu1lfFBm+wUBMITzcPWLf1Rwqaj6272tLQwE1hPepRHVn92H+Ayg818ZIB6Rvvn8HQGB5DWeYeBEDmC1M4vCuG0CZu2L8qnwmHv2149HSrc8pXdp9q6qEYh3icKZFF/sl7v6noHjnCXixL8MGAcORH6UCZKKS0V4ACoBD3mcFGxqeikES2ffMCjUkuRSMHkP8Fx3ChnZjgT1z9VGdQRP1Wx0Nl1ehZLsxkUS51AaHLxHj5eSNvmx9/zeuWRqbhd9dKrMDR/SLTYqtJVLhEZVYTK7GLcQ7bGukDzGvQajA7J1Voo001sDVRCZOGOYYby8DPdwio/VynsKBZiKrXVI5rnsa+0Z6I2Np/So5OLx3KkPMR7mOddC6IkxL/05gyOiYsv7Me7JwbJfmA1XdHpJzgT686ZY6mBC3ZsxEVSc3ZOFJKmj/2b5s3YwiVb7kayUUdFI0hlF4R2sfyhxNd5i4+KOgfqVtQ2Kf89gJKzY6zjxGdA5bmyLriJwQzD+xGfgtQO3vi9WpoW7DgLDaPyb/UiIIH7PRW/uhsf/gp/glbF10zSoE2YKroOZoDiAAto2uvG5Jul0WOiv0PZjKR32e1pb7uhfafkrehF/uSaZQDxxbVXlk+fR3f8kOkzBnC4lOytaVvuk3z9+OURaAzsANNsJHp3pGhG0+8c
 O+/gsXiONSvNASaGhRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(346002)(366004)(136003)(376002)(39860400002)(396003)(6916009)(16526019)(66946007)(186003)(66476007)(6486002)(66556008)(2906002)(52116002)(36756003)(1076003)(8936002)(8676002)(38100700002)(83380400001)(6496006)(478600001)(4326008)(86362001)(5660300002)(107886003)(2616005)(316002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vAsxLSujZy2epfHFEsWx/lkDR73uEFHH5qBDYEEnXTBWro98iUbJEAb4mAF+?=
 =?us-ascii?Q?BFledbJNp6itH5Yd1B55ARqPFwnrCqghz/62vidC8Jm1KAqVRtes1X8pEcol?=
 =?us-ascii?Q?pbh2YwSSBCtihrJtcryMMe8ggucC4CAuy0otzgQF2bTkoxzT9C+cTI60CH8F?=
 =?us-ascii?Q?6ydBpS7S9qBoS7UqfPDHmAX6skjv419aIjimY2BIPHXxTSSj4qJ8bYlzSHwa?=
 =?us-ascii?Q?LSeS2XzZRoR/uIHV+Xr52MjX+C70kvlyIxcLrY+JhpzAznskv0DojPNjuyRL?=
 =?us-ascii?Q?uprf117JP8JtDQLCLsgm9rZpRLaJ+zfo9yHDTjKW7PGyqOn3J9O1bo63Q7tn?=
 =?us-ascii?Q?Cuqio5QHaMfY43qDOHKztntnccdloa+H5SMWD/O+YrqfMV88GzwlZwORBdFL?=
 =?us-ascii?Q?AONb4bhTCXEwHfbBQldtmKkPvjoSRojQZv0MhZXXsWfpO4JKcU30ECDqf1Di?=
 =?us-ascii?Q?rP1sf4TY0orm/oh3Kokp9fAy5pRErtZPaB3pgM2pevQsOCRTzkX5GpAqnL4k?=
 =?us-ascii?Q?NK833RvmpI9hgPirxeF9tFmYeNUTA8zZbnf5W++0ynrGhftpQoP4NASvJW3a?=
 =?us-ascii?Q?WMv8L3OGtSDKv+K5IZe+ZsIO0QVr62wt4yPQEx5atW2FcfQvUEtk/9kQdAxS?=
 =?us-ascii?Q?T5aVQY7A+cs7qY3SZ5tGiEFtZNYH9yvibp4JVptdn+bbQ7YBJvwy1vDwfAJD?=
 =?us-ascii?Q?92OBNYR3B7Q5t3D6lrNJWYJuzPi1Fd1IzM+5oO9fuNwY5aHDqYkAjzwePVVj?=
 =?us-ascii?Q?R9kuyv/LQEPko9TRhqlobGXuumqfnDEtSf58ich3qj3prjEVZqapE6yScyO/?=
 =?us-ascii?Q?d5zQaxmo17iUGR4qMpuYmInjFsMoaORYfeoQ5d0dXZdDtRxmD498Ff5WoEQM?=
 =?us-ascii?Q?PQR0dFeGOlQ8I1GEdL2ismR21LEMrtKN8aa9z+1oyK33XQChKszenOeDdqya?=
 =?us-ascii?Q?F1FbHUNyZ8EQWsZTG0rzCDDou2Qkycql3CocFd/StTbxWGk2lz074ZfcqC9U?=
 =?us-ascii?Q?LLKhaAWug9ahC86xZ1I2wsLDI7hKeRmKl/mKw6klFCUmu67xkN25Ms7uSmsS?=
 =?us-ascii?Q?ENwoZSlxyXm/rclkitDwz/t+59QeRm4C74A3Cf+cHS7WbRCyqXh/rEBtcEFP?=
 =?us-ascii?Q?nFx19pTC7mxFiRpfoYzmirVoF1Qm5+8yePOrRlDETh4B25agae8lItJpbZ5j?=
 =?us-ascii?Q?JT/0N7XKQr7gzBJ1edoZDcU6Q/91cVKgCcOskDtDeRR3dRR5oAMcCkX3RcBs?=
 =?us-ascii?Q?F8xfAc/qDGcSbW/UHFyAH8+rA3QYTI9GPNKNaKCBYam0iIQMThlx+V1/mE9v?=
 =?us-ascii?Q?km6UW5eb+R92JXDvLywJO8PKcMqNxnJKiEIsaD6RV3KkU1owr4vIpprGDNeV?=
 =?us-ascii?Q?VdOh0vo=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 476a4147-464a-4efb-8710-08d91c6d423a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 15:29:43.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dn8Tncj+uucVHeG1acdPr7EjVOYtOQ7bPvP8kIZf1xI8EfxLnb2XzneXRXSM+4bs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6909
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

* try new one first, fall back on old one otherwise =3D> retrocompatible
* use better cipher descriptions

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 smbinfo | 79 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 63 insertions(+), 16 deletions(-)

diff --git a/smbinfo b/smbinfo
index b96fdbc..73c5bb3 100755
--- a/smbinfo
+++ b/smbinfo
@@ -34,6 +34,7 @@ VERBOSE =3D False
 CIFS_QUERY_INFO          =3D 0xc018cf07
 CIFS_ENUMERATE_SNAPSHOTS =3D 0x800ccf06
 CIFS_DUMP_KEY            =3D 0xc03acf08
+CIFS_DUMP_FULL_KEY       =3D 0xc011cf0a
=20
 # large enough input buffer length
 INPUT_BUFFER_LENGTH =3D 16384
@@ -192,9 +193,11 @@ ACE_FLAGS =3D [
 ]
=20
 CIPHER_TYPES =3D [
-    (0x00, "SMB3.0 CCM encryption"),
-    (0x01, "CCM encryption"),
-    (0x02, "GCM encryption"),
+    (0x00, "AES-128-CCM"),
+    (0x01, "AES-128-CCM"),
+    (0x02, "AES-128-GCM"),
+    (0x03, "AES-256-CCM"),
+    (0x04, "AES-256-GCM"),
 ]
=20
 def main():
@@ -799,35 +802,79 @@ class KeyDebugInfoStruct:
     def __init__(self):
         self.suid =3D bytearray()
         self.cipher =3D 0
-        self.auth_key =3D bytearray()
+        self.session_key =3D bytearray()
         self.enc_key =3D bytearray()
         self.dec_key =3D bytearray()
=20
     def ioctl(self, fd):
         buf =3D bytearray()
         buf.extend(struct.pack("=3D 8s H 16s 16s 16s", self.suid, self.cip=
her,
-                               self.auth_key, self.enc_key, self.dec_key))
+                               self.session_key, self.enc_key, self.dec_ke=
y))
         fcntl.ioctl(fd, CIFS_DUMP_KEY, buf, True)
-        (self.suid, self.cipher, self.auth_key,
+        (self.suid, self.cipher, self.session_key,
          self.enc_key, self.dec_key) =3D struct.unpack_from('=3D 8s H 16s =
16s 16s', buf, 0)
=20
+class FullKeyDebugInfoStruct:
+    def __init__(self):
+        # lets pick something large to be future proof
+        # 17 + 3*32 would be strict minimum as of linux 5.13
+        self.in_size =3D 1024
+        self.suid =3D bytearray()
+        self.cipher =3D 0
+        self.session_key_len =3D 0
+        self.server_in_key_len =3D 0
+        self.server_out_key_len =3D 0
+
+    def ioctl(self, fd):
+        fmt =3D "=3D I 8s H B B B"
+        size =3D struct.calcsize(fmt)
+        buf =3D bytearray()
+        buf.extend(struct.pack(fmt, self.in_size, self.suid, self.cipher,
+                               self.session_key_len, self.server_in_key_le=
n, self.server_out_key_len))
+        buf.extend(bytearray(self.in_size-size))
+        fcntl.ioctl(fd, CIFS_DUMP_FULL_KEY, buf, True)
+        (self.in_size, self.suid, self.cipher,
+         self.session_key_len, self.server_in_key_len,
+         self.server_out_key_len) =3D struct.unpack_from(fmt, buf, 0)
+
+        end =3D size
+        self.session_key =3D buf[end:end+self.session_key_len]
+        end +=3D self.session_key_len
+        self.server_in_key =3D buf[end:end+self.server_in_key_len]
+        end +=3D self.server_in_key_len
+        self.server_out_key =3D buf[end:end+self.server_out_key_len]
+
 def bytes_to_hex(buf):
     return " ".join(["%02x"%x for x in buf])
=20
 def cmd_keys(args):
-    kd =3D KeyDebugInfoStruct()
+    fd =3D os.open(args.file, os.O_RDONLY)
+    kd =3D FullKeyDebugInfoStruct()
+
     try:
-        fd =3D os.open(args.file, os.O_RDONLY)
+        # try new call first
         kd.ioctl(fd)
     except Exception as e:
-        print("syscall failed: %s"%e)
-        return False
-
-    print("Session Id: %s"%bytes_to_hex(kd.suid))
-    print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=3DTrue=
))
-    print("Session Key: %s"%bytes_to_hex(kd.auth_key))
-    print("Encryption key: %s"%bytes_to_hex(kd.enc_key))
-    print("Decryption key: %s"%bytes_to_hex(kd.dec_key))
+        # new failed, try old call
+        kd =3D KeyDebugInfoStruct()
+        try:
+            kd.ioctl(fd)
+        except Exception as e:
+            # both new and old call failed
+            print("syscall failed: %s"%e)
+            return False
+        print("Session Id: %s"%bytes_to_hex(kd.suid))
+        print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=3D=
True))
+        print("Session Key: %s"%bytes_to_hex(kd.session_key))
+        print("Encryption key: %s"%bytes_to_hex(kd.enc_key))
+        print("Decryption key: %s"%bytes_to_hex(kd.dec_key))
+    else:
+        # no exception, new call succeeded
+        print("Session Id: %s"%bytes_to_hex(kd.suid))
+        print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=3D=
True))
+        print("Session Key: %s"%bytes_to_hex(kd.session_key))
+        print("ServerIn  Key: %s"%bytes_to_hex(kd.server_in_key))
+        print("ServerOut key: %s"%bytes_to_hex(kd.server_out_key))
=20
 if __name__ =3D=3D '__main__':
     main()
--=20
2.31.1

