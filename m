Return-Path: <SRS0=LMmx=Z2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8928DC2D0BE
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 22:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54ECC206DB
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 22:54:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbKbqA1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDWya (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Dec 2019 17:54:30 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28195 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728072AbfLDWy3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Dec 2019 17:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575500068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17TsypRWlPyDjgi4S2/Ek4BPc3HMjsnlhGKHmugmzHg=;
        b=ZbKbqA1M2aQiABllNBksVKxlln1ck2kZ+xC4a6XgqGqIErjkhwWwtG+PT+c/FCgWueD0L4
        8YmBG39rFakKHE7c11/Pq/oed86jpOjn62apE4K2czLk6EfKN+tw9vdhwUI+4hugCSKbUS
        JEiRLFlCSksZRowt9/B6Fsu7QMYsCaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-Q658LztdPyqjR3V8FmtM-g-1; Wed, 04 Dec 2019 17:54:26 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7220118AAFA1
        for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2019 22:54:25 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-46.bne.redhat.com [10.64.54.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA27B5D9C5;
        Wed,  4 Dec 2019 22:54:24 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 3/3] cifs: use compounding for open and first query-dir for readdir()
Date:   Thu,  5 Dec 2019 08:54:10 +1000
Message-Id: <20191204225410.17514-4-lsahlber@redhat.com>
In-Reply-To: <20191204225410.17514-1-lsahlber@redhat.com>
References: <20191204225410.17514-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Q658LztdPyqjR3V8FmtM-g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Combine the initial SMB2_Open and the first SMB2_Query_Directory in a compo=
und.
This shaves one round-trip of each directory listing, changing it from 4 to=
 3
for small directories.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h |  3 ++
 fs/cifs/smb2ops.c   | 96 ++++++++++++++++++++++++++++++++++++++++++++++---=
----
 2 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1ed695336f62..b276281ec0d8 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -595,6 +595,9 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct ci=
fs_server_iface *iface);
=20
 void extract_unc_hostname(const char *unc, const char **h, size_t *len);
 int copy_path_name(char *dst, const char *src);
+int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_io=
v,
+=09=09=09       int resp_buftype,
+=09=09=09       struct cifs_search_info *srch_inf);
=20
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *se=
s,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a7f328f79c6f..09949beea769 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1997,14 +1997,33 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
 =09=09     struct cifs_search_info *srch_inf)
 {
 =09__le16 *utf16_path;
-=09int rc;
-=09__u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
+=09struct smb_rqst rqst[2];
+=09struct kvec rsp_iov[2];
+=09int resp_buftype[2];
+=09struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+=09struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
+=09int rc, flags =3D 0;
+=09u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
 =09struct cifs_open_parms oparms;
+=09struct smb2_query_directory_rsp *qd_rsp =3D NULL;
+=09struct smb2_create_rsp *op_rsp =3D NULL;
=20
 =09utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
 =09if (!utf16_path)
 =09=09return -ENOMEM;
=20
+=09if (smb3_encryption_required(tcon))
+=09=09flags |=3D CIFS_TRANSFORM_REQ;
+
+=09memset(rqst, 0, sizeof(rqst));
+=09resp_buftype[0] =3D resp_buftype[1] =3D CIFS_NO_BUFFER;
+=09memset(rsp_iov, 0, sizeof(rsp_iov));
+
+=09/* Open */
+=09memset(&open_iov, 0, sizeof(open_iov));
+=09rqst[0].rq_iov =3D open_iov;
+=09rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
+
 =09oparms.tcon =3D tcon;
 =09oparms.desired_access =3D FILE_READ_ATTRIBUTES | FILE_READ_DATA;
 =09oparms.disposition =3D FILE_OPEN;
@@ -2015,22 +2034,75 @@ smb2_query_dir_first(const unsigned int xid, struct=
 cifs_tcon *tcon,
 =09oparms.fid =3D fid;
 =09oparms.reconnect =3D false;
=20
-=09rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL);
-=09kfree(utf16_path);
-=09if (rc) {
-=09=09cifs_dbg(FYI, "open dir failed rc=3D%d\n", rc);
-=09=09return rc;
-=09}
+=09rc =3D SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, utf16_path);
+=09if (rc)
+=09=09goto qdf_free;
+=09smb2_set_next_command(tcon, &rqst[0]);
=20
+=09/* Query directory */
 =09srch_inf->entries_in_buffer =3D 0;
 =09srch_inf->index_of_last_entry =3D 2;
=20
-=09rc =3D SMB2_query_directory(xid, tcon, fid->persistent_fid,
-=09=09=09=09  fid->volatile_fid, 0, srch_inf);
-=09if (rc) {
-=09=09cifs_dbg(FYI, "query directory failed rc=3D%d\n", rc);
+=09memset(&qd_iov, 0, sizeof(qd_iov));
+=09rqst[1].rq_iov =3D qd_iov;
+=09rqst[1].rq_nvec =3D SMB2_QUERY_DIRECTORY_IOV_SIZE;
+
+=09rc =3D SMB2_query_directory_init(xid, tcon, &rqst[1],
+=09=09=09=09       COMPOUND_FID, COMPOUND_FID,
+=09=09=09=09       0, srch_inf->info_level);
+=09if (rc)
+=09=09goto qdf_free;
+
+=09smb2_set_related(&rqst[1]);
+
+=09rc =3D compound_send_recv(xid, tcon->ses, flags, 2, rqst,
+=09=09=09=09resp_buftype, rsp_iov);
+
+=09/* If the open failed there is nothing to do */
+=09op_rsp =3D (struct smb2_create_rsp *)rsp_iov[0].iov_base;
+=09if (op_rsp =3D=3D NULL || op_rsp->sync_hdr.Status !=3D STATUS_SUCCESS) =
{
+=09=09cifs_dbg(FYI, "query_dir_first: open failed rc=3D%d\n", rc);
+=09=09goto qdf_free;
+=09}
+=09fid->persistent_fid =3D op_rsp->PersistentFileId;
+=09fid->volatile_fid =3D op_rsp->VolatileFileId;
+
+=09/* Anything else than ENODATA means a genuine error */
+=09if (rc && rc !=3D -ENODATA) {
 =09=09SMB2_close(xid, tcon, fid->persistent_fid, fid->volatile_fid);
+=09=09cifs_dbg(FYI, "query_dir_first: query directory failed rc=3D%d\n", r=
c);
+=09=09trace_smb3_query_dir_err(xid, fid->persistent_fid,
+=09=09=09=09=09 tcon->tid, tcon->ses->Suid, 0, 0, rc);
+=09=09goto qdf_free;
 =09}
+
+=09qd_rsp =3D (struct smb2_query_directory_rsp *)rsp_iov[1].iov_base;
+=09if (qd_rsp->sync_hdr.Status =3D=3D STATUS_NO_MORE_FILES) {
+=09=09trace_smb3_query_dir_done(xid, fid->persistent_fid,
+=09=09=09=09=09  tcon->tid, tcon->ses->Suid, 0, 0);
+=09=09srch_inf->endOfSearch =3D true;
+=09=09rc =3D 0;
+=09=09goto qdf_free;
+=09}
+
+=09rc =3D smb2_parse_query_directory(tcon, &rsp_iov[1], resp_buftype[1],
+=09=09=09=09=09srch_inf);
+=09if (rc) {
+=09=09trace_smb3_query_dir_err(xid, fid->persistent_fid, tcon->tid,
+=09=09=09tcon->ses->Suid, 0, 0, rc);
+=09=09goto qdf_free;
+=09}
+=09resp_buftype[1] =3D CIFS_NO_BUFFER;
+
+=09trace_smb3_query_dir_done(xid, fid->persistent_fid, tcon->tid,
+=09=09=09tcon->ses->Suid, 0, srch_inf->entries_in_buffer);
+
+ qdf_free:
+=09kfree(utf16_path);
+=09SMB2_open_free(&rqst[0]);
+=09SMB2_query_directory_free(&rqst[1]);
+=09free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
+=09free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 =09return rc;
 }
=20
--=20
2.13.6

