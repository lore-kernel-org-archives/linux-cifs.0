Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BC44ABBD4
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 10:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404996; cv=pass; b=FmGEJGKjW6JO0xZBikdp8jAs33Qx4UwBGbB8s4ATTVkGtd+6Ug1S26E5OltmOusWcmp3lNd38MxZK4thaemNtGNokt2rWUP4I0MEiixm4k/Gp2GBlj3WXgBh2p3+KWXwokBWoHyaqi7x+6obA13AIrt7hZAF584K4bAK2W6HXAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404996; c=relaxed/simple;
	bh=Bfo6yA4tdFTz0CojFmxTqPYvarBD8CeXSaQxDqBheJU=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=ZzV0lmHPEQ2IkdOqS0U4py/MsDJRVL5Q8YbzGax3gkIiqpXRrPdjD9krgsfqsFkIXTK/sWuwaKfnudC6pF9Iupr7cjYFDJupVH1VPJU+i3G4U+Csf1w3kcONnUQB11+Z01Jp1FN7XmOEYQoLFQHSfyy+Ti2w53DispYYsMQlHQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lNEc+mED; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lNEc+mED"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5337c7b9937so404771cf.0
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 03:16:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792404994; cv=none;
        d=google.com; s=arc-20260327;
        b=Udg1n8Bc/WuDTzAlIsoEiN9y68SyX1MtZu/Bo4jvBWmsFbVkOq8LLiTeNPo580ROAp
         4ICf6dl1IHqRtI4d+XznxgdqR61Eb1htdRvv2axB0+5oQIZ6Q6YQwlVFW0ULVsMOsUEs
         SMBHjfJjVYn4iWm0aPwEft5fGosy0qRbs/4DRak87ducOz0hUdBMD2YzruvnjHtmeafo
         6aU1XANQAjNoVPokoW/ETMgKwy0GiyNcXtuMtSTX/eqy8uYOmgt//FCdslADS5QAIHy7
         xZqtoHzuvAlsCul/tNAUZlhWkrosOEPVcqvOJHHI9PL5KdOFoSQiDp2a17pYUlbG0nTq
         NE7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=hDoj6XweuEIzgZODOcQI/MCL15mW9RVkIWVbM7dr42g=;
        fh=t+1v03sPehsmpmWnOGMeVD8iSyn8gxsLZc+9SIasI9c=;
        b=e6P2RHTN7U5HObedqY6Qalpb3S8e/ZsxyxVUgPO2AyZQlOI2mQ7Q7FPbdL8b32nzVG
         WPYe/G5xLkBBqgWJyda+TWjRgw81SAS5H5HYQyDmsyePcF+2omhkxIqEJBq6c/+1mhKx
         OpWb10akgSV2K4N2WcjadnGXmW65EUgI1X7obYsNvrMdx+QqZzJIhzWo6OudYBUO3zMP
         9wTuJtCJfiQBEOJlS1uLnxflrH5+NNq5cYRvl3s5rALMGjoLwucm9zNj+XMeQwx8fEeg
         ZfAAPWa4MqcVDNdMhg+SNs0AoNAbp6ZwkPptJohbhj1JTTEswKwX0OmY23G9BQCPF0h3
         6jgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792404994; x=1793009794; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hDoj6XweuEIzgZODOcQI/MCL15mW9RVkIWVbM7dr42g=;
        b=lNEc+mEDEerVCMdaCZqieW8rwKE5+Oiybjj/+dFfMHU3kFXk3GD+rrFO761l4jrMph
         bUkQkp88O0Txb81sROK6/syImj6NU/fiWSQ5fSrZL84uLgBJq2PP50hRzrHdI4L54rL4
         evdHeLyrR9iuaN14lLRC1koM6oaLbftTHP3yr68WiPmmqFrU3+TuhZDUaU8MmaUCLI5o
         KmjrWA7Jyt9KM4I5rEvK5zmcsYF9wNNVmA8iw5AkRl6QuZ+efWHrd5llRyKOlXwhY+8c
         tJKHcuN5L4kbq3udobGkWH2T0R3Neoa5EpGrX/BlKSaVpr7Y6N/UQK4bmvu034v6lRjk
         b4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792404994; x=1793009794;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hDoj6XweuEIzgZODOcQI/MCL15mW9RVkIWVbM7dr42g=;
        b=ikQSdWoHEtL0D9oj4yu2SQfvFvXY7TVf1STW+Uve4KLfVVImfOfsYINbRkC79XRQtE
         KLM2zOkaTDLa5YTzKs9aHkRefuyIzqJ7BGIY/cv1yH3gtoL1/AVTUYQVcJM1sprb3qPK
         knRA4Gt/EtxrKUynZ5/kp7gQinZmmaVc7djfUTwauSdnK5BmE3fMuo+/OcvqnsARCMsz
         Lhuv/e/tDSHCSv9TAsYVBoGo8J3wyVe28tRtj/ehXRLh7+fkxOGbOiIQkBHeMEPruTSK
         vssAV+WwNATEp5NUXtz5uxtiPhz2yDKPJWkxJR3Jb05nadKGBzk6e2p8SP2A7avL33xg
         ExQQ==
X-Gm-Message-State: AFq9FYIfz4uOrT5+OF6qThXDGmQYlwKcSxL4gWh2iByPIZ4+4rjS4ArM
	wlGua2g40H7mcuH045bIkGiCEx2v/Ij5JFwJMMvc0jKg8bfUTOUJrjd1AgrMpy24DPAw5ioEcCz
	wJR86Wg/okZf6kGD9NTgFV/b923SLjxFzzDVSnHNDNxVV/g1mrGBNHaC3VWw=
X-Gm-Gg: AYBFou17hEEzyckoTe1P7n8TU05eY1QA8UyM+S4jf81Bme6lf9Y6LPRyWFZ4tD4GW/B
	w9xz/BDpr4bGHNaQ0Qu44cbVGwjGOWiMaougErLFiK3FSDMnpkuwy+hCDFjxVK9zZFLHxvYj6H3
	xvEpROnFR2mDm6vTeWfK7KxEML4aOxzSbodXmgaYlzmXA8cwBQc4fGNPrseggXJUO2eMG8fChqH
	ETQdHwJMm37kLIxhHp3Lfq2Ox9wSAEHUxbvbpArmlmlcu7AspBM6lNcUC8sDY8JQu0q1SyNvaQT
	BFhUto1ThsHwXFvuyiA2oy+/vr/rJjxy+1DJV9P4FDTYPhcAwgtqrWOBmdOJqfVONTyIX4a6JWA
	DphfHgj1BGHfCDT9dlfjECYzAFzSL3WKa0EXL5jppCXyjkTW4+qauS/CXzuOUe7yJnBW3bJo0Nq
	armTISaYAh2WxNC4yYZV2Nx6Iw6YAe4kuOAazlkw5AYzF4i6WaM5am+epSdc0Exeg=
X-Received: by 2002:a05:622a:120f:b0:535:84ef:2e26 with SMTP id
 d75a77b69052e-53645fd0692mr15498011cf.7.1792404992732; Mon, 19 Oct 2026
 03:16:32 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 03:16:30 -0700
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Oct 2026 03:16:30 -0700
From: Dominik Maier <dmnk@google.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 19 Oct 2026 03:16:30 -0700
X-Gm-Features: AclHuK_bT9nyHjcGezSGj4_7-dlTSQOXROJaI16d96Q4cQAKv2Ul3Rg_A9jpyq8
Message-ID: <CAE7N4Sq5L=Y2iKHYXsB4cogCA7-J2HoHy8jrnBNAq1cLZZ2E2Q@mail.gmail.com>
Subject: [BUG] smb: client: slab-out-of-bounds write in id_mode_to_cifs_acl()
 chmod branch
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, dmnk+artist@google.com
Content-Type: text/plain; charset="UTF-8"

In Linux 7.3.0 (commit c03c1a14507d), the chmod branch of
id_mode_to_cifs_acl() in fs/smb/client/cifsacl.c (line 1827) can
under-allocate the target security descriptor buffer pnntsd, leading to
a slab-out-of-bounds write in copy_sec_desc().

Commit 0ee150794c75 ("smb: client: fix heap overflow in DACL owner/group
rewrite") fixed the chown branch of id_mode_to_cifs_acl() by reserving
sizeof(struct smb_ntsd) + 2 * sizeof(struct smb_sid) when computing
nsecdesclen. However, the chmod branch immediately above it also invokes
build_sec_desc() -> copy_sec_desc(), which unconditionally writes both
the Owner SID and Group SID at pnntsd + sidsoffset and
pnntsd + sidsoffset + sizeof(struct smb_sid) (2 * 68 = 136 bytes total).

When a file on an SMB2/SMB3 share mounted with -o cifsacl,
-o modefromsid, or posix (with CONFIG_CIFS=y) has a security descriptor
with compact or overlapping Owner/Group SIDs, calling chmod()
under-allocates pnntsd and writes up to 80 bytes past the end of
kmalloc-1024 on -o cifsacl, 124 bytes on -o modefromsid, and 64 bytes
past kmalloc-128 on posix.

We reproduced this in QEMU with a local loopback SMB2 server that
returns a 644-byte security descriptor containing compact Owner/Group
SIDs and a client that mounts //127.0.0.1/share with -o cifsacl and
calls chmod(testfile, 0127), causing id_mode_to_cifs_acl() to allocate
1024 bytes (kmalloc-1024) and write 1104 bytes (+80 bytes out-of-bounds).
The reproducer is available upon request.

Below is a proposed fix (also tested in QEMU) that reserves
sizeof(struct smb_acl) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_ntsd) on the posix path) in the chmod branch.

Fixes: 0ee150794c75 ("smb: client: fix heap overflow in DACL
owner/group rewrite")
Assisted-by: ARTIST LLM
---
 fs/smb/client/cifsacl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 0cc5b0cd2d5c..8b780a92d91f 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1826,12 +1826,15 @@ id_mode_to_cifs_acl(struct inode *inode, const
char *path, __u64 *pnmode,

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
