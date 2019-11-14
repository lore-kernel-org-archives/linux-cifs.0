Return-Path: <SRS0=ILFa=ZG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45D3C43141
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 17:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA5C20718
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 17:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R0MRDtUC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfKNR4D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Nov 2019 12:56:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30905 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726473AbfKNR4C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Nov 2019 12:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573754161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gJ2lp0m+sLZX24RNjuIddwIM1kRXXv9PEcfkabM6vJI=;
        b=R0MRDtUCnDJQsMj2AjcI6k5WnWcmgONu1WonAFKkLB8zLKuipBDdvc+GuwklPycudtMWe/
        vS2YgTSBzBBudTqROYpsxbGmR0tl8Surg2gOWquq/j72I5A5HCUMXdvsR6sCDI+2EvO8Wu
        eEV+VKbe/LB9Rq9g04OLjzxovc+9C9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-Nfv0U0KqN7qG73e73prdhQ-1; Thu, 14 Nov 2019 12:55:56 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF826107B01D;
        Thu, 14 Nov 2019 17:55:55 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.0.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65EA860BF1;
        Thu, 14 Nov 2019 17:55:54 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, smfrench@gmail.com, lsahlber@redhat.com
Subject: [PATCH] Add program name to error output instead of static mount.cifs
Date:   Thu, 14 Nov 2019 23:25:51 +0530
Message-Id: <20191114175551.18805-1-kdsouza@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: Nfv0U0KqN7qG73e73prdhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As we are supporting mount.smb3 to be invoked, the error output
should contain the called program and not mount.cifs

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 mount.cifs.c | 56 ++++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 0ed9d0a..40918c1 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -194,7 +194,7 @@ struct parsed_mount_info {
 static const char *thisprogram;
 static const char *cifs_fstype;
=20
-static int parse_unc(const char *unc_name, struct parsed_mount_info *parse=
d_info);
+static int parse_unc(const char *unc_name, struct parsed_mount_info *parse=
d_info, const char *progname);
=20
 static int check_setuid(void)
 {
@@ -206,7 +206,7 @@ static int check_setuid(void)
=20
 #if CIFS_DISABLE_SETUID_CAPABILITY
 =09if (getuid() && !geteuid()) {
-=09=09printf("This mount.cifs program has been built with the "
+=09=09printf("This program has been built with the "
 =09=09       "ability to run as a setuid root program disabled.\n");
 =09=09return EX_USAGE;
 =09}
@@ -301,7 +301,7 @@ static int mount_usage(FILE * stream)
 =09=09"\n\tbsize=3D<size>");
 =09fprintf(stream,
 =09=09"\n\nOptions are described in more detail in the manual page");
-=09fprintf(stream, "\n\tman 8 mount.cifs\n");
+=09fprintf(stream, "\n\tman 8 %s\n", thisprogram);
 =09fprintf(stream, "\nTo display the version number of the mount helper:")=
;
 =09fprintf(stream, "\n\t%s -V\n", thisprogram);
=20
@@ -636,7 +636,7 @@ return_i:
=20
 static int
 get_password_from_file(int file_descript, char *filename,
-=09=09       struct parsed_mount_info *parsed_info)
+=09=09       struct parsed_mount_info *parsed_info, const char *program)
 {
 =09int rc =3D 0;
 =09char buf[sizeof(parsed_info->password) + 1];
@@ -649,8 +649,8 @@ get_password_from_file(int file_descript, char *filenam=
e,
 =09=09rc =3D access(filename, R_OK);
 =09=09if (rc) {
 =09=09=09fprintf(stderr,
-=09=09=09=09"mount.cifs failed: access check of %s failed: %s\n",
-=09=09=09=09filename, strerror(errno));
+=09=09=09=09"%s failed: access check of %s failed: %s\n",
+=09=09=09=09program, filename, strerror(errno));
 =09=09=09toggle_dac_capability(0, 0);
 =09=09=09return EX_SYSERR;
 =09=09}
@@ -658,8 +658,8 @@ get_password_from_file(int file_descript, char *filenam=
e,
 =09=09file_descript =3D open(filename, O_RDONLY);
 =09=09if (file_descript < 0) {
 =09=09=09fprintf(stderr,
-=09=09=09=09"mount.cifs failed. %s attempting to open password file %s\n",
-=09=09=09=09strerror(errno), filename);
+=09=09=09=09"%s failed. %s attempting to open password file %s\n",
+=09=09=09=09program, strerror(errno), filename);
 =09=09=09toggle_dac_capability(0, 0);
 =09=09=09return EX_SYSERR;
 =09=09}
@@ -675,8 +675,8 @@ get_password_from_file(int file_descript, char *filenam=
e,
 =09rc =3D read(file_descript, buf, sizeof(buf) - 1);
 =09if (rc < 0) {
 =09=09fprintf(stderr,
-=09=09=09"mount.cifs failed. Error %s reading password file\n",
-=09=09=09strerror(errno));
+=09=09=09"%s failed. Error %s reading password file\n",
+=09=09=09program, strerror(errno));
 =09=09rc =3D EX_SYSERR;
 =09=09goto get_pw_exit;
 =09}
@@ -923,7 +923,7 @@ parse_options(const char *data, struct parsed_mount_inf=
o *parsed_info)
 =09=09=09=09=09"invalid path to network resource\n");
 =09=09=09=09return EX_USAGE;
 =09=09=09}
-=09=09=09rc =3D parse_unc(value, parsed_info);
+=09=09=09rc =3D parse_unc(value, parsed_info, thisprogram);
 =09=09=09if (rc)
 =09=09=09=09return rc;
 =09=09=09break;
@@ -1280,7 +1280,7 @@ nocopy:
 =09return 0;
 }
=20
-static int parse_unc(const char *unc_name, struct parsed_mount_info *parse=
d_info)
+static int parse_unc(const char *unc_name, struct parsed_mount_info *parse=
d_info, const char *progname)
 {
 =09int length =3D strnlen(unc_name, MAX_UNC_LEN);
 =09const char *host, *share, *prepath;
@@ -1305,26 +1305,26 @@ static int parse_unc(const char *unc_name, struct p=
arsed_mount_info *parsed_info
 =09}
=20
 =09if (strncmp(unc_name, "//", 2) && strncmp(unc_name, "\\\\", 2)) {
-=09=09fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
+=09=09fprintf(stderr, "%s: bad UNC (%s)\n", progname, unc_name);
 =09=09return EX_USAGE;
 =09}
=20
 =09host =3D unc_name + 2;
 =09hostlen =3D strcspn(host, "/\\");
 =09if (!hostlen) {
-=09=09fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
+=09=09fprintf(stderr, "%s: bad UNC (%s)\n", progname, unc_name);
 =09=09return EX_USAGE;
 =09}
 =09share =3D host + hostlen + 1;
=20
 =09if (hostlen + 1 > sizeof(parsed_info->host)) {
-=09=09fprintf(stderr, "mount.cifs: host portion of UNC too long\n");
+=09=09fprintf(stderr, "%s: host portion of UNC too long\n", progname);
 =09=09return EX_USAGE;
 =09}
=20
 =09sharelen =3D strcspn(share, "/\\");
 =09if (sharelen + 1 > sizeof(parsed_info->share)) {
-=09=09fprintf(stderr, "mount.cifs: share portion of UNC too long\n");
+=09=09fprintf(stderr, "%s: share portion of UNC too long\n", progname);
 =09=09return EX_USAGE;
 =09}
=20
@@ -1335,7 +1335,7 @@ static int parse_unc(const char *unc_name, struct par=
sed_mount_info *parsed_info
 =09prepathlen =3D strlen(prepath);
=20
 =09if (prepathlen + 1 > sizeof(parsed_info->prefix)) {
-=09=09fprintf(stderr, "mount.cifs: UNC prefixpath too long\n");
+=09=09fprintf(stderr, "%s: UNC prefixpath too long\n", progname);
 =09=09return EX_USAGE;
 =09}
=20
@@ -1347,7 +1347,7 @@ static int parse_unc(const char *unc_name, struct par=
sed_mount_info *parsed_info
 =09return 0;
 }
=20
-static int get_pw_from_env(struct parsed_mount_info *parsed_info)
+static int get_pw_from_env(struct parsed_mount_info *parsed_info, const ch=
ar *program)
 {
 =09int rc =3D 0;
=20
@@ -1355,10 +1355,10 @@ static int get_pw_from_env(struct parsed_mount_info=
 *parsed_info)
 =09=09rc =3D set_password(parsed_info, getenv("PASSWD"));
 =09else if (getenv("PASSWD_FD"))
 =09=09rc =3D get_password_from_file(atoi(getenv("PASSWD_FD")), NULL,
-=09=09=09=09=09    parsed_info);
+=09=09=09=09=09    parsed_info, program);
 =09else if (getenv("PASSWD_FILE"))
 =09=09rc =3D get_password_from_file(0, getenv("PASSWD_FILE"),
-=09=09=09=09=09    parsed_info);
+=09=09=09=09=09    parsed_info, program);
=20
 =09return rc;
 }
@@ -1408,9 +1408,9 @@ static int uppercase_string(char *string)
 =09return 1;
 }
=20
-static void print_cifs_mount_version(void)
+static void print_cifs_mount_version(const char *progname)
 {
-=09printf("mount.cifs version: %s\n", VERSION);
+=09printf("%s version: %s\n", progname, VERSION);
 }
=20
 /*
@@ -1782,7 +1782,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed_i=
nfo,
 =09=09parsed_info->flags |=3D CIFS_SETUID_FLAGS;
 =09}
=20
-=09rc =3D get_pw_from_env(parsed_info);
+=09rc =3D get_pw_from_env(parsed_info, thisprogram);
 =09if (rc)
 =09=09goto assemble_exit;
=20
@@ -1802,7 +1802,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed_i=
nfo,
=20
 =09parsed_info->flags &=3D ~(MS_USERS | MS_USER);
=20
-=09rc =3D parse_unc(orig_dev, parsed_info);
+=09rc =3D parse_unc(orig_dev, parsed_info, thisprogram);
 =09if (rc)
 =09=09goto assemble_exit;
=20
@@ -1987,10 +1987,10 @@ int main(int argc, char **argv)
 =09=09thisprogram =3D "mount.cifs";
=20
 =09if(strcmp(thisprogram, "mount.cifs") =3D=3D 0)
-               cifs_fstype =3D "cifs";
+=09=09cifs_fstype =3D "cifs";
=20
-        if(strcmp(thisprogram, "mount.smb3") =3D=3D 0)
-              cifs_fstype =3D "smb3";
+=09if(strcmp(thisprogram, "mount.smb3") =3D=3D 0)
+=09=09cifs_fstype =3D "smb3";
=20
 =09/* allocate parsed_info as shared anonymous memory range */
 =09parsed_info =3D mmap((void *)0, sizeof(*parsed_info), PROT_READ | PROT_=
WRITE,
@@ -2027,7 +2027,7 @@ int main(int argc, char **argv)
 =09=09=09++parsed_info->verboseflag;
 =09=09=09break;
 =09=09case 'V':
-=09=09=09print_cifs_mount_version();
+=09=09=09print_cifs_mount_version(thisprogram);
 =09=09=09exit(0);
 =09=09case 'w':
 =09=09=09parsed_info->flags &=3D ~MS_RDONLY;
--=20
2.21.0

