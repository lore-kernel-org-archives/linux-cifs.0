Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05C91DE887;
	Tue,  7 Oct 2025 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759845418; cv=none; b=iBmc60WO4MtDUrJIJ2tt/eRKm2KmrIQBNR7TKbpqOQWtNLnrqBQkKR8dL78PkyMgffpC/Pmvlou4rcxC2GKqpvkTs3hNpUQiBbiNwAdqvQzfIhnIKCpxsf0XBDf7wySvHp7cMJN00O/GAulGmBfF8EX7sRalAF07xIRkCandOso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759845418; c=relaxed/simple;
	bh=Wi3J1XtMuR1O7fegeKFuRvokDhXazfrVyJxG+JlRfmM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=HFPtgq7bm/NLYLsJLDNISHpHnBwBbBBoUSaUiCihDQHsXoraSb6jURUT8aTsHiXowgrUrYFVgZex6EFp/0oUVS4Q6KtmGSm66FpG4+ICvAQQ6/YGZj5o0DuRnHeeRlX0ylNE7IIFF8GxrwMHsiOUA3BMBV9VRjD13tV3IxvuCa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=KVN5NlVc; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="KVN5NlVc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759845410; x=1760450210; i=markus.elfring@web.de;
	bh=v8DsEMB2FRksA0dGd/S0prFoIKyv/nPEMSOWWwWY7TY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=KVN5NlVcFGREoYOeCWpccaGuOKypEAxB27ruF6ZRED6Z/Petsh59l1K+E+d52eJA
	 GI2D6UnCv6OfUKoe6XVTvKsnHHUPX6HkYBeiFOPaoAuuhNi7nfQJV9IWvLbI6sfi/
	 axu0CBDn4yML/INmx2dGf25Yudqcnldk9XlTeWlTNGvpQMSbc85bRn9AzpvviujFK
	 jyjd5MJManXf5DfqSORoyfBUQerTBCu7SgxctVq4U3qUHS/RHM4BdNDmvalRBS/0b
	 ZHPnGMPQcjAyqa9Lwo9X51c6l1WB6wdrY214YQG0yo3oRKwJPtJxo2vrZODfYUkEx
	 sODOUQaUhNgpWiKvWg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mq1CA-1uTEYK2ck6-00oXRY; Tue, 07
 Oct 2025 15:50:42 +0200
Message-ID: <bdb24f04-98a5-43ce-bef2-dcda4edd8618@web.de>
Date: Tue, 7 Oct 2025 15:50:33 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Al Viro <viro@zeniv.linux.org.uk>, Bharath SM <bharathsm@microsoft.com>,
 Paul Aurich <paul@darkrain42.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Use more common code in open_cached_dir()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EyYwPU6y05QU3P5iAEG3I+uti+YbHyLrDqDOGdMWLf47BTvEjOm
 01lk2tdUfKyhqYv8D7OZAbz5qekZkTThbkT9clV0trCIx3CVWs85VKL5W0ZiYIqe/oxog73
 Funucz8PKdvlIwGYC79raXiacS1fF/HLkhPNUSBDl0DS4jI1t2iIPzoiBfZdZvr3l59J2q9
 aZXuH4jWmbSbLJz56tK+g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:w5bSxpeHRYE=;7cb81zwooO3cx42869it7l56NBs
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Oct 2025 15:34:56 +0200

Use two additional labels so that another bit of common code can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cached_dir.c | 42 ++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b36f9f9340f0..d3ab0467b0d9 100644
=2D-- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -184,9 +184,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon=
 *tcon,
 	spin_lock(&cfids->cfid_list_lock);
 	cfid =3D find_or_create_cached_dir(cfids, path, lookup_only, tcon->max_c=
ached_dirs);
 	if (cfid =3D=3D NULL) {
-		spin_unlock(&cfids->cfid_list_lock);
-		kfree(utf16_path);
-		return -ENOENT;
+		rc =3D -ENOENT;
+		goto free_unlock_list;
 	}
 	/*
 	 * Return cached fid if it is valid (has a lease and has a time).
@@ -195,10 +194,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
 	 */
 	if (is_valid_cached_dir(cfid)) {
 		cfid->last_access_time =3D jiffies;
-		spin_unlock(&cfids->cfid_list_lock);
 		*ret_cfid =3D cfid;
-		kfree(utf16_path);
-		return 0;
+		rc =3D 0;
+		goto free_unlock_list;
 	}
 	spin_unlock(&cfids->cfid_list_lock);
=20
@@ -331,30 +329,25 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
=20
=20
 	if (o_rsp->OplockLevel !=3D SMB2_OPLOCK_LEVEL_LEASE) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc =3D -EINVAL;
-		goto oshr_free;
+		goto unlock_list;
 	}
=20
 	rc =3D smb2_parse_contexts(server, rsp_iov,
 				 &oparms.fid->epoch,
 				 oparms.fid->lease_key,
 				 &oplock, NULL, NULL);
-	if (rc) {
-		spin_unlock(&cfids->cfid_list_lock);
-		goto oshr_free;
-	}
+	if (rc)
+		goto unlock_list;
=20
 	rc =3D -EINVAL;
-	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
-		spin_unlock(&cfids->cfid_list_lock);
-		goto oshr_free;
-	}
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
+		goto unlock_list;
+
 	qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
-	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_al=
l_info)) {
-		spin_unlock(&cfids->cfid_list_lock);
-		goto oshr_free;
-	}
+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_al=
l_info))
+		goto unlock_list;
+
 	if (!smb2_validate_and_copy_iov(
 				le16_to_cpu(qi_rsp->OutputBufferOffset),
 				sizeof(struct smb2_file_all_info),
@@ -364,10 +357,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
=20
 	cfid->time =3D jiffies;
 	cfid->last_access_time =3D jiffies;
-	spin_unlock(&cfids->cfid_list_lock);
 	/* At this point the directory handle is fully cached */
 	rc =3D 0;
-
+unlock_list:
+	spin_unlock(&cfids->cfid_list_lock);
 oshr_free:
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
@@ -404,6 +397,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
 		goto replay_again;
=20
 	return rc;
+
+free_unlock_list:
+	spin_unlock(&cfids->cfid_list_lock);
+	kfree(utf16_path);
+	return rc;
 }
=20
 int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
=2D-=20
2.51.0

