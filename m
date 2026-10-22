Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792711279;
	b=G1QxdPmaSEMc6bVaBR/AZp9s4uzYXwT+5fCX4tZE2ECRCR4uYe8nlupvAjWC6HE2nw4k
	 q6x4koK2pwqY1IJhACerh2PZ4Y7UUJ1rMt0cLLSD3PH/1ZeMffiO9109PYvo0U3/Up7Hm
	 U9vfyC4q2QJWh1Ty86WcQ4rnTCkvNQz1KTieUmL7kwS0jaLtHg9vlR27P7UsW9jRcWfza
	 JJpopYgZWgS1p7ESEmWDPeVNixLQeoM8Rdq8p4Oc4l5RZTQka5NeZI53pgx1dp9XOw6qS
	 NvWZ5PYEegcXxfQ76KXMiwePWbLAbKYPxL9oJ54QY+D1KCai/7DXStr5ib2KKTBeXng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792711279;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=SHJxDgIYc+qbivFM8ERTQHwZCkmgqlj7B33EGnkLD6g=;
	b=1P/SacoBQu98nMjUwzHWEkSnbrU7+21SXydsNmLdRD3tA3i6NrqVcC+rtzOcKF2tZtKY
	 tP6RaOISnQxpaXsbFBOuVjOauidEkTNlcO92rGALE/qe0GPbMfLGdSB30Nr+Os9LDxECb
	 oS23hwf4o3YdDENI/sBgg+4R15O7dta7aV9l7/ymhAoGQjJXD0/+MPBbr6bmRWx6TLlz2
	 YHcg9FF5xU0zxLH0DtEOgC668A5AF/YGgkbQFeZj9XOV8GOQdkTvS6jYffru1x/FtwdGB
	 6BBaAhw8HEsOEt1IANI9hQzPAn5W1Xra1c8CdQXYIEZWTrUUoUadqwFLhTKO8koJmpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dmnk.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=VP2IUJqY;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56537606A31F
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 23:21:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56537606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmnk.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=VP2IUJqY
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1895ffc83so1969665e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 16:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792711278; x=1793316078; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SHJxDgIYc+qbivFM8ERTQHwZCkmgqlj7B33EGnkLD6g=;
        b=VP2IUJqYo7gaXQQUmiyDP/NQtkbY1hPxB+VE7fXQ+31wIuR6P8z3az2jHKtU0dQGOX
         s6uQWo6qs1WbNliTPxnkxzV7GhA14Jnk5NY5aQdSt3qq6+UqwgVLwL2hLeGDg34l+Yre
         OiXBG1HMwSPs4KTBuzyLwpDUCR5ln6VDyn/AibgJ/Ob8Ic3bhG841sskOg5mlqTa3eEm
         h5k286NdioUDvnHAL/vxVQJqEMYt0C/YZlC1k8ApXzC/kHBehzbT6fhFer4dIJz3Hx9G
         l8yT5xT253Q2/3c9IYOdS2USezmGA+9uRNEnQfhX4juMiVqxgd98DLcuIB/vHVW9RgnN
         rSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792711278; x=1793316078;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SHJxDgIYc+qbivFM8ERTQHwZCkmgqlj7B33EGnkLD6g=;
        b=ZxE4NSD1BQYFNxmIfoiOgViUbRmmocZ0iHL9dYLJSMH0DQqjY19inwdY/kygbdSfaT
         8pfNVSrg+Zw0NIWkEKomNFtxa///Y/IriZv0qg/7AQ4J7xBsOMJ/iTpJvfSOJskcKYnA
         GcVdN2UoB96I/pYvvfj+abuyOEnC9Qnn9BXcmBjNb0/H7ExFkblqTbftPOSfMzv4mywc
         lDyf3wzQ2Td/78Q28QKDNuzajxCqNx+QtMSQcThkiPB1ovXYSMWBneOMB+JRIBuBX5Am
         cY+QMgWQ+Eh/KaEuvdQAAlLWb0YZUpdgb3LNjjivhyrHKY9iYTc4qJz/AwPh375EwIgi
         mV0w==
X-Gm-Message-State: AFq9FYJpGPbX9tws/KhKDkwT89o9DB1EvpZy2NS/Yx9Eu2Z4KSoh+SuA
	9a1WLSlTVWjQ+BqAbK7CkvoOjKb0y7ZSKE2T0IfqMp5hg3UrkPRWnIYaw37fth/kdSQr6ukCaA=
	=
X-Received: from wmcn25.prod.google.com ([2002:a05:600c:c0d9:b0:4a1:8bbb:59bd])
 (user=dmnk job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3514:b0:49d:1fa8:b266
 with SMTP id 5b1f17b1804b1-4a211ed7602mr6960555e9.26.1792711277667; Thu, 22
 Oct 2026 16:21:17 -0700 (PDT)
Date: Fri, 23 Oct 2026 01:21:16 +0200
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022232116.2536320-1-dmnk@google.com>
Subject: [PATCH] smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()
From: Dominik Maier <dmnk@google.com>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, dmnk+artist@google.com, 
	Dominik Maier <dmnk@google.com>
Content-Type: text/plain; charset="UTF-8"

In id_mode_to_cifs_acl(), while the chown branch reserves
sizeof(struct smb_ntsd) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_acl) and the worst-case ACE space after
commit 0ee150794c75 ("smb: client: fix heap overflow in DACL owner/group
rewrite")), the chmod branch only adds 2 * sizeof(struct smb_ace) or
5 * sizeof(struct smb_ace) to secdesclen (or 1 * sizeof(struct smb_ace)
on posix).

However, the chmod branch also invokes build_sec_desc() ->
copy_sec_desc(), which unconditionally writes the Owner SID at
pnntsd + sidsoffset and the Group SID at
pnntsd + sidsoffset + sizeof(struct smb_sid) (2 * 68 = 136 bytes total),
and set_chmod_dacl() always writes a struct smb_acl header (8 bytes)
even when the source descriptor has dacloffset == 0. When a security
descriptor has compact or overlapping Owner/Group SIDs (or
dacloffset == 0), calling chmod() under-allocates pnntsd and writes past
the end of the slab buffer.

Reserve sizeof(struct smb_acl) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_ntsd) on the posix path) in the chmod branch of
id_mode_to_cifs_acl().

Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
---
 fs/smb/client/cifsacl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index d1a92bb4d9a5..e24d9582f262 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1826,12 +1826,15 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 
 	/* Potentially, five new ACEs can be added to the ACL for U,G,O mapping */
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
+		nsecdesclen = sizeof(struct smb_acl) +
+			      (sizeof(struct smb_sid) * 2);
 		if (posix)
-			nsecdesclen = 1 * sizeof(struct smb_ace);
+			nsecdesclen += sizeof(struct smb_ntsd) +
+				       sizeof(struct smb_ace);
 		else if (mode_from_sid)
-			nsecdesclen = secdesclen + (2 * sizeof(struct smb_ace));
+			nsecdesclen += secdesclen + (2 * sizeof(struct smb_ace));
 		else /* cifsacl */
-			nsecdesclen = secdesclen + (5 * sizeof(struct smb_ace));
+			nsecdesclen += secdesclen + (5 * sizeof(struct smb_ace));
 	} else { /* chown */
 		/* When ownership changes, changes new owner sid length could be different */
 		nsecdesclen = sizeof(struct smb_ntsd) + (sizeof(struct smb_sid) * 2);
-- 
2.56.0.257.gf7497c7d27-goog

