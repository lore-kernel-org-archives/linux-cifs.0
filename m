Return-Path: <SRS0=mJ1i=RE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87563C43381
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Mar 2019 02:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5420520854
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Mar 2019 02:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfCACGL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 21:06:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64399 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfCACGK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Feb 2019 21:06:10 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23FAB30DBC0B;
        Fri,  1 Mar 2019 02:06:10 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-37.bne.redhat.com [10.64.54.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75F601001DD5;
        Fri,  1 Mar 2019 02:06:09 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] smbinfo: decode the ACEs
Date:   Fri,  1 Mar 2019 12:05:58 +1000
Message-Id: <20190301020558.16091-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 01 Mar 2019 02:06:10 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Decode the most common ACE types and provide a [-V]erbose option
to show the individual mask bits by name.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smbinfo.c   | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 smbinfo.rst |   5 +-
 2 files changed, 168 insertions(+), 34 deletions(-)

diff --git a/smbinfo.c b/smbinfo.c
index 02910c6..6b63f9d 100644
--- a/smbinfo.c
+++ b/smbinfo.c
@@ -52,10 +52,13 @@ struct smb_query_info {
 #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info)
 #define INPUT_BUFFER_LENGTH 16384
 
+int verbose;
+
 static void
 usage(char *name)
 {
-        fprintf(stderr, "Usage: %s <command> <file>\n"
+        fprintf(stderr, "Usage: %s [-V] <command> <file>\n"
+		"-V for verbose output\n"
                 "Commands are\n"
                 "  fileaccessinfo:\n"
                 "      Prints FileAccessInfo for a cifs file.\n"
@@ -148,11 +151,22 @@ struct bit_string file_access_mask[] = {
 static void
 print_bits(uint32_t mask, struct bit_string *bs)
 {
+        int first = 1;
+
+	if (!verbose) {
+		return;
+	}
+
         while (bs->string) {
-                if (mask & bs->bit)
-                    printf("%s ", bs->string);
+		if (mask & bs->bit) {
+			printf("%s%s", first?"":",", bs->string);
+			first = 0;
+		}
                 bs++;
         }
+	if (!first) {
+		printf(" ");
+	}
 }
 
 static void
@@ -591,17 +605,106 @@ print_sid(unsigned char *sd)
         for (i = 0; i < sd[1]; i++) {
                 memcpy(&subauth, &sd[8 + 4 * i], 4);
                 subauth = le32toh(subauth);
-                printf("-%d", subauth);
+                printf("-%u", subauth);
         }
 }
 
 static void
-print_acl(unsigned char *sd)
+print_ace_type(uint8_t t)
+{
+        switch(t) {
+	case 0x00: printf("ALLOWED"); break;
+	case 0x01: printf("DENIED"); break;
+	case 0x02: printf("AUDIT"); break;
+	case 0x03: printf("ALARM"); break;
+	case 0x04: printf("ALLOWED_COMPOUND"); break;
+	case 0x05: printf("ALLOWED_OBJECT"); break;
+	case 0x06: printf("DENIED_OBJECT"); break;
+	case 0x07: printf("AUDIT_OBJECT"); break;
+	case 0x08: printf("ALARM_OBJECT"); break;
+	case 0x09: printf("ALLOWED_CALLBACK"); break;
+	case 0x0a: printf("DENIED_CALLBACK"); break;
+	case 0x0b: printf("ALLOWED_CALLBACK_OBJECT"); break;
+	case 0x0c: printf("DENIED_CALLBACK_OBJECT"); break;
+	case 0x0d: printf("AUDIT_CALLBACK"); break;
+	case 0x0e: printf("ALARM_CALLBACK"); break;
+	case 0x0f: printf("AUDIT_CALLBACK_OBJECT"); break;
+	case 0x10: printf("ALARM_CALLBACK_OBJECT"); break;
+	case 0x11: printf("MANDATORY_LABEL"); break;
+	case 0x12: printf("RESOURCE_ATTRIBUTE"); break;
+	case 0x13: printf("SCOPED_POLICY_ID"); break;
+	default: printf("<UNKNOWN>");
+	}
+	printf(" ");
+}
+
+struct bit_string ace_flags_mask[] = {
+        { 0x80, "FAILED_ACCESS" },
+        { 0x40, "SUCCESSFUL_ACCESS" },
+        { 0x10, "INHERITED" },
+        { 0x08, "INHERIT_ONLY" },
+        { 0x04, "NO_PROPAGATE_INHERIT" },
+        { 0x02, "CONTAINER_INHERIT" },
+        { 0x01, "OBJECT_INHERIT" },
+        { 0, NULL }
+};
+
+static void
+print_mask_sid_ace(unsigned char *sd, int type)
+{
+        uint32_t u32;
+
+        memcpy(&u32, &sd[0], 4);
+	printf("Mask:0x%08x ", le32toh(u32));
+	if (type == S_IFDIR) {
+		print_bits(le32toh(u32), directory_access_mask);
+        } else {
+		print_bits(le32toh(u32), file_access_mask);
+	}
+	printf("SID:");
+	print_sid(&sd[4]);
+	printf("\n");
+}
+
+static int
+print_ace(unsigned char *sd, int type)
+{
+        uint16_t size;
+	int i;
+
+	printf("Type:0x%02x ", sd[0]);
+	if (verbose) {
+		print_ace_type(sd[0]);
+	}
+
+	printf("Flags:0x%02x ", sd[1]);
+	print_bits(sd[1], ace_flags_mask);
+
+	memcpy(&size, &sd[2], 2);
+	size = le16toh(size);
+
+	switch (sd[0]) {
+	case 0x00:
+	case 0x01:
+	case 0x02:
+		print_mask_sid_ace(&sd[4], type);
+		break;
+	default:
+		for (i = 0; i < size; i++)
+			printf("%02x", sd[4 + i]);
+	}
+
+	printf("\n");
+	return size;
+}
+
+static void
+print_acl(unsigned char *sd, int type)
 {
-        int i, j, off;
-        uint16_t count, size;
+        int i, off;
+        uint16_t count;
 
-        if (sd[0] != 2) {
+        if ((sd[0] != 2) && (sd[0] != 4)) {
                 fprintf(stderr, "Unknown ACL revision\n");
                 return;
         }
@@ -610,22 +713,43 @@ print_acl(unsigned char *sd)
         count = le16toh(count);
         off = 8;
         for (i = 0; i < count; i++) {
-                printf("Type:%02x Flags:%02x ", sd[off], sd[off + 1]);
-                memcpy(&size, &sd[off + 2], 2);
-                size = le16toh(size);
+		off += print_ace(&sd[off], type);
+        }
+}
 
-                for (j = 0; j < size; j++)
-                        printf("%02x", sd[off + 4 + j]);
+struct bit_string control_bits_mask[] = {
+        { 0x8000, "SR" },
+        { 0x4000, "RM" },
+        { 0x2000, "PS" },
+        { 0x1000, "PD" },
+        { 0x0800, "SI" },
+        { 0x0400, "DI" },
+        { 0x0200, "SC" },
+        { 0x0100, "DC" },
+        { 0x0080, "DT" },
+        { 0x0040, "SS" },
+        { 0x0020, "SD" },
+        { 0x0010, "SP" },
+        { 0x0008, "DD" },
+        { 0x0004, "DP" },
+        { 0x0002, "GD" },
+        { 0x0001, "OD" },
+        { 0, NULL }
+};
 
-                off += size;
-                printf("\n");
-        }
+static void
+print_control(uint16_t c)
+{
+	printf("Control: 0x%04x ", c);
+	print_bits(c, control_bits_mask);
+	printf("\n");
 }
 
 static void
-print_sd(uint8_t *sd)
+print_sd(uint8_t *sd, int type)
 {
         int offset_owner, offset_group, offset_dacl;
+	uint16_t u16;
 
         printf("Revision:%d\n", sd[0]);
         if (sd[0] != 1) {
@@ -633,7 +757,8 @@ print_sd(uint8_t *sd)
                 exit(1);
         }
 
-        printf("Control: %02x%02x\n", sd[2], sd[3]);
+        memcpy(&u16, &sd[2], 2);
+        print_control(le16toh(u16));
 
         memcpy(&offset_owner, &sd[4], 4);
         offset_owner = le32toh(offset_owner);
@@ -654,7 +779,7 @@ print_sd(uint8_t *sd)
         }
         if (offset_dacl) {
                 printf("DACL:\n");
-                print_acl(&sd[offset_dacl]);
+                print_acl(&sd[offset_dacl], type);
         }
 }
 
@@ -662,6 +787,9 @@ static void
 secdesc(int f)
 {
         struct smb_query_info *qi;
+        struct stat st;
+
+        fstat(f, &st);
 
         qi = malloc(sizeof(struct smb_query_info) + INPUT_BUFFER_LENGTH);
         memset(qi, 0, sizeof(qi) + INPUT_BUFFER_LENGTH);
@@ -675,7 +803,7 @@ secdesc(int f)
                 exit(1);
         }
 
-        print_sd((uint8_t *)(&qi[1]));
+        print_sd((uint8_t *)(&qi[1]), st.st_mode & S_IFMT);
         free(qi);
 }
 
@@ -777,11 +905,14 @@ int main(int argc, char *argv[])
         int c;
         int f;
 
-        while ((c = getopt_long(argc, argv, "v", NULL, NULL)) != -1) {
+        while ((c = getopt_long(argc, argv, "vV", NULL, NULL)) != -1) {
                 switch (c) {
                 case 'v':
                         printf("smbinfo version %s\n", VERSION);
                         return 0;
+                case 'V':
+			verbose = 1;
+			break;
                 default:
                         usage(argv[0]);
                 }
@@ -796,29 +927,29 @@ int main(int argc, char *argv[])
         }
 
 
-        if (!strcmp(argv[1], "fileaccessinfo"))
+        if (!strcmp(argv[optind], "fileaccessinfo"))
                 fileaccessinfo(f);
-        else if (!strcmp(argv[1], "filealigninfo"))
+        else if (!strcmp(argv[optind], "filealigninfo"))
                 filealigninfo(f);
-        else if (!strcmp(argv[1], "fileallinfo"))
+        else if (!strcmp(argv[optind], "fileallinfo"))
                 fileallinfo(f);
-        else if (!strcmp(argv[1], "filebasicinfo"))
+        else if (!strcmp(argv[optind], "filebasicinfo"))
                 filebasicinfo(f);
-        else if (!strcmp(argv[1], "fileeainfo"))
+        else if (!strcmp(argv[optind], "fileeainfo"))
                 fileeainfo(f);
-        else if (!strcmp(argv[1], "filefsfullsizeinfo"))
+        else if (!strcmp(argv[optind], "filefsfullsizeinfo"))
                 filefsfullsizeinfo(f);
-        else if (!strcmp(argv[1], "fileinternalinfo"))
+        else if (!strcmp(argv[optind], "fileinternalinfo"))
                 fileinternalinfo(f);
-        else if (!strcmp(argv[1], "filemodeinfo"))
+        else if (!strcmp(argv[optind], "filemodeinfo"))
                 filemodeinfo(f);
-        else if (!strcmp(argv[1], "filepositioninfo"))
+        else if (!strcmp(argv[optind], "filepositioninfo"))
                 filepositioninfo(f);
-        else if (!strcmp(argv[1], "filestandardinfo"))
+        else if (!strcmp(argv[optind], "filestandardinfo"))
                 filestandardinfo(f);
-        else if (!strcmp(argv[1], "secdesc"))
+        else if (!strcmp(argv[optind], "secdesc"))
                 secdesc(f);
-        else if (!strcmp(argv[1], "quota"))
+        else if (!strcmp(argv[optind], "quota"))
                 quota(f);
         else {
                 fprintf(stderr, "Unknown command %s\n", argv[optind]);
diff --git a/smbinfo.rst b/smbinfo.rst
index 5222a71..9bfd313 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -11,7 +11,7 @@ Userspace helper to display SMB-specific file information for the Linux SMB clie
 SYNOPSIS
 ********
 
-  smbinfo [-v] {command} {file system object}
+  smbinfo [-v] [-V] {command} {file system object}
 
 ***********
 DESCRIPTION
@@ -35,6 +35,9 @@ OPTIONS
 -v
   Print version number and exit.
 
+-V
+  Verbose output.
+
 *******
 COMMAND
 *******
-- 
2.15.1

