Received: from o12.p25.mailjet.com (o12.p25.mailjet.com [185.189.236.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1810337F743
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 02:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.189.236.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777429559; cv=none; b=Y11GiSRhdidtHJIpy5xsbwD/f4Y0F2A6hyE9SKF1djkw+d9ETCGZ+zmsCjFHGv3DKs3gezHhkSuxZpsWTjIYd/gWXuxM0X2XSYldg84S1p9D4UxiZKCp2WXfqJxBIVK3RAHcKInV7FyzM0wsQXg90asdSjDznKzWtEFGTz56l3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777429559; c=relaxed/simple;
	bh=MnToQbK/FkNAhxh5aQ4vTyxi+EldDESUytf58yodrW8=;
	h=Message-Id:MIME-Version:From:To:Subject:Date:Cc; b=NaMjFGyFWUE9Tg+eEA/eho7fjMcWVpNrz3Ylhi5rxLK8RKnDWgDJFIyZWhp5x8V2HmISES6rhwjGTUekfJMmFrdNEOCKnBZ0jY9ZkJ+mUhoLYwEbz0VkDQyQLPQXYKUio5uJdGYrtvX21DdUmC9fIkrCc3oyZM9aTjFWg7y3pRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yikuo.dev; spf=pass smtp.mailfrom=a3119462.bnc3.mailjet.com; dkim=pass (2048-bit key) header.d=yikuo.dev header.i=yi@yikuo.dev header.b=jefRvSJ4; arc=none smtp.client-ip=185.189.236.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yikuo.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=a3119462.bnc3.mailjet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yikuo.dev header.i=yi@yikuo.dev header.b="jefRvSJ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; q=dns/txt;
  d=yikuo.dev; i=yi@yikuo.dev; s=mailjet; t=1777429556; x=1777436756;
  h=Message-Id: MIME-Version: From: To: Subject: Date:
   List-Unsubscribe: List-Unsubscribe-Post: Cc: Feedback-Id:
   X-CSA-Complaints: X-MJ-Mid: X-MJ-SMTPGUID:
   X-REPORT-ABUSE-TO: Content-Transfer-Encoding: To: From:
   Sender: Subject: Date;
  bh=jgRWHS5LTnADW7gurrSjzDLoK6uUiNKmh4ecbUTbkmg=;
  b=jefRvSJ4C2ISFVIHgqmY8OOjmBYULnk3qkugb3lUbuglcWpcCn1vCI3+9
 W9RJnv1v/1l8RkEaRIC9YILuml/7b9JZs9HPmXnxoI/0UnUhPelvikqSOGJg
 kN3jEUpvGpJI4HnxK8V+j7v28yx8l+GDZ9xkTITAzp1cIo7Ph/ziJXmzJzae
 qaX7ZvnI5uQxF+5xfzZPHvLtO3aGcdJCzX0iD186cEkZxvd8DaisSAyi2Xme
 DrFGAvNdKxA6rqzSYdbN03YdpDdfbNFhsgzZScchSvYRD0iAcKnpxcj6loBn
 /XJW+lD63LCexEpCLaSHJKLbyBVNZlwMTjHpz0UnR9vJw==
Message-Id: <4bf423bb.AU4AAJbgzlAAAAAAAAAABAMtJJMAAYKKIjQAAAAAAC-ZZgBp8Ww0@mailjet.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yi Kuo <yi@yikuo.dev>
To: smfrench@gmail.com, linkinjeon@kernel.org
Subject: [PATCH] smb: smbdirect: fix MR registration for coalesced SG lists
Date: Wed, 29 Apr 2026 10:25:25 +0800
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Cc: metze@samba.org, tom@talpey.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Yi Kuo
	<yi@yikuo.dev>
Feedback-Id: 42.3119462.2858555:MJ
X-CSA-Complaints: csa-complaints@eco.de
X-MJ-Mid:
	AU4AAJbgzlAAAAAAAAAABAMtJJMAAYKKIjQAAAAAAC-ZZgBp8Ww0yCNLysOaRJes78hqlhuD6gArnjs
X-MJ-SMTPGUID: a321fef6-42c1-4399-acf4-f1adff38652b
X-REPORT-ABUSE-TO: Message sent by Mailjet please report to
	abuse@mailjet.com with a copy of the message
Content-Transfer-Encoding: quoted-printable

ib_dma_map_sg() modifies the provided scatterlist and returns the
number of mapped entries, which can be fewer than the requested
mr->sgt.nents if the DMA controller coalesces contiguous memory
segments. Passing the original, uncoalesced count to ib_map_mr_sg()
causes memory registration failures if coalescing actually occurs.

Capture the actual mapped count returned by ib_dma_map_sg() and pass it
to ib_map_mr_sg() to ensure correct MR registration.

Also update the ib_dma_map_sg() error logging to drop the error
pointer formatting, since the return value is an integer count
rather than an error code.

Signed-off-by: Yi Kuo <yi@yikuo.dev>
---
 fs/smb/smbdirect/mr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 5228e699cd5d..058dc24bf544 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -269,7 +269,7 @@ smbdirect_connection_register_mr_io(struct smbdirect_so=
cket *sc,
 {
 	const struct smbdirect_socket_parameters *sp =3D &sc->parameters;
 	struct smbdirect_mr_io *mr;
-	int ret, num_pages;
+	int ret, num_pages, num_mapped;
 	struct ib_reg_wr *reg_wr;
=20
 	num_pages =3D iov_iter_npages(iter, sp->max_frmr_depth + 1);
@@ -300,19 +300,19 @@ smbdirect_connection_register_mr_io(struct smbdirect_=
socket *sc,
 		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
 	smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
=20
-	ret =3D ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-	if (!ret) {
+	num_mapped =3D ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->=
dir);
+	if (!num_mapped) {
 		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-			"ib_dma_map_sg num_pages=3D%u dir=3D%x ret=3D%d (%1pe)\n",
-			num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
+			"ib_dma_map_sg num_pages=3D%u dir=3D%x num_mapped=3D%d\n",
+			num_pages, mr->dir, num_mapped);
 		goto dma_map_error;
 	}
=20
-	ret =3D ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE)=
;
-	if (ret !=3D mr->sgt.nents) {
+	ret =3D ib_map_mr_sg(mr->mr, mr->sgt.sgl, num_mapped, NULL, PAGE_SIZE);
+	if (ret !=3D num_mapped) {
 		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-			"ib_map_mr_sg failed ret =3D %d nents =3D %u\n",
-			ret, mr->sgt.nents);
+			"ib_map_mr_sg failed ret =3D %d num_mapped =3D %u\n",
+			ret, num_mapped);
 		goto map_mr_error;
 	}
=20
--=20
2.54.0

=
