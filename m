Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612A840803B;
	Sun, 18 Oct 2026 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792346012; cv=none; b=cibebhJE2yIlBD74mkIvHMwoSiz2Qgz6oa2uRypcmXd3tzQS2aS4a9LuZuURvqz43nVBHztSwBz8oZZRSs1UNrb8v7UtSoAEbNreNAkW2MABt/1k1OlyzoxSdl+IqaZDb5RBnJshD9yxyofMQLWC/knf1MVd1IBDNfASHaqZNR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792346012; c=relaxed/simple;
	bh=iVSP1hK5NPP6v87jrXxqiWjS4+26ltrJN+QbKrM0q5E=;
	h=Message-ID:In-Reply-To:References:From:Subject:To:Cc:Date; b=IU8MD3PgX7aHIkfSJ0rykUQ87rC7G44i33RtMq23AzCxOultt/+0jZKT4GZkhOKXmlRavYYSJwrwlS9QA5r4AHhY1dekNnvDYShPRccCJxBJRBeIPas9X2CI5pIA9hWqS4CVWD4ovExi2ljhinBKIIxEzlrTLGJSk5llzn0AGJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b=l8+DtixI; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b="l8+DtixI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1792345999; x=1792950799; i=jan.koester@gmx.net;
	bh=Gn/GMpZ+LCIUOsuc0RvGxobrMeLbyZBuGTCxRFacq3g=;
	h=X-UI-Sender-Class:Message-ID:In-Reply-To:References:From:Subject:
	 To:Cc:Date:Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=l8+DtixIOr74NPy3n3zcoAs6P/U8rLgwfLJU9dlv4ROp/x0O7OlrC0Fx9bfpy5ni
	 fLD+eq2dSM9J0j5lQMwF68fWgRNWLE/xiczqRUiOBSl/2HyFlMFzAMIdPTlN/bDrt
	 3ijV2kiO+2tF7Cy4u+jstfeGXGatYkM6FmjkclQI+vTK/cl8pLrM1luGo+G9TvqFW
	 bNDLFkkl619l3lWBDpzkGhvh+AnWuCrSegFX77+MSSqyFreK9cLlTnu80+AqX1u6i
	 i4+H+A6LTS64118Q/7fDQr0wpBJ5ygkp1A2WYMgq807jbDCycrVGdj6FtX0h6p11S
	 LP7z8qcqzojkbux2xw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MdNcA-1wjRIl1hOC-00jEr6; Sun, 18
 Oct 2026 19:53:19 +0200
Message-ID: <1861a1d193fc19a37cac28c3d3312046d69bf5bf.1792345559.git.jan.koester@gmx.net>
In-Reply-To: <cover.1792345559.git.jan.koester@gmx.net>
References: <cover.1792345559.git.jan.koester@gmx.net>
From: Jan Koester <jan.koester@gmx.net>
Subject: [PATCH 2/2] ksmbd: put the workgroup into the NTLMSSP target info's
 domain names
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 19:53:16 +0200
X-Provags-ID: V03:K1:posw8+Heo3TOWor+tw4qYw55XYiIHM8lqoZxpMmN+R6L0rja+n5
 E/OnTkfXIdiezLa+U1fax3Vib2uG82VHKm93KcmOYZgLGKIHZPFoZU3LHP1J9ZAHrAmM4Km
 x43AUEYrlZPDs3LKb9h1tmqoS5/Nbf05IH71bAEWIN6M3PA6DOf5aHwV+NuHjBMNRrSYSCg
 219aytE2pwywy0U0G2EcA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dzfIR/+0tRc=;IPQgPdjiNVDiSAy/jWFz795DUZJ
 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
 =
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

ksmbd_build_ntlmssp_challenge_blob() writes the netbios name into all
four AV pairs of the challenge's target info, the domain names
(MsvAvNbDomainName, MsvAvDnsDomainName) included. The client copies
them into its NTLMv2 response.

With NTLM pass-through, a domain controller verifies that response over
NETLOGON, and Samba (NTLMv2_RESPONSE_verify_workstation()) refuses it
with NT_STATUS_LOGON_FAILURE unless MsvAvNbComputerName is the secure
channel's computer account and MsvAvNbDomainName its workgroup. Every
pass-through login of a domain user then fails.

Put the workgroup into the two domain names. Size the challenge blob
from both names in one helper, ntlmssp_challenge_size(), and check that
the blob fits into the response buffer when it is built in place
without SPNEGO: the workgroup may be longer than the netbios name.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@gmx.net>
=2D--
 fs/smb/server/auth.c    | 41 ++++++++++++++++++++++++++++++++++-------
 fs/smb/server/smb2pdu.c | 21 +++++++++++++++++++--
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 9a2a3c6a37..8639997080 100644
=2D-- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -376,10 +376,10 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_=
message *chgblob,
 				   struct ksmbd_conn *conn)
 {
 	struct target_info *tinfo;
-	wchar_t *name;
+	wchar_t *name, *domain;
 	__u8 *target_name;
 	unsigned int flags, blob_off, blob_len, type, target_info_len =3D 0;
-	int len, uni_len, conv_len;
+	int len, uni_len, dom_len, conv_len;
 	int cflags =3D conn->ntlmssp.client_flags;
=20
 	memcpy(chgblob->Signature, NTLMSSP_SIGNATURE, 8);
@@ -426,6 +426,23 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_m=
essage *chgblob,
=20
 	uni_len =3D UNICODE_LEN(conv_len);
=20
+	len =3D strlen(ksmbd_work_group());
+	domain =3D kmalloc(2 + UNICODE_LEN(len), KSMBD_DEFAULT_GFP);
+	if (!domain) {
+		kfree(name);
+		return -ENOMEM;
+	}
+
+	conv_len =3D smb_strtoUTF16((__le16 *)domain, ksmbd_work_group(), len,
+				  conn->local_nls);
+	if (conv_len < 0 || conv_len > len) {
+		kfree(domain);
+		kfree(name);
+		return -EINVAL;
+	}
+
+	dom_len =3D UNICODE_LEN(conv_len);
+
 	blob_off =3D sizeof(struct challenge_message);
 	blob_len =3D blob_off + uni_len;
=20
@@ -446,14 +463,23 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_=
message *chgblob,
 	tinfo =3D (struct target_info *)(target_name + uni_len);
=20
 	chgblob->TargetInfoArray.Length =3D 0;
-	/* Add target info list for NetBIOS/DNS settings */
+	/*
+	 * Add target info list for NetBIOS/DNS settings: the computer names
+	 * are the netbios name, the domain names the workgroup. A domain
+	 * controller checks the latter when it is asked to verify the
+	 * NTLMv2 response of a domain user (NETLOGON pass-through).
+	 */
 	for (type =3D NTLMSSP_AV_NB_COMPUTER_NAME;
 	     type <=3D NTLMSSP_AV_DNS_DOMAIN_NAME; type++) {
+		bool is_domain =3D type =3D=3D NTLMSSP_AV_NB_DOMAIN_NAME ||
+				 type =3D=3D NTLMSSP_AV_DNS_DOMAIN_NAME;
+		int av_len =3D is_domain ? dom_len : uni_len;
+
 		tinfo->Type =3D cpu_to_le16(type);
-		tinfo->Length =3D cpu_to_le16(uni_len);
-		memcpy(tinfo->Content, name, uni_len);
-		tinfo =3D (struct target_info *)((char *)tinfo + 4 + uni_len);
-		target_info_len +=3D 4 + uni_len;
+		tinfo->Length =3D cpu_to_le16(av_len);
+		memcpy(tinfo->Content, is_domain ? domain : name, av_len);
+		tinfo =3D (struct target_info *)((char *)tinfo + 4 + av_len);
+		target_info_len +=3D 4 + av_len;
 	}
=20
 	/* Add terminator subblock */
@@ -464,6 +490,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_me=
ssage *chgblob,
 	chgblob->TargetInfoArray.Length =3D cpu_to_le16(target_info_len);
 	chgblob->TargetInfoArray.MaximumLength =3D cpu_to_le16(target_info_len);
 	blob_len +=3D target_info_len;
+	kfree(domain);
 	kfree(name);
 	ksmbd_debug(AUTH, "NTLMSSP SecurityBufferLength %d\n", blob_len);
 	return blob_len;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6b8809f67b..704c694fe7 100644
=2D-- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1822,6 +1822,20 @@ static __le32 deassemble_neg_contexts(struct ksmbd_=
conn *conn,
 	return status;
 }
=20
+/*
+ * ntlmssp_challenge_size() - room for the challenge blob: the netbios na=
me as
+ * target name and the two computer names, the workgroup as the two domai=
n
+ * names (UTF-16, each with its 4-byte AV pair header), the terminator
+ */
+static size_t ntlmssp_challenge_size(void)
+{
+	size_t nb =3D strlen(ksmbd_netbios_name()) * 2;
+	size_t wg =3D strlen(ksmbd_work_group()) * 2;
+
+	return sizeof(struct challenge_message) + nb + 2 * (4 + nb) +
+	       2 * (4 + wg) + 4;
+}
+
 /**
  * smb2_handle_negotiate() - handler for smb2 negotiate command
  * @work:	smb work containing smb request buffer
@@ -2096,6 +2110,10 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 	memset(chgblob, 0, sizeof(struct challenge_message));
=20
 	if (!work->conn->use_spnego) {
+		if ((char *)rsp->Buffer + ntlmssp_challenge_size() >
+		    (char *)work->response_buf + work->response_sz)
+			return -EINVAL;
+
 		sz =3D ksmbd_build_ntlmssp_challenge_blob(chgblob, work->conn);
 		if (sz < 0)
 			return -ENOMEM;
@@ -2104,8 +2122,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 		return 0;
 	}
=20
-	sz =3D sizeof(struct challenge_message);
-	sz +=3D (strlen(ksmbd_netbios_name()) * 2 + 1 + 4) * 6;
+	sz =3D ntlmssp_challenge_size();
=20
 	neg_blob =3D kzalloc(sz, KSMBD_DEFAULT_GFP);
 	if (!neg_blob)
=2D-=20
2.56.0

