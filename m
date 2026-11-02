Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600162;
	b=kPQSYgi8zKk8OJA5b751pYXcQ9la1BSQov5bJcEBFpilCKcsi13kyH7xSFM0VActal3f
	 WvcIO2eX9JIsVjtmZcwQX3RP/nNxPk+QA27BNkVgt7TcCwJS5AU/2w4irO3DR3UewQDlB
	 yaBAFZokFTt1+dZbiPV/wOLMcUJX10zISj0OEpx/gvszm+Zk5nv1uZxfOLKNNwl1VOQTi
	 GUI6xfjYaR5NRyCV4AbfrC6DBtlBzwv+yJ8b2ciMqfAOWZPwT3+Fulm7vsOXmnITFGBCS
	 5j95Ir9T2kQrMAHuLiUXKxjEK+URSRkEKfP06RD7tOM6t08oqLKNo1k5MhyF6NHD0Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600162;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=Aa12U8lqowtEXcBjVgZ153KPUb1ylc4xFCiy3jc52tU=;
	b=WvHwYaX2SYIDrAitROFHvweHt2T4CVqdZJGyXjDnFMDz6/mJI7Mm+4KWT4Q7dkSWiWyB
	 ie+VT0eTcp06zg+IZlv3J7Nnrya17EKJBZ7sA+VaLcdvSaBPohPJb3p8xO28zKWDMfveH
	 drPti0Ck3+kk6eAu99wCyM+Boc4z5sJdr2MqDy/GKz8dsJ4gaQZzn51nGIIf6y+UL57j+
	 eTBdTbhB4yRiFy7s7NX/IOmWzxU5VuXw/QX8Ibf/ajCw+1yNJOrn6AbHFu43i7aMUEwER
	 ewUEePoM8EqR2YqwAprHq1BLZKOWm4AIwqMb35QFIYz5pWw8z2I2108HQKH0NRhT6WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=l+soKsnY;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=blubPZDi;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D175A606A324
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 06:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D175A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=l+soKsnY;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=blubPZDi
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 352167A0196
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 01:16:01 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Mon, 02 Nov 2026 01:16:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1793600160; x=
	1793686560; bh=Aa12U8lqowtEXcBjVgZ153KPUb1ylc4xFCiy3jc52tU=; b=l
	+soKsnYwAYkAVSuVUptUKZMuEY+4qHbQcnz3ZlgBBnoavs8dnxkk5aDItKp52yXc
	xPHD5HIp5Rblg9O4/jQWRAnHPnso8jT4xBV0dhLf+vRqXDx7vbN2utVA3F76Leq6
	pbImbXst13KObHN9HawxTbzFSakCUdY1ugNPMKW8+by9oH2yKtcIZO+S/jFg30Vj
	A7igZkm3q3zxAHLe9TinhATOHJFcHJ0ae4qHGGu4RH9tOKf9sZx5X/AF+dOI6LIe
	jQ6RfZ75L7r3j6+9fqe5cTDnUOK8fnjKJVubv6qa5NSvWGZ4f6vznG2+XHL1mVx7
	SR18DH5fn5rrTHpCYPJgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793600160; x=1793686560; bh=A
	a12U8lqowtEXcBjVgZ153KPUb1ylc4xFCiy3jc52tU=; b=blubPZDiWMZ3ZGMRL
	EvlBlZe26CPNfTY1iQ61CRJxRPGbzN0EwJR0EgaPCK3OcR8YnzZduIvTnJRqokdB
	532zpC8jDdZAXqL6G/kJQEVIseTmQMb4O2G+joUh+Pc73/8OwI/zWdcrDqBrYES5
	OeK4I8O7lhWagpTuAAPzAO6aGcddgV6sB++8XxYjTFD53ps6zy3qvHeOWBIMdKWj
	1XeoOAGxzMXRyD5jSRQq2DVSqzgicdFJHGtkGmBV2nKZkn5QWvqy7+5nvRIqwp/z
	CDuHUwbfeWYeiiS3x9mdD1hVjBm9ILNw40QI83EoUr95MTksOvC1ultaHngI19jl
	fGiUQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793600160; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:BoV0E+g3rgbAxfH/HdzuAe/f3TVVMEzs6CGnANpVLNlehJr
	APArCTIfTqTEx1Zdlv3kZTRFtkL5gzczL++8vAHzUtLnoL5HMHkZ5WHYU3oMQcIj
	eLKN3RveVbXBCLIULWThyh2STQN7H+ByIQBEJQ5gEys1AhuJ6YNdcXDjJf25BSHS
	3eqZdgck/GIYDr1HsL02/8viKLsnc9n6WS11t3aqZjm56aCZFMcwV0TBs9WV/vku
	Xd1qNvln+D7kYJG1TYZ8jOh1E+4/hIbfly+Sesi2QXPx0Kjo4f3tB5FWVxj7Nl8P
	SoLbhjYEuRsiURpMz6JyunA3PPwDo6fTZneeEKw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:HSlNcvgtdmCPsHYCgd1XKvn0vimtPw23B2wXWYY7RPw=:Q6zNsfO1MCog57yNg6sYxuUY+nPIW/8pMj/8aCJCaqc=;
X-ME-Sender: <xms:oCroam4VAkTQoSwcP1ow3VReVMeGo_npMnBQtcM1S_mwTNt4-CzPoQ>
    <xme:oCroasfaV3FbDWEgV3EyBH06zu5m3yX5i-LOawqUNBB5yqKIEkQ2LLQg-ADS0qxjh
    404k-oImoFoQFXb5AxqvkGro_-LWPkFrDsnuWKaJpX8tLLbdw_9LsPX>
X-ME-Received: <xmr:oCroap4pEeYueNCgtH5CmGz8Zw-YLud-OA7Do8NLUi8VEtuYWPLSieXilt4PN99r>
X-ME-Proxy-Cause: dmFkZTFGKk/WNkmd39cyK5kg4BSYFhiJducBg0q1Dxb/yw6McJPeF1k53VrIA8oFQ5r40l
    efUL3sv/8CAXT8lgRt8Iz7IjTiWfVT2ebK2NwBpvdLS8Pjffu/hHGhn+gqv/rBNe83ITNx
    isYSXwB5NsSv+wIZUQnX2Twt2UHiwYUdH9okdl+Tcoof6j+mv1wOcVdaGK1nzN5QxMHC34
    691NClNUMb4l54cR295xvnobYFBPXHIPXvC13rnrhOZuAA3zMtBCYTUL1GH1N1scDmrvCU
    NsduhI/xR7REwD8kOsukMODjx2QIz+iv5MoEUnKw+1TXCUDQretHLbYHKiCh6sRN4WCpWQ
    Zcb53vE3fp1+sCH10+gIzlVsEa5EmB/hUIpWbqbkcvZ32u7MU51Yrj8fVqlc/kSMY6hMWO
    Lb96foJE4FXvI63BDnSb4vaSFdbkpX1Fm3he28DrrwStpZWgA2pWYTC7EQIjYEUNx/gb//
    PaeQZf9/KWUQiI2KmVQBncvY9JMQj+xHdonhrddr8rxslIRy2xgWIiac2wnILWsk4xbFVE
    5UySjqw2PBMNunlrChmKaFI5hBgh8euN2rVQwLtEV84/WpOJmP4gl5Mjf2ukko5dRw72ii
    R0Gm26SwmthyiUVvVqs22T0aTDTsnauHRUo6+98iP+l08K3PY9Cd8Jf4Q1kA
X-ME-Proxy: <xmx:oCroap-tz_JJ1TOG-J6glT60OqU3rCJ7JtUnDII83kt1caC2HDZnhA>
    <xmx:oCroarGeG0WO7VvGU7Ze6j9k9hDtJW9knm5Lh8pXfevHF84OUHwt7g>
    <xmx:oCroauUOhN-8kVK55ptPoGstzyPVQATN66Mk9HcN7yoRwhFW1EDl6w>
    <xmx:oCroan9-eLUysO4DksyN0gSyf33C0NUUOoncTZBRiBI61ji0-VFVlA>
    <xmx:oCroalKWDPdI_3-b1XG3X0p1wRtksRjyhLCxkQ5ZWDjhw6iQQAuXKiLJ>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 01:15:59 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: let the owner read and change the DACL when no ACE names it
Date: Mon,  2 Nov 2026 00:15:36 -0600
Message-ID: <20261102061537.830714-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102061537.830714-1-icb@fastmail.org>
References: <20261102061537.830714-1-icb@fastmail.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb_check_perm_dacl() refuses the owner when neither its DACL lookup nor
the POSIX ACL fallback matches. The owner then cannot read or replace
the DACL over SMB. MS-DTYP 2.5.3.2 grants the owner READ_CONTROL and
WRITE_DAC unless an OWNER RIGHTS ACE applies.

An empty DACL allows the owner's explicit requests for these rights but
refuses MAXIMUM_ALLOWED. smb2_open() uses that check for the maximal
access reply (MS-SMB2 3.3.5.9.5), so even a READ_CONTROL open fails when
it asks for that reply.

Grant the owner's implicit rights on both paths, for explicit requests
and MAXIMUM_ALLOWED, unless an OWNER RIGHTS ACE applies.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Reachable on a share with "vfs objects = acl_xattr", for example after
    the owner replaces a file's DACL with one that grants only another
    user.
    
    The empty-DACL check this patch changes came with de0cffef897c ("ksmbd:
    deny access for an empty DACL instead of granting the request"), merged
    for v7.4, so an older stable tree needs that commit first. The check
    before it refused MAXIMUM_ALLOWED on an empty DACL as well.
    
    Tested on ksmbd-for-next d13da43938d1 with KASAN. Only the owner's
    results change. The owner of a file whose only ACE grants another user
    can now open it for READ_CONTROL or WRITE_DAC, and is still refused
    READ_DATA. On an empty DACL, the owner's MAXIMUM_ALLOWED handle gets
    READ_CONTROL and WRITE_DAC when POSIX permits the open. A READ_CONTROL
    open with a maximal access context also succeeds. Its handle holds
    READ_CONTROL, and its reply reports both rights. Without POSIX read
    permission, MAXIMUM_ALLOWED still fails in smb2_open(). An ACE stored
    after a DACL whose ACE count is zero still grants nothing.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smbacl.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 664f01263611..83974643aa88 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1477,6 +1477,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	int i, found = 0;
 	unsigned int access_bits = 0, denied = 0;
 	struct smb_ace *others_ace = NULL;
+	bool or_ace = false;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
 	unsigned short ace_size;
@@ -1509,6 +1510,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	is_owner = uid == from_kuid(&init_user_ns, vfsuid_into_kuid(vfsuid));
 
 	if (!pdacl->num_aces) {
+		unsigned int allowed = 0;
+
 		/*
 		 * An empty (present, zero-ACE) DACL grants no access to
 		 * anyone except the object owner's implicit READ_CONTROL
@@ -1517,9 +1520,14 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		 * not let trailing bytes after a zero-ACE DACL become an
 		 * implicit grant.
 		 */
-		if (!is_owner ||
-		    (*pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)))
+		if (is_owner)
+			allowed = READ_CONTROL | WRITE_DAC;
+		if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+			requested |= allowed;
+		if (!allowed || requested & ~allowed)
 			rc = -EACCES;
+		else
+			*pdaccess = cpu_to_le32(requested);
 		goto err_out;
 	}
 
@@ -1604,6 +1612,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			found = 1;
 			break;
 		}
+		if (!compare_sids(&sid_owner_rights, &ace->sid) &&
+		    !(ace->flags & INHERIT_ONLY_ACE))
+			or_ace = true;
 		if (!compare_sids(&sid_everyone, &ace->sid) ||
 		    !compare_sids(&sid_authusers, &ace->sid))
 			others_ace = ace;
@@ -1645,8 +1656,23 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 		if (others_ace) {
 			ace = others_ace;
 		} else {
-			ksmbd_debug(SMB, "Can't find corresponding sid\n");
-			rc = -EACCES;
+			unsigned int allowed = 0;
+
+			/*
+			 * No ACE names the owner, who may still read and
+			 * change the DACL unless OWNER RIGHTS applies
+			 * (MS-DTYP 2.5.3.2).
+			 */
+			if (is_owner && !or_ace)
+				allowed = READ_CONTROL | WRITE_DAC;
+			if (*pdaccess & FILE_MAXIMAL_ACCESS_LE)
+				requested |= allowed;
+			if (!allowed || requested & ~allowed) {
+				ksmbd_debug(SMB, "Can't find corresponding sid\n");
+				rc = -EACCES;
+				goto err_out;
+			}
+			*pdaccess = cpu_to_le32(requested);
 			goto err_out;
 		}
 	}
-- 
2.47.3

