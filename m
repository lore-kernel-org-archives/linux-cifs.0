Return-Path: <SRS0=hrCW=42=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC451C10F29
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Mar 2020 16:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C68E8208C3
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Mar 2020 16:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="MIxpCUTh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCIQDl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Mar 2020 12:03:41 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.194]:24053 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbgCIQDk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Mar 2020 12:03:40 -0400
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2020 12:03:39 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id D7EA1E8F7F
        for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2020 10:41:44 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BKXIjNoVNRP4zBKXIjkK4M; Mon, 09 Mar 2020 10:41:44 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O53dB5ETwz7n/9q8r/0WJyznrRV+l3KzCKxDBLopKhE=; b=MIxpCUThmaDEEsQo0BX+us+fHq
        hYNSAO5QWgVpqUOiEjn+6+GzfOrOi5nLRq+PJa55P0X9wFyeEi8O7D82iq56qcOM1kP2ve4Q5WF1o
        yvWT64gIj3ENwnjUpF9kxNzn+BSPiOcXfAiKoHKQvVrBi0C6axaSBFb+IhLCAy/WfGFxeIzWKMPEx
        +BWQBopZVHt3ykE6KBS8wwHnbUMN4RK2vJMAmYqbepGUM+Mn6VC7HRg08l31V/WBwMunSzLiMqsSP
        9YSPedcB3IgmWNlA8GI8StcgcH9REY6M2iNaK9NlyKxE5F0AHWBaxsMJOUhUurkhu1/nfZU6LX73/
        PnMu/6+g==;
Received: from [201.162.240.150] (port=7078 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jBKXF-002uHv-5C; Mon, 09 Mar 2020 10:41:43 -0500
Date:   Mon, 9 Mar 2020 10:44:51 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] cifs: smb2pdu.h: Replace zero-length array with
 flexible-array member
Message-ID: <20200309154451.GA31357@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.240.150
X-Source-L: No
X-Exim-ID: 1jBKXF-002uHv-5C
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.150]:7078
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/cifs/smb2pdu.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index ad14b8505b4d..817bc0531536 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -182,7 +182,7 @@ struct smb2_symlink_err_rsp {
 	__le16 PrintNameOffset;
 	__le16 PrintNameLength;
 	__le32 Flags;
-	__u8  PathBuffer[0];
+	__u8  PathBuffer[];
 } __packed;
 
 /* SMB 3.1.1 and later dialects. See MS-SMB2 section 2.2.2.1 */
@@ -210,7 +210,7 @@ struct share_redirect_error_context_rsp {
 	__le16 Flags;
 	__le16 TargetType;
 	__le32 IPAddrCount;
-	struct move_dst_ipaddr IpAddrMoveList[0];
+	struct move_dst_ipaddr IpAddrMoveList[];
 	/* __u8 ResourceName[] */ /* Name of share as counted Unicode string */
 } __packed;
 
@@ -326,7 +326,7 @@ struct smb2_netname_neg_context {
 	__le16	ContextType; /* 0x100 */
 	__le16	DataLength;
 	__le32	Reserved;
-	__le16	NetName[0]; /* hostname of target converted to UCS-2 */
+	__le16	NetName[]; /* hostname of target converted to UCS-2 */
 } __packed;
 
 #define POSIX_CTXT_DATA_LEN	16
@@ -421,13 +421,13 @@ struct tree_connect_contexts {
 	__le16 ContextType;
 	__le16 DataLength;
 	__le32 Reserved;
-	__u8   Data[0];
+	__u8   Data[];
 } __packed;
 
 /* Remoted identity tree connect context structures - see MS-SMB2 2.2.9.2.1 */
 struct smb3_blob_data {
 	__le16 BlobSize;
-	__u8   BlobData[0];
+	__u8   BlobData[];
 } __packed;
 
 /* Valid values for Attr */
@@ -477,14 +477,14 @@ struct remoted_identity_tcon_context {
 	__le16 DeviceGroups; /* offset to SID_ARRAY_DATA struct */
 	__le16 UserClaims; /* offset to BLOB_DATA struct */
 	__le16 DeviceClaims; /* offset to BLOB_DATA struct */
-	__u8   TicketInfo[0]; /* variable length buf - remoted identity data */
+	__u8   TicketInfo[]; /* variable length buf - remoted identity data */
 } __packed;
 
 struct smb2_tree_connect_req_extension {
 	__le32 TreeConnectContextOffset;
 	__le16 TreeConnectContextCount;
 	__u8  Reserved[10];
-	__u8  PathName[0]; /* variable sized array */
+	__u8  PathName[]; /* variable sized array */
 	/* followed by array of TreeConnectContexts */
 } __packed;
 
@@ -689,7 +689,7 @@ struct smb2_create_req {
 	__le16 NameLength;
 	__le32 CreateContextsOffset;
 	__le32 CreateContextsLength;
-	__u8   Buffer[0];
+	__u8   Buffer[];
 } __packed;
 
 /*
@@ -727,7 +727,7 @@ struct create_context {
 	__le16 Reserved;
 	__le16 DataOffset;
 	__le32 DataLength;
-	__u8 Buffer[0];
+	__u8 Buffer[];
 } __packed;
 
 #define SMB2_LEASE_READ_CACHING_HE	0x01
@@ -869,7 +869,7 @@ struct crt_sd_ctxt {
 struct resume_key_req {
 	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
 	__le32	ContextLength;	/* MBZ */
-	char	Context[0];	/* ignored, Windows sets to 4 bytes of zero */
+	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
 } __packed;
 
 /* this goes in the ioctl buffer when doing a copychunk request */
@@ -931,7 +931,7 @@ struct reparse_data_buffer {
 	__le32	ReparseTag;
 	__le16	ReparseDataLength;
 	__u16	Reserved;
-	__u8	DataBuffer[0]; /* Variable Length */
+	__u8	DataBuffer[]; /* Variable Length */
 } __packed;
 
 struct reparse_guid_data_buffer {
@@ -939,7 +939,7 @@ struct reparse_guid_data_buffer {
 	__le16	ReparseDataLength;
 	__u16	Reserved;
 	__u8	ReparseGuid[16];
-	__u8	DataBuffer[0]; /* Variable Length */
+	__u8	DataBuffer[]; /* Variable Length */
 } __packed;
 
 struct reparse_mount_point_data_buffer {
@@ -950,7 +950,7 @@ struct reparse_mount_point_data_buffer {
 	__le16	SubstituteNameLength;
 	__le16	PrintNameOffset;
 	__le16	PrintNameLength;
-	__u8	PathBuffer[0]; /* Variable Length */
+	__u8	PathBuffer[]; /* Variable Length */
 } __packed;
 
 #define SYMLINK_FLAG_RELATIVE 0x00000001
@@ -964,7 +964,7 @@ struct reparse_symlink_data_buffer {
 	__le16	PrintNameOffset;
 	__le16	PrintNameLength;
 	__le32	Flags;
-	__u8	PathBuffer[0]; /* Variable Length */
+	__u8	PathBuffer[]; /* Variable Length */
 } __packed;
 
 /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
@@ -1066,7 +1066,7 @@ struct smb2_ioctl_req {
 	__le32 MaxOutputResponse;
 	__le32 Flags;
 	__u32  Reserved2;
-	__u8   Buffer[0];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_ioctl_rsp {
@@ -1469,7 +1469,7 @@ struct smb3_fs_vol_info {
 	__le32	VolumeLabelLength; /* includes trailing null */
 	__u8	SupportsObjects; /* True if eg like NTFS, supports objects */
 	__u8	Reserved;
-	__u8	VolumeLabel[0]; /* variable len */
+	__u8	VolumeLabel[]; /* variable len */
 } __packed;
 
 /* partial list of QUERY INFO levels */
@@ -1531,7 +1531,7 @@ struct smb2_file_rename_info { /* encoding of request for level 10 */
 	__u8   Reserved[7];
 	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
 	__le32 FileNameLength;
-	char   FileName[0];     /* New name to be assigned */
+	char   FileName[];     /* New name to be assigned */
 } __packed; /* level 10 Set */
 
 struct smb2_file_link_info { /* encoding of request for level 11 */
@@ -1540,7 +1540,7 @@ struct smb2_file_link_info { /* encoding of request for level 11 */
 	__u8   Reserved[7];
 	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
 	__le32 FileNameLength;
-	char   FileName[0];     /* Name to be assigned to new link */
+	char   FileName[];     /* Name to be assigned to new link */
 } __packed; /* level 11 Set */
 
 struct smb2_file_full_ea_info { /* encoding of response for level 15 */
@@ -1548,7 +1548,7 @@ struct smb2_file_full_ea_info { /* encoding of response for level 15 */
 	__u8   flags;
 	__u8   ea_name_length;
 	__le16 ea_value_length;
-	char   ea_data[0]; /* \0 terminated name plus value */
+	char   ea_data[]; /* \0 terminated name plus value */
 } __packed; /* level 15 Set */
 
 /*
-- 
2.25.0

