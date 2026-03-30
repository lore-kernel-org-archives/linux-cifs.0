Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1092239EF1A
	for <linux-cifs@vger.kernel.org>; Mon, 30 Mar 2026 21:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905032; cv=none; b=DOUDMQtzaKMNCTvQnDnCFC9jh6g+jaMnyWTtXX1ls7hRk1TdrZAYHKhnn44lpaEfeiRGkVVp4gaWjTShXYdfbNRll7D3d+2dC+Ttpj7SJ9iS2GnZSvWuYzHaeg3oJlKVof3KuN1Ice4/5Ytz4pTU1GF/HhfjOjYCS9Y7pkjryxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905032; c=relaxed/simple;
	bh=GU5VXvQJFY0/uC9eC9G7mqYpq09UbP5fOBc8AiA1Qcg=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=J710woWVnS6gSJUpYderqEr7TU5iaOaZ2qWOC04iMSuE0F+gPQa2SNA+HQJ/8wboxWESoKKqXIBcvi5P0jsFU0pG1wXuCRvMC4D3jm2Nim3sgxKA9kXpan14qg3KhT/19Ty/u5eVhJIH7wRIEKT5xKtgYtWoJZtEPM+8SjdyVkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=YidgZ1o9; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="YidgZ1o9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1774905018; x=1775164218;
	bh=X3Q+LYlTt9jH2ObR7NqgyduNMxki+7TD4MsYI73loVU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=YidgZ1o9dHwg6MBJ4a17bJ7K+eaU2hEBwm7yAE6SzkbM9eFNsM8CLmjb9xtHjdMSN
	 CRvqFeXWHJlnkBPHVL202bChwChyWOwlP8l1xsCD0UdFzA8jo8qC6y4U8PaLjsT+9d
	 orLIHO+NSO8/jFe/+Q8d7qwepgqcJ/Bpw13qS8zmdpJArX7H+Ss5+WuzI5kJhL7Rlq
	 NSOajPV1t5IUZsP70wyH4QfaN8uIfuQWPb4PhuA05GW8Mc/it4w9cqmEVpVZMk3i+W
	 Y76Iv6f7MptgabKXKF10zT55kL/7hPSIfjTxYhNrTK6ZqwlHW1SaPmDZzPR1Cwj+oW
	 FU6A7diiKMgrA==
Date: Mon, 30 Mar 2026 21:10:14 +0000
To: "sfrench@samba.org" <sfrench@samba.org>
From: FredTheDude <FredTheDude@proton.me>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: [PATCH] fs/smb/client: fix out-of-bounds read in  cifs_sanitize_prepath
Message-ID: <f6jyHqZ0Ycp1KP50Nf0K6QULaw7WbojZIPK4NrYYw6zNoj93MvpecYMT0xE5mjChSgdLhieKk9rpjUDjWtY73UAjwFGS85VxlkO4yJuEInE=@proton.me>
Feedback-ID: 151443565:user:proton
X-Pm-Message-ID: c6e4555d1b2a40993c960e2445828e088e2f08c4
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


When cifs_sanitize_prepath is called with an empty string or a string
containing only delimiters (e.g., "/"), the current logic attempts to
check *(cursor2 - 1) before cursor2 has advanced. This results in an
out-of-bounds read.

This patch adds an early exit check after stripping prepended
delimiters. If no path content remains, the function returns NULL.

The bug was identified via manual audit and verified using a
standalone test case compiled with AddressSanitizer, which
triggered a SEGV on affected inputs.

Signed-off-by: Fredric Cover <FredTheDude@proton.me>

---

If I made any stupid mistakes, let me know.
I am just a high-school freshman, and I have a lot to learn, especially in =
C.
Thanks for taking your time to look at my patch.
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 03c112f4d..3f0faae99 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -588,6 +588,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
        while (IS_DELIM(*cursor1))
                cursor1++;

+       /* exit in case of only delimiters */
+       if (!*cursor1)
+               return NULL;
+
        /* copy the first letter */
        *cursor2 =3D *cursor1;

--
2.43.0
