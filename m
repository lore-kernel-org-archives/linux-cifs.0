Return-Path: <SRS0=+dfI=23=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D742C33C8C
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jan 2020 16:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48810208C4
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jan 2020 16:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtcNfCan"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgAFQbg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:31:36 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36884 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgAFQbf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jan 2020 11:31:35 -0500
Received: by mail-qv1-f66.google.com with SMTP id f16so19265797qvi.4
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jan 2020 08:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rtA74+unsUR/vqPvRHYSHMJswTlQjiVxGqB2XtBcv8w=;
        b=XtcNfCanyw+IvxFQm1MVdbvfK/fBDevsN67ooQaAHrMcrF7YMgzLrIqeUcZO0QxdHv
         cDN96rCNWisU1iwkPoCa3zvFujUhg8x9hRUwEvURXZqJFpeeB2AnuY1nCh8o38Qc3CjN
         y1q1fpabqWMKvvPvA28WkrpQ+gPJRH+gBro3fV88wyyHADBg/EpzMT7okvz+VQN1eIQT
         yNZz2aHVTPe9rVkciV7XKsJw4OG4EGZMxnx4oJxG1401W3/7+QmEzwjSBdGTFyXQLff5
         c0WpZkz02sCxiK/ZoptkMdQ2CmUa7LW22BDaCibF+3HMlH1yRDspzafbfX9OORJvF9pS
         P6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtA74+unsUR/vqPvRHYSHMJswTlQjiVxGqB2XtBcv8w=;
        b=c9tLb5X4KY2dSWo0yZJCJaD39E2e7OCWoovlCErfU4jb1Cy8d6YPG26Q2hnb1Xp/9X
         IuUCqNz3ckniJ/7C47bwwIFQVpksvdDkIj5dKVSvPjL+9+Hb1t/3TqanGBFH/w1bSaos
         29Eaq7IHzXmncspqjaIYwgNDttanuhw2l7VQztSly40r/e+jvYtbfCNr73v+0Nng2xum
         3splC1uJM/WjXi6/Pb6b1G7mb0cQpVMGHnyVlg8iNymeWHISe/SU3TMUaMxehBsuvHvk
         0OwyYknrgIUdR1KAxBE3153MtXEsffdKT52FXMho464Hh3Xb2beBTXMK08wu4yC7V1QQ
         3b7Q==
X-Gm-Message-State: APjAAAX+DAGDXI+M7ugh14F7RtmxtCkKIT5AqAWKzkK/vycxZ1y8/rIY
        33uB/cTofxsp/k14cdPIUzRwGf3s
X-Google-Smtp-Source: APXvYqw/PbrPZ2tQfTYOjU5dDZVI6GcHEncievPMBE8KKO+jNivECjRVy0WmSLwOJcE1umS5bScI+w==
X-Received: by 2002:a05:6214:707:: with SMTP id b7mr78530010qvz.97.1578328293934;
        Mon, 06 Jan 2020 08:31:33 -0800 (PST)
Received: from ip-172-31-1-121.ec2.internal (ec2-3-231-202-5.compute-1.amazonaws.com. [3.231.202.5])
        by smtp.gmail.com with ESMTPSA id f26sm23434195qtv.77.2020.01.06.08.31.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 08:31:33 -0800 (PST)
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org, samba-technical@lists.samba.org,
        sblbir@amazon.com, boris.v.protopopov@gmail.com
Subject: [PATCH] Add support for setting owner and group in ntsd
Date:   Mon,  6 Jan 2020 16:31:19 +0000
Message-Id: <20200106163119.9083-2-boris.v.protopopov@gmail.com>
X-Mailer: git-send-email 2.24.1.485.gad05a3d8e5
In-Reply-To: <20200106163119.9083-1-boris.v.protopopov@gmail.com>
References: <20200106163119.9083-1-boris.v.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Extend setcifsacl utility to allow setting owner and group SIDs
in the security descriptor in addition to setting ACLs. This is
a user-friendly intefrace for setting owner and group SIDs that
takes advantage of the recent extensions in the CIFS kernel
client, and it complements setting raw values via setfattr.

Signed-off-by: Boris Protopopov <boris.v.protopopov@gmail.com>
---
 cifsacl.h         |   4 +-
 setcifsacl.c      | 253 ++++++++++++++++++++++++++++++++++++++++++++----------
 setcifsacl.rst.in |  27 ++++--
 3 files changed, 235 insertions(+), 49 deletions(-)

diff --git a/cifsacl.h b/cifsacl.h
index ca72dd4..bd0c695 100644
--- a/cifsacl.h
+++ b/cifsacl.h
@@ -26,7 +26,9 @@
 #define _CIFSACL_H
 
 #define BUFSIZE 1024
-#define ATTRNAME "system.cifs_acl"
+#define ATTRNAME	"system.cifs_acl"
+#define ATTRNAME_ACL	ATTRNAME
+#define ATTRNAME_NTSD	"system.cifs_ntsd"
 
 #define MAX_NUM_AUTHS 6
 
diff --git a/setcifsacl.c b/setcifsacl.c
index 9a301e2..6e5a633 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -44,7 +44,9 @@ enum setcifsacl_actions {
 	ActDelete,
 	ActModify,
 	ActAdd,
-	ActSet
+	ActSetAcl,
+	ActSetOwner,
+	ActSetGroup
 };
 
 static void *plugin_handle;
@@ -140,6 +142,90 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	return bufsize;
 }
 
+/*
+ * This function (and the one above) does not need to set the SACL-related
+ * fields, and this works fine because on the SMB protocol level, setting owner
+ * info, DACL, and SACL requires one to use separate flags that control which
+ * part of the descriptor is begin looked at on the server side
+ */
+static ssize_t
+copy_sec_desc_with_sid(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
+		struct cifs_sid *sid, int maction)
+{
+	int size, daclsize;
+	int osidoffset, gsidoffset, dacloffset;
+	int nosidoffset, ngsidoffset, ndacloffset, nsidssize;
+	ssize_t bufsize;
+	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
+	struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
+	struct cifs_ctrl_acl *dacl_ptr, *ndacl_ptr;
+
+	/* copy security descriptor control portion */
+	osidoffset = le32toh(pntsd->osidoffset);
+	gsidoffset = le32toh(pntsd->gsidoffset);
+	dacloffset = le32toh(pntsd->dacloffset);
+	/*
+	 * the size of the owner or group sid might be different from the old
+	 * one, so the group sid offest might change, and if the owner is
+	 * positioned before the DACL, the dacl offset might change as well;
+	 * note however, that the owner sid offset does not change
+	 */
+	nosidoffset = osidoffset;
+	size = sizeof(struct cifs_ntsd);
+	pnntsd->revision = pntsd->revision;
+	pnntsd->type = pntsd->type;
+	pnntsd->osidoffset = pntsd->osidoffset;
+	bufsize = size;
+
+	/* set the pointers for source sids */
+	if (maction == ActSetOwner) {
+		owner_sid_ptr = sid;
+		group_sid_ptr = (struct cifs_sid *)((char *)pntsd + gsidoffset);
+	}
+	if (maction == ActSetGroup) {
+		owner_sid_ptr = (struct cifs_sid *)((char *)pntsd + osidoffset);
+		group_sid_ptr = sid;
+	}
+
+	dacl_ptr = (struct cifs_ctrl_acl *)((char *)pntsd + dacloffset);
+	daclsize = le16toh(dacl_ptr->size) + sizeof(struct cifs_ctrl_acl);
+
+	/* copy owner sid */
+	nowner_sid_ptr = (struct cifs_sid *)((char *)pnntsd + nosidoffset);
+	size = copy_cifs_sid(nowner_sid_ptr, owner_sid_ptr);
+	bufsize += size;
+	nsidssize = size;
+
+	/* copy group sid */
+	ngsidoffset = nosidoffset + size;
+	ngroup_sid_ptr = (struct cifs_sid *)((char *)pnntsd + ngsidoffset);
+	pnntsd->gsidoffset = htole32(ngsidoffset);
+	size = copy_cifs_sid(ngroup_sid_ptr, group_sid_ptr);
+	bufsize += size;
+	nsidssize += size;
+
+	/* position the dacl control info as in the fetched descriptor */
+	if (dacloffset <= osidoffset)
+		ndacloffset = dacloffset;
+	else
+		ndacloffset = nosidoffset + nsidssize;
+	ndacl_ptr = (struct cifs_ctrl_acl *)((char *)pnntsd + ndacloffset);
+	pnntsd->dacloffset = htole32(ndacloffset);
+
+	/* the DACL control fields do not change */
+	ndacl_ptr->revision = dacl_ptr->revision;
+	ndacl_ptr->size = dacl_ptr->size;
+	ndacl_ptr->num_aces = dacl_ptr->num_aces;
+
+	/*
+	 * add DACL size (control portion and the array of aces) to the
+	 * buffer size
+	 */
+	bufsize += daclsize;
+
+	return bufsize;
+}
+
 static int
 copy_ace(struct cifs_ace *dace, struct cifs_ace *sace)
 {
@@ -788,7 +874,7 @@ setacl_action(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd,
 		rc = ace_add(pntsd, npntsd, bufsize, facesptr,
 				numfaces, cacesptr, numcaces);
 		break;
-	case ActSet:
+	case ActSetAcl:
 		rc = ace_set(pntsd, npntsd, bufsize, cacesptr, numcaces);
 		break;
 	default:
@@ -803,9 +889,10 @@ static void
 setcifsacl_usage(const char *prog)
 {
 	fprintf(stderr,
-	"%s: Alter CIFS/NTFS ACL in a security descriptor of a file object\n",
+	"%s: Alter CIFS/NTFS ACL or owner/group in a security descriptor of a file object\n",
+		prog);
+	fprintf(stderr, "Usage: %s option [<list_of_ACEs>|<SID>] <file_name>\n",
 		prog);
-	fprintf(stderr, "Usage: %s option <list_of_ACEs> <file_name>\n", prog);
 	fprintf(stderr, "Valid options:\n");
 	fprintf(stderr, "\t-v	Version of the program\n");
 	fprintf(stderr, "\n\t-a	Add ACE(s), separated by a comma, to an ACL\n");
@@ -825,21 +912,32 @@ setcifsacl_usage(const char *prog)
 	"\n\t-S	Replace existing ACL with ACE(s), separated by a comma\n");
 	fprintf(stderr,
 	"\tsetcifsacl -S \"ACL:Administrator:ALLOWED/0x0/D\" <file_name>\n");
+	fprintf(stderr,
+	"\n\t-o	Set owner using specified SID (name or raw format)\n");
+	fprintf(stderr,
+	"\tsetcifsacl -o \"Administrator\" <file_name>\n");
+	fprintf(stderr,
+	"\n\t-g	Set group using specified SID (name or raw format)\n");
+	fprintf(stderr,
+	"\tsetcifsacl -g \"Administrators\" <file_name>\n");
 	fprintf(stderr, "\nRefer to setcifsacl(1) manpage for details\n");
 }
 
 int
 main(const int argc, char *const argv[])
 {
-	int i, rc, c, numcaces, numfaces;
+	int i, rc, c, numcaces = 0, numfaces = 0;
 	enum setcifsacl_actions maction = ActUnknown;
 	ssize_t attrlen, bufsize = BUFSIZE;
-	char *ace_list, *filename, *attrval, **arrptr = NULL;
+	char *ace_list = NULL, *filename = NULL, *attrval = NULL,
+		**arrptr = NULL, *sid_str = NULL;
 	struct cifs_ctrl_acl *daclptr = NULL;
 	struct cifs_ace **cacesptr = NULL, **facesptr = NULL;
 	struct cifs_ntsd *ntsdptr = NULL;
+	struct cifs_sid sid;
+	char *attrname = ATTRNAME_ACL;
 
-	c = getopt(argc, argv, "hvD:M:a:S:");
+	c = getopt(argc, argv, "hvD:M:a:S:o:g:");
 	switch (c) {
 	case 'D':
 		maction = ActDelete;
@@ -854,9 +952,19 @@ main(const int argc, char *const argv[])
 		ace_list = optarg;
 		break;
 	case 'S':
-		maction = ActSet;
+		maction = ActSetAcl;
 		ace_list = optarg;
 		break;
+	case 'o':
+		maction = ActSetOwner;
+		sid_str = optarg;
+		attrname = ATTRNAME_NTSD;
+		break;
+	case 'g':
+		maction = ActSetGroup;
+		sid_str = optarg;
+		attrname = ATTRNAME_NTSD;
+		break;
 	case 'h':
 		setcifsacl_usage(basename(argv[0]));
 		return 0;
@@ -875,11 +983,16 @@ main(const int argc, char *const argv[])
 	}
 	filename = argv[3];
 
-	if (!ace_list) {
+	if (!ace_list && maction != ActSetOwner && maction != ActSetGroup) {
 		printf("%s: No valid ACEs specified\n", __func__);
 		return -1;
 	}
 
+	if (!sid_str && (maction == ActSetOwner || maction == ActSetGroup)) {
+		printf("%s: No valid SIDs specified\n", __func__);
+		return -1;
+	}
+
 	if (init_plugin(&plugin_handle)) {
 		fprintf(stderr, "WARNING: unable to initialize idmapping "
 				"plugin. Only \"raw\" SID strings will be "
@@ -889,16 +1002,24 @@ main(const int argc, char *const argv[])
 		plugin_loaded = true;
 	}
 
-	numcaces = get_numcaces(ace_list);
-
-	arrptr = parse_cmdline_aces(ace_list, numcaces);
-	if (!arrptr)
-		goto setcifsacl_numcaces_ret;
+	if (maction == ActSetOwner || maction == ActSetGroup) {
+		/* parse the sid */
+		if (setcifsacl_str_to_sid(sid_str, &sid)) {
+			printf("%s: failed to parce \'%s\' as SID\n", __func__,
+				sid_str);
+			goto setcifsacl_numcaces_ret;
+		}
+	} else {
+		numcaces = get_numcaces(ace_list);
 
-	cacesptr = build_cmdline_aces(arrptr, numcaces);
-	if (!cacesptr)
-		goto setcifsacl_cmdlineparse_ret;
+		arrptr = parse_cmdline_aces(ace_list, numcaces);
+		if (!arrptr)
+			goto setcifsacl_numcaces_ret;
 
+		cacesptr = build_cmdline_aces(arrptr, numcaces);
+		if (!cacesptr)
+			goto setcifsacl_cmdlineparse_ret;
+	}
 cifsacl:
 	if (bufsize >= XATTR_SIZE_MAX) {
 		printf("%s: Buffer size %zd exceeds max size of %d\n",
@@ -912,7 +1033,7 @@ cifsacl:
 		goto setcifsacl_cmdlineverify_ret;
 	}
 
-	attrlen = getxattr(filename, ATTRNAME, attrval, bufsize);
+	attrlen = getxattr(filename, attrname, attrval, bufsize);
 	if (attrlen == -1) {
 		if (errno == ERANGE) {
 			free(attrval);
@@ -924,26 +1045,64 @@ cifsacl:
 		}
 	}
 
-	numfaces = get_numfaces((struct cifs_ntsd *)attrval, attrlen, &daclptr);
-	if (!numfaces && maction != ActAdd) { /* if we are not adding aces */
-		printf("%s: Empty DACL\n", __func__);
-		goto setcifsacl_facenum_ret;
-	}
+	if (maction == ActSetOwner || maction == ActSetGroup) {
+		struct cifs_ntsd *pfntsd = (struct cifs_ntsd *)attrval;
+		int dacloffset = le32toh(pfntsd->dacloffset);
+		struct cifs_ctrl_acl *daclinfo =
+				(struct cifs_ctrl_acl *)(attrval + dacloffset);
+		int numaces = le16toh(daclinfo->num_aces);
+		int acessize = le32toh(daclinfo->size);
+		size_t faceoffset, naceoffset;
+		char *faceptr, *naceptr;
 
-	facesptr = build_fetched_aces((char *)daclptr, numfaces);
-	if (!facesptr)
-		goto setcifsacl_facenum_ret;
+		/*
+		 * this allocates large enough buffer for max sid size and the
+		 * dacl info from the fetched security descriptor
+		 */
+		rc = alloc_sec_desc(pfntsd, &ntsdptr, numaces, &faceoffset);
+		if (rc)
+			goto setcifsacl_numcaces_ret;
 
-	bufsize = 0;
-	rc = setacl_action((struct cifs_ntsd *)attrval, &ntsdptr, &bufsize,
-		facesptr, numfaces, cacesptr, numcaces, maction);
-	if (rc)
-		goto setcifsacl_action_ret;
+		/*
+		 * copy the control structures from the fetched descriptor, the
+		 * sid specified by the user, and adjust the offsets/move dacl
+		 * control structure if needed
+		 */
+		bufsize = copy_sec_desc_with_sid(pfntsd, ntsdptr, &sid,
+				maction);
+
+		/* copy aces verbatim as they have not changed */
+		faceptr = attrval + faceoffset;
+		naceoffset = le32toh(ntsdptr->dacloffset) +
+				sizeof(struct cifs_ctrl_acl);
+		naceptr = (char *)ntsdptr + naceoffset;
+		memcpy(naceptr, faceptr, acessize);
+	} else {
+		bufsize = 0;
+
+		numfaces = get_numfaces((struct cifs_ntsd *)attrval, attrlen,
+				&daclptr);
+		if (!numfaces && maction != ActAdd) {
+			/* if we are not adding aces */
+			printf("%s: Empty DACL\n", __func__);
+			goto setcifsacl_facenum_ret;
+		}
+
+		facesptr = build_fetched_aces((char *)daclptr, numfaces);
+		if (!facesptr)
+			goto setcifsacl_facenum_ret;
 
-	attrlen = setxattr(filename, ATTRNAME, ntsdptr, bufsize, 0);
+		rc = setacl_action((struct cifs_ntsd *)attrval, &ntsdptr,
+				&bufsize, facesptr, numfaces, cacesptr,
+				numcaces, maction);
+		if (rc)
+			goto setcifsacl_action_ret;
+	}
+
+	attrlen = setxattr(filename, attrname, ntsdptr, bufsize, 0);
 	if (attrlen == -1) {
 		printf("%s: setxattr error: %s\n", __func__, strerror(errno));
-		goto setcifsacl_facenum_ret;
+		goto setcifsacl_action_ret;
 	}
 
 	if (plugin_loaded)
@@ -951,25 +1110,33 @@ cifsacl:
 	return 0;
 
 setcifsacl_action_ret:
-	free(ntsdptr);
+	if (ntsdptr)
+		free(ntsdptr);
 
 setcifsacl_facenum_ret:
-	for (i = 0; i < numfaces; ++i)
-		free(facesptr[i]);
-	free(facesptr);
+	if (facesptr) {
+		for (i = 0; i < numfaces; ++i)
+			free(facesptr[i]);
+		free(facesptr);
+	}
 
 setcifsacl_getx_ret:
-	free(attrval);
+	if (attrval)
+		free(attrval);
 
 setcifsacl_cmdlineverify_ret:
-	for (i = 0; i < numcaces; ++i)
-		free(cacesptr[i]);
-	free(cacesptr);
+	if (cacesptr) {
+		for (i = 0; i < numcaces; ++i)
+			free(cacesptr[i]);
+		free(cacesptr);
+	}
 
 setcifsacl_cmdlineparse_ret:
-	free(arrptr);
+	if (arrptr)
+		free(arrptr);
 
 setcifsacl_numcaces_ret:
-	exit_plugin(plugin_handle);
+	if (plugin_loaded)
+		exit_plugin(plugin_handle);
 	return -1;
 }
diff --git a/setcifsacl.rst.in b/setcifsacl.rst.in
index de9c758..985af7c 100644
--- a/setcifsacl.rst.in
+++ b/setcifsacl.rst.in
@@ -2,16 +2,16 @@
 setcifsacl
 ==========
 
-------------------------------------------------------------------------------------------------
-Userspace helper to alter an ACL in a security descriptor for Common Internet File System (CIFS)
-------------------------------------------------------------------------------------------------
+-------------------------------------------------------------------------------------------------------------------
+Userspace helper to alter an ACL or owner/group SID in a security descriptor for Common Internet File System (CIFS)
+-------------------------------------------------------------------------------------------------------------------
 :Manual section: 1
 
 ********
 SYNOPSIS
 ********
 
-  setcifsacl [-v|-a|-D|-M|-S] "{one or more ACEs}" {file system object}
+  setcifsacl [-v|-a|-D|-M|-S|-o|-g] "{one or more ACEs or a SID}" {file system object}
 
 ***********
 DESCRIPTION
@@ -20,7 +20,7 @@ DESCRIPTION
 This tool is part of the cifs-utils suite.
 
 ``setcifsacl`` is a userspace helper program for the Linux CIFS client
-file system. It is intended to alter an ACL of a security descriptor
+file system. It is intended to alter an ACL or set owner/group SID of a security descriptor
 for a file system object. Whether a security descriptor to be set is
 applied or not is determined by the CIFS/SMB server.
 
@@ -55,6 +55,13 @@ OPTIONS
   Set an ACL of security descriptor with the list of ACEs Existing ACL
   is replaced entirely with the specified ACEs.
 
+-o
+  Set owner SID to one specified as a command line argument.
+
+-g
+  Set group SID to one specified as a command line argument.
+
+  The owner/group SID can be specified as a name or a raw SID value.
   Every ACE entry starts with "ACL:" One or more ACEs are specified
   within double quotes.  Multiple ACEs are separated by a comma.
 
@@ -93,6 +100,16 @@ Set an ACL
 
   setcifsacl -S "ACL:CIFSTESTDOM\Administrator:0x0/0x0/FULL,ACL:CIFSTESTDOM\user2:0x0/0x0/FULL" <file_name>
 
+Set owner SID
+=============
+
+  setcifsacl -o "S-1-5-21-3338130290-3403600371-1423429424-2102" <file_name>
+
+Set group SID
+=============
+
+  setcifsacl -g "Administrators@BUILTIN" <file_name>
+
 *****
 NOTES
 *****
-- 
2.14.5

